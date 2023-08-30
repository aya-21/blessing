class CardsController < ApplicationController

  def index
    @cards = Card.order(created_at: :desc) # 降順に取得
  end

  def new
    @card = Card.new
  end

  def create
    # アップロードされた画像が存在するか確認
    unless params[:card][:card_image].present?
      flash[:alert] = "画像をアップロードしてください"
      return render :new
    end
  
    message = params[:card][:message]
    new_image_path = generate_card_image(message)
  
    @card = current_user.cards.build(card_params)
    @card.card_image = File.open(new_image_path)
  
    if @card.save
      flash[:notice] = "カードを作成しました"
      redirect_to cards_path
    else
      flash[:alert] = @card.errors.full_messages.join(", ")
      render :new
    end
  end

  INDENTION_COUNT = 12 # 1行あたりの文字数
  ROW_LIMIT = 7      # 最大行数
  
  def generate_card_image(message)
    message = prepare_text(message)

    # 元の画像のパスを指定
    template_path = Rails.root.join('app', 'assets', 'images', 'card1.png')
    template = MiniMagick::Image.open(template_path)
  
    # アップロードした画像のパスを取得
    uploaded_image_path = params[:card][:card_image].path
    uploaded_image = MiniMagick::Image.open(uploaded_image_path)

    # 画像の幅と高さを取得
    width = uploaded_image.width
    height = uploaded_image.height

    # 1:1のアスペクト比でクロッピングするサイズを計算
    crop_size = [width, height].min

    # 画像を1:1にクロッピング
    uploaded_image.crop "#{crop_size}x#{crop_size}+0+0"
  
    # アップロードした画像のサイズを調整（必要に応じて）
    uploaded_image.resize "600x600"
  
    # テンプレートの画像にアップロードした画像を合成
    template = template.composite(uploaded_image) do |c|
      c.compose "Over"    # OverCompositeOp
      c.geometry "+167+285" # アップロードした画像の位置を指定
    end
  
    # メッセージを画像に追加
    template.combine_options do |c|
      c.font Rails.root.join('app', 'assets', 'fonts', 'KiwiMaru-Light.ttf').to_s
      c.pointsize '50'
      c.fill '#000000'
      c.annotate '0x0+920+620', message
    end
  
    # 新しい画像ファイルのパスを指定（作成日時をファイル名に記載）
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    new_image_path = Rails.root.join('tmp', "card_image_#{timestamp}.png")
  
    # 新しい画像ファイルとして保存
    template.write(new_image_path)
  
    # 新しい画像のパスを返す
    new_image_path
  end

  # 背景に収まるように文字を調整
  def prepare_text(message)
    message.scan(/.{1,#{INDENTION_COUNT}}/)[0...ROW_LIMIT].join("\n")
  end

  # カードのダウンロード機能
  def download_card
    card = Card.find(params[:id])
    event_name = card.event.event_name # イベント名を取得
    filename = "#{event_name}のカード.png" # ファイル名を作成
    
    send_file card.card_image.path, filename: filename, type: "image/png", disposition: "attachment"
  end 

  private

  def card_params
    params.require(:card).permit(:event_id, :card_name, :message, :card_image)
  end

end
