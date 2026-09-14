#==============================================================================
# ■ RGSS3 アイテム・スキル使用条件詳細設定 Ver1.03 by 星潟
#------------------------------------------------------------------------------
# アイテム・スキル使用条件を多数の能力値とステート、スイッチ、変数で設定します。
# また、それぞれ、アクター専用条件化・エネミー専用条件化する事が出来ます。
#
# この設定は、1つのアイテム・スキルにつき幾つでも設定できます。
# ただし、1行に設定できる項目は1つのみです。
# 2つ以上の項目を設定したい場合、必ず改行して記入して下さい。
#
# 使い方はそこそこ難解ですが、かなり幅広い使い方ができると思います。
# 項目によって、設定項目が3つだったり4つだったりするので注意して下さい。
#==============================================================================
# 基本能力値・追加能力値・特殊能力値と生存・死亡・行動可能者・行動不能者取得、
# 現在HP・MP・TP合計値についてはメモ欄記入時の設定項目が3つあります。
# データを数値化した物を以て使用条件に合致しているか判断します。
# なお、本スクリプトによる行動不能者判定には「隠れている場合」も含まれます。
#==============================================================================
# ★基本能力値★（デフォルト設定用ワード　MHP,MMP,ATK,DEF,MAT,MDF,AGI,LUK）
#
# 記入例:最大HPが600以上の時使用可能にする場合
#
# <使用条件:MHP,600,以上>
#------------------------------------------------------------------------------
# ★追加能力値★（デフォルト設定用ワード　HIT,EVA,CRI,CEV,MEV,MRF,CNT,HRG,MRG,TRG）
#
# 記入例:回避率が10％以下の時使用可能にする場合
#
# <使用条件:EVA,10,以下>
#------------------------------------------------------------------------------
# ★特殊能力値★（デフォルト設定用ワード　TGR,GRD,REC,PHA,MCR,TCR,PDR,MDR,FDR,EXR）
#
# 記入例:狙われ率が0以外の時使用可能にする場合
#
# <使用条件:TGR,0,以外>
#------------------------------------------------------------------------------
# ☆敵/味方生存数☆（デフォルト設定用ワード　OPA/FRA）
#
# 記入例:敵の生存数が5以上の時使用可能にする場合
#
# <使用条件:OPA,5,以上>
#
# 記入例:味方の生存数が3未満の時使用可能にする場合
#
# <使用条件:FRA,3,未満>
#------------------------------------------------------------------------------
# ☆敵/味方死亡数☆（デフォルト設定用ワード　OPD/FRD）
#
# 記入例:敵の死亡数が3以下の時使用可能にする場合
#
# <使用条件:OPD,3,以下>
#
# 記入例:味方の死亡数が2以外の時使用可能にする場合
#
# <使用条件:FRD,2,以外>
#------------------------------------------------------------------------------
# ☆敵/味方行動可能数☆（デフォルト設定用ワード　OPM/FRM）
#
# 記入例:敵の行動可能数が4以外の時使用可能にする場合
#
# <使用条件:OPM,4,以外>
#
# 記入例:味方の行動可能数が3の時使用可能にする場合
#
# <使用条件:FRM,3,同値>
#------------------------------------------------------------------------------
# ☆敵/味方行動不能数☆（デフォルト設定用ワード　ONM/FNM）
#
# 記入例:敵の行動不能数が1の時使用可能にする場合
#
# <使用条件:ONM,1,同値>
#
# 記入例:味方の行動不能数が1以上の時使用可能にする場合
#
# <使用条件:FNM,1,以上>
#------------------------------------------------------------------------------
# ☆敵/味方現在HP合計値☆（デフォルト設定用ワード　OHT/FHT）
#
# 記入例:敵全体のHP合計値が1000未満の時使用可能にする場合
#
# <使用条件:OHT,1000,未満>
#
# 記入例:味方全体のHP合計値が1000未満の時使用可能にする場合
#
# <使用条件:FHT,1000,未満>
#------------------------------------------------------------------------------
# ☆敵/味方現在MP合計値☆（デフォルト設定用ワード　OMT/FMT）
#
# 記入例:敵のMP合計値が600以下の時使用可能にする場合
#
# <使用条件:OMT,600,以下>
#
# 記入例:味方のMP合計値が600以下の時使用可能にする場合
#
# <使用条件:FMT,600,以下>
#------------------------------------------------------------------------------
# ☆敵/味方現在TP合計値☆（デフォルト設定用ワード　OTT/FTT）
#
# 記入例:敵のTP合計値が150以上の時使用可能にする場合
#
# <使用条件:OTT,150,以上>
#
# 記入例:味方のTP合計値が150以上の時使用可能にする場合
#
# <使用条件:FTT,150,以上>
#==============================================================================
# スイッチを使用する場合は、若干特殊な記述となります。
#==============================================================================
# ☆スイッチ☆（デフォルト設定用ワード　SWT）
#
# 記入例:スイッチID25がONの時使用可能にする場合
#
# <使用条件:SWT,25,ON>
#
# 記入例:スイッチID52がOFFの時使用可能にする場合
#
# <使用条件:SWT,52,OFF>
#==============================================================================
# ステートやパーティ内にいるかどうかの判定（アクター限定）を使用する場合も
# 若干特殊な記述となります。
#==============================================================================
# ★ステート★（デフォルト設定用ワード　STT）
#
# 記入例:ステートID3が付与されている時使用可能にする場合
#
# <使用条件:STT,3,前提>
#
# 記入例:スイッチID6が付与されていない時使用可能にする場合
#
# <使用条件:STT,6,禁止>
#------------------------------------------------------------------------------
# ★パーティ内にいるかどうか★（デフォルト設定用ワード　API）
#
#   アクターの場合（~A:1,3,5~と併せて使用する事を想定しています）
#
# 記入例:指定アクターがパーティにいない場合のみ使用可能にする場合
#
# <使用条件:API,禁止,禁止>
#
# 記入例:指定アクターがパーティにいて、なおかつ戦闘メンバーにいない場合のみ使用可能にする場合
#
# <使用条件:API,前提,禁止>
#
# 記入例:指定アクターがパーティにいて、なおかつ戦闘メンバーにいる場合のみ使用可能にする場合
#
# <使用条件:API,前提,前提>
#
#   エネミーの場合（~E:200,201~と併せて使用する事を想定しています）
#
# 記入例:指定エネミーが敵グループにいない場合のみ使用可能にする場合
#
# <使用条件:API,禁止,禁止>
#
# 記入例:指定エネミーが敵グループにいて、なおかつ隠れている場合のみ使用可能にする場合
#
# <使用条件:API,前提,禁止>
#
# 記入例:指定エネミーが敵グループにいて、なおかつ隠れていない場合のみ使用可能にする場合
#
# <使用条件:API,前提,前提>
#==============================================================================
# スクリプトで判定させる場合は、かなり特殊な記述となります。
# ここでは、対象者を示す単語としてaを用います。
# aのHPであれば、a.hp、aのMPであれば、a.mp等。
#==============================================================================
# ★スクリプト★（デフォルト設定用ワード　SCR）
#
# 記入例:スキルID2を覚えている場合は使用可能。エラーになる場合も使用可能
#
# <使用条件:SCR,OK,a.skill_learn?($data_skills[2])>
#
# 記入例:防具100を装備している場合は使用可能。エラーになる場合も使用不可
#
# <使用条件:SCR,NG,a.armors.include?($data_armors[100])>
#
# 記入例:セーブ回数が999回より多い場合のみ使用可能。エラーになる場合も使用不可
#
# <使用条件:SCR,NG,999<$game_systems.save_count>
#==============================================================================
# 以下の項目はメモ欄記入時の設定項目が4つあり
# データを数値化した物を以て使用条件に合致しているか判断します。
#==============================================================================
# ★現在HP★（デフォルト設定用ワード　HP）
#
# 記入例:HPが500以上の時使用可能にする場合
#
# <使用条件:HP,数値,500,以上>
#------------------------------------------------------------------------------
# ★現在MP★（デフォルト設定用ワード　MP）
#
# 記入例:MPが50％以下の時使用可能にする場合
#
# <使用条件:MP,割合,50,以下>
#------------------------------------------------------------------------------
# ★現在TP★（デフォルト設定用ワード　TP）
#
# 記入例:TPが0以外の時使用可能にする場合
#
# <使用条件:TP,数値,0,以外>
#------------------------------------------------------------------------------
# ★属性有効度★（デフォルト設定用ワード　ELP）
#
# 記入例:属性ID3の属性有効度が50％と同値の時使用可能にする場合
#
# <使用条件:ELP,3,50,同値>
#------------------------------------------------------------------------------
# ★弱体有効度★（デフォルト設定用ワード　DBP）
#
# 弱体有効度の対象能力指定は0が最大HP、1が最大MP、2が攻撃力、3が防御力……
# 7が運まで続きます
#
# 記入例:運の弱体有効度が100％と同値の時使用可能にする場合
# <使用条件:DBP,7,100,同値>
#------------------------------------------------------------------------------
# ★ステート有効度★（デフォルト設定用ワード　STP）
#
# 記入例:ステートID2のステート有効度が100％と同値の時使用可能にする場合
# <使用条件:STP,2,100,同値>
#------------------------------------------------------------------------------
# ☆変数☆（デフォルト設定用ワード　VAR）
#
# 記入例:変数1が25よりも上の数値の時使用可能にする場合
#
# <使用条件:VAR,1,25,超過>
#------------------------------------------------------------------------------
# ☆特定ステートにかかっている者の数☆（デフォルト設定用ワード　OPS/FRS）
#
# 記入例:敵のステートID3にかかっている数が2以上の時使用可能にする場合
#
# <使用条件:OPS,3,2,以上>
#
# 記入例:味方のステートID3にかかっている数が2以上の時使用可能にする場合
#
# <使用条件:FRS,3,2,以上>
#------------------------------------------------------------------------------
# ☆現在HP平均値☆（デフォルト設定用ワード　OHA/FHA）
#
# 記入例:敵のHP平均値が1000未満の時使用可能にする場合
#
# <使用条件:OHA,数値,1000,未満>
#
# 記入例:味方のHP平均値が1000未満の時使用可能にする場合
#
# <使用条件:FHA,数値,1000,未満>
#------------------------------------------------------------------------------
# ☆現在MP平均値☆（デフォルト設定用ワード　OMA/FMA）
#
# 記入例:敵のMP平均割合が60％以下の時使用可能にする場合
#
# <使用条件:OMA,割合,60,以下>
#
# 記入例:味方のMP平均割合が60％以下の時使用可能にする場合
#
# <使用条件:FMA,割合,60,以下>
#------------------------------------------------------------------------------
# ☆現在TP平均値☆（デフォルト設定用ワード　OTA/FTA）
#
# 記入例:敵のTP平均値が0以上の時使用可能にする場合
#
# <使用条件:OTA,数値,0,以上>
#
# 記入例:味方のTP平均値が0以上の時使用可能にする場合
#
# <使用条件:FTA,数値,0,以上>
#==============================================================================
# 同じ行に下記の7つの何れかを併せて記述する事で
# 判定対象をスキル使用者を基にした判定から変化させる事が出来ます。
#
# ただし、元々味方全体や敵全体に判定を行う条件（OPS等）の場合は
# 無駄な負荷をかけるだけの為、使用しない方が賢明でしょう。
# （無意味な種類の物は名前の両端を☆で囲んでいます）
# また、複数記入した場合は、味方全体＞敵全体＞敵味方全体＞その他の順に
# 優先度が高いです。
#------------------------------------------------------------------------------
# *味全*
# →条件の判定を味方(アクター側ならパーティ、エネミー側なら敵グループ)全体とする。
#
# *敵全*
# →条件の判定を敵(アクター側なら敵グループ、エネミー側ならパーティ)全体とする。
#
# *敵味全*
# →条件の判定を敵味方全体とする。
#
# ~A:1,3,5~
# →条件の判定をアクター1、3、5とする。
#（メンバーに含まれなくてもいい）
#
# ~P:2,4~
# →条件の判定をパーティ戦闘メンバーの先頭から2番目と4番目のアクターとする。
#（存在しない場合は条件を満たさないものとする）
#
# ~E:200,201~
# →条件の判定を敵グループ内のエネミーID200と201の敵とする。
#（存在しない場合は条件を満たさないものとする）
#
# ~T:1,2,3~
# →条件の判定を敵グループ内の先頭メンバー・2番目のメンバー・3番目のメンバーとする。
#（存在しない場合は条件を満たさないものとする）
#==============================================================================
# 使用条件をアクター限定にする場合、その使用条件と同じ行に
# 「アクター用」と記入する事で、その条件はアクターが使う場合のみ判定されます。
# 
# また、エネミー用にする場合は、同じくその使用条件と同じ行に
# 「エネミー用」と記入する事で、エネミー用使用条件となります。
# （共に鍵括弧は含みません）
#------------------------------------------------------------------------------
# 参考までに、極端に長い例を記します。
#
# 敵味方全員のTPが30％より上で味方全員のMPが50以上で敵全員の最大HPが500以下で
# 更に自分の攻撃力が150以上かつ魔法力が100未満、そしてスイッチ1がONの時使用可能。
# 使用者がアクターの場合は戦闘メンバーの2番目と3番目と4番目が
# 存在していることが条件となる。
#
# *敵味全*<使用条件:TP,割合,30,超過>
# *味全*<使用条件:MP,数値,50,以上>
# *敵全*<使用条件:MHP,500,以下>
# <使用条件:ATK,150,以上>
# <使用条件:MAT,100,未満>
# <使用条件:SWT,1,ON>
# アクター用~P:2,3,4~<使用条件:API,前提,前提>
#==============================================================================
# Ver1.01
# - 使用条件で割合・平均値を選択した場合に
#   正常に使用条件が反映されない不具合を修正しました。
# Ver1.02
# - 動作を軽量化しました。
# - 特定のアクター・パーティの戦闘メンバー・エネミー・敵グループへの
#   対象設定が可能になりました。
# - アクター/エネミーが存在するか否かでの使用条件設定が可能になりました。
# - スクリプトによる条件設定が可能になりました。
#==============================================================================
module IS_USABLE
  
  #使用条件用ワード
  
  WORD_BASE = "使用条件"
  
  #アクター専用条件化
  
  WORD_ACTOR = "アクター用"
  
  #エネミー専用条件化
  
  WORD_ENEMY = "エネミー用"
  
  #条件の判別を味方全体化
  
  WORD_F_ALL = "*味全*"
  
  #条件の判別を敵全体化
  
  WORD_O_ALL = "*敵全*"
  
  #条件の判別を敵・味方全体化
  
  WORD_A_ALL = "*敵味全*"
  
  #条件の判別を味方全体化
  
  WORD_ACTOR_A = "A"
  
  #条件の判別を味方全体化
  
  WORD_PARTY_P = "P"
  
  #条件の判別を味方全体化
  
  WORD_ENEMY_E = "E"
  
  #条件の判別を味方全体化
  
  WORD_TROOP_T = "T"
  
  #能力値・変数の場合の設定
  #～より上
  
  WORD_A = "超過"
  
  #～以上
  
  WORD_B = "以上"
  
  #～より下
  
  WORD_C = "未満"
  
  #～以下
  
  WORD_D = "以下"
  
  #～と同じ数値
  
  WORD_E = "同値"
  
  #～と同じ数値ではない
  
  WORD_F = "以外"
  
  #スイッチの場合の設定
  #ONの場合
  
  WORD_G = "ON"
  
  #OFFの場合
  
  WORD_H = "OFF"
  
  #ステート・パーティの場合の設定
  #ONの場合
  
  WORD_I = "前提"
  
  #OFFの場合
  
  WORD_J = "禁止"
  
  #数値単位の指定（現在HP・現在MP・現在TP関連のみ有効）
  #ONの場合
  
  WORD_K = "数値"
  
  #OFFの場合
  
  WORD_L = "割合"
  
  #スクリプトの場合、エラーとなった際の設定
  #ONの場合
  
  WORD_M = "OK"
  
  #OFFの場合
  
  WORD_N = "NG"
  
  #能力値名設定
  #現在HP
  
  WORD1 = "HP"
  
  #現在MP
  
  WORD2 = "MP"
  
  #現在TP
  
  WORD3 = "TP"
  
  #最大HP
  
  WORD4 = "MHP"
  
  #最大MP
  
  WORD5 = "MMP"
  
  #攻撃力
  
  WORD6 = "ATK"
  
  #防御力
  
  WORD7 = "DEF"
  
  #魔法力
  
  WORD8 = "MAT"
  
  #魔法防御
  
  WORD9 = "MDF"
  
  #敏捷性
  
  WORD10 = "AGI"
  
  #運
  
  WORD11 = "LUK"
  
  #命中率
  
  WORD12 = "HIT"
  
  #回避率
  
  WORD13 = "EVA"
  
  #会心率
  
  WORD14 = "CRI"
  
  #会心回避率
  
  WORD15 = "CEV"
  
  #魔法回避率
  
  WORD16 = "MEV"
  
  #魔法反射率
  
  WORD17 = "MRF"
  
  #反撃率
  
  WORD18 = "CNT"
  
  #HP再生率
  
  WORD19 = "HRG"
  
  #MP再生率
  
  WORD20 = "MRG"
  
  #TP再生率
  
  WORD21 = "TRG"
  
  #狙われ率
  
  WORD22 = "TGR"
  
  #防御効果率
  
  WORD23 = "GRD"
  
  #回復効果率
  
  WORD24 = "REC"
  
  #薬の知識
  
  WORD25 = "PHA"
  
  #MP消費率
  
  WORD26 = "MCR"
  
  #TPチャージ率
  
  WORD27 = "TCR"
  
  #物理ダメージ率
  
  WORD28 = "PDR"
  
  #魔法ダメージ率
  
  WORD29 = "MDR"
  
  #床ダメージ率
  
  WORD30 = "FDR"
  
  #経験獲得率
  
  WORD31 = "EXR"
  
  #属性有効度
  
  WORD32 = "ELP"
  
  #弱体有効度
  
  WORD33 = "DBP"
  
  #ステート有効度
  
  WORD34 = "STP"
  
  #ステート
  
  WORD35 = "STT"
  
  #スイッチ
  
  WORD36 = "SWT"
  
  #変数
  
  WORD37 = "VAR"
  
  #敵で特定ステートにかかっている者の数
  
  WORD38 = "OPS"
  
  #味方で特定ステートにかかっている者の数
  
  WORD39 = "FRS"
  
  #敵で生存している者の数
  
  WORD40 = "OPA"
  
  #味方で生存している者の数
  
  WORD41 = "FRA"
  
  #敵で死亡している者の数
  
  WORD42 = "OPD"
  
  #味方で死亡している者の数
  
  WORD43 = "FRD"
  
  #敵で行動可能者の数
  
  WORD44 = "OPM"
  
  #味方で行動可能者の数
  
  WORD45 = "FRM"
  
  #敵で行動不能者の数
  
  WORD46 = "ONM"
  
  #味方で行動不能者の数
  
  WORD47 = "FNM"
  
  #敵の現在HP平均値
  
  WORD48 = "OHA"
  
  #味方の現在HP平均値
  
  WORD49 = "FHA"
  
  #敵の現在MP平均値
  
  WORD50 = "OMA"
  
  #味方の現在MP平均値
  
  WORD51 = "FMA"
  
  #敵の現在TP平均値
  
  WORD52 = "OTA"
  
  #味方の現在TP平均値
  
  WORD53 = "FTA"
  
  #敵の現在HP合計値
  
  WORD54 = "OHT"
  
  #味方の現在HP合計値
  
  WORD55 = "FHT"
  
  #敵の現在MP合計値
  
  WORD56 = "OMT"
  
  #味方の現在MP合計値
  
  WORD57 = "FMT"
  
  #敵の現在TP合計値
  
  WORD58 = "OTT"
  
  #味方の現在TP合計値
  
  WORD59 = "FTT"
  
  #パーティ/敵グループ内にいるかどうかの判定
  #アクターの場合はパーティにいるか否かと戦闘メンバーにいるか否か
  #エネミーの場合は敵グループにいるか否かと隠れているか否かを判定
  
  WORD60 = "API"
  
  #スクリプトを用いた特殊な判定
  #スクリプトにある程度理解がある方向け
  
  WORD61 = "SCR"

