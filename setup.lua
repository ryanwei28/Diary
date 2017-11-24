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
local onSwitchPress
local text1 
local text2
local text3
local text4 
local text5 
local text6
local text7
local text8
local text9
local predictSetBtn
local tallSetBtn
local setBtnEvent 
local createSwitch
local prevScene = composer.getVariable( "prevScene" )
local checkSwitchBtn 
local setNum1 , setNum2 , setNum3 , setNum4 = 1,1,1,1
local readDb

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    print( prevScene )
    -- title = display.newText( _parent, "設定", X, Y*0.2, font , H*0.045 )
    T.title("設定" , sceneGroup)

    text1 = display.newText( _parent, "密碼保護", X*0.2, Y*0.4, font , H*0.043 )
    text1.anchorX = 0
    text2 = display.newText( _parent, "通知功能", X*0.2, Y*0.7, font , H*0.043 )
    text2.anchorX = 0
    text3 = display.newText( _parent, "通知時間", X*0.2, Y*0.9, font , H*0.043 )
    text3.anchorX = 0
    text4 = display.newText( _parent, "計畫", X*0.2, Y*1.1, font , H*0.043 )
    text4.anchorX = 0
    text5 = display.newText( _parent, "性別", X*0.2, Y*1.3, font , H*0.043 )
    text5.anchorX = 0
    text6 = display.newText( _parent, "OFF", X*1.6, Y*0.4, font , H*0.028 )
    text6.anchorX = 0 
    text7 = display.newText( _parent, "ON", X*1.6, Y*0.7, font ,  H*0.028 )
    text7.anchorX = 0 
    text8 = display.newText( _parent, "想避孕", X*1.6, Y*1.1, font ,  H*0.028 )
    text8.anchorX = 0 
    text9 = display.newText( _parent, "女生", X*1.6, Y*1.3, font ,  H*0.028 )
    text9.anchorX = 0 

    local predictSetBtn = widget.newButton({ 
        x = X*1 ,
        y = Y*1.55,
        id = "predictSetBtn",
        label = "行經日數及未來經期預測設定          ＞",
        fontSize = H*0.026 ,
        shape = "roundedRect",
        width = W*0.9,
        height = H*0.08,
        cornerRadius = H*0.017,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = setBtnEvent 
    }) 

    _parent:insert(predictSetBtn)

    local tallSetBtn = widget.newButton({ 
        x = X*1 ,
        y = Y*1.75,
        id = "tallSetBtn",
        label = "身高設定                                             ＞",
        fontSize = H*0.026 ,
        shape = "roundedRect",
        width = W*0.9,
        height = H*0.08,
        cornerRadius = H*0.017,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = setBtnEvent 
    })

    _parent:insert(tallSetBtn)

    -- createSwitch()
    back = display.newCircle( _parent, X*0.2, Y*0.2, H*0.045 )
    back:addEventListener( "tap", listener )

    checkSwitchBtn()
    readDb()
end

listener = function ( e )
    composer.showOverlay( "daily_calendar" )
end

setBtnEvent = function ( e )
    if ( "ended" == e.phase ) then
        if e.target.id == "predictSetBtn" then 
            composer.showOverlay( "predictSet" )
        elseif e.target.id == "tallSetBtn" then 
            composer.showOverlay( "tallSet" )
        end
    end
end


checkSwitchBtn = function (  )
    checkBoxBtnEvent = function ( e )
        if ( "ended" == e.phase ) then
            if e.target.id == "psdProtectSwitch" then 
                setNum1 = 1 - setNum1
                if setNum1 == 0 then 
                    -- text6.text = "ON"
                    -- database:exec([[UPDATE Setting SET Protect = "ON" WHERE id = 1 ;]])
                    composer.setVariable( "prevScene", "setup" )
                    composer.showOverlay("psdPropect")
                else
                    -- text6.text = "OFF"
                    -- database:exec([[UPDATE Setting SET Protect = "OFF" WHERE id = 1 ;]])
                    composer.setVariable( "prevScene", "setup" )
                    composer.showOverlay("psdPropect")
                end
            elseif e.target.id == "notificationSwitch" then 
                setNum2 = 1 - setNum2
                if setNum2 == 0 then 
                    text7.text = "ON"
                    database:exec([[UPDATE Setting SET Notification = "ON" WHERE id = 1 ;]])
                else
                    text7.text = "OFF"
                    database:exec([[UPDATE Setting SET Notification = "OFF" WHERE id = 1 ;]])
                end
            elseif e.target.id == "planSwitch" then 
                setNum3 = 1 - setNum3
                if setNum3 == 0 then 
                    text8.text = "想懷孕"
                    database:exec([[UPDATE Setting SET Plan = "想懷孕" WHERE id = 1 ;]])
                else
                    text8.text = "想避孕"
                    database:exec([[UPDATE Setting SET Plan = "想避孕" WHERE id = 1 ;]])
                end
            elseif e.target.id == "sexSwitch" then 
                setNum4 = 1 - setNum4
                if setNum4 == 0 then 
                    text9.text = "男生"
                    database:exec([[UPDATE Setting SET Sex = "男生" WHERE id = 1 ;]])
                else
                    text9.text = "女生"
                    database:exec([[UPDATE Setting SET Sex = "女生" WHERE id = 1 ;]])
                end
            end
        end
    end

    local psdProtectSwitch = widget.newButton({ 
        x = X*1.3,
        y = Y*0.4,
        id = "psdProtectSwitch",
        label = "",
        fontSize = 30 ,
        shape = "rect",
        width = W*0.1 ,
        height = H*0.05 ,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = checkBoxBtnEvent 
    })

    local notificationSwitch = widget.newButton({ 
        x = X*1.3,
        y = Y*0.7,
        id = "notificationSwitch",
        label = "",
        fontSize = 30 ,
        shape = "rect",
        width = W*0.1 ,
        height = H*0.05 ,
        radius = 30 ,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = checkBoxBtnEvent 
    })

    local planSwitch = widget.newButton({ 
        x = X*1.3,
        y = Y*1.1,
        id = "planSwitch",
        label = "",
        fontSize = 30 ,
        shape = "rect",
        width = W*0.1 ,
        height = H*0.05 ,
        radius = 30 ,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = checkBoxBtnEvent 
    })

    local sexSwitch = widget.newButton({ 
        x = X*1.3,
        y = Y*1.3,
        id = "sexSwitch",
        label = "",
        fontSize = 30 ,
        shape = "rect",
        width = W*0.1 ,
        height = H*0.05 ,
        radius = 30 ,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = checkBoxBtnEvent 
    })
    

    sceneGroup:insert(psdProtectSwitch)
    sceneGroup:insert(notificationSwitch)
    sceneGroup:insert(planSwitch)
    sceneGroup:insert(sexSwitch)
end
 
readDb = function (  )
    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
        text6.text = row.Protect 
        text7.text = row.Notification
        text8.text = row.Plan
        text9.text = row.Sex

        if row.Protect == "ON" then 
            text6.text = "ON"
            setNum1 = 0
        else
            text6.text = "OFF"
            setNum1 = 1
        end

        if row.Notification == "ON" then 
            text7.text = "ON"
            setNum2 = 0
        else
            text7.text = "OFF"
            setNum2 = 1
        end

        if row.Plan == "想懷孕" then 
            text8.text = "想懷孕"
            setNum3 = 0
        else
            text8.text = "想避孕"
            setNum3 = 1
        end

        if row.Sex == "男生" then 
            text9.text = "男生"
            setNum4 = 0
        else
            text9.text = "女生"
            setNum4 = 1
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
