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
local text1 
local text2 
local text3 
local text4 
local btn1 
local btn2 
local btn3 
local btnNext 
local createPickerWheel
local createPickerWheelBtn
local createMask
local maskListener
local maskGroup = display.newGroup ()
local topGroup = display.newGroup( )
local setValue1 
local setValue2
local setValue3
local daysTable = { 31 ,28 ,31 ,30 ,31 ,30 ,31 ,31 ,30 ,31 ,30 ,31 ,31 ,28}
local sY 
local sM 
local sD 
local bg 
local titleBg 
local bird 
local createCircle 
local sGroup = display.newGroup( )
local cGroup = display.newGroup( )
local midGroup = display.newGroup( )
local sw = 1
local circle 
local readDb
local blackTitle
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    createCircle(X*1.397,Y*0.953)
    createSwitch()
    bg = display.newImageRect( _parent, "images/radio_mask_1@3x.png", W, H )
    bg.x , bg.y = X , Y*1.0

    blackTitle = display.newRect( _parent, X, Y*0.07, W, H*0.07 )
    blackTitle.anchorY = 1
    blackTitle:setFillColor( 0 )

    titleBg = display.newImageRect( _parent, "images/bg_top@3x.png", W, H*0.07 )
    titleBg.x , titleBg.y ,titleBg.anchorY= X, Y*0.07 , 0

    bird = display.newImageRect( _parent, "images/twobirds@3x.png", W*0.2666, H*0.09 )
    bird.x , bird.y = X ,Y *0.37

    title = display.newText( _parent, "初次使用設定", X, Y*0.14, bold , H*0.032 )

    text1 = display.newText( _parent, "上次月經開始...", X*0.96, Y*0.53, bold , H*0.027 )
    text1.anchorX = 1 
    text1:setFillColor( 226/255,68/255,61/255 )
    text2 = display.newText( _parent, "月經週期", X*0.96, Y*0.665, bold , H*0.027 )
    text2.anchorX = 1 
    text2:setFillColor( 0.85,0.22,0.23 )
    text3 = display.newText( _parent, "經期長度", X*0.96, Y*0.795, bold , H*0.027 )
    text3.anchorX = 1 
    text3:setFillColor( 0.85,0.22,0.23 )
    text4 = display.newText( _parent, "性別", X*0.96, Y*0.955, bold , H*0.027 )
    text4.anchorX = 1 
    text4:setFillColor( 0.85,0.22,0.23 )

    addBtn()

     for row in database:nrows([[SELECT * FROM Setting WHERE id = 1]]) do
        if row.Cycle ~= "" then 
            composer.gotoScene( "enterPassword" )
        end
    end 

    
end

createCircle = function ( sX , sY , gr )
    circle = display.newImageRect( cGroup, "images/radio_btn@3x.png", H*0.057 , H*0.057 )
    circle.x , circle.y = sX , sY 
end

createSwitch = function (  )

    local left = display.newImageRect(  sGroup , "images/radio_on@3x.png",  W*0.23, H*0.049 )
    left.x , left.y = X*1.27 , Y*0.953

    local leftTextShadow = display.newText( sGroup, "女生", left.x - W*0.028 , left.y + W*0.002, bold , H*0.025 )
    leftTextShadow:setFillColor( 0.5 )
    local leftText = display.newText( sGroup, "女生", left.x - W*0.03, left.y, bold , H*0.025 )


    local right = display.newImageRect( sGroup, "images/radio_off@3x.png",  W*0.23, H*0.049 )
    right.x , right.y = W*0.77 , Y*0.953

    local rightTextShadow = display.newText( sGroup, "男生", right.x + W*0.032 , right.y + W*0.002, bold , H*0.025 )
    rightTextShadow:setFillColor( 0.5 )
    local rightText = display.newText( sGroup, "男生", right.x + W*0.03, right.y, bold , H*0.025 )
    
    readDb() 

    sGroup:addEventListener( "tap", function (  )
        sw = 1 - sw 
        print( sw )
        if sw == 0 then
             database:exec([[UPDATE Setting SET Sex = "男生" WHERE id = 1 ;]])
            transition.to( circle, {time = 200 , x = X*1.14} )
            transition.to(sGroup, {time = 200 , x = -W*0.1333})
        elseif sw == 1 then 
             database:exec([[UPDATE Setting SET Sex = "女生" WHERE id = 1 ;]])
            transition.to( circle, {time = 200 , x = X*1.397} )
            transition.to(sGroup, {time = 200 , x = 0})
        end 
    end )
end

readDb = function (  )
    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
        -- text6.text = row.Protect 
        -- text7.text = row.Notification
        -- text8.text = row.Plan
        -- text9.text = row.Sex

        if row.Sex == "女生" then 
            sGroup.x = 0
            circle.x = X*1.397
            sw = 1
        --     text6.text = "ON"
        --     setNum1 = 0
            -- gr.x = circleX - (leftW - circleW/2 + W*0.012)

        else
            sGroup.x = -W*0.1333
            circle.x = X*1.14
            sw = 0
            -- gr.x = circleX
        --     text6.text = "OFF"
        --     setNum1 = 1
        end
    end
