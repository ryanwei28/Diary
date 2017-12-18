-----------------------------------------------------------------------------------------
--
-- leaveMessage.lua
--
-----------------------------------------------------------------------------------------

local sqlite3 = require "sqlite3"
local scene = composer.newScene()
local date = os.date( "*t" ) 
local init 
local sceneGroup
local bg
local back
local images 
local whiteBg
local label_autohr
local gray 
local rowIndex = composer.getVariable( "rowIndex" )
local scrollView
local banner 
local titleText 
local authorText 
local pink 
local grayText 
local contentText 
local onKeyEvent 
local bannerListener 

local title = { 
    "孕氣，運氣?\nMore than Luck"  ,
    "懷孕就結婚?\nWhen It Comes to 'Knocked Up'"  ,
    "不可不知驗孕快狠準關鍵字"  ,
    "快又準！DIY驗孕知識全攻略"  ,
    "聰明快捷驗孕一試就準"  ,
}

local imgs = {
    "1.jpg"  ,
    "2.jpg"  ,
    "3.jpg"  ,
    "4.jpg"  ,
    "5.jpg"  ,
}

local author = {
    "張芳維醫師" , 
    "毛士鵬醫師" , 
    "雙和醫院婦產部 生殖醫學中心 陳碧華醫師" , 
    "張建枚醫師" , 
    "耕莘醫院永和分院婦產科 葉紹錡醫師" , 

}

local grayTable = {
    "懷孕是幸福的，男女都好，只要健健康康" , 
    "李木生婦產科副院長毛士鵬醫師" , 
    "" , 
    "" , 
    "" ,
}

