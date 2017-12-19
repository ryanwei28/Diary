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
local dateTable 
local lineTable 
local dotTable 
local vTable
local small 
local big 
local wNum 
local wTable 
local pointTable 
local statisticCount 
local daysTable 
local day 
local month
local year 
local today
local e 
local d 
local n 
local s 
local sY 
local sM 
local sD 
local preDate 
local chkDb 
local writeDb 
local regularPreDate 
local wPointTable 
local wPointNum 
local connectLineTable 
local prePointNum
local a 
local b
local c 
local createBtn
local createBtnEvent
local temperatureBtn
local weightBtn
local printWeightPlot
local weightPlotReset
local printTemperaturePlot
local temperaturePlotReset
local sY
local sM
local sD
local daysTable
local switch = "temperature"
local vGroup
local noDataText
local labelTable 
local labelTable2 
local startTable 
local endTable
local startTableNum 
local endTableNum
local connectPeriodTable 
local periodEndTable
local greenBgT
local greenBgW
local chartBg
local frontGroup 
local midGroup
local backGroup 
local temperatureText 
local temperatureBtn_press
local weightText 
local weightBtn_press
-- print( "2017/10/31" < "2017/11/01" )
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    -- title = display.newText( _parent, "圖表", X, Y*0.15, font , H*0.045 )
    T.bg(_parent)

    -- for row in database:nrows([[SELECT * FROM Diary ORDER BY Temperature ASC ;]]) do
    --     if row.Temperature ~= "" then
    --         print( row.Temperature.."tt" )
    --     end
    -- end

    -- printPlot()
    createBtn()
    -- end
    T.title("圖表" , sceneGroup)

    timer.performWithDelay( 1, function (  )
        printTemperaturePlot()

    end  )

    -- native.setActivityIndicator( true )
end


