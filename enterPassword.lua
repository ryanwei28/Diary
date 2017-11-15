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
local enterBtn
local textListener
local psd = ""
local textField 
local alertText
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    title = display.newText( _parent, "輸入密碼", X, Y*0.2, font , 50 )

    alertText = display.newText( _parent, "", X, Y*0.5 , font , 30 )
    textField = native.newTextField( X, Y*0.4, W*0.7, H*0.05 )
    textField.placeholder = "請輸入密碼"
    textField.isSecure = true
    textField:addEventListener( "userInput", textListener )
    _parent:insert(textField)
    enterBtn()

    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
        if row.Protect ~= "ON" then
            composer.gotoScene( "mainUI" )
        end
    end
end

enterBtn = function (  )
    enterBtnEvent = function ( e )
        if e.phase == "ended" then
            if psd == "" then
                alertText.text = "請輸入密碼"
            else
                for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
                    if psd == row.Password then
                        composer.gotoScene( "mainUI" )
                    else
                        alertText.text = "密碼錯誤"
                    end
                end
            end
        end
    end

    local enterBtn = widget.newButton( {
        x = X*1 ,
        y = Y*0.65,
        id = "updateBtn",
        label = "確定",
        fontSize = 30 ,
        shape = "roundedRect",
        width = W*0.2,
        height = H*0.08,
        cornerRadius = 20,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = enterBtnEvent 
    } )                 

    sceneGroup:insert(enterBtn)  
end

textListener = function( event )
    if ( event.phase == "began" ) then
     
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        
    elseif ( event.phase == "editing" ) then
        psd = event.text
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
        textField:removeSelf( )
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
