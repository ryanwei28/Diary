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
    "Dr. DIY 美麗問診室"  ,
    "DIY驗孕知識全攻略"  ,
    "不可不知驗孕快狠準關鍵字"  ,
    "帶妳精準掌握DIY自我檢測驗孕要訣"  ,

    "沒有月經還會排卵嗎?\n但月經規律，是否就表示排卵正常?"  ,
}

local imgs = {
    "1.jpg"  ,
    "2.jpg"  ,
    "3.jpg"  ,
    "4.jpg"  ,
    "5.jpg"  ,
}

local author = {
    -- "張芳維醫師" , 
    -- "毛士鵬醫師" , 
    -- "雙和醫院婦產部 生殖醫學中心 陳碧華醫師" , 
    -- "張建枚醫師" , 
    -- "耕莘醫院永和分院婦產科 葉紹錡醫師" , 
    "Dr. DIY" ,
    "Dr. DIY" ,
    "Dr. DIY" ,
    "Dr. DIY" ,
    "Dr. DIY" ,
}

local grayTable = {
    -- "懷孕是幸福的，男女都好，只要健健康康" , 
    -- "李木生婦產科副院長毛士鵬醫師" , 
    "" , 
    "" , 
    "" ,
    "" ,
    "" ,
   }

local content = {
[[·請問月經過後多久可以自行驗孕?

排卵期是在月經週期的第14天左右，而卵子若受精成功，大約在8~9天後就可以利用驗孕產品測出是否懷孕。若是真有懷孕，間隔越久體內激素越高，效果自然越準確。


·如驗孕產品上的顯示結果線非常微弱，這樣代表有懷孕嗎? 

若驗孕產品上出現的檢測線微弱，可以先確認檢測的尿量是否足夠、驗孕產品是否還在使用期限內、是否有正確使用驗孕產品，以上因素都會影響驗孕的正確性。排除前面幾種狀況，正常使用驗孕產品，淡紅線就有可能代表懷孕前期。懷孕前期因體內的激素分泌量較少，出現的檢測線可能是比較顏色較淡的紅線。


·如何判別驗孕產品上的紅線? 

驗孕產品使用的檢測原理，大約在10秒左右就可以有結果產生。如果使用後3~5分鐘內有陽性反應的紅線浮出，那麼就是有懷孕；如果超過10分鐘以上才有紅線出現，檢測結果就有可能是假陽性，建議可以過一段時間後再重新檢驗。


·若第一次驗孕的結果沒有懷孕跡象，但生理期遲遲還未來，還需要重複檢驗嗎? 

第一次驗孕後，若是沒有懷孕跡象，可以於間隔一個禮拜後再重新檢驗一次。如第二次檢測結果依然沒有懷孕跡象，其間也沒有發生性行為，就可以暫時排除懷孕的可能性。


·如何選購市面上販售的驗孕產品? 

驗孕產品的檢測原理，不外乎是檢測HCG絨毛指數的濃度，但不同的材質還是多少有些差異。有懷孕計畫者，驗孕頻率較高，或是追求價格便宜，使用方式簡單，驗孕試紙會是妳的好選擇；要注意的是，若一疊驗孕紙全裝在一個包裝袋裡，而不是採用單一試紙單一包裝，可能會比較容易受到潮濕污染，影響判讀結果。好操作的驗孕筆或驗孕棒，拉開就可放進尿杯，只要跑完變色時間，約3分鐘就可以知道結果，也是目前最多人使用的驗孕選擇。而在醫院使用的驗孕盤，市面上也買得到，採取平放的方式，操作上只要用吸管，就能精準將尿液滴到指示的位置，約5分鐘跑完，就會清楚顯示結果，可以避免筆狀驗孕產品因為置於尿液中太久，或是尿液量太多而影響判讀。除了價格，最好還是以自己的使用需求和使用習慣為主。

 ]] ,

[[·如何簡易計算自己的排卵週期？

如果妳的月經規則，以28天來計算，則從月經週期的最後一天（下次月經開始的第一天）往前推14天就是排卵日；若月經週期是30天，則反推前2週就是排卵期。但如果妳的月經不規則甚至非常紊亂，則不適用於這個計算方式。


·利用市售DIY驗孕產品驗孕，是否就可準確知道是否懷孕？與醫院所用的有何不同？

現在的DIY驗孕產品都很進步，快又方便，建議在選擇時，最好有衛生署的核發的准許證字號較有保障。該注意的是，一旦驗孕產品顯示陽性 (懷孕) 反應，最好儘速至醫院作進一步診斷，即使驗孕產品呈現陽性反應，也不一定是正常懷孕，有些人可能會有子宮外孕、葡萄胎等不正常懷孕，甚至是其他癌症疾病的假性懷孕現象，通常醫生除了尿液外，還會以抽血和超音波合併診斷，避免發生危險。


·驗孕時，只要使用一種驗孕產品就可以了？判讀上需注意哪些現象？

基於想要更準確的心理作用，很多人會重複驗孕好幾次，其實只要驗孕方式正確，使用的不是過期的不良產品，通常是不需要再重複驗孕的。此外，在判讀驗孕產品時，一些早期懷孕的人，可能會出現一深一淺紅色現象；而尿液浸泡驗孕產品的時間過久，則會出現兩條很淺的紅色，有可能是未懷孕。無論是哪一種驗孕產品，使用前都應詳細閱讀說明，才能避免操作錯誤導致驗孕失準。

]],

[[·生理週期不正常，是否就無法掌握驗孕時機？

若以28天來計算，在正常的月經週期中，第1至第5天是子宮內膜剝落期，之後的第6至第13天是濾泡期，第14至第15天是排卵期，到了第16至第28天則是黃體期，而第14至第15天正是排卵高峰期。多數月經週期正常（約在28至35天範圍內）的人都可以計算出自己的排卵期，少數人受到生理體質影響而有不規則月經排卵現象，可以至醫院或診所做抽血、驗尿和超音波，透過醫師診斷找出自己的排卵期。


·自行驗孕和醫院驗孕，哪一個比較好？

現今驗孕產品的準確率已高達98%以上，對於有計劃懷孕者非常方便，畢竟跑一趟醫院驗孕，相對也比較耗時。 因此，建議妳能先自己在家驗孕，若為陽性 (懷孕) 結果，再去醫院做更詳細的檢查。一般來說，若是月經超過2星期沒來，無論妳的週期是否規律，都可以自行驗孕。


·驗孕過程，如何掌握最佳尿液品質？

在驗孕時，檢測的是尿液中絨毛激素的濃度，大多數人都知道，早起第一次尿液最濃，最適合做為驗孕之用，但其實要取得最佳品質的尿液，建議妳，為了讓結果更正確，最好先將前段約1/3的尿液排掉，而要收集中段的尿液來檢測，以防前段萬一有感染問題，會造檢驗時的干擾。


·驗孕時，為何會有偽陰性和偽陽性？

當性行為之後，一旦受精卵完成結合，就會在輸卵管內移動，約6～7天到達子宮，接著胎盤細胞就會開始繁殖，並分泌出胎盤荷爾蒙，當胎盤荷爾蒙增加到一定的濃度時，這時驗孕才會有反應。由於中間胚胎著床的時間約需8～9天，若濃度不夠，就有可能驗不出來，建議最好再等一週待尿中的濃度足夠，再來驗孕比較準確。
至於偽陽性，可能顯示出淡淡的2條線，有可能是子宮外孕，或是自然流產的徵兆，最好儘速就醫診斷；此外，如果妳為了治療不孕症而進行HCG注射療程，也可能會造成偽陽性，最好等療程7～10天身體代謝之後，再來驗孕比較準確。
]] ,

[[·性行為隔天，以驗孕產品來驗孕會準確嗎？

一般而言，排卵在月經週期的第14天左右，一旦精卵結合成功著床之後，受精卵約需要6到7天才會開始分泌人類胎盤絨毛膜性腺激素 (HCG)，而最快也得要10天左右，才會大量產生HCG。驗孕產品的檢測原理，是透過檢測尿液HCG濃度來判定的。因此，想要確認是否懷孕，性行為隔天就檢測並不適宜，最好在月經延遲後至少7天，再進行測試較為準確。


·即使生理週期不規律，也可以計算排卵期嗎？

規律的生理週期，指的是生理期週數在21天～35天的範圍內，期間的幾天落差都算正常，但想要算出較為準確的排卵週期，生理週期如落在28～30天會比較好算。一般而言，月經的第一天開始至結束約莫七天，稱為濾泡期；而卵泡發育到高峰時準備排卵，稱為排卵期；至於排卵之後會產生黃體素，稱之為黃體期，大多天數為14天。以28天為例，扣除黃體期14天，則濾泡期是14天，而排卵期就在其中的1～2天，以此類推。儘管這也是計算安全期的簡易方法，但大多數女性的生理週期並不準確，可能因此意外受孕，或是錯過受孕時機。


·使用驗孕產品時，應多注意哪些事項？

進行驗孕前，一定要詳細閱讀驗孕產品的相關操作說明，並遵照尿液檢測步驟和建議等待時間。驗孕時最好以早上起床的第一次尿液為主，因為此時的HCG濃度最高，可以得到最為準確的結果。若在其他時間驗孕，則中間最好隔4小時不要上廁所，也不要喝太多水，以避免稀釋尿液中的HCG激素而造成檢測結果不準確。該注意的是，如為人工受孕而施打HCG、服用某些藥物或是一些自體免疫疾病會影響測試結果，造成偽陽性，使用前也要多留意驗孕產品的指示說明。


·驗孕產品上顯示的紅線，意義為何？ 

以3分鐘顯示結果的驗孕產品為例，在判讀時，若還未到3分鐘就顯示為2條紅線，即是陽性（懷孕）；若等待至3分鐘才顯示為2條紅線，則仍可判定是陽性（懷孕）；若是等待3分鐘後，還是維持1條對照線，那就是陰性（未懷孕）。要注意的是，有些人在懷孕早期，因週數較小，尿液中的HCG濃度較低，或是不正常的子宮外孕，都可能會呈現出淡淡紅線的弱陽性，不妨再至醫院或診所做進一步的確認。

]],
[[月經和排卵的關係密切，排卵決定月經，如果沒有排卵，就不會有月經；更確切地說，沒有排卵就沒有排卵性月經。因此，判斷月經是否正常，應首先判斷有沒有排卵，有排卵的月經是正常的。

月經和排卵都受腦下垂體和卵巢的內分泌激素的影響而呈現週期性變化，兩者的周期長短大多是一致的，都是每個月1個週期。

女性的月經週期有長有短，但排卵日與下次月經開始之間的間隔時間比較固定，一般在14天左右。根據排卵和月經之間的這種關係，就可以按月經週期來推算排卵期。推算方法是從下次月經來潮的第1天算起，倒數14天就是排卵日。

用這種方法推算排卵期，首先要知道月經週期的長短，才能推算出下次月經來潮的開始日期和排卵期，所以只能適用於月經週期一向正常的女性。對於月經週期不規則的女性則比較無法推算出下次月經來潮的日期，故也無法推算到排卵日和排卵期。

有時因健康情況、環境改變及情緒波動等可以使排卵推遲或提前，這樣按月經週期推算出來的排卵期就不夠正確。

通過對月經和排卵的關係的分析，我們可以了解到，排卵正常，月經才會正常。但相反地，如月經規律就代表排卵正常嗎？

規則的月經週期不一定就有正常的排卵。因為正常的排卵是一個很複雜的過程，包括需要適量的荷爾蒙以及必須在適當的時間發生，如微妙的荷爾蒙不平衡或排卵的異常就可能會導致較差的受孕能力。

]] 
}

