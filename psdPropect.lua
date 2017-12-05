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
local title
local back
local prevScene = composer.getVariable( "prevScene" )
local createBtn 
local buttonEvent 
local readDb
local alertText
local titleBg
local title
local onKeyEvent
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    -- title = display.newText( _parent, "密碼保護", X, Y*0.2, font , H*0.045 )
    -- T.title("密碼保護" , sceneGroup)
    T.bg(_parent)
    titleBg = display.newImageRect( _parent, "images/bg_top@3x.png", W, H*0.07 )
    titleBg.x , titleBg.y ,titleBg.anchorY= X, Y*0.07 , 0

    title = display.newText( _parent , "密碼保護" , X, Y*0.14, bold , H*0.032 )

    -- back = display.newCircle( _parent, X*0.2, Y*0.2, H*0.045 )
    -- back:addEventListener( "tap", listener )
    T.backBtn(sceneGroup,prevScene)
    createBtn()
    -- psdSwitchBtn:setLabel( "New Label" )
    readDb()

    timer.performWithDelay( 1, function (  )
        Runtime:addEventListener( "key", onKeyEvent )
    end  )
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
                composer.showOverlay( prevScene )
                Runtime:removeEventListener( "key", onKeyEvent )
                return true
            end
        end
    end
 
    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
    -- This lets the operating system execute its default handling of the key
    return true
end


listener = function ( e )
    composer.showOverlay( prevScene )
end


createBtn = function (  )
    buttonEvent = function ( e )
        if ( "ended" == e.phase ) then
            if e.target.id == "psdSwitchBtn" then
                composer.setVariable( "setType", "set" )
                composer.showOverlay("psdSet")
            elseif e.target.id == "changePsdBtn" then 
                for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
                    if row.Protect == "ON" then 
                        composer.setVariable( "setType", "change" )
                        composer.showOverlay("psdSet")
                    elseif row.Protect == "OFF" then 
                        if alertText then
                            alertText:removeSelf( )
                        end
                        alertText = display.newText( sceneGroup, "請先設置密碼", X, Y*0.85, bold , H*0.028 )
                        alertText:setFillColor( 0 )
                    end
                end
               
            end

        end
    end

    psdSwitchBtn = widget.newButton({ 
        x = X*1,
        y = Y*0.4,
        id = "psdSwitchBtn",
        label = "開啟密碼保護",
        fontSize = H*0.03 ,
        shape = "roundedRect",
        font = bold , 
        width = W*0.7,
        height = H*0.1,
        cornerRadius = H*0.028,
        fillColor = { default={0.12,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = buttonEvent 
    })

    changePsdBtn = widget.newButton({ 
        x = X*1,
        y = Y*0.7,
        id = "changePsdBtn",
        label = "變更密碼保護",
        fontSize = H*0.03 ,
        shape = "roundedRect",
        font = bold , 
        width = W*0.7,
        height = H*0.1,
        cornerRadius = H*0.028,
        fillColor = { default={0.12,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = buttonEvent 
    })

  
    sceneGroup:insert(psdSwitchBtn)
    sceneGroup:insert(changePsdBtn)
end

readDb = function (  )
    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
        if row.Protect == "ON" then 
            psdSwitchBtn:setLabel( "關閉密碼保護" )
        elseif row.Protect == "OFF" then 
            psdSwitchBtn:setLabel( "開啟密碼保護" )
        end
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
