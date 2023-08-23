class CardsController < ApplicationController

  def index
    @cards = Card.order(created_at: :desc) # 降順に取得
  end

  def new
    @card = Card.new
  end

  def create
    message = params[:card][:message]
    new_image_path = generate_card_image(message)

    @card = current_user.cards.build(card_params) # 現在のユーザーに関連付ける
    @card.card_image = File.open(new_image_path)

    if @card.save
      flash[:notice] = "カードを作成しました"
      redirect_to cards_path
    else
      render :new
    end
  end

    # カードのダウンロード機能
  def download_card
    card = Card.find(params[:id])
    event_name = card.event.event_name # イベント名を取得
    filename = "#{event_name}のカード.png" # ファイル名を作成
    
    send_file card.card_image.path, filename: filename, type: "image/png", disposition: "attachment"
  end
    

  

  private

  INDENTION_COUNT = 12 # 1行あたりの文字数
  ROW_LIMIT = 5        # 最大行数
  
  def generate_card_image(message)
    # 元の画像のパスを指定
    image_path = Rails.root.join('app', 'assets', 'images', 'card1.png')
    message = prepare_text(message) # メッセージを整形
  
    # MiniMagickを使用して画像を開く
    image = MiniMagick::Image.open(image_path)
  
    # 画像に対してオプションを設定
    image.combine_options do |c|
      c.font Rails.root.join('app', 'assets', 'fonts', 'KiwiMaru-Light.ttf').to_s # フォントの指定
      c.gravity 'center' # テキストの位置
      c.pointsize '70'   # フォントサイズ
      c.fill '#e9ad98'  # テキストの色
      c.annotate '0x0+200-150', message # メッセージの追加
    end
  
    # 新しい画像ファイルのパスを指定
    new_image_path = Rails.root.join('tmp', 'new_card_image.png')
  
    # 新しい画像ファイルとして保存
    image.write(new_image_path)
  
    # 新しい画像のパスを返す
    new_image_path
  end
  
  # 背景に収まるように文字を調整
  def prepare_text(message)
    message.scan(/.{1,#{INDENTION_COUNT}}/)[0...ROW_LIMIT].join("\n")
  end

  def card_params
    params.require(:card).permit(:event_id, :card_name, :message)
  end
end


