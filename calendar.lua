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
local year
local month 
local day 
local textListener
local btn
local handleButtonEvent 
local yText = ""
local mText = ""
local dText = ""

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    
    
    year = native.newTextField( X*0.9, Y*0.3, W*0.7, H*0.1 )
    month = native.newTextField( X*0.9, Y*0.7, W*0.7, H*0.1 )
    day = native.newTextField( X*0.9, Y*1.1, W*0.7, H*0.1 )
    


    year.id = "year"
    year.placeholder = "year"
    year:addEventListener( "userInput", textListener )
    month.id = "month"
    month.placeholder = "month"
    month:addEventListener( "userInput", textListener )
    day.id = "day"
    day.placeholder = "day"
    day:addEventListener( "userInput", textListener )

    btn = widget.newButton({ 
        x = X*1,
        y = Y*1.5,
        id = "btn",
        label = "輸入",
        fontSize = 30 ,
        shape = "circle",
        radius = 30 ,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = handleButtonEvent 
        })

    Y=2017 
    M=11 
    d = 7
    y=Y%100;
    c=Y/100;
    m=M;
    w=(y+(y/4)+(c/4)-(2*c)+((26*(m+1))/10)+d-1);
    w=(w%7+7)%7;
    r=w;

    print( r )

    _parent:insert(year)
    _parent:insert(month)
    _parent:insert(day)
    _parent:insert(btn)

end


textListener = function( event )
    if ( event.phase == "began" ) then
     
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
    
    elseif ( event.phase == "editing" ) then
        if event.target.id == "year" then
            yText = event.text 
        elseif event.target.id == "month" then
            mText = event.text 
        elseif event.target.id == "day" then
            dText = event.text 
        end
    end     
end

handleButtonEvent = function ( e )
    if ( "ended" == e.phase ) then
        if e.target.id == "btn" then 
           print( yText..mText..dText )
        elseif e.target.id == "" then 
          
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

        -- composer.recycleOnSceneChange = true
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
