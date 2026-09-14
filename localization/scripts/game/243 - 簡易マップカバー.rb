#==============================================================================
# ■ RGSS3 簡易マップカバー Ver1.01 by 星潟
#------------------------------------------------------------------------------
# マップ画面を特定色で覆います。
# また、指定された画像(※1)を元に、指定座標の覆った色を薄れさせます。
# 薄れさせる度合いは画像の赤の要素に応じます。
# 
# イベントを考慮しない明かりスクリプトのようなものです。
# 
# ※1 この画像はGraphicsのSystemフォルダに格納してください。
#==============================================================================
# マップのメモ欄で設定
#------------------------------------------------------------------------------
# <カバーカラー:0,0,0,255>
# 
# マップ全体を赤0 緑0 青0 不透明度255の色で覆う。
#------------------------------------------------------------------------------
# <アンチカバー:2,2,AntiCover1>
# 
# マップのX座標2・Y座標2の位置を中心に
# AntiCover1の画像でカバーカラーを薄れさせる。
#------------------------------------------------------------------------------
# <アンチカバー:14,5,AntiCover2,$game_switches[1]>
# 
# スイッチID1がONの時、マップのX座標14・Y座標5の位置を中心に
# AntiCover2の画像でカバーカラーを薄れさせる。
# (ただし、スイッチID1をマップ内でONにするだけでは自動的には切りかわらない。
#  後述のイベントコマンドのスクリプトで再描写フラグをONにする必要がある)
#==============================================================================
# イベントコマンドのスクリプトで設定
#------------------------------------------------------------------------------
# map_cover_update_execute
# 
# マップカバーを現在の設定で再描写する。
#------------------------------------------------------------------------------
# set_cover_color
# 
# マップカバーを消す。
#------------------------------------------------------------------------------
# set_cover_color(255,0,128)
# 
# マップカバーを赤255 緑0 青128の色で再描写する。
#------------------------------------------------------------------------------
# set_cover_color(255,0,128,150)
# 
# マップカバーを赤255 緑0 青128 不透明度150の色で再描写する。
#------------------------------------------------------------------------------
# reset_cover_color
# 
# マップカバー色の設定をマップに設定してあった色に戻す。
#==============================================================================
module EasyMapCover
  
  #マップカバー色の指定用キーワードを指定
  
  Word1 = "カバーカラー"
  
  #アンチカバーの座標と条件指定用キーワードを指定
  
  Word2 = "アンチカバー"
  
  #アンチカバープレーンのZ座標を指定
  
  Z    = 300
  
end
class Spriteset_Map
  #--------------------------------------------------------------------------
  # タイマースプライトの作成
  #--------------------------------------------------------------------------
  alias create_timer_easy_map_cover create_timer
  def create_timer
    create_timer_easy_map_cover
    create_easy_map_cover
  end
  #--------------------------------------------------------------------------
  # タイマースプライトの解放
  #--------------------------------------------------------------------------
  alias dispose_timer_easy_map_cover dispose_timer
  def dispose_timer
    dispose_timer_easy_map_cover
    dispose_easy_map_cover
  end
  #--------------------------------------------------------------------------
  # タイマースプライトの更新
  #--------------------------------------------------------------------------
  alias update_timer_easy_map_cover update_timer
  def update_timer
    update_timer_easy_map_cover
    update_easy_map_cover
  end
  #--------------------------------------------------------------------------
  # 簡易マップカバープレーンの作成
  #--------------------------------------------------------------------------
  def create_easy_map_cover
    @easy_map_cover_plane = Plane_EasyMapCover.new(@viewport1)
    @easy_map_cover_plane.z = EasyMapCover::Z
  end
  #--------------------------------------------------------------------------
  # 簡易マップカバープレーンの更新
  #--------------------------------------------------------------------------
  def dispose_easy_map_cover
    @easy_map_cover_plane.bitmap.dispose if @easy_map_cover_plane.bitmap && !@easy_map_cover_plane.bitmap.disposed?
    @easy_map_cover_plane.dispose
  end
  #--------------------------------------------------------------------------
  # 簡易マップカバープレーンの更新
  #--------------------------------------------------------------------------
  def update_easy_map_cover
    @easy_map_cover_plane.update_easy_map_cover
  end
