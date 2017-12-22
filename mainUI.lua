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
local onSystemEvent2 
local overlayOptions = {
            isModal = true,
            effect = "fade",
            time = 400,
            params = {
                sampleVar = "my sample variable"
            }
        }
local tabFontSize = H*0.03
local bg 
-- local tabBar

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    T.bg(_parent)
    -- Configure the tab buttons to appear within the bar
    local tabButtons = {
        {
            label = "",
            id = "daily_calendar",
            defaultFile = "images/tab_day@3x.png" , 
            overFile = "images/tab_day_press@3x.png" , 
            width = W*0.2, 
            height = H*0.078,
            selected = true,
            size = tabFontSize,
            onPress = handleTabBarEvent
        },
        {
            label = "",
            id = "monthly_calendar",
            defaultFile = "images/tab_month@3x.png" , 
            overFile = "images/tab_month_press@3x.png" , 
            width = W*0.2, 
            height = H*0.078,
            size = tabFontSize,
            onPress = handleTabBarEvent
        },
        {
            label = "",
            id = "chart",
            defaultFile = "images/tab_chart@3x.png" , 
            overFile = "images/tab_chart_press@3x.png" , 
            width = W*0.2, 
            height = H*0.078,
            size = tabFontSize,
            onPress = handleTabBarEvent
        },
         {
            label = "",
            id = "hotNews",
            defaultFile = "images/tab_news@3x.png" , 
            overFile = "images/tab_news_press@3x.png" , 
            width = W*0.2, 
            height = H*0.078,
            size = tabFontSize,
            onPress = handleTabBarEvent
        },
         {
            label = "",
            id = "DrDIY",
            defaultFile = "images/tab_diy@3x.png" , 
            overFile = "images/tab_diy_press@3x.png" , 
            width = W*0.2, 
            height = H*0.078,
            size = tabFontSize,
            onPress = handleTabBarEvent ,
            -- labelColor = { default={ 0.95, 1, 1 }, over={ 0.12, 0, 0, 0.5 } } ,
             fillColor = { default={ 0.852, 0.2, 0.5, 0.7 }, over={ 0.14, 0.2, 0.5, 1 } }

        },
    }
     
    -- Create the widget
    tabBar = widget.newTabBar(
        {
            top = H-H*0.078,
            left = 0 , 
            width = W+1,
            height =  H*0.078 , 
            buttons = tabButtons ,
            labelColor = { default={ 0.95, 1, 1 }, over={ 0.12, 0, 0, 0.5 } } ,
            fillColor = { default={ 0.852, 0.2, 0.5, 0.7 }, over={ 0.14, 0.2, 0.5, 1 } }
        }
    )

    -- sceneGroup:insert(tabBar)
       

    -- T.tabBar()
    Runtime:addEventListener( "system", onSystemEvent2 )

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

onSystemEvent2 = function( event )
    if ( event.type == "applicationResume" ) then
        for row in database:nrows([[SELECT * FROM Setting WHERE id = 1]]) do
            if row.Password ~= "" then 
                composer.gotoScene( "enterPassword" )

                if launchArgs and launchArgs.notification then
            
                    native.showAlert( "Girl's Diary", launchArgs.notification.alert, { "OK" } )
                    
                    -- Need to call the notification listener since it won't get called if the
                    -- the app was already closed.
                    notificationListener( launchArgs.notification )
                end
            end
        end 
        -- T.alert("noDay")
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
        if not tabBar then 
            T.tabBar()
        end 
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