local content2 = {
--     [[Q4:飲食、酒精或藥物是否會影響驗孕結果? 就像酒測時大量喝水並不會影響血液裡的酒精濃度，一般飲食、飲酒和藥物並不會影響到血液與尿液中的HCG濃度，除非是服用或施打荷爾蒙相關藥物，才會讓HCG變化，影響驗孕結果。

-- Q5:取尿液樣時有什麼需要特別注意的地方嗎? 一般醫師建議取用中段尿液是為了避免前、後段的細菌雜質影響檢測結果，不過就驗孕來說差異其實不大，重點是依照各產品包裝上的指示操作，避免在尿液取樣時取樣過多或過少，而出現偽陽性影響檢測的準確率。

-- ◎張芳維醫師簡歷 三軍總醫院婦產部主治醫師
-- 國防醫學院醫學系醫學士 國防醫學院婦產學科助理教授]]
[[]] , 
    [[]] , 
    [[]] , 
    [[]] , 
    [[]] , 
}

local heightTable = {
    H*4, 
    H*16,
    H*16,
    H*3,
    H*4,
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

    if H > 1000 then 
        contentText.y = Y*1.5
    end

    contentText2 = display.newText( sceneGroup, content2[rowIndex], X, H*0.62+contentText.height , W*0.85, 0 , bold, W*0.0453 )
    contentText2.anchorY = 0 
    contentText2:setFillColor( 0 )


    whiteBg = display.newRoundedRect( sceneGroup, X, H*0.525, W*0.95,H*0.3 + contentText.height + contentText2.height, H*0.015 )
    whiteBg.anchorY = 0 

    label_autohr = display.newImageRect( sceneGroup, "images/label_autohr@3x.png", W*0.253, H*0.033 )
    label_autohr.x , label_autohr.y = W*0.8 , H*0.525

    pink = display.newRect( sceneGroup, W*0.69, H*0.525 , W*0.0373*((#author[rowIndex]/3)-5)  , H*0.033 )
    pink.anchorX = 1 
    pink:setFillColor( 254/255,118/255,118/255 )

    authorText = display.newText( sceneGroup, author[rowIndex], W*0.85 , H*0.525, bold , W*0.0373) 
    authorText.anchorX = 1 

    -- banner = display.newImageRect( sceneGroup, "ad.jpg", W, H*0.079 )

    banner = display.newImageRect( sceneGroup, "banner.jpg", system.DocumentsDirectory ,  W, H*0.079 )
   
    if banner then 
        banner.x , banner.y =  X, H*0.49 + whiteBg.height 
        banner:addEventListener( "tap", bannerListener )
    end

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
    scrollView:insert(contentText2)
    


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
