-----------------------------------------------------------------------------------------
--
-- leaveMessage.lua
--
-----------------------------------------------------------------------------------------

local sqlite3 = require "sqlite3"
local path = system.pathForFile("data.db", system.DocumentsDirectory)
local database = sqlite3.open( path )
local scene = composer.newScene()
local date = os.date( "*t" ) 
local init 
local sceneGroup
local cc
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
local dbDate = tostring(c..y.."/"..string.format("%02d",m).."/"..string.format("%02d",d))
local dateText1
local dateText2
local week = ""
local daysTable = { 31 ,28 ,31 ,30 ,31 ,30 ,31 ,31 ,30 ,31 ,30 ,31 ,31 ,28}
local judgeWeek 
local mNum = m
local yNum = y
local leftLeapYear
local rightLeapYear
local backButtonEvent
local setBtn
local setBtnEvent
local text1
local text2
local text3
local text4 
local text5
local text6
local closeText 
local temperatureText
local weightText
local noticText
local BMIText 
local readDb 
local checkDb 
local writeDb
local title
local backBtn
local statisticalDays 
local statusText
composer.setVariable( "prevScene", "daily_calendar" )

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    title = display.newText( _parent, "日曆", X, Y*0.15, font , H*0.05 )

    text1 = display.newText( _parent , "本日狀況", X, Y*0.6 , font , H*0.037 )
    
    text2 = display.newText( _parent , "親密行為", X*0.3, Y*0.8 , font , H*0.03 )
    text2.anchorX = 0 
    text3 = display.newText( _parent , "基礎體溫", X*0.3, Y*1 , font , H*0.03 )
    text3.anchorX = 0 
    text4 = display.newText( _parent , "體重", X*0.3, Y*1.2 , font , H*0.03 )
    text4.anchorX = 0 
    text5 = display.newText( _parent , "BMI", X*0.3, Y*1.4 , font , H*0.03 )
    text5.anchorX = 0 
    text6 = display.newText( _parent , "Notes", X*0.3, Y*1.6 , font , H*0.03 )
    text6.anchorX = 0 
    closeText = display.newText( _parent , "尚無紀錄", X*0.8, Y*0.8 , font , H*0.025 )
    closeText.anchorX = 0
    temperatureText = display.newText( _parent , "尚無紀錄", X*0.8, Y*1 , font , H*0.025 )
    temperatureText.anchorX = 0
    weightText = display.newText( _parent , "尚無紀錄", X*0.6, Y*1.2 , font , H*0.025 )
    weightText.anchorX = 0
    BMIText = display.newText( _parent , "請至設定頁設定身高", X*0.6, Y*1.4 , font , H*0.025 )
    BMIText.anchorX = 0
    noticText = display.newText( _parent , "尚無紀錄", X*0.7, Y*1.6 , font , H*0.025 )
    noticText.anchorX = 0

    statusText = display.newText( _parent , "今天是安全期", X, Y*0.7 , font , H*0.028 )
    statusText:setFillColor( 0.88 , 0.33 , 0.342 )

    judgeWeek()
    dateText1 = display.newText( _parent, m.."/"..d , X , Y*0.3 , font , H*0.05 )
    dateText2 = display.newText( _parent, c..y.."  "..week , X, Y*0.4, font , H*0.025 )
    if m == 1 then 
        m = 13
        y = y - 1
    elseif m == 2 then 
        m = 14 
        y = y - 1
    end

    leftBtn = widget.newButton({ 
        x = X*0.1,
        y = Y*0.3,
        id = "leftBtn",
        label = "<",
        fontSize = H*0.037 ,
        shape = "circle",
        radius = H*0.04 ,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = handleButtonEvent 
    })

    rightBtn = widget.newButton({ 
        x = X*1.9,
        y = Y*0.3,
        id = "rightBtn",
        label = ">",
        fontSize = H*0.037 ,
        shape = "circle",
        radius =  H*0.04 ,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = handleButtonEvent 
    })

    _parent:insert(leftBtn)
    _parent:insert(rightBtn)
    -- _parent:insert(year)
    -- _parent:insert(month)
    -- _parent:insert(day)

    -- y = 17
    -- c = 20
    -- m = 11
    -- d = 30
    -- w = math.fmod( ( y + math.modf(y/4) + math.modf(c/4) - 2*c +  math.modf(26*(m+1)/10) + d - 1 ) , 7 )
    -- print( "星期:"..w )
    -- print( yText..mText..dText )

    -- print( os.date( "%c" ).."c" )
    -- print( os.date( "%d" ).."d" )
    -- print( os.date( "%w" ).."w" )
    -- print( os.date( "%Y" ).."y" )
    -- print( os.date( "%m" ).."m" )
    backToday()
    setBtn()
    readDb()
    -- statisticalDays()

    --  for row in database:nrows([[SELECT * FROM Diary WHERE id = 2 ]]) do
    --     a2 = row.Date
    --     print( type(row.Date)..row.Date)
    -- end

    --    for row in database:nrows([[SELECT * FROM Diary WHERE id = 5 ]]) do
    --     a5 = row.Date
    --     print( type(row.Date)..row.Date)
    -- end

    -- print(a2 == a5)
end


