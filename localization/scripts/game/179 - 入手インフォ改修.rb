#==============================================================================
# ■ 入手インフォ改修 by gentlawk via ココナラ ver1.10
#==============================================================================
#------------------------------------------------------------------------------
# ■内容
# レーネ様「入手インフォメーション＋マップエフェクトベース RGSS3」スクリプトの挙動を改善します。
# 1. ポップアップ中のテキストで制御文字を利用可能にします。
# 2. ポップアップの同時表示数を制限できるようにします。
# 　その際、表示数を超えて表示しようとした場合は古いものを削除して新しいものを表示します。
#
# ■位置
# レーネ様「入手インフォメーション＋マップエフェクトベース RGSS3」より下
#
# ■使用方法
# 詳細設定欄にて以下の項目を設定してください。
# ○POPUP_MAX
# 　ポップアップの最大同時表示です。
# 　最大まで表示されているときに表示待ちのポップアップがある場合は
# 　一番古いポップアップを削除して表示します。
# ○POPUP_WAIT
#   ポップアップの表示間隔時間です。
# ○SCROLL_SPEED
# 　古いポップアップが消えて表示中のポップアップが詰められる際の移動速度です。
# ○LABEL_FONT_SIZE
# 　ポップアップのラベルのフォントサイズです。デフォルトは14です。
# ○FONT_SIZE
# 　ポップアップの内容のフォントサイズです。デフォルトは22です。
# ○ICON_SIZE
# 　アイコンのサイズです。デフォルトは24です。
#
# □表示数制限について
# 一度に表示する制限を追加したため、表示演出を変更しています。
# 古いポップアップが消えるとその分表示中のポップアップの位置が詰められ、
# 空いたスペースに新しいポップアップが表示されます。
#
# □制御文字対応について
# アイテムなどの説明文をポップアップで表示する際制御文字が利用できます。
# また、スクリプトでのポップアップでも制御文字が利用できますが、
# スクリプトで利用する際は以下の点にご注意ください。
# ・ダブルクォーテーション「"」で文字列を囲う場合は「\」を2つ重ねる
# 　　例) "\\c[10]レオリュード城　地下監獄"
# ・シングルクォーテーション「'」で文字列を囲う場合は「\」は1で良い
# 　　例) '\c[10]レオリュード城　地下監獄'
#
# ※演出を変更している都合上、多数の定義上書きがあるためご注意ください。
#
#------------------------------------------------------------------------------
module Gentlawk
  @@gentlawk_includes ||= {}
  @@gentlawk_includes[:I_GetInfo] = 1.10
  module GetInfo
    #▲▽▲▽▲▽▲▽▲▽▲▽▲▽▲▽
    #詳細設定
    
    # ポップアップの最大表示数
    POPUP_MAX = 4
    # ポップアップの表示ウェイト
    POPUP_WAIT = 10
    # ポップアップを詰める際の移動速度
    SCROLL_SPEED = 4
    
    # ポップアップのラベルフォントサイズ(デフォルト:14)
    LABEL_FONT_SIZE = 14#12
    # ポップアップの内容フォントサイズ(デフォルト:22)
    FONT_SIZE = 23#16
    # ポップアップのアイコンサイズ(デフォルト:24)
    ICON_SIZE = 24#16
    
    #▲▽▲▽▲▽▲▽▲▽▲▽▲▽▲▽
    def self.define_enqueue(obj)
      class << obj
        alias gentlawk_get_info_push push
        def push(e)
          # 一度キューに迂回する
          $game_temp.streffect_in.push(e)
        end
      end
    end
  end
  class RequirementException < StandardError; end
  def self.requirement(name, version)
    if include?(name, version)
      return true
    end
    raise RequirementException, "#{name} ver#{version}以上が導入されていません"
  end
  def self.include?(name, version)
    @@gentlawk_includes[name] && @@gentlawk_includes[name] >= version
  end
