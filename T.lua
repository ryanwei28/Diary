local M = {}

function M.init()
	print("MMMMMMMMMMM")
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
        { x=580, y=28, width=64, height=40 },
        { x=580, y=148, width=64, height=40 },
        { x=580, y=228, width=24, height=68 }
    },
    sheetContentWidth = 662,  --606
    sheetContentHeight = 376,  --320
}

-- display.newRoundedRect( [parent,], x, y, width, height, cornerRadius )
M.pickerWheelSheet = graphics.newImageSheet( "images/picker.png", pickerOptions )

M.options = {
    --  -- isModal = true,
    -- effect = "fade",
    -- time = 400,
}

return M


