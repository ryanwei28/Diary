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
local dCalendarY = composer.getVariable( "dCalendarY" )
local dCalendarM = composer.getVariable( "dCalendarM" )
local dCalendarD = composer.getVariable( "dCalendarD" )
if dCalendarY then
    c = tonumber(string.sub( dCalendarY , 1 , 2 ))
    y = tonumber(string.sub( dCalendarY , 3 , 4 ))
    m = dCalendarM
    d = dCalendarD
end
local mNum = m
local yNum = y
local dbDate = tostring(c..y.."/"..string.format("%02d",m).."/"..string.format("%02d",d))
local dateText1
local dateText2
local week = ""
local daysTable = { 31 ,28 ,31 ,30 ,31 ,30 ,31 ,31 ,30 ,31 ,30 ,31 ,31 ,28}
local judgeWeek 
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
-- local title
local backBtn
local statisticalDays 
local statusText
local statusNum
local sceneGroupListener 
local bg 
local bg_green
-- local titleBg 
local pinkRect
local whiteRect
local closeImg
local tempImg
local weightImg
local bmiImg
local noteImg
local addDashedLine
local dashedLine
local bird 
local stringNum 
local notejoin 
local helpBtnEvent 
local maskGroup = display.newGroup( ) 
local helpImg
local helpImgX
local mask 
local scrollView
local noticTextH 

