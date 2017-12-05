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
local textListener 
local textField
local alertText 
-- local alertText2
local psd = ""
local chkBthEvent 
local setType = composer.getVariable( "setType" )
local readDb
local addCloseBtn
local updateBtn
local updateNum = 0
local setPsdNum = 0
local psdChk 
local backBtn
local onKeyEvent
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    -- title = display.newText( _parent, "密碼設定", X, Y*0.2, font , H*0.045 )
    -- T.title("密碼設定" , sceneGroup)
    titleBg = display.newImageRect( _parent, "images/bg_top@3x.png", W, H*0.07 )
    titleBg.x , titleBg.y ,titleBg.anchorY= X, Y*0.07 , 0

    title = display.newText( _parent , "密碼設定" , X, Y*0.14, bold , H*0.032 )

    backBtn = widget.newButton({
        label = "",
        onEvent = listener,
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
    -- back = display.newCircle( _parent, X*0.2, Y*0.2, H*0.045 )
    -- back:addEventListener( "tap", listener )

    -- addBtn()

    textField = native.newTextField( X, Y*0.4, W*0.7, H*0.05 )
    textField.placeholder = "請輸入密碼"
    textField.isSecure = true
    textField:addEventListener( "userInput", textListener )
    _parent:insert(textField)

    alertText = display.newText( sceneGroup, "", X, Y*0.5, font , H*0.028 )

    if setType == "change" then 
        title.text = "變更密碼"
        textField.placeholder = "請輸入密碼以變更"
        updateBtn()
    else
        readDb()
    end

    Runtime:addEventListener( "key" , onKeyEvent)
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
                native.setKeyboardFocus( nil )
                composer.showOverlay( "setup" )
                Runtime:removeEventListener( "key", onKeyEvent )
                return true
            end
        end
    end
 
    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
    -- This lets the operating system execute its default handling of the key
    return true
end


listener = function ( e )
    if e.phase == "ended" then
        native.setKeyboardFocus( nil )
        composer.showOverlay( "setup" )
    end
end


textListener = function( event )
    if ( event.phase == "began" ) then
     
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        native.setKeyboardFocus( nil )
    elseif ( event.phase == "editing" ) then
        psd = event.text
    end
end

addBtn = function (  )
    chkBthEvent = function ( e )
        if e.phase == "ended" then
            if psd == "" then
                alertText.text = "請輸入密碼"   
            else 
                if setPsdNum == 0 then
                    setPsdNum = 1
                    alertText.text = "再次輸入確認密碼"
                    textField.text = ""
                    psdChk = psd
                elseif setPsdNum == 1 then
                    print(psd)
                    if psdChk == psd then
                        database:exec([[UPDATE Setting SET Password = ']]..psd..[[' WHERE id = 1 ;]])
                        database:exec([[UPDATE Setting SET Protect = "ON" WHERE id = 1 ;]])
                        native.setKeyboardFocus( nil )
                        composer.showOverlay( "setup" )
                    else
                        alertText.text = "兩次輸入密碼不同"
                    end
                end
            end
        end
    end

    local chkBth = widget.newButton( {
        x = X*1 ,
        y = Y*0.65,
        id = "chkBth",
        label = "確定",
        fontSize = H*0.028 ,
        shape = "roundedRect",
        width = W*0.2,
        height = H*0.08,
        cornerRadius = H*0.015,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = chkBthEvent 
    } )                 

    sceneGroup:insert(chkBth)  
end

addCloseBtn = function (  )
    closeBthEvent = function ( e )
        if e.phase == "ended" then
            if psd == "" then
                alertText.text = "請輸入密碼"
            else 
                for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
                    print( row.Password..":"..psd )
                    if psd == row.Password then
                        print( "yes" )
                        database:exec([[UPDATE Setting SET Password = "" WHERE id = 1 ;]])
                        database:exec([[UPDATE Setting SET Protect = "OFF" WHERE id = 1 ;]])
                        native.setKeyboardFocus( nil )
                        composer.showOverlay( "setup" )
                    else                  
                        alertText.text = "密碼錯誤"  
                    end
                end
            end
        end
    end

    local closeBtn = widget.newButton( {
        x = X*1 ,
        y = Y*0.65,
        id = "colseBth",
        label = "確定",
        fontSize = H*0.028 ,
        shape = "roundedRect",
        width = W*0.2,
        height = H*0.08,
        cornerRadius = H*0.015,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = closeBthEvent 
    } )                 

    sceneGroup:insert(closeBtn)  
end

updateBtn = function (  )
    updateBtnEvent = function ( e )
        if e.phase == "ended" then
            if psd == "" then
                    alertText.text = "請輸入密碼"
            else
                if updateNum == 1 then
                    database:exec([[UPDATE Setting SET Password = ']]..psd..[[' WHERE id = 1 ;]])
                    native.setKeyboardFocus( nil )
                    composer.showOverlay( "setup" )
                else
                    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
                        if psd == row.Password then
                            alertText.text = "請輸入新的密碼" 
                            textField.text = ""
                            updateNum = 1 
                        else
                            alertText.text = "密碼錯誤" 
                        end
                    end
                end
            end
        end
    end

    local updateBtn = widget.newButton( {
        x = X*1 ,
        y = Y*0.65,
        id = "updateBtn",
        label = "確定",
        fontSize = H*0.028 ,
        shape = "roundedRect",
        width = W*0.2,
        height = H*0.08,
        cornerRadius = H*0.015,
        fillColor = { default={0.92,0.12,0.45,1}, over={0.2,0.78,0.75,0.4} },
        onEvent = updateBtnEvent 
    } )                 

    sceneGroup:insert(updateBtn)  
end

readDb = function (  )
    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
        if row.Protect == "ON" then
            addCloseBtn()
            title.text = "關閉密碼"
            textField.placeholder = "請輸入密碼以關閉"
        elseif row.Protect == "OFF" then
            addBtn()
            title.text = "設定密碼"
            textField.placeholder = "請輸入設定密碼"
        end
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
