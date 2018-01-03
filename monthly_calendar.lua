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
local periodTable = {}
local periodTable1 = {}
local periodTable2 = {}
local periodTable3 = {}
local periodTable4 = {}
local whiteRectTable = {}
local creatMonthlyCalendar 
local mGroup
local wd
local listener
local backBtn2
local readMonthDb
local fourSqrare
local duringDays = 0
local duringNum = 0
local paddingNum = 0 
local paddingDays = 0
local last
local frontGroup = display.newGroup( )
local backGroup = display.newGroup( )
local blackTitle
local bg1
local bg2
local removeListener 
local removeSw = true
local redRect 
local readOvulation 
local predictDay 
local avgDays
local continuance
local topBg
local bottomBg
local legend 
local todayRect 
local sunmon
local sceneGroupListener 
local start1month 
-- local bg1Listener
-- local bg 
-- local titleBg
composer.setVariable( "prevScene", "monthly_calendar" )
-- ❤▲◯
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    
    -- bg = display.newRect( _parent, X, Y*1.07, W, H )
    -- bg:setFillColor( 127/255, 215/255, 210/255 )
    -- bg.x , bg.y = X , Y*1.07
    bg1 = display.newRect( _parent, X , Y*0.27 , W, H*0.15 )
    bg1:setFillColor(145/255,215/255,215/255)
    -- bg1:addEventListener( "touch", bg1Listener )
    -- bg1.x , bg1.y = X , Y*0.35

    bg2 = display.newRect( _parent, X , Y*1.487 , W, H*0.15 )
    bg2:setFillColor(145/255,215/255,215/255)

    topBg = display.newImageRect( sceneGroup, "images/bg_white_top@3x.png" , W , H*0.0135 )
    topBg.x , topBg.y = X , H*0.2031

    bottomBg = display.newImageRect( sceneGroup, "images/bg_white_bottom@3x.png" , W , H*0.0135 )
    bottomBg.x , bottomBg.y = X , H*0.675

    legend = display.newImageRect( sceneGroup, "images/legend@3x.png", W*0.781, H*0.021)
    legend.x , legend.y = X , Y*1.415
    -- titleBg = display.newImageRect( _parent, "images/bg_top@3x.png", W, H*0.07 )
    -- titleBg.x , titleBg.y ,titleBg.anchorY= X, Y*0.07 , 0
    -- title = display.newText( _parent, "月曆", X, Y*0.14, bold , H*0.032 )
    blackTitle = display.newRect( _parent, X, Y*0.07, W, H*0.07 )
    blackTitle.anchorY = 1
    blackTitle:setFillColor( 0 )

    T.title("月曆" , frontGroup)

    judgeWeek()
    judge1stWeek()
    dateText1 = display.newText( _parent, c..y.." 年 "..m.." 月" , X , Y*0.28 , bold ,  H*0.029 )
    dateText1:setFillColor( 226/255,68/255,61/255 )
    sunmon = display.newImageRect( _parent, "images/week@3x.png", W*1.03,  H*0.015 )
    sunmon.x , sunmon.y = X , H*0.183
    -- wd = display.newText( _parent, "SUN           MON           TUE           WED           THU           FRI           SAT", X, H*0.183 , bold , H*0.015 )
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
        x = X*0.5,
        y = Y*0.275,
        id = "leftBtn",
        -- label = "<",
        -- fontSize = H*0.028 ,
        -- shape = "circle",
        -- radius = H*0.028 ,
        -- fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        width = H*0.033 , 
        height = H*0.033 , 
        defaultFile = "images/btn_prev_r_press@3x.png" , 
        onEvent = handleButtonEvent 
    })

    rightBtn = widget.newButton({ 
        x = X*1.5,
        y = Y*0.275,
        id = "rightBtn",
        -- label = ">",
        -- fontSize = H*0.028 ,
        -- shape = "circle",
        -- radius = H*0.028 ,
        -- fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        width = H*0.033 , 
        height = H*0.033 , 
        defaultFile = "images/btn_next_r_press@3x.png" , 
        onEvent = handleButtonEvent 
    })

    _parent:insert(leftBtn)
    _parent:insert(rightBtn)

    backToday()
    setBtn()
    -- readDb()
    fourSqrare()


    readOvulation()

    sceneGroup:addEventListener("touch" , sceneGroupListener )

    -- backToday()
    start1month()
end

start1month = function (  )
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


