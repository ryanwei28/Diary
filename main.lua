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

local main 
local writeDb
local checkDb
local ttt 

main = function (  )
    local function onSystemEvent( event )
        if event.type == "applicationExit" then
            database:close()
        end
    end
         

    database:exec([[
                    CREATE TABLE IF NOT EXISTS Diary ( id INTEGER PRIMARY KEY , Date , Start , End , Close , Temperature , Weight , Notes , StartDays);
                    CREATE TABLE IF NOT EXISTS Setting ( id INTEGER PRIMARY KEY , Password , Notification , NoticeTime , Plan , Sex , Cycle , During , Height ,Protect);
                    CREATE TABLE IF NOT EXISTS Statistics ( id INTEGER PRIMARY KEY , StartDay , Continuance , Padding );
                     
                ]])

    checkDb()
    Runtime:addEventListener("system", onSystemEvent)

    composer.gotoScene( "enterPassword" )

     -- local tablesetup =  [[
     --                    INSERT INTO Diary VALUES ( NULL , "" ,  , "End" , "Close" , "Temperature" , "Weight" , "Notes");
     --                ]]
     --                -- CREATE TABLE IF NOT EXISTS Diary ( id INTEGER PRIMARY KEY , Data , Start , End , Close , Temperature , Weight , Notes);

     --        database:exec(tablesetup)

    -- print( ttt("04/23/2015 17:43:12" , "04/25/2015 17:43:12") )
end

writeDb = function (  )
    local tablesetup =  [[
                        INSERT INTO Setting VALUES ( NULL , "" , "" , "" , "" , "" , "" , "5" , "" ,"OFF");
                    ]]
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