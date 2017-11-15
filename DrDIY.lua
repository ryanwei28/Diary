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
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    display.newText( _parent, "DIY", X, Y, font , 50 )

    tableView = widget.newTableView(
    {
        left = 0,
        top = 200,
        height = H*0.7,
        width = W,
        onRowRender = onRowRender,
        onRowTouch = onRowTouch,
        listener = scrollListener,
        scrollBarOptions = {
            sheet = scrollBarSheet,
            topFrame = 1,
            middleFrame = 2,
            bottomFrame = 3
            }
    })
 
    -- Insert 40 rows
    for i = 1, 10 do
     
        -- Insert a row into the tableView
        tableView:insertRow(
            {
                isCategory = false,
                rowHeight = 100,
                rowColor = { default={1,1,1}, over={1,0.5,0,0.2} },
                lineColor = { 0.5, 0.5, 0.5 }
            }
        )
    end

    _parent:insert(tableView)
end


onRowRender = function( event )
 
    local row = event.row
 
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth
 
    local rowTitle = display.newText( row, "Row " .. row.index, 0, 0, nil, 30 )
    rowTitle:setFillColor( 0 )
 
    -- Align the label left and vertically centered
    rowTitle.anchorX = 0
    rowTitle.x = 0
    rowTitle.y = rowHeight * 0.5
end

onRowTouch = function ( e )
    local row = e.row.index
    print( row )
    composer.showOverlay( "newsDIY" )
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
