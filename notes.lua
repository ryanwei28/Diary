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
local textListener
local msgBox
local addSaveBtn
local saveBtn 
local saveBtnEvent
local dbDate = composer.getVariable( "dbDate" )
local noteContent = ""
local backBtn
local bg_green 
local onKeyEvent 
local backBtnImg
local noteShadow
local whiteBg 
local bird 
local product 
local redText 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    -- title = display.newText( _parent, "紀錄", X, Y*0.2, font , 50 )
    T.bg(sceneGroup)

    bg_green = display.newImageRect( _parent, "images/bg_green@3x.png", W, H*0.602 )
    bg_green.x , bg_green.y = X , Y * 1.398
    T.title("紀錄" , sceneGroup)
     
    backBtn = widget.newButton({
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

    backBtnImg = display.newImageRect( sceneGroup, "images/nav_back@3x.png", W*0.032, H*0.036 )
    backBtnImg.x , backBtnImg.y = W*0.032 , H*0.05 
    backBtnImg.anchorX , backBtnImg.anchorY = 0 , 0

    noteShadow = display.newImageRect( sceneGroup, "images/note_shadow@3x.png", W*0.866, H*0.764 )
    noteShadow.x , noteShadow.y = X , H*0.523

    whiteBg = display.newRect( sceneGroup, W*0.513, H*0.512, W*0.825, H*0.736 )

    bird = display.newImageRect( sceneGroup, "images/bird_1@3x.png", W*0.096 , H*0.072 )
    bird.x , bird.y = W*0.165  , H*0.192

    product = display.newImageRect( sceneGroup, "images/product_2@3x.png", W*0.0666, H*0.123 )
    product.x , product.y = W*0.18 , H*0.806 

    redText = display.newText( sceneGroup, "統一藥品驗孕系列產品  關心您", W*0.258, H*0.834 , bold , H*0.021 )
    redText:setFillColor( 226/255,68/255,61/255 )
    redText.anchorX = 0

    sceneGroup:insert( backBtn)

    msgBox = native.newTextBox( W*0.57, H*0.48, W*0.628, H*0.613 )
    msgBox.id = "msgBox"
    -- msgBox.placeholder = "輸入留言內容"
    msgBox.isEditable = true
    msgBox.size = H*0.0254
    msgBox.hasBackground = false
    msgBox:addEventListener( "userInput", textListener )
    _parent:insert(msgBox)
    -- addSaveBtn()
    for row in database:nrows([[SELECT * FROM Diary WHERE Date = ']]..dbDate..[[']]) do
        msgBox.text = row.Notes
    end

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
                native.setKeyboardFocus( nil )
                composer.showOverlay( "edit" )
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
    if e.phase == "ended" then
        native.setKeyboardFocus( nil )
        composer.showOverlay( "edit" )
    end
end

textListener = function( event )
    if ( event.phase == "began" ) then
     
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        native.setKeyboardFocus( nil )
    elseif ( event.phase == "editing" ) then
        -- msgText = event.text 
        noteContent = event.text
        if backBtn then
            backBtn:removeSelf( )
            backBtn = nil 
            backBtnImg.alpha = 0
        end

        if not saveBtn then
            addSaveBtn()
        end
    end
end

addSaveBtn = function (  )
    saveBtn = widget.newButton( {
        x = X*1.8 , 
        y = Y*0.14 , 
        shape = "rect" , 
        width = W*0.1 , 
        height = H*0.05 ,
        label = "儲存",
        fontSize = H*0.03 ,
        font = bold ,
        fillColor = { default={1,1,1,0}, over={0.7,0.7,0.7,0} },
        labelColor = { default={1,1,1,}, over={0.7,0.7,0.7} },
        onEvent = saveBtnEvent 
        } )

    sceneGroup:insert(saveBtn)
end
 
saveBtnEvent = function ( e )
    if e.phase == "ended" then
        database:exec([[UPDATE Diary SET Notes = ']]..noteContent..[[' WHERE date =']]..dbDate..[[';]])

        saveBtn:removeSelf( )
        saveBtn = nil
        native.setKeyboardFocus( nil )
        
        backBtn = widget.newButton({
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
        } )

        sceneGroup:insert( backBtn)

        backBtnImg.alpha = 1
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
