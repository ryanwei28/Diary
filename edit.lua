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
local mNum = m
local yNum = y
local leftLeapYear
local rightLeapYear
local checkDb
local text1 
local text2 
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
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )

    title = display.newText( _parent, "紀錄", X, Y*0.2, font , H*0.045 )

    text1 = display.newText( _parent, "今天經期開始", X*0.3, Y*0.6, font , H*0.035 )
    text1.anchorX = 0
    text2 = display.newText( _parent, "今天經期結束", X*0.3, Y*0.8, font , H*0.035 )
    text2.anchorX = 0
    
    statusText = display.newText( _parent, "今天是安全期", X, Y*0.5, font , H*0.025 )
    statusText:setFillColor( 0.88 , 0.33 , 0.342 )

    closeText = display.newText( textGroup, "text", X*1.2, Y*1 , font , H*0.025 )
    closeText.anchorX = 0
    temperatureText = display.newText( textGroup, "text", X*1.2, Y*1.2 , font , H*0.025 )
    temperatureText.anchorX = 0
    weightText = display.newText( textGroup, "text", X*1.2, Y*1.4 , font , H*0.025 )
    weightText.anchorX = 0
    noticText = display.newText( textGroup, "text", X*1.2, Y*1.6 , font , H*0.025 )
    noticText.anchorX = 0

    createBtn()
    -- createPickerWheel()
    judgeWeek()
    dateText1 = display.newText( _parent, c..y.."/"..m.."/"..d , X , Y*0.4 , font , H*0.038 )
    -- dateText2 = display.newText( _parent, c..y.."  "..week , X, Y*0.4, font , 30 )
    if m == 1 then 
        m = 13
        y = y - 1
    elseif m == 2 then 
        m = 14 
        y = y - 1
    end

    leftBtn = widget.newButton({ 
        x = X*0.55,
        y = Y*0.4,
        id = "leftBtn",
        label = "<",
        fontSize = H*0.025 ,
        shape = "circle",
        radius = H*0.025 ,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = handleButtonEvent 
    })

    rightBtn = widget.newButton({ 
        x = X*1.45,
        y = Y*0.4,
        id = "rightBtn",
        label = ">",
        fontSize = H*0.025 ,
        shape = "circle",
        radius = H*0.025 ,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = handleButtonEvent 
    })

    _parent:insert(leftBtn)
    _parent:insert(rightBtn)

    checkDb()
    checkBoxBtn()
    readDb()
    -- statisticalDays()
    
end

listener = function ( e )
    -- composer.hideOverlay(  )
    composer.showOverlay( prevScene )
    -- composer.showOverlay( "notes" )
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
            print( c..y..m..d..":"..week )
        elseif e.target.id == "rightBtn" then 
            rightLeapYear()
            print( daysTable[14] )
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
            print( c..y..m..d..":"..week )
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
        print( "leap" )
    elseif leap ~= 0 then 
        daysTable[14] = 28
        print( "no leap" )
    end
end

rightLeapYear = function (  )
    local leap = math.fmod(c..y , 4)
    
    if leap == 3 then 
        daysTable[14] = 29
        print( "leap" )
    elseif leap ~= 3 then 
        daysTable[14] = 28
        print( "no leap" )
    end
end

-- writeDb = function (  )
--     for i = 1 , daysTable[m] do 
--         local tablesetup =  [[
--                             INSERT INTO Diary VALUES ( NULL , ']]..c..yNum.."/"..string.format("%02d",mNum) .."/"..string.format("%02d",i)..[[' , "" , "" , "" , "" , "" , "","");
--                         ]]
--                         -- CREATE TABLE IF NOT EXISTS Diary ( id INTEGER PRIMARY KEY , Data , Start , End , Close , Temperature , Weight , Notes);
--         database:exec(tablesetup)
--     end
-- end


