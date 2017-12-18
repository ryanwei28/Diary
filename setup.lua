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
local cGroup = display.newGroup( )
local midGroup = display.newGroup( )
local maskGroup = display.newGroup()
local topGroup = display.newGroup()
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

local cNum = 0
local cTable = {}
local blackTitle 
local pinkArrow
local pinkArrow2 
local helpBtnEvent 
local onKeyEvent

local pkwBg
local pkwTitle
local talltextListener 
local tallsetBtnEvent 
local fieldBg 
local setGroup
local cmText 
local pinkkBg
local notifyTimeBtn 
local notifyTimeBtnListener 
local notiTimeText 
local createPickerWheel 
local createPickerWheelBtn
local createMask 
local maskListener
local mask 
local sex --print(notificationSet.alertContent[sex][plan].pre1)
local plan --print(notificationSet.alertContent[sex][plan].pre1)

-- local sGroup = display.newGroup( )
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    -- notificationSet.startNotify("2017/11/15" ,notificationSet.alertContent['Boy']["Bi"].pre1 )
    -- notificationSet.startNotify("2017/11/18" ,notificationSet.alertContent['Girl']["Bi"].pre1 )
    -- notificationSet.startNotify("2017/12/11" ,notificationSet.alertContent['Boy']["Huai"].dg6 )
    -- notificationSet.startNotify("2017/12/15" ,notificationSet.alertContent['Boy']["Huai"].pre1 )
    -- print( prevScene )
    -- title = display.newText( _parent, "設定", X, Y*0.2, font , H*0.045 )
    -- T.bg(_parent)
    createCircle(X*1.47,Y*0.315)
    createCircle(X*1.675,Y*0.633)
    createCircle(X*1.671,Y*0.9625)
    createCircle(X*1.675,Y*1.129)

    createSwitch(W*0.08,X*1.77,Y*0.316,"ON","OFF","psdPropect" ,gr1 , W*0.23 )
    createSwitch(W*0.08,X*1.7,Y*0.634,"ON","OFF","notification" , gr2 , W*0.23)
    createSwitch(W*0.1,X*1.69,Y*0.963,"想懷孕","想避孕","plan" , gr3 , W*0.262)
    createSwitch(W*0.08,X*1.7,Y*1.128,"女生","男生","sex" , gr4 , W*0.23)

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
    notifyTimeBtn = display.newRect( _parent, X, Y*0.8 , W*0.8, H*0.08 )
    -- notifyTimeBtn:setFillColor( 0 )
    notifyTimeBtn:addEventListener( "touch", notifyTimeBtnListener )

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
    
   pinkArrow3 = display.newImageRect( sceneGroup, "images/cell_arrow_pink@3x.png", W*0.0266, H*0.024 )
   pinkArrow3.x , pinkArrow3.y = W*0.86 , Y*0.8

   notiTimeText = display.newText( _parent, "8:35 上午", X*1.45, Y*0.8, bold , H*0.025 )
   notiTimeText:setFillColor( 254/255,118/255,118/255 )

    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
        notiTimeText.text = row.NotifyTime 
    end

   timer.performWithDelay( 1, function (  )
       Runtime:addEventListener( "key", onKeyEvent )
   end )


end

notifyTimeBtnListener = function ( e )
    if e.phase == "ended" then 
        createPickerWheel()
        createPickerWheelBtn()
        createMask()
    end
end

onKeyEvent = function( event )

    -- Print which key was pressed down/up
    local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
    print( message )
 
    -- If the "back" key was pressed on Android, prevent it from backing out of the app
    if (event.phase == "down" and event.keyName == "back") then
        --Here the key was pressed      
        downPress = true
        return true
    else 
        if ( event.keyName == "back" and event.phase == "up" and downPress ) then
            if ( system.getInfo("platform") == "android" ) then
                composer.showOverlay( "daily_calendar" )
                Runtime:removeEventListener( "key", onKeyEvent )
                return true
            end
        end
    end
 
    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
    -- This lets the operating system execute its default handling of the key
    return true
end