end
class Plane_EasyMapCover < Plane
  #--------------------------------------------------------------------------
  # 更新
  #--------------------------------------------------------------------------
  def update_easy_map_cover
    update_bitmap
    update_position
  end
  #--------------------------------------------------------------------------
  # ビットマップの更新
  #--------------------------------------------------------------------------
  def update_bitmap
    mid = $game_map.map_id
    return if !$game_map.map_cover_update && @map_id == mid
    $game_map.map_cover_update = false
    @map_id = mid
    if self.bitmap
      self.bitmap.dispose
      self.bitmap = nil
    end
    cc = $game_map.cover_color
    return if cc.empty?
    mw = 32 * $game_map.width
    mh = 32 * $game_map.height
    base = Bitmap.new(mw,mh)
    base.fill_rect(base.rect,Color.new(cc[0],cc[1],cc[2],cc[3]))
    hl = $game_map.loop_horizontal?
    vl = $game_map.loop_vertical?
    $game_map.anti_map_cover_data.each {|a|
    next if a[3] && !eval(a[3])
    bc = Cache.system(a[2])
    bcw = bc.width
    bch = bc.height
    bcsx = a[0] * 32 + 16 - bcw / 2
    bcsy = a[1] * 32 + 16 - bch / 2
    bcw.times {|bcxn|
    bcx = bcsx + bcxn
    if mw <= bcx
      next unless hl
      bcx -= mw
    elsif bcx < 0
      next unless hl
      bcx += mw
    end
    bch.times {|bcyn|
    bcy = bcsy + bcyn
    if mh <= bcy
      next unless vl
      bcy -= mh
    elsif bcy < 0
      next unless vl
      bcy += mh
    end
    gc2 = bc.get_pixel(bcxn,bcyn)
    red = gc2.red
    next if red == 0
    gc1 = base.get_pixel(bcx,bcy)
    gc1.alpha -= red
    base.set_pixel(bcx,bcy,gc1)
    }}}
    self.bitmap = base
  end
  #--------------------------------------------------------------------------
  # 表示位置の更新
  #--------------------------------------------------------------------------
  def update_position
    self.ox = $game_map.display_x * 32
    self.oy = $game_map.display_y * 32
  end
end
class Game_Map
  attr_accessor :map_cover_update
  #--------------------------------------------------------------------------
  # セットアップ
  #--------------------------------------------------------------------------
  alias setup_easy_map_cover setup
  def setup(map_id)
    setup_easy_map_cover(map_id)
    @changed_cover_color = nil
    @map_cover_update = nil
  end
  #--------------------------------------------------------------------------
  # カバーカラー
  #--------------------------------------------------------------------------
  def cover_color
    @changed_cover_color || @map.cover_color
  end
  #--------------------------------------------------------------------------
  # アンチカバー
  #--------------------------------------------------------------------------
  def anti_map_cover_data
    @map.anti_map_cover_data
  end
  #--------------------------------------------------------------------------
  # カバーカラーの設定変更
  #--------------------------------------------------------------------------
  def set_cover_color(*args)
    a = args.is_a?(Array) ? args[0] : args
    if a.size > 2
      a += [255] if a.size == 3
      r = a
    else
      r = []
    end
    @changed_cover_color = r
    @map_cover_update = true
  end
  #--------------------------------------------------------------------------
  # カバーカラー設定変更解除
  #--------------------------------------------------------------------------
  def reset_cover_color
    @changed_cover_color = nil
    @map_cover_update = true
  end
end
class Game_Interpreter
  #--------------------------------------------------------------------------
  # カバーカラーの設定変更反映
  #--------------------------------------------------------------------------
  def map_cover_update_execute
    $game_map.map_cover_update = true 
  end
  #--------------------------------------------------------------------------
  # カバーカラーの設定変更
  #--------------------------------------------------------------------------
  def set_cover_color(*args)
    $game_map.set_cover_color(args)
  end
  #--------------------------------------------------------------------------
  # カバーカラー設定変更解除
  #--------------------------------------------------------------------------
  def reset_cover_color
    $game_map.reset_cover_color
  end
end
class RPG::Map
  #--------------------------------------------------------------------------
  # カバーカラー
  #--------------------------------------------------------------------------
  def cover_color
    @cover_color ||= create_cover_color
  end
  #--------------------------------------------------------------------------
  # カバーカラーの作成
  #--------------------------------------------------------------------------
  def create_cover_color
    if /<#{EasyMapCover::Word1}[:：](\S+)>/ =~ note
      a = $1.split(/\s*,\s*/).inject([]) {|r,i| r.push(i.to_i)}
      if a.size > 2
        a.push(255) if a.size < 4
        return a
      end
    end
    []
  end
  #--------------------------------------------------------------------------
  # アンチカバー
  #--------------------------------------------------------------------------
  def anti_map_cover_data
    @anti_map_cover_data ||= create_anti_map_cover_data
  end
  #--------------------------------------------------------------------------
  # アンチカバーの作成
  #--------------------------------------------------------------------------
  def create_anti_map_cover_data
    r = []
    note.each_line {|l|
    if /<#{EasyMapCover::Word2}[:：](\S+)>/ =~ l
      a = $1.split(/\s*,\s*/)
      if a.size > 2
        a[0] = a[0].to_i
        a[1] = a[1].to_i
        r.push(a)
      end
    end}
    r
  end
end