printWeightPlot = function (  )
    

    vGroup = display.newGroup( ) 
    frontGroup = display.newGroup( )
    midGroup = display.newGroup( )
    backGroup = display.newGroup( )
    sceneGroup:insert(vGroup)
    -- sceneGroup:insert(frontGroup)
    -- sceneGroup:insert(backGroup)
    


    daysTable = { 31 ,28 ,31 ,30 ,31 ,30 ,31 ,31 ,30 ,31 ,30 ,31 ,31 ,28}
    day = os.date("%d" )
    month = os.date("%m" )
    year = os.date( "%Y" )
    today = year.."/"..string.format("%02d" , month) .."/"..string.format("%02d" , day)
    e = os.date(os.time())
    d = 130
    n = (24*60*60)
    s = e - (d-1) * n
    sY = tonumber( os.date("%Y" , s))
    sM = tonumber( string.format( "%02d", os.date("%m" , s) ))
    sD = tonumber( string.format( "%02d" , os.date("%d" , s) ))
    preDate = sY.."/"..string.format( "%02d", sM).."/"..string.format( "%02d",sD)

    regularPreDate = tostring(preDate)
    dateTable = {}
    lineTable = {}
    vTable = {}
    wNum = 0 
    wTable = {}
    pointTable = {}
    wPointTable = {}
    wPointNum = 0
    connectLineTable = {}
    connectPeriodTable = {}
    periodEndTable = {}
    dotTable = {}
    a = 0
    b = 0
    c = 0
    labelTable = {}
    labelTable2 = {}

    for row in database:nrows([[SELECT * FROM Diary ORDER BY Temperature ASC ;]]) do
        if row.Weight ~= "" then
            wNum = wNum + 1
            wTable[wNum] = row.Weight
            print( row.Weight.."tt" )
        end
    end

    scrollView = widget.newScrollView(
        {
            x = W*0.54,
            y = Y*1.1,
            width =  W*0.78,
            height = H*0.7,
            hideBackground = true ,
            scrollWidth = 600,
            scrollHeight = 800,
            verticalScrollDisabled = true , 
            -- listener = scrollListener
        }
    )
 
    sceneGroup:insert(scrollView)
    scrollView:insert(frontGroup)
    scrollView:insert(midGroup)
    scrollView:insert(backGroup)

    startTable = {} 
    endTable = {} 
    startTableNum = 0
    endTableNum = 0

    for row in database:nrows([[SELECT * FROM Diary WHERE Date >= ']]..regularPreDate..[[' AND Date <= ']]..today..[[' ORDER BY Date ASC ;]]) do
        startTableNum = startTableNum + 1 
        startTable[startTableNum] = row.Start 
    end 

    for row in database:nrows([[SELECT * FROM Statistics WHERE StartDay >= ']]..regularPreDate..[[' AND StartDay <= ']]..today..[[' ORDER BY StartDay ASC ;]]) do
        endTableNum = endTableNum + 1 
        endTable[endTableNum] = row.Continuance 
    end 

    if #wTable >= 2 then
        chartBg = display.newImageRect( vGroup, "images/chart@3x.png", W*0.8, H*0.6086 )
        chartBg.x , chartBg.y = W*0.54 ,Y
        print( "??????????????????" )
        --下限
        small = tonumber(string.sub( wTable[1], 1 , -5 )) - tonumber(string.sub( wTable[1], 1 , -5 ))*0.02
        --上限
        big = tonumber( string.sub( wTable[wNum], 1 , -5 )) + tonumber( string.sub( wTable[wNum], 1 , -5 ))*0.02

        --Y軸數值
        for i = 1 , 7 do 
            vTable[i] = display.newText( vGroup, string.format( "%.1f", small + (big-small)*(i-1)/6  )  , X*0.16 , Y*1.78 - i*Y*0.195 , font , H*0.024 )
            vTable[i]:setFillColor( 234/255,87/255,73/255 )
        end

        --X軸日期
        for i = 1 , 132 do 
            dateTable[i] = display.newText( sceneGroup, string.sub( preDate, 6 ,-1 ).."\n "..string.sub( preDate, 1 ,4 )  , X*0.1 + i*0.3*X, Y*1.29 ,bold , H*0.015 )
            scrollView:insert(dateTable[i])
            dateTable[i]:setFillColor( 140/255,200/255,100/255 )

            -- dotTable[i] = display.newLine( sceneGroup, X*0.1 + i*0.3*X, Y*1.2, X*0.1 + i*0.3*X, Y*0.1 )
            

            dotTable[i] = display.newImageRect( sceneGroup, "images/chart_dot@3x.png", H*0.015, H*0.015 )
            dotTable[i].x , dotTable[i].y = X*0.1 + i*0.3*X, Y*1.2 
            scrollView:insert( dotTable[i]) 

            lineTable[i] = display.newImageRect( frontGroup, "images/chart_line_vr@3x.png", W*0.0025, H*0.6086 )
            lineTable[i].x , lineTable[i].y = X*0.1 + i*0.3*X, Y*0.61
            -- scrollView:insert( lineTable[i]) 

            -- lineTable[i] = display.newLine( sceneGroup, X*0.1 + i*0.3*X, Y*1.2, X*0.1 + i*0.3*X, Y*0.1 )
            -- scrollView:insert( lineTable[i])
            -- for i = 1,2 do 
                statisticCount()
            -- end 
            chkDb()
        end

        --點

        for row in database:nrows([[SELECT * FROM Diary WHERE Date >= ']]..regularPreDate..[[' AND Date <= ']]..today..[[' ORDER BY Date ASC ;]]) do
            wPointNum = wPointNum + 1
            wPointTable[wPointNum] = row.Weight
        end

        print( regularPreDate )
        print( today )
        for i = 1 , #wPointTable do 
            if wPointTable[i] ~= "" then
                a = a + 1
                -- pointTable[i] = display.newCircle( sceneGroup, lineTable[i+1].x ,  Y*1.2 - ((string.sub( wPointTable[i], 1 , -5 )-small)/(big-small)*Y*1.1), 12 )
                -- pointTable[i]:setFillColor( 0/255, 154/255, 219/255 )
                -- scrollView:insert(pointTable[i])
            -- vTable[i] = display.newText( vGroup, string.format( "%.1f", small + (big-small)*(i-1)/6  )  , X*0.16 , Y*1.78 - i*Y*0.195 , font , H*0.024 )

                pointTable[i] = display.newCircle( backGroup, lineTable[i+1].x ,  Y*1.2 - ((string.sub( wPointTable[i], 1 , -5 )-small)/(big-small)*Y*1.23), H*0.006 )
                pointTable[i]:setFillColor( 145/255, 215/255, 215/255 )
                labelTable[i] = display.newRect( backGroup, pointTable[i].x , pointTable[i].y + Y*0.06, W*0.0933, H*0.024 )
                labelTable[i]:setFillColor( 254/255 , 187/255 , 108/255 )
                labelTable2[i] = display.newText( backGroup , string.sub( wPointTable[i], 1 , -5 ) , pointTable[i].x, pointTable[i].y + Y*0.065, bold , H*0.018 )
                labelTable2[i]:setFillColor( 1 )
                -- scrollView:insert(pointTable[i])
                -- scrollView:insert(labelTable[i])
                -- scrollView:insert(labelTable2[i])

                if a >= 2 then
                    --連線
                    connectLineTable[i] = display.newLine( midGroup, pointTable[prePointNum].x, pointTable[prePointNum].y, pointTable[i].x, pointTable[i].y  )
                    connectLineTable[i]:setStrokeColor( 145/255, 215/255, 215/255 )
                    connectLineTable[i].strokeWidth = H*0.0045
                    -- scrollView:insert(connectLineTable[i])
                    print( prePointNum )
                    
                end
                prePointNum = i
            end

            if i == #wPointTable then
                -- native.setActivityIndicator( false )
            end 
        end


        for i = 1 , #startTable do 
            

            if startTable[i] ~= "" then
               c = c + 1
               print(endTable[c] ..">>>>>>>>days")
               print(0.3*X*endTable[c])
              
                connectPeriodTable[i] = display.newRect( frontGroup, lineTable[i+1].x - X*0.15, -Y*0.01, 0.3*X*endTable[c] , H*0.604  )
                connectPeriodTable[i]:setFillColor( 255/255,11/255,0.1,0.5 )
                connectPeriodTable[i].anchorX = 0
                connectPeriodTable[i].anchorY = 0
                local text = display.newText( frontGroup, "經\n期", lineTable[i+1].x - X*0.07 , Y*0.09 , bold , H*0.02 )
                -- scrollView:insert(connectPeriodTable[i])
                -- scrollView:insert(text)
                 
            end
        end

        scrollView:scrollTo( "right", { time=0 } )
    else
        noDataText = display.newText( vGroup, "尚無紀錄", X, Y , bold , H*0.03 )
        noDataText:setFillColor(0.67)
        -- native.setActivityIndicator( false )
    end



