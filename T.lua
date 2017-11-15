local M = {}

function M.init()
	print("MMMMMMMMMMM")
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

return M