textListener = function( event )
    if ( event.phase == "began" ) then
     
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
    
    elseif ( event.phase == "editing" ) then
        if event.target.id == "year" then
            yText = event.text 
        elseif event.target.id == "month" then
            mText = event.text 
        elseif event.target.id == "day" then
            dText = event.text 
        end
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

            dateText1.text = mNum.."/"..d
            dateText2.text = c..yNum.."  "..week
            dbDate = c..yNum.."/"..string.format("%02d" ,mNum ).."/"..string.format("%02d" ,d )
            checkDb()
            readDb()
            print( dbDate..":dddd" )
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

            dateText1.text = mNum.."/"..d
            dateText2.text = c..yNum.."  "..week
            dbDate = c..yNum.."/"..string.format("%02d" ,mNum ).."/"..string.format("%02d" ,d )
            checkDb()
            readDb()
            print( dbDate..":dddddd" )
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

backToday = function (  )
    backButtonEvent = function ( e )
        if ( "ended" == e.phase ) then
            c = tonumber(string.sub( os.date( "%Y" ) , 1 , 2 ))
            y = tonumber(string.sub( os.date( "%Y" ) , 3 , 4 ))
            m = tonumber(os.date( "%m" ))
            d = tonumber(os.date( "%d" ))
            -- w = tonumber(os.date( "%w" )) 
            judgeWeek()
            dateText1.text = m.."/"..d 
            dateText2.text = c..y.."  "..week
            if m == 1 then 
                m = 13
                y = y - 1
            elseif m == 2 then 
                m = 14 
                y = y - 1
            end
        end
    end

    backBtn = widget.newButton({ 
        x = X*0.2,
        y = Y*0.15,
        id = "backBtn",
        label = "回今天",
        fontSize = H*0.032 ,
        shape = "circle",
        radius = H*0.032 ,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = backButtonEvent 
    })

    sceneGroup:insert(backBtn)
end

setBtn = function (  )
    setBtnEvent = function ( e )
        if ( "ended" == e.phase ) then
            if e.target.id == "disclaimer" then 
                composer.showOverlay( "disclaimer" )
            elseif e.target.id == "statistics" then 
                composer.showOverlay( "statistics" )
            elseif e.target.id == "setup" then 
                composer.showOverlay( "setup" )
             elseif e.target.id == "editBtn" then 
                -- composer.setVariable( "prevScene", "daily_calendar" )
    --              composer.setVariable( "mCalendarId", e.target.id )
                composer.setVariable( "mCalendarY", c..yNum )
                composer.setVariable( "mCalendarM", mNum )
                composer.setVariable( "mCalendarD", d )
                composer.showOverlay( "edit" )
            end
        end
    end

    local disclaimerBtn = widget.newButton({ 
        x = X*1.4,
        y = Y*0.15,
        id = "disclaimer",
        label = "免責",
        fontSize = H*0.028 ,
        shape = "circle",
        radius = H*0.028 ,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = setBtnEvent 
    })

    local statisticsBtn = widget.newButton({ 
        x = X*1.6,
        y = Y*0.15,
        id = "statistics",
        label = "統計",
        fontSize = H*0.028 ,
        shape = "circle",
        radius = H*0.028 ,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = setBtnEvent 
    })

    local setupBtn = widget.newButton({ 
        x = X*1.8,
        y = Y*0.15,
        id = "setup",
        label = "設定",
        fontSize = H*0.028 ,
        shape = "circle",
        radius = H*0.028 ,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = setBtnEvent 
    })

    local editBtn = widget.newButton({ 
        x = X*1.5,
        y = Y*0.6,
        id = "editBtn",
        label = "編輯",
        fontSize = H*0.028 ,
        shape = "circle",
        radius = H*0.028 ,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = setBtnEvent 
    })

    sceneGroup:insert(disclaimerBtn)
    sceneGroup:insert(statisticsBtn)
    sceneGroup:insert(setupBtn)
    sceneGroup:insert(editBtn)

end

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
        if rows < 1 then 
            writeDb()
        end
    end

    print("rrrr:"..rows)
end

readDb = function (  )
    for row in database:nrows([[SELECT * FROM Diary WHERE Date = ']]..dbDate..[[']]) do
        closeText.text = row.Close 
        temperatureText.text = row.Temperature
        weightText.text = row.Weight
        noticText.text = row.Notes
        statusNum = row.StartDays
        print(statusNum.."statusNum")
    end

    if closeText.text == "" then 
        closeText.text = "尚無紀錄"
    end

    if temperatureText.text == "" then 
        temperatureText.text = "尚無紀錄"
    end

    if weightText.text == "" then
        weightText.text = "尚無紀錄"
    end

    if noticText.text == "" then
        noticText.text = "尚無紀錄"
    end

    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1]]) do
        if row.Height == "" then
            BMIText.text = "請至設定頁設定身高"
        elseif row.Height ~= "" then
            if weightText.text ~= "尚無紀錄" then
                BMIText.text =  string.sub (string.sub( weightText.text, 1,4 ) /(row.Height / 100 )^2 , 1 , 4 )
            else
                BMIText.text = "請輸入體重"
            end
        end
    end

    if statusNum ~= "" then
        statusText.text = "今天是月經期"

    elseif statusNum == "" or statusNum == nil then
        statusText.text = "今天是安全期"
    end
end

statisticalDays = function (  )
    for row in database:nrows([[SELECT * FROM Diary WHERE Start = 1]]) do
        -- print(row.Date.."aaaaaaaaa")
    end

    for row in database:nrows([[SELECT * FROM Diary WHERE End = 1]]) do
        -- print(row.Date.."bbbbbbbbbbbb")
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
