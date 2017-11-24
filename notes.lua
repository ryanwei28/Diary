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
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    -- title = display.newText( _parent, "紀錄", X, Y*0.2, font , 50 )
    T.title("紀錄" , sceneGroup)

    back = display.newCircle( _parent, X*0.2, Y*0.2, 50 )
    back:addEventListener( "tap", listener )

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
    native.setKeyboardFocus( nil )
    composer.showOverlay( "edit" )
end

textListener = function( event )
    if ( event.phase == "began" ) then
     
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        native.setKeyboardFocus( nil )
    elseif ( event.phase == "editing" ) then
        -- msgText = event.text 
        noteContent = event.text
        if back then
            back:removeSelf( )
            back = nil 
        end

        if not saveBtn then
            addSaveBtn()
        end
    end
end

addSaveBtn = function (  )
    saveBtn = widget.newButton( {
        x = X*1.8 , 
        y = Y*0.2 , 
        shape = "rect" , 
        width = W*0.1 , 
        height = H*0.05 ,
        label = "儲存",
        fontSize = 30 ,
        fillColor = { default={0.7,0.52,0.75,0.5}, over={0.2,0.78,0.75,0.4} },
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
        back = display.newCircle( sceneGroup, X*0.2, Y*0.2, 50 )
        back:addEventListener( "tap", listener )
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
