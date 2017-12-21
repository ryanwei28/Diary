local M = {}

function M.init()
	print("MMMMMMMMMMM")
end

function M.tabBar(  )

    local function handleTabBarEvent ( event )
        composer.hideOverlay()
        if event.target.id == "daily_calendar" then
            composer.showOverlay( "daily_calendar", overlayOptions )
            print(1 )  -- Reference to button's 'id' parameter
        elseif event.target.id == "monthly_calendar" then
            composer.showOverlay( "monthly_calendar", overlayOptions )
            print(2 )
        elseif event.target.id == "chart" then
            composer.showOverlay( "chart", overlayOptions )
            print(3 )
        elseif event.target.id == "hotNews" then
            -- composer.hideOverlay( "DrDIY")
            composer.showOverlay( "hotNews", overlayOptions )

            print(4 )
        elseif event.target.id == "DrDIY" then
            composer.showOverlay( "DrDIY", overlayOptions )
            print(5 )
        end
    end 


    local tabButtons = {
        {
            label = "",
            id = "daily_calendar",
            defaultFile = "images/tab_day@3x.png" , 
            overFile = "images/tab_day_press@3x.png" , 
            width = W*0.2, 
            height = H*0.078,
            selected = true,
            size = tabFontSize,
            onPress = handleTabBarEvent
        },
        {
            label = "",
            id = "monthly_calendar",
            defaultFile = "images/tab_month@3x.png" , 
            overFile = "images/tab_month_press@3x.png" , 
            width = W*0.2, 
            height = H*0.078,
            size = tabFontSize,
            onPress = handleTabBarEvent
        },
        {
            label = "",
            id = "chart",
            defaultFile = "images/tab_chart@3x.png" , 
            overFile = "images/tab_chart_press@3x.png" , 
            width = W*0.2, 
            height = H*0.078,
            size = tabFontSize,
            onPress = handleTabBarEvent
        },
         {
            label = "",
            id = "hotNews",
            defaultFile = "images/tab_news@3x.png" , 
            overFile = "images/tab_news_press@3x.png" , 
            width = W*0.2, 
            height = H*0.078,
            size = tabFontSize,
            onPress = handleTabBarEvent
        },
         {
            label = "",
            id = "DrDIY",
            defaultFile = "images/tab_diy@3x.png" , 
            overFile = "images/tab_diy_press@3x.png" , 
            width = W*0.2, 
            height = H*0.078,
            size = tabFontSize,
            onPress = handleTabBarEvent ,
            -- labelColor = { default={ 0.95, 1, 1 }, over={ 0.12, 0, 0, 0.5 } } ,
             fillColor = { default={ 0.852, 0.2, 0.5, 0.7 }, over={ 0.14, 0.2, 0.5, 1 } }

        },
    }
     
    -- Create the widget
    local tabBar = widget.newTabBar(
        {
            top = H-H*0.078,
            left = 0 , 
            width = W+1,
            height =  H*0.078 , 
            buttons = tabButtons ,
            labelColor = { default={ 0.95, 1, 1 }, over={ 0.12, 0, 0, 0.5 } } ,
            fillColor = { default={ 0.852, 0.2, 0.5, 0.7 }, over={ 0.14, 0.2, 0.5, 1 } }
        }
    )

    -- sceneGroup:insert(tabBar)
       

end



function M.backBtn( sceneGroup , prevScene )
    
    function backBtnListener( e )
        if e.phase == "ended" then
            composer.showOverlay( prevScene )
        end
    end

    local backBtn = widget.newButton({
        label = "",
        onEvent = backBtnListener,
        left = W*0.032 ,
        top = H*0.035, 
        shape = "rect",
        width = W*0.1,
        height = H*0.06,
        fontSize = H*0.05 ,
        -- font = bold ,
        fillColor = { default={254/255,118/255,118/255,0.1}, over={1,0.1,0.7,0} },
        -- labelColor = { default={ 1, 1, 1 }, over={ 0.7, 0.7, 0.7 } }
        -- } )
        -- defaultFile = "images/nav_back@3x.png" , 
        -- overFile = "" , 
        })

    local backBtnImg = display.newImageRect( sceneGroup, "images/nav_back@3x.png", W*0.032, H*0.036 )
    backBtnImg.x , backBtnImg.y = W*0.032 , H*0.05 
    backBtnImg.anchorX , backBtnImg.anchorY = 0 , 0

    sceneGroup:insert( backBtn)
