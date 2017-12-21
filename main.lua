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

local launchArgs = ...

notifications = require( "plugin.notifications" )
widget = require("widget")
T = require("T")
notificationSet = require("notificationSet")
composer = require ("composer")
sqlite3 = require "sqlite3"
path = system.pathForFile("data.db", system.DocumentsDirectory)
database = sqlite3.open( path )
display.setStatusBar( display.LightTransparentStatusBar )
bold = "NotoSansCJKtc-Medium"

local main 
local writeDb
local checkDb
local ttt 
local opendoor
local downloadImg 
local networkListener
local onSystemEvent2
platform = system.getInfo( "platform" )


main = function (  )
    
    local function onSystemEvent( event )
        if event.type == "applicationExit" then
            database:close()
        end
    end
         

    database:exec([[
                    CREATE TABLE IF NOT EXISTS Diary ( id INTEGER PRIMARY KEY , Date , Start , End , Close , Temperature , Weight , Notes , StartDays ,  Period);
                    CREATE TABLE IF NOT EXISTS Setting ( id INTEGER PRIMARY KEY , Password , Notification , NoticeTime , Plan , Sex , Cycle , regularCycle , During , Height ,Protect, SetSwitch , NotifyTime);
                    CREATE TABLE IF NOT EXISTS Statistics ( id INTEGER PRIMARY KEY , StartDay , Continuance , Padding );
                    CREATE TABLE IF NOT EXISTS Notifications ( id INTEGER PRIMARY KEY , NotifyDate , UTCTime , RandomId ,Type );
                     
                ]])

    checkDb()
    Runtime:addEventListener("system", onSystemEvent)


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


    function notificationListener( event )
        if event.custom == nil then
            local json = require("json")
            print("Notification listener unknown event: ", json.prettify(event))
            return
        end

        print( "Notification Listener event:" )

        local maxStr = 20       -- set maximum string length
        local endStr


        if ( event.custom ) then
            print( event.custom.id )
            -- native.showAlert( "Girl's Diary", launchArgs.notification.alert, { "OK" } )
            -- notifications.cancelNotification( notificationIDtable[event.custom.id] )
            -- system.cancelNotification( notificationIDtable[event.custom.id] )

        end

        -- native.setProperty( "applicationIconBadgeNumber", 0 )

    end
    

    Runtime:addEventListener( "notification", notificationListener )

     

    Runtime:addEventListener( "key", onKeyEvent )

    downloadImg("banner.jpg","http://design.unidyna.com/ryan/banner.jpg")
    downloadImg("hotnews1.jpg","http://design.unidyna.com/ryan/hotnews1.jpg")
    downloadImg("hotnews2.jpg","http://design.unidyna.com/ryan/hotnews2.jpg")

    opendoor = display.newImageRect( "images/opendoor.png", W, H ) 
    opendoor.x , opendoor.y = X , Y 

    timer.performWithDelay( 500, function (  )
        transition.to( opendoor , {time = 100 , alpha = 0 , onComplete = function (  )
            composer.gotoScene( "initSetting" )

        end} )
    end  )
    


 
    -- Set up a system event listener
    Runtime:addEventListener( "system", onSystemEvent2 )

        
    if launchArgs and launchArgs.notification then
            
        native.showAlert( "Girl's Diary", launchArgs.notification.alert, { "OK" } )
        
        -- Need to call the notification listener since it won't get called if the
        -- the app was already closed.
        notificationListener( launchArgs.notification )
    end
end


onSystemEvent2 = function( event )
    if ( event.type == "applicationResume" ) then
        for row in database:nrows([[SELECT * FROM Setting WHERE id = 1]]) do
            if row.Password ~= "" then 
                composer.gotoScene( "enterPassword" )
            end
        end 
        -- T.alert("noDay")
    end
end

downloadImg = function ( filename , url )
    local params = {}
     
    -- Tell network.request() that we want the "began" and "progress" events:
    params.progress = "download"
     
    -- Tell network.request() that we want the output to go to a file:
    params.response = {
        filename = filename,
        baseDirectory = system.DocumentsDirectory
    }
      
    network.request( url , "GET", networkListener,  params )
end


networkListener = function( event )
    if ( event.isError ) then
        print( "Network error: ", event.response )
 
    elseif ( event.phase == "began" ) then
        if ( event.bytesEstimated <= 0 ) then
            print( "Download starting, size unknown" )
        else
            print( "Download starting, estimated size: " .. event.bytesEstimated )
        end
 
    elseif ( event.phase == "progress" ) then
        if ( event.bytesEstimated <= 0 ) then
            print( "Download progress: " .. event.bytesTransferred )
        else
            print( "Download progress: " .. event.bytesTransferred .. " of estimated: " .. event.bytesEstimated )
        end
         
    elseif ( event.phase == "ended" ) then
       
        print( "Download complete, total bytes transferred: " .. event.bytesTransferred )

        -- display.newImageRect( sceneGroup, "corona.jpg", system.DocumentsDirectory , W, H*0.3 )
    end
end


writeDb = function (  )
    local tablesetup =  [[
                        INSERT INTO Setting VALUES ( NULL , "" , "ON" , "" , "想避孕" , "男生" ,"" , "" , "" , "" ,"OFF", 1 , "09:00 上午");
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