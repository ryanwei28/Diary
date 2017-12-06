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
local tt
local backBtn
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )

    T.title("身高設定" , sceneGroup)

    -- title = display.newText( _parent, "身高設定", X, Y*0.2, font , H*0.045 )
    cmText = display.newText( _parent, "單位:公分", X, Y*0.6, font , H*0.028 )

    backBtn = widget.newButton({
        label = "",
        onEvent = listener,
        left = W*0.032 ,
        top = H*0.035, 
        -- shape = "rect",
        width = W*0.1,
        height = H*0.08,
        fontSize = H*0.05 ,
        -- font = bold ,
        fillColor = { default={1,1,1,0}, over={1,0.1,0.7,0} },
        -- labelColor = { default={ 1, 1, 1 }, over={ 0.7, 0.7, 0.7 } }
        -- } )
        -- defaultFile = "images/nav_back@3x.png" , 
        -- overFile = "" , 
        })

    local backBtnImg = display.newImageRect( sceneGroup, "images/nav_back@3x.png", W*0.032, H*0.036 )
    backBtnImg.x , backBtnImg.y = W*0.032 , H*0.05 
    backBtnImg.anchorX , backBtnImg.anchorY = 0 , 0

    sceneGroup:insert( backBtn)
    -- back = display.newCircle( _parent, X*0.2, Y*0.2, H*0.045 )
    -- back:addEventListener( "tap", listener )

    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1]]) do
        tt = row.Height
    end

    textField = native.newTextField( X, Y*0.5, W*0.3, H*0.05 )
    textField.placeholder = tt
    textField.inputType = "number"
    textField:addEventListener( "userInput", textListener )
    _parent:insert(textField)

    local cancelBtn = widget.newButton({ 
        x = X*0.76 ,
        y = Y*0.8,
        id = "cancelBtn",
        label = "取消",
        font = bold , 
        fontSize = H*0.03 ,
        width = W*0.213 ,
        height = H*0.054,
        shape = "roundedRect",
        cornerRadius  = H*0.009,
        fillColor = { default={254/255,118/255,118/255,1}, over={90/255,48/255,62/255,1} },
        labelColor = {default = {1,1,1} , over = {1,1,1} } ,
        onEvent = setBtnEvent 
    }) 

    _parent:insert(cancelBtn)

    local confirmBtn = widget.newButton({ 
        x = X*1.24 ,
        y = Y*0.8,
        id = "confirmBtn",
        label = "確定",
        font = bold , 
        fontSize = H*0.03 ,
        width = W*0.213 ,
        height = H*0.054,
        shape = "roundedRect",
        cornerRadius  = H*0.009,
        fillColor = { default={254/255,118/255,118/255,1}, over={90/255,48/255,62/255,1} },
        labelColor = {default = {1,1,1} , over = {1,1,1} } ,
        onEvent = setBtnEvent 
    })
     _parent:insert(confirmBtn)

end

listener = function ( e )
    if e.phase == "ended" then
        native.setKeyboardFocus( nil )
        composer.showOverlay( "setup" )
    end
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