end

function M.bg( group )
    local bg = display.newImageRect( group, "images/bg_dot@3x.png", W, H )
    bg.x , bg.y = X , Y*1.07
end

function M.title( titleText , group )
    local titleBg = display.newImageRect( group, "images/bg_top@3x.png", W, H*0.07 )
    titleBg.x , titleBg.y ,titleBg.anchorY= X, Y*0.07 , 0
    -- print(X)
    local titleText = display.newText( group , titleText , X, Y*0.14, bold , H*0.032 )
end

function M.alert( alertType )
    function onCompleteee( event )
        if ( event.action == "clicked" ) then
            local i = event.index
            if ( i == 1 ) then
                -- Do nothing; dialog will simply dismiss
            elseif ( i == 2 ) then
                -- Open URL if "Learn More" (second button) was clicked
            end
        end
    end
  
    if alertType == "already" then
        local alert = native.showAlert( "","今天是月經期，無法新增為月經開始日", { "OK" }, onCompleteee )
    elseif alertType == "firstDay" then
        local alert = native.showAlert( "","月經開始日不可同時為月經結束日", { "OK" }, onCompleteee )
    elseif alertType == "future" then
        local alert = native.showAlert( "","無法記錄未來日子", { "OK" }, onCompleteee )
    elseif alertType == "tooClose" then
        local alert = native.showAlert( "","與下次月經開始日太接近，請確認日期", { "OK" }, onCompleteee )
    elseif alertType == "noStart" then
        local alert = native.showAlert( "","請先建立一筆經期開始資料", { "OK" }, onCompleteee )
    elseif alertType == "notToday" then
        local alert = native.showAlert( "","如經期非於本日結束，請直接於結束當天標記", { "OK" }, onCompleteee )
    elseif alertType == "next" then
        local alert = native.showAlert( "","請輸入完整三筆資料", { "OK" }, onCompleteee )
    elseif alertType == "noDay" then
        local alert = native.showAlert( "","無此日期", { "OK" }, onCompleteee )    
    end
end

function M.writeData ( content )
    -- Path for the file to read
    local path = system.pathForFile( "login.txt", system.DocumentsDirectory )
     
    -- Open the file handle
    local file, errorString = io.open( path, "w" )
     
    if not file then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
    else
    	-- local s = tostring(content)
        file:write(content)
        -- Output lines
        -- for line in file:lines() do
        --     print( line )
        -- end
        -- Close the file handle
        io.close( file )
    end
     
    file = nil
end

