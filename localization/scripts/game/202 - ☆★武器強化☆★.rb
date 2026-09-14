#==============================================================================
# ■ RGSS3 アイテム合成 ver 1.04
#------------------------------------------------------------------------------
# 　配布元:
#     白の魔 http://izumiwhite.web.fc2.com/
#
# 　利用規約:
#     RPGツクールVX Aceの正規の登録者のみご利用になれます。
#     利用報告・著作権表示とかは必要ありません。
#     改造もご自由にどうぞ。
#     何か問題が発生しても責任は持ちません。
#==============================================================================


#--------------------------------------------------------------------------
# ★ 初期設定。
#    合成レシピ等の設定
#--------------------------------------------------------------------------
module WD_itemsynthesis_ini
  
  Cost_view =  true #費用(Ｇ)の表示(合成の費用が全て0Gの場合はfalseを推奨)
  
  Category_i = false #カテゴリウィンドウに「アイテム」の項目を表示
  Category_w = true #カテゴリウィンドウに「武器」の項目を表示
  Category_a = false #カテゴリウィンドウに「防具」の項目を表示
  Category_k = false #カテゴリウィンドウに「大事なもの」の項目を表示
  
  I_recipe = [] #この行は削除しないこと
  W_recipe = [] #この行は削除しないこと
  A_recipe = [] #この行は削除しないこと
  
  #以下、合成レシピ。
  #例: I_recipe[3]  = [100, ["I",1,1], ["W",2,1], ["A",2,2], ["A",3,1]]
  #と記載した場合、ID3のアイテムの合成必要は、100Ｇ。
  #必要な素材は、ID1のアイテム1個、ID2の武器1個、ID2の防具2個、ID3の防具1個
  #となる。
  
  #武器の合成レシピ
  W_recipe[101]  = [100,   ["W",100,1], ["I",10,1]] #忠義の剣
  W_recipe[102]  = [200,  ["W",101,1], ["I",10,3]]
  W_recipe[103]  = [300,   ["W",102,1], ["I",10,5]]
  W_recipe[104]  = [500,   ["W",103,1], ["I",30,1]]
  W_recipe[105]  = [800,   ["W",104,1], ["I",30,3]]
  W_recipe[106]  = [1000,   ["W",105,1], ["I",30,5]]
  W_recipe[107]  = [1500,   ["W",106,1], ["I",31,1]]
  W_recipe[108]  = [2000,   ["W",107,1], ["I",31,2]]
  W_recipe[109]  = [2500,   ["W",108,1], ["I",31,3]]
  W_recipe[110]  = [5000,   ["W",109,1], ["I",32,1]]
  W_recipe[112]  = [100,   ["W",111,1], ["I",10,1]] #ダガー
  W_recipe[113]  = [200,   ["W",112,1], ["I",10,2]]
  W_recipe[114]  = [300,   ["W",113,1], ["I",10,3]]
  W_recipe[115]  = [400,   ["W",114,1], ["I",30,1]]
  W_recipe[116]  = [600,   ["W",115,1], ["I",30,2]]
  W_recipe[117]  = [900,   ["W",116,1], ["I",30,3]]
  W_recipe[118]  = [1300,   ["W",117,1], ["I",31,1]]
  W_recipe[119]  = [1800,   ["W",118,1], ["I",31,2]]
  W_recipe[120]  = [2400,   ["W",119,1], ["I",31,3]]
  W_recipe[121]  = [4000,   ["W",120,1], ["I",32,1]]
  W_recipe[123]  = [100,   ["W",122,1], ["I",10,1]] #古木の杖
  W_recipe[124]  = [200,   ["W",123,1], ["I",10,3]]
  W_recipe[125]  = [300,   ["W",124,1], ["I",10,5]]
  W_recipe[126]  = [500,   ["W",125,1], ["I",30,1]]
  W_recipe[127]  = [800,   ["W",126,1], ["I",30,3]]
  W_recipe[128]  = [1000,   ["W",127,1], ["I",30,5]]
  W_recipe[129]  = [1500,   ["W",128,1], ["I",31,1]]
  W_recipe[130]  = [2000,   ["W",129,1], ["I",31,2]]
  W_recipe[131]  = [2500,   ["W",130,1], ["I",31,3]]
  W_recipe[132]  = [5000,   ["W",131,1], ["I",32,1]]
  W_recipe[134]  = [100,   ["W",133,1], ["I",10,1]] #穢れた剣
  W_recipe[135]  = [200,   ["W",134,1], ["I",10,3]]
  W_recipe[136]  = [300,   ["W",135,1], ["I",10,5]]
  W_recipe[137]  = [500,   ["W",136,1], ["I",30,1]]
  W_recipe[138]  = [800,   ["W",137,1], ["I",30,3]]
  W_recipe[139]  = [1000,   ["W",138,1], ["I",30,5]]
  W_recipe[140]  = [1500,   ["W",139,1], ["I",31,1]]
  W_recipe[141]  = [2000,   ["W",140,1], ["I",31,2]]
  W_recipe[142]  = [2500,   ["W",141,1], ["I",31,3]]
  W_recipe[143]  = [5000,   ["W",142,1], ["I",32,1]]
  W_recipe[145]  = [100,   ["W",144,1], ["I",10,1]] #爛れた骨
  W_recipe[146]  = [200,   ["W",145,1], ["I",10,2]]
  W_recipe[147]  = [300,   ["W",146,1], ["I",10,3]]
  W_recipe[148]  = [500,   ["W",147,1], ["I",30,1]]
  W_recipe[149]  = [800,   ["W",148,1], ["I",30,2]]
  W_recipe[150]  = [1000,   ["W",149,1], ["I",30,3]]
  W_recipe[151]  = [1500,   ["W",150,1], ["I",31,1]]
  W_recipe[152]  = [2000,   ["W",151,1], ["I",31,2]]
  W_recipe[153]  = [2500,   ["W",152,1], ["I",31,3]]
  W_recipe[154]  = [5000,   ["W",153,1], ["I",32,1]]
  W_recipe[156]  = [1000,   ["W",155,1], ["I",10,1]]#変異した細胞
  W_recipe[157]  = [2000,   ["W",156,1], ["I",10,3]]
  W_recipe[158]  = [3000,   ["W",157,1], ["I",10,5]]
  W_recipe[159]  = [5000,   ["W",158,1], ["I",30,1]]
  W_recipe[160]  = [8000,   ["W",159,1], ["I",30,3]]
  W_recipe[161]  = [10000,   ["W",160,1], ["I",30,5]]
  W_recipe[162]  = [15000,   ["W",161,1], ["I",31,1]]
  W_recipe[163]  = [20000,   ["W",162,1], ["I",31,3]]
  W_recipe[164]  = [25000,   ["W",163,1], ["I",31,5]]
  W_recipe[165]  = [50000,   ["W",164,1], ["I",32,1]]
  W_recipe[167]  = [100,   ["W",166,1], ["I",10,1]]#双剣ブローデン
  W_recipe[168]  = [200,   ["W",167,1], ["I",10,3]]
  W_recipe[169]  = [300,   ["W",168,1], ["I",10,5]]
  W_recipe[170]  = [500,   ["W",169,1], ["I",30,1]]
  W_recipe[171]  = [800,   ["W",170,1], ["I",30,3]]
  W_recipe[172]  = [1000,   ["W",171,1], ["I",30,5]]
  W_recipe[173]  = [1500,   ["W",172,1], ["I",31,1]]
  W_recipe[174]  = [2000,   ["W",173,1], ["I",31,2]]
  W_recipe[175]  = [2500,   ["W",174,1], ["I",31,3]]
  W_recipe[176]  = [5000,   ["W",175,1], ["I",32,1]]
  W_recipe[178]  = [2500,   ["W",177,1], ["I",33,1]]#蟲人の鐘
  W_recipe[179]  = [5000,   ["W",178,1], ["I",33,1]]
  W_recipe[180]  = [7500,   ["W",179,1], ["I",33,1]]
  W_recipe[181]  = [10000,   ["W",180,1], ["I",33,1]]
  W_recipe[182]  = [15000,   ["W",181,1], ["I",33,1]]
  W_recipe[184]  = [100,   ["W",183,1], ["I",10,1]]#渾魔の剣
  W_recipe[185]  = [200,   ["W",184,1], ["I",10,3]]
  W_recipe[186]  = [300,   ["W",185,1], ["I",10,5]]
  W_recipe[187]  = [500,   ["W",186,1], ["I",30,1]]
  W_recipe[188]  = [800,   ["W",187,1], ["I",30,3]]
  W_recipe[189]  = [1000,   ["W",188,1], ["I",30,5]]
  W_recipe[190]  = [1500,   ["W",189,1], ["I",31,1]]
  W_recipe[191]  = [2000,   ["W",190,1], ["I",31,2]]
  W_recipe[192]  = [2500,   ["W",191,1], ["I",31,3]]
  W_recipe[193]  = [5000,   ["W",192,1], ["I",32,1]]
  W_recipe[195]  = [100,   ["W",194,1], ["I",10,1]]#賢者の杖
  W_recipe[196]  = [300,   ["W",195,1], ["I",10,3]]
  W_recipe[197]  = [500,   ["W",196,1], ["I",10,5]]
  W_recipe[198]  = [1000,   ["W",197,1], ["I",30,1]]
  W_recipe[199]  = [1500,   ["W",198,1], ["I",30,3]]
  W_recipe[200]  = [2000,   ["W",199,1], ["I",30,5]]
  W_recipe[201]  = [2500,   ["W",200,1], ["I",31,1]]
  W_recipe[202]  = [3000,   ["W",201,1], ["I",31,2]]
  W_recipe[203]  = [3500,   ["W",202,1], ["I",31,3]]
  W_recipe[204]  = [2500,   ["W",203,1], ["I",32,1]]
  W_recipe[205]  = [2500,   ["W",194,1], ["I",33,1], ["I",71,1]]#滅びゆく賢者の杖
  W_recipe[206]  = [5000,   ["W",205,1], ["I",33,1]]
  W_recipe[207]  = [7500,   ["W",206,1], ["I",33,1]]
  W_recipe[208]  = [10000,   ["W",207,1], ["I",33,1]]
  W_recipe[209]  = [30000,   ["W",208,1], ["I",32,1], ["I",33,1]]
  W_recipe[211]  = [100,   ["W",210,1], ["I",10,1]]#蠢く鞭
  W_recipe[212]  = [300,   ["W",211,1], ["I",10,3]]
  W_recipe[213]  = [500,   ["W",212,1], ["I",10,5]]
  W_recipe[214]  = [1000,   ["W",213,1], ["I",30,1]]
  W_recipe[215]  = [1500,   ["W",214,1], ["I",30,3]]
  W_recipe[216]  = [2000,   ["W",215,1], ["I",30,5]]
  W_recipe[217]  = [2500,   ["W",216,1], ["I",31,1]]
  W_recipe[218]  = [3000,   ["W",217,1], ["I",31,2]]
  W_recipe[219]  = [3500,   ["W",218,1], ["I",31,3]]
  W_recipe[220]  = [5000,   ["W",219,1], ["I",32,1]]
  W_recipe[222]  = [100,   ["W",221,1], ["I",10,1]]#眼狩りの短刀
  W_recipe[223]  = [300,   ["W",222,1], ["I",10,3]]
  W_recipe[224]  = [500,   ["W",223,1], ["I",10,5]]
  W_recipe[225]  = [1000,   ["W",224,1], ["I",30,1]]
  W_recipe[226]  = [1500,   ["W",225,1], ["I",30,3]]
  W_recipe[227]  = [2000,   ["W",226,1], ["I",30,5]]
  W_recipe[228]  = [2500,   ["W",227,1], ["I",31,1]]
  W_recipe[229]  = [3000,   ["W",228,1], ["I",31,2]]
  W_recipe[230]  = [3500,   ["W",229,1], ["I",31,3]]
  W_recipe[231]  = [5000,   ["W",230,1], ["I",32,1]]
  W_recipe[233]  = [100,   ["W",232,1], ["I",10,1]]#重槍
  W_recipe[234]  = [300,   ["W",233,1], ["I",10,3]]
  W_recipe[235]  = [500,   ["W",234,1], ["I",10,5]]
  W_recipe[236]  = [1000,   ["W",235,1], ["I",30,1]]
  W_recipe[237]  = [1500,   ["W",236,1], ["I",30,3]]
  W_recipe[238]  = [2000,   ["W",237,1], ["I",30,5]]
  W_recipe[239]  = [2500,   ["W",238,1], ["I",31,1]]
  W_recipe[240]  = [3000,   ["W",239,1], ["I",31,2]]
  W_recipe[241]  = [3500,   ["W",240,1], ["I",31,3]]
  W_recipe[242]  = [5000,   ["W",241,1], ["I",32,1]]
  W_recipe[244]  = [100,   ["W",243,1], ["I",10,1]]#仕込み靴
  W_recipe[245]  = [300,   ["W",244,1], ["I",10,3]]
  W_recipe[246]  = [500,   ["W",245,1], ["I",10,5]]
  W_recipe[247]  = [1000,   ["W",246,1], ["I",30,1]]
  W_recipe[248]  = [1500,   ["W",247,1], ["I",30,3]]
  W_recipe[249]  = [2000,   ["W",248,1], ["I",30,5]]
  W_recipe[250]  = [2500,   ["W",249,1], ["I",31,1]]
  W_recipe[251]  = [3000,   ["W",250,1], ["I",31,2]]
  W_recipe[252]  = [3500,   ["W",251,1], ["I",31,3]]
  W_recipe[253]  = [5000,   ["W",252,1], ["I",32,1]]
  W_recipe[255]  = [100,   ["W",254,1], ["I",10,1]]#燻んだ斧
  W_recipe[256]  = [300,   ["W",255,1], ["I",10,3]]
  W_recipe[257]  = [500,   ["W",256,1], ["I",10,5]]
  W_recipe[258]  = [1000,   ["W",257,1], ["I",30,1]]
  W_recipe[259]  = [1500,   ["W",258,1], ["I",30,3]]
  W_recipe[260]  = [2000,   ["W",259,1], ["I",30,5]]
  W_recipe[261]  = [2500,   ["W",260,1], ["I",31,1]]
  W_recipe[262]  = [3000,   ["W",261,1], ["I",31,2]]
  W_recipe[263]  = [3500,   ["W",262,1], ["I",31,3]]
  W_recipe[264]  = [5000,   ["W",263,1], ["I",32,1]]
  W_recipe[266]  = [100,   ["W",265,1], ["I",10,1]]#決闘士の両刃斧
  W_recipe[267]  = [300,   ["W",266,1], ["I",10,3]]
  W_recipe[268]  = [500,   ["W",267,1], ["I",10,5]]
  W_recipe[269]  = [1000,   ["W",268,1], ["I",30,1]]
  W_recipe[270]  = [1500,   ["W",269,1], ["I",30,3]]
  W_recipe[271]  = [2000,   ["W",270,1], ["I",30,5]]
  W_recipe[272]  = [2500,   ["W",271,1], ["I",31,1]]
  W_recipe[273]  = [3000,   ["W",272,1], ["I",31,2]]
  W_recipe[274]  = [3500,   ["W",273,1], ["I",31,3]]
  W_recipe[275]  = [5000,   ["W",274,1], ["I",32,1]]
  W_recipe[277]  = [100,   ["W",276,1], ["I",10,1]]#守人の剣
  W_recipe[278]  = [300,   ["W",277,1], ["I",10,3]]
  W_recipe[279]  = [500,   ["W",278,1], ["I",10,5]]
  W_recipe[280]  = [1000,   ["W",279,1], ["I",30,1]]
  W_recipe[281]  = [1500,   ["W",280,1], ["I",30,3]]
  W_recipe[282]  = [2000,   ["W",281,1], ["I",30,5]]
  W_recipe[283]  = [2500,   ["W",282,1], ["I",31,1]]
  W_recipe[284]  = [3000,   ["W",283,1], ["I",31,2]]
  W_recipe[285]  = [3500,   ["W",284,1], ["I",31,3]]
  W_recipe[286]  = [5000,   ["W",285,1], ["I",32,1]]
  W_recipe[288]  = [100,   ["W",287,1], ["I",10,1]]#弑逆の弩
  W_recipe[289]  = [300,   ["W",288,1], ["I",10,3]]
  W_recipe[290]  = [500,   ["W",289,1], ["I",10,5]]
  W_recipe[291]  = [1000,   ["W",290,1], ["I",30,1]]
  W_recipe[292]  = [1500,   ["W",291,1], ["I",30,3]]
  W_recipe[293]  = [2000,   ["W",292,1], ["I",30,5]]
  W_recipe[294]  = [2500,   ["W",293,1], ["I",31,1]]
  W_recipe[295]  = [3000,   ["W",294,1], ["I",31,2]]
  W_recipe[296]  = [3500,   ["W",295,1], ["I",31,3]]
  W_recipe[297]  = [5000,   ["W",296,1], ["I",32,1]]
  W_recipe[701]  = [2500,   ["W",700,1], ["I",33,1]]#赫怒の爪
  W_recipe[702]  = [5000,   ["W",701,1], ["I",33,1]]
  W_recipe[703]  = [7500,   ["W",702,1], ["I",33,1]]
  W_recipe[704]  = [10000,   ["W",703,1], ["I",33,1]]
  W_recipe[705]  = [15000,   ["W",704,1], ["I",32,1], ["I",33,1]]
  W_recipe[707]  = [2500,   ["W",706,1], ["I",33,1]]#大鷹の大剣
  W_recipe[708]  = [5000,   ["W",707,1], ["I",33,1]]
  W_recipe[709]  = [7500,   ["W",708,1], ["I",33,1]]
  W_recipe[710]  = [10000,   ["W",709,1], ["I",33,1]]
  W_recipe[711]  = [15000,   ["W",710,1], ["I",32,1], ["I",33,1]]
  W_recipe[713]  = [2500,   ["W",712,1], ["I",33,1]]#術士の穢刃
  W_recipe[714]  = [5000,   ["W",713,1], ["I",33,1]]
  W_recipe[715]  = [7500,   ["W",714,1], ["I",33,1]]
  W_recipe[716]  = [10000,   ["W",715,1], ["I",33,1]]
  W_recipe[717]  = [15000,   ["W",716,1], ["I",32,1], ["I",33,1]]
  W_recipe[719]  = [2500,   ["W",718,1], ["I",33,1]]#悲哀の錫杖
  W_recipe[720]  = [5000,   ["W",719,1], ["I",33,1]]
  W_recipe[721]  = [7500,   ["W",720,1], ["I",33,1]]
  W_recipe[722]  = [10000,   ["W",721,1], ["I",33,1]]
  W_recipe[723]  = [15000,   ["W",722,1], ["I",32,1], ["I",33,1]]
  W_recipe[725]  = [2500,   ["W",724,1], ["I",33,1]]#カルカル・ヘラに死の音を
  W_recipe[726]  = [5000,   ["W",725,1], ["I",33,1]]
  W_recipe[727]  = [7500,   ["W",726,1], ["I",33,1]]
  W_recipe[728]  = [10000,   ["W",727,1], ["I",33,1]]
  W_recipe[729]  = [15000,   ["W",728,1], ["I",32,1], ["I",33,1]]
  W_recipe[731]  = [2500,   ["W",730,1], ["I",33,1]]#黄金の剣
  W_recipe[732]  = [5000,   ["W",731,1], ["I",33,1]]
  W_recipe[733]  = [7500,   ["W",732,1], ["I",33,1]]
  W_recipe[734]  = [10000,   ["W",733,1], ["I",33,1]]
  W_recipe[735]  = [15000,   ["W",734,1], ["I",32,1], ["I",33,1]]
  W_recipe[737]  = [2500,   ["W",736,1], ["I",33,1]]#影の刃
  W_recipe[738]  = [5000,   ["W",737,1], ["I",33,1]]
  W_recipe[739]  = [7500,   ["W",738,1], ["I",33,1]]
  W_recipe[740]  = [10000,   ["W",739,1], ["I",33,1]]
  W_recipe[741]  = [15000,   ["W",740,1], ["I",32,1], ["I",33,1]]
  W_recipe[743]  = [2500,   ["W",742,1], ["I",33,1]]#月光の大鎌
  W_recipe[744]  = [5000,   ["W",743,1], ["I",33,1]]
  W_recipe[745]  = [7500,   ["W",744,1], ["I",33,1]]
  W_recipe[746]  = [10000,   ["W",745,1], ["I",33,1]]
  W_recipe[747]  = [15000,   ["W",746,1], ["I",32,1], ["I",33,1]]
  W_recipe[749]  = [2500,   ["W",748,1], ["I",33,1]]#レイドの短剣
  W_recipe[750]  = [5000,   ["W",749,1], ["I",33,1]]
  W_recipe[751]  = [7500,   ["W",750,1], ["I",33,1]]
  W_recipe[752]  = [10000,   ["W",751,1], ["I",33,1]]
  W_recipe[753]  = [15000,   ["W",752,1], ["I",32,1], ["I",33,1]]