end

printTemperaturePlot = function (  )
    vGroup = display.newGroup( ) 
    frontGroup = display.newGroup( )
    midGroup = display.newGroup( )
    backGroup = display.newGroup( )
    sceneGroup:insert(vGroup)
    -- sceneGroup:insert(frontGroup)
    -- sceneGroup:insert(backGroup)
    


    daysTable = { 31 ,28 ,31 ,30 ,31 ,30 ,31 ,31 ,30 ,31 ,30 ,31 ,31 ,28}
    day = os.date("%d" )
    month = os.date("%m" )
    year = os.date( "%Y" )
    today = year.."/"..string.format("%02d" , month) .."/"..string.format("%02d" , day)
    e = os.date(os.time())
    d = 130
    n = (24*60*60)
    s = e - (d-1) * n
    sY = tonumber( os.date("%Y" , s))
    sM = tonumber( string.format( "%02d", os.date("%m" , s) ))
    sD = tonumber( string.format( "%02d" , os.date("%d" , s) ))
    preDate = sY.."/"..string.format( "%02d", sM).."/"..string.format( "%02d",sD)

    regularPreDate = tostring(preDate)
    dateTable = {}
    lineTable = {}
    vTable = {}
    wNum = 0 
    wTable = {}
    pointTable = {}
    wPointTable = {}
    wPointNum = 0
    connectLineTable = {}
    connectPeriodTable = {}
    periodEndTable = {}
    dotTable = {}
    a = 0
    b = 0
    c = 0
    labelTable = {}
    labelTable2 = {}

    for row in database:nrows([[SELECT * FROM Diary ORDER BY Temperature ASC ;]]) do
        if row.Temperature ~= "" then
            wNum = wNum + 1
            wTable[wNum] = row.Temperature
            print( row.Temperature.."tt" )
        end
    end

    scrollView = widget.newScrollView(
        {
            x = W*0.54,
            y = Y*1.1,
            width =  W*0.78,
            height = H*0.7,
            hideBackground = true ,
            -- scrollWidth = W*50,
            -- scrollHeight = 800,
            -- isBounceEnabled = false , 
            verticalScrollDisabled = true , 
            -- listener = scrollListener
        }
    )
 
    sceneGroup:insert(scrollView)
    scrollView:insert(frontGroup)
    scrollView:insert(midGroup)
    scrollView:insert(backGroup)

    startTable = {} 
    endTable = {} 
    startTableNum = 0
    endTableNum = 0

    for row in database:nrows([[SELECT * FROM Diary WHERE Date >= ']]..regularPreDate..[[' AND Date <= ']]..today..[[' ORDER BY Date ASC ;]]) do
        startTableNum = startTableNum + 1 
        startTable[startTableNum] = row.Start 
    end 

    for row in database:nrows([[SELECT * FROM Statistics WHERE StartDay >= ']]..regularPreDate..[[' AND StartDay <= ']]..today..[[' ORDER BY StartDay ASC ;]]) do
        endTableNum = endTableNum + 1 
        endTable[endTableNum] = row.Continuance 
    end 

    if #wTable >= 2 then
        chartBg = display.newImageRect( vGroup, "images/chart@3x.png", W*0.8, H*0.6086 )
        chartBg.x , chartBg.y = W*0.54 ,Y
        print( "??????????????????" )
        --下限
        small = tonumber(string.sub( wTable[1], 1 , -5 )) - tonumber(string.sub( wTable[1], 1 , -5 ))*0.02
        --上限
        big = tonumber( string.sub( wTable[wNum], 1 , -5 )) + tonumber( string.sub( wTable[wNum], 1 , -5 ))*0.02

        --Y軸數值
        for i = 1 , 7 do 
            vTable[i] = display.newText( vGroup, string.format( "%.1f", small + (big-small)*(i-1)/6  )  , X*0.16 , Y*1.78 - i*Y*0.195 , font , H*0.024 )
            vTable[i]:setFillColor( 234/255,87/255,73/255 )
        end

        --X軸日期
        for i = 1 , 132 do 
            dateTable[i] = display.newText( sceneGroup, string.sub( preDate, 6 ,-1 ).."\n "..string.sub( preDate, 1 ,4 )  , X*0.1 + i*0.3*X, Y*1.29 ,bold , H*0.015 )
            scrollView:insert(dateTable[i])
            dateTable[i]:setFillColor( 140/255,200/255,100/255 )

            -- dotTable[i] = display.newLine( sceneGroup, X*0.1 + i*0.3*X, Y*1.2, X*0.1 + i*0.3*X, Y*0.1 )
            

            dotTable[i] = display.newImageRect( sceneGroup, "images/chart_dot@3x.png", H*0.015, H*0.015 )
            dotTable[i].x , dotTable[i].y = X*0.1 + i*0.3*X, Y*1.2 
            scrollView:insert( dotTable[i]) 

            lineTable[i] = display.newImageRect( frontGroup, "images/chart_line_vr@3x.png", W*0.0025, H*0.6086 )
            lineTable[i].x , lineTable[i].y = X*0.1 + i*0.3*X, Y*0.61
            -- scrollView:insert( lineTable[i]) 

            -- lineTable[i] = display.newLine( sceneGroup, X*0.1 + i*0.3*X, Y*1.2, X*0.1 + i*0.3*X, Y*0.1 )
            -- scrollView:insert( lineTable[i])
            -- for i = 1,2 do 
                statisticCount()
            -- end 
            chkDb()
        end

        -- display.newCircle( scrollView , dateTable[130].x + 50, Y, 50 )
        --點

        for row in database:nrows([[SELECT * FROM Diary WHERE Date >= ']]..regularPreDate..[[' AND Date <= ']]..today..[[' ORDER BY Date ASC ;]]) do
            wPointNum = wPointNum + 1
            wPointTable[wPointNum] = row.Temperature
        end

        print( regularPreDate )
        print( today )
        for i = 1 , #wPointTable do 
            if wPointTable[i] ~= "" then
                a = a + 1
                -- pointTable[i] = display.newCircle( sceneGroup, lineTable[i+1].x ,  Y*1.2 - ((string.sub( wPointTable[i], 1 , -5 )-small)/(big-small)*Y*1.1), 12 )
                -- pointTable[i]:setFillColor( 0/255, 154/255, 219/255 )
                -- scrollView:insert(pointTable[i])
            -- vTable[i] = display.newText( vGroup, string.format( "%.1f", small + (big-small)*(i-1)/6  )  , X*0.16 , Y*1.78 - i*Y*0.195 , font , H*0.024 )

                pointTable[i] = display.newCircle( backGroup, lineTable[i+1].x ,  Y*1.2 - ((string.sub( wPointTable[i], 1 , -5 )-small)/(big-small)*Y*1.23), H*0.006 )
                pointTable[i]:setFillColor( 145/255, 215/255, 215/255 )
                labelTable[i] = display.newRect( backGroup, pointTable[i].x , pointTable[i].y + Y*0.06, W*0.0933, H*0.024 )
                labelTable[i]:setFillColor( 254/255 , 187/255 , 108/255 )
                labelTable2[i] = display.newText( backGroup , string.sub( wPointTable[i], 1 , -5 ) , pointTable[i].x, pointTable[i].y + Y*0.065, bold , H*0.018 )
                labelTable2[i]:setFillColor( 1 )
                -- scrollView:insert(pointTable[i])
                -- scrollView:insert(labelTable[i])
                -- scrollView:insert(labelTable2[i])

                if a >= 2 then
                    --連線
                    connectLineTable[i] = display.newLine( midGroup, pointTable[prePointNum].x, pointTable[prePointNum].y, pointTable[i].x, pointTable[i].y  )
                    connectLineTable[i]:setStrokeColor( 145/255, 215/255, 215/255 )
                    connectLineTable[i].strokeWidth = H*0.0045
                    -- scrollView:insert(connectLineTable[i])
                    print( prePointNum )
                    
                end
                prePointNum = i
            end
        end


        for i = 1 , #startTable do 
            

            if startTable[i] ~= "" then
               c = c + 1
               print(endTable[c] ..">>>>>>>>days")
               print(0.3*X*endTable[c])
              
                connectPeriodTable[i] = display.newRect( frontGroup, lineTable[i+1].x - X*0.15, -Y*0.01, 0.3*X*endTable[c] , H*0.604  )
                connectPeriodTable[i]:setFillColor( 255/255,11/255,0.1,0.5 )
                connectPeriodTable[i].anchorX = 0
                connectPeriodTable[i].anchorY = 0
                local text = display.newText( frontGroup, "經\n期", lineTable[i+1].x - X*0.07 , Y*0.09 , bold , H*0.02 )
                -- scrollView:insert(connectPeriodTable[i])
                -- scrollView:insert(text)
                 
            end
        end

        scrollView:scrollTo( "right", { time=0 } )
    else
        noDataText = display.newText( vGroup, "尚無紀錄", X, Y , bold , H*0.03 )
        noDataText:setFillColor(0.67)
    end


