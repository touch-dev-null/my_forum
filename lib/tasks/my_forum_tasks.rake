namespace :my_forum do
  namespace :import do
    namespace :smf do

      $connection = Mysql2::Client.new Rails.configuration.database_configuration['smf_import']

      desc "Import Boards"
      task boards: :environment do
        MyForum::Category.delete_all
        MyForum::Forum.delete_all

        sql = <<-SQL
          SELECT
            `smf_categories`.`name` AS category_name,
            `smf_boards`.`name` AS board_name,
            `smf_boards`.`description` AS board_description
          FROM smf_boards
          INNER JOIN `smf_categories` ON `smf_boards`.`id_cat` = `smf_categories`.`id_cat`
        SQL

        result = $connection.query sql
        result.each do |row|
          category = MyForum::Category.find_or_create_by(name: row['category_name'])
          category.forums.create(name: row['board_name'], description: row['board_description'])
        end
      end

      desc "Import Users"
      task users: :environment do
        MyForum::User.destroy_all

        sql = "SELECT member_name, date_registered, real_name, email_address, personal_text, birthdate, website_title, website_url, signature, avatar, is_activated FROM smf_members;"
        result = $connection.query sql
        result.each do |row|
          begin
            date_registered = Time.at(row['date_registered'].to_i) rescue nil
            user = MyForum::User.create!(
              login:      row['member_name'],
              email:      row['email_address'],
              real_name:  row['real_name'],
              birthdate:  row['birthdate'],
              signature:  row['signature'],
              avatar:     row['avatar'],
              created_at: date_registered,
              additional_info: {
                personal_text:  row['personal_text'],
                website_title:  row['website_title'],
                website_url:    row['website_url'],
                is_activated:   row['is_activated']
            })
          rescue => e
            print e
          end
        end
      end

      desc "Import Topics and Posts"
      task topics: :environment do
        MyForum::Topic.delete_all
        MyForum::Post.delete_all

        sql = <<-SQL
          SELECT
            `smf_boards`.`name` AS board_name, `smf_messages`.`poster_email`, `smf_messages`.`poster_name`, `smf_messages`.`body`,
            `smf_messages`.`subject`, `smf_messages`.`poster_time`, `smf_messages`.`id_topic`
          FROM `smf_messages`
          INNER JOIN `smf_boards` ON `smf_messages`.`id_board` = `smf_boards`.`id_board`
          ORDER BY `id_msg` ASC, `id_topic` ASC;
        SQL
        result = $connection.query sql
        result.each do |row|
          begin
            user = MyForum::User.find_by_email(row['poster_email']) || MyForum::User.find_by_login(row['poster_name'])
            user = MyForum::User.create!(login: row['poster_name'], email: row['poster_email'], is_deleted: true) unless user

            forum = MyForum::Forum.find_or_create_by(name: row['board_name'])

            # smf does not uses description field, so i use it temponary while import process
            unless topic = MyForum::Topic.where(description: row['id_topic']).first
              topic = forum.topics.create!(name: row['subject'], description: row['id_topic'])
            end

            post_time = Time.at(row['poster_time'].to_i)
            topic.posts.create!(user: user, text: row['body'], forum_id: forum.id, created_at: post_time, updated_at: post_time)
          rescue => e
            print e
          end
        end
        MyForum::Topic.update_all(description: nil)

      end

      desc "Import Private Messages"
      task pms: :environment do
        MyForum::PrivateMessage.delete_all

        sql = <<-SQL
          SELECT
            smf_personal_messages.msgtime, smf_personal_messages.subject, smf_personal_messages.body, smf_personal_messages.from_name,
            smf_pm_recipients.id_member as to_member, smf_members.member_name
          FROM smf_personal_messages
          LEFT JOIN smf_pm_recipients ON smf_personal_messages.id_pm = smf_pm_recipients.id_pm
          LEFT JOIN smf_members ON smf_members.id_member = smf_pm_recipients.id_member
        SQL

        result = $connection.query sql
        result.each do |row|
          sender = MyForum::User.find_by_login(row['from_name'])
          recipient = MyForum::User.find_by_login(row['member_name'])
          next unless sender and recipient

          pm_time = Time.at(row['msgtime'].to_i)

          MyForum::PrivateMessage.create!(
            sender_id: sender.id,
            sender_login: sender.login,
            recipient_id: recipient.id,
            recipient_login: recipient.login,
            sender_deleted: false,
            recipient_deleted: false,
            unread: false,
            subject: row['subject'],
            body: row['body'],
            created_at: pm_time,
            updated_at: pm_time)
        end

      end
    end
  end
end