end


#==============================================================================
# ■ WD_itemsynthesis
#------------------------------------------------------------------------------
# 　アイテム合成用の共通メソッドです。
#==============================================================================

module WD_itemsynthesis
  def i_recipe_switch_on(id)
    $game_system.i_rcp_sw = [] if $game_system.i_rcp_sw == nil
    $game_system.i_rcp_sw[id] = false if $game_system.i_rcp_sw[id] == nil
    $game_system.i_rcp_sw[id] = true
  end
  def i_recipe_switch_off(id)
    $game_system.i_rcp_sw = [] if $game_system.i_rcp_sw == nil
    $game_system.i_rcp_sw[id] = false if $game_system.i_rcp_sw[id] == nil
    $game_system.i_rcp_sw[id] = false
  end
  def i_recipe_switch_on?(id)
    $game_system.i_rcp_sw = [] if $game_system.i_rcp_sw == nil
    $game_system.i_rcp_sw[id] = false if $game_system.i_rcp_sw[id] == nil
    return $game_system.i_rcp_sw[id]
  end
  def i_recipe_all_switch_on
    for i in 1..$data_items.size
      i_recipe_switch_on(i)
    end
  end
  def i_recipe_all_switch_off
    for i in 1..$data_items.size
      i_recipe_switch_off(i)
    end
  end
  def w_recipe_switch_on(id)
    $game_system.w_rcp_sw = [] if $game_system.w_rcp_sw == nil
    $game_system.w_rcp_sw[id] = false if $game_system.w_rcp_sw[id] == nil
    $game_system.w_rcp_sw[id] = true
  end
  def w_recipe_switch_off(id)
    $game_system.w_rcp_sw = [] if $game_system.w_rcp_sw == nil
    $game_system.w_rcp_sw[id] = false if $game_system.w_rcp_sw[id] == nil
    $game_system.w_rcp_sw[id] = false
  end
  def w_recipe_switch_on?(id)
    $game_system.w_rcp_sw = [] if $game_system.w_rcp_sw == nil
    $game_system.w_rcp_sw[id] = false if $game_system.w_rcp_sw[id] == nil
    return $game_system.w_rcp_sw[id]
  end
  def w_recipe_all_switch_on
    for i in 1..$data_weapons.size
      w_recipe_switch_on(i)
    end
  end
  def w_recipe_all_switch_off
    for i in 1..$data_weapons.size
      w_recipe_switch_off(i)
    end
  end
  def a_recipe_switch_on(id)
    $game_system.a_rcp_sw = [] if $game_system.a_rcp_sw == nil
    $game_system.a_rcp_sw[id] = false if $game_system.a_rcp_sw[id] == nil
    $game_system.a_rcp_sw[id] = true
  end
  def a_recipe_switch_off(id)
    $game_system.a_rcp_sw = [] if $game_system.a_rcp_sw == nil
    $game_system.a_rcp_sw[id] = false if $game_system.a_rcp_sw[id] == nil
    $game_system.a_rcp_sw[id] = false
  end
  def a_recipe_switch_on?(id)
    $game_system.a_rcp_sw = [] if $game_system.a_rcp_sw == nil
    $game_system.a_rcp_sw[id] = false if $game_system.a_rcp_sw[id] == nil
    return $game_system.a_rcp_sw[id]
  end
  def a_recipe_all_switch_on
    for i in 1..$data_armors.size
      a_recipe_switch_on(i)
    end
  end
  def a_recipe_all_switch_off
    for i in 1..$data_armors.size
      a_recipe_switch_off(i)
    end
  end
  def recipe_all_switch_on
    i_recipe_all_switch_on
    w_recipe_all_switch_on
    a_recipe_all_switch_on
  end
  def recipe_all_switch_off
    i_recipe_all_switch_off
    w_recipe_all_switch_off
    a_recipe_all_switch_off
  end

