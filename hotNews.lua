-----------------------------------------------------------------------------------------
--
-- leaveMessage.lua
--
-----------------------------------------------------------------------------------------

local sqlite3 = require "sqlite3"
local scene = composer.newScene()
local date = os.date( "*t" ) 
local json = require("json")
local init 
local sceneGroup
local month
local banner
local listener 
local networkListener 
local img1 
local img2 
local readFile 
local i = 0  
local urlTable = {}
local urlNum = 0 
local img1Listener 
local img2Listener
local contents 
local imgs = {
   "1.jpg"  ,
   -- "2.jpg"  ,
   -- "3.jpg"  ,
   -- "4.jpg"  ,
   -- "5.jpg"  ,
}


-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    bg = display.newRect( _parent, X, Y*1.07, W, H )
    bg:setFillColor( 145/255,215/255,215/255 )
    T.title("Hot News" , sceneGroup)

    -- T.creatAdWall( X , H*0.1 , imgs , sceneGroup , true)

    -- img2.strokeWidth = 2
    -- img2:setStrokeColor(0.8)
    -- notificationSet.startNotify("2017/11/15" ,notificationSet.alertContent['Boy']["Bi"].pre1 )
    -- notificationSet.startNotify("2017/11/18" ,notificationSet.alertContent['Girl']["Bi"].pre1 )
    -- notificationSet.startNotify("2017/12/11" ,notificationSet.alertContent['Boy']["Huai"].dg6 )
    -- notificationSet.startNotify("2017/12/13" ,notificationSet.alertContent[sexNoti][planNoti].pre1 ,"pre1")
    -- notificationSet.startNotify("2017/12/13" ,notificationSet.alertContent[sexNoti][planNoti].holidaySafe ,"holidaySafe")

    -- notificationSet.closeNotify()
    


    banner = display.newImageRect( sceneGroup, "banner.jpg", system.DocumentsDirectory ,  W, H*0.079 )
   
    if banner then 
        banner.x , banner.y =  X, H*0.884 
        banner:addEventListener("tap" , listener)
    end 

    -- img1 = display.newRect( _parent, X, Y*0.6, W*0.9, H*0.338 )
    img1 = display.newImageRect( sceneGroup, "hotnews1.jpg",  system.DocumentsDirectory  , W*0.9 ,  H*0.338  )
    
    if img1 then 
        img1.x , img1.y =  X, Y*0.58
    end
        -- img1.strokeWidth = 2
        -- img1:setStrokeColor(0.8)
    -- img2 = display.newRect( _parent, X, Y*1.33, W*0.9, H*0.338 )
    img2 = display.newImageRect( sceneGroup, "hotnews2.jpg",  system.DocumentsDirectory  , W*0.9 ,  H*0.338  )

    if img2 then 
        img2.x , img2.y =  X, Y*1.31       
    end 
   
   readFile()

end

listener = function ( e )
    composer.setVariable( "preScene", "hotNews" )
    composer.showOverlay( "webView" )
end

readFile = function (  )
    -- Path for the file to read
    local path = system.pathForFile( "url.json", system.DocumentsDirectory )
     
    -- Open the file handle
    local file, errorString = io.open( path, "r" )
     
    if not file then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
    else

        if img1 then 
            img1:addEventListener( "tap", img1Listener )
        end 

        if img2 then 
            img2:addEventListener( "tap", img2Listener )
        end
        -- Close the file handle
        io.close( file )
    end
     
    file = nil
end
      
img1Listener = function (  )

    local filename = system.pathForFile( "url.json", system.DocumentsDirectory )
    local decoded, pos, msg = json.decodeFile( filename )
     
    if not decoded then
        print( "Decode failed at "..tostring(pos)..": "..tostring(msg) )
    else
        print( decoded.url1 )
    end
    
    system.openURL( decoded.url1 )
end

img2Listener = function (  )
    local filename = system.pathForFile( "url.json", system.DocumentsDirectory )
    local decoded, pos, msg = json.decodeFile( filename )
     
    if not decoded then
        print( "Decode failed at "..tostring(pos)..": "..tostring(msg) )
    else
        print( decoded.url2 )
    end

    system.openURL( decoded.url2 )
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