--print table 
function M.print_r( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end 


function M.statisticCount ()

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
        sM = sM + 1 
        if sM > 12 then 
            sM = 1 
            sY = sY + 1 
        end
    end

    sDate = sY.."/"..string.format("%02d",sM).."/"..string.format("%02d",sD)
end

function M.caculateDays( eDay , sDay )
    local e = os.date(os.time{year=string.sub(eDay , 1 , 4) ,month=string.sub(eDay , 6 , 7),day=string.sub(eDay , 9 , 10)})
    local s = os.date(os.time{year=string.sub(sDay , 1 , 4) ,month=string.sub(sDay , 6 , 7),day=string.sub(sDay , 9 , 10)})

    local days = (tonumber(e-s)/24/60/60) 

    return days 
end

function M.addDays( sDay , days )
    -- local e = os.date(os.time{year=string.sub(eDay , 1 , 4) ,month=string.sub(eDay , 6 , 7),day=string.sub(eDay , 9 , 10)})
    local s = os.date(os.time{year=string.sub(sDay , 1 , 4) ,month=string.sub(sDay , 6 , 7),day=string.sub(sDay , 9 , 10)})
    -- local days = (tonumber(e-s)/24/60/60) 
    local e = days*24*60*60 + s 
    local eDay = os.date("%Y", e).."/"..os.date("%m", e).."/"..os.date("%d", e)

    return eDay
end


function M.minusDays( eDay , days )
    local e = os.date(os.time{year=string.sub(eDay , 1 , 4) ,month=string.sub(eDay , 6 , 7),day=string.sub(eDay , 9 , 10)})
    -- local s = os.date(os.time{year=string.sub(sDay , 1 , 4) ,month=string.sub(sDay , 6 , 7),day=string.sub(sDay , 9 , 10)})
    -- local days = (tonumber(e-s)/24/60/60) 
    local s = e - days*24*60*60  
    local sDay = os.date("%Y", s).."/"..os.date("%m", s).."/"..os.date("%d", s)

    return sDay
end

local pickerOptions = {
    frames =
    {
        { x=28, y=28, width=40, height=40 },
        { x=68, y=28, width=240, height=40 },
        { x=308, y=28, width=40, height=40 },
        { x=28, y=68, width=40, height=240 },
        { x=308, y=68, width=40, height=240 },
        { x=28, y=308, width=40, height=40 },
        { x=68, y=308, width=240, height=40 },
        { x=308, y=308, width=40, height=40 },
        { x=68, y=68, width=64, height=80 },
        { x=68, y=228, width=64, height=80 },
        { x=570, y=28, width=64, height=18 },
        { x=570, y=168, width=64, height=19 },
        { x=580, y=228, width=24, height=68 }
    },
    sheetContentWidth = 662,  --606
    sheetContentHeight = 376,  --320
}

-- display.newRoundedRect( [parent,], x, y, width, height, cornerRadius )
M.pickerWheelSheet = graphics.newImageSheet( "images/picker@3x.png", pickerOptions )

M.options = {
    --  -- isModal = true,
    -- effect = "fade",
    -- time = 400,
}


adImgData = {
    -- { defaultFile = "images/mailPackage.png"} , 
    --  { defaultFile = "images/mailPackage.png"} , 
}
--產生廣告幻燈片 x , y 為廣告群組位置 , adImgData：廣告圖片table,table內有幾張圖片就會產生幾則廣告 , sceneGroup：指示器群組 , 滑動功能開啟
function M.creatAdWall( x , y , adImgData , sceneGroup , openSlide)
    local adGroup = display.newGroup( )
    local adDisplacement = W*0.5  --廣告輪播位移量
    local count = 0
    local imgNum = 1 --目前顯示圖片編號
    local tabBtn = {}
    local indicateGrp = display.newGroup()
    local img = {}
    local beganStart = false
    local adId
    
    -- local openSlide


    local function requestCallback(event)
        print("resquestCallBack")
        if (event.isError) then
            print("Network error")
        else
            print( "RESPONSE" .. event.response )
            local data = json.decode(event.response)
            --print(data)
            if (data['RetCode'] == 1) then
                --請求成功
                print("點擊廣告" , adId)
            else
                --請求失敗
                print( "Msg:" .. data["Msg"] )
            end
        end

        return true
    end

    --計時位移涵式
    local function adTimerStart(  )
        print("adTimer")
        adTimer = timer.performWithDelay( 6000 , function (  )
            adDisplacement = adDisplacement - W
            transition.to( adGroup , {time = 200 , x = adDisplacement} )
             -- print( "ad:" , adGroup.x )
             count = count + 1 
             imgNum = imgNum + 1 
            if count == 3 then
                img[#img+1] = img[1] 
                img[1].x = img[#img-1].x + W
                table.remove( img , 1 )
                count = 2
            end             

            if ( imgNum == #adImgData + 1 ) then
                imgNum = 1
            end

            for i = 1 , #adImgData do 
                tabBtn[i].alpha = 0.5 
                tabBtn[imgNum].alpha = 1 
            end
        end , -1 )
    end

    --滑動圖片產生動作涵式
    function adBottonListener( e )

        local phase = e.phase
        local obj = e.target
        if (phase == "began") then 
            beganStart = true
            if (openSlide == true )then
                obj.OldX = adGroup.x
                -- if (adTimer) then
                --     timer.cancel( adTimer )
                -- end
                display.getCurrentStage():setFocus( e.target )
            end
        elseif (phase == "moved") then 
            if (beganStart == true ) then
                dx = 0
                dx = e.x - e.xStart
                if (openSlide == true )then
                    adGroup.x = obj.OldX + dx 
                end
            end
        elseif  ( phase == "ended" or phase == "cancelled") then
            if (beganStart == true) then
                if (openSlide == true )then
                    -- adTimerStart()
                    display.getCurrentStage():setFocus( nil )
                end
                 --往右拉
                if (dx ) and ( dx > 20 ) then 
                    if (openSlide == true )then
                        adDisplacement = adDisplacement + W
                        transition.to( adGroup , {time = 200 , x = adDisplacement} )
                        count = count - 1 
                        imgNum = imgNum - 1 

                        if count == -1 then
                            table.insert( img , 1 , img[#img] ) 
                            img[#img].x = img[2].x - W*1
                            table.remove( img , #img )
                            count = 0
                        end  

                        if ( imgNum == 0 ) then
                            imgNum = #adImgData
                        end

                        for i = 1 , #adImgData do 
                            tabBtn[i].alpha = 0.5 
                            tabBtn[imgNum].alpha = 1
                        end

                        dx = 0
                    end
                --往佐拉
                elseif ( dx ) and ( dx < -20 ) then 
                    if (openSlide == true )then
                        adDisplacement = adDisplacement - W
                        transition.to( adGroup , {time = 200 , x = adDisplacement} )
                         -- print( "ad:" , adGroup.x )
                         count = count + 1 
                         imgNum = imgNum + 1 
                        if count == 3 then
                            img[#img+1] = img[1] 
                            img[1].x = img[#img-1].x + W*1
                            table.remove( img , 1 )
                            count = 2
                        end             

                        if ( imgNum == #adImgData + 1 ) then
                            imgNum = 1
                        end

                        for i = 1 , #adImgData do 
                            tabBtn[i].alpha = 0.5 
                            tabBtn[imgNum].alpha = 1
                        end

                        dx = 0
                    end
                else
                    -- composer.setVariable( "websiteName" , contentMI[e.target.id].title )
                    -- composer.setVariable( "url" , contentMI[e.target.id].url )
                    -- networkRequest("ad/click" , requestCallback , {ad_id = contentMI[e.target.id].id})
                    -- composer.gotoScene( "webView" )
                    -- adId = contentMI[e.target.id].id
                end 
                dx = 0
                beganStart = false
            end
        end    
    end

    --從table取得廣告圖片
    for i = 1 , #adImgData do 
        img[i] = display.newImageRect( adGroup, adImgData[i], W, H*0.3 )
        img[i].x , img[i].y =  i*W-W , H*0.5
         
    --              = widget.newButton( {
    --         baseDir = system.DocumentsDirectory ,
    --         defaultFile = adImgData[i].defaultFile , 
    --         width = W , 
    --         height = 370 * HEIGHT_RATIO ,
    --         top = 115 * HEIGHT_RATIO , 
    --         left = i * _SCREEN.W - _SCREEN.W ,
    --         onEvent = adBottonListener ,
    --         } )
        
        img[i].id = i
        -- adGroup:insert( img[i] )
        -- group:insert( adGroup )
    end

    --產生指示器
    for i = 1 , #adImgData do 
        tabBtn[i] = display.newCircle( indicateGrp , i * H*0.0749, y + H*0.674 , 15 )
        tabBtn[i].alpha = 0.5
        tabBtn[1].alpha = 1
    end

    indicateGrp.x = X
    indicateGrp.y = y + H*0.674
    indicateGrp.anchorChildren = true
    sceneGroup:insert( indicateGrp )
    adGroup.x , adGroup.y = x , y

     -- adTimerStart(  )
    adGroup:addEventListener( "touch", adBottonListener )

    return adGroup
end


return M