createPickerWheel = function ( btnId )
    
    local columnData 

   
    columnData =
    {
        {
            align = "left",
            width = W*0.25,
            startIndex = 1,
            labelPadding = W*0.05333,
            labels = { "上午","下午"}
        },
        {
            align = "left",
            width = W*0.15,
            labelPadding = W*0.01333,
            startIndex = 6,
            labels = { "01" ,"02" ,"03" ,"04" ,"05" ,"06" ,"07" ,"08" ,"09" ,"10" ,"11" ,"12"  }
        },
        {
            align = "left",
            labelPadding = W*0.01333,
            width = W*0.15,
            startIndex = 1,
            labels = { "00" ,"05", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55",  }
        }
    }

    
   
    -- Create the widget
    pickerWheel = widget.newPickerWheel(
    {
        x = X ,
        y = H*0.46,
        fontSize = H*0.03,
        font = bold , 
        rowHeight = H*0.043,
        columns = columnData , 
        style = "resizable", 
        width = W*0.55 , 

        sheet = T.pickerWheelSheet,
        topLeftFrame = 1,
        topMiddleFrame = 2,
        topRightFrame = 3,
        middleLeftFrame = 4,
        middleRightFrame = 5,
        bottomLeftFrame = 6,
        bottomMiddleFrame = 7,
        bottomRightFrame = 8,
        topFadeFrame = 9,
        bottomFadeFrame = 10,
        middleSpanTopFrame = 11,
        middleSpanBottomFrame = 12,
        separatorFrame = 13,
        middleSpanOffset = 4,
        borderPadding = 8

    })  
         
    sceneGroup:insert(pickerWheel)
    -- print( v1, v2, v3 )
end

createPickerWheelBtn = function (  )
    pkwBg = display.newImageRect( topGroup, "images/modal@3x.png", W*0.7, H*0.39 )
    pkwBg.x , pkwBg.y = X , H*0.4647

    pkwTitle = display.newText( topGroup, "通知時間", X, Y*0.595 , bold , H*0.03 )

    pickerWheelButtonEvent = function ( e )
        if ( "ended" == e.phase ) then
            if e.target.id == "clearPickerWheelBtn" then 
               
                -- if id == "close" then
                --     database:exec([[UPDATE Diary SET Close ="" WHERE date =']]..dbDate..[[';]])
                -- elseif id == "temperature" then
                --     database:exec([[UPDATE Diary SET Temperature ="" WHERE date =']]..dbDate..[[';]])
                -- elseif id == "weight" then
                --     database:exec([[UPDATE Diary SET Weight ="" WHERE date =']]..dbDate..[[';]])
                -- end
            elseif e.target.id == "chkPickerWheelBtn" then 
                local values = pickerWheel:getValues()
                -- if id == "close" then
                --     local v1 = values[1].value
                --     database:exec([[UPDATE Diary SET Close =']]..v1..[[' WHERE date =']]..dbDate..[[';]])
                -- elseif id == "temperature" then
                local v1 = values[1].value
                local v2 = values[2].value
                local v3 = values[3].value

                notiTimeText.text = v2..":"..v3.." "..v1
                database:exec([[UPDATE Setting SET NotifyTime =']]..v2..":"..v3.." "..v1..[[' WHERE id = 1 ;]])
                -- elseif id == "weight" then
                --     local v1 = values[1].value
                --     local v2 = values[2].value
                --     local v3 = values[3].value
                --     database:exec([[UPDATE Diary SET Weight =']]..v1..v2..v3..[[' WHERE date =']]..dbDate..[[';]])
                -- end

                if v1 == "下午" then 
                    v2 = v2 + 12 
                end 

                print(v2..":"..v3)
                database:exec([[UPDATE Notifications SET UTCTime = ']]..v2..":"..v3..[[' ;]])
                notificationSet.closeNotify()
                notificationSet.reOpenNotify()
            end

            pickerWheel:removeSelf( )
            clearPickerWheelBtn:removeSelf( )
            chkPickerWheelBtn:removeSelf( )
            pkwBg:removeSelf( )
            pkwTitle:removeSelf( )
            -- readDb()
            mask:removeSelf( )
            -- Runtime:removeEventListener( "key", onKeyEvent )
            -- Runtime:addEventListener( "key", onKeyEvent2 )

        end
    end

    clearPickerWheelBtn = widget.newButton({ 
        x = X*0.76,
        y = Y*1.24,
        id = "clearPickerWheelBtn",
        label = "取消",
        font = bold , 
        fontSize = H*0.03 ,
        width = W*0.213 ,
        height = H*0.054,
        shape = "roundedRect",
        cornerRadius  = H*0.009,
        fillColor = { default={254/255,118/255,118/255,1}, over={90/255,48/255,62/255,1} },
        labelColor = {default = {1,1,1} , over = {1,1,1} } ,
        onEvent = pickerWheelButtonEvent 
    })

    chkPickerWheelBtn = widget.newButton({ 
        x = X*1.24,
        y = Y*1.24,
        id = "chkPickerWheelBtn",
        label = "確定",
         font = bold , 
        fontSize = H*0.03 ,
        width = W*0.213 ,
        height = H*0.054,
        shape = "roundedRect",
        cornerRadius  = H*0.009,
        fillColor = { default={254/255,118/255,118/255,1}, over={90/255,48/255,62/255,1} },
        labelColor = {default = {1,1,1} , over = {1,1,1} } ,
        onEvent = pickerWheelButtonEvent 
    })

  
    topGroup:insert(clearPickerWheelBtn)
    topGroup:insert(chkPickerWheelBtn)

    
    -- Runtime:removeEventListener( "key", onKeyEvent2 )
    -- Runtime:addEventListener( "key", onKeyEvent )
    
end

maskListener = function ( e )
    if e.phase == "began" then
        display.getCurrentStage():setFocus( e.target )
    elseif e.phase == "ended" then
        display.getCurrentStage():setFocus(nil)
    end

    return true
end

createMask = function (  )
    mask = display.newRect( maskGroup, X, Y*0.9, W, H )
    mask:setFillColor( 0 )
    mask.alpha = 0.5
    mask:addEventListener( "touch", maskListener )
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

    local left = display.newImageRect( gr, "images/radio_on@3x.png",  sWidth, H*0.049 )
    left.x , left.y = sX - sPadding , sY

    local leftTextShadow = display.newText( gr, t1, left.x-sPadding/3+1 , left.y +1 , bold ,H*0.024 )
    leftTextShadow:setFillColor( 0.5 )
    local leftText = display.newText( gr, t1, left.x-sPadding/3, left.y, bold ,H*0.024 )
    

    local right = display.newImageRect( gr,"images/radio_off@3x.png",  sWidth, H*0.049 )
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
    gr:addEventListener( 'touch', function ( e )
        if e.phase == "ended" then 
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
                    
                    function onCompleteNoti( event )
                        if ( event.action == "clicked" ) then
                            local i = event.index
                            if ( i == 1 ) then
                                -- Do nothing; dialog will simply dismiss
                            elseif ( i == 2 ) then
                                database:exec([[UPDATE Setting SET Notification = "OFF" WHERE id = 1 ;]])
                                print( e.target.id..sw2 )
                                transition.to( e.target , {time = 200 , x =- W*0.157} )
                                transition.to( cTable[2] , {time = 200 , x = X*1.4} )
                                notificationSet.closeNotify()
                                database:exec([[DELETE FROM Notifications ;]])
                            end
                        end
                    end
                  
                    local alert = native.showAlert( "","將此通知功能關閉，日後將無法再收到任何本APP「個人化通知」中自動排程的貼心提醒，已排程的提醒亦會全數刪除。\n \n是否確定關閉？", { "NO","YES" }, onCompleteNoti )

                else
                    database:exec([[UPDATE Setting SET Notification = "ON" WHERE id = 1 ;]])
                    print( e.target.id..sw2 )
                    transition.to( e.target , {time = 200 , x = 0} )
                    transition.to( cTable[2] , {time = 200 , x = X*1.675} )
                    notificationSet.reOpenNotify()
                end
            elseif e.target.id == "plan" then
                sw3 = 1 - sw3
                if sw3 == 0 then
                    database:exec([[UPDATE Setting SET Plan = "想避孕" WHERE id = 1 ;]])
                    print( e.target.id..sw3)
                    transition.to( e.target , {time = 200 , x = - W*0.191} )
                    transition.to( cTable[3] , {time = 200 , x = X*1.33} )
                    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
                        if row.Notification == "ON" then
                            notificationSet.closeNotify()
                            notificationSet.reOpenNotify()
                        end
                    end
                else
                    database:exec([[UPDATE Setting SET Plan = "想懷孕" WHERE id = 1 ;]])
                    print( e.target.id..sw3 )
                    transition.to( e.target , {time = 200 , x = 0} )
                    transition.to( cTable[3] , {time = 200 , x = X*1.671} )
                    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
                        if row.Notification == "ON" then
                            notificationSet.closeNotify()
                            notificationSet.reOpenNotify()
                        end
                    end
                end
            elseif e.target.id == "sex" then
                sw4 = 1 - sw4
                if sw4 == 0 then
                    database:exec([[UPDATE Setting SET Sex = "男生" WHERE id = 1 ;]])
                    print( e.target.id..sw4 )
                    transition.to( e.target , {time = 200 , x = - W*0.157 } )
                    transition.to( cTable[4] , {time = 200 , x = X*1.4} )
                    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
                        if row.Notification == "ON" then
                            notificationSet.closeNotify()
                            notificationSet.reOpenNotify()
                        end
                    end
                else
                    database:exec([[UPDATE Setting SET Sex = "女生" WHERE id = 1 ;]])
                    print( e.target.id..sw4 )
                    transition.to( e.target , {time = 200 , x = 0} )
                    transition.to( cTable[4] , {time = 200 , x = X*1.675} )
                    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
                        if row.Notification == "ON" then
                            notificationSet.closeNotify()
                            notificationSet.reOpenNotify()
                        end
                    end
                end
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

    print(notificationSet.alertContent.Girl.Bi.pre7)
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
            createMask()
            

            tallSet()
            -- composer.showOverlay( "tallSet" )
        end
    end
end

tallSet = function (  )
    setGroup = display.newGroup( ) 
    topGroup:insert(setGroup)
    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1]]) do
        tt = row.Height
    end

    pkwBg = display.newImageRect( setGroup, "images/modal@3x.png", W*0.7, H*0.24 )
    pkwBg.x , pkwBg.y = X , H*0.353

    pinkkBg = display.newRect( setGroup, X, Y*0.53 , W*0.7, H*0.03 )
    pinkkBg:setFillColor( 254/255,118/255,118/255 )

    pkwTitle = display.newText( setGroup, "身高設定", X, Y*0.515 , bold , H*0.0254 )
    -- pkwTitle:setFillColor( 0 )

    cmText = display.newText( setGroup, "單位:公分", X, H*0.372 , bold, H*0.0194 )
    cmText:setFillColor( 0.67 )

    fieldBg = display.newImageRect( setGroup, "images/input@3x.png", W*0.32 , H*0.048 )
    fieldBg.x , fieldBg.y = X , H*0.33

    textField = native.newTextField( X, H*0.33, W*0.3, H*0.05 )
    textField.placeholder = tt
    textField.hasBackground = false
    textField.inputType = "number"
    native.setKeyboardFocus( textField )
    textField:addEventListener( "userInput", talltextListener )
    textField:setTextColor(226/255,68/255,61/255)
    setGroup:insert(textField)


    local cancelBtn = widget.newButton({ 
        x = X*0.76 ,
        y = H*0.431,
        id = "cancelBtn",
        label = "取消",
        font = bold , 
        fontSize = H*0.03 ,
        width = W*0.213 ,
        height = H*0.054,
        shape = "roundedRect",
        cornerRadius  = H*0.009,
        fillColor = { default={254/255,118/255,118/255,1}, over={90/255,48/255,62/255,1} },
        labelColor = {default = {1,1,1} , over = {1,1,1} } ,
        onEvent = tallsetBtnEvent 
    }) 

    setGroup:insert(cancelBtn)

    local confirmBtn = widget.newButton({ 
        x = X*1.24 ,
        y = H*0.431 ,
        id = "confirmBtn",
        label = "確定",
        font = bold , 
        fontSize = H*0.03 ,
        width = W*0.213 ,
        height = H*0.054,
        shape = "roundedRect",
        cornerRadius  = H*0.009,
        fillColor = { default={254/255,118/255,118/255,1}, over={90/255,48/255,62/255,1} },
        labelColor = {default = {1,1,1} , over = {1,1,1} } ,
        onEvent = tallsetBtnEvent 
    })
     setGroup:insert(confirmBtn)

end

tallsetBtnEvent = function ( e )
    if e.phase == "ended" then 
        if e.target.id == "cancelBtn" then
            native.setKeyboardFocus( nil )
            setGroup:removeSelf( )
            mask:removeSelf( )
        elseif e.target.id == "confirmBtn" then
            if tallText == nil then 
                tallText = ""
            end
            native.setKeyboardFocus( nil )
            database:exec([[UPDATE Setting SET Height =']]..tallText..[[' WHERE id =1;]])
            setGroup:removeSelf( )
            mask:removeSelf( )
        end
    end
end

talltextListener = function( event )
    if ( event.phase == "began" ) then
     
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        native.setKeyboardFocus( nil )
    elseif ( event.phase == "editing" ) then
        tallText = event.text 
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
    -- init(midGroup)
    sceneGroup:insert( gr1 )
    sceneGroup:insert( gr2 )
    sceneGroup:insert( gr3 )
    sceneGroup:insert( gr4 )
    -- init(midGroup)
    sceneGroup:insert( midGroup )
    sceneGroup:insert( cGroup )
    init(midGroup)
    sceneGroup:insert( maskGroup )
    sceneGroup:insert( topGroup )
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
        Runtime:removeEventListener( "key", onKeyEvent )
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
