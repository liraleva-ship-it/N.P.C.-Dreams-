#==============================================================================
# ■ RGSS3 追加ダメージ/属性ダメージ軽減 Ver1.01 by 星潟
#------------------------------------------------------------------------------
# ダメージ計算の最終段階でダメージを追加したり割合増幅したり
# 属性ダメージを指定値分軽減する機能を追加します。
# なお、使用効果ではなくダメージ計算の部分で計算を行いますので
# ダメージ:なしに設定されたアイテム・スキルには
# 効果がありませんのでご注意ください。
# (ダメージ欄を使わない場合でもダメージ:なしでなければいいので
#  HP回復であればHP回復にしてダメージ値を0に設定してください)
# 
# また、使用効果の値には割合増加の効果は影響しませんので
# 影響させる場合は使用効果を使わず、ダメージ欄の方で設定を行ってください。
#==============================================================================
# 特徴を有する項目のメモ欄に指定
#------------------------------------------------------------------------------
# <追加ダメージ:ホイミ,値,50,75>
# 
# 75％の確率で追加ダメージタグでホイミのついているアイテム・スキルの
# 効果量を50加算。
#------------------------------------------------------------------------------
# <追加ダメージ:ホイミ,割合,50,100>
# 
# 100％の確率で追加ダメージタグでホイミのついているアイテム・スキルの
# 効果量を50％増加。
#------------------------------------------------------------------------------
# <属性ダメージ軽減:1,50,25>
# 
# 25％の確率で属性ID1によるダメージを50軽減。
#==============================================================================
# アイテム・スキルのメモ欄に指定
#------------------------------------------------------------------------------
# <追加ダメージタグ:ホイミ>
# 
# このアイテム・スキルの追加ダメージタグとしてホイミを追加。
#==============================================================================
module AddDamageFeature
  
  #追加ダメージ設定用キーワードを指定
  
  Word1 = "追加ダメージ"
  
  #追加ダメージタグ設定用キーワードを指定
  
  Word2 = "追加ダメージタグ"
  
  #属性ダメージ軽減設定用キーワードを指定
  
  Word3 = "属性ダメージ軽減"
  
  #追加ダメージ設定時用の系統判定キーワードを指定
  
  Words = ["値","割合"]
  
  #追加ダメージの割合変動処理を追加ダメージの値側にも影響させるかを指定
  #影響させる場合はtrue、させない場合はfalse
  
  Type = false
  
end
class RPG::BaseItem
  #--------------------------------------------------------------------------
  # 追加ダメージ特徴
  #--------------------------------------------------------------------------
  def add_damage_features
    @add_damage_features ||= create_add_damage_features
  end
  #--------------------------------------------------------------------------
  # 追加ダメージ特徴作成
  #--------------------------------------------------------------------------
  def create_add_damage_features
    h = {}
    note.each_line {|l|
    next unless /<#{AddDamageFeature::Word1}[:：](\S+)>/ =~ l
    a = $1.split(/\s*,\s*/)
    case a.size
    when 3;a.push("100")
    when 4
    else;next
    end
    flag = false
    2.times {|i|
    next unless a[1] == AddDamageFeature::Words[i]
    a[1] = i
    flag = true
    break}
    next unless flag
    h[a[0]] ||= []
    h[a[0]].push(a[1,3])}
    h
  end
  #--------------------------------------------------------------------------
  # 属性ダメージ軽減特徴
  #--------------------------------------------------------------------------
  def resist_element_damage_features
    @resist_element_damage_features ||= create_resist_element_damage_features
  end
  #--------------------------------------------------------------------------
  # 属性ダメージ軽減特徴作成
  #--------------------------------------------------------------------------
  def create_resist_element_damage_features
    h = {}
    note.each_line {|l|
    next unless /<#{AddDamageFeature::Word3}[:：](\S+)>/ =~ l
    a = $1.split(/\s*,\s*/)
    case a.size
    when 2;a.push("100")
    when 3
    else;next
    end
    h[a[0].to_i] ||= []
    h[a[0].to_i].push(a[1,2])}
    h
  end