end

createPickerWheel = function ( btnId )
    local columnData 

    if btnId == "btn1" then 
         columnData =
        {
            {
                align = "center",
                width = W*0.3,
                startIndex = 2,
                labelPadding = 1,
                labels = { "2015年", "2016年", "2017年","2018年" }
            },
            {
                align = "center",
                width = W*0.2,
                labelPadding = 10,
                startIndex = 1,
                labels = { "1月", "2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月", }
            },
            {
                align = "center",
                width = W*0.2,
                labelPadding = 10,
                startIndex = 1,
                labels = { "1日", "2日","3日","4日","5日","6日","7日","8日","9日","10日","11日","12日","13日","14日","15日","16日","17日","18日","19日","20日","21日","22日","23日","24日","25日","26日","27日","28日","29日","30日","31日", }
            },
        }
    elseif btnId == "btn2" then 
        columnData =
        {
            {
                align = "center",
                width = W*0.3,
                startIndex = 1,
                labelPadding = 10,
                labels = { "15天", "16天","17天","18天","19天","20天","21天","22天","23天","24天","25天","26天","27天","28天", }
            },
           
        }
    elseif btnId == "btn3" then 
        columnData =
        {
            {
                align = "center",
                width = W*0.2,
                startIndex = 1,
                labelPadding = 10,
                labels = { "2天","3天","4天","5天","6天","7天","8天","9天","10天" }
            },
           
        }
    end
   
    -- Create the widget
    pickerWheel = widget.newPickerWheel(
    {
        x = X ,
        y = Y*0.8,
        style = "resizable",
        width = W*0.3,
        rowHeight = H*0.05,
        fontSize = H*0.035,
        columns = columnData
    })  
         
    sceneGroup:insert(pickerWheel)
    -- print( v1, v2, v3 )
end

