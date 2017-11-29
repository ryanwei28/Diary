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
        label = "<",
        onEvent = listener,
        left = X*0.02 ,
        top = Y*0.07, 
        shape = "rect",
        width = W*0.1,
        height = H*0.07,
        fontSize = H*0.05 ,
        font = bold ,
        fillColor = { default={1,0,0,0}, over={1,0.1,0.7,0} },
        labelColor = { default={ 1, 1, 1 }, over={ 0.7, 0.7, 0.7 } }
        } )

    sceneGroup:insert( backBtn)

    msgBox = native.newTextBox( X*1, Y*1.1, W*0.9, H*0.6 )
    msgBox.id = "msgBox"
    -- msgBox.placeholder = "輸入留言內容"
    msgBox.isEditable = true
    msgBox.size = 50
    msgBox:addEventListener( "userInput", textListener )
    _parent:insert(msgBox)
    -- addSaveBtn()
    for row in database:nrows([[SELECT * FROM Diary WHERE Date = ']]..dbDate..[[']]) do
        msgBox.text = row.Notes
    end
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
            label = "<",
            onEvent = listener,
            left = X*0.02 ,
            top = Y*0.07, 
            shape = "rect",
            width = W*0.1,
            height = H*0.07,
            fontSize = H*0.05 ,
            font = bold ,
            fillColor = { default={1,0,0,0}, over={1,0.1,0.7,0} },
            labelColor = { default={ 1, 1, 1 }, over={ 0.7, 0.7, 0.7 } }
        } )

        sceneGroup:insert( backBtn)
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
