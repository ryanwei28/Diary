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

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    bg = display.newRect( _parent, X, Y*1.07, W, H )
    bg:setFillColor( 145/255,215/255,215/255 )
    -- T.title("Hot News" , sceneGroup)

    -- T.creatAdWall( X , H*0.1 , imgs , sceneGroup , true)
    T.backBtn(sceneGroup , preScene)

    webView = native.newWebView( X, Y, W, H*0.8 )
    webView:request( "http://www.ppc-life.com.tw" )
  
    -- month = native.newTextField( X*0.9, Y*0.7, W*0.7, H*0.1 )
    -- _parent:insert(month)
  
    -- notificationSet.startNotify("2017/11/15" ,notificationSet.alertContent['Boy']["Bi"].pre1 )
    -- notificationSet.startNotify("2017/11/18" ,notificationSet.alertContent['Girl']["Bi"].pre1 )
    -- notificationSet.startNotify("2017/12/11" ,notificationSet.alertContent['Boy']["Huai"].dg6 )
    -- notificationSet.startNotify("2017/12/13" ,notificationSet.alertContent[sexNoti][planNoti].pre1 ,"pre1")
    -- notificationSet.startNotify("2017/12/13" ,notificationSet.alertContent[sexNoti][planNoti].holidaySafe ,"holidaySafe")

    -- notificationSet.closeNotify()
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
        webView:removeSelf( )
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
