# coding: utf-8
# frozen_string_literal: true

require_relative "hiroto_push/version"

module HirotoPush
  class Error < StandardError; end
  # coding: utf-8
  def self.hiroto_push
    # コミットメッセージの入力
    print 'Enter the commit message: '
    commit_message = gets.chomp.strip

    remote_string = IO.popen('git remote -v'){|io| io.read}
    url = remote_string.lines.first.chomp
    pattern = "github\\.com:([^\\/]+)/([^\\.]+)\\.git"
    matches = url.match(pattern)

    username = matches[1]
    repo_name = matches[2]


    # リモートリポジトリのSSH
    remote_repo_url = "git@github.com:#{username}/#{repo_name}.git"

    # 変更のステージング
    system("git add .")

    # コミット
    system("git commit -m '#{commit_message}'")

    # masterからmainに変更
    system('git branch -M main')

    # remoteリポジトリに接続してるかどうかの判定
    existing_remote = system('git remote -v')

    if existing_remote.nil?
      system("git remote add origin #{remote_repo_url}")
      puts "リモートリポジトリを追加しました。"
    else
      puts "リモートリポジトリはすでに存在しています。追加処理はスキップされました。"
    end

    # プッシュ()
    system('git push -u origin main')
  end
end