writeDb = function (  )
    for row in database:nrows([[SELECT COUNT(*) FROM Diary ; ]]) do
        firstRow = row['COUNT(*)']
    end

    if firstRow <= 10 then 
        for row in database:nrows([[SELECT * FROM Diary WHERE Start = 1 ;]]) do
            firstStart = row.Date
        end

        for row in database:nrows([[SELECT * FROM Diary WHERE End = 1 ;]]) do
            firstEnd = row.Date
        end

         for i = 1 , daysTable[m] do 
            local firstDate = c..yNum.."/"..string.format("%02d",mNum) .."/"..string.format("%02d",i) 
            
            if firstDate < firstStart or firstDate > firstEnd then

                local tablesetup =  [[
                                    INSERT INTO Diary VALUES ( NULL , ']]..c..yNum.."/"..string.format("%02d",mNum) .."/"..string.format("%02d",i)..[[' , "" , "" , "" , "" , "" , "","");
                                ]]
                                -- CREATE TABLE IF NOT EXISTS Diary ( id INTEGER PRIMARY KEY , Data , Start , End , Close , Temperature , Weight , Notes);
                database:exec(tablesetup)
            else

            end
        end
    else
        for i = 1 , daysTable[m] do 
            local tablesetup =  [[
                                INSERT INTO Diary VALUES ( NULL , ']]..c..yNum.."/"..string.format("%02d",mNum) .."/"..string.format("%02d",i)..[[' , "" , "" , "" , "" , "" , "","");
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
    -- print("rrrr:"..rows)
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

    local closeBtn = widget.newButton({ 
        x = X*1,
        y = Y*1,
        id = "close",
        label = "親密行為                                            ＞",
        fontSize = H*0.022 ,
        shape = "roundedRect",
        width = W*0.8,
        height = H*0.08,
        cornerRadius = H*0.015,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = createBtnEvent 
    })

    local temperatureBtn = widget.newButton({ 
        x = X*1,
        y = Y*1.2,
        id = "temperature",
        label = "基礎體溫                                            ＞",
        fontSize = H*0.022 ,
        shape = "roundedRect",
        width = W*0.8,
        height = H*0.08,
        cornerRadius = H*0.015,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = createBtnEvent 
    })

    local weightBtn = widget.newButton({ 
        x = X*1,
        y = Y*1.4,
        id = "weight",
        label = "體重KG                                            ＞",
        fontSize = H*0.022 ,
        shape = "roundedRect",
        width = W*0.8,
        height = H*0.08,
        cornerRadius = H*0.015,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = createBtnEvent 
    })

    local notesBtn = widget.newButton({ 
        x = X*1,
        y = Y*1.6,
        id = "notes",
        label = "Notes                                            ＞",
        fontSize = H*0.022 ,
        shape = "roundedRect",
        width = W*0.8,
        height = H*0.08,
        cornerRadius = H*0.015,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = createBtnEvent 
    })

    back = display.newCircle(  X*0.2, Y*0.2, H*0.045 )
    back:addEventListener( "tap", listener )

    btnGroup:insert(back)
    btnGroup:insert(closeBtn)
    btnGroup:insert(temperatureBtn)
    btnGroup:insert(weightBtn)
    btnGroup:insert(notesBtn)

end

createPickerWheel = function ( btnId )
    local columnData 

    if btnId == "close" then 
         columnData =
        {
            {
                align = "left",
                width = H*0.19,
                startIndex = 2,
                labelPadding = 1,
                labels = { "有避孕", "沒避孕", "不知道是否有避孕", }
            },
        }
    elseif btnId == "temperature" then 
        columnData =
        {
            {
                align = "left",
                width = H*0.075,
                startIndex = 2,
                labelPadding = 10,
                labels = { "35", "36", "37", "38" }
            },
            {
                align = "left",
                width = H*0.075,
                labelPadding = 10,
                startIndex = 1,
                labels = { ".00", ".01", ".02",".03",".04",".05",".06", }
            },
            {
                align = "left",
                labelPadding = 10,
                width = H*0.075,
                startIndex = 1,
                labels = { "度C" }
            }
        }
    elseif btnId == "weight" then 
        columnData =
        {
            {
                align = "left",
                width = H*0.075,
                startIndex = 2,
                labelPadding = 10,
                labels = { "35", "36", "37", "38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99",}
            },
            {
                align = "left",
                width = H*0.075,
                labelPadding = 10,
                startIndex = 1,
                labels = { ".0", ".1", ".2",".3",".4",".5",".6",".7",".8",".9", }
            },
            {
                align = "left",
                labelPadding = 10,
                width = H*0.075,
                startIndex = 1,
                labels = { "kg" }
            }
        }
    end
   
    -- Create the widget
    pickerWheel = widget.newPickerWheel(
    {
        x = X ,
        y = Y*0.8,
        fontSize = H*0.024,
        columns = columnData
    })  
         
    sceneGroup:insert(pickerWheel)
    -- print( v1, v2, v3 )
end

createPickerWheelBtn = function ( id )
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
            readDb()
            mask:removeSelf( )
        end
    end

    clearPickerWheelBtn = widget.newButton({ 
        x = X*0.8,
        y = Y*1.2,
        id = "clearPickerWheelBtn",
        label = "清除",
        fontSize = H*0.038 ,
        shape = "circle",
        radius = H*0.025 ,
        fillColor = { default={0.12,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = pickerWheelButtonEvent 
    })

    chkPickerWheelBtn = widget.newButton({ 
        x = X*1.2,
        y = Y*1.2,
        id = "chkPickerWheelBtn",
        label = "儲存",
        fontSize = H*0.038 ,
        shape = "circle",
        radius = H*0.025 ,
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

readDb = function (  )
    for row in database:nrows([[SELECT * FROM Diary WHERE Date = ']]..dbDate..[[']]) do
        closeText.text = row.Close 
        temperatureText.text = row.Temperature
        weightText.text = row.Weight
        noticText.text = row.Notes

        print( type(row.Start).."start" )
        local start = tostring(row.Start)
        if start == "1" then 
            ch1Text.text = "V"
            ch1 = 0
        else
            ch1Text.text = ""
            ch1 = 1
        end

        local endd = tostring(row.End)
        if endd == "1" then 
            ch2Text.text = "V"
            ch2 = 0
        else
            ch2Text.text = ""
            ch2 = 1
        end

        if row.StartDays ~= "" then 
            statusText.text = "今天是月經期"
        else
            statusText.text = "今天是安全期"
        end
    end
end

judgeReadDb = function ( judgeType )
    
        for row in database:nrows([[SELECT * FROM Diary WHERE Date = ']]..dbDate..[[']]) do
            judgeDayStart = row.StartDays  
            judgeDayEnd = ""
            -- row.StartDays    
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

        if judgeDayEnd == "1" then 
            judgeDayEnd = "firstDay"
        end
   
    -- elseif judgeType == "noStart" then
        for row in database:nrows([[SELECT * FROM Statistics ORDER BY StartDay DESC ]]) do
            ftDate = row.StartDay
        end

        if ftDate and dbDate < ftDate then
            judgeDayEnd = "noStart"
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
end

checkBoxBtn = function (  )
    checkBoxBtnEvent = function ( e )
        judgeReadDb()
        if ( "ended" == e.phase ) then
            if e.target.id == "checkBox1" then 
                ch1 = 1 - ch1
                if ch1 == 0 then 
                    if judgeDayStart == "" then
                        ch1Text.text = "V"
                        for row in database:nrows([[SELECT COUNT(*) FROM Diary WHERE Start != "" ;]]) do
                            startCount = row['COUNT(*)'] + 1
                            -- print( row['COUNT(*)'].."?????" )
                        end
                        print(startCount.."????")
                        database:exec([[UPDATE Diary SET Start = 1 WHERE date =']]..dbDate..[[';]])
                        sD = tonumber( string.sub( dbDate, 9 , 10 ) )
                        sM = tonumber( string.sub( dbDate, 6 , 7 ) )
                        sY = tonumber( string.sub( dbDate, 1 , 4 ) )
                        -- sDate = sY.."/"..sM.."/"..sD
                        sDate = sY.."/"..string.format("%02d",sM).."/"..string.format("%02d",sD)
                        for i = 1 , nextTime do 
                            -- database:exec([[UPDATE Diary SET StartDays = ']]..i..[[' WHERE date =']]..sDate..[[';]])
                            print( i..sDate..":iiii"..dbDate )
                            database:exec([[UPDATE Diary SET StartDays = ']]..i..[[' WHERE date =']]..sDate..[[';]])                            
                            statisticCount()
                            if i == nextTime-1 then
                                database:exec([[UPDATE Diary SET End = 1 WHERE date =']]..sDate..[[';]])
                            end 
                        end

                        startStatisticalDays()
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
                                ch1Text.text = ""
                                print( sDate.."sadsadsad" )
                                -- database:exec([[UPDATE Diary SET End = "" WHERE date =']]..sDate..[[';]])
                                database:exec([[UPDATE Diary SET Start = "" , StartDays = "" WHERE date =']]..dbDate..[[';]])
                                database:exec([[DELETE FROM Statistics WHERE StartDay =']]..dbDate..[[';]])
                                readDb()
                            end
                        end
                    end
                  
                    local alert = native.showAlert( "","確定刪除此筆經期資料?", { "NO" , "YES" }, onCompleteee )
                    
                end
            elseif e.target.id == "checkBox2" then 
                ch2 = 1 - ch2
                if ch2 == 0 then 
                    print(judgeDayEnd.."PPPPPPPP" )
                    if judgeDayEnd == "" then
                        ch2Text.text = "V"
                        -- database:exec([[UPDATE Diary SET End = 1 WHERE date =']]..dbDate..[[';]])
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
    end

    checkBox1 = widget.newButton({ 
        x = X*1.4,
        y = Y*0.6,
        id = "checkBox1",
        label = "",
        fontSize = H*0.025 ,
        shape = "rect",
        width = W*0.1 ,
        height = H*0.05 ,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = checkBoxBtnEvent 
    })

    checkBox2 = widget.newButton({ 
        x = X*1.4,
        y = Y*0.8,
        id = "checkBox2",
        label = "",
        fontSize = H*0.025 ,
        shape = "rect",
        width = W*0.1 ,
        height = H*0.05 ,
        radius = 30 ,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = checkBoxBtnEvent 
    })

    ch1Text = display.newText( textGroup , "" , X*1.4 , Y*0.6, font , H*0.045 )
    ch2Text = display.newText( textGroup , "" , X*1.4 , Y*0.8, font , H*0.045 )

    sceneGroup:insert(checkBox1)
    sceneGroup:insert(checkBox2)

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

    if continuRows > 1 then 

        for row in database:nrows([[SELECT * FROM Statistics ORDER BY StartDay ASC ;]]) do
            continuNum = continuNum + 1 
            continuTable[continuNum] = row.StartDay 
        end

        for i = 1 , continuRows-1 do 
            local s = os.date(os.time({year = string.sub( continuTable[i] , 1 , 4 ), month = string.sub( continuTable[i] , 6 , 7) , day = string.sub( continuTable[i] , 9 , 10)}))
            local e = os.date(os.time({year = string.sub( continuTable[i+1] , 1 , 4 ), month = string.sub( continuTable[i+1] , 6 , 7) , day = string.sub( continuTable[i+1] , 9 , 10)}))
            local n = (24*60*60)
            local d = (e-s)/n
            print( d.."qq"..i )
            -- print( continuTable[i] )
            database:exec([[UPDATE Statistics SET Padding = ']]..d..[[' WHERE StartDay =']]..continuTable[i+1]..[[';]])
        end
    end

    database:exec([[UPDATE Statistics SET Padding = 0 WHERE StartDay =']]..continuTable[1]..[[';]])


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
        print( eDay.."eeeeeeeeeeeeee" )
    end 

    local e = os.date(os.time{year=string.sub(eDay , 1 , 4) ,month=string.sub(eDay , 6 , 7),day=string.sub(eDay , 9 , 10)})
    local s = os.date(os.time{year=string.sub(sDay , 1 , 4) ,month=string.sub(sDay , 6 , 7),day=string.sub(sDay , 9 , 10)})

    days = (tonumber(e-s)/24/60/60+1) 

    sD = tonumber( string.sub( sDay, 9 , 10 ) )
    sM = tonumber( string.sub( sDay, 6 , 7 ) )
    sY = tonumber( string.sub( sDay, 1 , 4 ) )
    sDate = sY.."/"..sM.."/"..sD
    print( days.."dddddddddddd" )
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
