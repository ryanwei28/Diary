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
local maskBg
local cGroup = display.newGroup( )
local midGroup = display.newGroup( )
local cNum = 0
local cTable = {}
local blackTitle 
local pinkArrow
local pinkArrow2 
local helpBtnEvent 
-- local sGroup = display.newGroup( )
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    print( prevScene )
    -- title = display.newText( _parent, "設定", X, Y*0.2, font , H*0.045 )
    -- T.bg(_parent)
    createCircle(X*1.47,Y*0.315)
    createCircle(X*1.675,Y*0.633)
    createCircle(X*1.671,Y*0.9625)
    createCircle(X*1.675,Y*1.128)

    createSwitch(W*0.08,X*1.77,Y*0.315,"ON","OFF","psdPropect" ,gr1 , W*0.23 )
    createSwitch(W*0.08,X*1.7,Y*0.633,"ON","OFF","notification" , gr2 , W*0.23)
    createSwitch(W*0.1,X*1.69,Y*0.9625,"想懷孕","想避孕","plan" , gr3 , W*0.262)
    createSwitch(W*0.08,X*1.7,Y*1.126,"女生","男生","sex" , gr4 , W*0.23)

    maskBg = display.newImageRect( _parent, "images/radio_mask_2@3x.png", W, H )
    maskBg.x , maskBg.y = X , Y*1
    T.title("設定" , sceneGroup)
    T.backBtn(sceneGroup , "daily_calendar")


    blackTitle = display.newRect( _parent, X, Y*0.07, W, H*0.07 )
    blackTitle.anchorY = 1
    blackTitle:setFillColor( 0 )

    -- pinkRect = display.newRoundedRect( _parent, X, Y*0.9, W*0.9, H*0.5, H*0.02 )
    -- pinkRect:setFillColor( 254/255,118/255,118/255 )

    -- whiteRect = display.newRoundedRect( _parent, X, Y*0.95, W*0.8, H*0.42, H*0.02 )
    -- whiteRect:setFillColor( 1 )

    -- psdRect = display.newRoundedRect( _parent , X, Y*0.3, W*0.9 , H*0.07 , H*0.02 )
    -- psdRect.strokeWidth = H*0.005
    -- psdRect:setStrokeColor( 254/255,118/255,118/255 )

    setText = display.newText( _parent, "個人化通知設定", X, Y*0.482, bold , H*0.027 )
    setText:setFillColor( 1 )

    text1 = display.newText( _parent, "密碼保護", X*0.2, Y*0.315, bold , H*0.03 )
    text1.anchorX = 0
    text1:setFillColor( 254/255,118/255,118/255 )
    text2 = display.newText( _parent, "通知功能", X*0.3, Y*0.633, bold , H*0.03 )
    text2:setFillColor( 0 )
    text2.anchorX = 0
    text3 = display.newText( _parent, "通知時間", X*0.3, Y*0.8, bold , H*0.03 )
    text3:setFillColor( 0 )
    text3.anchorX = 0
    text4 = display.newText( _parent, "計畫", X*0.3, Y*0.9625, bold , H*0.03 )
    text4:setFillColor( 0 )
    text4.anchorX = 0
    text5 = display.newText( _parent, "性別", X*0.3, Y*1.126, bold , H*0.03 )
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

    addDashedLine(Y*0.71)
    addDashedLine(Y*0.88)
    addDashedLine(Y*1.045)

    local predictSetBtn = widget.newButton({ 
        x = X*1 ,
        y = H*0.688,
        id = "predictSetBtn",
        label = "行經日數及未來經期預測設定",
        labelAlign  = "left" ,
        labelXOffset = W*0.0213 , 
        fontSize = H*0.0254 ,
        font = bold ,
        shape = "roundedRect",
        width = W*0.92,
        height = H*0.08,
        cornerRadius = H*0.017,
        strokeWidth = H*0.003 ,
        strokeColor =  { default={254/255,118/255,118/255}, over={254/255,118/255,118/255} },
        labelColor = { default={254/255,118/255,118/255}, over={254/255,118/255,118/255} },
        fillColor = { default={1,1,1}, over={0.3,0.3,0.3,0.4} },
        onEvent = setBtnEvent 
    }) 

    _parent:insert(predictSetBtn)

    local tallSetBtn = widget.newButton({ 
        x = X*1 ,
        y = H*0.781,
        id = "tallSetBtn",
        label = "身高設定",
        labelAlign  = "left" ,
        labelXOffset = W*0.0213 , 
        fontSize = H*0.0254 ,
        font = bold , 
        shape = "roundedRect",
        width = W*0.92,
        height = H*0.08,
        cornerRadius = H*0.017,
        strokeWidth = H*0.003 ,
        strokeColor =  { default={254/255,118/255,118/255}, over={254/255,118/255,118/255} },
        labelColor = { default={254/255,118/255,118/255}, over={254/255,118/255,118/255} },
        fillColor = { default={1,1,1}, over={0.3,0.3,0.3,0.4} },
        onEvent = setBtnEvent 
    })

    _parent:insert(tallSetBtn)


    local helpBtn = widget.newButton({ 
        left = W*0.84,
        top = H*0.226,
        id = "helpBtn",
        -- label = "編輯",
        -- fontSize = H*0.028 ,
        -- shape = "circle",
        -- radius = H*0.028 ,
        -- fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        width = W*0.0586, 
        height = H*0.0329,
        defaultFile = "images/btn_help@3x.png" , 
        overFile = "images/btn_help_press@3x.png" ,
        onEvent = helpBtnEvent 
    })

    _parent:insert(helpBtn)

   pinkArrow = display.newImageRect( sceneGroup, "images/cell_arrow_pink@3x.png", W*0.0266, H*0.024 )
   pinkArrow.x , pinkArrow.y = W*0.893 , H*0.688

   pinkArrow2 = display.newImageRect( sceneGroup, "images/cell_arrow_pink@3x.png", W*0.0266, H*0.024 )
   pinkArrow2.x , pinkArrow2.y = W*0.893 , H*0.781
    
