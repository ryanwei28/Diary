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
local todayNum = c..y.."/"..m.."/"..d
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
local readDb 
local checkDb 
local writeDb
local title
local judge1stWeek 
local firstW
local mCalendarTable = {}
local creatMonthlyCalendar 
local mGroup
local wd
local listener
local backBtn2
local readMonthDb
composer.setVariable( "prevScene", "monthly_calendar" )
-- ❤▲◯
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    title = display.newText( _parent, "月曆", X, Y*0.15, font , 50 )

    judgeWeek()
    judge1stWeek()
    dateText1 = display.newText( _parent, c..y.." 年 "..m.." 月" , X , Y*0.3 , font , 50 )
    wd = display.newText( _parent, "SUN   MON   TUE   WED   THU   FRI   SAT", X, Y*0.5 , font , 25 )
    -- dateText2 = display.newText( _parent, c..y.."  "..week , X, Y*0.4, font , 30 )
    if m == 1 then 
        m = 13
        y = y - 1
    elseif m == 2 then 
        m = 14 
        y = y - 1
    end
--=======================================================================================================
    readMonthDb()
    creatMonthlyCalendar()

--========================================================================================================


    leftBtn = widget.newButton({ 
        x = X*0.4,
        y = Y*0.3,
        id = "leftBtn",
        label = "<",
        fontSize = 30 ,
        shape = "circle",
        radius = 30 ,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = handleButtonEvent 
    })

    rightBtn = widget.newButton({ 
        x = X*1.6,
        y = Y*0.3,
        id = "rightBtn",
        label = ">",
        fontSize = 30 ,
        shape = "circle",
        radius = 30 ,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = handleButtonEvent 
    })

    _parent:insert(leftBtn)
    _parent:insert(rightBtn)

    backToday()
    setBtn()
    -- readDb()
    
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

            print( daysTable[14] )
            -- d = d - 1
            -- if d < 1 then 
            --     m = m - 1
            --     if m < 3 then
            --         m = 14
            --         y = y - 1 
            --     end
            --     d = daysTable[m]
                
            -- end

            -- judgeWeek()
            m = m - 1

            if m < 3 then
                m = 14
                y = y - 1 
            end
            
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

            dateText1.text = c..yNum.." 年 "..mNum.." 月"
            -- dateText2.text = c..yNum.."  "..week
            dbDate = c..yNum.."/"..string.format("%02d" ,mNum ).."/"..string.format("%02d" ,d )
            checkDb()
            -- readDb()
            print( dbDate..":dddd" )
            judge1stWeek()
            print( daysTable[m]..":mDays" )
            print( firstW..":firstW" )
            mGroup:removeSelf( )
            readMonthDb()
            creatMonthlyCalendar()
            

        elseif e.target.id == "rightBtn" then 
            rightLeapYear()
            print( daysTable[14] )
            -- d = d + 1 
            -- if d > daysTable[m] then 
            --     d = 1 
            --     print( daysTable[m] )
            --     m = m + 1 
            --     if m > 14 then 
            --         m = 3 
            --         y = y + 1 
            --     end
            -- end

            judgeWeek()

            m = m + 1 
            
            if m > 14 then 
                m = 3 
                y = y + 1 
            end

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

            dateText1.text = c..yNum.." 年 "..mNum.." 月"
            dbDate = c..yNum.."/"..string.format("%02d" ,mNum ).."/"..string.format("%02d" ,d )
            -- dbDate = tostring(c..yNum.."/"..mNum.."/"..d)
            checkDb()
            -- readDb()
            print( dbDate..":dddddd" )
            judge1stWeek()
            print( daysTable[m]..":mDays" )
            print( firstW..":firstW" )
            mGroup:removeSelf( )
            readMonthDb()
            creatMonthlyCalendar()

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

    print(c..y..m..d..w)
end
    