end
#==============================================================================
# ■ Game_Temp
#==============================================================================
class Game_Temp
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :streffect_in  # 表示キュー
  attr_accessor :streffect_out # 画面外表示
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias gentlawk_get_info_initialize initialize
  def initialize
    gentlawk_get_info_initialize
    @streffect_in = []
    @streffect_out = []
    Gentlawk::GetInfo.define_enqueue(@streffect)
  end
end
#==============================================================================
# ■ Spriteset_Map
#==============================================================================
class Spriteset_Map
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias gentlawk_get_info_initaialize initialize
  def initialize
    @streffect_wait = 0
    gentlawk_get_info_initaialize
  end
  #--------------------------------------------------------------------------
  # ● エフェクトの作成
  #--------------------------------------------------------------------------
  alias gentlawk_get_info_create_streffect create_streffect
  def create_streffect
    gentlawk_get_info_create_streffect
    Gentlawk::GetInfo.define_enqueue($game_temp.streffect)
    $game_temp.streffect_out = []
    $game_temp.streffect_in = []
  end
  #--------------------------------------------------------------------------
  # ● エフェクトの解放
  #--------------------------------------------------------------------------
  def dispose_streffect
    $game_temp.streffect.reverse.each do |effect|
      effect.dispose if effect
    end
    $game_temp.streffect = []
    Gentlawk::GetInfo.define_enqueue($game_temp.streffect)
    $game_temp.streffect_out.reverse.each do |effect|
      effect.dispose if effect
    end
    $game_temp.streffect_out = []
    $game_temp.streffect_in.reverse.each do |effect|
      effect.dispose if effect
    end
    $game_temp.streffect_in = []
  end
  #--------------------------------------------------------------------------
  # ● エフェクトの更新
  #--------------------------------------------------------------------------
  def update_streffect
    # キューにあるエフェクトを処理
    if $game_temp.streffect_in.size > 0 && @streffect_wait <= 0
      effect = $game_temp.streffect_in.shift
      effect.setup
      $game_temp.streffect.gentlawk_get_info_push(effect)
      @streffect_wait = Gentlawk::GetInfo::POPUP_WAIT
    elsif @streffect_wait > 0
      @streffect_wait -= 1
    end
    
    # 更新
    (0...$game_temp.streffect.size).each do |i|
      if $game_temp.streffect[i] != nil
        $game_temp.streffect[i].viewport = @viewport1
        $game_temp.streffect[i].update
      end
    end
    (0...$game_temp.streffect_out.size).each do |i|
      if $game_temp.streffect_out[i] != nil
        $game_temp.streffect_out[i].viewport = @viewport1
        $game_temp.streffect_out[i].update
      end
    end
  end
