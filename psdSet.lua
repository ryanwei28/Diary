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
local textField2
local textField3
local textField4
local inputPsw 
local inputPsw2
local inputPsw3
local inputPsw4
local alertText 
local c1 
local c2 
local c3 
local c4 
-- local alertText2
local psd = ""
local chkBthEvent 
local setType = composer.getVariable( "setType" )
local readDb
local closeListener
local updateBtn
local updateNum = 0
local setPsdNum = 0
local psdChk 
local backBtn
local onKeyEvent
local enterText
local psdType = "enter"
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
init = function ( _parent )
    -- title = display.newText( _parent, "密碼設定", X, Y*0.2, font , H*0.045 )
    -- T.title("密碼設定" , sceneGroup)

    textField = native.newTextField( X, H*3,  W*0.9 , H*0.078 )
    -- textField.size = 50
    textField.inputType = "number"
    native.setKeyboardFocus( textField )

    -- textField.isSecure = true
    textField.hasBackground = false
    textField:addEventListener( "userInput", textListener )
    _parent:insert(textField)


    T.bg(sceneGroup)
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

    -- textField = native.newTextField( X, Y*0.4, W*0.9, H*0.2 )
    -- textField.placeholder = "請輸入密碼"
    -- textField.inputType = "number"
    -- -- textField.isSecure = true
    -- textField.size = 80
    -- native.setKeyboardFocus( textField )
    -- textField:addEventListener( "userInput", textListener )
    -- _parent:insert(textField)

    enterText = display.newText( sceneGroup, "請輸入密碼", X, H*0.156 , bold , H*0.027 )
    enterText:setFillColor( 77/255,77/255,102/255 )

    inputPsw = display.newImageRect( sceneGroup, "images/input_pw@3x.png", W*0.16 , H*0.078 )
    inputPsw.x , inputPsw.y = W*0.221 ,H*0.25
    c1 = display.newCircle( sceneGroup, W*0.221 , H*0.25, H*0.015 )
    c1:setFillColor( 0 ) 
    c1.alpha = 0

    inputPsw2 = display.newImageRect( sceneGroup, "images/input_pw@3x.png", W*0.16 , H*0.078 )
    inputPsw2.x , inputPsw2.y = W*0.408 ,H*0.25
    c2 = display.newCircle( sceneGroup,  W*0.408 ,H*0.25 , H*0.015 )
    c2:setFillColor( 0 ) 
    c2.alpha = 0

    inputPsw3 = display.newImageRect( sceneGroup, "images/input_pw@3x.png", W*0.16 , H*0.078 )
    inputPsw3.x , inputPsw3.y = W*0.595 ,H*0.25
    c3 = display.newCircle( sceneGroup, W*0.595 ,H*0.25 , H*0.015 )
    c3:setFillColor( 0 ) 
    c3.alpha = 0

    inputPsw4 = display.newImageRect( sceneGroup, "images/input_pw@3x.png", W*0.16 , H*0.078 )
    inputPsw4.x , inputPsw4.y = W*0.782 ,H*0.25
    c4 = display.newCircle( sceneGroup, W*0.782 ,H*0.25 , H*0.015 )
    c4:setFillColor( 0 ) 
    c4.alpha = 0



    -- textField2 = native.newTextField( X, H*0.33, W*0.3, H*0.05 )
    -- textField.size = 80
    -- -- native.setKeyboardFocus( textField )
    -- textField2.inputType = "number"
    -- textField2.isSecure = true
    -- textField2:addEventListener( "userInput", textListener )
    -- _parent:insert(textField2)

    -- textField3 = native.newTextField( X, H*0.33, W*0.3, H*0.05 )
    -- textField3.size = 80
    -- -- native.setKeyboardFocus( textField )
    -- textField3.inputType = "number"
    -- textField3.isSecure = true
    -- textField3:addEventListener( "userInput", textListener )
    -- _parent:insert(textField3)

    -- textField4 = native.newTextField( X, H*0.33, W*0.3, H*0.05 )
    -- textField4.size = 80
    -- -- native.setKeyboardFocus( textField )
    -- textField4.inputType = "number"
    -- textField4.isSecure = true
    -- textField4:addEventListener( "userInput", textListener )
    -- _parent:insert(textField4)

    alertText = display.newText( sceneGroup, "", X, Y*0.65, bold , H*0.023 )
    alertText:setFillColor( 77/255,77/255,102/255 )

    if setType == "change" then 
        title.text = "改變密碼"
        textField.placeholder = "請輸入密碼以變更"
        enterText.text = "輸入您的舊密碼"
        -- updateBtn()
        psdType = "update"
    else
        readDb()
    end

    Runtime:addEventListener( "key" , onKeyEvent)