end

statisticCount = function (  )
    -- sD = tonumber( string.sub( startTable[j], 9 , 10 ) )
    -- sM = tonumber( string.sub( startTable[j], 6 , 7 ) )
    -- sY = tonumber( string.sub( startTable[j], 1 , 4 ) )

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

    preDate = sY.."/"..string.format("%02d",sM).."/"..string.format("%02d",sD)
    -- print( sY.."/"..string.format("%02d",sM).."/"..string.format("%02d",sD) )
end
    
chkDb = function (  )
    for row in database:nrows([[SELECT COUNT(*) FROM Diary WHERE Date = ']]..preDate..[[' ;]]) do
        if row['COUNT(*)'] < 1 then
            writeDb()
            -- print( preDate.."tt" )
        end
    end
end

writeDb = function (  )
    local tablesetup =  [[
                            INSERT INTO Diary VALUES ( NULL , ']]..preDate..[[' , "" , "" , "" , "" , "" , "","" ,"");
                        ]]
    database:exec(tablesetup)
end

weightPlotReset = function (  )
    if scrollView and vGroup  then
        scrollView:removeSelf( )
        -- scrollView = nil 

        vGroup:removeSelf( )
    end
end

temperaturePlotReset = function (  )
    if scrollView and vGroup then
        scrollView:removeSelf( )
        -- scrollView = nil 

        vGroup:removeSelf( )
    end