end

class Game_Interpreter
  include WD_itemsynthesis
end

class Game_System
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :i_rcp_sw
  attr_accessor :w_rcp_sw
  attr_accessor :a_rcp_sw
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias wd_orig_initialize004 initialize
  def initialize
    wd_orig_initialize004
    @i_rcp_sw = []
    @w_rcp_sw = []
    @a_rcp_sw = []
  end
end


#==============================================================================
# ■ Scene_ItemSynthesis
#------------------------------------------------------------------------------
# 　合成画面の処理を行うクラスです。
#==============================================================================

class Scene_ItemSynthesis < Scene_MenuBase
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_dummy_window
    create_number_window
    create_status_window
    create_material_window
    create_list_window
    create_category_window
    create_gold_window
    create_change_window
  end
  #--------------------------------------------------------------------------
  # ● ゴールドウィンドウの作成
  #--------------------------------------------------------------------------
  def create_gold_window
    @gold_window = Window_Gold.new
    @gold_window.viewport = @viewport
    @gold_window.x = Graphics.width - @gold_window.width
    @gold_window.y = @help_window.height
    @gold_window.hide
  end
  #--------------------------------------------------------------------------
  # ● 切り替え表示ウィンドウの作成
  #--------------------------------------------------------------------------
  def create_change_window
    wx = 0
    wy = @gold_window.y
    ww = Graphics.width - @gold_window.width
    wh = @gold_window.height
    @change_window = Window_ItemSynthesisChange.new(wx, wy, ww, wh)
    @change_window.viewport = @viewport
    @change_window.hide
  end
  #--------------------------------------------------------------------------
  # ● ダミーウィンドウの作成
  #--------------------------------------------------------------------------
  def create_dummy_window
    wy = @help_window.y + @help_window.height + 48
    wh = Graphics.height - wy
    @dummy_window = Window_Base.new(0, wy, Graphics.width, wh)
    @dummy_window.viewport = @viewport
  end
  #--------------------------------------------------------------------------
  # ● 個数入力ウィンドウの作成
  #--------------------------------------------------------------------------
  def create_number_window
    wy = @dummy_window.y
    wh = @dummy_window.height
    @number_window = Window_ItemSynthesisNumber.new(0, wy, wh)
    @number_window.viewport = @viewport
    @number_window.hide
    @number_window.set_handler(:ok,     method(:on_number_ok))
    @number_window.set_handler(:cancel, method(:on_number_cancel))
    @number_window.set_handler(:change_window, method(:on_change_window))    
  end
  #--------------------------------------------------------------------------
  # ● ステータスウィンドウの作成
  #--------------------------------------------------------------------------
  def create_status_window
    wx = @number_window.width
    wy = @dummy_window.y
    ww = Graphics.width - wx
    wh = @dummy_window.height
    @status_window = Window_ShopStatus.new(wx, wy, ww, wh)
    @status_window.viewport = @viewport
    @status_window.hide
  end
  #--------------------------------------------------------------------------
  # ● 素材ウィンドウの作成
  #--------------------------------------------------------------------------
  def create_material_window
    wx = @number_window.width
    wy = @dummy_window.y
    ww = Graphics.width - wx
    wh = @dummy_window.height
    @material_window = Window_ItemSynthesisMaterial.new(wx, wy, ww, wh)
    @material_window.viewport = @viewport
    @material_window.hide
    @number_window.material_window = @material_window
  end
  #--------------------------------------------------------------------------
  # ● 合成アイテムリストウィンドウの作成
  #--------------------------------------------------------------------------
  def create_list_window
    wy = @dummy_window.y
    wh = @dummy_window.height
    @list_window = Window_ItemSynthesisList.new(0, wy, wh)
    @list_window.viewport = @viewport
    @list_window.help_window = @help_window
    @list_window.status_window = @status_window
    @list_window.material_window = @material_window
    @list_window.hide
    @list_window.set_handler(:ok,     method(:on_list_ok))
    @list_window.set_handler(:cancel, method(:on_list_cancel))
    @list_window.set_handler(:change_window, method(:on_change_window))    
  end
  #--------------------------------------------------------------------------
  # ● カテゴリウィンドウの作成
  #--------------------------------------------------------------------------
  def create_category_window
    @category_window = Window_ItemSynthesisCategory.new
    @category_window.viewport = @viewport
    @category_window.help_window = @help_window
    @category_window.y = @help_window.height
    @category_window.activate
    @category_window.item_window = @list_window
    @category_window.set_handler(:ok,     method(:on_category_ok))
    @category_window.set_handler(:cancel, method(:return_scene))
  end
  #--------------------------------------------------------------------------
  # ● 合成アイテムリストウィンドウのアクティブ化
  #--------------------------------------------------------------------------
  def activate_list_window
    @list_window.money = money
    @list_window.show.activate
  end
  #--------------------------------------------------------------------------
  # ● 合成［決定］
  #--------------------------------------------------------------------------
  def on_list_ok
    @item = @list_window.item
    @list_window.hide
    @number_window.set(@item, max_buy, buying_price, currency_unit)
    @number_window.show.activate
  end
  #--------------------------------------------------------------------------
  # ● 合成［キャンセル］
  #--------------------------------------------------------------------------
  def on_list_cancel
    @category_window.activate
    @category_window.show
    @dummy_window.show
    @list_window.hide
    @status_window.hide
    @status_window.item = nil
    @material_window.hide
    @material_window.set(nil, nil)
    @gold_window.hide
    @change_window.hide
    @help_window.clear
  end
  #--------------------------------------------------------------------------
  # ● 表示切替
  #--------------------------------------------------------------------------
  def on_change_window
    if @status_window.visible
      @status_window.hide
      @material_window.show
    else
      @status_window.show
      @material_window.hide
    end
  end
  #--------------------------------------------------------------------------
  # ● カテゴリ［決定］
  #--------------------------------------------------------------------------
  def on_category_ok
    activate_list_window
    @gold_window.show
    @change_window.show
    @material_window.show
    @category_window.hide
    @list_window.select(0)
  end
  #--------------------------------------------------------------------------
  # ● 個数入力［決定］
  #--------------------------------------------------------------------------
  def on_number_ok
    Sound.play_shop
    do_syntetic(@number_window.number)
    end_number_input
    @gold_window.refresh
  end
  #--------------------------------------------------------------------------
  # ● 個数入力［キャンセル］
  #--------------------------------------------------------------------------
  def on_number_cancel
    Sound.play_cancel
    end_number_input
  end
  #--------------------------------------------------------------------------
  # ● 合成の実行
  #--------------------------------------------------------------------------
  def do_syntetic(number)
    $game_party.lose_gold(number * buying_price)
    $game_party.gain_item(@item, number)
    
      @recipe = @list_window.recipe(@item)
      for i in 1...@recipe.size
        kind = @recipe[i][0]
        id   = @recipe[i][1]
        num  = @recipe[i][2]
        if kind == "I"
          item = $data_items[id]
        elsif kind == "W"
          item = $data_weapons[id]
        elsif kind == "A"
          item = $data_armors[id]
        end
        $game_party.lose_item(item, num*number)
      end
  end
  #--------------------------------------------------------------------------
  # ● 個数入力の終了
  #--------------------------------------------------------------------------
  def end_number_input
    @number_window.hide
    activate_list_window
  end
  #--------------------------------------------------------------------------
  # ● 最大購入可能個数の取得
  #--------------------------------------------------------------------------
  def max_buy
    max = $game_party.max_item_number(@item) - $game_party.item_number(@item)
    
    @recipe = @list_window.recipe(@item)
      for i in 1...@recipe.size
        kind = @recipe[i][0]
        id   = @recipe[i][1]
        num  = @recipe[i][2]
        if kind == "I"
          item = $data_items[id]
        elsif kind == "W"
          item = $data_weapons[id]
        elsif kind == "A"
          item = $data_armors[id]
        end
        if num > 0
          max_buf = $game_party.item_number(item)/num
        else
          max_buf = 999
        end
        max = [max, max_buf].min
      end
      
    buying_price == 0 ? max : [max, money / buying_price].min

  end
  #--------------------------------------------------------------------------
  # ● 所持金の取得
  #--------------------------------------------------------------------------
  def money
    @gold_window.value
  end
  #--------------------------------------------------------------------------
  # ● 通貨単位の取得
  #--------------------------------------------------------------------------
  def currency_unit
    @gold_window.currency_unit
  end
  #--------------------------------------------------------------------------
  # ● 合成費用の取得
  #--------------------------------------------------------------------------
  def buying_price
    @list_window.price(@item)
  end