end

class Game_BattlerBase
  #--------------------------------------------------------------------------
  # スキル／アイテムの共通使用可能条件チェック1
  #--------------------------------------------------------------------------
  alias usable_item_conditions_met_ex1? usable_item_conditions_met?
  def usable_item_conditions_met?(item)
    
    #本来の処理と追加条件を判定する。
    #両方の条件を満たしているか否かを返す。
    
    usable_item_conditions_met_ex1?(item) && usable_item_conditions_met_ex2?(item)
    
  end
  #--------------------------------------------------------------------------
  # スキル／アイテムの共通使用可能条件チェック2
  #--------------------------------------------------------------------------
  def usable_item_conditions_met_ex2?(item)
    
    #追加条件のハッシュを取得する。
    
    base_data = item.use_condition_array
    
    #追加条件が何も存在しない場合はtrueを返す。
    
    return true if base_data.empty?
    
    #追加条件をそれぞれ判定する。
    
    base_data.each {|use_condition|
    
    #条件がアクター専用/エネミー専用か否かを判定し
    #当てはまらない場合は処理を飛ばす。
    
    case use_condition[:user_type]
    
    #アクター専用
    
    when 1;next if !self.actor?
    
    #エネミー専用
    
    when 2;next if self.actor?
    
    end
    
    #データタイプを初期化する。
    
    data_type = 0
    
    #判定対象を取得する。
    
    case use_condition[:condition_target]
    
    #明確な設定が無い場合、まず対象用の空の配列を作成する。
    
    when 0;condition_target = []
      
      #アクター用配列が空ではない時
      
      if !use_condition[:array_a].empty?
        
        #配列の要素別に判定する。
        
        use_condition[:array_a].each {|i|
        
        #対象の配列に加える。
        
        condition_target.push($game_actors[i])
        
        }
        
      #パーティ用配列が空ではない時
      
      elsif !use_condition[:array_p].empty?
        
        #配列の要素別に判定する。
        
        ma = $game_party.members
        
        use_condition[:array_p].each {|i|
        
        #該当者を取得。
        
        m = ma[i - 1]
        
        return false unless m
        
        #該当者が存在する場合は対象の配列に加える。
        
        condition_target.push(m)
        
        }
      
      #エネミー用配列が空ではない時
      
      elsif !use_condition[:array_e].empty?
        
        #配列の要素別に判定する。
        
        use_condition[:array_e].each {|i|
        
        #該当するエネミーIDを持つ敵を選別する。
        
        tm = $game_troop.members.select {|m| m.enemy_id == i}
        
        #対象の配列に加える。
        
        condition_target = condition_target + tm unless tm.empty?
        
        }
      
      #敵グループ用配列が空ではない時
      
      elsif !use_condition[:array_t].empty?
        
        #配列の要素別に判定する。
        
        ma = $game_troop.members
        
        use_condition[:array_t].each {|i|
        
        #該当者を取得。
        
        m = ma[i - 1]
        
        return false unless m
        
        #該当者が存在する場合は対象の配列に加える。
        
        condition_target.push(m)
        
        }
      
      #どれにも該当しない時（自分のみ）
      
      else;condition_target.push(self)
        
      end
      
    #味方グループの場合
    
    when 1;condition_target = friends_unit.members
      
    #敵グループの場合
    
    when 2;condition_target = opponents_unit.members
      
    #敵グループと味方グループ全体の場合
    
    when 3;condition_target = friends_unit.members + opponents_unit.members
      
    end
    
    #該当者が存在しない場合はfalseを返す。
    
    return false if condition_target.empty?
    
    #判定対象別に条件を判定する。
    
    condition_target.each {|character|
    
    #対象が存在しない場合は飛ばす。
    
    next unless character
    
    #条件の配列を取得する。
    
    array = use_condition[:array]
    
    #配列の1つ目の値で種類分けを行う。
    
    case array[0]
    
    #現在HP（データタイプ1）
    
    when IS_USABLE::WORD1;data_type = 1
      
      #配列の2番目の文字列で数値か割合かを判定。
      
      case array[1]
      
      #数値の場合
      
      when IS_USABLE::WORD_K;data = character.hp
        
      #割合の場合
      
      when IS_USABLE::WORD_L;data = character.hp_rate * 100
        
      end
      
    #現在MP（データタイプ1）
    
    when IS_USABLE::WORD2;data_type = 1
      
      #配列の2番目の文字列で数値か割合かを判定。
      
      case array[1]
      
      #数値の場合
      
      when IS_USABLE::WORD_K;data = character.mp
        
      #割合の場合
        
      when IS_USABLE::WORD_L;data = character.mp_rate * 100
        
      end
      
    #現在TP（データタイプ1）
    
    when IS_USABLE::WORD3;data_type = 1
      
      #配列の2番目の文字列で数値か割合かを判定。
      
      case array[1]
      
      #数値の場合
      
      when IS_USABLE::WORD_K;data = character.tp
        
      #割合の場合
        
      when IS_USABLE::WORD_L;data = character.tp_rate * 100
        
      end
      
    #最大HP（データタイプ0）
    
    when IS_USABLE::WORD4;data = character.param(0)
      
    #最大MP（データタイプ0）
    
    when IS_USABLE::WORD5;data = character.param(1)
    
    #攻撃力（データタイプ0）
    
    when IS_USABLE::WORD6;data = character.param(2)
    
    #防御力（データタイプ0）
    
    when IS_USABLE::WORD7;data = character.param(3)
    
    #魔法力（データタイプ0）
    
    when IS_USABLE::WORD8;data = character.param(4)
    
    #魔法防御（データタイプ0）
    
    when IS_USABLE::WORD9;data = character.param(5)
    
    #敏捷性（データタイプ0）
    
    when IS_USABLE::WORD10;data = character.param(6)
    
    #運（データタイプ0）
    
    when IS_USABLE::WORD11;data = character.param(7)
    
    #命中率（データタイプ0）
    
    when IS_USABLE::WORD12;data = character.xparam(0) * 100
    
    #回避率（データタイプ0）
    
    when IS_USABLE::WORD13;data = character.xparam(1) * 100
    
    #会心率（データタイプ0）
    
    when IS_USABLE::WORD14;data = character.xparam(2) * 100
    
    #会心回避率（データタイプ0）
    
    when IS_USABLE::WORD15;data = character.xparam(3) * 100
    
    #魔法回避率（データタイプ0）
    
    when IS_USABLE::WORD16;data = character.xparam(4) * 100
    
    #魔法反射率（データタイプ0）
    
    when IS_USABLE::WORD17;data = character.xparam(5) * 100
    
    #反撃率（データタイプ0）
    
    when IS_USABLE::WORD18;data = character.xparam(6) * 100
    
    #HP再生率（データタイプ0）
    
    when IS_USABLE::WORD19;data = character.xparam(7) * 100
    
    #MP再生率（データタイプ0）
    
    when IS_USABLE::WORD20;data = character.xparam(8) * 100
    
    #TP再生率（データタイプ0）
    
    when IS_USABLE::WORD21;data = character.xparam(9) * 100
    
    #狙われ率（データタイプ0）
    
    when IS_USABLE::WORD22;data = character.sparam(0) * 100
    
    #防御効果率（データタイプ0）
    
    when IS_USABLE::WORD23;data = character.sparam(1) * 100
    
    #回復効果率（データタイプ0）
    
    when IS_USABLE::WORD24;data = character.sparam(2) * 100
    
    #薬の知識（データタイプ0）
    
    when IS_USABLE::WORD25;data = character.sparam(3) * 100
    
    #MP消費率（データタイプ0）
    
    when IS_USABLE::WORD26;data = character.sparam(4) * 100
    
    #TPチャージ率（データタイプ0）
    
    when IS_USABLE::WORD27;data = character.sparam(5) * 100
    
    #物理ダメージ率（データタイプ0）
    
    when IS_USABLE::WORD28;data = character.sparam(6) * 100
    
    #魔法ダメージ率（データタイプ0）
    
    when IS_USABLE::WORD29;data = character.sparam(7) * 100
    
    #床ダメージ率（データタイプ0）
    
    when IS_USABLE::WORD30;data = character.sparam(8) * 100
    
    #経験獲得率（データタイプ0）
    
    when IS_USABLE::WORD31;data = character.sparam(9) * 100
    
    #属性有効度（データタイプ1）
      
    when IS_USABLE::WORD32;data_type = 1
      
      data = character.element_rate(array[1].to_i) * 100
    
    #弱体有効度（データタイプ1）
    
    when IS_USABLE::WORD33;data_type = 1
      
      data = character.debuff_rate(array[1].to_i) * 100
    
    #ステート有効度（データタイプ1）
    
    when IS_USABLE::WORD34;data_type = 1
      
      data = character.state_rate(array[1].to_i) * 100
    
    #ステート（データタイプ2）
    
    when IS_USABLE::WORD35;data_type = 2
    
    #スイッチ（データタイプ3）
      
    when IS_USABLE::WORD36;data_type = 3
    
    #変数（データタイプ1）
      
    when IS_USABLE::WORD37;data_type = 1
      
      data = $game_variables[(array[1]).to_i]
    
    #敵で特定ステートにかかっている者の数（データタイプ1）
      
    when IS_USABLE::WORD38;data_type = 1
      
      data = opponents_unit.members_state_check((array[1]).to_i)
    
    #味方で特定ステートにかかっている者の数（データタイプ1）
      
    when IS_USABLE::WORD39;data_type = 1
      
      data = friends_unit.members_state_check((array[1]).to_i)
    
    #敵で生存している者の数（データタイプ0）
      
    when IS_USABLE::WORD40;data = opponents_unit.alive_members.size
    
    #味方で生存している者の数（データタイプ0）
      
    when IS_USABLE::WORD41;data = friends_unit.alive_members.size
    
    #敵で死亡している者の数（データタイプ0）
      
    when IS_USABLE::WORD42;data = opponents_unit.dead_members.size
    
    #味方で死亡している者の数（データタイプ0）
      
    when IS_USABLE::WORD43;data = friends_unit.dead_members.size
    
    #敵で行動可能者の数（データタイプ0）
      
    when IS_USABLE::WORD44;data = opponents_unit.movable_members_ex.size
    
    #味方で行動可能者の数（データタイプ0）
      
    when IS_USABLE::WORD45;data = friends_unit.movable_members_ex.size
    
    #敵で行動不能者の数（データタイプ0）
      
    when IS_USABLE::WORD46;data = opponents_unit.not_movable_members_ex.size
    
    #味方で行動不能者の数（データタイプ0）
      
    when IS_USABLE::WORD47;data = friends_unit.not_movable_members_ex.size
    
    #敵の現在HP平均値（データタイプ1）
      
    when IS_USABLE::WORD48;data_type = 1
      
      #配列の2番目の文字列で数値か割合かを判定。
      
      case array[1]
      
      #数値の場合
      
      when IS_USABLE::WORD_K;data = opponents_unit.hp(0)
        
      #割合の場合
        
      when IS_USABLE::WORD_L;data = opponents_unit.hp(1)
        
      end
    
    #味方の現在HP平均値（データタイプ1）
      
    when IS_USABLE::WORD49;data_type = 1
      
      #配列の2番目の文字列で数値か割合かを判定。
      
      case array[1]
      
      #数値の場合
      
      when IS_USABLE::WORD_K;data = friends_unit.hp(0)
        
      #割合の場合
        
      when IS_USABLE::WORD_L;data = friends_unit.hp(1)
        
      end
    
    #敵の現在MP平均値（データタイプ1）
      
    when IS_USABLE::WORD50;data_type = 1
      
      #配列の2番目の文字列で数値か割合かを判定。
      
      case array[1]
      
      #数値の場合
      
      when IS_USABLE::WORD_K;data = opponents_unit.mp(0)
        
      #割合の場合
        
      when IS_USABLE::WORD_L;data = opponents_unit.mp(1)
        
      end
    
    #味方の現在MP平均値（データタイプ1）
      
    when IS_USABLE::WORD51;data_type = 1
      
      #配列の2番目の文字列で数値か割合かを判定。
      
      case array[1]
      
      #数値の場合
      
      when IS_USABLE::WORD_K;data = friends_unit.mp(0)
        
      #割合の場合
        
      when IS_USABLE::WORD_L;data = friends_unit.mp(1)
        
      end
    
    #敵の現在TP平均値（データタイプ1）
      
    when IS_USABLE::WORD52;data_type = 1
      
      #配列の2番目の文字列で数値か割合かを判定。
      
      case array[1]
      
      #数値の場合
      
      when IS_USABLE::WORD_K;data = opponents_unit.tp(0)
        
      #割合の場合
        
      when IS_USABLE::WORD_L;data = opponents_unit.tp(1)
        
      end
    
    #味方の現在TP平均値（データタイプ1）
      
    when IS_USABLE::WORD53;data_type = 1
      
      #配列の2番目の文字列で数値か割合かを判定。
      
      case array[1]
      
      #数値の場合
      
      when IS_USABLE::WORD_K;data = friends_unit.tp(0)
        
      #割合の場合
        
      when IS_USABLE::WORD_L;data = friends_unit.tp(1)
        
      end
    
    #敵の現在HP合計値（データタイプ0）
    
    when IS_USABLE::WORD54;data = opponents_unit.hptotal
    
    #味方の現在HP合計値（データタイプ0）
    
    when IS_USABLE::WORD55;data = friends_unit.hptotal
    
    #敵の現在MP合計値（データタイプ0）
    
    when IS_USABLE::WORD56;data = opponents_unit.mptotal
    
    #味方の現在MP合計値（データタイプ0）
    
    when IS_USABLE::WORD57;data = friends_unit.mptotal
    
    #敵の現在TP合計値（データタイプ0）
    
    when IS_USABLE::WORD58;data = opponents_unit.tptotal
    
    #味方の現在TP合計値（データタイプ0）
    
    when IS_USABLE::WORD59;data = friends_unit.tptotal
    
    #味方の現在TP合計値（データタイプ4）
    
    when IS_USABLE::WORD60;data_type = 4
    
    #スクリプト（データタイプ5）
    
    when IS_USABLE::WORD61;data_type = 5
      
    end
    
    #データタイプで分岐。
    
    case data_type
    
    #データタイプが0の場合、まず取得したデータを整数化してから処理を続行。
    
    when 0;data = data.to_i
      
      #配列内の3番目の文字列で分岐。
      
      case array[2]
      
      #超過
      
      when IS_USABLE::WORD_A;return false if data <= array[1].to_i
      
      #以上
      
      when IS_USABLE::WORD_B;return false if data < array[1].to_i
      
      #未満
      
      when IS_USABLE::WORD_C;return false if data >= array[1].to_i
      
      #以下
      
      when IS_USABLE::WORD_D;return false if data > array[1].to_i
      
      #同値
      
      when IS_USABLE::WORD_E;return false if data != array[1].to_i
      
      #以外
      
      when IS_USABLE::WORD_F;return false if data == array[1].to_i
        
      end
    
    #データタイプが1の場合、まず取得したデータを整数化してから処理を続行。
    
    when 1;data = data.to_i
      
      #配列内の4番目の文字列で分岐。
      
      case array[3]
      
      #超過
      
      when IS_USABLE::WORD_A;return false if data <= array[2].to_i
      
      #以上
      
      when IS_USABLE::WORD_B;return false if data < array[2].to_i
      
      #未満
      
      when IS_USABLE::WORD_C;return false if data >= array[2].to_i
      
      #以下
      
      when IS_USABLE::WORD_D;return false if data > array[2].to_i
      
      #同値
      
      when IS_USABLE::WORD_E;return false if data != array[2].to_i
      
      #以外
      
      when IS_USABLE::WORD_F;return false if data == array[2].to_i
        
      end
    
    #データタイプが2の場合
    
    when 2
      
      #ステートIDを取得。
      
      data = array[1].to_i
      
      #配列内の3番目の文字列で分岐。
      
      case array[2]
      
      #ステートにかかっているか？
      
      when IS_USABLE::WORD_I;return false unless character.state?(data)
      
      #ステートにかかっていないか？
      
      when IS_USABLE::WORD_J;return false if character.state?(data)
      
      end
    
    #データタイプが3の場合
    
    when 3
      
      #スイッチIDを取得。
      
      data = $game_switches[(array[1]).to_i]
      
      #配列内の3番目の文字列で分岐。
      
      case array[2]
      
      #スイッチがONか？
      
      when IS_USABLE::WORD_G;return false unless data
      
      #スイッチがOFFか？
      
      when IS_USABLE::WORD_H;return false if data
      
      end
    
    #データタイプが4の場合
    
    when 4
      
      #キャラクターがアクターかどうかを判定。
      
      if character.actor?
        
        #配列の2番目の文字列で分岐。
        
        case array[1]
        
        #PT内にいなければならないか？
        
        when IS_USABLE::WORD_I;
          
          return false unless $game_party.all_members.include?(character)
        
          #配列の3番目の文字列で分岐。
          
          case array[2]
          
          #戦闘メンバー内にいなければならないか？
          
          when IS_USABLE::WORD_I;return false unless $game_party.members.include?(character)
          
          #戦闘メンバー内にいてはならないか？
          
          when IS_USABLE::WORD_J;return false if $game_party.members.include?(character)
          end
          
        #PT内にいてはならないか？
        
        when IS_USABLE::WORD_J;return false if $game_party.all_members.include?(character)
        
        end
        
      else
        
        #配列の2番目の文字列で分岐。
        
        case array[1]
        
        #PT内にいなければならないか？
        
        when IS_USABLE::WORD_I;
          
          return false unless $game_troop.members.include?(character)
        
          #配列の3番目の文字列で分岐。
          
          case array[2]
          
          #戦闘メンバー内にいなければならないか？
          
          when IS_USABLE::WORD_I;return false unless character.hidden?
          
          #戦闘メンバー内にいてはならないか？
          
          when IS_USABLE::WORD_J;return false if character.hidden?
          end
          
        #PT内にいてはならないか？
        
        when IS_USABLE::WORD_J;return false if $game_troop.members.include?(character)
        
        end
      
      end
    
    #データタイプが5の場合
    
    when 5
      
      begin
        
        #配列の3番目の文字列をスクリプトとして実行。
        
        a = character
        
        return false unless eval(array[2])
        
      rescue
        
        #エラーとなった場合は、配列の2番目の文字列で分岐。
        
        case array[1]
        
        #OKの場合は次の条件の処理を行う。
        
        when IS_USABLE::WORD_M;next
        
        #NGの場合はfalseを返す。
        
        when IS_USABLE::WORD_N;return false
        end
        
      end
      
    end
    }
    }
    
    #全ての条件を満たすのでtrueを返す。
    
    true
    
  end