end


textListener = function( event )
    if ( event.phase == "began" ) then
     
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- native.setKeyboardFocus( nil )
    elseif ( event.phase == "editing" ) then
        psd = event.text
        if #psd == 0 then
            c1.alpha = 0
        elseif #psd == 1 then 
            alertText.text = ""
            c1.alpha = 1
            c2.alpha = 0
            -- c3.alpha = 0 
            -- c4.alpha = 0
        elseif #psd == 2 then 
            c2.alpha = 1
            c3.alpha = 0
        elseif #psd == 3 then 
            c3.alpha = 1
            c4.alpha = 0
        elseif #psd == 4 then 
            c4.alpha = 1
            -- native.setKeyboardFocus( nil )
            if psdType == "enter" then
                chkBthEvent()
            elseif psdType == "close" then
                closeListener()
            elseif psdType == "update" then 
                updateBtn()
            end 
        end
    end
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

chkBthEvent = function ( e )
    if psd == "" then
        enterText.text = "請輸入密碼"   
    else 
        if setPsdNum == 0 then
            setPsdNum = 1
            enterText.text = "請再次輸入密碼"
            textField.text = ""
            psdChk = psd
            c1.alpha = 0
            c2.alpha = 0 
            c3.alpha = 0 
            c4.alpha = 0
            native.setKeyboardFocus( textField )
        elseif setPsdNum == 1 then
            print(psd)
            if psdChk == psd then
                database:exec([[UPDATE Setting SET Password = ']]..psd..[[' WHERE id = 1 ;]])
                database:exec([[UPDATE Setting SET Protect = "ON" WHERE id = 1 ;]])
                native.setKeyboardFocus( nil )
                composer.showOverlay( "setup" )
            else
                alertText.text = "密碼不同。請重新設定"
                enterText.text = "請輸入密碼" 
                textField.text = ""
                c1.alpha = 0
                c2.alpha = 0 
                c3.alpha = 0 
                c4.alpha = 0
                native.setKeyboardFocus( textField )
                setPsdNum = 0
            end
        end
    end
end

closeListener = function (  )
    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
        print( row.Password..":"..psd )
        if psd == row.Password then
            print( "yes" )
            database:exec([[UPDATE Setting SET Password = "" WHERE id = 1 ;]])
            database:exec([[UPDATE Setting SET Protect = "OFF" WHERE id = 1 ;]])
            native.setKeyboardFocus( nil )
            composer.showOverlay( "setup" )
        else                  
            alertText.text = "密碼錯誤。請重新輸入"  
            textField.text = ""
            c1.alpha = 0 
            c2.alpha = 0 
            c3.alpha = 0 
            c4.alpha = 0 
            native.setKeyboardFocus( textField )
        end
    end
end

updateBtn = function (  )
    if updateNum == 1 then
        database:exec([[UPDATE Setting SET Password = ']]..psd..[[' WHERE id = 1 ;]])
        native.setKeyboardFocus( nil )
        composer.showOverlay( "setup" )
    else
        for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
            if psd == row.Password then
                enterText.text = "輸入您的新密碼" 
                textField.text = ""
                updateNum = 1 
                c1.alpha = 0 
                c2.alpha = 0 
                c3.alpha = 0 
                c4.alpha = 0
                native.setKeyboardFocus( textField )
            else
                alertText.text = "密碼錯誤。請重新輸入" 
                textField.text = ""
                c1.alpha = 0 
                c2.alpha = 0 
                c3.alpha = 0 
                c4.alpha = 0
                native.setKeyboardFocus( textField )

            end
        end
    end
end

readDb = function (  )
    for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
        if row.Protect == "ON" then
            psdType = "close"
            -- addCloseBtn()
            title.text = "關閉密碼"
            textField.placeholder = "請輸入密碼以關閉"
        elseif row.Protect == "OFF" then
            psdType = "enter"
            -- addBtn()
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
