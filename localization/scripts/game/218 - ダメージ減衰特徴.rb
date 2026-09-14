#==============================================================================
# ■ RGSS3 ダメージ減衰特徴 Ver1.00　by 星潟
#------------------------------------------------------------------------------
# 複数対象へのダメージ時、後にダメージを与える敵ほど
# ダメージが減少する特徴の設定が可能となります。（戦闘中のみ有効です）
# アイテム・スキルはダメージ欄で処理するダメージ・回復には有効ですが
# アイテムの「使用効果」には無効ですので注意して下さい。
# 
# 例1.
# <通常攻撃減衰:25>と記入した特徴が付与されたキャラクターが
# <通常攻撃減衰参照>と記入されたアイテム・スキルで攻撃した場合。
# 
# 敵に命中するごとに与えるダメージが25％ずつ減少する。
# 
# 例2.
# <ダメージ減衰:30>と記入したアイテム・スキルを使用した場合
# 
# 敵に命中するごとに与えるダメージが30％ずつ減少する。
# 
# 例3.
# <通常攻撃減衰:10>と記入した特徴が付与されたキャラクターが
# <通常攻撃減衰参照>及び<ダメージ減衰:10>と記入された
# アイテム・スキルを使用した場合
# 
# 敵に命中するごとに与えるダメージが19％（100％ - 90％×90％）ずつ減少する。
# 
#==============================================================================
module Attenuation
  
  WORD1 = "通常攻撃減衰"
  
  WORD2 = "ダメージ減衰"
  
  WORD3 = "<通常攻撃減衰参照>"
  
end
class Game_Battler < Game_BattlerBase
  attr_accessor :attenuation_data
  def a_attenuation
    data = 0
    for f in feature_objects
      next if f == nil
      data += f.a_attenuation
    end
    return data
  end
  def ui_attenuation
    data = 0
    for f in feature_objects
      next if f == nil
      data += f.ui_attenuation
    end
    return data
  end
  def attenuation_data
    @attenuation_data = 100 if @attenuation_data == nil
    return @attenuation_data
  end
  #--------------------------------------------------------------------------
  # ● ダメージ計算
  #--------------------------------------------------------------------------
  alias make_damage_value_attenuation make_damage_value
  def make_damage_value(user, item)
    make_damage_value_attenuation(user, item)
    return if !$game_party.in_battle
    if @result.hp_damage != 0
      @result.hp_damage *= user.attenuation_data
      @result.hp_damage /= 100
    end
    if @result.mp_damage != 0
      @result.mp_damage *= user.attenuation_data
      @result.mp_damage /= 100
    end
    if item.ui_attenuation != 0
      attenuation_rate = 100 - item.ui_attenuation
      user.attenuation_data *= attenuation_rate
      user.attenuation_data /= 100
    end
    if item.attack_type == 0 && user.a_attenuation != 0
      attenuation_rate = 100 - user.a_attenuation
      user.attenuation_data *= attenuation_rate
      user.attenuation_data /= 100
    end
  end
end
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● スキル／アイテムの使用
  #--------------------------------------------------------------------------
  alias use_item_attenuation use_item
  def use_item
    @attenuation_last_battler = @subject
    attenuation_restore
    use_item_attenuation
    attenuation_restore
  end
  #--------------------------------------------------------------------------
  # ● ダメージ減衰値の初期化
  #--------------------------------------------------------------------------
  def attenuation_restore
    @attenuation_last_battler.attenuation_data = 100
  end
end
class RPG::BaseItem
  attr_accessor :a_attenuation
  def a_attenuation
    return @a_attenuation if @a_attenuation != nil
    memo = @note.scan(/<#{Attenuation::WORD1}[：:](\S+)>/)
    memo = memo.flatten
    if memo != nil && !memo.empty?
      @a_attenuation = memo[0].to_i
    else
      @a_attenuation = 0
    end
    return @a_attenuation
  end
end
class RPG::UsableItem < RPG::BaseItem
  attr_accessor :ui_attenuation
  attr_accessor :attack_type
  def ui_attenuation
    return @ui_attenuation if @ui_attenuation != nil
    memo = @note.scan(/<#{Attenuation::WORD2}[：:](\S+)>/)
    memo = memo.flatten
    if memo != nil && !memo.empty?
      @ui_attenuation = memo[0].to_i
    else
      @ui_attenuation = 0
    end
    return @ui_attenuation
  end
  def attack_type
    return @attack_type if @attack_type != nil
    @attack_type = @note.include?(Attenuation::WORD3) ? 0 : 1
    return @attack_type
  end
end