end


#==============================================================================
# ■ Window_ItemSynthesisList
#------------------------------------------------------------------------------
# 　合成画面で、合成可能なアイテムの一覧を表示するウィンドウです。
#==============================================================================

class Window_ItemSynthesisList < Window_Selectable
  include WD_itemsynthesis
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :status_window            # ステータスウィンドウ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(x, y, height)
    super(x, y, window_width, height)
    
    @shop_goods = []
    @shop_recipes = []
    
    for i in 1..WD_itemsynthesis_ini::I_recipe.size
      recipe = WD_itemsynthesis_ini::I_recipe[i]
      if recipe
        good = [0, i, recipe[0]]
        if i_recipe_switch_on?(i)
          @shop_goods.push(good)
          @shop_recipes.push(recipe)
        end
      end
    end
    for i in 1..WD_itemsynthesis_ini::W_recipe.size
      recipe = WD_itemsynthesis_ini::W_recipe[i]
      if recipe
        good = [1, i, recipe[0]]
        if w_recipe_switch_on?(i)
          @shop_goods.push(good)
          @shop_recipes.push(recipe)
        end
      end
    end
    for i in 1..WD_itemsynthesis_ini::A_recipe.size
      recipe = WD_itemsynthesis_ini::A_recipe[i]
      if recipe
        good = [2, i, recipe[0]]
        if a_recipe_switch_on?(i)
          @shop_goods.push(good)
          @shop_recipes.push(recipe)
        end
      end
    end
    
    @money = 0
    refresh
    select(0)
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
    return 304
  end
  #--------------------------------------------------------------------------
  # ● 項目数の取得
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 1
  end
  #--------------------------------------------------------------------------
  # ● アイテムの取得
  #--------------------------------------------------------------------------
  def item
    @data[index]
  end
  #--------------------------------------------------------------------------
  # ● 所持金の設定
  #--------------------------------------------------------------------------
  def money=(money)
    @money = money
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 選択項目の有効状態を取得
  #--------------------------------------------------------------------------
  def current_item_enabled?
    enable?(@data[index])
  end
  #--------------------------------------------------------------------------
  # ● 合成費用を取得
  #--------------------------------------------------------------------------
  def price(item)
    @price[item]
  end
  #--------------------------------------------------------------------------
  # ● 合成可否を取得
  #--------------------------------------------------------------------------
  def enable?(item)
    @makable[item]
  end
  #--------------------------------------------------------------------------
  # ● レシピを取得
  #--------------------------------------------------------------------------
  def recipe(item)
    @recipe[item]
  end
  #--------------------------------------------------------------------------
  # ● アイテムを許可状態で表示するかどうか
  #--------------------------------------------------------------------------
  def have_mat?(recipe)
    flag = true
    if @money >= recipe[0]
      for i in 1...recipe.size
        kind = recipe[i][0]
        id   = recipe[i][1]
        num  = recipe[i][2]
        if kind == "I"
          item = $data_items[id]
        elsif kind == "W"
          item = $data_weapons[id]
        elsif kind == "A"
          item = $data_armors[id]
        end
        if $game_party.item_number(item) < [num, 1].max
          flag = false
        end
      end
    else
      flag = false
    end
    return flag
  end
  #--------------------------------------------------------------------------
  # ● カテゴリの設定
  #--------------------------------------------------------------------------
  def category=(category)
    return if @category == category
    @category = category
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    create_contents
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # ● アイテムをリストに含めるかどうか
  #--------------------------------------------------------------------------
  def include?(item)
    case @category
    when :item
      item.is_a?(RPG::Item) && !item.key_item?
    when :weapon
      item.is_a?(RPG::Weapon)
    when :armor
      item.is_a?(RPG::Armor)
    when :key_item
      item.is_a?(RPG::Item) && item.key_item?
    else
      false
    end
  end
  #--------------------------------------------------------------------------
  # ● アイテムリストの作成
  #--------------------------------------------------------------------------
  def make_item_list
    @data = []
    @price = {}
    @makable = {}
    @recipe = {}
    for i in 0...@shop_goods.size
      goods = @shop_goods[i]
      recipe = @shop_recipes[i]
      case goods[0]
      when 0;  item = $data_items[goods[1]]
      when 1;  item = $data_weapons[goods[1]]
      when 2;  item = $data_armors[goods[1]]
      end
      if item
        if include?(item)
          @data.push(item)
          @price[item] = goods[2]
          @makable[item] = have_mat?(recipe) && $game_party.item_number(item) < $game_party.max_item_number(item) 
          @recipe[item] = recipe
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    rect = item_rect(index)
    draw_item_name(item, rect.x, rect.y, enable?(item))
    rect.width -= 4
    draw_text(rect, price(item), 2)  if WD_itemsynthesis_ini::Cost_view
  end
  #--------------------------------------------------------------------------
  # ● ステータスウィンドウの設定
  #--------------------------------------------------------------------------
  def status_window=(status_window)
    @status_window = status_window
    call_update_help
  end
  #--------------------------------------------------------------------------
  # ● 素材ウィンドウの設定
  #--------------------------------------------------------------------------
  def material_window=(material_window)
    @material_window = material_window
    call_update_help
  end
  #--------------------------------------------------------------------------
  # ● ヘルプテキスト更新
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(item) if @help_window
    @status_window.item = item if @status_window
    @material_window.set(item, recipe(item)) if @material_window
  end
  #--------------------------------------------------------------------------
  # ● Z ボタン（表示切替）が押されたときの処理
  #--------------------------------------------------------------------------
  def process_change_window
    Sound.play_cursor
    Input.update
    call_handler(:change_window)
  end
  #--------------------------------------------------------------------------
  # ● 決定やキャンセルなどのハンドリング処理
  #--------------------------------------------------------------------------
  def process_handling
    super
    if active
      return process_change_window if handle?(:change_window) && Input.trigger?(:Z)