sceneGroupListener = function ( e )
    if e.phase == "began" then 
        sx = e.x 
    elseif e.phase == "moved" then 
        ex = e.x 
    elseif e.phase == "ended" then
        if ex then
            if sx > ex + 20 then 
                display.getCurrentStage():setFocus( e.target )
                 if removeSw == true  then
                    removeListener()
                end

                removeSw = false
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
                mGroup.y = mGroup.y - H*0.2
                transition.to( mGroup, {time = 150 , y = H*0.005 , onComplete = function (  )
                    mGroup:removeSelf( )
                    readMonthDb()

                    creatMonthlyCalendar()
                    removeSw = true
                    display.getCurrentStage():setFocus( nil )
                end} )
                -- mGroup:removeSelf( )
                -- readMonthDb()
                -- creatMonthlyCalendar()
                
            elseif sx < ex - 20 then 
                display.getCurrentStage():setFocus( e.target )
                 if removeSw == true  then
                    removeListener()
                end

                removeSw = false
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
                mGroup.y = mGroup.y + H*0.2
                transition.to( mGroup, {time = 150 , y = -H*0.0005 , onComplete = function (  )
                    mGroup:removeSelf( )
                    readMonthDb()

                    creatMonthlyCalendar()
                    removeSw = true
                    display.getCurrentStage():setFocus( nil )
                end} )
                -- mGroup:removeSelf( )
                -- readMonthDb()

                -- creatMonthlyCalendar()
            end

            sx , ex = nil ,nil
        end
    end
end

handleButtonEvent = function ( e )
    if ( "ended" == e.phase ) then
        display.getCurrentStage():setFocus( e.target )
        if e.target.id == "leftBtn" then 
            if removeSw == true  then
                removeListener()
            end

            removeSw = false
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
            mGroup.y = mGroup.y - H*0.2
            transition.to( mGroup, {time = 150 , y = H*0.005 , onComplete = function (  )
                mGroup:removeSelf( )
                readMonthDb()

                creatMonthlyCalendar()
                removeSw = true
                display.getCurrentStage():setFocus( nil )
            end} )
            -- mGroup:removeSelf( )
            -- readMonthDb()
            -- creatMonthlyCalendar()
            

        elseif e.target.id == "rightBtn" then 
            if removeSw == true  then
                removeListener()
            end

            removeSw = false
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
            mGroup.y = mGroup.y + H*0.2
            transition.to( mGroup, {time = 150 , y = -H*0.0005 , onComplete = function (  )
                mGroup:removeSelf( )
                readMonthDb()

                creatMonthlyCalendar()
                removeSw = true
                display.getCurrentStage():setFocus( nil )
            end} )
            -- mGroup:removeSelf( )
            -- readMonthDb()

            -- creatMonthlyCalendar()

        end
    end

    return true 
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

    -- backBtn2 = widget.newButton({ 
    --     x = X*0.2,
    --     y = Y*0.15,
    --     id = "backBtn",
    --     label = "回今天",
    --     fontSize = H*0.035 ,
    --     shape = "circle",
    --     radius = H*0.028 ,
    --     fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
    --     onEvent = backButtonEvent 
    -- })

    backBtn2 = widget.newButton({ 
        x = X*0.2,
        y = Y*0.13,
        id = "backBtn",
        width = W*0.15,
        height = H*0.039,
        -- label = "回今天",
        -- fontSize = H*0.032 ,
        -- shape = "circle",
        -- radius = H*0.032 ,
        -- fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        defaultFile = "images/nav_today@3x.png" , 
        overFile = "images/nav_today_press@3x.png" , 
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
        x = X*1.45,
        y = Y*0.135,
        id = "disclaimer",
        -- label = "免責",
        -- fontSize = H*0.028 ,
        -- shape = "circle",
        -- radius = H*0.028 ,
        -- fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        width = W*0.064, 
        height = H*0.036, 
        defaultFile = "images/nav_info@3x.png" ,
        overFile = "images/nav_info_press@3x.png" , 
        onEvent = setBtnEvent 
    })

    local statisticsBtn = widget.newButton({ 
        x = X*1.65,
        y = Y*0.135,
        id = "statistics",
        -- label = "統計",
        -- fontSize = H*0.028 ,
        -- shape = "circle",
        -- radius = H*0.028 ,
        -- fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        width = W*0.064, 
        height = H*0.036, 
        defaultFile = "images/nav_chart@3x.png" ,
        overFile = "images/nav_chart_press@3x.png" , 
        onEvent = setBtnEvent 
    })

    local setupBtn = widget.newButton({ 
        x = X*1.85,
        y = Y*0.135,
        id = "setup",
        -- label = "設定",
        -- fontSize = H*0.028 ,
        -- shape = "circle",
        -- radius = H*0.028 ,
        -- fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        width = W*0.064, 
        height = H*0.036, 
        defaultFile = "images/nav_setting@3x.png" ,
        overFile = "images/nav_setting_press@3x.png" , 
        onEvent = setBtnEvent 
    })

    sceneGroup:insert(disclaimerBtn)
    sceneGroup:insert(statisticsBtn)
    sceneGroup:insert(setupBtn)
end

bg1Listener = function ( e )
    if e.phase == "began" then
        display.getCurrentStage():setFocus( e.target )
    elseif e.phase == "ended" then
        display.getCurrentStage():setFocus(nil)
    end

    return true
end

