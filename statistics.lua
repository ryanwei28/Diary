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
local text1
local text2 
local text3 
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
local line 
local noticeText 
local noticeT = "注意：「平均週期」與「平均天數」為前12月之週期平均值，如不足12個月，以實際紀錄之月份數來計算平均天數。"
local product 
local onKeyEvent 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    -- title = display.newText( _parent, "經期資料統計", X, Y*0.2, font , H*0.04 )
    T.bg(sceneGroup)
    T.title("經期資料統計" , sceneGroup)

    text1 = display.newText( _parent, "月經開始日", W*0.294 , H*0.14, bold , H*0.0254 )
    text1:setFillColor( 226/255,68/255,61/255 )

    text2 = display.newText( _parent, "持續天數", W*0.637 , H*0.14, bold , H*0.0254 )
    text2:setFillColor( 226/255,68/255,61/255 )

    text3 = display.newText( _parent, "間隔", W*0.914, H*0.14, bold , H*0.0254 )
    text3:setFillColor( 226/255,68/255,61/255 )

    line = display.newImageRect( sceneGroup , "images/line_dashed@3x.png" ,W*0.805 , H*0.001499 )
    line.x , line.y =  W*0.570, H*0.166

    noticeText = display.newText( sceneGroup, noticeT, X, H*0.79 , W*0.936 , H*0.0853 , bold , H*0.0165 )
    noticeText:setFillColor( 0.56 )

    product = display.newImageRect( sceneGroup, "images/product@3x.png", W*0.114, H*0.129 )
    product.x , product.y = W*0.084 , H*0.199 
    -- back = display.newCircle( _parent, X*0.2, Y*0.2, H*0.04 )
    -- back:addEventListener( "tap", listener )
    T.backBtn(_parent , prevScene)

    scrollView = widget.newScrollView(
        {
            top =H*0.167,
            left = W*0.168 ,
            width = W*0.805,
            height = H*0.556,
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

    Runtime:addEventListener( "key", onKeyEvent )
end

onKeyEvent = function( event )

    -- Print which key was pressed down/up
    local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
    print( message )
 
    -- If the "back" key was pressed on Android, prevent it from backing out of the app
    if (event.phase == "down" and event.keyName == "back") then
        --Here the key was pressed      
        downPress = true
        return true
    else 
        if ( event.keyName == "back" and event.phase == "up" and downPress ) then
            if ( system.getInfo("platform") == "android" ) then
                composer.showOverlay( prevScene )
                Runtime:removeEventListener( "key", onKeyEvent )
                return true
            end
        end
    end
 
    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
    -- This lets the operating system execute its default handling of the key
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
        rowTable[i] = display.newText( sceneGroup , dbData[i].StartDay.."                    "..dbData[i].Continuance.."                        "..dbData[i].Padding , X*0.0133, Y*-0.07 + i*Y*0.16, bold , H*0.0254 )
        rowTable[i]:setFillColor( 0.18 )
        rowTable[i].anchorX = 0
        lineTable[i] = display.newImageRect( sceneGroup , "images/line_dashed@3x.png" ,W*0.9 , H*0.001499 )
        lineTable[i].x , lineTable[i].y =  X*0.8, Y*0 + i*Y*0.16
        -- lineTable[i] = display.newText( sceneGroup , "-------------------------------------------------------------" , X*0.6, Y*-0.03 + i*Y*0.2, font , H*0.032 )
        -- lineTable[i]:setFillColor(0)
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
        Runtime:removeEventListener( "key", onKeyEvent )
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
