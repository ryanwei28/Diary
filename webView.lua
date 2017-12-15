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
local month
local banner
local preScene = composer.getVariable( "preScene" )
local webView
local pink 
local backBtn 
local listener 
local black 
local preBtn 
local nextBtn 
local reloadBtn 
local stopBtn 
local openNewBtn 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    bg = display.newRect( _parent, X, Y*1.07, W, H )
    bg:setFillColor( 145/255,215/255,215/255 )
    -- T.title("Hot News" , sceneGroup)

    -- T.creatAdWall( X , H*0.1 , imgs , sceneGroup , true)




    webView = native.newWebView( X, Y*0.07+H*0.066, W, H*0.76 )
    webView.anchorY = 0 
    _parent:insert(webView)
    webView:request( "http://www.ppc-life.com.tw" )
    
    pink = display.newImageRect( _parent, "images/web_navbar@3x.png", W, H*0.066 )
    pink.anchorY = 0 
    pink.x , pink.y = X , Y*0.07

    backBtn = widget.newButton( {
        x = W*0.08,
        y = H*0.067, 
        width = W*0.133 ,
        height = H*0.045 ,
        defaultFile = "images/web_back@3x.png",
        overFile = "images/web_back_press@3x.png", 
        onEvent = listener ,

        } )

    _parent:insert(backBtn)

    black =  display.newImageRect( _parent, "images/web_tabbar@3x.png", W, H*0.0764 )
    black.anchorY = 0 
    black.x , black.y = X , H*0.85

    preBtn =  display.newImageRect( _parent, "images/web_prev@3x.png",  H*0.045, H*0.045 )
    preBtn.anchorY = 0 
    preBtn.x , preBtn.y = W*0.07 , H*0.865

    nextBtn =  display.newImageRect( _parent, "images/web_next@3x.png",  H*0.045, H*0.045 )
    nextBtn.anchorY = 0 
    nextBtn.x , nextBtn.y = W*0.2 , H*0.865

    stopBtn =  display.newImageRect( _parent, "images/web_stop@3x.png", H*0.045, H*0.045 )
    stopBtn.anchorY = 0 
    stopBtn.x , stopBtn.y = W*0.4 , H*0.865

    reloadBtn =  display.newImageRect( _parent, "images/web_reload@3x.png", H*0.045, H*0.045 )
    reloadBtn.anchorY = 0 
    reloadBtn.x , reloadBtn.y = W*0.78 , H*0.865

    openNewBtn =  display.newImageRect( _parent, "images/web_share@3x.png", H*0.045, H*0.045 )
    openNewBtn.anchorY = 0 
    openNewBtn.x , openNewBtn.y = W*0.92 ,  H*0.865
    -- month = native.newTextField( X*0.9, Y*0.7, W*0.7, H*0.1 )
    -- _parent:insert(month)
  
    -- notificationSet.startNotify("2017/11/15" ,notificationSet.alertContent['Boy']["Bi"].pre1 )
    -- notificationSet.startNotify("2017/11/18" ,notificationSet.alertContent['Girl']["Bi"].pre1 )
    -- notificationSet.startNotify("2017/12/11" ,notificationSet.alertContent['Boy']["Huai"].dg6 )
    -- notificationSet.startNotify("2017/12/13" ,notificationSet.alertContent[sexNoti][planNoti].pre1 ,"pre1")
    -- notificationSet.startNotify("2017/12/13" ,notificationSet.alertContent[sexNoti][planNoti].holidaySafe ,"holidaySafe")

    -- notificationSet.closeNotify()
end

listener = function ( e )
    if e.phase == "ended" then 
        composer.showOverlay( preScene )
    end 
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
        -- webView:removeSelf( )
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