end

createBtn = function (  )
    createBtnEvent = function ( e )
        if ( "began" == e.phase ) or ( "moved" == e.phase ) then
            e.target:setFillColor( 0.5 )
        elseif ( "ended" == e.phase ) then
            if e.target.id == "temperatureBtn" then 
                if switch ~= "temperature" then
                    
                    weightPlotReset()
                    printTemperaturePlot()
                    -- e.target:setFillColor( 224/255,239/255,215/255 )
                end
                -- temperatureBtn:setFillColor( 224/255,239/255,215/255 )   
                temperatureBtn_press:setFillColor( 224/255,239/255,215/255 )
                weightBtn:setFillColor( 0.99 )  
                weightBtn_press.alpha = 0
                temperatureBtn_press.alpha = 1
                switch = "temperature"
            elseif e.target.id == "weightBtn" then 
                if switch ~= "weight" then
                    temperaturePlotReset()
                    printWeightPlot()
                end
                temperatureBtn:setFillColor( 0.99 )   
                -- weightBtn:setFillColor( 224/255,239/255,215/255 )  
                weightBtn_press.alpha = 1
                temperatureBtn_press.alpha = 0
                switch = "weight"
                weightBtn_press:setFillColor( 224/255,239/255,215/255 )
            end

            
        end    
    end

    temperatureBtn = display.newImageRect( sceneGroup, "images/subtab@3x.png" ,  W*0.5, H*0.08 )
    temperatureBtn.id = "temperatureBtn"
    temperatureBtn.x , temperatureBtn.y  = X*0.5 , Y*0.26 
    temperatureBtn:addEventListener( "touch", createBtnEvent )

    temperatureBtn_press = display.newImageRect( sceneGroup, "images/subtab_active@3x.png" ,  W*0.5, H*0.08 )
    temperatureBtn_press.x , temperatureBtn_press.y  = X*0.5 , Y*0.26 
    temperatureBtn_press.alpha = 1
    temperatureBtn_press:addEventListener( "touch", createBtnEvent )

    temperatureText = display.newText( sceneGroup, "基礎體溫(度C)", X*0.5 , Y*0.26 , bold , H*0.03 )
    -- widget.newButton({ 
    --     x = X*0.5,
    --     y = Y*0.26,
    --     id = "temperatureBtn",
    --     label = "基礎體溫(度C)",
    --     fontSize = H*0.03 ,
    --     font = bold , 
    --     width = W*0.5,
    --     height = H*0.08,
    --     -- shape = "rect",
    --     -- cornerRadius = H*0.018,
    --     -- fillColor = { default={0.7,0.7,0.7,1}, over={0.5,0.5,0.5,1} },
    --     labelColor =  { default={1,1,1,1}, over={1,1,1,1} },

    --     overFile = "images/subtab@3x.png" , 
    --     defaultFile = "images/subtab_active@3x.png" , 
    --     onEvent = createBtnEvent 
    -- })

    weightBtn = display.newImageRect( sceneGroup, "images/subtab@3x.png" ,  W*0.5, H*0.08 )
    weightBtn.id = "weightBtn"
    weightBtn.x , weightBtn.y  = X*1.5 , Y*0.26 
    weightBtn:addEventListener( "touch", createBtnEvent )

    weightBtn_press = display.newImageRect( sceneGroup, "images/subtab_active@3x.png" ,  W*0.5, H*0.08 )
    weightBtn_press.alpha = 0
    weightBtn_press.x , weightBtn_press.y  = X*1.5 , Y*0.26 
    weightBtn_press:addEventListener( "touch", createBtnEvent )

    weightText = display.newText( sceneGroup, "體重(KG)", X*1.5 , Y*0.26 , bold , H*0.03 )

    -- widget.newButton({ 
    --     x = X*1.5,
    --     y = Y*0.26,
    --     id = "weightBtn",
    --     label = "體重(KG)",
    --     fontSize = H*0.03 ,
    --     font = bold , 
    --     width = W*0.5,
    --     height = H*0.08,
    --     -- shape = "rect",
    --     -- cornerRadius = H*0.018,
    --     -- fillColor = { default={0.7,0.7,0.7,1}, over={0.5,0.5,0.5,1} },
    --     labelColor =  { default={1,1,1,1}, over={1,1,1,1} },

    --     overFile = "images/subtab@3x.png" , 
    --     defaultFile = "images/subtab_active@3x.png" , 
    --     onEvent = createBtnEvent 
    -- })

    -- sceneGroup:insert(weightBtn)
    -- sceneGroup:insert(temperatureBtn)
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
    sceneGroup = self.view
    init(sceneGroup)
    -- sceneGroup:insert( frontGroup )
    -- sceneGroup:insert( backGroup )
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
