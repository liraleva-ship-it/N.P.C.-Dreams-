=begin
 RegionSwitch for VXA ver 1.0.1.0
  設定したリージョンに入ったらスイッチオン
  自動実行イベントと組み合わせて使うといい感じ


  マップ設定のメモ欄に
[RSW:12,10]
  とか書くとリージョン１２に入った時にスイッチ１０がONになるようになります。

URL:: http://www.tktkgame.com/
LAST_UPDATE:: 2012/09/18
=end
module Tktkgame
  module RegionSwitch
    REGEX_REGION_SETTING = /\[RSW:(\d+),(\d+)\s*\]/
    # RPG::Map include用
    module MixinMap
      # メモからリージョンイベント情報を取得
      def init_region_switches
        @region_switches = {}
        self.note.scan(REGEX_REGION_SETTING) do |m|
          region_id = m[0].to_i
          sw_no      = m[1].to_i
          if region_id > 0 && sw_no > 0
            @region_switches[region_id] = [sw_no, true]
          end
        end
      end
      protected :init_region_switches
      def region_switches
        init_region_switches() if @region_switches.nil?
        return @region_switches
      end
    end

    # Game_Map include用
    module MixinGameMap
      def check_region_switche(region_id)
        if @map.region_switches.key?(region_id)
          sw_no, value = @map.region_switches[region_id]
          if $game_switches[sw_no] != value
            $game_switches[sw_no] = value
            need_refresh = true
          end
        end
      end
    end

    # Game_Map include用
    module MixinGamePlayer
      #--------------------------------------------------------------------------
      # ● 歩数増加
      #--------------------------------------------------------------------------
      def increase_steps
        super
        if !@through && !jumping?
          $game_map.check_region_switche($game_map.region_id(@x, @y))
        end
      end
    end

  end # END module Tktkgame::RegionSwitch

end # END module Tktkgame

class RPG::Map
  include Tktkgame::RegionSwitch::MixinMap
end
class Game_Map
  include Tktkgame::RegionSwitch::MixinGameMap
end

class Game_Player
  include Tktkgame::RegionSwitch::MixinGamePlayer
end