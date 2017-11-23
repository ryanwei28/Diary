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
-- print( "2017/10/31" < "2017/11/01" )
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    title = display.newText( _parent, "圖表", X, Y*0.15, font , H*0.045 )


    

    -- for row in database:nrows([[SELECT * FROM Diary ORDER BY Temperature ASC ;]]) do
    --     if row.Temperature ~= "" then
    --         print( row.Temperature.."tt" )
    --     end
    -- end

    -- printPlot()
    printTemperaturePlot()
        createBtn()
    -- end

end

printWeightPlot = function (  )
    vGroup = display.newGroup( ) 
    sceneGroup:insert(vGroup)
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
    a = 0
    connectPeriodTable = {}
    periodEndTable = {}
    b = 0
    c = 0
    labelTable = {}
    labelTable2 = {}


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


    for row in database:nrows([[SELECT * FROM Diary ORDER BY Weight ASC ;]]) do
        if row.Weight ~= "" then
            wNum = wNum + 1
            wTable[wNum] = row.Weight
            print( row.Weight.."ww" )
        end
    end

    scrollView = widget.newScrollView(
        {
            top = Y*0.4,
            left = X*0.25,
            width = W*0.8,
            height = H*0.7,
            hideBackground = true ,
            scrollWidth = 600,
            scrollHeight = 800,
            verticalScrollDisabled = true , 
            -- listener = scrollListener
        }
    )
 
    sceneGroup:insert(scrollView)
    
    if #wTable >= 2 then
        --下限
        small = string.sub( wTable[1], 1 , -3 ) - string.sub( wTable[1], 1 , -3 )*0.02
        --上限
        big = string.sub( wTable[wNum], 1 , -3 ) + string.sub( wTable[wNum], 1 , -3 )*0.02

        --X軸數值
        for i = 1 , 7 do 
            vTable[i] = display.newText( vGroup, string.format( "%.1f", small + (big-small)*(i-1)/6  )  , X*0.16 , Y*1.77 - i*Y*0.18 , font , H*0.028 )
        end

        --Y軸日期
        for i = 1 , 130 do 
            dateTable[i] = display.newText( sceneGroup, string.sub( preDate, 6 ,-1 ).."\n"..string.sub( preDate, 1 ,4 )  , X*0.1 + i*0.3*X, Y*1.35 ,font , H*0.028 )
            scrollView:insert(dateTable[i])

            lineTable[i] = display.newLine( sceneGroup, X*0.1 + i*0.3*X, Y*1.2, X*0.1 + i*0.3*X, Y*0.1 )
            scrollView:insert( lineTable[i])

            statisticCount()
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
                pointTable[i] = display.newCircle( sceneGroup, lineTable[i+1].x ,  Y*1.2 - ((string.sub( wPointTable[i], 1 , -3 )-small)/(big-small)*Y*1.1), H*0.008 )
                pointTable[i]:setFillColor( 0/255, 154/255, 219/255 )
                labelTable[i] = display.newRect( sceneGroup, pointTable[i].x , pointTable[i].y + Y*0.06, W*0.09, H*0.026 )
                labelTable[i]:setFillColor( 0.72 , 0.45 , 0.62 )
                labelTable2[i] = display.newText( sceneGroup , string.sub( wPointTable[i], 1 , -3 ) , pointTable[i].x, pointTable[i].y + Y*0.06, font , H*0.028 )
                labelTable2[i]:setFillColor( 0.1 )
                scrollView:insert(pointTable[i])
                scrollView:insert(labelTable[i])
                scrollView:insert(labelTable2[i])

                if a >= 2 then
                    --連線
                    connectLineTable[i] = display.newLine( sceneGroup, pointTable[prePointNum].x, pointTable[prePointNum].y, pointTable[i].x, pointTable[i].y  )
                    connectLineTable[i]:setStrokeColor( 0/255, 154/255, 219/255 , 0.5 )
                    connectLineTable[i].strokeWidth = 5
                    scrollView:insert(connectLineTable[i])
                    print( prePointNum )
                    
                end
                prePointNum = i
            end
        end


        for i = 1 , #startTable do 
            

            if startTable[i] ~= "" then
               c = c + 1
               print(endTable[c] ..">>>>>>>>days")
              
                connectPeriodTable[i] = display.newRect( sceneGroup, lineTable[i+1].x - X*0.15, Y*0.1, 0.3*X*endTable[c] , H*0.55  )
                connectPeriodTable[i]:setFillColor( 0.35,0.81,0.1,0.1 )
                connectPeriodTable[i].anchorX = 0
                connectPeriodTable[i].anchorY = 0
                local text = display.newText( sceneGroup, "經\n期", lineTable[i+1].x - X*0.1 , Y*0.15 , font , H*0.02 )
                scrollView:insert(connectPeriodTable[i])
                scrollView:insert(text)
            end
        end

        scrollView:scrollTo( "right", { time=0 } )
        
    else 
        noDataText = display.newText( vGroup, "尚無資料", X, Y , font , H*0.05 )
    end
end