#      return process_change_window if handle?(:change_window) && Input.trigger?(:Z)
    end
  end
end


#==============================================================================
# ■ Window_ItemSynthesisMaterial
#------------------------------------------------------------------------------
# 　合成画面で、合成に必要な素材を表示するウィンドウです。
#==============================================================================

class Window_ItemSynthesisMaterial < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @item = nil
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_possession(4, 0)
    draw_material_info(0, line_height * 2)
  end
  #--------------------------------------------------------------------------
  # ● アイテムの設定
  #--------------------------------------------------------------------------
  def set(item, recipe)
    @item = item
    @recipe = recipe
    @make_number = 1
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 作成個数の設定
  #--------------------------------------------------------------------------
  def set_num(make_number)
    @make_number = make_number
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 所持数の描画
  #--------------------------------------------------------------------------
  def draw_possession(x, y)
    rect = Rect.new(x, y, contents.width - 4 - x, line_height)
    change_color(system_color)
    draw_text(rect, Vocab::Possession)
    change_color(normal_color)
    draw_text(rect, $game_party.item_number(@item), 2)
  end
  #--------------------------------------------------------------------------
  # ● 素材情報の描画
  #--------------------------------------------------------------------------
  def draw_material_info(x, y)
    rect = Rect.new(x, y, contents.width, line_height)
    change_color(system_color)
    contents.font.size = 18
    draw_text(rect, "Необходимые материалы / Навыки", 0)
    if @recipe
      for i in 1...@recipe.size
        kind = @recipe[i][0]
        id   = @recipe[i][1]
        num  = @recipe[i][2]
        if kind == "I"
          item = $data_items[id]
        elsif kind == "W"
          item = $data_weapons[id]
        elsif kind == "A"
          item = $data_armors[id]
        end
        rect = Rect.new(x, y + line_height*i, contents.width, line_height)
        enabled = true
        enabled = false if [num*@make_number, 1].max  > $game_party.item_number(item)
        draw_item_name(item, rect.x, rect.y, enabled)
        change_color(normal_color, enabled)
        if num > 0
          draw_text(rect, "#{num*@make_number}/#{$game_party.item_number(item)}", 2)
        end
      end
    end
    change_color(normal_color)
    contents.font.size = 24
  end
