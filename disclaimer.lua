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
local back
local prevScene = composer.getVariable( "prevScene" )
local textLC
local textBlue
local textContent
local textService
local textMail 
local textPhone 
local textAddress 
local textCompany 
local tLC = [[Legal & Compliance：]]
local tBlue = [[使用者在使用『Girl's Diary女孩日記』APP之前，請務必詳細閱讀並以下條款，一旦開始使用本應用程式，即代表同意下列條款。]]
local tContent = [[1. 本應用程式所提供之所有訊息包括文字內容、圖片、表格等僅供使用者參考，並不能作為個別診斷、治療、用藥、想避孕或想懷孕的依據。本應用程式已致力於提供正確的資訊，但本公司並不保證相關資料的正確性、即時性或完整性，對於前述資料之錯誤或缺漏導致之損害或影響，本公司並不負擔任何賠償責任。

2. 本應用程式所提供之任何建議、提醒或醫藥資訊僅供參考，並不能取代醫師之診斷。關於程式中保養提醒、排卵期提醒、安全期提醒、易孕(危險)期提醒、避孕提醒等資訊，皆為依照使用者輸入的資料及選擇的計算方式來推算，僅提供參考，如因使用本應用程式或因其內容導致任何非預期（如：意外懷孕或未能如預期懷孕等）的結果，本公司不負擔任何賠償責任。

3. 本應用程式適用對象為月經規律之使用者，如您的月經期不規律，不建議使用本應用程式來預測身體的安全期、易孕期、排卵日等狀況。如您有月經週期不規律之情況，建議請教專科醫師諮詢合宜的推算方式。

4. 關於安全期或排卵期、易孕期的推算僅供參考。因每位女性身體狀況不同，本應用程式推算之排卵日為理論上的排卵日，實際上仍有可能提早或延後。且因每個人的身體狀況不同，建議在預測的安全期中進行性行為時，想避孕的使用者仍要採取適當的避孕措施。

5. 本應用程式僅提供單純的經期追蹤，考量到安全性並不收集您的個人資料或隱私權資訊，恕不提供任何資料備份及儲存功能，為避免不可預知的錯誤影響手機運作，請您於操作本應用程式應備份重要資料。

6. 使用本應用程式將可能啟動手機之3G資料傳輸功能，於使用前請確認您的資料傳輸費率及限制，對於您因使用本應用程式而增加之資料傳輸費用、漫遊費用或相關電信資費，本公司概不負責。

7. 若因操作不當而影響手機正常功能，本公司恕不負責維修及任何賠償責任。

8. 本應用程式及其中所有文字、圖片、表格或任何涉及著作權、商標權及相關智慧財產權，皆歸屬統一藥品股份有限公司所有，請勿為任何不法使用。

9. 本應用程式係由威納科技團隊開發、設計，並經實際安裝測試。]]
local tService =  [[如有任何建議或指教，請與我們聯絡，我們將竭誠為您服務。]]
local tMail = [[ppcbrandCS@ppcmail.com.tw]]
local tPhone = [[+886227488299 ext.323]]
local tAddress = [[105台北市松山區東興路8號7樓 ]]
local tCompany = [[統一藥品股份有限公司]]
local taplistener 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    -- cc = display.newText( _parent, "免責聲明", X, Y, font , 50 )
    T.bg(_parent)
    T.title("免責聲明" , sceneGroup)
    T.backBtn(_parent , prevScene)

    textLC = display.newText( _parent, tLC, X*1, Y*0.05, bold , H*0.025)
    textLC.anchorY = 0
    textLC:setFillColor( 0.1 )

    textBlue = display.newText( _parent, tBlue , X*0.1, Y*0.18 , W*0.9, H*0.3, bold , H*0.026)
    textBlue.anchorX , textBlue.anchorY = 0 , 0
    textBlue:setFillColor( 0,0,1 )

    textContent = display.newText( _parent, tContent, X*0.1, Y*0.5 , W*0.9, H*2.2, bold , H*0.026)
    textContent.anchorX , textContent.anchorY = 0 , 0
    textContent:setFillColor( 0.1 )

    print( textContent.y )
    textService = display.newText( _parent, tService, X*0.1, Y*4.4 , W*0.9, H*0.2, bold , H*0.026)
    textService.anchorX , textService.anchorY = 0 , 0
    textService:setFillColor( 0.1 )

    textMail = display.newText( _parent, tMail, X*0.1, Y*4.55 , bold , H*0.026)
    textMail.id = "mail"
    textMail.anchorX , textMail.anchorY = 0 , 0
    textMail:setFillColor( 0,0,1 )

    textPhone = display.newText( _parent, tPhone, X*0.1, Y*4.63 , bold , H*0.026)
    textPhone.id = "phone"
    textPhone.anchorX , textPhone.anchorY = 0 , 0
    textPhone:setFillColor( 0,0,1 )

    textAddress = display.newText( _parent, tAddress, X*0.1, Y*4.71 , bold , H*0.026)
    textAddress.id = "address"
    textAddress.anchorX , textAddress.anchorY = 0 , 0
    textAddress:setFillColor( 0,0,1 )

    textCompany = display.newText( _parent, tCompany, X*0.1, Y*4.79 , bold , H*0.026)
    textCompany.anchorX , textCompany.anchorY = 0 , 0
    textCompany:setFillColor( 0.1 )

    scrollView = widget.newScrollView(
        {
            top = Y*0.22,
            left = X*0,
            width = W*1,
            height = H*0.8,
            isBounceEnabled = false ,
            hideBackground = true ,
            scrollWidth = 600,
            scrollHeight = 800,
            horizontalScrollDisabled = true 
            -- listener = scrollListener
        }
    )

    sceneGroup:insert(scrollView)
    scrollView:insert(textLC)
    scrollView:insert(textBlue)
    scrollView:insert(textContent)
    scrollView:insert(textService)
    scrollView:insert(textMail)
    scrollView:insert(textPhone)
    scrollView:insert(textAddress)
    scrollView:insert(textCompany)
    -- scrollView:insert(text)

    textMail:addEventListener( "tap", taplistener )
    textPhone:addEventListener( "tap", taplistener )
    textAddress:addEventListener( "tap", taplistener )

end

taplistener = function ( e )
   
   if e.target.id == "mail" then
       local options =
       {
          to = "ppcbrandCS@ppcmail.com.tw",
          -- subject = "My High Score",
          -- body = "I scored over 9000!!! Can you do better?",
          -- attachment = { baseDir=system.DocumentsDirectory, filename="Screenshot.png", type="image/png" }
       }
       native.showPopup( "mail", options )
       print("mail")
   elseif e.target.id == "phone" then 
       

        local function alertListener( e )
           if e.index == 1 then
                print( 1 )
            elseif e.index == 2 then 
                system.openURL( "tel:+886227488299p323" )
                print( 2 )
            end
       end

       native.showAlert( "", "+886227488299 ext.323" , {"取消","通話"} , alertListener )
       print( "phone" )
   elseif e.target.id == "address" then
       print( "address" )
   end
end

-- listener = function ( e )
--     composer.showOverlay( prevScene )
-- end


    
 
      


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
