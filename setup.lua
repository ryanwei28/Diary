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
local pinkRect 
local whiteRect
local psdRect 
local setText 
local createSwitch 
local gr1 = display.newGroup( )
local gr2 = display.newGroup( )
local gr3 = display.newGroup( )
local gr4 = display.newGroup( )
local left 
local right 
local circle
-- local switchListener
-- local sw = 1
local sw1 = 1
local sw2 = 1
local sw3 = 1 
local sw4 = 1 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    print( prevScene )
    -- title = display.newText( _parent, "設定", X, Y*0.2, font , H*0.045 )
    T.bg(_parent)
    T.title("設定" , sceneGroup)

    pinkRect = display.newRoundedRect( _parent, X, Y*0.9, W*0.9, H*0.5, H*0.02 )
    pinkRect:setFillColor( 254/255,118/255,118/255 )

    whiteRect = display.newRoundedRect( _parent, X, Y*0.95, W*0.8, H*0.42, H*0.02 )
    whiteRect:setFillColor( 1 )

    psdRect = display.newRoundedRect( _parent , X, Y*0.3, W*0.9 , H*0.07 , H*0.02 )
    psdRect.strokeWidth = H*0.005
    psdRect:setStrokeColor( 254/255,118/255,118/255 )

    setText = display.newText( _parent, "個人化通知設定", X, Y*0.47, bold , H*0.027 )
    setText:setFillColor( 1 )

    text1 = display.newText( _parent, "密碼保護", X*0.2, Y*0.3, bold , H*0.03 )
    text1.anchorX = 0
    text1:setFillColor( 254/255,118/255,118/255 )
    text2 = display.newText( _parent, "通知功能", X*0.3, Y*0.65, bold , H*0.03 )
    text2:setFillColor( 0 )
    text2.anchorX = 0
    text3 = display.newText( _parent, "通知時間", X*0.3, Y*0.85, bold , H*0.03 )
    text3:setFillColor( 0 )
    text3.anchorX = 0
    text4 = display.newText( _parent, "計畫", X*0.3, Y*1.05, bold , H*0.03 )
    text4:setFillColor( 0 )
    text4.anchorX = 0
    text5 = display.newText( _parent, "性別", X*0.3, Y*1.25, bold , H*0.03 )
    text5:setFillColor( 0 )
    text5.anchorX = 0
    -- text6 = display.newText( _parent, "OFF", X*1.6, Y*0.3, bold , H*0.028 )
    -- text6:setFillColor( 0 )
    -- text6.anchorX = 0 
    -- text7 = display.newText( _parent, "ON", X*1.6, Y*0.7, bold ,  H*0.028 )
    -- text7:setFillColor( 0 )
    -- text7.anchorX = 0 
    -- text8 = display.newText( _parent, "想避孕", X*1.6, Y*1.1, bold ,  H*0.028 )
    -- text8:setFillColor( 0 )
    -- text8.anchorX = 0 
    -- text9 = display.newText( _parent, "女生", X*1.6, Y*1.3, bold ,  H*0.028 )
    -- text9:setFillColor( 0 )
    -- text9.anchorX = 0 

    addDashedLine(Y*0.75)
    addDashedLine(Y*0.95)
    addDashedLine(Y*1.15)

    local predictSetBtn = widget.newButton({ 
        x = X*1 ,
        y = Y*1.52,
        id = "predictSetBtn",
        label = "行經日數及未來經期預測設定      >",
        fontSize = H*0.03 ,
        font = bold ,
        shape = "roundedRect",
        width = W*0.9,
        height = H*0.08,
        cornerRadius = H*0.017,
        strokeWidth = H*0.005 ,
        strokeColor =  { default={254/255,118/255,118/255}, over={254/255,118/255,118/255} },
        labelColor = { default={254/255,118/255,118/255}, over={254/255,118/255,118/255} },
        fillColor = { default={1,1,1}, over={0.7,0.7,0.7,0.4} },
        onEvent = setBtnEvent 
    }) 

    _parent:insert(predictSetBtn)

    local tallSetBtn = widget.newButton({ 
        x = X*1 ,
        y = Y*1.72,
        id = "tallSetBtn",
        label = "身高設定                                    >",
        fontSize = H*0.03 ,
        font = bold , 
        shape = "roundedRect",
        width = W*0.9,
        height = H*0.08,
        cornerRadius = H*0.017,
        strokeWidth = H*0.005 ,
        strokeColor =  { default={254/255,118/255,118/255}, over={254/255,118/255,118/255} },
        labelColor = { default={254/255,118/255,118/255}, over={254/255,118/255,118/255} },
        fillColor = { default={1,1,1}, over={0.7,0.7,0.7,0.4} },
        onEvent = setBtnEvent 
    })

    _parent:insert(tallSetBtn)

    -- createSwitch()
    -- back = display.newCircle( _parent, X*0.2, Y*0.2, H*0.045 )
    -- back:addEventListener( "tap", listener )
    T.backBtn(_parent , "daily_calendar")
    -- checkSwitchBtn()
    -- readDb()

    createSwitch(X*1.5,text1.y,"ON","OFF","psdPropect" ,gr1 )
    createSwitch(X*1.4,text2.y,"ON","OFF","notification" , gr2 )
    createSwitch(X*1.4,text4.y,"想懷孕","想避孕","plan" , gr3 )
    createSwitch(X*1.4,text5.y,"女生","男生","sex" , gr4 )
