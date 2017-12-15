-----------------------------------------------------------------------------------------
--
-- leaveMessage.lua
--
-----------------------------------------------------------------------------------------

-- local sqlite3 = require "sqlite3"
local scene = composer.newScene()
local date = os.date( "*t" ) 
local init 
local sceneGroup
local title
local back
local writeDb
local month
local year 
local day 
local textListener 
local handleButtonEvent
local yText = ""
local mText = ""
local dText = ""
local c = tonumber(string.sub( os.date( "%Y" ) , 1 , 2 ))
local y = tonumber(string.sub( os.date( "%Y" ) , 3 , 4 ))
local m = tonumber(os.date( "%m" ))
local d = tonumber(os.date( "%d" ))
local w = tonumber(os.date( "%w" )) 
local dateText1
local dateText2
local week = ""
local daysTable = { 31 ,28 ,31 ,30 ,31 ,30 ,31 ,31 ,30 ,31 ,30 ,31 ,31 ,28}
local judgeWeek 
local leftLeapYear
local rightLeapYear
local checkDb
local text1 
local text2 
local text3
local text4
local text5
local text6
local createBtn
local createBtnEvent
local updateId
local createPickerWheel
local pickerWheel
local createPickerWheelBtn
local pickerWheelButtonEvent
local clearPickerWheelBtn
local chkPickerWheelBtn
local closeText 
local temperatureText 
local weightText 
local noticText
local btnGroup = display.newGroup( )
local textGroup = display.newGroup()
local maskGroup = display.newGroup()
local topGroup = display.newGroup()
local readDb
local mCalendarId = composer.getVariable( "mCalendarId" )
local mCalendarY = composer.getVariable( "mCalendarY" )
local mCalendarM = composer.getVariable( "mCalendarM" )
local mCalendarD = composer.getVariable( "mCalendarD" )
if mCalendarY then
    c = tonumber(string.sub( mCalendarY , 1 , 2 ))
    y = tonumber(string.sub( mCalendarY , 3 , 4 ))
    m = mCalendarM
    d = mCalendarD
end
local mNum = m
local yNum = y
local dbDate = tostring(c..y.."/"..string.format("%02d",m).."/"..string.format("%02d",d))
local listener
local prevScene = composer.getVariable( "prevScene" )
local checkBoxBtn 
local checkBoxBtnEvent
local ch1 , ch2 = 1 , 1
local checkBox1
local checkBox2
local maskListener
local createMask
local mask
local statisticalDays
local days
local startTable
local endTable
local sDate
local statusText 
local during
local judgeReadDb
local judgeDayStart
local judgeDayEnd
local deleteNum
local startCount = 0
-- local nextTime = 3
local startNum = 0 
local endNum = 0 
for row in database:nrows([[SELECT * FROM Setting ]]) do
    nextTime = row.During 
end
local startStatisticalDays
local endStatisticalDays 
local sDay
local duringDays
local continuanceCount 
local checkUpdate 
local updateCount
local bg_orange 
local pinkRect 
local checkbox_off1
local checkbox_off2 
local checkbox_on1
local checkbox_on2
local arrow
local addImages 
local bird 
local onKeyEvent
local onKeyEvent2
local pkwBg
local pkwTitle
local addNotifications 
local deleteNotifications 
local changeHoliday
local holiday = "ss"
local holidayTable = {
    {"02/14" , "西洋情人節" } ,
    {"08/17" , "七夕情人節" } ,
     -- {"11/25" , "七夕情人節!!" } ,
    {"12/24" , "聖誕夜" } ,
    {"12/31" , "跨年夜" } ,
}


local alertContent = {}
alertContent.Boy = {}
alertContent.Girl = {}

-- local A = {}

-- A.holiday = ""
-- return A
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    -- title = display.newText( _parent, "紀錄", X, Y*0.2, font , H*0.045 )
    T.bg(_parent)
    T.title("紀錄" , sceneGroup)

    bg_orange = display.newImageRect( _parent, "images/bg_orange@3x.png", W, H*0.602 )
    bg_orange.x , bg_orange.y = X , H*0.646

    pinkRect =  display.newRoundedRect( _parent, X, Y*0.991, W*0.92, H*0.538 ,H*0.015)
    pinkRect:setFillColor( 254/255,118/255,118/255 )

    text1 = display.newText( textGroup, "今天經期開始", W*0.194, H*0.279, bold , H*0.0254 )
    text1.anchorX = 0
    text1:setFillColor( 0 )
    checkbox_off1 = display.newImageRect( textGroup, "images/checkbox_off@3x.png", W*0.0586 , H*0.0329 )
    checkbox_off1.x , checkbox_off1.y = W*0.877 , H*0.279
    checkbox_on1 = display.newImageRect( textGroup, "images/checkbox_on@3x.png", W*0.0586 , H*0.0329 )
    checkbox_on1.x , checkbox_on1.y = W*0.877 , H*0.279
    checkbox_on1.alpha = 0

    text2 = display.newText( textGroup, "今天經期結束", W*0.194, H*0.3628, bold , H*0.0254 )
    text2.anchorX = 0
    text2:setFillColor( 0 )
    checkbox_off2 = display.newImageRect( textGroup, "images/checkbox_off@3x.png", W*0.0586 , H*0.0329 )
    checkbox_off2.x , checkbox_off2.y = W*0.877 , H*0.3628
    checkbox_on2 = display.newImageRect( textGroup, "images/checkbox_on@3x.png", W*0.0586 , H*0.0329 )
    checkbox_on2.x , checkbox_on2.y = W*0.877 , H*0.3628
    checkbox_on2.alpha = 0


    text3 = display.newText( textGroup, "親密行為", W*0.194, H*0.449, bold , H*0.0254 )
    text3.anchorX = 0
    text3:setFillColor( 0 )
    text4 = display.newText( textGroup, "基礎體溫°C", W*0.194, H*0.536, bold , H*0.0254 )
    text4.anchorX = 0
    text4:setFillColor( 0 )
    text5 = display.newText( textGroup, "體重KG", W*0.194, H*0.623, bold , H*0.0254 )
    text5.anchorX = 0
    text5:setFillColor( 0 )
    text6 = display.newText( textGroup, "Notes", W*0.194, H*0.710, bold , H*0.0254 )
    text6.anchorX = 0
    text6:setFillColor( 0 )

    statusText = display.newText( _parent, "今天是安全期", X, H*0.186, bold , H*0.0254 )
    statusText:setFillColor( 226/255,68/255,61/255  )

    closeText = display.newText( textGroup, "text", W*0.816, text3.y , bold , H*0.025 )
    closeText.anchorX = 1
    closeText:setFillColor( 254/255,118/255,118/255 )
    temperatureText = display.newText( textGroup, "text", W*0.816, text4.y , bold , H*0.025 )
    temperatureText.anchorX = 1
    temperatureText:setFillColor( 254/255,118/255,118/255 )
    weightText = display.newText( textGroup, "text", W*0.816, text5.y , bold , H*0.025 )
    weightText.anchorX = 1
    weightText:setFillColor( 254/255,118/255,118/255 )
    noticText = display.newText( textGroup, "text", W*0.816, text6.y , bold , H*0.025 )
    noticText.anchorX = 1
    noticText:setFillColor( 254/255,118/255,118/255 )
    arrow(text3.y)
    arrow(text4.y)
    arrow(text5.y)
    arrow(text6.y)
    addImages("images/ico_mc_start@3x.png",text1.y)
    addImages("images/ico_mc_end@3x.png",text2.y)
    addImages("images/ico_lip@3x.png",text3.y)
    addImages("images/ico_temp@3x.png",text4.y)
    addImages("images/ico_weight@3x.png",text5.y)
    addImages("images/ico_note@3x.png",text6.y)

    bird = display.newImageRect( textGroup, "images/bird_2@3x.png", W*0.12, H*0.0824 )
    bird.x , bird.y = W*0.897 , H*0.195
    -- ch1Text = display.newText( textGroup , "" , X*1.4 , Y*0.6, font , H*0.045 )
    -- ch2Text = display.newText( textGroup , "" , X*1.4 , Y*0.8, font , H*0.045 )
    createBtn()
    -- createPickerWheel()
    judgeWeek()
    dateText1 = display.newText( _parent, c..y.."/"..m.."/"..d , X , H*0.15 , bold , H*0.032 )
    dateText1:setFillColor( 226/255,68/255,61/255 )
    -- dateText2 = display.newText( _parent, c..y.."  "..week , X, Y*0.4, font , 30 )
    if m == 1 then 
        m = 13
        y = y - 1
    elseif m == 2 then 
        m = 14 
        y = y - 1
    end

    leftBtn = widget.newButton({ 
        x = W*0.277,
        y = H*0.15,
        id = "leftBtn",
        width = H*0.033,
        height = H*0.033,
        defaultFile = "images/btn_prev_r@3x.png",
        overFile = "images/btn_prev_r_press@3x.png",
        -- label = "<",
        -- fontSize = H*0.025 ,
        -- shape = "circle",
        -- radius = H*0.025 ,
        -- fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = handleButtonEvent 
    })

    rightBtn = widget.newButton({ 
        x = W*0.722,
        y = H*0.15,
        id = "rightBtn",
        width = H*0.033,
        height = H*0.033,
        defaultFile = "images/btn_next_r@3x.png",
        overFile = "images/btn_next_r_press@3x.png",
        onEvent = handleButtonEvent 
    })

    _parent:insert(leftBtn)
    _parent:insert(rightBtn)

    checkDb()
    -- checkBoxBtn()
    readDb()
    -- statisticalDays()
    timer.performWithDelay( 1, function (  )
        Runtime:addEventListener( "key", onKeyEvent2 )
    end )
    
    -- Runtime:removeEventListener( "key", onKeyEvent2 )
