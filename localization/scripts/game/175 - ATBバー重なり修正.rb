#==============================================================================
# ■ ATBバー重なり修正 by gentlawk via ココナラ ver1.00
#==============================================================================
#------------------------------------------------------------------------------
# ■内容
# C Winter様「ATBスクリプト」および、
# ひきも記様「バトラー表示拡張スクリプト」の競合により、
# ATBゲージが手前設定にしているにもかかわらず
# バトラー画像の裏に表示されてしまう不具合を修正します。
#
# ■位置
# C Winter様「ATBスクリプト」
# ひきも記様「バトラー表示拡張スクリプト」
# より下
#
# ■使用方法
# とくにありません
#
#------------------------------------------------------------------------------
module Gentlawk
  @@gentlawk_includes ||= {}
  @@gentlawk_includes[:I_ATBGauge] = 1.00
  module ATBGauge
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
# ■ Sprite_Battler
#==============================================================================
class Sprite_Battler < Sprite_Base
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias gentlawk_atb_gauge_update update
  def update
    gentlawk_atb_gauge_update
    # 座標の再設定
    @gauge_sprite.update_rect(self.x, self.y, self.z) if @gauge_sprite
  end
end
#==============================================================================
# ■ Sprite_Enemy_Gauge
#==============================================================================
class Sprite_Enemy_Gauge < Sprite_Base
  #--------------------------------------------------------------------------
  # ● ＡＰゲージ表示位置を更新
  #--------------------------------------------------------------------------
  alias gentlawk_atb_gauge_update_rect update_rect
  def update_rect(x, y, z)
    gentlawk_atb_gauge_update_rect(x, y, z)
    self.y = y - @gauge_high * @battler_sprite.zoom_x
    self.y += ATB::ENEMY_GAUGE_POS_DATA[@gauge_number]
  end
end
