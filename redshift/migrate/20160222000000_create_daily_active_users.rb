class CreateDailyActiveUsers < Redshift::Migration
  def up_sql
    <<-EOH
    CREATE TABLE IF NOT EXISTS daily_active_users(
      id INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,

      date TIMESTAMP,

      uuid VARCHAR(256),
      user_id INTEGER,
      role INTEGER,
      published_rank INTEGER
    );
    EOH
  end

  def down_sql
    <<-EOH
    DROP TABLE IF EXISTS daily_active_users;
    EOH
  end
end