end

changeHoliday = function ( sex , plan , holiday , dayType )
    
    alertContent.Boy.Bi = { 
        
        holidaySafe = "今天是"..holiday.."，放鬆心情狂歡一下！雖為安全期，建議還是採取避孕措施" ,
        holidayDg = "今天是"..holiday.."，恰好為她的易孕期，要記得採取避孕措施唷！" ,
        holidayDg6 = "今天是"..holiday.."，恰好為她的預測排卵日，要記得採取避孕措施唷！" , 
        holidayPre7 = "今天是"..holiday.."，她的經期預計7天後開始，要好好服侍可能陰晴不定的她" , 
        holidayDuring = "今天是"..holiday.."，她的好朋友恰巧來訪，發揮你體貼的一面，與她溫馨共同度過"
    }

    alertContent.Boy.Huai = {
       
        holidaySafe = "今天是"..holiday.."，放鬆心情狂歡一下吧！" ,
        holidayDg = "今天是"..holiday.."，恰好為她的易孕期，要好好把握努力做人！" ,
        holidayDg6 = "今天是"..holiday.."，恰好為她的預測排卵日，好好把握唷！" , 
        holidayPre7 = "今天是"..holiday.."，她的經期預計7天後開始，要好好服侍可能陰晴不定的她" , 
        holidayDuring = "今天是"..holiday.."，她的好朋友恰巧來訪，發揮你體貼的一面，與她溫馨共同度過"
    }

    alertContent.Girl.Bi = {
       
        holidaySafe = "今天是"..holiday.."，放鬆心情狂歡一下！雖為安全期，建議還是採取避孕措施" ,
        holidayDg = "今天是"..holiday.."，恰好為易孕期，要記得採取避孕措施唷！" ,
        holidayDg6 = "今天是"..holiday.."，恰好為預測排卵日，要記得採取避孕措施唷！" , 
        holidayPre7 = "今天"..holiday.."，為經期前一週，注意抑油控痘舒壓，可多泡熱水澡促進血液循環" , 
        holidayDuring = "今天是"..holiday.."，雖然好朋友來訪，也要溫馨共同度過。"
    }

    alertContent.Girl.Huai = {
       
        holidaySafe = "今天是"..holiday.."，放鬆心情狂歡一下吧！" ,
        holidayDg = "今天是"..holiday.."，恰好為易孕期，好好把握努力做人！" ,
        holidayDg6 = "今天是"..holiday.."，恰好為預測排卵日，好好把握唷！" , 
        holidayPre7 = "今天"..holiday.."，為經期前一週，注意抑油控痘舒壓，可多泡熱水澡促進血液循環" , 
        holidayDuring = "今天是"..holiday.."，雖然好朋友來訪，也要溫馨共同度過。"

    }

    return alertContent[sex][plan][dayType]
end

onKeyEvent = function( event )

    -- Print which key was pressed down/up
    local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
    -- print( message )
 
    -- If the "back" key was pressed on Android, prevent it from backing out of the app
    if (event.phase == "down" and event.keyName == "back") then
        --Here the key was pressed      
        downPress = true
        return true
    else 
        if ( event.keyName == "back" and event.phase == "up" and downPress ) then
            if ( system.getInfo("platform") == "android" ) then
                pickerWheel:removeSelf( )
                clearPickerWheelBtn:removeSelf( )
                chkPickerWheelBtn:removeSelf( )
                mask:removeSelf( )
                pkwBg:removeSelf()
                pkwTitle:removeSelf()
                Runtime:removeEventListener( "key", onKeyEvent )
                timer.performWithDelay( 1, function ( )
                    Runtime:addEventListener( "key", onKeyEvent2 )
                end )
            
                return true
            end
        end
    end
 
    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
    -- This lets the operating system execute its default handling of the key
    return true
end

onKeyEvent2 = function( event )

    -- Print which key was pressed down/up
    local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
    -- print( message )
 
    -- If the "back" key was pressed on Android, prevent it from backing out of the app
    if (event.phase == "down" and event.keyName == "back") then
        --Here the key was pressed      
        downPress = true
        return true
    else 
        if ( event.keyName == "back" and event.phase == "up" and downPress ) then
            if ( system.getInfo("platform") == "android" ) then
                composer.showOverlay( prevScene )
                Runtime:removeEventListener( "key", onKeyEvent2 )

                return true
            end
        end
    end
 
    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
    -- This lets the operating system execute its default handling of the key
    return true
