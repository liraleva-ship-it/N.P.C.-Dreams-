=begin
      RGSS3
      
      ★ 天候：舞い上がる光 ★
      
      正確には天候じゃないけど、そこは気にしない。
      
      ● 使い方 ●========================================================
      イベントコマンドのスクリプトで以下のどちらかの命令を実行。
      --------------------------------------------------------------------
      soar_photon
      soar_photon(true)
      --------------------------------------------------------------------
      後者のように引数にtrueを渡した場合、光が伸びながら消えるようになります。
      ====================================================================
      
      ver1.01

      Last Update : 2011/12/25
      12/25 : プリセットの天候使用時にエラーが発生する不具合を修正
      12/17 : RGSS2からの移植
      
      ろかん　　　http://kaisou-ryouiki.sakura.ne.jp/
=end

$rsi ||= {}
$rsi["天候：舞い上がる光"] = true

class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● 天候：舞い上がる光の開始
  #--------------------------------------------------------------------------
  def soar_photon(type = false)
    screen.change_weather(type ? :photon2 : :photon1, 1, 0)
  end
end

class Spriteset_Weather
  WSP_TYPE1 = :photon1
  WSP_TYPE2 = :photon2
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias soar_photon_initialize initialize
  def initialize(viewport = nil)
    soar_photon_initialize(viewport)
    create_photon_bitmap
  end
  #--------------------------------------------------------------------------
  # ● 光子の色 1
  #--------------------------------------------------------------------------
  def photon_color1
    Color.new(200, 255, 255, 120)
  end
  #--------------------------------------------------------------------------
  # ● 光子の色 2
  #--------------------------------------------------------------------------
  def photon_color2
    Color.new(170, 255, 255, 255)
  end
  #--------------------------------------------------------------------------
  # ● 天候［舞い上がる光］のビットマップを作成
  #--------------------------------------------------------------------------
  def create_photon_bitmap
    @photon_bitmap = Bitmap.new(6, 6)
    @photon_bitmap.fill_rect(0, 1, 6, 4, photon_color1)
    @photon_bitmap.fill_rect(1, 0, 4, 6, photon_color1)
    @photon_bitmap.fill_rect(1, 2, 4, 2, photon_color2)
    @photon_bitmap.fill_rect(2, 1, 2, 4, photon_color2)
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  alias soar_photon_dispose dispose
  def dispose
    soar_photon_dispose
    @photon_bitmap.dispose
  end
  #--------------------------------------------------------------------------
  # ● 新しい光子の作成
  #--------------------------------------------------------------------------
  def create_new_photon(sprite)
    sprite.x = rand(640) - 50 + @ox
    sprite.y = rand(480) + 50 + @oy
    sprite.opacity = rand(76) + 180
    sprite.zoom_x = sprite.zoom_y = 1.0
  end
  #--------------------------------------------------------------------------
  # ● 天候タイプの設定
  #--------------------------------------------------------------------------
  alias soar_photon_type= type=
  def type=(type)
    if @type != type
      @sprites.each{|sprite| sprite.zoom_x = sprite.zoom_y = 1.0}
    end
    self.soar_photon_type = type
  end
  #--------------------------------------------------------------------------
  # ● スプライトの更新
  #--------------------------------------------------------------------------
  alias soar_photon_update_sprite update_sprite
  def update_sprite(sprite)
    if @type == :photon1 || @type == :photon2
      case @type
      when :photon1
        update_sprite_photon1(sprite)
      when :photon2
        update_sprite_photon2(sprite)
      end
      sprite.ox = @ox / sprite.zoom_x
      sprite.oy = @oy / sprite.zoom_y
      create_new_photon(sprite) if sprite.opacity < 16
    else
      soar_photon_update_sprite(sprite)
    end
  end
  #--------------------------------------------------------------------------
  # ● スプライトの更新［舞い上がる光］
  #--------------------------------------------------------------------------
  def update_sprite_photon1(sprite)
    sprite.bitmap = @photon_bitmap
    sprite.y -= 1
    sprite.opacity -= 2
  end
  #--------------------------------------------------------------------------
  # ● スプライトの更新［舞い上がる光］（伸びながら消える）
  #--------------------------------------------------------------------------
  def update_sprite_photon2(sprite)
    sprite.bitmap = @photon_bitmap
    sprite.y -= 1
    sprite.opacity -= 2
    sprite.zoom_x -= 0.006
    sprite.zoom_y += 0.06
  end
end