end


#==============================================================================
# ■ Window_ItemSynthesisNumber
#------------------------------------------------------------------------------
# 　合成画面で、合成するアイテムの個数を入力するウィンドウです。
#==============================================================================

class Window_ItemSynthesisNumber < Window_ShopNumber
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_item_name(@item, 0, item_y)
    draw_number
    draw_total_price if WD_itemsynthesis_ini::Cost_view
  end
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def material_window=(material_window)
    @material_window = material_window
    call_update_help
  end
  #--------------------------------------------------------------------------
  # ● 作成個数の変更
  #--------------------------------------------------------------------------
  def change_number(amount)
    @number = [[@number + amount, @max].min, 1].max
    call_update_help #追加
  end
  #--------------------------------------------------------------------------
  # ● ヘルプテキスト更新
  #--------------------------------------------------------------------------
  def call_update_help
    @material_window.set_num(@number) if @material_window
  end
  #--------------------------------------------------------------------------
  # ● Z ボタン（表示切替）が押されたときの処理
  #--------------------------------------------------------------------------
  def process_change_window
    Sound.play_cursor
    Input.update
    call_handler(:change_window)
  end
  #--------------------------------------------------------------------------
  # ● 決定やキャンセルなどのハンドリング処理
  #--------------------------------------------------------------------------
  def process_handling
    super
    if active
      return process_change_window if handle?(:change_window) && Input.trigger?(:Z)