end

helpBtnEvent = function ( e )
    if e.phase == "ended" then 
        composer.showOverlay( "help" )
    end 
end

createCircle = function ( cX , cY  )
    cNum = cNum + 1
    cTable[cNum] = display.newImageRect( sceneGroup, "images/radio_btn@3x.png", H*0.057 , H*0.057 )
    cTable[cNum].x , cTable[cNum].y = cX , cY 
end

createSwitch = function ( sPadding , sX , sY ,t1 , t2 , id , gr , sWidth )

    -- gr = display.newGroup( )
    gr.id = id 
    -- sceneGroup:insert(gr)
    -- rbg = display.newRect( X, Y, W, H )
    -- rbg:setFillColor( 1,0,0 )

    local left = display.newImageRect( gr, "images/radio_on@3x.png",  sWidth, H*0.04797 )
    left.x , left.y = sX - sPadding , sY

    local leftTextShadow = display.newText( gr, t1, left.x-sPadding/3+1 , left.y +1 , bold ,H*0.024 )
    leftTextShadow:setFillColor( 0.5 )
    local leftText = display.newText( gr, t1, left.x-sPadding/3, left.y, bold ,H*0.024 )
    

    local right = display.newImageRect( gr,"images/radio_off@3x.png",  sWidth, H*0.04797 )
    right.x , right.y = sX + sPadding , sY

    local rightTextShadow = display.newText( gr, t2, right.x+sPadding/3+1 , right.y+1 , bold ,H*0.024 )
    rightTextShadow:setFillColor( 0.5 )
    local rightText = display.newText( gr, t2, right.x+sPadding/3, right.y, bold ,H*0.024 )
   
    -- local circle = display.newImageRect( gr, "images/radio_btn@3x.png", H*0.057 , H*0.057 )
    -- circle.x , circle.y = sX , sY 

    -- gr:insert( cGroup )
    -- local circleX = circle.x 
    -- local circleW = circle.width
    local leftW = left.width 

    readDb( leftW , gr)
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
                transition.to( e.target , {time = 200 , x =- W*0.157} )
                transition.to( cTable[2] , {time = 200 , x = X*1.4} )

            else
                database:exec([[UPDATE Setting SET Notification = "ON" WHERE id = 1 ;]])
                print( e.target.id..sw2 )
                transition.to( e.target , {time = 200 , x = 0} )
                transition.to( cTable[2] , {time = 200 , x = X*1.675} )
            end
        elseif e.target.id == "plan" then
            sw3 = 1 - sw3
            if sw3 == 0 then
                database:exec([[UPDATE Setting SET Plan = "想避孕" WHERE id = 1 ;]])
                print( e.target.id..sw3)
                transition.to( e.target , {time = 200 , x = - W*0.191} )
                transition.to( cTable[3] , {time = 200 , x = X*1.33} )
            else
                database:exec([[UPDATE Setting SET Plan = "想懷孕" WHERE id = 1 ;]])
                print( e.target.id..sw3 )
                transition.to( e.target , {time = 200 , x = 0} )
                transition.to( cTable[3] , {time = 200 , x = X*1.671} )
            end
        elseif e.target.id == "sex" then
            sw4 = 1 - sw4
            if sw4 == 0 then
                database:exec([[UPDATE Setting SET Sex = "男生" WHERE id = 1 ;]])
                print( e.target.id..sw4 )
                transition.to( e.target , {time = 200 , x = - W*0.157 } )
                transition.to( cTable[4] , {time = 200 , x = X*1.4} )
            else
                database:exec([[UPDATE Setting SET Sex = "女生" WHERE id = 1 ;]])
                print( e.target.id..sw4 )
                transition.to( e.target , {time = 200 , x = 0} )
                transition.to( cTable[4] , {time = 200 , x = X*1.675} )
                
            end
        end

    end )

    -- bg2 = display.newRect( X, Y, W, H )
    -- bg2:setFillColor( 0.5 )
