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
local pickerWheel
local onValueSelected
local onValueSelected2
local values
local values2
local v1
local v2
local touchlistener
local text1
local text2 
local text2Day
local text3 
local bg1 
local bg2
local indexCycle
local indexDuring
local paddingDays = 0 
local paddingNum = 0 
local avgCycle
local regularCycle
local setSwitch
local duringRect 
local chkOff1 
local chkOff2 
local chkOn1 
local chkOn2 
local onKeyEvent 
local w1 
local w2 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    -- title = display.newText( _parent, "週期設定", X, Y*0.2, font , H*0.045 )
    T.bg(_parent)
    T.title("週期設定" , sceneGroup)

    bg1 = display.newRect( _parent, X, H*0.266 , W*0.92, H*0.267 )
    bg1.id = "bg1"
    bg1:setFillColor( 254/255,118/255,118/255 )
    bg1:addEventListener( "touch", touchlistener )

    bg2 = display.newRect( _parent, X, H*0.463, W*0.92 , H*0.103 )
    bg2.id = "bg2"
    bg2:setFillColor( 0.78 )
    bg2:addEventListener( "touch", touchlistener )

    duringRect = display.newRect( _parent, X, H*0.665, W*0.92, H*0.267 )
    duringRect:setFillColor(  254/255,118/255,118/255 )
    -- back = display.newCircle( _ parent, X*0.2, Y*0.2, H*0.045 )
    -- back:addEventListener( "tap", listener )
    T.backBtn(sceneGroup,"setup")

    text1 = display.newText( _parent, "採用固定周期", X*0.37, H*0.266, bold ,H*0.027 )
    text1.anchorX = 0
    text2 = display.newText( _parent, "採用平均週期", X*0.37, H*0.463, bold,H*0.027 )
    text2.anchorX = 0
    text2Day = display.newText( _parent, "    天", X*1.8, H*0.463, bold,H*0.027 )
    text2Day.anchorX = 1
    text3 = display.newText( _parent, "每次行經日數", W*0.0666, H*0.665, bold,H*0.027 )
    text3.anchorX = 0

    chkOff1 = display.newImageRect( _parent, "images/checkbox_w_off@3x.png", H*0.033, H*0.033 )
    chkOff1.x , chkOff1.y = W*0.096 , H*0.266

    chkOff2 = display.newImageRect( _parent, "images/checkbox_w_off@3x.png", H*0.033, H*0.033 )
    chkOff2.x , chkOff2.y = W*0.096 , H*0.463

    chkOn1 = display.newImageRect(_parent, "images/checkbox_w_on@3x.png", H*0.033, H*0.033 )
    chkOn1.x , chkOn1.y = W*0.096 , H*0.266
    chkOn1.alpha = 0

    chkOn2 = display.newImageRect(_parent, "images/checkbox_w_on@3x.png", H*0.033, H*0.033 )
    chkOn2.x , chkOn2.y = W*0.096 ,  H*0.463
    chkOn2.alpha = 0

    for row in database:nrows([[SELECT * FROM Statistics ;]]) do
        paddingDays = paddingDays + row.Padding
        paddingNum = paddingNum + 1
    end

    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
        avgCycle = row.Cycle
        text2Day.text = avgCycle.."    天"
    end

    if paddingNum > 1 then 
        avgCycle = string.format("%d" , paddingDays/(paddingNum-1) )
        text2Day.text = string.format("%d" , paddingDays/(paddingNum-1) ).."    天"
    end

    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
        indexCycle = row.regularCycle
        regularCycle = row.regularCycle
    end

    w1 = display.newRect( sceneGroup, X*1.55, H*0.266, W*0.24, H*0.21 )
    w2 = display.newRect( sceneGroup, X*1.55, H*0.665, W*0.24, H*0.21 )

    local columnData = 
    { 
        { 
            align = "center",
            width =  W*0.25,
            labelPadding = 0,
            startIndex = indexCycle-14 ,
            labels = { "15天", "16天", "17天", "18天" , "19天", "20天", "21天", "22天", "23天", "24天","25天","26天","27天","28天","29天","30天","31天","32天","33天","34天","35天","36天","37天","38天","39天","40天","41天","42天","43天","44天","45天","46天","47天","48天","49天","50天","51天","52天","53天","54天","55天","56天","57天","58天","59天","60天", }
        },
    }
 
    -- Create the widget
    pickerWheel = widget.newPickerWheel(
    {
        x = X*1.55 ,
        y = H*0.266 ,
        columns = columnData,
        style = "resizable",
        width = W*0.25,
        rowHeight = H*0.043,
        fontSize = H*0.03,
        font = bold , 
        onValueSelected = onValueSelected,

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
 
    _parent:insert(pickerWheel)
    
    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
        indexDuring = row.During
    end

    local columnData2 = 
    { 
        { 
            align = "center",
            width =  W*0.25,
            labelPadding = 20,
            startIndex = indexDuring-1 ,
            labels = { "2天", "3天", "4天", "5天" , "6天", "7天", "8天", "9天", "10天", }
        },
    }
 
    -- Create the widget
    pickerWheel2 = widget.newPickerWheel(
    {
        x = X*1.55 ,
        y = H*0.665 ,
        columns = columnData2,
        style = "resizable",
        width = W*0.25,
        -- height = H*0.1 ,
        rowHeight = H*0.043,
        fontSize = H*0.03,
        font = bold , 
        onValueSelected = onValueSelected2,

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
 
    _parent:insert(pickerWheel2)
    
    -- local xxx = display.newCircle( _parent, X, Y*1.7, 30 )
    -- xxx:addEventListener( "tap", xxxlistener )
    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
        setSwitch = row.SetSwitch
    end

    if setSwitch == 1 then 
        chkOn1.alpha = 1
        chkOn2.alpha = 0
        bg1:setFillColor( 254/255,118/255,118/255 )
        bg2:setFillColor( 0.78 )
    elseif setSwitch == 2 then 
        chkOn1.alpha = 0
        chkOn2.alpha = 1
        bg1:setFillColor( 0.78 )
        bg2:setFillColor( 254/255,118/255,118/255 )
    end 

    timer.performWithDelay( 1, function (  )
        Runtime:addEventListener( "key", onKeyEvent )
    end  )
    
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
                composer.showOverlay( "setup" )
                Runtime:removeEventListener( "key", onKeyEvent )
                return true
            end
        end
    end
 
    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
    -- This lets the operating system execute its default handling of the key
    return true
end

listener = function ( e )
    composer.showOverlay( "setup" )
end

onValueSelected = function (  )

    timer.performWithDelay( 1, function (  )
        values = pickerWheel:getValues()
        regularCycle = string.sub(  values[1].value , 1 , -4 )
        database:exec([[UPDATE Setting SET Cycle = ']]..regularCycle..[[' , regularCycle = ']]..regularCycle..[[' WHERE id = 1 ;]])
        database:exec([[UPDATE Setting SET setSwitch = 1 WHERE id = 1 ;]])
        -- print( v1 )
        bg1:setFillColor( 254/255,118/255,118/255 )
        bg2:setFillColor( 0.78 )
        chkOn1.alpha = 1
        chkOn2.alpha = 0
        print(regularCycle)
    end  )
   
end

onValueSelected2 = function (  )

    timer.performWithDelay( 1, function (  )
        values2 = pickerWheel2:getValues()
        v2 = string.sub(  values2[1].value , 1 , -4 )
        database:exec([[UPDATE Setting SET During = ']]..v2..[[' WHERE id = 1 ;]])
        print( v2 )
    end  )
   
end
    
touchlistener = function ( e )
    if e.phase == "ended" then
        if e.target.id == "bg1" then
            chkOn1.alpha = 1
            chkOn2.alpha = 0
            bg1:setFillColor( 254/255,118/255,118/255 )
            bg2:setFillColor( 0.78 )
            if regularCycle then
                database:exec([[UPDATE Setting SET Cycle = ']]..regularCycle..[[' , regularCycle = ']]..regularCycle..[[' WHERE id = 1 ;]])
                database:exec([[UPDATE Setting SET setSwitch = 1 WHERE id = 1 ;]])
            end
        elseif e.target.id == "bg2" then
            chkOn1.alpha = 0
            chkOn2.alpha = 1
            bg1:setFillColor( 0.78 )
            bg2:setFillColor( 254/255,118/255,118/255 )
            database:exec([[UPDATE Setting SET Cycle = ']]..avgCycle..[[' WHERE id = 1 ;]])
            database:exec([[UPDATE Setting SET setSwitch = 2 WHERE id = 1 ;]])
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
