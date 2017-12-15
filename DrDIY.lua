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
local bg 
local banner 
local article = { "",""}
local whiteBg = {} 
local networkListener 
local request 

local title = { 
                "孕氣，運氣?"  ,
                "懷孕就結婚?"  ,
                "不可不知驗孕快狠準關\n鍵字"  ,
                "快又準！DIY驗孕知識\n全攻略"  ,
                "聰明快捷驗孕一試就\n準"  ,
         }

local imgs = {
                "1.jpg"  ,
                "2.jpg"  ,
                "3.jpg"  ,
                "4.jpg"  ,
                "5.jpg"  ,
}

local listener
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    bg = display.newRect( _parent, X, Y*1.07, W, H )
    bg:setFillColor( 145/255,215/255,215/255 )
    T.title("Dr. DIY" , _parent)

    -- display.newText( _parent, "DIY", X, Y, font , 50 )
    -- banner = display.newRect( sceneGroup, X, H*0.884, W, H*0.079 )
    -- banner:setFillColor( 0.5 )
    banner = display.newImageRect( sceneGroup, "ad.jpg", W, H*0.079 )
    banner.x , banner.y =  X, H*0.884 
    banner:addEventListener("tap" , listener)

    tableView = widget.newTableView(
    {
        left = W*0.025,
        top = H*0.12,
        height = H*0.715,
        width = W*0.95,
        hideBackground  = true , 
        onRowRender = onRowRender,
        onRowTouch  = onRowTouch,
        -- listener = scrollListener,
        noLines = true
      
    })
 
    -- -- Insert 40 rows
    for i = 1, #title do
     
        -- Insert a row into the tableView
        tableView:insertRow(
            {
                isCategory = false,
                rowHeight = H*0.15,
                rowColor = { default={1,1,1,0}, over={1,0.5,0,0} },
                lineColor = { 0.5, 0.5, 0.5 } , 
                -- hideBackground  = true , 

            }
        )
    end

    _parent:insert(tableView)

    request()
end

request = function (  )
    local headers = {}
      
    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Accept-Language"] = "en-US"
    
    local body = "org_secret=ADB82C39FBBCD7E9&app_secret=A7OD56W8FG5GW3L&sql_statement=select * from GD01_TALK_LIST_VIEW&app_name=Girl’s Diary&locale=cht"
     
    local params = {}
    params.headers = headers
    params.body = body
      
    network.request( "http://gm01.goodmobile.tw/WebService/getSQLPlist.php", "POST", networkListener, params )
end

networkListener = function( event )
 
    if ( event.isError ) then
        print( "Network error: ", event.response )
    else
        print ( "RESPONSE: " .. event.response )
    end
end


onRowRender = function( event )
 
    local row = event.row
 
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth
    
    whiteBg[row.index] = display.newRect( row, W*0.475, H*0.065 , W*0.95 , H*0.1425 )

    local rowTitle = display.newText( row, title[row.index] , W*0.3, H*0.0645 , bold , H*0.0254 )
    rowTitle:setFillColor( 254/255,118/255,118/255 )
    -- Align the label left and vertically centered
    rowTitle.anchorX = 0

    local images = display.newRoundedRect( row, W*0.15,  H*0.065, W*0.26, H*0.115 , H*0.013 )
    images.fill = { type="image", filename= imgs[row.index] }
    -- local images = display.newImageRect( row, imgs[row.index], W*0.22, H*0.115 )
    -- images.x , images.y = W*0.15,  H*0.065
    -- images.cornerRadius = 20
    -- rowTitle.x = 0
    -- rowTitle.y = 

    

    local arrow = display.newImageRect( row, "images/cell_arrow_blue@3x.png", W*0.0266, H*0.024 )
    arrow.x , arrow.y = W*0.9 , H*0.065
end

onRowTouch = function ( e )
    local row = e.row.index
    print( row )
    if e.phase == "press" then
        whiteBg[row]:setFillColor( 0.67 )
        print( 123 )
    elseif e.phase == "release" then
        whiteBg[row]:setFillColor( 1 )
        composer.setVariable( "rowIndex", e.row.index )
        composer.showOverlay( "newsDIY" )
    elseif e.phase == "tap" then
        composer.setVariable( "rowIndex", e.row.index )
        composer.showOverlay( "newsDIY" )
    end
end

listener = function (  )
    composer.setVariable( "preScene", "DrDIY" )
    composer.showOverlay( "webView" )
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
