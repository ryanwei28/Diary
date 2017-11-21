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
local handleTabBarEvent 
local overlayOptions = {
            isModal = true,
            effect = "fade",
            time = 400,
            params = {
                sampleVar = "my sample variable"
            }
        }
local tabFontSize = H*0.03
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
   

    -- Configure the tab buttons to appear within the bar
    local tabButtons = {
        {
            label = "日曆",
            id = "daily_calendar",
            selected = true,
            size = tabFontSize,
            onPress = handleTabBarEvent
        },
        {
            label = "月曆",
            id = "monthly_calendar",
            size = tabFontSize,
            onPress = handleTabBarEvent
        },
        {
            label = "圖表",
            id = "chart",
            size = tabFontSize,
            onPress = handleTabBarEvent
        },
         {
            label = "hotNews",
            id = "hotNews",
            size = tabFontSize,
            onPress = handleTabBarEvent
        },
         {
            label = "Dr.DIY",
            id = "DrDIY",
            size = tabFontSize,
            onPress = handleTabBarEvent
        },
    }
     
    -- Create the widget
    local tabBar = widget.newTabBar(
        {
            top = H - H*0.06,
            width = display.contentWidth,
            height =  H*0.06 , 
            buttons = tabButtons
        }
)
       
end

handleTabBarEvent = function( event )
    composer.hideOverlay()
    if event.target.id == "daily_calendar" then
        composer.showOverlay( "daily_calendar", overlayOptions )
        print(1 )  -- Reference to button's 'id' parameter
    elseif event.target.id == "monthly_calendar" then
        composer.showOverlay( "monthly_calendar", overlayOptions )
        print(2 )
    elseif event.target.id == "chart" then
        composer.showOverlay( "chart", overlayOptions )
        print(3 )
    elseif event.target.id == "hotNews" then
        -- composer.hideOverlay( "DrDIY")
        composer.showOverlay( "hotNews", overlayOptions )

        print(4 )
    elseif event.target.id == "DrDIY" then
        composer.showOverlay( "DrDIY", overlayOptions )
        print(5 )
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
        -- composer.showOverlay( "daily_calendar", overlayOptions )
        timer.performWithDelay( 1, function (  )
        composer.showOverlay( "daily_calendar", overlayOptions )
    end  )
    end
end
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        
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
