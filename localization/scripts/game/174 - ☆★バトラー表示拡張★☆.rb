#==============================================================================
# ★ RGSS3_バトラー表示拡張 Ver1.02
#==============================================================================
=begin

作者：tomoaky
webサイト：ひきも記 (http://hikimoki.sakura.ne.jp/)

戦闘シーンにおいてエネミーのスプライトに以下の効果を適用します。
  ・ランダムに左右反転
  ・Ｙ座標を元に拡大縮小をおこない遠近感を演出
  ・一定間隔で拡大縮小をおこない息遣いを演出
  
行動不可状態のエネミーは息遣いが自動的に一時停止します

2012.04.05  Ver1.02
　・アクターグラフィックに効果を適用しないように修正
    デフォルトの戦闘シーンでは特に意味はありません

2011.12.20  Ver1.01
  ・解像度に合わせて遠近効果の基準となるＹ座標を自動計算するように修正

2011.12.15  Ver1.0
  公開

=end

#==============================================================================
# □ 設定項目
#==============================================================================
module TMBSPREX
  # 左右反転を適用しないトループをIDで指定
  NO_MIRROR_TROOP = [4, 5, 6]
  
  # 左右反転を適用しないエネミーをIDで指定
  NO_MIRROR_ENEMY = [2, 3, 36, 37, 38, 39, 41, 42, 43, 45, 49, 51, 54, 57, 61, 66, 68, 69,
    70,71,72,75,82,83,85,87,88,93,94,95,96,97,98,100,104,105,106,111,112,119,120,122,
    113,114,115,116,117,122,123,124,125,129,130,134,135,138,139,140,141,145,
    142,143,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,
    169,170,175,176,177,178,182,183,188,
    ]
  
  # 遠近効果を適用しないトループをIDで指定
  NO_ZOOM_TROOP = [5, 6,]
  
  # 遠近効果を適用しないエネミーをIDで指定
  NO_ZOOM_ENEMY = [6, 45, 65, 67, 69,70,71,72,75,77,78,82,83,101,105,106,111,119,120,
  122,113,114,115,116,117,122,123,124,129,130,132,134,135,138,139,140,141,144,145,
  146,142,143,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,
  169,175,176,177,182,183,188,
  ]#42,43]
  
  # 息遣いを適用しないトループをIDで指定
  NO_BREATH_TROOP = []
  
  # 息遣いを適用しないエネミーをIDで指定
  NO_BREATH_ENEMY = [6,]
end

#==============================================================================
# ■ Sprite_Battler
#==============================================================================
class Sprite_Battler < Sprite_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias tmbsprex_sprite_battler_initialize initialize
  def initialize(viewport, battler = nil)
    tmbsprex_sprite_battler_initialize(viewport, battler)
    if battler && !battler.actor?
      unless TMBSPREX::NO_MIRROR_TROOP.include?($game_troop.troop.id)
        unless TMBSPREX::NO_MIRROR_ENEMY.include?(battler.enemy.id)
          self.mirror = (rand(3) == 0)      # 1/3の確率で左右反転
        end
      end
      unless TMBSPREX::NO_ZOOM_TROOP.include?($game_troop.troop.id)
        unless TMBSPREX::NO_ZOOM_ENEMY.include?(battler.enemy.id)
          border_y = Graphics.height * 65 / 100
          self.zoom_x = (battler.screen_y - border_y) * 0.005 + 1.0
        end
      end
      unless TMBSPREX::NO_BREATH_TROOP.include?($game_troop.troop.id)
        unless TMBSPREX::NO_BREATH_ENEMY.include?(battler.enemy.id)
          @zoom_max = rand(30) + 150
          @zoom_count = rand(@zoom_max)
        end
      end
      @use_tmbsprex = true
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias tmbsprex_sprite_battler_update update
  def update
    tmbsprex_sprite_battler_update
    if @use_tmbsprex
      self.zoom_y = self.zoom_x
      self.z = 50 + self.y
      if @zoom_max && @battler.movable?
        @zoom_count += 1
        @zoom_count = 0 if @zoom_count == @zoom_max
        f = Math.sin(Math::PI * @zoom_count / (@zoom_max / 2))
        self.zoom_y += f * 0.015 + 0.015
      end
    end
  end
end