end
class RPG::UsableItem
  #--------------------------------------------------------------------------
  # 追加ダメージタグ
  #--------------------------------------------------------------------------
  def add_damage_features_tags
    @add_damage_features_tags ||= create_add_damage_features_tags
  end
  #--------------------------------------------------------------------------
  # 追加ダメージタグ作成
  #--------------------------------------------------------------------------
  def create_add_damage_features_tags
    a = []
    note.each_line {|l|
    a.push($1.to_s) if /<#{AddDamageFeature::Word2}[:：](\S+)>/ =~ l}
    a
  end
end
class Game_BattlerBase
  #--------------------------------------------------------------------------
  # 属性有効度の取得
  #--------------------------------------------------------------------------
  alias element_rate_add_damage_features element_rate
  def element_rate(element_id)
    @result.resist_element_damage_eids.push(element_id)
    element_rate_add_damage_features(element_id)
  end
end
class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # ダメージ計算
  #--------------------------------------------------------------------------
  alias make_damage_value_add_damage_features make_damage_value
  def make_damage_value(user, item)
    @result.create_add_damage_features_value(user, item)
    make_damage_value_add_damage_features(user, item)
  end
  #--------------------------------------------------------------------------
  # スキル／アイテムの属性修正値を取得
  #--------------------------------------------------------------------------
  alias item_element_rate_add_damage_features item_element_rate
  def item_element_rate(user, item)
    @get_resist_element_damage_features_eid = true
    r = item_element_rate_add_damage_features(user, item)
    @get_resist_element_damage_features_eid = nil
    r
  end
  #--------------------------------------------------------------------------
  # 追加ダメージ
  #--------------------------------------------------------------------------
  def create_add_damage_features_value(item)
    r = [0,1.0]
    tags = item.add_damage_features_tags
    feature_objects.each {|f| f.add_damage_features.each {|k,a|
    a.each {|v|
    if tags.include?(k) && eval(v[2]) > rand(100)
      case v[0]
      when 0;r[0] += eval(v[1])
      when 1;r[1] *= 1 + eval(v[1]) * 0.01
      end
    end}}}
    r
  end
  #--------------------------------------------------------------------------
  # 属性ダメージ軽減
  #--------------------------------------------------------------------------
  def create_resist_element_damage_features_value
    r = 0
    feature_objects.each {|f| f.resist_element_damage_features.each {|k,a|
    next unless @result.resist_element_damage_eids.include?(k)
    a.each {|v|
    r += eval(v[0]) if eval(v[1]) > rand(100)}}}
    r
  end
end
class Game_ActionResult
  attr_accessor :resist_element_damage_eids
  #--------------------------------------------------------------------------
  # ダメージ値のクリア
  #--------------------------------------------------------------------------
  alias clear_damage_values_add_damage_features clear_damage_values
  def clear_damage_values
    clear_damage_values_add_damage_features
    @add_damage_features_value = [0,1.0]
    @resist_element_damage_eids = []
  end
  #--------------------------------------------------------------------------
  # 追加ダメージ
  #--------------------------------------------------------------------------
  def add_damage_features_value
    @add_damage_features_value ||= [0,1.0]
  end
  #--------------------------------------------------------------------------
  # 属性ダメージ軽減用属性ID
  #--------------------------------------------------------------------------
  def resist_element_damage_eids
    @resist_element_damage_eids ||= []
  end
  #--------------------------------------------------------------------------
  # 追加ダメージ作成
  #--------------------------------------------------------------------------
  def create_add_damage_features_value(user,item)
    @add_damage_features_value = user.create_add_damage_features_value(item)
  end
  #--------------------------------------------------------------------------
  # ダメージの作成
  #--------------------------------------------------------------------------
  alias make_damage_add_damage_features make_damage
  def make_damage(value, item)
    a = add_damage_features_value
    sign = item.damage.sign
    fix = (a[0] * sign)
    true_value = AddDamageFeature::Type ? (value + fix) * a[1] : value * a[1] + fix
    true_value -= @battler.create_resist_element_damage_features_value if sign > 0
    if sign > 0
      true_value = 0 if true_value < 0
    else
      true_value = 0 if true_value > 0
    end
    make_damage_add_damage_features(true_value.to_i,item)
  end
end