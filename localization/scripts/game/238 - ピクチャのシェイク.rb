#==============================================================================
#　ピクチャのシェイク
#　
#　指定した番号のピクチャをシェイクさせます
#
#　起動方法
#　　スクリプトに以下のように記述してください。
#　　　shake_img(z,p)
#　　　　z：ピクチャの番号です。
#　　　　p：揺れの大きさの幅を指定します。
#　　　　d：揺れの速さを指定します。
#　　　　s：揺れの長さを指定します。
#
#　利用規約
#　　連絡不要
#　　商用可
#    改造可
#    再配布可（無改造の場合はクレジットを消さないでください）
#    アダルト可
#　　利用された際、クレジットはあると喜びます　
#
#　　　　　　　　　　　　　　　　　　　　　　　by 3dpose
#　　　　　　　　　　　　　　　　　　　　　　　http://customsaga.wiki.fc2.com/
#
#　　　　　　　　　　　　　　　　　　　　　　　GY. Materials
#　　　　　　　　　　　　　　　　　　　　　　　http://gymaterials.jp/
#
#==============================================================================
# ■ Game_Interpreter
#------------------------------------------------------------------------------
# 　イベントコマンドを実行するインタプリタです。このクラスは Game_Map クラス、
# Game_Troop クラス、Game_Event クラスの内部で使用されます。
#==============================================================================

class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● 画像のシェイク
  #--------------------------------------------------------------------------
  def shake_img(z,p,d,s)
    # 元となるピクチャのデータを取得
    pic = screen.pictures[z]
    origin = pic.origin
    ox = pic.x
    oy = pic.y
    zoom_x = pic.zoom_x
    zoom_y = pic.zoom_y
    opacity = pic.opacity
    blend_type = pic.blend_type
    duration = d
    # ランダムの大きさを設定
    rp = p*2
    # シェイク実行
    for i in 1..s
      x = rand(rp)-p + ox
      y = rand(rp)-p + oy
      pic.move(origin, x, y, zoom_x, zoom_y, opacity, blend_type, duration)
      wait(duration)
    end
    # 最初の位置に戻す
    pic.move(origin, ox, oy, zoom_x, zoom_y, opacity, blend_type, duration)
  end
end