end
class Game_Unit
  #--------------------------------------------------------------------------
  # 隠れていないメンバーの配列取得
  #--------------------------------------------------------------------------
  def unhidden_members
    members.select {|member| !member.hidden?}
  end
  #--------------------------------------------------------------------------
  # 行動可能なメンバーの配列取得
  #--------------------------------------------------------------------------
  def movable_members_ex
    unhidden_members.select {|member| member.movable?}
  end
  #--------------------------------------------------------------------------
  # 行動不能なメンバーの配列取得
  #--------------------------------------------------------------------------
  def not_movable_members_ex
    unhidden_members.select {|member| !member.movable?}
  end
  #--------------------------------------------------------------------------
  # メンバーステートチェック
  #--------------------------------------------------------------------------
  def members_state_check(state_id)
    
    #初期値を取得。
    
    data = 0
    
    #メンバーが該当ステートを付与されている場合はデータに1加算。
    
    members.each {|i| data += 1 if i.state?(state_id)}
    
    #データを返す。
    
    data
  end
  #--------------------------------------------------------------------------
  # HPの平均値を計算
  #--------------------------------------------------------------------------
  def hp(type)
    
    #メンバーの配列を取得。
    
    ma = members
    
    #メンバー数が0の場合は0を返す。
    
    return 0 if ma.size == 0
    
    #タイプ別に処理
    
    case type
    
    #タイプが0の場合
    
    when 0;ma.inject(0) {|r, member| r += member.hp} / ma.size
    
    #タイプが1の場合
    
    when 1;ma.inject(0) {|r, member| r += member.hp_rate * 100} / ma.size
    end
  end
  #--------------------------------------------------------------------------
  # MPの平均値を計算
  #--------------------------------------------------------------------------
  def mp(type)
    
    #メンバーの配列を取得。
    
    ma = members
    
    #メンバー数が0の場合は0を返す。
    
    return 0 if ma.size == 0
    
    #タイプ別に処理
    
    case type
    
    #タイプが0の場合
    
    when 0;ma.inject(0) {|r, member| r += member.mp} / ma.size
    
    #タイプが1の場合
    
    when 1;ma.inject(0) {|r, member| r += member.mp_rate * 100} / ma.size
    
    end
  end
  #--------------------------------------------------------------------------
  # TPの平均値を計算
  #--------------------------------------------------------------------------
  def tp(type)
    
    #メンバーの配列を取得。
    
    ma = members
    
    #メンバー数が0の場合は0を返す。
    
    return 0 if ma.size == 0
    
    #タイプ別に処理
    
    case type
    
    #タイプが0の場合
    
    when 0;ma.inject(0) {|r, member| r += member.tp} / ma.size
    
    #タイプが1の場合
    
    when 1;ma.inject(0) {|r, member| r += member.tp_rate * 100} / ma.size
    
    end
  end
  #--------------------------------------------------------------------------
  # HPの合計値を計算
  #--------------------------------------------------------------------------
  def hptotal
    
    #メンバーの配列を取得。
    
    ma = members
    
    #メンバー数が0なら0、そうでなければ、メンバー全員のHP合計値を返す。
    
    ma.size == 0 ? 0 : ma.inject(0) {|r, member| r += member.hp}
  end
  #--------------------------------------------------------------------------
  # MPの合計値を計算
  #--------------------------------------------------------------------------
  def mptotal
    
    #メンバーの配列を取得。
    
    ma = members
    
    #メンバー数が0なら0、そうでなければ、メンバー全員のMP合計値を返す。
    
    ma.size == 0 ? 0 : ma.inject(0) {|r, member| r += member.mp}
  end
  #--------------------------------------------------------------------------
  # TPの合計値を計算
  #--------------------------------------------------------------------------
  def tptotal
    
    #メンバーの配列を取得。
    
    ma = members
    
    #メンバー数が0なら0、そうでなければ、メンバー全員のTP合計値を返す。
    
    ma.size == 0 ? 0 : ma.inject(0) {|r, member| r += member.tp}
  end