end

arrow = function ( arrowY )
    local arrowImge = display.newImageRect( textGroup, "images/cell_arrow_red@3x.png", W*0.0266, H*0.025 )
    arrowImge.x , arrowImge.y = W*0.877 , arrowY
end

addImages = function ( file , iconY )
    local icons = display.newImageRect( textGroup, file , H*0.036, H*0.036 )
    icons.x , icons.y = W*0.13 , iconY
end

listener = function ( e )
    -- composer.hideOverlay(  )
    if e.phase == "ended" then
        composer.setVariable( "dCalendarY", c..yNum )
        composer.setVariable( "dCalendarM", mNum )
        composer.setVariable( "dCalendarD", d )
        composer.showOverlay( prevScene )
        -- composer.showOverlay( "notes" )
    end
end


handleButtonEvent = function ( e )
    if ( "ended" == e.phase ) then
        if e.target.id == "leftBtn" then 
            leftLeapYear()

            -- print( daysTable[14] )
            d = d - 1
            if d < 1 then 
                m = m - 1
                if m < 3 then
                    m = 14
                    y = y - 1 
                end
                d = daysTable[m]
            end

            judgeWeek()
            
            yNum = y 
            if m == 12 and d == 31 then 
                yNum = y 
            elseif m > 12 then 
                yNum = y + 1 
            end

            mNum = m 
            if m == 13 then
                mNum = 1 
            elseif m == 14 then 
                mNum = 2 
            end 

            dateText1.text = c..yNum.."/"..mNum.."/"..d
            -- dbDate = tostring(dateText1.text)
            dbDate = c..yNum.."/"..string.format("%02d" ,mNum ).."/"..string.format("%02d" ,d )
            -- dateText2.text = c..yNum.."  "..week
            checkDb()
            readDb()
            -- print( c..y..m..d..":"..week )
        elseif e.target.id == "rightBtn" then 
            rightLeapYear()
            -- print( daysTable[14] )
            d = d + 1 
            if d > daysTable[m] then 
                d = 1 
                print( daysTable[m] )
                m = m + 1 
                if m > 14 then 
                    m = 3 
                    y = y + 1 
                end
            end

            judgeWeek()

            yNum = y 
            if m > 12 then 
                yNum = y + 1
            end

            mNum = m 
            if m == 13 then
                mNum = 1 
            elseif m == 14 then 
                mNum = 2 
            end 

            dateText1.text = c..yNum.."/"..mNum.."/"..d
            dbDate = c..yNum.."/"..string.format("%02d" ,mNum ).."/"..string.format("%02d" ,d )
            -- dateText2.text = c..yNum.."  "..week
            -- print( c..y..m..d..":"..week )
            checkDb()
            readDb()
        end
    end
end
    
judgeWeek = function (  )
  
    w = math.fmod( ( y + math.modf(y/4) + math.modf(c/4) - 2*c +  math.modf(26*(m+1)/10) + d - 1 ) , 7 )
    
    if w == 1 then
        week = "星期一"
    elseif w == 2 then
         week = "星期二"
    elseif w == 3 then
         week = "星期三"
    elseif w == 4 then
         week = "星期四"        
    elseif w == 5 then
         week = "星期五"
    elseif w == 6 then
         week = "星期六"
    elseif w == 0 then
         week = "星期日"
    end

    -- print(c..y..m..d..w)
end
    
leftLeapYear = function (  )
    local leap = math.fmod(c..y , 4)
    
    if leap == 0 then 
        daysTable[14] = 29
    elseif leap ~= 0 then 
        daysTable[14] = 28
    end
end

rightLeapYear = function (  )
    local leap = math.fmod(c..y , 4)
    
    if leap == 3 then 
        daysTable[14] = 29
    elseif leap ~= 3 then 
        daysTable[14] = 28
    end
end


writeDb = function (  )
    for row in database:nrows([[SELECT COUNT(*) FROM Diary ; ]]) do
        firstRow = row['COUNT(*)']
    end

    for i = 1 , daysTable[m] do 
        local uu 
        local uuDate = c..yNum.."/"..string.format("%02d",mNum) .."/"..string.format("%02d",i) 

        for row in database:nrows([[SELECT COUNT(*) FROM Diary WHERE date =  ']]..uuDate..[[' ; ]]) do
            uu = row['COUNT(*)']
        end

        if uu < 1 then 
            local tablesetup =  [[
                                INSERT INTO Diary VALUES ( NULL , ']]..c..yNum.."/"..string.format("%02d",mNum) .."/"..string.format("%02d",i)..[[' , "" , "" , "" , "" , "" , "","" , "");
                            ]]
                            -- CREATE TABLE IF NOT EXISTS Diary ( id INTEGER PRIMARY KEY , Data , Start , End , Close , Temperature , Weight , Notes);
            database:exec(tablesetup)
        end
    end
end

checkDb = function (  )
    for row in database:nrows([[SELECT COUNT(*) FROM Diary WHERE Date = ']]..dbDate..[[']]) do
        rows = row['COUNT(*)']
    end

    if rows < 1 then 
        writeDb()
    end
end
 