end
#==============================================================================
# ■ Window_GetInfo
#==============================================================================
class Window_Getinfo < Window_Base
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :move_y
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(id, type, text = "", value)
#~     #super(-16, 0, 544 + 32, 38 + 32)
    dh = line_height
    h = Gentlawk::GetInfo::LABEL_FONT_SIZE + dh + standard_padding * 2
    super(-16, 0, 640 + 32, h)
    self.z = Z
    self.contents_opacity = 0
    self.back_opacity = 0
    self.opacity = 0
    self.visible = false
    @collapse = false
    @id = id
    @type = type
    @text = text
    @value = value
  end
  #--------------------------------------------------------------------------
  # ● 行の高さ
  #--------------------------------------------------------------------------
  def line_height
    [Gentlawk::GetInfo::FONT_SIZE + 2, Gentlawk::GetInfo::ICON_SIZE].max
  end
  #--------------------------------------------------------------------------
  # ● 整列間隔の取得
  #--------------------------------------------------------------------------
  def window_spacing
    Gentlawk::GetInfo::LABEL_FONT_SIZE + line_height + 4
  end
  #--------------------------------------------------------------------------
  # ● セットアップ
  #--------------------------------------------------------------------------
  def setup
    @count = 0
    # 最大数表示数制限
    @i = $game_temp.streffect.size
    if @i >= Gentlawk::GetInfo::POPUP_MAX
      @i = Gentlawk::GetInfo::POPUP_MAX-1
      $game_temp.streffect.each.with_index do |effect, i|
        effect.move_down(i == 0)
      end
      $game_temp.streffect_out.push($game_temp.streffect.shift)
    end
    
    if Y_TYPE == 0
      self.y = -14 + 4 + (@i * window_spacing)
    else
      #self.y = 140 - 58 - (@i * 40)
      self.y = 480 - self.contents.height - 12 - 4 - (@i * window_spacing)
    end
    @move_y = self.y
    $game_temp.getinfo_size[@i] = true 
    refresh(@id, @type, @text, @value)
    #SE発音　タイプチェック　0～3ならvalueを見る　4(お金)ならidを見る
    case @type
    when 0..3
      if @value >= 1
        INFO_SE.play
      elsif @value <= -1
        #Sound.play_evasion #減るときは音を鳴らなさい
      end
    when 4
      if @id >= 1
        Audio.se_play("Audio/SE/Magic1", 80, 80)
      elsif @id <= -1
        #Sound.play_evasion #減るときは音を鳴らなさい
      end
    when 5
#~         Audio.se_play("Audio/SE/レシピ発見", 100, 90)
    when 6
      if @value >= 1
        INFO_SE.play
      elsif @value <= -1
        #Sound.play_evasion #減るときは音を鳴らなさい
      end
    when 7
#~         Audio.se_play("Audio/SE/レシピ発見", 100, 90)
    when 8
