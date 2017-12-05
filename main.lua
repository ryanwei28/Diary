-----------------------------------------------------------------------------------------
--
-- main.lua
--
    -- aa = math.modf(10/3) --取整數 ,3
    -- bb = math.fmod(10,3) --取餘數 ,1
    -- --蔡勒公式 w:星期幾 , y:西元年後兩位 , c: 西元年前兩位 , m:月份 3~14 , 一二月份為隔年13、14月 , d:日
    -- w = math.fmod( ( y + math.modf(y/4) + math.modf(c/4) - 2*c +  math.modf(26*(m+1)/10) + d - 1 ) , 7 )
--     print(os.date(os.time{year=2017,month=03,day=01,hour=17}));  

--     date = 1 
--     print(string.format("%02d", date))

-- actualContentHeight
-- -----------------------------------------------------------------------------------------
X = display.contentCenterX
Y = display.contentCenterY
H = display.contentHeight
W = display.contentWidth 
widget = require("widget")
T = require("T")
composer = require ("composer")
sqlite3 = require "sqlite3"
path = system.pathForFile("data.db", system.DocumentsDirectory)
database = sqlite3.open( path )
display.setStatusBar( display.LightTransparentStatusBar )
bold = "cwTeXHei-zhonly"

local main 
local writeDb
local checkDb
local ttt 

-- local options = {
--     frames =
--     {
--         { x=28, y=28, width=40, height=40 },
--         { x=68, y=28, width=240, height=40 },
--         { x=308, y=28, width=40, height=40 },
--         { x=28, y=68, width=40, height=240 },
--         { x=308, y=68, width=40, height=240 },
--         { x=28, y=308, width=40, height=40 },
--         { x=68, y=308, width=240, height=40 },
--         { x=308, y=308, width=40, height=40 },
--         { x=68, y=68, width=64, height=80 },
--         { x=68, y=228, width=64, height=80 },
--         { x=580, y=28, width=64, height=40 },
--         { x=580, y=148, width=64, height=40 },
--         { x=580, y=228, width=24, height=68 }
--     },
--     sheetContentWidth = 662,  --606
--     sheetContentHeight = 376,  --320
-- }

-- -- display.newRoundedRect( [parent,], x, y, width, height, cornerRadius )
-- pickerWheelSheet = graphics.newImageSheet( "images/picker.png", options )

main = function (  )


    local function onSystemEvent( event )
        if event.type == "applicationExit" then
            database:close()
        end
    end
         

    database:exec([[
                    CREATE TABLE IF NOT EXISTS Diary ( id INTEGER PRIMARY KEY , Date , Start , End , Close , Temperature , Weight , Notes , StartDays ,  Period);
                    CREATE TABLE IF NOT EXISTS Setting ( id INTEGER PRIMARY KEY , Password , Notification , NoticeTime , Plan , Sex , Cycle , regularCycle , During , Height ,Protect, SetSwitch );
                    CREATE TABLE IF NOT EXISTS Statistics ( id INTEGER PRIMARY KEY , StartDay , Continuance , Padding );
                     
                ]])

    checkDb()
    Runtime:addEventListener("system", onSystemEvent)

    composer.gotoScene( "initSetting" )

    local function onKeyEvent( event )
 
        -- Print which key was pressed down/up
        local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
        print( message )
     
        -- If the "back" key was pressed on Android, prevent it from backing out of the app
        if ( event.keyName == "back" ) then
            if ( system.getInfo("platform") == "android" ) then
                return true
            end
        end
     
        -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
        -- This lets the operating system execute its default handling of the key
        return true
    end


    Runtime:addEventListener( "key", onKeyEvent )

end

writeDb = function (  )
    local tablesetup =  [[
                        INSERT INTO Setting VALUES ( NULL , "" , "" , "" , "" , "" ,"" , "" , "" , "" ,"OFF", 1);
                        ]]
                    --     INSERT INTO Diary VALUES( "" , "2017/11/05" , "1" , "" , "" , "" , "" , "" , "");


                    -- ]]
                    -- CREATE TABLE IF NOT EXISTS Diary ( id INTEGER PRIMARY KEY , Data , Start , End , Close , Temperature , Weight , Notes);
    database:exec(tablesetup)
end

checkDb = function (  )
    for row in database:nrows([[SELECT COUNT(*) FROM Setting ]]) do
        rows = row['COUNT(*)']
    end

    if rows < 1 then 
        writeDb()
    end
end


main()