end


createSwitch = function ( sX , sY ,t1 , t2 , id , gr )

    -- gr = display.newGroup( )
    gr.id = id 
    sceneGroup:insert(gr)
    -- rbg = display.newRect( X, Y, W, H )
    -- rbg:setFillColor( 1,0,0 )

    local left = display.newImageRect( gr, "images/radio_on@3x.png",  W*0.2, H*0.04 )
    left.x , left.y = sX - 25 , sY

    local leftText = display.newText( gr, t1, left.x-5, left.y, font ,H*0.03 )

    local right = display.newImageRect( gr,"images/radio_off@3x.png",  W*0.2, H*0.04 )
    right.x , right.y = sX + 25 , sY

    local rightText = display.newText( gr, t2, right.x+5, right.y, font ,H*0.03 )

    local circle = display.newImageRect( gr, "images/radio_btn@3x.png", H*0.05 , H*0.05 )
    circle.x , circle.y = sX , sY 

    local circleX = circle.x 
    local circleW = circle.width
    local leftW = left.width 


    readDb(circleX , circleW, leftW , gr)
    -- display.newLine( sX-(left.width - circle.width/2+ W*0.012), 0, sX-(left.width - circle.width/2+ W*0.012), H )
    -- display.newLine( sX, 0, sX, H )
    gr:addEventListener( 'tap', function ( e )
        if e.target.id == "psdPropect" then
            if sw1 == 0 then
                composer.setVariable( "prevScene", "setup" )
                composer.showOverlay("psdPropect")
                print( e.target.id..sw1 )
            else
                composer.setVariable( "prevScene", "setup" )
                composer.showOverlay("psdPropect")
                print( e.target.id..sw1 )
            end
        elseif e.target.id == "notification" then
            sw2 = 1 - sw2 
            if sw2 == 0 then
                database:exec([[UPDATE Setting SET Notification = "OFF" WHERE id = 1 ;]])
                print( e.target.id..sw2 )
                transition.to( e.target , {time = 200 , x = - (left.width - circle.width/2 + W*0.012)} )
                -- sw2 = 0 
            else
                database:exec([[UPDATE Setting SET Notification = "ON" WHERE id = 1 ;]])
                print( e.target.id..sw2 )
                transition.to( e.target , {time = 200 , x = 0} )
            end
        elseif e.target.id == "plan" then
            sw3 = 1 - sw3
            if sw3 == 0 then
                database:exec([[UPDATE Setting SET Plan = "想避孕" WHERE id = 1 ;]])
                print( e.target.id..sw3)
                transition.to( e.target , {time = 200 , x = - (left.width - circle.width/2 + W*0.012)} )
            else
                database:exec([[UPDATE Setting SET Plan = "想懷孕" WHERE id = 1 ;]])
                print( e.target.id..sw3 )
                transition.to( e.target , {time = 200 , x = 0} )
            end
        elseif e.target.id == "sex" then
            sw4 = 1 - sw4
            if sw4 == 0 then
                database:exec([[UPDATE Setting SET Sex = "男生" WHERE id = 1 ;]])
                print( e.target.id..sw4 )
                transition.to( e.target , {time = 200 , x = - (left.width - circle.width/2 + W*0.012)} )
            else
                database:exec([[UPDATE Setting SET Sex = "女生" WHERE id = 1 ;]])
                print( e.target.id..sw4 )
                transition.to( e.target , {time = 200 , x = 0} )
            end
        end
        -- sw = 1 - sw 
        -- if sw == 0 then
        --     transition.to( e.target , {time = 200 , x = - (left.width - circle.width/2 + W*0.012)} )
        --     -- return sw 
        --     if e.target.id == "psdPropect" then
        --         composer.setVariable( "prevScene", "setup" )
        --         composer.showOverlay("psdPropect")
        --         print( e.target.id..sw )
        --     elseif e.target.id == "notification" then
        --         database:exec([[UPDATE Setting SET Notification = "OFF" WHERE id = 1 ;]])
        --         print( e.target.id..sw )
        --         sw2 = 0
        --     elseif e.target.id == "plan" then
        --         database:exec([[UPDATE Setting SET Plan = "想避孕" WHERE id = 1 ;]])
        --         print( e.target.id..sw )
        --         sw3 = 0 
        --     elseif e.target.id == "sex" then
        --         database:exec([[UPDATE Setting SET Sex = "男生" WHERE id = 1 ;]])
        --         print( e.target.id..sw )
        --         sw4 = 0
        --     end
        -- elseif sw == 1 then 
        --     transition.to( e.target , {time = 200 , x = 0} )
        --     -- return sw 
        --     if e.target.id == "psdPropect" then
        --         composer.setVariable( "prevScene", "setup" )
        --         composer.showOverlay("psdPropect")
        --         print( e.target.id..sw )
        --     elseif e.target.id == "notification" then
        --         database:exec([[UPDATE Setting SET Notification = "ON" WHERE id = 1 ;]])
        --         print( e.target.id..sw )
        --         sw2 = 1
        --     elseif e.target.id == "plan" then
        --         database:exec([[UPDATE Setting SET Plan = "想懷孕" WHERE id = 1 ;]])
        --         print( e.target.id..sw )
        --         sw3 = 1
        --     elseif e.target.id == "sex" then
        --         database:exec([[UPDATE Setting SET Sex = "女生" WHERE id = 1 ;]])
        --         print( e.target.id..sw )
        --         sw4 = 1
        --     end
        -- end 

        -- print( sw2 )
        -- readDb(circleX , circleW, leftW , gr)
    end )

    -- bg2 = display.newRect( X, Y, W, H )
    -- bg2:setFillColor( 0.5 )