end


readDb = function ( circleX , circleW , leftW , gr )
    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
        -- text6.text = row.Protect 
        -- text7.text = row.Notification
        -- text8.text = row.Plan
        -- text9.text = row.Sex

        if row.Protect == "ON" then 
            gr1.x = 0
            cTable[1].x = X*1.73
        --     text6.text = "ON"
        --     setNum1 = 0
            -- gr.x = circleX - (leftW - circleW/2 + W*0.012)

        else
            gr1.x = - W*0.157
            cTable[2].x = X*1.47
            -- gr.x = circleX
        --     text6.text = "OFF"
        --     setNum1 = 1
        end

        if row.Notification == "ON" then 
            gr2.x = 0
            sw2 = 1
        --     text7.text = "ON"
        --     setNum2 = 0
            cTable[2].x = X*1.675
        else
            gr2.x = - W*0.157
            sw2 = 0
        --     text7.text = "OFF"
        --     setNum2 = 1
            cTable[2].x = X*1.4
        end

        if row.Plan == "想懷孕" then 
            gr3.x = 0 
            sw3 = 1
            cTable[3].x = X*1.671
        --     text8.text = "想懷孕"
        --     setNum3 = 0
        else
            gr3.x = - W*0.191
            sw3 = 0
            cTable[3].x = X*1.33
        --     text8.text = "想避孕"
        --     setNum3 = 1
        end

        if row.Sex == "女生" then 
            gr4.x = 0
            sw4 = 1
        --     text9.text = "男生"
        --     setNum4 = 0
            cTable[4].x = X*1.675
        else
            gr4.x = - W*0.157
            sw4 = 0
        --     text9.text = "女生"
        --     setNum4 = 1
            cTable[4].x = X*1.4
        end
    end
end
    
 
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
 
      


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
    sceneGroup = self.view
    sceneGroup:insert( gr1 )
    sceneGroup:insert( gr2 )
    sceneGroup:insert( gr3 )
    sceneGroup:insert( gr4 )
    sceneGroup:insert( midGroup )
    sceneGroup:insert( cGroup )
    init(midGroup)
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
