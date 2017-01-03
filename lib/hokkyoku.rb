require 'hokkyoku/version'
require 'nokogiri'
require 'open-uri'
require 'pry'
require 'thor'

module Hokkyoku
    class Company
        attr_reader :code

        def initialize(code)
            @code = code
        end

        def name
            @name ||= info_page.css('.nh_company .name01').text
        end

        def homepage
            @homepage ||= info_page.css('.maincontents .pdall5 tr td a').attr('href').text
        end

        def now_stock_price
            "現在値 " + finance_page.css('.stock_summary-number').text
        end

        def stock_info
            finance_page.css('.cols-content .def .def-number').text.split(')')
        end

        def start_price
            "始値 " + stock_info[0] + ')'
        end

        def highest_price
            "高値 " + stock_info[1] + ')'
        end

        def lowest_price
            "安値 " + stock_info[2] + ')'
        end

        def info
            [name, homepage, now_stock_price, start_price, highest_price, lowest_price]
        end

        def latest_stock_price
            "現在値 " + finance_page.css('.stock_summary-number').text
        end

        private

        def info_page
            url = "http://www.net-ir.ne.jp/company/#{code}/index.html"
            page(url)
        end

        def finance_page
            url = "http://quote.nomura.co.jp/nomura/cgi-bin/parser.pl?TEMPLATE=nomura_tp_kabu_01&QCODE=#{code}"
            page(url)
        end

        def page(url)
            Nokogiri::HTML.parse(open(url).read)
        end
    end

    class CompanyInfoClient
        class << self
          def call
              new.ask
          end
          end

        attr_accessor :now_company

        def ask
            menu = ask_menu

            if ask_code?(menu)
                self.now_company = Company.new(ask_code)
                puts now_company.info
            elsif ask_sec?(menu)
                ask_sec.times do
                    puts now_company.latest_stock_price

                    execute_each_sec(1) do
                        puts "実行時間:#{Time.now}"
                    end
                end
            elsif finish?(menu)
                puts "---------------\n終了します"
                return
            end

            ask
        end

        private

        def ask_code?(num)
            num == 1
        end

        def ask_sec?(num)
            now_company && num == 2
        end

        def finish?(num)
            !now_company && num == 2 || 3
        end

        def ask_menu
            ask_num <<-EOS
----------------
何をしますか？
1 #{now_company ? "新しく企業を調べ直す" : "企業を調べる"}
#{"2 #{now_company.name.strip}の現在株価を指定した秒数更新し続ける" if now_company}
#{now_company ? 3 : 2} 終了する
---------------
    EOS
        end

        def ask_code
            ask_num "---------------\n企業コードを入力してください"
        end

        def ask_sec
            ask_num "秒数を指定してください"
        end

        def ask_num(message)
            puts message
            gets_num
        end

        def gets_num
            gets.chomp.to_i
        end

        def execute_each_sec(sleep_sec)
            yield
            sleep sleep_sec
        end
    end

    CompanyInfoClient.call
end
