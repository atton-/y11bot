# -*- coding: utf-8 -*-

# DMの内容調べたり、DMの内容に対応したtextを返したりするメソッド群。
# unit_test 対象。

require 'date'

def is_enable? str
  # 文字列strが有効かどうか確認する
  # get_time で時間を取得できるか get_footer_head で単語を取得できるか確認
  # 両方取得できたら、今より先のデータか確認する
  if get_time(str).nil? || get_footer_head(str).nil?
    return false
  end
  get_time(str) > Time.now
end

def get_time str
  # 最初の文字は抜かして12文字取得
  # YYYYmmddHHMM のフォーマット
  str = str[1,12]
  # string から Time へ
  begin
    DateTime.strptime(str + "JST","%Y%m%d%H%M%Z").to_time
  rescue 
    nil
  end
end

def get_diff time
  # 時刻差分を取得。
  diff = (time - Time.now).to_i
  day  = (diff / (60 * 60)) / 24
  hour = (diff / (60 * 60)) % 24

  return { "day"=>day , "hour"=>hour }
end

def get_footer_head str
  # 先頭の数字からフッタの先頭を取得する
  str = str[0,1]

  # 0 = 無し
  # 1 = 期限
  # 2 = 試験
  # 3 = 補講
  # default nil

  case str
  when "0"
    ""
  when "1" 
    "期限"
  when "2"
    "試験"
  when "3"
    "補講"
  else 
    nil 
  end
end

def get_footer_foot diff
  # フッタの後半を取得する。時刻の部分。

  day = diff["day"]
  hour = diff["hour"]

  if day >= 30
    "まで30日以上あります"
  elsif day >= 1 && hour == 0
    "までおよそ#{day}日です"
  elsif day == 0 && hour >= 1
    "までおよそ#{hour}時間です"
  elsif day >= 1 && hour >= 1
    "までおよそ#{day}日と#{hour}時間です"
  else
    "まで1時間を切っています"
  end
end

def get_footer str
  # フッタを取得する。
  # nil確認はしないので呼び出し前にis_enable?で要確認
  # strの先頭が0のときだけ空の文字列

  diff = get_diff(get_time str)

  if get_footer_head(str).empty?
    ""
  else
    "\n#{get_footer_head str}#{get_footer_foot diff}"
  end
end

def get_body str
  # str の2行目以降を返す
  str.sub /^.*\n/,""
end