createBtn = function (  )

    createBtnEvent = function ( e )
        local today = tonumber(os.date( "%Y" ))..string.format("%02d", tonumber(os.date( "%m" )))..string.format("%02d", tonumber(os.date( "%d" ))) 
        local choseDay = string.sub( dbDate, 1 ,4 )..string.sub( dbDate, 6 ,7 )..string.sub( dbDate, 9 ,10 )
        
        if ( "ended" == e.phase ) then
            if today < choseDay then
                T.alert("future")
            else
                if e.target.id == "close" then 
                    createPickerWheelBtn("close")
                    createPickerWheel("close")
                    createMask()
                    Runtime:removeEventListener( "key", onKeyEvent2 )
                elseif e.target.id == "temperature" then 
                    createPickerWheelBtn("temperature")
                    createPickerWheel("temperature")
                    createMask()
                elseif e.target.id == "weight" then 
                    createPickerWheelBtn("weight")
                    createPickerWheel("weight")
                    createMask()
                 elseif e.target.id == "notes" then 
                    composer.setVariable( "dbDate", dbDate )
                    composer.showOverlay( "notes" )
                end
            end    
        end
    end

    local startBtn = widget.newButton({ 
        x = X*1,
        y = H*0.279,
        id = "start",
        label = "",
        fontSize = H*0.022 ,
        shape = "roundedRect",
        width = W*0.866,
        height = H*0.072,
        font = bold ,
        cornerRadius = H*0.009,
        fillColor = { default={1,1,1}, over={1,1,1} },
        onEvent = checkBoxBtnEvent 
    })

    local endBtn = widget.newButton({ 
        x = X*1,
        y = H*0.3628,
        id = "end",
        label = "",
        fontSize = H*0.022 ,
        shape = "roundedRect",
        width = W*0.866,
        height = H*0.072,
        font = bold ,
        cornerRadius = H*0.009,
        fillColor = { default={1,1,1}, over={1,1,1} },
        onEvent = checkBoxBtnEvent 
    })

    local closeBtn = widget.newButton({ 
        x = X*1,
        y = H*0.449,
        id = "close",
        label = "",
        fontSize = H*0.022 ,
        shape = "roundedRect",
        width = W*0.866,
        height = H*0.072,
        font = bold ,
        cornerRadius = H*0.009,
        fillColor = { default={1,1,1}, over={1,1,1} },
        onEvent = createBtnEvent 
    })

    local temperatureBtn = widget.newButton({ 
        x = X*1,
        y = H*0.536,
        id = "temperature",
        label = "",
        fontSize = H*0.022 ,
        shape = "roundedRect",
        width = W*0.866,
        height = H*0.072,
        font = bold ,
        cornerRadius = H*0.009,
        fillColor = { default={1,1,1}, over={1,1,1} },
        onEvent = createBtnEvent 
    })

    local weightBtn = widget.newButton({ 
        x = X*1,
        y = H*0.623,
        id = "weight",
        label = "",
         fontSize = H*0.022 ,
        shape = "roundedRect",
        width = W*0.866,
        height = H*0.072,
        font = bold ,
        cornerRadius = H*0.009,
        fillColor = { default={1,1,1}, over={1,1,1} },
        onEvent = createBtnEvent 
    })

    local notesBtn = widget.newButton({ 
        x = X*1,
        y = H*0.710,
        id = "notes",
        label = "",
         fontSize = H*0.022 ,
        shape = "roundedRect",
        width = W*0.866,
        height = H*0.072,
        font = bold ,
        cornerRadius = H*0.009,
        fillColor = { default={1,1,1}, over={1,1,1} },
        onEvent = createBtnEvent 
    })

    local backBtn = widget.newButton({
        label = "",
        onEvent = listener,
        left = W*0.032 ,
        top = H*0.035, 
        shape = "rect",
        width = W*0.1,
        height = H*0.06,
        fontSize = H*0.05 ,
        -- font = bold ,
        fillColor = { default={254/255,118/255,118/255,0.1}, over={1,0.1,0.7,0} },
        -- labelColor = { default={ 1, 1, 1 }, over={ 0.7, 0.7, 0.7 } }
        -- } )
        -- defaultFile = "images/nav_back@3x.png" , 
        -- overFile = "" , 
        })

    local backBtnImg = display.newImageRect( sceneGroup, "images/nav_back@3x.png", W*0.032, H*0.036 )
    backBtnImg.x , backBtnImg.y = W*0.032 , H*0.05 
    backBtnImg.anchorX , backBtnImg.anchorY = 0 , 0

    btnGroup:insert(backBtn)
    btnGroup:insert(closeBtn)
    btnGroup:insert(temperatureBtn)
    btnGroup:insert(weightBtn)
    btnGroup:insert(notesBtn)
    btnGroup:insert(startBtn)
    btnGroup:insert(endBtn)
end

createPickerWheel = function ( btnId )
    
    local columnData 

    if btnId == "close" then 
         columnData =
        {
            {
                align = "left",
                width = W*0.55,
                startIndex = 2,
                labelPadding = W*0.0533,
                labels = { "有避孕", "沒避孕", "不知道是否有避孕", }
            },
        }
    elseif btnId == "temperature" then 
        columnData =
        {
            {
                align = "left",
                width = W*0.25,
                startIndex = 3,
                labelPadding = W*0.0533,
                labels = { "35", "36", "37", "38" }
            },
            {
                align = "left",
                width = W*0.15,
                labelPadding = W*0.01333,
                startIndex = 6,
                labels = { ".00", ".01", ".02",".03",".04",".05",".06",".07",".08",".09",".10",".11",".12",".13",".14",".15",".16",".17",".18",".19",".20",".21",".22",".23",".24",".25",".26",".27",".28",".29",".30",".31",".32",".33",".34",".35",".36",".37",".38",".39",".40",".41",".42",".43",".44",".45",".46",".47",".48",".49",".50",".51",".52",".53",".54",".55",".56",".57",".58",".59",".60",".61",".62",".63",".64",".65",".66",".67",".68",".69",".70",".71",".72",".73",".74",".75",".76",".77", ".78",".79",".80",".81",".82",".83",".84",".85",".86",".87",".88",".89",".90",".91",".92",".93",".94",".95",".96",".97",".98",".99",}
            },
            {
                align = "left",
                labelPadding = W*0.01333,
                width = W*0.15,
                startIndex = 1,
                labels = { "°C" }
            }
        }
    elseif btnId == "weight" then 
        columnData =
        {
            {
                align = "left",
                width = W*0.25,
                startIndex = 11,
                labelPadding = W*0.05333,
                labels = { "35", "36", "37", "38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99",}
            },
            {
                align = "left",
                width = W*0.15,
                labelPadding = W*0.01333,
                startIndex = 6,
                labels = { ".0", ".1", ".2",".3",".4",".5",".6",".7",".8",".9", }
            },
            {
                align = "left",
                labelPadding = W*0.01333,
                width = W*0.15,
                startIndex = 1,
                labels = { "kg" }
            }
        }
    end
   
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

