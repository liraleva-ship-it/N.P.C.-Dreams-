#==============================================================================
# ★ RGSS3_メタルボディ Ver1.0
#==============================================================================
=begin

作者：tomoaky
webサイト：ひきも記は閉鎖しました。 (http://hikimoki.sakura.ne.jp/)

ステートや装備品、エネミーのメモ欄に <メタルボディ 5> と書くことで
受けるダメージの上限を指定した値に制限することができます。

2013.06.06  Ver1.0
  公開

=end

#==============================================================================
# ■ Game_Battler
#==============================================================================
class Game_Battler < Game_BattlerBase
  
  #--------------------------------------------------------------------------
  # ○ メタルボディ効果を返す
  #--------------------------------------------------------------------------
  def metal_body
    feature_objects.each do |object|
      return $1.to_i if /<メタルボディ\s*(\d+)\s*>/ =~ object.note
    end
    nil
  end
  #--------------------------------------------------------------------------
  # ● 防御修正の適用
  #--------------------------------------------------------------------------
  alias tmmetalbody_game_battler_apply_guard apply_guard
  def apply_guard(damage)
    result = tmmetalbody_game_battler_apply_guard(damage)
    return (result > 0 && metal_body ? [result, metal_body*$game_variables[287]].min : result)
  end
  
  
#~   def metal_body_2
#~     feature_objects.each do |object|
#~       return $1.to_i if /<強防御\s*(\d+)\s*>/ =~ object.note
#~     end
#~     nil
#~   end
#~   
#~   alias tmmetalbody_game_battler_apply_guard_2 apply_guard
#~   def apply_guard(damage)
#~     result = tmmetalbody_game_battler_apply_guard_2(damage)
#~     return (damage / (damage > 0 && metal_body_2 ? metal_body_2 * grd : 1))
#~   end

end


