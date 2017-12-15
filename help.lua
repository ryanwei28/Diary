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
local tableView
local onRowRender
local bg 
local btnX 
local btnXListener 
local onKeyEvent
local text 
local textContent = [[將『個人化通知設定』的《通知功能》打開，系統便會在推算出來的時間點自動以文字做出以下提醒：

◎經期前提醒
◎易孕期（危險期）提醒
◎排卵日提醒
◎安全期提醒
◎護膚保養建議
◎驗孕通知
◎特別節日提醒（包括西洋情人節、耶誕夜、跨年夜）
◎經期一週前提醒

使用者可以設定：

◎通知時間：想收到以上提醒的時間
◎計畫：設定想懷孕或想避孕，依據不同的計劃，使用者會收到不同的文字訊息。
◎性別：可設定使用者性別，男性及女性使用者會依狀況收到不同的訊息。

如不想收到以上所有提醒，可在『個人化通知設定』中的《通知功能》切換成「OFF」。]]
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    T.bg(_parent)
    T.title("『個人化通知設定』說明" , _parent)

    btnX = widget.newButton({
        x = W*0.936,
        y = H*0.068,
        width = H*0.036,
        height = H*0.036,
        defaultFile = "images/nav_close@3x.png" ,
        overFile = "images/nav_close_press@3x.png" , 
        onRelease = btnXListener , 
    })

    sceneGroup:insert(btnX)

      scrollView = widget.newScrollView
    {
        top = Y*0.25,
        left = 0 ,
        width = W,
        height = H*0.8,
        hideBackground = true , 
        -- scrollWidth = 600,
        -- scrollHeight = 800,
        horizontalScrollDisabled = true
    }

    sceneGroup:insert(scrollView)

    text = display.newText( sceneGroup, textContent, X, Y*0.05 , W*0.9, H*1 , bold , H*0.025 )
    text.anchorY = 0
    text:setFillColor( 254/255,118/255,118/255 )
    scrollView:insert(text) 

    Runtime:addEventListener( "key", onKeyEvent )
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
                composer.showOverlay( "setup" )
                Runtime:removeEventListener( "key", onKeyEvent )
                return true
            end
        end
    end
 
    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
    -- This lets the operating system execute its default handling of the key
    return true
end

btnXListener = function ( e )
    -- composer.hideOverlay( )
    composer.showOverlay( "setup" )
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
        -- composer.recycleOnSceneChange = true
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
