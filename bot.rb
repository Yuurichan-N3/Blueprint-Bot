require 'httparty'
require 'faker'
require 'colorize'

puts "╔══════════════════════════════════════════════╗".cyan
puts "║     🌟 WAITLIST BOT - Referral Automation    ║".cyan
puts "║ Automate your waitlist referral submissions! ║".cyan
puts "║  Developed by: https://t.me/sentineldiscus   ║".cyan
puts "╚══════════════════════════════════════════════╝".cyan

url = "https://api.getwaitlist.com/api/v1/waiter"
headers = {
  "accept" => "application/json",
  "content-type" => "application/json",
  "sec-ch-ua" => '"Chromium";v="136", "Microsoft Edge";v="136", "Not.A/Brand";v="99"',
  "sec-ch-ua-mobile" => "?0",
  "sec-ch-ua-platform" => '"Windows"',
  "user-agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0",
  "referer" => "https://getwaitlist.com/",
  "origin" => "https://getwaitlist.com"
}

def generate_random_email
  "#{Faker::Name.first_name.downcase}#{rand(100..999)}@gmail.com"
end

print "リファラルコードを入力してください: "
ref_code = gets.chomp
print "リクエストの送信回数を入力してください: "
num_requests = gets.chomp.to_i

success_count = 0
num_requests.times do |i|
  payload = {
    "waitlist_id" => 28188,
    "referral_link" => "https://getwaitlist.com/waitlist/28188?ref_id=#{ref_code}",
    "heartbeat_uuid" => "",
    "widget_type" => "WIDGET_1",
    "email" => generate_random_email,
    "answers" => [
      {
        "question_value" => "What chains or ecosystems do you use regularly? ",
        "answer_value" => "EVM (Mainnet; Base; Arbitrum; Optimism; Polygon)"
      }
    ]
  }

  begin
    response = HTTParty.post(url, body: payload.to_json, headers: headers)
    
    if response.code == 200
      puts "リクエスト #{i+1}/#{num_requests} 成功！ メール: #{payload['email']}".green
      success_count += 1
    else
      puts "リクエスト #{i+1}/#{num_requests} 失敗！ ステータスコード: #{response.code}".yellow
      puts "レスポンス: #{response.body}".yellow
    end
    
    sleep 1
    
  rescue StandardError => e
    puts "リクエスト #{i+1}/#{num_requests} エラー: #{e}".red
  end
end

puts "\n完了！ 成功した回数: #{success_count}/#{num_requests}".cyan