end
class RPG::UsableItem < RPG::BaseItem
  #--------------------------------------------------------------------------
  # 使用条件の配列を取得
  #--------------------------------------------------------------------------
  def use_condition_array
    
    #キャッシュが存在する場合はキャッシュを返す。
    
    @use_condition_array ||= create_use_condition_array
    
  end
  #--------------------------------------------------------------------------
  # 使用条件の配列を作成
  #--------------------------------------------------------------------------
  def create_use_condition_array
    
    #配列を作成する。
    
    a1 = []
    
    #メモ欄の各行からデータを取得。
    
    self.note.each_line {|l|
    if /<#{IS_USABLE::WORD_BASE}[：:](\S+)>/ =~ l
      
      #取得した文字列を配列化。
      
      a2 = $1.split(/\s*,\s*/)
      
      #配列の要素数が3か4の場合のみ処理を続行。
      
      if a2.size == 3 or a2.size == 4
        #アクターのみ条件が発生する場合、条件タイプは1とする。
        if l.include?(IS_USABLE::WORD_ACTOR)
          ut = 1
        #エネミーのみ条件が発生する場合、条件タイプは2とする。
        elsif l.include?(IS_USABLE::WORD_ENEMY)
          ut = 2
        #誰でも条件が発生する場合、条件タイプは0とする。
        else
          ut = 0
        end
        #味方全体に条件が発生する場合、判定対象は1とする。
        if l.include?(IS_USABLE::WORD_F_ALL)
          ct = 1
        #敵全体に条件が発生する場合、判定対象は2とする。
        elsif l.include?(IS_USABLE::WORD_O_ALL)
          ct = 2
        #敵味方全体に条件が発生する場合、判定対象は3とする。
        elsif l.include?(IS_USABLE::WORD_A_ALL)
          ct = 3
        #その他の条件の場合は判定対象は0とする。
        else
          ct = 0
        end
        #個別の条件となるハッシュを作成。
        hash = {:array => a2,:user_type => ut,:condition_target => ct}
        if ct == 0
          #条件の対象を指定したIDのアクターとする。
          hash[:array_a] = /~#{IS_USABLE::WORD_ACTOR_A}[：:](\S+)~/ =~ l ? $1.to_s.split(/\s*,\s*/).inject([]) {|r,i| r.push(i.to_i)} : []
          #条件の対象を指定されたインデックスのパーティメンバーとする。
          hash[:array_p] = /~#{IS_USABLE::WORD_PARTY_P}[：:](\S+)~/ =~ l ? $1.to_s.split(/\s*,\s*/).inject([]) {|r,i| r.push(i.to_i)} : []
          #条件の対象を指定したIDのエネミーとする。
          hash[:array_e] = /~#{IS_USABLE::WORD_ENEMY_E}[：:](\S+)~/ =~ l ? $1.to_s.split(/\s*,\s*/).inject([]) {|r,i| r.push(i.to_i)} : []
          #条件の対象を指定されたインデックスの敵グループメンバーとする。
          hash[:array_t] = /~#{IS_USABLE::WORD_TROOP_T}[：:](\S+)~/ =~ l ? $1.to_s.split(/\s*,\s*/).inject([]) {|r,i| r.push(i.to_i)} : []
        end
        a1.push(hash)
      end
    end
    }
    
    #配列を返す。
    
    a1
  end
end