end

-- switchListener = function ( e )
--     sw = 1 - sw 
--     if sw == 0 then
--         transition.to( e.target , {time = 200 , x = -80} )
--         -- return sw 
--     elseif sw == 1 then 
--         transition.to( e.target , {time = 200 , x = 0} )
--         -- return sw 
--     end 

-- end


addDashedLine = function ( y )
    dashedLine = display.newImageRect( sceneGroup, "images/line_dashed@3x.png", W*0.74, H*0.001499 )
    dashedLine.x , dashedLine.y = X , y
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
        y = Y*0.3,
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
 
readDb = function ( circleX , circleW , leftW , gr )
    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
        -- text6.text = row.Protect 
        -- text7.text = row.Notification
        -- text8.text = row.Plan
        -- text9.text = row.Sex

        if row.Protect == "ON" then 
            gr1.x = 0
        --     text6.text = "ON"
        --     setNum1 = 0
            -- gr.x = circleX - (leftW - circleW/2 + W*0.012)

        else
            gr1.x = 0 - (leftW - circleW/2 + W*0.012)
            -- gr.x = circleX
        --     text6.text = "OFF"
        --     setNum1 = 1
        end

        if row.Notification == "ON" then 
            gr2.x = 0
            sw2 = 1
        --     text7.text = "ON"
        --     setNum2 = 0
        else
            gr2.x = 0 - (leftW - circleW/2 + W*0.012)
            sw2 = 0
        --     text7.text = "OFF"
        --     setNum2 = 1
        end

        if row.Plan == "想懷孕" then 
            gr3.x = 0 
            sw3 = 1
        --     text8.text = "想懷孕"
        --     setNum3 = 0
        else
            gr3.x = 0 - (leftW - circleW/2 + W*0.012)
            sw3 = 0
        --     text8.text = "想避孕"
        --     setNum3 = 1
        end

        if row.Sex == "女生" then 
            gr4.x = 0
            sw4 = 1
        --     text9.text = "男生"
        --     setNum4 = 0
        else
            gr4.x = 0 - (leftW - circleW/2 + W*0.012)
            sw4 = 0
        --     text9.text = "女生"
        --     setNum4 = 1
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
