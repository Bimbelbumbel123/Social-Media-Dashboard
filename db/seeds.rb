Platform.destroy_all
Account.destroy_all
Stat.destroy_all
User.destroy_all

youtube = Platform.create!(platform_name: 'YouTube', icon_url: 'https://upload.wikimedia.org/wikipedia/commons/b/b8/YouTube_Logo_2017.svg')
instagram = Platform.create!(platform_name: 'Instagram', icon_url: 'https://upload.wikimedia.org/wikipedia/commons/e/e7/Instagram_logo_2016.svg')
tiktok = Platform.create!(platform_name: 'TikTok', icon_url: 'https://upload.wikimedia.org/wikipedia/en/a/a9/TikTok_logo.svg')

acc1 = Account.create!(platform: youtube, username: 'bimbelbumbel123', likes: 120, clicks: 50, comments: 12, dislikes: 2, posts_count: 45)
acc2 = Account.create!(platform: instagram, username: 'bimbelbumbel123', likes: 220, clicks: 90, comments: 25, dislikes: 4, posts_count: 78)
acc3 = Account.create!(platform: tiktok, username: 'bimbelbumbel123', likes: 420, clicks: 150, comments: 45, dislikes: 9, posts_count: 120)

(0..6).each do |i|
  date = i.days.ago.to_date
  Stat.create!(account: acc1, date: date, followers: 1000 + i*2, likes: 10 + i, posts: 1)
  Stat.create!(account: acc2, date: date, followers: 5000 + i*5, likes: 20 + i*2, posts: 2)
  Stat.create!(account: acc3, date: date, followers: 2000 + i*3, likes: 15 + i, posts: 1)
end

User.create!(name: 'Demo User', username: 'demo', email: 'demo@example.com')

puts "Seeded platforms #{Platform.count}, accounts #{Account.count}, stats #{Stat.count}, users #{User.count}"
