# frozen_string_literal: true

class PricesController < ApplicationController
  def show
    symbol = params[:symbol].to_s.downcase

    return render_not_found unless SUPPORTED_SYMBOLS.include?(symbol)

    record = PriceLookupService.new(symbol).call

    return render_service_unavailable unless record

    render json: CryptoPriceSerializer.call(record)
  end

  private

  def render_not_found
    render json: { error: "Unsupported cryptocurrency." }, status: :not_found
  end

  def render_service_unavailable
    render json: { error: "Price currently unavailable." }, status: :service_unavailable
  end
end