local content = {
[[她和他隔著矮桌各自坐在沙發上，不到五坪大的客廳裡凝結著對峙的緊張感。
沒有交談的兩人視線倒是有志一同的，落向桌面一根白色條狀物。 那是驗孕棒。
桌上散落不同廠牌的驗孕棒，有的原封不動、有的被丟在一旁顯然已經用過。 
不知道是不滿意前幾個測試結果，還是只想再確定，總之，這是他們測試的第三次。
不是沒有想過當媽媽的這件事，但好像到了這一刻才有最真實的感覺。 
光是可能懷孕的現在，她就已經可以想像自己觸碰到嬰兒暖呼呼又輕柔柔的感覺。
「其實，才遲來了一個星期搞不好明天就來了。」 她想到這裡有點失望的說。
「時間到了吧？」 他抬頭看了一眼，牆上的時鐘又往前跳動了一格。
「我已經幫妳預約婦產科了，明天下班接妳一起去檢查。」 他笑著說眼睛瞇成一條直線，站了起來一伸手就輕輕把她抱入懷中。
「順便問問醫生懷孕初期要注意些什麼事情。」 

這麼有責任感應該是個好爸爸吧？
她回頭在他臉上落下一個吻。 「我想要女生，你呢？」
「男女都好，只要健康、像妳都好。」 Dr. DIY美麗問診室

Q1:性行為後隔多久時間可以驗孕? 每位女性的排卵期固定為14天，月經週期28天的人，在排卵後兩個星期大約就能檢驗是否懷孕。若月經週期並非28天為一週期，就需要推算排卵日期，往後推算14日，就可以開始檢測是否懷孕。

Q2:該如何挑選適合自己的驗孕產品? 首先，挑選越新的產品越好。所謂「新」，指的是產品的出廠日期，幾乎所有檢驗試劑都一樣，出廠越久，準確率就會跟著下降。因台灣氣候潮濕，也可選擇防潮包裝的驗孕產品，避免受潮而影響檢測結果。最後可以比較各家產品的準確率，包含偽陽性、偽陰性等出現的機率都可列入挑選時的考慮。 

Q3:在不同時間(早晨、中午、晚間)驗孕是否會影響準確率? 早晨、中午、晚上所測的驗孕準確率不會相差太大，不過一般驗孕產品是利用尿液中的人類絨毛激素(HCG)來檢測是否懷孕，時間越久HCG濃度越高，越能提升準確率，所以晚上測會比白天稍微準確些。

Q4:飲食、酒精或藥物是否會影響驗孕結果? 就像酒測時大量喝水並不會影響血液裡的酒精濃度，一般飲食、飲酒和藥物並不會影響到血液與尿液中的HCG濃度，除非是服用或施打荷爾蒙相關藥物，才會讓HCG變化，影響驗孕結果。

Q5:取尿液樣時有什麼需要特別注意的地方嗎? 一般醫師建議取用中段尿液是為了避免前、後段的細菌雜質影響檢測結果，不過就驗孕來說差異其實不大，重點是依照各產品包裝上的指示操作，避免在尿液取樣時取樣過多或過少，而出現偽陽性影響檢測的準確率。

◎張芳維醫師簡歷 三軍總醫院婦產部主治醫師
國防醫學院醫學系醫學士 國防醫學院婦產學科助理教授 ]] ,
[[她每次和男友做愛一定會戴保險套，有一回她想說生理期剛結束，這時做愛應該不會懷孕，有些事情就是很奇怪，越這麼想就越會被莫非定律給盯上，那麼湊巧的只因那一回沒戴保險套做愛就懷孕了。

當生理期遲到時，她跑來跟我討論不知道是懷孕還是生理期來遲，我無法幫她確認這種事，也不想叫她多等幾天看看，於是我陪她一起到藥局買驗孕棒，當下我們還很怕驗不準，所以一次還買了三份。 

有的人看到驗孕棒上顯示幾條線的表情就能知道是高潮還是低潮，它就跟廟裡籤筒一樣，把籤抽出來只看見號碼，卻不知道是上上籤還是下下籤，直到看見籤詩上『上上下下』字樣才能知道是抽中上上籤的高潮還是下下籤的低潮。

我們就像電影裡那樣，反覆拿著驗孕棒與外盒確認幾條線代表什麼意思，最後朋友看懂驗孕棒上的線條顯示後，我真不知該如何形容她臉上表情，像是又驚又喜外加一臉充滿髒話的懊悔表情。 

當下她猶豫問我該不該留下小孩，我不方便表達什麼意見，畢竟又不是我跟她生的，我也不會幫她養小孩，所以根本不該給她什麼意見，我很認真的建議她回去跟肇事者討論。

無論她打來跟我說做哪種決定，結婚也好、生下小孩也罷，我真的覺得她開心就好。因為那是她自己的人生，她為自己的人生負責，就算以後會到處哭夭不停，那也是她自己做出的決定。 

過了一個多星期，她打電話告訴我：「我們決定要結婚了…說來真好笑，因為懷孕才結婚，感覺像是拿刀架著對方跟自己結婚…」

親愛的，有些對象並不是妳拿刀架著他，他就會跟妳結婚啊。 

◎作者簡介 亞美將
左手寫字，右手畫圖，以輕鬆詼諧的生活態度來觀察人生每一刻，並且紀錄下來發表在網路平台上。 上面的故事，我們或多或少聽過類似版本，然而卻不是每個版本都有快樂結局，唯有具備正確知識，才是尊重、愛護自己的表現。以下為專業婦產科醫師毛士鵬對於一些避孕、驗孕常見問題的解答。

1. 想要避孕，該如何計算排卵期? 雖然月經週期長短每個人有所不同，同一個人每次週期長短也不盡相同，但大多數人黃體期的壽命是14天，這是恒定不變的。所以可以用簡單數學公式法預測排卵日：如果下次月經來潮的那天是第N天，那麼這次的排卵日就是第N-14天。

2. 如果懷疑自己可能受孕，何時是驗孕的最好時機? 受孕第6、7天開始，尿液中就能檢測出快速增加的特異激素－人絨毛膜促性腺激素（簡稱HCG），通常醫院及目前市售的驗孕棒檢驗，都是通過尿液檢測其中的HCG，靈敏度很高。如果想要比較準確的結果，最好在14天後驗孕，此時受精卵著床會開始大量分泌HGG，檢驗會較準確。

3. 除了找婦產科醫師之外，有沒有其他自行驗孕的方式? 市面上有多款可自行操作的驗孕產品，如驗孕棒、驗孕片或驗孕卡等，都是利用尿液中所含的HCG檢查，將尿液滴在試紙上呈現的反應判定懷孕與否。家用驗孕在一般藥房都有售，準確性高而且不需要醫生處方，這種測試方法的好處就是讓妳有更多的隱私和方便性，只要在任何隱密地方，花幾分鐘就可以得到結果。

4. 什麼會影響驗孕棒的準確率？ 驗孕棒準確率和使用方法有關，如果錯誤操作或者操作時間不對，準確率就會受影響。例如，驗孕棒存放時間超過1年、或是未注意保存條件使試紙受潮，測驗結果可能就不準確。其他像尿液滴在錯誤測試區、驗孕棒沒有水平放置，或是靜置時間過久，也可能出現弱陽性（即第二條色帶隱隱出現的樣子）。最後，即使呈現陽性不表示百分之百懷孕，有些腫瘤細胞如葡萄胎、絨癌等，也會分泌HCG。建議使用驗孕棒前請詳閱說明書，為保險起見再到醫院進行詳細、全面的檢查。

◎毛士鵬醫師簡歷 三軍總醫院婦產部兼任主治醫師
國軍高雄總醫院婦產科主治醫師 署立雙和醫院婦產部主治醫師暨產房主任
李木生婦產科副院長]] ,
[[懷孕是女性的人生大事，卻不見得都是按著時間表發生，無論妳準備好了沒，對自己的身體多些了解，掌握驗孕知識和驗孕產品種種，絕對是2013愛自己的最佳健康王道！本月＜美麗佳人＞透過專業婦產科醫師陳碧華，讓妳快很準做好自己的生涯規劃。

MC：生理週期不正常，就無法掌握驗孕時機？ 陳碧華：
若以28天來計算，在正常的月經週期中，第1～第5天是子宮內膜剝落期，之後第6～第13天是濾泡期，第14～第15天是排卵期，到了第16～第28天則是黃體期。而第14～第15天正是排卵（LH）高峰期，基本上，多數月經週期正常（約在28～35天範圍內）的人都可以算得出來自己的排卵期，少數人受到生理體質影響而有不規則月經排卵現象，可以至醫院做抽血、驗尿和超音波，透過醫師診斷還是找出自己的排卵期。較棘手是，愈來愈多女性因為生活緊張壓力大，又經常熬夜、飲食不正常，荷爾蒙常因此失調，這種現代人的文明病造成的月經週期不規則，除了無法計算自己的排卵期，也難以最快時間時間內知道答案。 

MC：自行驗孕和醫院驗孕，哪一個比較好？
其實現今驗孕產品的準確率已高達97%以上，對於有懷孕計劃者非常方便，畢竟跑一趟醫院驗孕，除了驗血，醫院還會幫妳驗尿和做超音波檢查，相對也比較耗時。因此，我們鼓勵妳能先自己在家驗孕，若為陽性結果，再去醫院進行更詳細的檢查。一般來說，若是月經超過2星期沒來，無論妳的週期是否規律，都可以自行驗孕。 

MC：在驗孕過程，如何掌握最佳尿液品質？
在驗孕時，要檢測的是尿液中的絨毛激素的濃度，多數人都知道，早起第一次尿液最濃，最適合做為驗孕之用，但其實要取得最佳品質的尿液，建議妳，為了讓結果更正確，在排尿時，最好先將前段（約1/3）的尿液排掉，而要收集中段的尿液來檢測，以防前段萬一有感染問題，會造檢驗時的干擾。 

MC：驗孕時，為何會有偽陰性和偽陽性？
偽陰性的結果，可能是排卵週期不規則，或是太早驗了所致。基本上，當性行為之後，一旦受精卵完成結合，就會在輸卵管內移動，約6～7天到達子宮，接著胎盤細胞就會開始繁殖，並分泌出胎盤荷爾蒙（即絨毛激素HCG），當胎盤荷爾蒙增加到一定的濃度時，這時來驗孕才會有反應。由於中間胚胎著床的時間約需8～9天，若濃度不夠，當然就驗不出來，最好再等一週待尿中的濃度足夠，再來驗孕比較準確。至於偽陽性，可能顯示出淡淡的2條線，有可能是子宮外孕，或是自然流產的徵兆，最好儘速就醫診斷；此外，如果妳為了治療不孕症而進行HCG注射療程，也可能會造成偽陽性，最好等療程7～10天身體代謝之後，再來驗孕比較準確。 

MC：各式各樣的驗孕產品讓人眼花撩亂，該如何選擇？
陳碧華： 其實驗孕產品的檢測原理，不外乎是檢測HCG絨毛指數的濃度，但不同的材質還是多少有些差異。有懷孕計畫者，驗孕頻率較高，或是追求價格便宜，使用方式簡單、如同石蕊試紙般好辨識的驗孕試紙，會是妳的好選擇；要注意的是，若一疊驗孕紙全裝在一個包裝袋裡，而不是採用單一試紙單一包裝，可能會比較容易受到潮濕污染，影響判讀結果。而好操作的驗孕筆或驗孕棒，拉開就可放進尿杯，只要跑完變色時間，約3分鐘就可以知道結果，同樣非常簡便，也是目前最多人使用的驗孕選擇。而在醫院使用的驗孕盤，市面上也買得到，採取平放的方式，操作上只要用吸管，就能精準將尿液滴到指示的位置，約5分鐘跑完，就會清楚顯示結果，可以避免筆狀驗孕產品因為置於尿液中太久，或是尿液量太多而影響判讀。醫院統計發現，北中南部對於驗孕產品的喜好都不太相同，看似琳瑯滿目的選擇，除了價格，最好還是以自己的使用需求和使用習慣為主。  ]] ,
[[提到驗孕，很多人第一個想法就是到醫院或診所，不過隨著驗孕產品愈來愈精準和多元化，DIY驗孕也蔚為風潮，到底該怎麼善加使用？來自專業婦產科醫師張建玫講解分析，帶妳深入了解女性生理和驗孕產品。

MC：如何簡單計算自己的排卵週期？ 
張建玫：一般來說，如果妳的月經規則，以28天來計算，則從月經週期的最後一天（下次月經開始的第一天）往前推14天就是排卵日；若月經週期是30天，則反推前2週就是排卵期。但如果妳的月經不規則甚至非常紊亂，就不適用於這個計算方式。 MC：市面上DIY驗孕產品琳瑯滿目，像是驗孕試紙、驗孕筆、驗孕盤、排卵試紙，它們的原理是？
張建玫：雖然市面上驗孕產品眾多，其實它們的測試原理其實相同，基本上都是利用懷孕女性的尿液，測試一種來自胎盤所產生的賀爾蒙，也就是所謂的絨毛膜激素（HCG）的濃度，來判定受孕與否。以往因為DIY驗孕產品少，使用的方式也不盡便利，近年來驗孕產品除了改良品質，在使用方式上也有更貼心的設計，判讀顯示也更清楚明瞭，但這些DIY驗孕產品只是劑型上的不同，選擇哪一種端看個人喜好。

MC：利用市售DIY驗孕產品驗孕，是否就可準確知道是否懷孕？與醫院所用的有何不同？ 其實現在的DIY驗孕產品都很進步，不但快又方便，準確率更可高達98%，在選擇時，最好有衛生署的核發的准許證字號較有保障。要注意的是，一旦驗孕產品顯示陽性反應，最好儘速至醫院作進一步診斷，因為即使驗孕產品呈現陽性反應，也不一定是正常懷孕，有些人可能會有子宮外孕、葡萄胎等不正常懷孕，甚至是其他癌症疾病的假性懷孕現象，通常醫生除了尿液外，還會以抽血和超音波合併診斷，避免發生危險。

MC：什麼時候驗孕才準確？收集尿液驗孕時，應注意哪些事項？ 基本上，在性行為後至少10天，懷孕1周之後才能驗出結果。在使用驗孕產品時，最好採用早上起床後的第一次尿液，因為經過一晚約6～8小時睡眠，尿液未被稀釋，此時的絨毛激素（HCG）濃度最高，驗孕也最為準確。

MC：在驗孕時，只要使用一種驗孕產品就可以了？判讀上需注意哪些現象 基於想要更準確的心理作用，很多人會重複驗孕好幾次，其實只要驗孕方正確，使用的不是過期不良產品，通常不需要再重複驗孕。此外，在判讀驗孕產品時，一些早期懷孕的人，可能會出現一深一淺紅色現象；而尿液浸泡驗孕產品的時間過久，則會出現兩條很淺的紅色，有可能是未懷孕。無論是哪一種驗孕產品，使用前都應詳細閱讀說明，才能避免操作錯誤導致驗孕失準。

◎DIY驗孕產品選購要訣 DIY驗孕產品因為劑型不同，在性質上也有差異，但準確率都可達99%以上。像是統一藥品推出的自我檢測驗孕筆，強調單一步驟，3分鐘即可判讀結果，準確率達99%以上；而自我檢測驗孕盤除了精確靈敏的快速測試效果，清楚明瞭的顯示設計讓人更容易判讀；另一自我檢測驗孕紙，簡便如試紙的設計，同樣3分鐘即可判讀結果；至於自我檢測排卵卡則以5分鐘判讀為設計，讓想要懷孕的妳精確做好時間規劃。
]] ,
[[對於有計畫懷孕或是想要多了解自己生理狀態的人，驗孕產品可說是快速、方便又實用的女性居家必備好物，近年來隨著科技進步，驗孕產品的準確率更是大為提高，但許多人在使用驗孕產品時，還是常因為錯誤的觀念，或是錯誤的使用、保存方式，使得驗孕結果不準確，甚至忽略可能潛在的身體健康危機。本月，＜美麗佳人＞邀來專業婦產科醫師葉紹錡，帶妳精準掌握DIY自我檢測驗孕要訣。

MC：性行為隔天，以驗孕產品來驗孕會準確嗎？ 葉紹錡：
不會！一般而言，我們的排卵在月經週期的第14天左右，一旦精卵結合成功著床之後，受精卵約需要6～7天才會開始分泌HCG(人類胎盤絨毛膜性腺激素)，最快也得要10天左右，才會大量產生HCG，而驗孕產品的測試原理，是透過檢測尿液HCG濃度來判定的。因此，想要確認是否懷孕，性行為隔天就測試並不適宜，最好在月經延遲後至少7天，再來進行測試較為準確。 MC：即使生理週期不規律，也可以計算排卵期？
所謂規律的生理週期，指的是生理期週數在21天～35天的範圍內，期間幾天的落差都算正常，但想要算出較為準確的排卵週期，生理週期落在28～30天比較好算。一般而言，月經的第一天開始至結束約莫七天，稱為濾泡期；而卵泡發育到高峰時準備排卵，稱為排卵期；至於排卵之後會產生黃體素，稱之為黃體期，大多為14天。以28天為例，扣除黃體期14天，則濾泡期是14天，而排卵期就在其中的1～2天，以此類推。儘管這也是計算安全期的簡便方法，但大多數女性的生理週期並不準確，可能因此意外受孕，或是錯過受孕時機。 

MC：使用驗孕產品時，應注意哪些事項？
首先，在進行驗孕前，一定要詳細閱讀驗孕產品的相關操作說明，並遵照尿液檢測步驟和建議等待時間；其次，驗孕時最好以早晨起床的第一次尿液為主，因為此時的HCG濃度最高，可以獲得最為準確的結果。若在其他時間驗孕，則中間最好隔4小時不要上廁所，也不要喝太多水，才不會稀釋尿液中的HCG激素，造成檢測結果不準確。要注意的是，為人工受孕而施打HCG、服用某些藥物或是一些自體免疫疾病會影響測試結果，造成偽陽性，使用前也要多留意驗孕產品的指示說明。 

MC：驗孕產品上顯示的紅線，意義為何？ 
以3分鐘顯示結果的驗孕產品為例，在判讀時，若還未到3分鐘就顯示為2條紅線，即是懷孕（陽性）；若等待至3分鐘才顯示為2條紅線，則仍可判定是懷孕（陽性）；若是等待3分鐘後，還是維持1條對照線，那就是未懷孕(陰性)。要注意的是，有些人在懷孕早期，因為週數較小，尿液中的HCG濃度較低，或是不正常的子宮外孕，都可能會呈現出淡淡紅線的弱陽性，不妨再至醫院做進一步的確認。 

◎驗孕產品哪種好？
市面上琳瑯滿目的驗孕產品，除了劑型不同，像是驗孕試紙、驗孕棒、驗孕盤、排卵卡…等等。葉紹錡指出，驗孕產品的靈敏度，可能隨著價格高低有不同的設計，但差異其實不大，基本上只要受孕後的HCG濃度夠，都可以測得準確的結果。但要注意的是，在驗孕產品存放時，最好選在室溫下通風陰涼處，不要放冰箱或是日曬，過了保存期限，期使沒開封也應開丟棄不用。
]] ,
}
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    -- cc = display.newText( _parent, "s", X, Y, font , 50 )
    bg = display.newRect( _parent, X, Y*1.07, W, H )
    bg:setFillColor( 145/255,215/255,215/255 )

    -- images = display.newRect( sceneGroup, X, H*0.294, W, H*0.421 )
    -- images:setFillColor( 0.8 )
    images = display.newImageRect( sceneGroup, imgs[rowIndex] , W*1.02 , H*0.421 )
    images.x , images.y = X, H*0.249 

    if #grayTable[rowIndex] > 0 then  
        gray = display.newRect( sceneGroup, X, H*0.4332 , W*1.02, H*0.054  )
        gray:setFillColor( 0,0,0,0.4 )

        grayText = display.newText( sceneGroup, grayTable[rowIndex], X*0.1 , H*0.4332, bold , H*0.02 )
        grayText.anchorX = 0 
    end 

   

    titleText = display.newText( sceneGroup, title[rowIndex] , X, H*0.65 , W*0.85 , H*0.2 , bold , H*0.03 )
    titleText:setFillColor( 254/255,118/255,118/255 )

    contentText = display.newText( sceneGroup, content[rowIndex], X, Y*1.3 , W*0.85, 0 , bold, W*0.0453 )
    contentText.anchorY = 0 
    contentText:setFillColor( 0 )

    whiteBg = display.newRoundedRect( sceneGroup, X, H*0.525, W*0.95,H*0.3 + contentText.height, H*0.015 )
    whiteBg.anchorY = 0 

    label_autohr = display.newImageRect( sceneGroup, "images/label_autohr@3x.png", W*0.253, H*0.033 )
    label_autohr.x , label_autohr.y = W*0.8 , H*0.525

    pink = display.newRect( sceneGroup, W*0.69, H*0.525 , W*0.0373*((#author[rowIndex]/3)-5)  , H*0.033 )
    pink.anchorX = 1 
    pink:setFillColor( 254/255,118/255,118/255 )

    authorText = display.newText( sceneGroup, author[rowIndex], W*0.88 , H*0.525, bold , W*0.0373) 
    authorText.anchorX = 1 

    banner = display.newImageRect( sceneGroup, "ad.jpg", W, H*0.079 )
    banner.x , banner.y =  X, H*0.49 + whiteBg.height 
    banner:addEventListener( "tap", bannerListener )

     scrollView = widget.newScrollView
    {
        top = Y*0.09,
        left = 0 ,
        width = W,
        height = H*0.89,
        -- hasBackground = false , 
        hideBackground = true , 
        -- scrollWidth = 600,
        -- scrollHeight = 800,
        horizontalScrollDisabled = true
    }

    sceneGroup:insert(scrollView)
    scrollView:insert(images)
    if #grayTable[rowIndex] > 0 then  
        scrollView:insert(gray)
        scrollView:insert(grayText)
    end
    scrollView:insert(whiteBg)
    scrollView:insert(label_autohr)
    scrollView:insert(banner)
    scrollView:insert(pink)
    scrollView:insert(titleText)
    scrollView:insert(authorText)
    scrollView:insert(contentText)
    
    T.title("Dr. DIY" , sceneGroup)

    local backBtn = widget.newButton({
        label = "",
        onEvent = listener,
        left = W*0.032 ,
        top = H*0.035, 
        shape = "rect",
        width = W*0.1,
        height = H*0.06,
        fontSize = H*0.05 ,
        -- font = bold ,
        fillColor = { default={254/255,118/255,118/255,0.1}, over={1,0.1,0.7,0} },
        -- labelColor = { default={ 1, 1, 1 }, over={ 0.7, 0.7, 0.7 } }
        -- } )
        -- defaultFile = "images/nav_back@3x.png" , 
        -- overFile = "" , 
        })

    local backBtnImg = display.newImageRect( sceneGroup, "images/nav_back@3x.png", W*0.032, H*0.036 )
    backBtnImg.x , backBtnImg.y = W*0.032 , H*0.05 
    backBtnImg.anchorX , backBtnImg.anchorY = 0 , 0

    sceneGroup:insert( backBtn)

    Runtime:addEventListener( "key", onKeyEvent )
end

listener = function ( e )
    if e.phase == "ended" then 
        composer.showOverlay( "DrDIY" )
    end
end

bannerListener = function ( e )
    composer.setVariable( "preScene", "newsDIY" )
    composer.showOverlay( "webView" )    
end

onKeyEvent = function( event )

    -- Print which key was pressed down/up
    local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
    print( message )
 
    -- If the "back" key was pressed on Android, prevent it from backing out of the app
    if (event.phase == "down" and event.keyName == "back") then
        --Here the key was pressed      
        downPress = true
        return true
    else 
        if ( event.keyName == "back" and event.phase == "up" and downPress ) then
            if ( system.getInfo("platform") == "android" ) then
                composer.showOverlay( "DrDIY" )
                Runtime:removeEventListener( "key", onKeyEvent )
                return true
            end
        end
    end
 
    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
    -- This lets the operating system execute its default handling of the key
    return true
end

    
 
      


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
    sceneGroup = self.view
    init(sceneGroup)
end
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
      
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        Runtime:removeEventListener( "key", onKeyEvent )
        composer.recycleOnSceneChange = true
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene
