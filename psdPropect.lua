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
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    title = display.newText( _parent, "密碼保護", X, Y*0.2, font , 50 )

    back = display.newCircle( _parent, X*0.2, Y*0.2, 50 )
    back:addEventListener( "tap", listener )
    createBtn()
    -- psdSwitchBtn:setLabel( "New Label" )
    readDb()
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
                        alertText = display.newText( sceneGroup, "請先設置密碼", X, Y*0.85, font , 30 )
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
        fontSize = 40 ,
        shape = "roundedRect",
        width = W*0.7,
        height = H*0.1,
        cornerRadius = 30,
        fillColor = { default={0.12,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = buttonEvent 
    })

    changePsdBtn = widget.newButton({ 
        x = X*1,
        y = Y*0.7,
        id = "changePsdBtn",
        label = "變更密碼保護",
        fontSize = 40 ,
        shape = "roundedRect",
        width = W*0.7,
        height = H*0.1,
        cornerRadius = 30,
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
