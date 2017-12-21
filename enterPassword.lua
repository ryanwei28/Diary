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
local enterText 
local inputPsw
local inputPsw2
local inputPsw3
local inputPsw4
local c1 
local c2
local c3 
local c4
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    -- title = display.newText( _parent, "輸入密碼", X, Y*0.2, font , 50 )
    
    T.bg(sceneGroup) 
    T.title("輸入密碼" , sceneGroup)


    alertText = display.newText( _parent, "", X, Y*0.5 , font , 30 )
    textField = native.newTextField( X, H*3, W*0.7, H*0.05 )
    textField.placeholder = "請輸入密碼"
    textField.inputType = "number"
    -- textField.isSecure = true
    native.setKeyboardFocus( textField )
    textField:addEventListener( "userInput", textListener )
    _parent:insert(textField)
    -- enterBtn()

    enterText = display.newText( sceneGroup, "輸入您的密碼", X, H*0.156 , bold , H*0.027 )
    enterText:setFillColor( 77/255,77/255,102/255 )

    inputPsw = display.newImageRect( sceneGroup, "images/input_pw@3x.png", W*0.16 , H*0.078 )
    inputPsw.x , inputPsw.y = W*0.221 ,H*0.25
    inputPsw:addEventListener( "tap", listener )
    c1 = display.newCircle( sceneGroup, W*0.221 , H*0.25, H*0.015 )
    c1:setFillColor( 0 ) 
    c1.alpha = 0

    inputPsw2 = display.newImageRect( sceneGroup, "images/input_pw@3x.png", W*0.16 , H*0.078 )
    inputPsw2.x , inputPsw2.y = W*0.408 ,H*0.25
    inputPsw2:addEventListener( "tap", listener )
    c2 = display.newCircle( sceneGroup,  W*0.408 ,H*0.25 , H*0.015 )
    c2:setFillColor( 0 ) 
    c2.alpha = 0

    inputPsw3 = display.newImageRect( sceneGroup, "images/input_pw@3x.png", W*0.16 , H*0.078 )
    inputPsw3.x , inputPsw3.y = W*0.595 ,H*0.25
    inputPsw3:addEventListener( "tap", listener )
    c3 = display.newCircle( sceneGroup, W*0.595 ,H*0.25 , H*0.015 )
    c3:setFillColor( 0 ) 
    c3.alpha = 0

    inputPsw4 = display.newImageRect( sceneGroup, "images/input_pw@3x.png", W*0.16 , H*0.078 )
    inputPsw4.x , inputPsw4.y = W*0.782 ,H*0.25
    inputPsw4:addEventListener( "tap", listener )
    c4 = display.newCircle( sceneGroup, W*0.782 ,H*0.25 , H*0.015 )
    c4:setFillColor( 0 ) 
    c4.alpha = 0

    alertText = display.newText( sceneGroup, "", X, Y*0.65, bold , H*0.023 )
    alertText:setFillColor( 77/255,77/255,102/255 )

    if tabBar then
        tabBar:removeSelf()
    end

    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
        if row.Protect ~= "ON" then
            composer.gotoScene( "mainUI" )
        end
    end
end

listener = function (  )
    native.setKeyboardFocus( textField )
end

enterBtn = function (  )
    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
        if psd == row.Password then
            native.setKeyboardFocus( nil )
            composer.gotoScene( "mainUI" )
        else
            alertText.text = "密碼錯誤。請重新輸入"
            textField.text = ""
            c1.alpha = 0
            c2.alpha = 0 
            c3.alpha = 0 
            c4.alpha = 0
            native.setKeyboardFocus( textField )
        end
    end 
end

textListener = function( event )
    if ( event.phase == "began" ) then
     
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- native.setKeyboardFocus( nil )
    elseif ( event.phase == "editing" ) then
        psd = event.text
        if #psd == 0 then
            c1.alpha = 0
        elseif #psd == 1 then 
            alertText.text = ""
            c1.alpha = 1
            c2.alpha = 0
            -- c3.alpha = 0 
            -- c4.alpha = 0
        elseif #psd == 2 then 
            c2.alpha = 1
            c3.alpha = 0
        elseif #psd == 3 then 
            c3.alpha = 1
            c4.alpha = 0
        elseif #psd == 4 then 
            c4.alpha = 1
            enterBtn()
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
        native.setKeyboardFocus( nil )
        if textField then 
            textField:removeSelf( )
        end 
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