printTemperaturePlot = function (  )
    vGroup = display.newGroup( ) 
    sceneGroup:insert(vGroup)
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
            top = Y*0.4,
            left = X*0.25,
            width = W*0.8,
            height = H*0.7,
            hideBackground = true ,
            scrollWidth = 600,
            scrollHeight = 800,
            verticalScrollDisabled = true , 
            -- listener = scrollListener
        }
    )
 
    sceneGroup:insert(scrollView)
    
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
        --下限
        small = tonumber(string.sub( wTable[1], 1 , -5 )) - tonumber(string.sub( wTable[1], 1 , -5 ))*0.02
        --上限
        big = tonumber( string.sub( wTable[wNum], 1 , -5 )) + tonumber( string.sub( wTable[wNum], 1 , -5 ))*0.02

        --X軸數值
        for i = 1 , 7 do 
            vTable[i] = display.newText( vGroup, string.format( "%.1f", small + (big-small)*(i-1)/6  )  , X*0.16 , Y*1.77 - i*Y*0.18 , font , H*0.028 )
        end

        --Y軸日期
        for i = 1 , 130 do 
            dateTable[i] = display.newText( sceneGroup, string.sub( preDate, 6 ,-1 ).."\n"..string.sub( preDate, 1 ,4 )  , X*0.1 + i*0.3*X, Y*1.35 ,font , H*0.028 )
            scrollView:insert(dateTable[i])

            lineTable[i] = display.newLine( sceneGroup, X*0.1 + i*0.3*X, Y*1.2, X*0.1 + i*0.3*X, Y*0.1 )
            scrollView:insert( lineTable[i])

            statisticCount()
            chkDb()
        end

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

                pointTable[i] = display.newCircle( sceneGroup, lineTable[i+1].x ,  Y*1.2 - ((string.sub( wPointTable[i], 1 , -5 )-small)/(big-small)*Y*1.1), H*0.008 )
                pointTable[i]:setFillColor( 0/255, 154/255, 219/255 )
                labelTable[i] = display.newRect( sceneGroup, pointTable[i].x , pointTable[i].y + Y*0.06, W*0.12, H*0.026 )
                labelTable[i]:setFillColor( 0.72 , 0.45 , 0.62 )
                labelTable2[i] = display.newText( sceneGroup , string.sub( wPointTable[i], 1 , -5 ) , pointTable[i].x, pointTable[i].y + Y*0.06, font , H*0.04 )
                labelTable2[i]:setFillColor( 0.1 )
                scrollView:insert(pointTable[i])
                scrollView:insert(labelTable[i])
                scrollView:insert(labelTable2[i])
                if a >= 2 then
                    --連線
                    connectLineTable[i] = display.newLine( sceneGroup, pointTable[prePointNum].x, pointTable[prePointNum].y, pointTable[i].x, pointTable[i].y  )
                    connectLineTable[i]:setStrokeColor( 0/255, 154/255, 219/255 )
                    connectLineTable[i].strokeWidth = 5
                    scrollView:insert(connectLineTable[i])
                    print( prePointNum )
                    
                end
                prePointNum = i
            end
        end


        for i = 1 , #startTable do 
            

            if startTable[i] ~= "" then
               c = c + 1
               print(endTable[c] ..">>>>>>>>days")
              
                connectPeriodTable[i] = display.newRect( sceneGroup, lineTable[i+1].x - X*0.15, Y*0.1, 0.3*X*endTable[c] , H*0.55  )
                connectPeriodTable[i]:setFillColor( 0.35,0.81,0.1,0.1 )
                connectPeriodTable[i].anchorX = 0
                connectPeriodTable[i].anchorY = 0
                local text = display.newText( sceneGroup, "經\n期", lineTable[i+1].x - X*0.1 , Y*0.15 , font , H*0.02 )
                scrollView:insert(connectPeriodTable[i])
                scrollView:insert(text)
            end
        end

        scrollView:scrollTo( "right", { time=0 } )
    else
        noDataText = display.newText( vGroup, "尚無資料", X, Y , font , H*0.058 )
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
        if ( "ended" == e.phase ) then
            if e.target.id == "temperatureBtn" then 
                if switch ~= "temperature" then
                    
                    weightPlotReset()
                    printTemperaturePlot()
                end
                temperatureBtn:setFillColor( 0.92,0.12,0.45,1 )   
                weightBtn:setFillColor( 0.3,0.28,0.75,0.4 )  
                switch = "temperature"
            elseif e.target.id == "weightBtn" then 
                if switch ~= "weight" then
                    temperaturePlotReset()
                    printWeightPlot()
                end
                temperatureBtn:setFillColor( 0.3,0.28,0.75,0.4 )   
                weightBtn:setFillColor( 0.92,0.12,0.45,1 )  
                switch = "weight"
            end
        end    
    end

    temperatureBtn = widget.newButton({ 
        x = X*0.5,
        y = Y*0.3,
        id = "temperatureBtn",
        label = "基礎體溫(度C)",
        fontSize = H*0.025 ,
        shape = "roundedRect",
        width = W*0.5,
        height = H*0.08,
        cornerRadius = H*0.018,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = createBtnEvent 
    })

    weightBtn = widget.newButton({ 
        x = X*1.5,
        y = Y*0.3,
        id = "weightBtn",
        label = "體重(kg)",
        fontSize = H*0.025 ,
        shape = "roundedRect",
        width = W*0.5,
        height = H*0.08,
        cornerRadius = H*0.018,
        fillColor = { default={0.3,0.28,0.75,0.4}, over={0.2,0.78,0.75,0.4} },
        onEvent = createBtnEvent 
    })

    sceneGroup:insert(weightBtn)
    sceneGroup:insert(temperatureBtn)
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
