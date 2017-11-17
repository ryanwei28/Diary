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
-- print( "2017/10/31" < "2017/11/01" )
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    title = display.newText( _parent, "圖表", X, Y*0.15, font , 50 )


    

    -- for row in database:nrows([[SELECT * FROM Diary ORDER BY Temperature ASC ;]]) do
    --     if row.Temperature ~= "" then
    --         print( row.Temperature.."tt" )
    --     end
    -- end

    -- printPlot()
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
        small = string.sub( wTable[1], 1 , -3 )   
        --上限
        big = string.sub( wTable[wNum], 1 , -3 )   

        --X軸數值
        for i = 1 , 7 do 
            vTable[i] = display.newText( vGroup, string.format( "%.1f", small + (big-small)*(i-1)/6  )  , X*0.16 , Y*1.77 - i*Y*0.18 , font , 30 )
        end

        --Y軸日期
        for i = 1 , 130 do 
            dateTable[i] = display.newText( sceneGroup, string.sub( preDate, 6 ,-1 ).."\n"..string.sub( preDate, 1 ,4 )  , X*0.1 + i*0.3*X, Y*1.35 ,font , 30 )
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
                pointTable[i] = display.newCircle( sceneGroup, lineTable[i+1].x ,  Y*1.2 - ((string.sub( wPointTable[i], 1 , -3 )-small)/(big-small)*Y*1.1), 20 )
                scrollView:insert(pointTable[i])

                if a >= 2 then
                    --連線
                    connectLineTable[i] = display.newLine( sceneGroup, pointTable[prePointNum].x, pointTable[prePointNum].y, pointTable[i].x, pointTable[i].y  )
                    scrollView:insert(connectLineTable[i])
                    print( prePointNum )
                    
                end
                prePointNum = i
            end
        end

        
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

    a = 0


    for row in database:nrows([[SELECT * FROM Diary ORDER BY Temperature ASC ;]]) do
        if row.Temperature ~= "" then
            wNum = wNum + 1
            wTable[wNum] = row.Temperature
            print( row.Temperature.."tt" )
        end
    end

    -- for row in database:nrows([[SELECT * FROM Diary ORDER BY Weight ASC ;]]) do
    --     if row.Weight ~= "" then
    --         wNum = wNum + 1
    --         wTable[wNum] = row.Weight
    --         print( row.Weight.."ww" )
    --     end
    -- end

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
        small = tonumber(string.sub( wTable[1], 1 , -5 ))
        --上限
        big = tonumber( string.sub( wTable[wNum], 1 , -5 ))

        --X軸數值
        for i = 1 , 7 do 
            vTable[i] = display.newText( vGroup, string.format( "%.1f", small + (big-small)*(i-1)/6  )  , X*0.16 , Y*1.77 - i*Y*0.18 , font , 30 )
        end

        --Y軸日期
        for i = 1 , 130 do 
            dateTable[i] = display.newText( sceneGroup, string.sub( preDate, 6 ,-1 ).."\n"..string.sub( preDate, 1 ,4 )  , X*0.1 + i*0.3*X, Y*1.35 ,font , 30 )
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
                pointTable[i] = display.newCircle( sceneGroup, lineTable[i+1].x ,  Y*1.2 - ((string.sub( wPointTable[i], 1 , -3 )-small)/(big-small)*Y*1.1), 20 )
                scrollView:insert(pointTable[i])

                if a >= 2 then
                    --連線
                    connectLineTable[i] = display.newLine( sceneGroup, pointTable[prePointNum].x, pointTable[prePointNum].y, pointTable[i].x, pointTable[i].y  )
                    scrollView:insert(connectLineTable[i])
                    print( prePointNum )
                    
                end
                prePointNum = i
            end
        end

        
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
            print( preDate.."tt" )
        end
    end
end

writeDb = function (  )
    local tablesetup =  [[
                            INSERT INTO Diary VALUES ( NULL , ']]..preDate..[[' , "" , "" , "" , "" , "" , "","");
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
        fontSize = 30 ,
        shape = "roundedRect",
        width = W*0.5,
        height = H*0.08,
        cornerRadius = 20,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = createBtnEvent 
    })

    weightBtn = widget.newButton({ 
        x = X*1.5,
        y = Y*0.3,
        id = "weightBtn",
        label = "體重(kg)",
        fontSize = 30 ,
        shape = "roundedRect",
        width = W*0.5,
        height = H*0.08,
        cornerRadius = 20,
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