#      return process_change_window if handle?(:change_window) && Input.trigger?(:Z)
    end
  end
end


#==============================================================================
# ■ Window_ItemSynthesisCategory
#------------------------------------------------------------------------------
# 　合成画面で、通常アイテムや装備品の分類を選択するウィンドウです。
#==============================================================================

class Window_ItemSynthesisCategory < Window_ItemCategory
  #--------------------------------------------------------------------------
  # ● 桁数の取得
  #--------------------------------------------------------------------------
  def col_max
    i = 0
    i += 1 if WD_itemsynthesis_ini::Category_i
    i += 1 if WD_itemsynthesis_ini::Category_w
    i += 1 if WD_itemsynthesis_ini::Category_a
    i += 1 if WD_itemsynthesis_ini::Category_k
    return i
  end
  #--------------------------------------------------------------------------
  # ● コマンドリストの作成
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::item,     :item)     if WD_itemsynthesis_ini::Category_i
    add_command(Vocab::weapon,   :weapon)   if WD_itemsynthesis_ini::Category_w
    add_command(Vocab::armor,    :armor)    if WD_itemsynthesis_ini::Category_a
    add_command(Vocab::key_item, :key_item) if WD_itemsynthesis_ini::Category_k
  end
end


#==============================================================================
# ■ Window_ItemSynthesisNumber
#------------------------------------------------------------------------------
# 　合成画面で、切替を表示するウィンドウです。
#==============================================================================

class Window_ItemSynthesisChange < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    text = "← Q Предыдущая страница / Следующая страница W →"
    draw_text(0, 0, contents_width, line_height, text, 1)
  end
end