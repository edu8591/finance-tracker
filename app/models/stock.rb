class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true

  def self.new_lookup(ticker_symbol)
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key],
      # secret_token: 'Tsk_3a53d49ec39f4f8893e101c98184a2a6',
      endpoint: 'https://sandbox.iexapis.com/v1'
    )
    begin
      new(
        ticker: ticker_symbol.upcase,
        name: client.company(ticker_symbol).company_name,
        last_price: client.price(ticker_symbol)
      )
    rescue => e
      nil
    end
  end

  def self.check_db(ticker)
    find_by(ticker: ticker.upcase)
  end
end
