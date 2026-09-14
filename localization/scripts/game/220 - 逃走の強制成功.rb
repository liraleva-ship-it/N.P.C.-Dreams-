module BattleManager

ESCAPE_FORCE = 98
def self.process_escape
$game_message.add(sprintf(Vocab::EscapeStart, $game_party.name))
success = @preemptive ? true : (rand < @escape_ratio)
Sound.play_escape
if success || $game_switches[ESCAPE_FORCE]
process_abort
else
@escape_ratio += 0.1
$game_message.add('\.' + Vocab::EscapeFailure)
$game_party.clear_actions
end
wait_for_message
return success
end
end