fourSqrare = function (  )
   square1 = display.newRect( sceneGroup, X*0.25, H*0.866, W*0.25, H*0.12 )
    square1:setFillColor( 254/255,187/255,108/255 )
    square2 = display.newRect( sceneGroup, X*0.75, H*0.866, W*0.25, H*0.12 )
    square2:setFillColor( 140/255,200/255,100/255 )
    square3 = display.newRect( sceneGroup, X*1.25, H*0.866, W*0.25, H*0.12 )
    square3:setFillColor( 145/255,215/255,215/255 )
    square4 = display.newRect( sceneGroup, X*1.75, H*0.866, W*0.25, H*0.12 )
    square4:setFillColor( 254/255,118/255,118/255 )

    tText1 = display.newText( sceneGroup, "上次月經開始", square1.x , Y*1.82 , bold , H*0.018 )
    tText2 = display.newText( sceneGroup, "下次月經預測", square2.x , Y*1.82 , bold , H*0.018 )
    tText3 = display.newText( sceneGroup, "平均週期", square3.x , Y*1.82 , bold , H*0.018 )
    tText4 = display.newText( sceneGroup, "平均天數", square4.x , Y*1.82 , bold , H*0.018 )
    sText1 = display.newText( sceneGroup, "", square1.x , Y*1.75 , bold , H*0.036 )
    sText1Year = display.newText( sceneGroup, "", square1.x , Y*1.66 , bold , H*0.02 )
    sText2 = display.newText( sceneGroup, "", square2.x , Y*1.75 , bold , H*0.036 )
    sText2Year = display.newText( sceneGroup, "", square2.x , Y*1.66 , bold , H*0.02 )
    sText3 = display.newText( sceneGroup, "", square3.x , Y*1.75 , bold , H*0.051 )
    sText3Day = display.newText( sceneGroup, "天", square3.x + X*0.16 , Y*1.75 , bold , H*0.02 )
    sText4 = display.newText( sceneGroup, "", square4.x , Y*1.75 , bold , H*0.051)
    sText4Day = display.newText( sceneGroup, "天", square4.x + X*0.13 , Y*1.75 , bold , H*0.02 )
    
    for row in database:nrows([[SELECT * FROM Statistics ORDER BY StartDay ASC ;]]) do
        last = row.StartDay
    end

    if last then
        sText1.text = string.sub( last , -5 , -1 ) 
        sText1Year.text = string.sub( last , 1 , 4 ) 
        -- local e = os.date(os.time{year=string.sub(endTable[i] , 1 , 4) ,month=string.sub(endTable[i] , 6 , 7),day=string.sub(endTable[i] , 9 , 10)})

        local s = os.date(os.time({year = string.sub( last , 1 , 4 ), month = string.sub( last , 6 , 7) , day = string.sub( last , 9 , 10)}))
        local d = 30
        for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
            d = row.Cycle
        end
        local n = (24*60*60)
        local e = s + (d)*n

        sText2Year.text = os.date("%Y",e)
        sText2.text = os.date("%m",e).."/"..os.date("%d",e)
        -- predictDay = os.date("%Y",e).."/"..os.date("%m",e).."/"..os.date("%d",e)

         for row in database:nrows([[SELECT * FROM Statistics ;]]) do
            if row.Padding ~= "" then
                paddingDays = paddingDays + tonumber(row.Padding)
                paddingNum = paddingNum + 1
            end
        end

        for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
            sText3.text = row.Cycle
        end

        if paddingNum > 1 and type(paddingDays) == "number" then
            sText3.text = string.format("%d" , paddingDays/(paddingNum-1) )
        end 

        for row in database:nrows([[SELECT * FROM Statistics ;]]) do
            duringDays = duringDays + row.Continuance
            duringNum = duringNum + 1
        end

        sText4.text = string.format("%d" , duringDays/duringNum )
        -- avgDays = tonumber( string.format("%d" , duringDays/duringNum ) )
    end
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
                                    INSERT INTO Diary VALUES ( NULL , ']]..c..yNum.."/"..string.format("%02d",mNum) .."/"..string.format("%02d",i)..[[' , "" , "" , "" , "" , "" , "","" , "");
                                ]]
                                -- CREATE TABLE IF NOT EXISTS Diary ( id INTEGER PRIMARY KEY , Data , Start , End , Close , Temperature , Weight , Notes);
                database:exec(tablesetup)
            else

            end
        end
    else
        for i = 1 , daysTable[m] do 
            local uu 
            local uuDate = c..yNum.."/"..string.format("%02d",mNum) .."/"..string.format("%02d",i) 

            for row in database:nrows([[SELECT COUNT(*) FROM Diary WHERE date =  ']]..uuDate..[[' ; ]]) do
                uu = row['COUNT(*)']
            end

            if uu < 1 then 
                local tablesetup =  [[
                                    INSERT INTO Diary VALUES ( NULL , ']]..c..yNum.."/"..string.format("%02d",mNum) .."/"..string.format("%02d",i)..[[' , "" , "" , "" , "" , "" , "","" , "" );
                                ]]
                                -- CREATE TABLE IF NOT EXISTS Diary ( id INTEGER PRIMARY KEY , Data , Start , End , Close , Temperature , Weight , Notes);
                database:exec(tablesetup)
            end
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