createPickerWheelBtn = function ( id )
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
                if id == "btn1" then
                    local v1 = string.sub(  values[1].value, 1 , -4 )
                    local v2 = string.sub(  values[2].value, 1 , -4 )
                    local v3 = string.sub(  values[3].value, 1 , -4 )
                    setValue1 = v1.."/"..string.format("%02d" , v2).."/"..string.format("%02d" , v3)
                    btn1:setLabel( values[1].value..values[2].value..values[3].value )
                elseif id == "btn2" then
                    setValue2 = string.sub( values[1].value, 1 , -4 )
                    btn2:setLabel( values[1].value )
                elseif id == "btn3" then
                    setValue3 = string.sub( values[1].value, 1 , -4 )
                    btn3:setLabel( values[1].value )
                    
                end
            end

            pickerWheel:removeSelf( )
            clearPickerWheelBtn:removeSelf( )
            chkPickerWheelBtn:removeSelf( )
            -- readDb()
            mask:removeSelf( )
        end
    end

    clearPickerWheelBtn = widget.newButton({ 
        x = X*0.8,
        y = Y*1.2,
        id = "clearPickerWheelBtn",
        label = "取消",
        fontSize = H*0.03 ,
        shape = "circle",
        radius = H*0.03 ,
        fillColor = { default={0.12,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = pickerWheelButtonEvent 
    })

    chkPickerWheelBtn = widget.newButton({ 
        x = X*1.2,
        y = Y*1.2,
        id = "chkPickerWheelBtn",
        label = "確定",
        fontSize = H*0.03 ,
        shape = "circle",
        radius = H*0.03 ,
        fillColor = { default={0.12,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = pickerWheelButtonEvent 
    })

  
    topGroup:insert(clearPickerWheelBtn)
    topGroup:insert(chkPickerWheelBtn)
end

maskListener = function ( e )
    if e.phase == "began" then
        display.getCurrentStage():setFocus( e.target )
        print( 123 )
    elseif e.phase == "ended" then
        display.getCurrentStage():setFocus(nil)
    end

    return true
end

createMask = function (  )
    mask = display.newRect( maskGroup, X, Y*0.9, W, H )
    mask:setFillColor( 0.9 )
    mask.alpha = 0.2
    mask:addEventListener( "touch", maskListener )
end

addBtn = function (  )
    btn1 = widget.newButton( {
        left = X*1.07 , 
        top = Y*0.48 , 
        id = "btn1" ,
        -- shape = "roundedRect",
        width = W*0.373,
        height = H*0.048,
        -- cornerRadius = H*0.015,
        label = "",
        fontSize = H*0.03 ,
        labelColor =  { default={226/255,68/255,61/255}, over={226/255,68/255,61/255}, } ,   
        -- strokeWidth = 1 ,
        -- strokeColor = { default={ 0.5, 0.5, 0.5 }, over={ 0.5, 0.5, 0.5 }, } , 
        defaultFile = "images/input@3x.png",
        -- overFile = "buttonOver.png",
        -- fillColor = { default={1,1,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = btnEvent 
        } )

    btn2 = widget.newButton( {
        left = X*1.07 , 
        top = Y*0.61 , 
        id = "btn2" ,
        -- shape = "roundedRect",
        width = W*0.213,
        height = H*0.048,
        defaultFile = "images/input@3x.png",
        -- cornerRadius = H*0.015,
        label = "",
        fontSize = H*0.03 ,
        labelColor =  { default={226/255,68/255,61/255}, over={226/255,68/255,61/255}, } ,   
        -- fillColor = { default={0.95,0.95,0.99,0.99}, over={0.2,0.78,0.75,0.4} },
        onEvent = btnEvent 
        } )

    btn3 = widget.newButton( {
        left = X*1.07 , 
        top = Y*0.745 , 
        id = "btn3" ,
        -- shape = "roundedRect",
        width = W*0.213,
        height = H*0.048,
        -- cornerRadius = H*0.015,
        defaultFile = "images/input@3x.png",
        label = "",
        fontSize = H*0.03 ,
        labelColor =  { default={226/255,68/255,61/255}, over={226/255,68/255,61/255}, } ,   
        -- fillColor = { default={0.95,0.95,0.99,0.99}, over={0.2,0.78,0.75,0.4} },
        onEvent = btnEvent 
        } )

    btnNext = widget.newButton( {
        x = X*1 , 
        y = Y*1.13 , 
        id = "btnNext" ,
        shape = "Rect",
        width = W*0.4,
        height = H*0.05,
        -- cornerRadius = 20,
        label = "下一步",
        font = bold ,
        fontSize = H*0.028 ,
        labelColor = {default = {1,1,1,1}} ,
        fillColor = { default={254/255,118/254,118/254,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = btnEvent 
        } )

    sceneGroup:insert(btn1)
    sceneGroup:insert(btn2)
    sceneGroup:insert(btn3)
    sceneGroup:insert(btnNext)
end
 
btnEvent = function ( e )
    if e.phase == "ended" then
        if e.target.id == "btnNext" then 
            -- composer.gotoScene( "enterPassword"  )
            if not setValue1 or not setValue2 or not setValue3 then
                T.alert("next")
            else
                database:exec([[INSERT INTO Statistics VALUES ( NULL , ']]..setValue1..[[' , ']]..setValue3..[[' , 0 );]])
                database:exec([[UPDATE Setting SET Cycle =']]..setValue2..[[' , regularCycle =']]..setValue2..[[' , During =']]..setValue3..[[' WHERE id = 1 ;]])
                
                sY = tonumber( string.sub( setValue1, 1 , 4 ) )
                sM = tonumber( string.sub( setValue1, 6 , 7 ) )
                sD = tonumber( string.sub( setValue1, 9 , 10 ) )
                sDate = sY.."/"..string.format("%02d",sM) .."/"..string.format("%02d",sD) 
                local t = tonumber(setValue3)
                for i = 1 , t do 

                    database:exec([[INSERT INTO Diary VALUES ( NULL , ']]..sDate..[[' , "" , "" ,"" ,"" ,"" ,"" , ']]..i..[['  ,"" ) ;]])
                    print( type(t).."ss"..t..i )
                    if i == 1 then
                        database:exec([[UPDATE Diary SET Start = 1 WHERE Date = ']]..sDate..[[';]])
                        print( 1 )
                    elseif i == t then 
                        print( "end" )
                        database:exec([[UPDATE Diary SET End = 1 WHERE Date = ']]..sDate..[[';]])
                    end

                    statisticCount()
                end 
                composer.gotoScene( "enterPassword"  )
            end
            
        elseif e.target.id == "btn1" then 
           createPickerWheelBtn("btn1")
           createPickerWheel("btn1")
           createMask()
        elseif e.target.id == "btn2" then 
           createPickerWheelBtn("btn2")
           createPickerWheel("btn2")
           createMask()
        elseif e.target.id == "btn3" then 
           createPickerWheelBtn("btn3")
           createPickerWheel("btn3")
           createMask()        
        end
    end
end

statisticCount = function (  )

    local sLeap = math.fmod( sY , 4)
    
    if sLeap == 3 then 
        daysTable[2] = 29
        -- print( "leap" )
    elseif sLeap ~= 3 then 
        daysTable[2] = 28
        -- print( "no leap" )
    end

  
    sD = sD + 1 
    if sD > daysTable[sM] then 
        sD = 1 
        sM = sM + 1 
        if sM > 12 then 
            sM = 1 
            sY = sY + 1 
        end
    end

    sDate = sY.."/"..string.format("%02d",sM).."/"..string.format("%02d",sD)
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
    sceneGroup = self.view
    sceneGroup:insert( sGroup )
    sceneGroup:insert( midGroup )
    sceneGroup:insert( cGroup )
    init(midGroup)

    sceneGroup:insert( maskGroup )
    sceneGroup:insert(topGroup)
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
