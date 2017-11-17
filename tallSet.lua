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
local listener
local pickerWheel
local textField
local cmText
local textListener 
local tallText = ""
local setBtnEvent 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )


    title = display.newText( _parent, "身高設定", X, Y*0.2, font , 50 )
    cmText = display.newText( _parent, "單位:公分", X, Y*0.6, font , 30 )

    back = display.newCircle( _parent, X*0.2, Y*0.2, 50 )
    back:addEventListener( "tap", listener )

    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1]]) do
        tt = row.Height
    end

    textField = native.newTextField( X, Y*0.5, W*0.3, H*0.05 )
    textField.placeholder = tt
    textField.inputType = "number"
    textField:addEventListener( "userInput", textListener )
    _parent:insert(textField)

    local cancelBtn = widget.newButton({ 
        x = X*0.7 ,
        y = Y*0.8,
        id = "cancelBtn",
        label = "取消",
        fontSize = 30 ,
        shape = "roundedRect",
        width = W*0.2,
        height = H*0.08,
        cornerRadius = 20,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = setBtnEvent 
    }) 

    _parent:insert(cancelBtn)

    local confirmBtn = widget.newButton({ 
        x = X*1.3 ,
        y = Y*0.8,
        id = "confirmBtn",
        label = "確定",
        fontSize = 30 ,
        shape = "roundedRect",
        width = W*0.2,
        height = H*0.08,
        cornerRadius = 20,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = setBtnEvent 
    })
     _parent:insert(confirmBtn)

end

listener = function ( e )
    native.setKeyboardFocus( nil )
    composer.showOverlay( "setup" )
end

setBtnEvent = function ( e )
    if e.phase == "ended" then 
        if e.target.id == "cancelBtn" then
            native.setKeyboardFocus( nil )
            composer.showOverlay( "setup" )
        elseif e.target.id == "confirmBtn" then
            native.setKeyboardFocus( nil )
            database:exec([[UPDATE Setting SET Height =']]..tallText..[[' WHERE id =1;]])
            composer.showOverlay( "setup" )
        end
    end
end

textListener = function( event )
    if ( event.phase == "began" ) then
     
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        native.setKeyboardFocus( nil )
    elseif ( event.phase == "editing" ) then
        tallText = event.text 
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