#~       
end

    self.visible = true
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias gentlawk_get_info_update update
  def update
    if Y_TYPE == 0 && self.y > @move_y
      self.y -= Gentlawk::GetInfo::SCROLL_SPEED
      self.y = @move_y if self.y <= @move_y
    elsif Y_TYPE == 1 && self.y < @move_y
      self.y += Gentlawk::GetInfo::SCROLL_SPEED
      self.y = @move_y if self.y >= @move_y
    end
    if @collapse
      self.contents_opacity -= OPACITY
      dispose if self.contents_opacity == 0
      return
    end
    gentlawk_get_info_update
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  alias gentlawk_get_info_dispose dispose
  def dispose
    $game_temp.streffect_out.delete_if{|effect| effect == self }
    index = $game_temp.streffect.index(self)
    if index
      $game_temp.streffect.delete_at(index)
      $game_temp.streffect[index...$game_temp.streffect.size].each do |effect|
        effect.move_down
      end
    end
    gentlawk_get_info_dispose
  end
  #--------------------------------------------------------------------------
  # ● 一行下げる
  #--------------------------------------------------------------------------
  def move_down(collapse = false)
    @collapse = true if collapse
    if Y_TYPE == 0
      self.y = @move_y if @move_y < self.y
      @move_y = self.y - window_spacing
    elsif Y_TYPE == 1
      self.y = @move_y if @move_y > self.y
      @move_y = self.y + window_spacing
    end
  end
  #--------------------------------------------------------------------------
  # ● アイコンの描画
  #     enabled : 有効フラグ。false のとき半透明で描画
  #--------------------------------------------------------------------------
  def draw_icon(icon_index, x, y, enabled = true)
    bitmap = Cache.system("Iconset")
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    to_rect = Rect.new(x,y,Gentlawk::GetInfo::ICON_SIZE,Gentlawk::GetInfo::ICON_SIZE)
    contents.stretch_blt(to_rect, bitmap, rect, enabled ? 255 : translucent_alpha)
  end
  #--------------------------------------------------------------------------
  # ● アイテム名の描画
  #     enabled : 有効フラグ。false のとき半透明で描画
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled = true, width = 172)
    return unless item
    draw_icon(item.icon_index, x, y, enabled)
    change_color(normal_color, enabled)
    draw_text(x + Gentlawk::GetInfo::ICON_SIZE, y, width, line_height, item.name)
  end
  #--------------------------------------------------------------------------
  # ● フォント設定のリセット
  #--------------------------------------------------------------------------
  def reset_font_settings
    contents.font.size = Gentlawk::GetInfo::FONT_SIZE
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(id, type, text = "", value)
    case type
    when 0 ; data = $data_items[id]
    when 1 ; data = $data_weapons[id]
    when 2 ; data = $data_armors[id]
    when 3 ; data = $data_skills[id]
    when 4 ; data = id
    when 5 ; data = id  #無理やりidに載せたテキストデータをdataに格納してます。
    when 6 ; data = id  #経験値増減の実際の値です。
    when 7 ; data = id
    when 8 ; data = id
    else   ; p "typeの値がおかしいです><;"
    end
    c = B_COLOR
    
    self.contents.font.size = Gentlawk::GetInfo::LABEL_FONT_SIZE
    lebel_w = self.contents.text_size(text).width
    label_h = Gentlawk::GetInfo::LABEL_FONT_SIZE
    self.contents.fill_rect(0, 0, lebel_w + 4, label_h, c)
    self.contents.draw_text_f(4, 0, 340, label_h, text)
    #アイテムの入手・消失操作
    $game_party.gain_item(data,@value) if type <= 2 && GET && @value >= 1  #入手
    $game_party.gain_item(data,@value) if type <= 2 && GET && @value <= -1 #消失
    
    contents.font.size = Gentlawk::GetInfo::FONT_SIZE
    h = label_h
    name_text_w = Gentlawk::GetInfo::FONT_SIZE * 7
    name_w = name_text_w + Gentlawk::GetInfo::ICON_SIZE
    #self.contents.fill_rect(0, 14, 544, 24, c)
    self.contents.fill_rect(0, h, self.contents.width, line_height, c)
    case type #表示分岐
    when 0..2 #アイテム・武器・防具表示
      draw_item_name(data, 4, h, true, name_w)
      unit_text = "ｘ"
      unit_rect = self.contents.text_size(unit_text)
      unit_rect.width += 4
      value_rect = self.contents.text_size(value)
      value_rect.width += 4
      self.contents.draw_text(4+name_w+12, h, unit_rect.width, line_height, unit_text)
      self.contents.draw_text(4+name_w+12+unit_rect.width, h, value_rect.width, line_height, value)
      draw_text_ex(4+name_w+12+unit_rect.width+value_rect.width+12, h, description(data))
    when 3 # スキル表示
      draw_item_name(data, 4, h, true, name_w)
      draw_text_ex(4+name_w+12, h, description(data))
    when 4 # お金表示
      draw_icon(G_ICON, 4, h)
      self.contents.draw_text(4+Gentlawk::GetInfo::ICON_SIZE, h, name_text_w, line_height, 
      data.to_s + Vocab.currency_unit)
      $game_party.gain_gold(id) if GET
    when 5 # テキスト出力
      draw_icon(T_ICON, 4, h)
      draw_text_ex(4+Gentlawk::GetInfo::ICON_SIZE, h, data)
    when 6
      exp_text = "Exp："
      exp_rect = self.contents.text_size(exp_text)
      exp_rect.width += 4
      self.contents.draw_text(4, h, exp_rect.width, line_height, exp_text)
      self.contents.draw_text(4+exp_rect.width, h, self.contents.width-exp_rect.width-4, line_height, data)
    when 7 # テキスト出力
      draw_icon(S_ICON, 4, h)
      draw_text_ex(4+Gentlawk::GetInfo::ICON_SIZE, h, data)
    when 8 # テキスト出力
      draw_icon(TS_ICON, 4, h)
      draw_text_ex(4+Gentlawk::GetInfo::ICON_SIZE, h, data)
    end
    Graphics.frame_reset
  end
end