judge1stWeek = function (  )
    firstW = math.fmod( ( y + math.modf(y/4) + math.modf(c/4) - 2*c +  math.modf(26*(m+1)/10) + 1 - 1 ) + 7 , 7 )

    if firstW == 0 then
        firstW = 7
    end
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
            mGroup:removeSelf( )
            
            c = tonumber(string.sub( os.date( "%Y" ) , 1 , 2 ))
            y = tonumber(string.sub( os.date( "%Y" ) , 3 , 4 ))
            m = tonumber(os.date( "%m" ))
            d = tonumber(os.date( "%d" ))
            -- w = tonumber(os.date( "%w" )) 
            yNum = y 
            mNum = m

            if m == 1 then 
                m = 13
                y = y - 1
            elseif m == 2 then 
                m = 14 
                y = y - 1
            end

            judgeWeek()
            judge1stWeek()
            -- dateText1.text =  c..y.." 年 "..m.." 月"
            dateText1.text = c..yNum.." 年 "..mNum.." 月"
            dbDate = tostring(c..yNum.."/"..string.format("%02d",mNum).."/"..string.format("%02d",d))
            -- dateText2.text = c..y.."  "..week
            

            creatMonthlyCalendar()
        end
    end

    backBtn2 = widget.newButton({ 
        x = X*0.2,
        y = Y*0.15,
        id = "backBtn",
        label = "回今天",
        fontSize = 40 ,
        shape = "circle",
        radius = 30 ,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = backButtonEvent 
    })

    sceneGroup:insert(backBtn2)
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
                composer.showOverlay( "edit" )
            end
        end
    end

    local disclaimerBtn = widget.newButton({ 
        x = X*1.4,
        y = Y*0.15,
        id = "disclaimer",
        label = "免責",
        fontSize = 30 ,
        shape = "circle",
        radius = 30 ,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = setBtnEvent 
    })

    local statisticsBtn = widget.newButton({ 
        x = X*1.6,
        y = Y*0.15,
        id = "statistics",
        label = "統計",
        fontSize = 30 ,
        shape = "circle",
        radius = 30 ,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = setBtnEvent 
    })

    local setupBtn = widget.newButton({ 
        x = X*1.8,
        y = Y*0.15,
        id = "setup",
        label = "設定",
        fontSize = 30 ,
        shape = "circle",
        radius = 30 ,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = setBtnEvent 
    })

    -- local editBtn = widget.newButton({ 
    --     x = X*1.5,
    --     y = Y*0.6,
    --     id = "editBtn",
    --     label = "編輯",
    --     fontSize = 30 ,
    --     shape = "circle",
    --     radius = 30 ,
    --     fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
    --     onEvent = setBtnEvent 
    -- })

    sceneGroup:insert(disclaimerBtn)
    sceneGroup:insert(statisticsBtn)
    sceneGroup:insert(setupBtn)
    -- sceneGroup:insert(editBtn)

end

writeDb = function (  )
    for i = 1 , daysTable[m] do 
        local tablesetup =  [[
                            INSERT INTO Diary VALUES ( NULL , ']]..c..yNum.."/"..string.format("%02d",mNum).."/"..string.format("%02d",i)..[[' , "" , "" , "" , "" , "" , "" , "");
                        ]]
                        -- CREATE TABLE IF NOT EXISTS Diary ( id INTEGER PRIMARY KEY , Data , Start , End , Close , Temperature , Weight , Notes);
        database:exec(tablesetup)
    end
end

checkDb = function (  )
    for row in database:nrows([[SELECT COUNT(*) FROM Diary WHERE Date = ']]..dbDate..[[']]) do
        rows = row['COUNT(*)']
    end

    if rows < 1 then 
        writeDb()
    end
    print("rrrr:"..rows)
end

readDb = function (  )
    for row in database:nrows([[SELECT * FROM Diary WHERE Date = ']]..dbDate..[[']]) do
        -- closeText.text = row.Close 
        -- temperatureText.text = row.Temperature
        -- weightText.text = row.Weight
    end

    -- if closeText.text == "" then 
    --     closeText.text = "尚無紀錄"
    -- end

    -- if temperatureText.text == "" then 
    --     temperatureText.text = "尚無紀錄"
    -- end

    -- if weightText.text == "" then
    --     weightText.text = "尚無紀錄"
    -- end
end

