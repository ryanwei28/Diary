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

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    title = display.newText( _parent, "經期資料統計", X, Y*0.2, font , 50 )

    text = display.newText( _parent, "月經開始日    持續天數    間隔", X*1.1, Y*0.4, font , 40 )
    text:setFillColor( 0.885 , 0.323,0.241 )


    back = display.newCircle( _parent, X*0.2, Y*0.2, 50 )
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
            -- listener = scrollListener
        }
    )
 
    -- Create a image and insert it into the scroll view
    -- local background = display.newRect( _parent, X, Y, W*0.8, H*0.7 )
    -- scrollView:insert( background )
    _parent:insert(scrollView)

    readDb()
    createRows()

   

    for j = 1 , 8 do 
                
                print( "sDateeeeeeeeee:"..sDate )
                database:exec([[UPDATE Diary SET StartDays = ']]..j..[[' WHERE date =']]..sDate..[[';]])
                statisticCount()
                -- sD = string.sub( startTable[i], 9 , 10 )
                -- print( sD )
                -- print( i..j )
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

    for row in database:nrows([[SELECT * FROM Statistics ]]) do
        dataNum = dataNum + 1
        dbData[dataNum] = {}
        dbData[dataNum].StartDay = row.StartDay
        dbData[dataNum].Continuance = row.Continuance
        print( row.StartDay..row.Continuance )
    end
end

createRows = function (  )
    for i = 1 , rows do 
        rowTable[i] = display.newText( sceneGroup , dbData[i].StartDay.."             "..dbData[i].Continuance , X*0.6, Y*-0.1 + i*Y*0.2, font , 40 )
        rowTable[i]:setFillColor( 0.8 )
        lineTable[i] = display.newText( sceneGroup , "-------------------------------------------------------------" , X*0.6, Y*-0.03 + i*Y*0.2, font , 40 )
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