readOvulation = function ( Tday )
    -- print(dbDate.."::::")
    -- print(T.caculateDays ( dbDate , "2017/11/05") )
    -- print(T.addDays(dbDate , 5 ) )
    -- print ( T.minusDays (dbDate , 6))

    local preMonth = T.minusDays( string.sub( dbDate,1,8).."01" , 30 )
    local nextMonth = T.addDays( string.sub( dbDate,1,8).."28" , 30 )

    print( preMonth )
    print( nextMonth )

     for row in database:nrows([[SELECT * FROM Statistics WHERE StartDay > ']]..preMonth..[[' AND StartDay < ']]..nextMonth..[[' ORDER BY StartDay ASC ]]) do
        -- sss = T.caculateDays( Tday , row.StartDay )
    end

    -- print( Tday.."??????" )
end

creatMonthlyCalendar = function (  )

    local mBg = display.newRect( backGroup, X, Y*0.87, W, H*0.466 ) 
    mGroup = display.newGroup( )
    
    for j = 1 , 7 do 
        local lineV = display.newLine( backGroup ,  -X*0.035+X*0.3*(j-1),  H*0.22 , -X*0.035+X*0.3*(j-1),  H*0.73 )
        lineV:setStrokeColor( 145/255, 215/255, 215/255 )
        lineV.strokeWidth = H*0.0045
    end

    backGroup:insert(mGroup)

    local s1 = c..yNum.."/"..string.format("%02d",mNum) .."/".."01"
    local mm = mNum+1 
    local yy = yNum
    if mm > 12 then 
        mm = 1 
        yy = yNum + 1
    end
    local e1 = c..yy.."/"..string.format("%02d",mm+1) .."/".."01"
    local dTable = {}
    local dNum = 0 

    -- local cW = 
    -- local cH = 
    for row in database:nrows([[SELECT * FROM Statistics WHERE StartDay >= ']]..s1..[[' AND StartDay < ']]..e1..[[' ;]]) do
        -- print(row.StartDay.."***")
        dNum = dNum + 1
        dTable[dNum] = row.StartDay
    end 
    
    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
        if row.SetSwitch == 1 then 
            avgDays = row.regularCycle
        elseif row.SetSwitch == 2 then 
            avgDays = row.Cycle
        end 
    end 

    -- print( avgDays.."++++++++++++" )

    for i = 1 , 5 do 
        for j = 1 , 7 do 
            k = i*7+j-7 
            -- display.newLine( x1, y1, x2, y2 )
            local lineH = display.newLine( mGroup , X*0, H*0.21 + i * H*0.07646, X*2,  H*0.21 + i * H*0.07646 )
            lineH:setStrokeColor(145/255, 215/255, 215/255)
            lineH.strokeWidth = H*0.0045
            -- local lineV = display.newLine( backGroup ,  -X*0.035+X*0.3*(j-1),  H*0.22 , -X*0.035+X*0.3*(j-1),  H*0.73 )
            -- lineV:setStrokeColor( 145/255, 215/255, 215/255 )
            -- lineV.strokeWidth = H*0.0045
            print(daysTable[m] .."MMMMMMMMMMMMMMMMMMMMMMM")
            if k <= daysTable[m] then 

                -- local lineH = display.newLine( mGroup , X*0, H*0.21 + i * H*0.07646, X*2,  H*0.21 + i * H*0.07646 )
                -- lineH:setStrokeColor(145/255, 215/255, 215/255)
                -- lineH.strokeWidth = H*0.0045
                -- local lineV = display.newLine( backGroup ,  -X*0.035+X*0.3*(j-1),  H*0.22 , -X*0.035+X*0.3*(j-1),  H*0.73 )
                -- lineV:setStrokeColor( 145/255, 215/255, 215/255 )
                -- lineV.strokeWidth = H*0.0045

                if (firstW + j -1 ) <= 6 then
                    -- periodTable[i*7+j-7] = display.newText( mGroup,"", -X*0.25 + (firstW + j  ) * W*0.15, H*0.25+ i * H*0.075, native.systemFontBold , H*0.032 )
                    -- periodTable[i*7+j-7]:setFillColor(0.15,0.41,0.3)

                    whiteRectTable[i*7+j-7] = display.newRect( mGroup, -X*0.185 + (firstW + j  ) * W*0.15, H*0.173 + i * H*0.0765, W*0.135 , H*0.065 )
                    -- whiteRectTable[i*7+j-7]:setFillColor( 0.5 )
                    whiteRectTable[i*7+j-7].id = c..yNum.."/"..string.format("%02d",mNum) .."/"..string.format("%02d",i*7+j-7)
                    whiteRectTable[i*7+j-7].day = i*7+j-7
                    whiteRectTable[i*7+j-7]:addEventListener( "tap", listener )


                    periodTable1[i*7+j-7] = display.newRect( mGroup , -X*0.18 + (firstW + j  ) * W*0.15, H*0.195+ i * H*0.075, W*0.155, H*0.0374 )
                    periodTable1[i*7+j-7]:setFillColor( 254/255,187/255,108/255 )
                    periodTable1[i*7+j-7].alpha = 0

                    periodTable2[i*7+j-7] = display.newRect( mGroup , -X*0.18 + (firstW + j  ) * W*0.15, H*0.195+ i * H*0.075, W*0.155, H*0.0374 )
                    periodTable2[i*7+j-7]:setFillColor(  254/255,118/255,118/255 )
                    periodTable2[i*7+j-7].alpha = 0

                    -- periodTable3[i*7+j-7] = display.newRect( mGroup , -X*0.18 + (firstW + j  ) * W*0.15, H*0.195+ i * H*0.075, W*0.145, H*0.0374 )
                    -- periodTable3[i*7+j-7]:setFillColor( 255/255,195/255,147/255 )
                    -- periodTable3[i*7+j-7].alpha = 0

                    periodTable3[i*7+j-7] = display.newImageRect( mGroup, "images/bg_predict@3x.png", W*0.155, H*0.0374 )
                    periodTable3[i*7+j-7].x , periodTable3[i*7+j-7].y =  -X*0.18 + (firstW + j  ) * W*0.15, H*0.195+ i * H*0.075
                    periodTable3[i*7+j-7].alpha = 0

                    -- periodTable4[i*7+j-7] = display.newCircle( mGroup , -X*0.18 + (firstW + j  ) * W*0.15, H*0.195+ i * H*0.075, H*0.01 )
                    -- periodTable4[i*7+j-7]:setFillColor( 255/255,20/255,20/255 )
                    -- periodTable4[i*7+j-7].alpha = 0

                    periodTable4[i*7+j-7] = display.newImageRect( mGroup, "images/ico_ovum@3x.png", H*0.036, H*0.036 )
                    periodTable4[i*7+j-7].x , periodTable4[i*7+j-7].y =  -X*0.13 + (firstW + j  ) * W*0.15, H*0.195+ i * H*0.075
                    periodTable4[i*7+j-7].alpha = 0

                    mCalendarTable[i*7+j-7] = display.newText( mGroup, i*7+j-7 , -X*0.25 + (firstW + j  ) * W*0.15, H*0.195 + i * H*0.0765, font , H*0.0224 )
                    mCalendarTable[i*7+j-7]:setFillColor( 0 )
                    mCalendarTable[i*7+j-7].id = c..yNum.."/"..string.format("%02d",mNum) .."/"..string.format("%02d",i*7+j-7)
                    mCalendarTable[i*7+j-7].day = i*7+j-7
                    -- mCalendarTable[i*7+j-7]:addEventListener( "tap", listener )

                  

                    for l = 1 , #dTable +1  do 
                        -- local e = os.date(os.time{year=string.sub(mCalendarTable[i*7+j-7].id , 1 , 4) ,month=string.sub(mCalendarTable[i*7+j-7].id , 6 , 7),day=string.sub(mCalendarTable[i*7+j-7].id , 9 , 10)})
                        -- local s = os.date(os.time{year=string.sub(dTable[l] , 1 , 4) ,month=string.sub(dTable[l] , 6 , 7),day=string.sub(dTable[l] , 9 , 10)})

                        -- local days = (tonumber(e-s)/24/60/60) 
                        -- print(mCalendarTable[i*7+j-7].id..":"..days.."天")
                        -- print(days)
                        -- print(0 == nil)
                        -- print( mCalendarTable[i*7+j-7].id..":::::::::::id" )
                        -- readOvulation(mCalendarTable[i*7+j-7].id)
                        for row in database:nrows([[SELECT * FROM Statistics ORDER BY StartDay ASC ]]) do
                            predictDay = T.addDays(row.StartDay , avgDays)
                        end

                        if predictDay then
                            local preMonth = T.minusDays( string.sub( dbDate,1,8).."01" , 30 )
                            local nextMonth = T.addDays( string.sub( dbDate,1,8).."28" , 30 )

                            print( preMonth )
                            print( nextMonth )

                            for row in database:nrows([[SELECT * FROM Statistics WHERE StartDay > ']]..preMonth..[[' AND StartDay < ']]..nextMonth..[[' ORDER BY StartDay ASC ]]) do
                                mCalendarTable[i*7+j-7].distance = T.caculateDays( mCalendarTable[i*7+j-7].id , row.StartDay )
                                
                                continuance = tonumber(row.Continuance) - 1
                                local dt = mCalendarTable[i*7+j-7].distance

                                if dt then
                                    if dt >= 0 and dt <= continuance then 
                                        periodTable2[i*7+j-7].alpha = 1
                                    
                                    elseif dt <= -10 and dt >= -19 then 
                                        periodTable1[i*7+j-7].alpha = 1
                                    end

                                    if dt == -14 then 
                                        periodTable4[i*7+j-7].alpha = 1
                                    end
                                end 

                            end

                            
                            -- print( predictDay.."-----------+++++++++++" )
                            mCalendarTable[i*7+j-7].distance = T.caculateDays( mCalendarTable[i*7+j-7].id , predictDay )
                            local dt2 = mCalendarTable[i*7+j-7].distance
                            -- -- end 

                            if continuance then 
                                if dt2 then
                                    if dt2 >= 0 and dt2 <= continuance then 
                                        periodTable3[i*7+j-7].alpha = 1
                                   
                                    elseif dt2 <= -10 and dt2 >= -19 then 
                                        periodTable1[i*7+j-7].alpha = 1
                                    end

                                    if dt2 == -14 then 
                                        periodTable4[i*7+j-7].alpha = 1
                                    end
                                end 
                            end 
                        end 
                    end 

                    if mCalendarTable[i*7+j-7].id == todayNum then
                        mCalendarTable[i*7+j-7]:setFillColor( 1,0,0 )
                        mCalendarTable[i*7+j-7].size = H*0.03
                        mCalendarTable[i*7+j-7].font = native.systemFontBold
                    end

                    for row in database:nrows([[SELECT * FROM Diary WHERE Date = ']]..mCalendarTable[i*7+j-7].id..[[' ]]) do
                        if row.Close ~= "" then
                            -- local cc = display.newText( mGroup, "❤" ,  -X*0.05 + (firstW + j  ) * W*0.13, H*0.25+ i * H*0.074, font , H*0.024 )
                            -- cc:setFillColor( 0.9 , 0.1 , 0.1 )
                            local cc = display.newImageRect( mGroup, "images/ico_lip@3x.png", W*0.05, H*0.03 )
                            cc.x , cc.y = -X*0.265 + (firstW + j  ) * W*0.15, H*0.18 + i * H*0.074
                            -- local cc = display.newText( mGroup, "❤" ,  -X*0.05 + (firstW + j  ) * W*0.13, H*0.25+ i * H*0.074, font , H*0.024 )
                            -- cc:setFillColor( 0.9 , 0.1 , 0.1 )
                        end

                        if row.Temperature ~= "" then
                            -- local dd = display.newText( mGroup, "◯" ,  -X*0.05 + (firstW + j  ) * W*0.13, H*0.25+ i * H*0.076, font , H*0.024 )
                            -- dd:setFillColor( 0.1 , 0.851 , 0.21 )

                            local dd = display.newImageRect( mGroup, "images/ico_temp@3x.png", W*0.05, H*0.035 )
                            dd.x , dd.y = -X*0.19 + (firstW + j  ) * W*0.15, H*0.168 + i * H*0.074
                        end

                        if row.Weight ~= "" then
                            -- local ee = display.newText( mGroup, "▲" , -X*0.05 + (firstW + j  ) * W*0.14, H*0.25+ i * H*0.076, font , H*0.024 )
                            -- ee:setFillColor( 0.15 , 0.12 , 0.91 )
                            local ee = display.newImageRect( mGroup, "images/ico_weight@3x.png", W*0.05, H*0.025 )
                            ee.x , ee.y = -X*0.265 + (firstW + j  ) * W*0.15, H*0.16 + i * H*0.074
                        end

                        if row.Notes ~= "" then
                            local ff = display.newImageRect( mGroup, "images/ico_note@3x.png", W*0.05, H*0.031 )
                            ff.x , ff.y = -X*0.11 + (firstW + j  ) * W*0.15, H*0.168 + i * H*0.074
                        end
                    end

                    -- print(mCalendarTable[i*7+j-7].id..":<6")
                end

                if (firstW + j -1 ) > 6 then     
                    whiteRectTable[i*7+j-7] = display.newRect( mGroup,  -X*2.29 +  (firstW + j  ) * W*0.15, H*0.17+ (i + 1) * H*0.0765, W*0.135 , H*0.065 )
                    -- whiteRectTable[i*7+j-7]:setFillColor( 1 )
                    whiteRectTable[i*7+j-7].id = c..yNum.."/"..string.format("%02d",mNum) .."/"..string.format("%02d",i*7+j-7)
                    whiteRectTable[i*7+j-7].day = i*7+j-7
                    whiteRectTable[i*7+j-7]:addEventListener( "tap", listener )

                    -- mCalendarTable[i*7+j-7] = display.newText( mGroup, i*7+j-7 , -X*2.33 +  (firstW + j  ) * W*0.15, H*0.195+ (i + 1) * H*0.0765, font , H*0.0224 )


                    periodTable[i*7+j-7] = display.newText( mGroup, "" , -X*2.33 +  (firstW + j  ) * W*0.15, H*0.195+ (i + 1) * H*0.075, native.systemFontBold , H*0.032 )
                    periodTable[i*7+j-7]:setFillColor(0.15,0.41,0.3)    
                    periodTable1[i*7+j-7] = display.newRect( mGroup , -X*2.29 +  (firstW + j  ) * W*0.15, H*0.195+ (i + 1) * H*0.075, W*0.155, H*0.0374 )
                    periodTable1[i*7+j-7]:setFillColor(  254/255,187/255,108/255 )
                    periodTable1[i*7+j-7].alpha = 0

                    periodTable2[i*7+j-7] = display.newRect( mGroup , -X*2.29 +  (firstW + j  ) * W*0.15, H*0.195+ (i + 1) * H*0.075, W*0.155, H*0.0374 )
                    periodTable2[i*7+j-7]:setFillColor(  254/255,118/255,118/255 )
                    periodTable2[i*7+j-7].alpha = 0

                    -- periodTable3[i*7+j-7] = display.newRect( mGroup , -X*2.29 +  (firstW + j  ) * W*0.15, H*0.195+ (i + 1) * H*0.075, W*0.145, H*0.0374 )
                    -- periodTable3[i*7+j-7]:setFillColor( 255/255,195/255,147/255 )
                    -- periodTable3[i*7+j-7].alpha = 0

                    periodTable3[i*7+j-7] = display.newImageRect( mGroup, "images/bg_predict@3x.png", W*0.155, H*0.0374 )
                    periodTable3[i*7+j-7].x , periodTable3[i*7+j-7].y = -X*2.29 +  (firstW + j  ) * W*0.15, H*0.195+ (i + 1) * H*0.075
                    periodTable3[i*7+j-7].alpha = 0

                    -- periodTable4[i*7+j-7] = display.newCircle ( mGroup , -X*2.29 +  (firstW + j  ) * W*0.15, H*0.195+ (i + 1) * H*0.075, H*0.01 )
                    -- periodTable4[i*7+j-7]:setFillColor( 255/255,20/255,20/255 )
                    -- periodTable4[i*7+j-7].alpha = 0

                    periodTable4[i*7+j-7] = display.newImageRect( mGroup, "images/ico_ovum@3x.png", H*0.036, H*0.036 )
                    periodTable4[i*7+j-7].x , periodTable4[i*7+j-7].y = -X*2.22 +  (firstW + j  ) * W*0.15, H*0.195+ (i + 1) * H*0.075
                    periodTable4[i*7+j-7].alpha = 0

                    mCalendarTable[i*7+j-7] = display.newText( mGroup, i*7+j-7 , -X*2.33 +  (firstW + j  ) * W*0.15, H*0.195+ (i + 1) * H*0.0765, font , H*0.0224 )
                    mCalendarTable[i*7+j-7]:setFillColor( 0 )
                    mCalendarTable[i*7+j-7].id = c..yNum.."/"..string.format("%02d", mNum) .."/"..string.format("%02d",i*7+j-7)
                    mCalendarTable[i*7+j-7].day = i*7+j-7
                    -- mCalendarTable[i*7+j-7]:addEventListener( "tap", listener )
                    
                   

                    for l = 1 , #dTable + 1 do 
                        -- local e = os.date(os.time{year=string.sub(mCalendarTable[i*7+j-7].id , 1 , 4) ,month=string.sub(mCalendarTable[i*7+j-7].id , 6 , 7),day=string.sub(mCalendarTable[i*7+j-7].id , 9 , 10)})
                        -- local s = os.date(os.time{year=string.sub(dTable[l] , 1 , 4) ,month=string.sub(dTable[l] , 6 , 7),day=string.sub(dTable[l] , 9 , 10)})

                        -- local days = (tonumber(e-s)/24/60/60) 
                        -- print(mCalendarTable[i*7+j-7].id..":"..days.."天")
                        -- print(days)
                        -- print(0 == nil)
                        -- if days >= 0 and days <= 5 then 
                        --     periodTable[i*7+j-7].text = "經"
                        -- elseif days == 14 then 
                        --     periodTable[i*7+j-7].text = "卵"
                        -- elseif days < 14 and days > 9  or days >14 and days <19 then 
                        --     periodTable[i*7+j-7].text = "危險"
                        -- end
                         for row in database:nrows([[SELECT * FROM Statistics ORDER BY StartDay ASC ]]) do
                            predictDay = T.addDays(row.StartDay , avgDays)
                        end

                        if predictDay then 

                            local preMonth = T.minusDays( string.sub( dbDate,1,8).."01" , 30 )
                            local nextMonth = T.addDays( string.sub( dbDate,1,8).."28" , 30 )

                            print( preMonth )
                            print( nextMonth )

                            for row in database:nrows([[SELECT * FROM Statistics WHERE StartDay > ']]..preMonth..[[' AND StartDay < ']]..nextMonth..[[' ORDER BY StartDay ASC ]]) do
                                mCalendarTable[i*7+j-7].distance = T.caculateDays( mCalendarTable[i*7+j-7].id , row.StartDay )
                                
                                continuance = tonumber(row.Continuance) - 1
                                local dt = mCalendarTable[i*7+j-7].distance

                                if dt then
                                    if dt >= 0 and dt <= continuance then 
                                        periodTable2[i*7+j-7].alpha = 1
                                   
                                    elseif dt <= -10 and dt >= -19 then 
                                        periodTable1[i*7+j-7].alpha = 1
                                    end

                                    if dt == -14 then 
                                        periodTable4[i*7+j-7].alpha = 1
                                    end
                                end 

                            end

                           
                            -- print( predictDay.."-----------+++++++++++" )
                            mCalendarTable[i*7+j-7].distance = T.caculateDays( mCalendarTable[i*7+j-7].id , predictDay )
                            local dt2 = mCalendarTable[i*7+j-7].distance
                            -- -- end 

                            if dt2 then
                                if continuance then 
                                    if dt2 >= 0 and dt2 <= continuance then 
                                        periodTable3[i*7+j-7].alpha = 1
                                    
                                    elseif dt2 <= -10 and dt2 >= -19 then 
                                        periodTable1[i*7+j-7].alpha = 1
                                    end

                                    if dt2 == -14 then 
                                        periodTable4[i*7+j-7].alpha = 1
                                    end 
                                end 
                            end 
                        end 
                    end 

                    if mCalendarTable[i*7+j-7].id == todayNum then
                        -- todayRect = display.newRect( mGroup,mCalendarTable[i*7+j-7].x+X*0.045 , mCalendarTable[i*7+j-7].y-Y*0.04, W*0.15, H*0.08 )
                        -- todayRect:setFillColor( 0.3,0.7,0.6,0.3 )
                        -- todayRect.strokeWidth = H*0.006
                        -- todayRect:setStrokeColor( 1,0,0 )
                        mCalendarTable[i*7+j-7]:setFillColor( 1,0,0 )
                        mCalendarTable[i*7+j-7].size = H*0.03
                        mCalendarTable[i*7+j-7].font = native.systemFontBold
                    end

                    -- for row in database:nrows([[SELECT * FROM Diary WHERE Date = ']]..mCalendarTable[i*7+j-7].id..[[' ]]) do
                    --     if row.Close ~= "" then
                    --         local cc = display.newText( mGroup, "❤" , -X*2 +  (firstW + j  ) * W*0.138, H*0.25+ (i + 1) * H*0.074, font ,  H*0.024 )
                    --         cc:setFillColor( 0.9 , 0.1 , 0.1 )
                    --     end

                    --     if row.Temperature ~= "" then
                    --         local dd = display.newText( mGroup, "◯" ,-X*2 +  (firstW + j  ) * W*0.138, H*0.25+ (i + 1) * H*0.076, font ,  H*0.024 )
                    --         dd:setFillColor( 0.1 , 0.851 , 0.21 )
                    --     end

                    --     if row.Weight ~= "" then
                    --         local ee = display.newText( mGroup, "▲" , -X*2 +  (firstW + j  ) * W*0.138, H*0.25+ (i + 1) * H*0.076, font ,  H*0.024 )
                    --         ee:setFillColor( 0.15 , 0.12 , 0.91 )
                    --     end
                    -- end

                    for row in database:nrows([[SELECT * FROM Diary WHERE Date = ']]..mCalendarTable[i*7+j-7].id..[[' ]]) do
                        if row.Close ~= "" then
                            -- local cc = display.newText( mGroup, "❤" ,  -X*0.05 + (firstW + j  ) * W*0.13, H*0.25+ i * H*0.074, font , H*0.024 )
                            -- cc:setFillColor( 0.9 , 0.1 , 0.1 )
                            local cc = display.newImageRect( mGroup, "images/ico_lip@3x.png", W*0.05, H*0.03 )
                            cc.x , cc.y = -X*2.37 + (firstW + j  ) * W*0.15, H*0.18 + (i+1) * H*0.074
                            -- local cc = display.newText( mGroup, "❤" ,  -X*0.05 + (firstW + j  ) * W*0.13, H*0.25+ i * H*0.074, font , H*0.024 )
                            -- cc:setFillColor( 0.9 , 0.1 , 0.1 )
                        end

                        if row.Temperature ~= "" then
                            -- local dd = display.newText( mGroup, "◯" ,  -X*0.05 + (firstW + j  ) * W*0.13, H*0.25+ i * H*0.076, font , H*0.024 )
                            -- dd:setFillColor( 0.1 , 0.851 , 0.21 )

                            local dd = display.newImageRect( mGroup, "images/ico_temp@3x.png", W*0.05, H*0.035 )
                            dd.x , dd.y = -X*2.29 + (firstW + j  ) * W*0.15, H*0.168 + (i+1) * H*0.074
                        end

                        if row.Weight ~= "" then
                            -- local ee = display.newText( mGroup, "▲" , -X*0.05 + (firstW + j  ) * W*0.14, H*0.25+ i * H*0.076, font , H*0.024 )
                            -- ee:setFillColor( 0.15 , 0.12 , 0.91 )
                            local ee = display.newImageRect( mGroup, "images/ico_weight@3x.png", W*0.05, H*0.025 )
                            ee.x , ee.y = -X*2.37 + (firstW + j  ) * W*0.15, H*0.16 + (i+1) * H*0.074
                        end

                        if row.Notes ~= "" then
                            local ff = display.newImageRect( mGroup, "images/ico_note@3x.png", W*0.05, H*0.031 )
                            ff.x , ff.y = -X*2.21 + (firstW + j  ) * W*0.15, H*0.168 + (i+1) * H*0.074
                        end
                    end
                     -- print(mCalendarTable[i*7+j-7].id..":>6")
                end 


            end
        end
    end
    -- print( mCalendarTable[25].text..":yeeeeeeee" )
    -- redRect = display.newRect( mGroup, X*1.017, Y*1.065, W*0.12, H*0.065 )
    -- redRect:setFillColor(1,0,0,0) 
    -- redRect.strokeWidth = H*0.009
    -- redRect:setStrokeColor( 1,0,0 )

    readOvulation()
end

removeListener = function (  )
    for i = 1 , daysTable[m] do 
        mCalendarTable[i]:removeEventListener( "tap", listener )
    end
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
    sceneGroup:insert(backGroup)
    sceneGroup:insert(frontGroup)
    init(frontGroup)
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