composer.setVariable( "prevScene", "daily_calendar" )

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    bg = display.newImageRect( _parent, "images/bg_dot@3x.png", W, H )
    bg.x , bg.y = X , Y*1.07

    T.title("日曆" , sceneGroup)

    -- titleBg = display.newImageRect( _parent, "images/bg_top@3x.png", W, H*0.07 )
    -- titleBg.x , titleBg.y ,titleBg.anchorY= X, Y*0.07 , 0

    bg_green = display.newImageRect( _parent, "images/bg_green@3x.png", W, H*0.602 )
    bg_green.x , bg_green.y = X , Y * 1.398

    pinkRect = display.newRoundedRect( _parent, X, Y*1.3, W*0.92, H*0.707, H*0.015 )
    pinkRect:setFillColor( 254/255,118/255,118/255 )

    bird = display.newImageRect( _parent, "images/bird_1@3x.png", W*0.1226, H*0.09 )
    bird.anchorX , bird.anchorY = 0 , 0
    bird.x , bird.y = X*0.08 , Y*0.48

    whiteRect = display.newRoundedRect( _parent, X, Y*1.35, W*0.84, H*0.645, H*0.015 )
    -- bg = display.newRect( _parent, X, Y, W, H )
    -- bg.alpha = 0.01
    scrollView = widget.newScrollView
    {
        x = X,
        y = Y*1.62 ,
        width = W*0.8,
        height = H*0.2,
        hideBackground = true , 
        -- isBounceEnabled = false , 
        -- scrollWidth = 600,
        -- scrollHeight = 800,
        horizontalScrollDisabled = true
    }

    sceneGroup:insert(scrollView)


    -- title = display.newText( _parent, "日曆", X, Y*0.14, bold , H*0.032 )

    closeImg = display.newImageRect( _parent, "images/ico_lip@3x.png", W*0.064, H*0.036 )
    closeImg.x , closeImg.y ,closeImg.anchorX = X*2*0.1173 , Y *0.92 , 0

    tempImg = display.newImageRect( _parent, "images/ico_temp@3x.png", W*0.064, H*0.036 )
    tempImg.x , tempImg.y ,tempImg.anchorX = X*2*0.1173 , Y *1.055 , 0

    weightImg = display.newImageRect( _parent, "images/ico_weight@3x.png", W*0.064, H*0.036 )
    weightImg.x , weightImg.y ,weightImg.anchorX = X*2*0.1173 , Y *1.195 , 0

    bmiImg = display.newImageRect( _parent, "images/ico_bmi@3x.png", W*0.064, H*0.036 )
    bmiImg.x , bmiImg.y ,bmiImg.anchorX = X*2*0.1173 , Y *1.33 , 0

    noteImg = display.newImageRect( _parent, "images/ico_note@3x.png", W*0.064, H*0.036 )
    noteImg.x , noteImg.y ,noteImg.anchorX = X*2*0.1173 , Y *1.47 , 0

    text1 = display.newText( _parent , "本日狀況", X, Y*0.65 , bold , H*0.024 )
    text1:setFillColor( 1 )
    text2 = display.newText( _parent , "親密行為", X*2*0.202, closeImg.y , bold , H*0.024 )
    text2.anchorX = 0
    text2:setFillColor( 0 )
    text2.anchorX = 0 
    text3 = display.newText( _parent , "基礎體溫", X*2*0.202, tempImg.y , bold , H*0.024 )
    text3.anchorX = 0
    text3:setFillColor( 0 )
    text3.anchorX = 0 
    text4 = display.newText( _parent , "體重", X*2*0.202, weightImg.y , bold , H*0.024 )
    text4.anchorX = 0
    text4:setFillColor( 0 )
    text4.anchorX = 0 

    closeText = display.newText( _parent , "尚無紀錄", X*2*0.405, closeImg.y , bold , H*0.024 )
    closeText:setFillColor( 170/255 )
    closeText.anchorX = 0
    temperatureText = display.newText( _parent , "尚無紀錄", X*2*0.405, tempImg.y , bold , H*0.024 )
    temperatureText:setFillColor(  170/255 )
    temperatureText.anchorX = 0
    weightText = display.newText( _parent , "尚無紀錄", X*2*0.32, weightImg.y , bold , H*0.024 )
    weightText:setFillColor(  170/255 )
    weightText.anchorX = 0
    BMIText = display.newText( _parent , "請至設定頁設定身高", X*2*0.2026, bmiImg.y , bold , H*0.024 )
    BMIText:setFillColor(  170/255 )
    BMIText.anchorX = 0

    noticTextH = -H*0.008
    if platform == "ios" then 
        noticTextH = H*0.008
    end
    noticText = display.newText( _parent , "尚無紀錄", X*0.2, noticTextH ,W*0.7 , 0 , bold , H*0.024 )
    noticText:setFillColor(  170/255 )
    noticText.anchorX = 0
    noticText.anchorY = 0
    scrollView:insert(noticText)

    statusText = display.newText( _parent , "今天是安全期", X, Y*0.79 , bold , H*0.024 )
    statusText:setFillColor( 254/255,118/255,118/255 )

    dateText1 = display.newText( _parent, m.."/"..d , X , Y*0.37 , native.systemFontBold , H*0.135 )
    dateText1:setFillColor( 226/255,68/255,61/255 )
    
    if m == 1 then 
        m = 13
        y = y - 1
    elseif m == 2 then 
        m = 14 
        y = y - 1
    end
    
    judgeWeek()
    dateText2 = display.newText( _parent, c..y.."  "..week , X, Y*0.55, bold , H*0.03 )
    dateText2:setFillColor(  226/255,68/255,61/255  )
    leftBtn = widget.newButton({ 
        x = X*0.07,
        y = Y*0.38,
        id = "leftBtn",
        -- label = "<",
        -- fontSize = H*0.037 ,
        -- shape = "circle",
        -- radius = H*0.04 ,
        -- fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        width = W*0.0693 , 
        height = H*0.09745,
        defaultFile = "images/btn_prev@3x.png" , 
        overFile = "images/btn_prev_press@3x.png" , 
        onEvent = handleButtonEvent 
    })

    rightBtn = widget.newButton({ 
        x = X*1.93,
        y = Y*0.38,
        id = "rightBtn",
        -- label = ">",
        -- fontSize = H*0.037 ,
        -- shape = "circle",
        -- radius =  H*0.04 ,
        -- fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        width = W*0.0693 , 
        height = H*0.09745,
        defaultFile = "images/btn_next@3x.png" , 
        overFile = "images/btn_next_press@3x.png" , 
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
    -- notejoin()
    backToday()
    setBtn()
    readDb()
    addDashedLine(H*0.425)
    addDashedLine(H*0.493)
    addDashedLine(H*0.561)
    addDashedLine(H*0.629)
    addDashedLine(H*0.697)
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
    sceneGroup:addEventListener("touch" , sceneGroupListener)
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
        createMask()

        local function helpImgEvent ( e )
            if e.phase == "ended" then 
                mask:removeSelf( )
                helpImg:removeSelf( )
                helpImgX:removeSelf( )
            end     
        end

        helpImg = widget.newButton({
            x = X ,
            y = Y*0.91 , 
            width = W*0.661,
            height = H*0.337, 
            defaultFile = "images/modal_bmi@3x.png" , 
            overFile = "images/modal_bmi@3x.png" , 
            onEvent = helpImgEvent , 
            })

        maskGroup:insert(helpImg)

        helpImgX = display.newImageRect( maskGroup, "images/nav_close@3x.png", H*0.036 , H*0.036 )
        helpImgX.x , helpImgX.y = W*0.77 , H*0.318

    end
end

notejoin = function (  )
    
    for row in database:nrows([[SELECT * FROM Diary WHERE Date = ']]..dbDate..[[']]) do
        stringNum = #row.Notes 
        notesContent = row.Notes
    end

    print( stringNum..":string" )

    if stringNum >= 60 then 
        noticText:removeSelf( )
        noticText = display.newText( sceneGroup , "notesContent", X*2*0.2026, Y*1.435 ,W*0.7 , W*0.045*stringNum/4 , bold , W*0.045 )
        noticText:setFillColor(  170/255 )
        noticText.anchorX = 0
        noticText.anchorY = 0
    end 
end

addDashedLine = function ( y )
    dashedLine = display.newImageRect( sceneGroup, "images/line_dashed@3x.png", W*0.7866, H*0.001499 )
    dashedLine.x , dashedLine.y = X , y
end

sceneGroupListener = function ( e )
    if e.phase == "began" then 
        sx = e.x 
    elseif e.phase == "moved" then 
        ex = e.x 
    elseif e.phase == "ended" then
        if ex then
            print( sx..":"..ex )
            if sx < ex - 20 then 
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
            elseif sx > ex + 20 then 
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
            end

            sx , ex = nil ,nil
        end
    end
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

    sceneGroup:insert(backBtn)
end

setBtn = function (  )
    setBtnEvent = function ( e )
        if ( "ended" == e.phase ) then
            if e.target.id == "disclaimer" then 
                composer.showOverlay( "disclaimer" ,T.options )
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

    local editBtn = widget.newButton({ 
        x = W*0.813,
        y = Y*0.6,
        id = "editBtn",
        -- label = "編輯",
        -- fontSize = H*0.028 ,
        -- shape = "circle",
        -- radius = H*0.028 ,
        -- fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        width = W*0.1013, 
        height = H*0.057,
        defaultFile = "images/btn_edit@3x.png" , 
        overFile = "images/btn_edit_press@3x.png" ,
        onEvent = setBtnEvent 
    })
    editBtn.anchorX = 0 

    local helpBtn = widget.newButton({ 
        left = W*0.818,
        top = H*0.647,
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
    sceneGroup:insert(disclaimerBtn)
    sceneGroup:insert(statisticsBtn)
    sceneGroup:insert(setupBtn)
    sceneGroup:insert(editBtn)
    sceneGroup:insert(helpBtn)

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
                                    INSERT INTO Diary VALUES ( NULL , ']]..c..yNum.."/"..string.format("%02d",mNum) .."/"..string.format("%02d",i)..[[' , "" , "" , "" , "" , "" , "","" , "");
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
        closeText:setFillColor( 170/255 )
    else
        closeText:setFillColor( 254/255,118/255,118/255  )
    end

    if temperatureText.text == "" then 
        temperatureText.text = "尚無紀錄"
         temperatureText:setFillColor( 170/255 )
    else
        temperatureText:setFillColor( 254/255,118/255,118/255  )
    end

    if weightText.text == "" then
        weightText.text = "尚無紀錄"
         weightText:setFillColor( 170/255 )
    else
        weightText:setFillColor( 254/255,118/255,118/255  )
    end

    if noticText.text == "" then
        noticText.text = "尚無紀錄"
         noticText:setFillColor( 170/255 )
    else
        noticText:setFillColor( 254/255,118/255,118/255  )
    end

    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1]]) do
        if row.Height == "" then
            BMIText.text = "請至設定頁設定身高"
            BMIText:setFillColor( 170/255 )
        elseif row.Height ~= "" then
            if weightText.text ~= "尚無紀錄" then
                BMIText.text =  string.sub (string.sub( weightText.text, 1,4 ) /(row.Height / 100 )^2 , 1 , 4 )
                BMIText:setFillColor( 254/255,118/255,118/255  )
            else
                BMIText.text = "請輸入體重"
                BMIText:setFillColor( 170/255 )
            end
        end
    end

    
    -- print(statusNum.."$$$$$$$$")
    if statusNum == "" or statusNum == nil then
        statusText.text = "今天是安全期"
    elseif statusNum ~= ""  then
        statusText.text = "今天是月經期"
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
            print(111111111111)
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
            print(ddd.."::::")
            if ddd > 9 and ddd <= 19 then
                statusText.text = "今天是預測危險期"
            end 

            if ddd == 14 then 
                statusText.text = "今天是預測排卵日"
            end

            for row in database:nrows([[SELECT * FROM Setting ;]]) do
                if ddd <= 0 and ddd > -row.During +1 then 
                    statusText.text = "今天是預測經期"
                end
            end 

            recentStartDay2 = nil
        end 


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
    sceneGroup:insert(maskGroup)
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