createPickerWheelBtn = function ( id )
    pkwBg = display.newImageRect( topGroup, "images/modal@3x.png", W*0.7, H*0.39 )
    pkwBg.x , pkwBg.y = X , H*0.4647

    pkwTitle = display.newText( topGroup, "", X, Y*0.595 , bold , H*0.03 )

    if id == "close" then 
        pkwTitle.text = "親密行為"
    elseif id == "temperature" then 
        pkwTitle.text = "基礎體溫"
    elseif id == "weight" then 
        pkwTitle.text = "體重"
    end 

    pickerWheelButtonEvent = function ( e )
        if ( "ended" == e.phase ) then
            if e.target.id == "clearPickerWheelBtn" then 
               
                if id == "close" then
                    database:exec([[UPDATE Diary SET Close ="" WHERE date =']]..dbDate..[[';]])
                elseif id == "temperature" then
                    database:exec([[UPDATE Diary SET Temperature ="" WHERE date =']]..dbDate..[[';]])
                elseif id == "weight" then
                    database:exec([[UPDATE Diary SET Weight ="" WHERE date =']]..dbDate..[[';]])
                end
            elseif e.target.id == "chkPickerWheelBtn" then 
                local values = pickerWheel:getValues()
                if id == "close" then
                    local v1 = values[1].value
                    database:exec([[UPDATE Diary SET Close =']]..v1..[[' WHERE date =']]..dbDate..[[';]])
                elseif id == "temperature" then
                    local v1 = values[1].value
                    local v2 = values[2].value
                    local v3 = values[3].value
                    database:exec([[UPDATE Diary SET Temperature =']]..v1..v2..v3..[[' WHERE date =']]..dbDate..[[';]])
                elseif id == "weight" then
                    local v1 = values[1].value
                    local v2 = values[2].value
                    local v3 = values[3].value
                    database:exec([[UPDATE Diary SET Weight =']]..v1..v2..v3..[[' WHERE date =']]..dbDate..[[';]])
                end
            end

            pickerWheel:removeSelf( )
            clearPickerWheelBtn:removeSelf( )
            chkPickerWheelBtn:removeSelf( )
            pkwBg:removeSelf( )
            pkwTitle:removeSelf( )
            readDb()
            mask:removeSelf( )
            Runtime:removeEventListener( "key", onKeyEvent )
            Runtime:addEventListener( "key", onKeyEvent2 )

        end
    end

    clearPickerWheelBtn = widget.newButton({ 
        x = X*0.76,
        y = Y*1.24,
        id = "clearPickerWheelBtn",
        label = "清除",
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
        label = "儲存",
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

    
    Runtime:removeEventListener( "key", onKeyEvent2 )
    Runtime:addEventListener( "key", onKeyEvent )
    
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

readDb = function (  )
    for row in database:nrows([[SELECT * FROM Diary WHERE Date = ']]..dbDate..[[']]) do
        closeText.text = row.Close 
        temperatureText.text = string.sub(row.Temperature,1,5)
        weightText.text = string.sub(row.Weight,1,4)
        noticText.text = row.Notes

        if #row.Close >= 12 then
            closeText.text = string.sub( row.Close, 1 , 9 ).."..."
        end

         if #row.Notes >= 12 then
            noticText.text = string.sub( row.Notes, 1 , 9 ).."..."
        end

        local start = tostring(row.Start)
        if start == "1" then 
            -- ch1Text.text = "V"
            checkbox_on1.alpha = 1
            ch1 = 0
        else
            checkbox_on1.alpha = 0
            -- ch1Text.text = ""
            ch1 = 1
        end

        local endd = tostring(row.End)
        if endd == "1" then 
            -- ch2Text.text = "V"
            checkbox_on2.alpha = 1
            ch2 = 0
        else
            -- ch2Text.text = ""
            checkbox_on2.alpha = 0
            ch2 = 1
        end

        if row.StartDays ~= "" then 
            statusText.text = "今天是月經期"
        else
            statusText.text = "今天是安全期"
        end
    end


    for row in database:nrows([[SELECT * FROM Statistics WHERE Startday >= ']]..dbDate..[[' ORDER BY Startday DESC ;]]) do
        recentStartDay = row.StartDay
    end

    -- print(recentStartDay)

    if recentStartDay then 
        local ddd = T.caculateDays( recentStartDay , dbDate)
        -- print(ddd.."::::")
        if ddd > 9 and ddd <= 19 then
            statusText.text = "今天是危險期"
        end 

        if ddd == 14 then 
            statusText.text = "今天是排卵日"
        end

        recentStartDay = nil
    else
        for row in database:nrows([[SELECT * FROM Statistics ORDER BY Startday ASC ;]]) do
            recentStartDay2 = row.StartDay
            -- print(111111111111)
        end

        if recentStartDay2 then
            for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
                if row.SetSwitch == 1 then 
                    avgDays2 = row.regularCycle
                elseif row.SetSwitch == 2 then 
                    avgDays2 = row.Cycle
                end 
            end 

            local predictDay = T.addDays(recentStartDay2 , avgDays2)
            local ddd = T.caculateDays( predictDay , dbDate)
            -- print(ddd.."::::")
            if ddd > 9 and ddd <= 19 then
                statusText.text = "今天是預測危險期"
            end 

            if ddd == 14 then 
                statusText.text = "今天是預測排卵日"
            end

            for row in database:nrows([[SELECT * FROM Setting ;]]) do
                if ddd <= 0 and ddd >= -row.During +1 then 
                    statusText.text = "今天是預測經期"
                end
            end 

            recentStartDay2 = nil
        end 
    end 
end

judgeReadDb = function ( judgeType )
        local judgeDayEndd = 0
        for row in database:nrows([[SELECT * FROM Diary WHERE Date = ']]..dbDate..[[']]) do
            judgeDayStart = row.StartDays  
            judgeDayEnd = ""
            -- row.StartDays    
            if row.Start == 1 then 
                judgeDayEndd = "1"
            end
        end


        local ftDate = nil 

        for row in database:nrows([[SELECT * FROM Statistics ORDER BY StartDay DESC ]]) do
            ftDate = row.StartDay
        end

        if ftDate and dbDate < ftDate or ftDate == nil then
            judgeDayEnd = "noStart"
        end


    -- if judgeType == "tooClose" then
        sD = tonumber( string.sub( dbDate, 9 , 10 ) )
        sM = tonumber( string.sub( dbDate, 6 , 7 ) )
        sY = tonumber( string.sub( dbDate, 1 , 4 ) )
        sDate = sY.."/"..sM.."/"..sD 

        for i = 1 , nextTime do 
            for row in database:nrows([[SELECT * FROM Diary WHERE Date = ']]..sDate..[[']]) do
                if row.Start == 1 then
                    judgeDayStart = "tooClose" 
                end

                -- print( "row.Start:"..row.Start..type(row.Start) )
            end
            statisticCount()
        end 

        if judgeDayEndd == "1" then 
            judgeDayEnd = "firstDay"
        end
        
    -- elseif
        -- elseif judgeType == "future" then
        local today = tonumber(os.date( "%Y" ))..string.format("%02d", tonumber(os.date( "%m" )))..string.format("%02d", tonumber(os.date( "%d" ))) 
        local choseDay = string.sub( dbDate, 1 ,4 )..string.sub( dbDate, 6 ,7 )..string.sub( dbDate, 9 ,10 )
        
        if today < choseDay then
            judgeDayStart = "future"
            judgeDayEnd = "future"
        end

    -- end
    print(judgeDayEnd.."###")
end

checkUpdate = function (  )
    for row in database:nrows([[SELECT COUNT(*) FROM Diary WHERE date =']]..sDate..[[';]]) do
        updateCount = row['COUNT(*)'] 
    end
end

checkBoxBtnEvent = function ( e )
    judgeReadDb()
    if ( "ended" == e.phase ) then
        if e.target.id == "start" then 
            ch1 = 1 - ch1
            if ch1 == 0 then 
                if judgeDayStart == "" then
                    -- ch1Text.text = "V"
                    checkbox_on1.alpha = 1
                    for row in database:nrows([[SELECT COUNT(*) FROM Diary WHERE Start != "" ;]]) do
                        startCount = row['COUNT(*)'] + 1
                        -- print( row['COUNT(*)'].."?????" )
                    end
                    -- print(startCount.."????")
                    database:exec([[UPDATE Diary SET Start = 1 WHERE date =']]..dbDate..[[';]])
                    sD = tonumber( string.sub( dbDate, 9 , 10 ) )
                    sM = tonumber( string.sub( dbDate, 6 , 7 ) )
                    sY = tonumber( string.sub( dbDate, 1 , 4 ) )
                    -- sDate = sY.."/"..sM.."/"..sD
                    sDate = sY.."/"..string.format("%02d",sM).."/"..string.format("%02d",sD)
                    for i = 1 , nextTime do 
                        checkUpdate( )
                        if updateCount < 1 then 
                            database:exec([[INSERT INTO Diary VALUES ( NULL , ']]..sDate..[[' , "" , "" , "" , "" ,"" , "" , ']]..i..[[' , "" );]])
                        elseif updateCount > 0 then 
                            database:exec([[UPDATE Diary SET StartDays = ']]..i..[[' WHERE date = ']]..sDate..[[';]])                            
                        end 
                        statisticCount( )
                        if i == nextTime-1 then
                            if updateCount < 1 then 
                                database:exec([[INSERT INTO Diary VALUES ( NULL , ']]..sDate..[[' , "" , 1 , "" , "" ,"" , "" , "" , "" );]])
                            elseif updateCount > 0 then 
                                database:exec([[UPDATE Diary SET End = 1 WHERE date = ']]..sDate..[[';]])
                            end
                        end 
                    end
                    addPeriodDay()
                    startStatisticalDays()

                    addNotifications()
                elseif judgeDayStart == "tooClose" then
                    print( judgeDayStart..":jjjday" )
                    T.alert("tooClose")
                elseif judgeDayStart == "future" then
                    print( judgeDayStart..":jjjday" )
                    T.alert("future")
                else
                    print( judgeDayStart..":jjjday" )
                    T.alert("already")
                end
            else
                function onCompleteee( event )
                    if ( event.action == "clicked" ) then
                        local i = event.index
                        if ( i == 1 ) then
                            -- Do nothing; dialog will simply dismiss
                        elseif ( i == 2 ) then
                            for row in database:nrows([[SELECT * FROM Statistics WHERE StartDay = ']]..dbDate..[[']]) do
                                deleteNum = row.Continuance 
                            end
                            sD = tonumber( string.sub( dbDate, 9 , 10 ) )
                            sM = tonumber( string.sub( dbDate, 6 , 7 ) )
                            sY = tonumber( string.sub( dbDate, 1 , 4 ) )
                            sDate = sY.."/"..sM.."/"..sD 
                            for i = 1 , deleteNum do 
                                database:exec([[UPDATE Diary SET StartDays = "" WHERE date =']]..sDate..[[';]])
                                statisticCount()
                                if i == deleteNum-1 then 
                                    database:exec([[UPDATE Diary SET End = "" WHERE date =']]..sDate..[[';]])
                                end
                            end
                            -- ch1Text.text = ""
                            checkbox_on1.alpha = 0
                            deleteNotifications()
                            database:exec([[UPDATE Diary SET Start = "" , StartDays = "" WHERE date =']]..dbDate..[[';]])
                            database:exec([[DELETE FROM Statistics WHERE StartDay =']]..dbDate..[[';]])
                            readDb()
                            
                            -- judgeDayEnd = "startDelete"
                        end
                    end
                end
              
                local alert = native.showAlert( "","確定刪除此筆經期資料?", { "NO" , "YES" }, onCompleteee )
                
            end
        elseif e.target.id == "end" then 
            ch2 = 1 - ch2
            if ch2 == 0 then 
                -- print(judgeDayEnd.."PPPPPPPP" )
                if judgeDayEnd == "" then
                    -- ch2Text.text = "V"
                    checkbox_on2.alpha = 1
                    -- database:exec([[UPDATE Diary SET End = 1 WHERE date =']]..dbDate..[[';]])XXX
                    endStatisticalDays()
                elseif judgeDayEnd == "future" then
                    print( judgeDayEnd..":jjjday" )
                    T.alert("future")
                elseif judgeDayEnd == "firstDay" then
                    print( judgeDayEnd..":jjjday" )
                    T.alert("firstDay") 
                elseif judgeDayEnd == "noStart" then
                    print( judgeDayEnd..":jjjday" )
                    T.alert("noStart") 
                else
                    print( judgeDayEnd..":jjjday" )
                end
            else
                -- ch2Text.text = ""
                -- database:exec([[UPDATE Diary SET End = "" WHERE date =']]..dbDate..[[';]])
                T.alert("notToday")
            end
        end            
    end
    
    -- newStatisticalDays()
    -- statisticalDays()
    readDb()
    -- addNotifications()
end

addNotifications = function (  )
    -- dbDate 
    -- print(T.addDays( dbDate , -5 ) )
    local duringNum
    local recentStartDay3 = {}
    local s = 0 

    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
        duringNum = row.During 
    end
   

    for row in database:nrows([[SELECT * FROM Statistics ORDER BY Startday ASC ;]]) do
        s = s + 1
        recentStartDay3[s] = row.StartDay
    end

  
    if dbDate >= recentStartDay3[s] then
        
        for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
            if row.SetSwitch == 1 then 
                avgDays2 = row.regularCycle
            elseif row.SetSwitch == 2 then 
                avgDays2 = row.Cycle
            end 
        end 
        local predictDay = T.addDays(recentStartDay3[s] , avgDays2)
        local ddd = T.caculateDays( predictDay , dbDate )

        -- local tablesetup =  [[
        --                         DELETE FROM Notifications WHERE NotifyDate >= ']]..T.addDays( dbDate , -7 )..[[' AND NotifyDate <= ']]..T.addDays( dbDate , ddd-9 )..[[' );
        --                         ]]
        local idTabel = {}
        local index = 0 

        for row in database:nrows([[SELECT * FROM Notifications WHERE NotifyDate >= ']]..T.addDays( recentStartDay3[s] , -7 )..[[' AND NotifyDate <= ']]..T.addDays( recentStartDay3[s] , 40 )..[[' ;]]) do
            index = index + 1 
            idTabel[index] = row.RandomId 
        end

        -- for i = 1 , #idTabel do 
        --     -- print( idTabel[i] )
        --     notifications.cancelNotification( notificationIDtable[idTabel[i]] )
        -- end 

        notifications.cancelNotification(  )


        database:exec([[DELETE FROM Notifications WHERE NotifyDate >= ']]..T.addDays( recentStartDay3[s] , -7 )..[[' AND NotifyDate <= ']]..T.addDays( recentStartDay3[s] ,40 )..[[' ;]])  --T.addDays( recentStartDay3[s] ,41 )
        print("DELETE:"..T.addDays( recentStartDay3[s] ,41 ))
        -- database:exec(tablesetup)   

        -- print(T.addDays( dbDate , -7 )..":"..T.addDays( dbDate , ddd-9 ))

        notificationSet.loadPlan()
        local holidayJudgePre7 = string.sub( T.addDays( dbDate , ddd-7 ) , 6,10 ) 
        for i = 1 , #holidayTable do
            if holidayJudgePre7 == holidayTable[i][1] then
                                print("{}{}{}{}{}{}{}{}{}ASDSAD")

                notificationSet.startNotify(T.addDays( dbDate , ddd-7 ) ,changeHoliday(sexNoti,planNoti,holidayTable[i][2],'holidayPre7') ,"holidayPre7")
            end 
        end

        local holidayJudgeDg6 = string.sub( T.addDays( dbDate , ddd-14 ) , 6,10 ) 
        for i = 1 , #holidayTable do
            if holidayJudgeDg6 == holidayTable[i][1] then
                -- holiday = holidayTable[i][2]
                -- print(changeHoliday(sexNoti,planNoti,holidayTable[i][2],'holidayDg6') )
                -- print(alertContent[sexNoti][planNoti].holidayDg6)
                notificationSet.startNotify(T.addDays( dbDate , ddd-14 ) ,changeHoliday(sexNoti,planNoti,holidayTable[i][2],'holidayDg6') ,"holidayDg6")

            end 
        end
       
        notificationSet.startNotify(T.addDays( dbDate , ddd-7 ) ,notificationSet.alertContent[sexNoti][planNoti].Mpre7 ,"Mpre7")
        notificationSet.startNotify(T.addDays( dbDate , 1 ) ,notificationSet.alertContent[sexNoti][planNoti].Mstart2 ,"Mstart2")
        notificationSet.startNotify(T.addDays( dbDate , duringNum-1 ) ,notificationSet.alertContent[sexNoti][planNoti].Mlast ,"Mlast")
        notificationSet.startNotify(T.addDays( dbDate , duringNum ) ,notificationSet.alertContent[sexNoti][planNoti].Mend1 ,"Mend1")
        notificationSet.startNotify(T.addDays( dbDate , ddd-13 ) ,notificationSet.alertContent[sexNoti][planNoti].Mdg7 ,"Mdg7")


        notificationSet.startNotify(T.addDays( dbDate , ddd-7 ) ,notificationSet.alertContent[sexNoti][planNoti].pre7 ,"pre7")
        notificationSet.startNotify(T.addDays( dbDate , ddd-1 ) ,notificationSet.alertContent[sexNoti][planNoti].pre1 ,"pre1")
        notificationSet.startNotify(T.addDays( dbDate , 0 ) ,notificationSet.alertContent[sexNoti][planNoti].first ,"first")
        notificationSet.startNotify(T.addDays( dbDate , duringNum-1 ) ,notificationSet.alertContent[sexNoti][planNoti].last ,"last")

        notificationSet.startNotify(T.addDays( dbDate , 40 ) ,notificationSet.alertContent[sexNoti][planNoti].Mno40 ,"Mno40")
        -- print(ddd.."DBDATEEEEE")
        notificationSet.startNotify(T.addDays( dbDate , ddd-19 ) ,notificationSet.alertContent[sexNoti][planNoti].dg1 ,"dg1")
        notificationSet.startNotify(T.addDays( dbDate , ddd-14 ) ,notificationSet.alertContent[sexNoti][planNoti].dg6 ,"dg6")
        notificationSet.startNotify(T.addDays( dbDate , ddd-10 ) ,notificationSet.alertContent[sexNoti][planNoti].dgLast ,"dgLast")
        notificationSet.startNotify(T.addDays( dbDate , ddd-9 ) ,notificationSet.alertContent[sexNoti][planNoti].safe ,"safe")

        for i = 1 , #holidayTable do
            if holidayTable[i][1] >= string.sub( T.addDays( dbDate , ddd-19 ),6,10) and  holidayTable[i][1] < string.sub( T.addDays( dbDate , ddd-9 ) ,6,10) then 
                print(holidayTable[i][2]..holidayTable[i][1])
                -- print( string.sub(dbDate , 1,5).."/"..holidayTable[i][1].."PPPPPPPPP")
                notificationSet.startNotify( string.sub(dbDate , 1,4).."/"..holidayTable[i][1] ,changeHoliday(sexNoti,planNoti,holidayTable[i][2],'holidayDg') ,"holidayDg")
            elseif holidayTable[i][1] >= string.sub( T.addDays( dbDate , 0 ) , 6,10) and holidayTable[i][1] <= string.sub( T.addDays( dbDate , duringNum-1 ) , 6 , 10) then 
                notificationSet.startNotify( string.sub(dbDate , 1,4).."/"..holidayTable[i][1] ,changeHoliday(sexNoti,planNoti,holidayTable[i][2],'holidayDuring' ),"holidayDuring")
                -- print(holidayTable[i][2]..holidayTable[i][1].."危險")
            elseif holidayTable[i][1] >= string.sub( T.addDays( dbDate , 0 ) , 6,10) and holidayTable[i][1] <= string.sub(T.addDays( dbDate , ddd-1 ) , 6 , 10 ) then
                notificationSet.startNotify( string.sub(dbDate , 1,4).."/"..holidayTable[i][1] ,changeHoliday(sexNoti,planNoti,holidayTable[i][2],'holidaySafe' ) ,"holidaySafe")
                -- print(holidayTable[i][2]..holidayTable[i][1])
                print( T.addDays( dbDate , ddd-1 ).."SADSADSADSA" )
            end 
        end
        recentStartDay3 = nil
    end
end

deleteNotifications = function (  )
    local duringNum
    local recentStartDay3 = {}
    local s = 0 

    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
        duringNum = row.During 
    end
   

    for row in database:nrows([[SELECT * FROM Statistics ORDER BY Startday ASC ;]]) do
        s = s + 1
        recentStartDay3[s] = row.StartDay
    end

    print(dbDate)
    print(recentStartDay3[s])
    print(recentStartDay3[s]==dbDate)
  
    if dbDate == recentStartDay3[s] then
        
        for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
            if row.SetSwitch == 1 then 
                avgDays2 = row.regularCycle
            elseif row.SetSwitch == 2 then 
                avgDays2 = row.Cycle
            end 
        end 
        local predictDay = T.addDays(recentStartDay3[s] , avgDays2)
        local ddd = T.caculateDays( predictDay , dbDate )

        local idTabel = {}
        local index = 0 

        for row in database:nrows([[SELECT * FROM Notifications WHERE NotifyDate >= ']]..T.addDays( recentStartDay3[s] , -7 )..[[' AND NotifyDate <= ']]..T.addDays( recentStartDay3[s] , 40 )..[[' ;]]) do
            index = index + 1 
            idTabel[index] = row.RandomId 
        end

        -- for i = 1 , #idTabel do 
        --     -- print( idTabel[i] )
        --     notifications.cancelNotification( notificationIDtable[idTabel[i]] )
        -- end 
        notifications.cancelNotification( )

        database:exec([[DELETE FROM Notifications WHERE NotifyDate >= ']]..T.addDays( recentStartDay3[s] , -7 )..[[' AND NotifyDate <= ']]..T.addDays( recentStartDay3[s] , 40 )..[[' ;]])
    end
end

addPeriodDay = function (  )
    --找出前面日期
    local e = os.date(os.time{year=string.sub(dbDate , 1 , 4) ,month=string.sub(dbDate , 6 , 7),day=string.sub(dbDate , 9 , 10)})
    -- local s = os.date(os.time{year=string.sub(sDay , 1 , 4) ,month=string.sub(sDay , 6 , 7),day=string.sub(sDay , 9 , 10)})
    local d = 14
    local s = e - d*24*60*60
    local sYear = os.date( "%Y" , s )
    local sMonth = os.date( "%m" , s )
    local sDay = os.date( "%d", s )
    -- print( sYear..sMonth..sDay.."&&&&&&&" )
    --=======================================================================

    --加入period編號
    for i = 1 , 40 do 

    end 
    -- local s1 = c..yNum.."/"..string.format("%02d",mNum) .."/".."01"
    -- local mm = mNum+1 
    -- local yy = yNum
    -- if mm > 12 then 
    --     mm = 1 
    --     yy = yNum + 1
    -- end
    -- local e1 = c..yy.."/"..string.format("%02d",mm+1) .."/".."01"
    -- local dTable = {}
    -- local dNum = 0 
    -- for row in database:nrows([[SELECT * FROM Statistics WHERE StartDay >= ']]..s1..[[' AND StartDay < ']]..e1..[[' ;]]) do
    --     -- print(row.StartDay.."***")
    --     dNum = dNum + 1
    --     dTable[dNum] = row.StartDay
    -- end 
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
        -- print( daysTable[sM] )
        sM = sM + 1 
        if sM > 12 then 
            sM = 1 
            sY = sY + 1 
        end
    end

    sDate = sY.."/"..string.format("%02d",sM).."/"..string.format("%02d",sD)
end

continuanceCount = function (  )
    local continuRows
    local continuTable = {}
    local continuNum = 0
    for row in database:nrows([[SELECT COUNT(*) FROM Statistics ;]]) do
        continuRows = row['COUNT(*)']
    end

    for row in database:nrows([[SELECT * FROM Statistics ORDER BY StartDay ASC ;]]) do
        continuNum = continuNum + 1 
        continuTable[continuNum] = row.StartDay 
        -- print(continuTable[continuNum]..":"..row.StartDay.."@@@@@@")
    end

    if continuRows > 1 then 

        for i = 1 , continuRows-1 do 
            local s = os.date(os.time({year = string.sub( continuTable[i] , 1 , 4 ), month = string.sub( continuTable[i] , 6 , 7) , day = string.sub( continuTable[i] , 9 , 10)}))
            local e = os.date(os.time({year = string.sub( continuTable[i+1] , 1 , 4 ), month = string.sub( continuTable[i+1] , 6 , 7) , day = string.sub( continuTable[i+1] , 9 , 10)}))
            local n = (24*60*60)
            local d = (e-s)/n
            -- print( d.."qq"..i )
            -- print( continuTable[i] )
            database:exec([[UPDATE Statistics SET Padding = ']]..d..[[' WHERE StartDay =']]..continuTable[i+1]..[[';]])
        end
    end

    -- if continuRows == 1 then
        database:exec([[UPDATE Statistics SET Padding = 0 WHERE StartDay =']]..continuTable[1]..[[';]])
    -- end


    --=================================================================================================
    -- local lastDay 

    -- for row in database:nrows([[SELECT * FROM Statistics ORDER BY StartDay ASC ;]]) do
    --     if row.StartDay and row.StartDay < dbDate then
    --         lastDay = row.StartDay
    --     end
    -- end

    -- print( lastDay )
end

startStatisticalDays = function (  )

    for row in database:nrows([[SELECT COUNT(*) FROM Statistics WHERE StartDay = ']]..dbDate..[[']]) do
        rows = row['COUNT(*)']
    end

    if rows < 1 then 
        local tablesetup =  [[
                INSERT INTO Statistics VALUES ( NULL , ']]..dbDate..[[' , ']]..nextTime..[[' , "" );
            ]]
                    -- CREATE TABLE IF NOT EXISTS Diary ( id INTEGER PRIMARY KEY , Data , Start , End , Close , Temperature , Weight , Notes);
            database:exec(tablesetup)
    end

    continuanceCount()
end

endStatisticalDays = function (  )
    for row in database:nrows([[SELECT * FROM Statistics WHERE StartDay < ']]..dbDate..[[' ORDER BY StartDay ASC ;]]) do
        sDay = row.StartDay 
    end 


    for row in database:nrows([[SELECT * FROM Diary WHERE End = 1 and Date > ']]..sDay..[[' ORDER BY Date DESC ]]) do
        eDay = row.Date 
        -- print( eDay.."eeeeeeeeeeeeee" )
    end 

    local e = os.date(os.time{year=string.sub(eDay , 1 , 4) ,month=string.sub(eDay , 6 , 7),day=string.sub(eDay , 9 , 10)})
    local s = os.date(os.time{year=string.sub(sDay , 1 , 4) ,month=string.sub(sDay , 6 , 7),day=string.sub(sDay , 9 , 10)})

    days = (tonumber(e-s)/24/60/60+1) 

    sD = tonumber( string.sub( sDay, 9 , 10 ) )
    sM = tonumber( string.sub( sDay, 6 , 7 ) )
    sY = tonumber( string.sub( sDay, 1 , 4 ) )
    sDate = sY.."/"..sM.."/"..sD
    -- print( days.."dddddddddddd" )
    for i = 1 , days do 
        database:exec([[UPDATE Diary SET StartDays = "" WHERE date =']]..sDate..[[';]])
        statisticCount()
        if i == days-1 then 
            database:exec([[UPDATE Diary SET End = "" WHERE date =']]..sDate..[[';]])
        end
    end
    -- database:exec([[UPDATE Diary SET End = "" WHERE date =']]..sDate..[[';]])
    -- database:exec([[UPDATE Diary SET Start = "" , StartDays = "" WHERE date =']]..sDay..[[';]])
    database:exec([[DELETE FROM Statistics WHERE StartDay =']]..sDay..[[';]])

    local e = os.date(os.time{year=string.sub(sDate , 1 , 4) ,month=string.sub(dbDate , 6 , 7),day=string.sub(dbDate , 9 , 10)})
    local s = os.date(os.time{year=string.sub(sDay , 1 , 4) ,month=string.sub(sDay , 6 , 7),day=string.sub(sDay , 9 , 10)})

    days = (tonumber(e-s)/24/60/60+1) 

    sD = tonumber( string.sub( sDay, 9 , 10 ) )
    sM = tonumber( string.sub( sDay, 6 , 7 ) )
    sY = tonumber( string.sub( sDay, 1 , 4 ) )
    sDate = sY.."/"..sM.."/"..sD

    for i = 1 , days do 
        database:exec([[UPDATE Diary SET StartDays = ']]..i..[[' WHERE date =']]..sDate..[[';]])
        statisticCount()
        if i == days-1 then 
            database:exec([[UPDATE Diary SET End = 1 WHERE date =']]..sDate..[[';]])
        end
    end

    for row in database:nrows([[SELECT COUNT(*) FROM Statistics WHERE StartDay = ']]..sDay..[[']]) do
        rows = row['COUNT(*)']
    end

    if rows < 1 then 
        local tablesetup =  [[
                INSERT INTO Statistics VALUES ( NULL , ']]..sDay..[[' , ']]..days..[[' , "" );
            ]]
                    -- CREATE TABLE IF NOT EXISTS Diary ( id INTEGER PRIMARY KEY , Data , Start , End , Close , Temperature , Weight , Notes);
            database:exec(tablesetup)
    end

    continuanceCount()
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
    sceneGroup = self.view
    init(sceneGroup)
    sceneGroup:insert( btnGroup )
    sceneGroup:insert( textGroup )
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
        Runtime:removeEventListener( "key", onKeyEvent2 )
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