creatMonthlyCalendar = function (  )
    mGroup = display.newGroup( )
    sceneGroup:insert(mGroup)
    for i = 1 , 5 do 
        for j = 1 , 7 do 
            k = i*7+j-7 
            if k <= daysTable[m] then 
                if (firstW + j -1 ) <= 6 then
                    mCalendarTable[i*7+j-7] = display.newText( mGroup, i*7+j-7 , X*0.27 + (firstW + j  ) * 72, 300+ i * 100, font , 40 )
                    mCalendarTable[i*7+j-7].id = c..yNum.."/"..string.format("%02d",mNum) .."/"..string.format("%02d",i*7+j-7)
                    mCalendarTable[i*7+j-7].day = i*7+j-7
                    mCalendarTable[i*7+j-7]:addEventListener( "tap", listener )
                    if mCalendarTable[i*7+j-7].id == todayNum then
                        mCalendarTable[i*7+j-7]:setFillColor( 1,0,0 )
                        mCalendarTable[i*7+j-7].size = 50
                    end

                    for row in database:nrows([[SELECT * FROM Diary WHERE Date = ']]..mCalendarTable[i*7+j-7].id..[[' ]]) do
                        if row.Close ~= "" then
                            local cc = display.newText( mGroup, "❤" , X*0.24 + (firstW + j  ) * 72, 290+ i * 100, font , 30 )
                            cc:setFillColor( 0.9 , 0.1 , 0.1 )
                        end

                        if row.Temperature ~= "" then
                            local dd = display.newText( mGroup, "◯" , X*0.3 + (firstW + j  ) * 72, 290+ i * 100, font , 30 )
                            dd:setFillColor( 0.1 , 0.851 , 0.21 )
                        end

                        if row.Weight ~= "" then
                            local ee = display.newText( mGroup, "▲" , X*0.24 + (firstW + j  ) * 72, 310+ i * 100, font , 30 )
                            ee:setFillColor( 0.15 , 0.12 , 0.91 )
                        end
                    end
                end

                if (firstW + j -1 ) > 6 then
                    mCalendarTable[i*7+j-7] = display.newText( mGroup, i*7+j-7 , X*0.27 + -X*1.35 + (firstW + j  ) * 72, 300+ (i + 1) * 100, font , 40 )
                    mCalendarTable[i*7+j-7].id = c..yNum.."/"..string.format("%02d", mNum) .."/"..string.format("%02d",i*7+j-7)
                    mCalendarTable[i*7+j-7].day = i*7+j-7
                    mCalendarTable[i*7+j-7]:addEventListener( "tap", listener )

                    if mCalendarTable[i*7+j-7].id == todayNum then
                        mCalendarTable[i*7+j-7]:setFillColor( 1,0,0 )
                        mCalendarTable[i*7+j-7].size = 50
                    end

                    for row in database:nrows([[SELECT * FROM Diary WHERE Date = ']]..mCalendarTable[i*7+j-7].id..[[' ]]) do
                        if row.Close ~= "" then
                            local cc = display.newText( mGroup, "❤" , X*0.24 + (firstW + j  ) * 72 -X*1.35, 290 + (i + 1) * 100, font , 30 )
                            cc:setFillColor( 0.9 , 0.1 , 0.1 )
                        end

                        if row.Temperature ~= "" then
                            local dd = display.newText( mGroup, "◯" , X*0.3 + (firstW + j  ) * 72-X*1.35, 290 + (i + 1) * 100, font , 30 )
                            dd:setFillColor( 0.1 , 0.851 , 0.21 )
                        end

                        if row.Weight ~= "" then
                            local ee = display.newText( mGroup, "▲" , X*0.24 + (firstW + j  ) * 72-X*1.35, 310+ i * 100, font , 30 )
                            ee:setFillColor( 0.15 , 0.12 , 0.91 )
                        end
                    end
                end 
            end
        end
    end
    -- print( mCalendarTable[25].text..":yeeeeeeee" )
end

listener = function ( e )
    print( e.target.id )
    composer.setVariable( "mCalendarId", e.target.id )
    composer.setVariable( "mCalendarY", c..yNum )
    composer.setVariable( "mCalendarM", mNum )
    composer.setVariable( "mCalendarD", e.target.day )
    -- composer.setVariable( "prevScene", "monthly_calendar" )
    composer.showOverlay( "edit" )
end

readMonthDb = function (  )
    for row in database:nrows([[SELECT * FROM Diary ]]) do
        if string.sub( row.Date, 1 , 7 ) == string.sub( dbDate, 1 , 7 ) then
            print(row.Date)
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
