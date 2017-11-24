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
local prevScene = composer.getVariable( "prevScene" )
local text
local readDb 
local dbData = {}
local dataNum = 0
local rowTable = {}
local scrollView
local lineTable = {}

local sY = 2017
local sD = 01 
local sM = 10
local sDate = sY.."/"..sM.."/"..sD 
local statisticCount
local daysTable = { 31 ,28 ,31 ,30 ,31 ,30 ,31 ,31 ,30 ,31 ,30 ,31 ,31 ,28}
local fourSqrare
local square1
local square2
local square3
local square4
local sText1
local sText2
local sText3
local sText4
local sText1Year 
local sText2Year
local tText1
local tText2
local tText3
local tText4 
local last 
local duringDays = 0
local duringNum = 0
local paddingDays = 0
local paddingNum = 0
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    -- title = display.newText( _parent, "經期資料統計", X, Y*0.2, font , H*0.04 )
    T.title("經期資料統計" , sceneGroup)

    text = display.newText( _parent, "月經開始日    持續天數    間隔", X*1.1, Y*0.4, font , H*0.031 )
    text:setFillColor( 0.885 , 0.323,0.241 )


    back = display.newCircle( _parent, X*0.2, Y*0.2, H*0.04 )
    back:addEventListener( "tap", listener )


    scrollView = widget.newScrollView(
        {
            top = X*0.8,
            left = X*0.2,
            width = W*0.85,
            height = H*0.5,
            hideBackground = true ,
            scrollWidth = 600,
            scrollHeight = 800,
            horizontalScrollDisabled = true 
            -- listener = scrollListener
        }
    )
 
    -- Create a image and insert it into the scroll view
    -- local background = display.newRect( _parent, X, Y, W*0.8, H*0.7 )
    -- scrollView:insert( background )
    _parent:insert(scrollView)

    readDb()
    createRows()

   

    -- for j = 1 , 8 do   
    --     print( "sDateeeeeeeeee:"..sDate )
    --     database:exec([[UPDATE Diary SET StartDays = ']]..j..[[' WHERE date =']]..sDate..[[';]])
    --     statisticCount()
    --     -- sD = string.sub( startTable[i], 9 , 10 )
    --     -- print( sD )
    --     -- print( i..j )
    -- end

    fourSqrare()
end

fourSqrare = function (  )
    square1 = display.newRect( sceneGroup, X*0.25, Y*1.7, W*0.25, H*0.15 )
    square1:setFillColor( 0.92,0.3,0.41 )
    square2 = display.newRect( sceneGroup, X*0.75, Y*1.7, W*0.25, H*0.15 )
    square2:setFillColor( 0.3,0.93,0.41 )
    square3 = display.newRect( sceneGroup, X*1.25, Y*1.7, W*0.25, H*0.15 )
    square3:setFillColor( 0.92,0.83,0.41 )
    square4 = display.newRect( sceneGroup, X*1.75, Y*1.7, W*0.25, H*0.15 )
    square4:setFillColor( 0.1,0.3,0.841 )

    tText1 = display.newText( sceneGroup, "上次月經開始", square1.x , Y*1.82 , native.systemFontBold , H*0.02 )
    tText2 = display.newText( sceneGroup, "下次月經預測", square2.x , Y*1.82 , native.systemFontBold , H*0.02 )
    tText3 = display.newText( sceneGroup, "平均週期", square3.x , Y*1.82 , native.systemFontBold , H*0.02 )
    tText4 = display.newText( sceneGroup, "平均天數", square4.x , Y*1.82 , native.systemFontBold , H*0.02 )
    sText1 = display.newText( sceneGroup, "", square1.x , Y*1.75 , native.systemFontBold , H*0.05 )
    sText1Year = display.newText( sceneGroup, "", square1.x , Y*1.65 , native.systemFontBold , H*0.047 )
    sText2 = display.newText( sceneGroup, "", square2.x , Y*1.75 , native.systemFontBold , H*0.05 )
    sText2Year = display.newText( sceneGroup, "", square2.x , Y*1.65 , native.systemFontBold , H*0.047 )
    sText3 = display.newText( sceneGroup, "", square3.x , Y*1.75 , native.systemFontBold , H*0.07 )
    sText3Day = display.newText( sceneGroup, "天", square3.x + X*0.13 , Y*1.75 , native.systemFontBold , H*0.02 )
    sText4 = display.newText( sceneGroup, "", square4.x , Y*1.75 , native.systemFontBold , H*0.07 )
    sText4Day = display.newText( sceneGroup, "天", square4.x + X*0.13 , Y*1.75 , native.systemFontBold , H*0.02 )

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

         for row in database:nrows([[SELECT * FROM Statistics ;]]) do
            paddingDays = paddingDays + row.Padding
            paddingNum = paddingNum + 1
        end

        for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
            sText3.text = row.Cycle
        end

        if paddingNum > 1 then
            sText3.text = string.format("%d" , paddingDays/(paddingNum-1) )
        end 

        for row in database:nrows([[SELECT * FROM Statistics ;]]) do
            duringDays = duringDays + row.Continuance
            duringNum = duringNum + 1
        end

        sText4.text = string.format("%d" , duringDays/duringNum )
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

    sDate = sY.."/"..string.format("%02d",sM).."/"..string.format("%02d",sD)
    -- print( sY.."/"..string.format("%02d",sM).."/"..string.format("%02d",sD) )
end

listener = function ( e )
    composer.showOverlay( prevScene )
end

readDb = function (  )
    for row in database:nrows([[SELECT COUNT(*) FROM Statistics ]]) do
        rows = row['COUNT(*)']
    end

    print( rows.."rows" )

    for row in database:nrows([[SELECT * FROM Statistics ORDER BY StartDay ASC ;]]) do
        dataNum = dataNum + 1
        dbData[dataNum] = {}
        dbData[dataNum].StartDay = row.StartDay
        dbData[dataNum].Continuance = row.Continuance
        dbData[dataNum].Padding = row.Padding
        print( row.StartDay..row.Continuance )
    end
end

createRows = function (  )
    for i = 1 , rows do 
        rowTable[i] = display.newText( sceneGroup , dbData[i].StartDay.."             "..dbData[i].Continuance.."            "..dbData[i].Padding , X*0.1, Y*-0.1 + i*Y*0.2, font , H*0.032 )
        rowTable[i]:setFillColor( 0.8 )
        rowTable[i].anchorX = 0
        lineTable[i] = display.newText( sceneGroup , "-------------------------------------------------------------" , X*0.6, Y*-0.03 + i*Y*0.2, font , H*0.032 )
        scrollView:insert( rowTable[i] )
        scrollView:insert( lineTable[i] )
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
