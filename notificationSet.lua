-- local edit = require("edit")

local M = {}

function M.loadPlan(  )
	-- local sex 
	-- local plan 
	 
	for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
	    sexNoti = row.Sex 
	    planNoti = row.Plan 
	end

	if sexNoti == "女生" then 
	    sexNoti = "Girl"
	elseif  sexNoti == "男生" then 
	    sexNoti = "Boy"
	end 

	if planNoti == "想避孕" then
	    planNoti = "Bi"
	elseif planNoti == "想懷孕" then 
	    planNoti = "Huai"
	end
end

local holiday = "聖誕節"
local holidayTable = {
    {"02/14" , "西洋情人節" } ,
    {"08/17" , "七夕情人節" } ,
     -- {"11/25" , "七夕情人節!!" } ,
    {"12/24" , "聖誕夜" } ,
    {"12/31" , "跨年夜" } ,
}


M.alertContent = {}
M.alertContent.Boy = {}
M.alertContent.Girl = {}

M.alertContent.Boy.Bi = { 
	pre7 = "她本週可能較浮躁易怒，心情起伏不定，要多體貼作個好男人唷！" ,
	pre1 = "明天是她的經期第一天，幫她在包包中放入衛生用品吧！" ,
	first = "幫她在包包中放入衛生用品，讓她感受到你的貼心~" ,
	last = "經期最後一天，她的安全期明天開始。" , 
	dg1 = "她的危險期今天開始，嘿咻記得採取避孕措施。" , 
	dg6 = "今天是她的預測排卵日，別忘了避孕措施唷~" , 
	dgLast = "" , 
	safe = "預測的安全期今天開始。（僅供參考，建議還是採取避孕措施！）" ,
	holidaySafe = "今天是"..holiday.."，放鬆心情狂歡一下！雖為安全期，建議還是採取避孕措施" ,
	holidayDg = "今天是"..holiday.."，恰好為她的易孕期，要記得採取避孕措施唷！" ,
	holidayDg6 = "今天是"..holiday.."，恰好為她的預測排卵日，要記得採取避孕措施唷！" , 
	holidayPre7 = "今天是"..holiday.."，她的經期預計7天後開始，要好好服侍可能陰晴不定的她" , 
	holidayDuring = "今天是"..holiday.."，她的好朋友恰巧來訪，發揮你體貼的一面，與她溫馨共同度過" , 
	Mpre7 = "經期前一週肌膚易出油，注意抑油控痘及舒壓，可多泡熱水澡促進血液循環。" ,
	Mstart2 = "生理期間肌膚容易缺水，要特別注意保濕唷！" ,
	Mlast = "經期結束後一週內為瘦身黃金期，可攝取低熱量高纖飲食，進行有氧運動。" , 
	Mend1 = "月經結束至排卵日前是濾泡期，可加強去角質及抗老保養。" ,
	Mdg7 = "排卵日後2~3天肌膚吸收力佳，可多敷面膜或補充高濃度活性成分，調理修復。" , 
	MheiXiu = "可以使用「統藥驗孕棒」測試看看是否做人成功！" , 
	Mno40 = "「女孩日記」提醒您，要記得更新經期記錄唷！" , 
}

M.alertContent.Boy.Huai = {
	pre7 = "她本週可能較浮躁易怒，心情起伏不定，要多體貼作個好男人唷！" ,
	pre1 = "明天是她的經期第一天，幫她在包包中放入衛生用品吧！" ,
	first = "幫她在包包中放入衛生用品，讓她感受到你的貼心~" ,
	last = "經期最後一天，她的安全期明天開始。" , 
	dg1 = "她的推測易孕期今天開始，要努力做人唷！" , 
	dg6 = "今天是預測排卵日，想生寶寶要再接再厲！" , 
	dgLast = "易孕期最後一天，好好把握！" , 
	safe = "她的預測安全期今天開始。" ,	
	holidaySafe = "今天是"..holiday.."，放鬆心情狂歡一下吧！" ,
	holidayDg = "今天是"..holiday.."，恰好為她的易孕期，要好好把握努力做人！" ,
	holidayDg6 = "今天是"..holiday.."，恰好為她的預測排卵日，好好把握唷！" , 
	holidayPre7 = "今天是"..holiday.."，她的經期預計7天後開始，要好好服侍可能陰晴不定的她" , 
	holidayDuring = "今天是"..holiday.."，她的好朋友恰巧來訪，發揮你體貼的一面，與她溫馨共同度過" , 
	Mpre7 = "經期前一週肌膚易出油，注意抑油控痘及舒壓，可多泡熱水澡促進血液循環。" ,
	Mstart2 = "生理期間肌膚容易缺水，要特別注意保濕唷！" ,
	Mlast = "經期結束後一週內為瘦身黃金期，可攝取低熱量高纖飲食，進行有氧運動。" , 
	Mend1 = "月經結束至排卵日前是濾泡期，可加強去角質及抗老保養。" ,
	Mdg7 = "排卵日後2~3天肌膚吸收力佳，可多敷面膜或補充高濃度活性成分，調理修復。" , 
	MheiXiu = "可以使用「統藥驗孕棒」測試看看是否做人成功！" , 
	Mno40 = "「女孩日記」提醒您，要記得更新經期記錄唷！" , 
}

M.alertContent.Girl.Bi = {
	pre7 = "" ,
	pre1 = "明天好朋友可能來訪，記得作好準備唷~" ,
	first = "今天好朋友應會來訪，記得準備唷~" ,
	last = "經期最後一天，安全期明天開始。" , 
	dg1 = "危險期今天開始，嘿咻記得採取避孕措施。" , 
	dg6 = "今天是預測的排卵日，別忘了避孕措施唷~" , 
	dgLast = "" , 
	safe = "預測的安全期今天開始。（僅供參考，建議還是採取避孕措施！）" ,
	holidaySafe = "今天是"..holiday.."，放鬆心情狂歡一下！雖為安全期，建議還是採取避孕措施" ,
	holidayDg = "今天是"..holiday.."，恰好為易孕期，要記得採取避孕措施唷！" ,
	holidayDg6 = "今天是"..holiday.."，恰好為預測排卵日，要記得採取避孕措施唷！" , 
	holidayPre7 = "今天"..holiday.."，為經期前一週，注意抑油控痘舒壓，可多泡熱水澡促進血液循環" , 
	holidayDuring = "今天是"..holiday.."，雖然好朋友來訪，也要溫馨共同度過。" , 
	Mpre7 = "經期前一週肌膚易出油，注意抑油控痘及舒壓，可多泡熱水澡促進血液循環。" ,
	Mstart2 = "生理期間肌膚容易缺水，要特別注意保濕唷！" ,
	Mlast = "經期結束後一週內為瘦身黃金期，可攝取低熱量高纖飲食，進行有氧運動。" , 
	Mend1 = "月經結束至排卵日前是濾泡期，可加強去角質及抗老保養。" ,
	Mdg7 = "排卵日後2~3天肌膚吸收力佳，可多敷面膜或補充高濃度活性成分，調理修復。" , 
	MheiXiu = "可以使用「統藥驗孕棒」測試看看是否做人成功！" , 
	Mno40 = "「女孩日記」提醒您，要記得更新經期記錄唷！" , 
}

M.alertContent.Girl.Huai = {
	pre7 = "" ,
	pre1 = "明天好朋友可能會來訪，記得作好準備唷~" ,
	first = "今天好朋友可能會來訪，記得準備唷~" ,
	last = "經期最後一天，安全期明天開始。" , 
	dg1 = "推測易孕期今天開始，要努力做人唷！" , 
	dg6 = "今天是預測排卵日，想生寶寶要再接再厲！" , 
	dgLast = "易孕期最後一天，好好把握！" , 
	safe = "預測的安全期今天開始。" ,
	holidaySafe = "今天是"..holiday.."，放鬆心情狂歡一下吧！" ,
	holidayDg = "今天是"..holiday.."，恰好為易孕期，好好把握努力做人！" ,
	holidayDg6 = "今天是"..holiday.."，恰好為預測排卵日，好好把握唷！" , 
	holidayPre7 = "今天"..holiday.."，為經期前一週，注意抑油控痘舒壓，可多泡熱水澡促進血液循環" , 
	holidayDuring = "今天是"..holiday.."，雖然好朋友來訪，也要溫馨共同度過。" ,
	Mpre7 = "經期前一週肌膚易出油，注意抑油控痘及舒壓，可多泡熱水澡促進血液循環。" ,
	Mstart2 = "生理期間肌膚容易缺水，要特別注意保濕唷！" ,
	Mlast = "經期結束後一週內為瘦身黃金期，可攝取低熱量高纖飲食，進行有氧運動。" , 
	Mend1 = "月經結束至排卵日前是濾泡期，可加強去角質及抗老保養。" ,
	Mdg7 = "排卵日後2~3天肌膚吸收力佳，可多敷面膜或補充高濃度活性成分，調理修復。" , 
	MheiXiu = "可以使用「統藥驗孕棒」測試看看是否做人成功！" , 
	Mno40 = "「女孩日記」提醒您，要記得更新經期記錄唷！" , 
}

M.alertContent.Maintain = {
	Mpre7 = "經期前一週肌膚易出油，注意抑油控痘及舒壓，可多泡熱水澡促進血液循環。" ,
	Mstart2 = "生理期間肌膚容易缺水，要特別注意保濕唷！" ,
	Mlast = "經期結束後一週內為瘦身黃金期，可攝取低熱量高纖飲食，進行有氧運動。" , 
	Mend1 = "月經結束至排卵日前是濾泡期，可加強去角質及抗老保養。" ,
	Mdg7 = "排卵日後2~3天肌膚吸收力佳，可多敷面膜或補充高濃度活性成分，調理修復。" , 
	MheiXiu = "可以使用「統藥驗孕棒」測試看看是否做人成功！" , 
	Mno40 = "「女孩日記」提醒您，要記得更新經期記錄唷！" , 
}

notificationIDtable = {}


alertContent = {}
alertContent.Boy = {}
alertContent.Girl = {}

alertContent.Boy.Bi = { 
	pre7 = "她本週可能較浮躁易怒，心情起伏不定，要多體貼作個好男人唷！" ,
	pre1 = "明天是她的經期第一天，幫她在包包中放入衛生用品吧！" ,
	first = "幫她在包包中放入衛生用品，讓她感受到你的貼心~" ,
	last = "經期最後一天，她的安全期明天開始。" , 
	dg1 = "她的危險期今天開始，嘿咻記得採取避孕措施。" , 
	dg6 = "今天是她的預測排卵日，別忘了避孕措施唷~" , 
	dgLast = "" , 
	safe = "預測的安全期今天開始。（僅供參考，建議還是採取避孕措施！）" ,
	holidaySafe = "今天是"..holiday.."，放鬆心情狂歡一下！雖為安全期，建議還是採取避孕措施" ,
	holidayDg = "今天是"..holiday.."，恰好為她的易孕期，要記得採取避孕措施唷！" ,
	holidayDg6 = "今天是"..holiday.."，恰好為她的預測排卵日，要記得採取避孕措施唷！" , 
	holidayPre7 = "今天是"..holiday.."，她的經期預計7天後開始，要好好服侍可能陰晴不定的她" , 
	holidayDuring = "今天是"..holiday.."，她的好朋友恰巧來訪，發揮你體貼的一面，與她溫馨共同度過" , 
	Mpre7 = "經期前一週肌膚易出油，注意抑油控痘及舒壓，可多泡熱水澡促進血液循環。" ,
	Mstart2 = "生理期間肌膚容易缺水，要特別注意保濕唷！" ,
	Mlast = "經期結束後一週內為瘦身黃金期，可攝取低熱量高纖飲食，進行有氧運動。" , 
	Mend1 = "月經結束至排卵日前是濾泡期，可加強去角質及抗老保養。" ,
	Mdg7 = "排卵日後2~3天肌膚吸收力佳，可多敷面膜或補充高濃度活性成分，調理修復。" , 
	MheiXiu = "可以使用「統藥驗孕棒」測試看看是否做人成功！" , 
	Mno40 = "「女孩日記」提醒您，要記得更新經期記錄唷！" , 
}

alertContent.Boy.Huai = {
	pre7 = "她本週可能較浮躁易怒，心情起伏不定，要多體貼作個好男人唷！" ,
	pre1 = "明天是她的經期第一天，幫她在包包中放入衛生用品吧！" ,
	first = "幫她在包包中放入衛生用品，讓她感受到你的貼心~" ,
	last = "經期最後一天，她的安全期明天開始。" , 
	dg1 = "她的推測易孕期今天開始，要努力做人唷！" , 
	dg6 = "今天是預測排卵日，想生寶寶要再接再厲！" , 
	dgLast = "易孕期最後一天，好好把握！" , 
	safe = "她的預測安全期今天開始。" ,	
	holidaySafe = "今天是"..holiday.."，放鬆心情狂歡一下吧！" ,
	holidayDg = "今天是"..holiday.."，恰好為她的易孕期，要好好把握努力做人！" ,
	holidayDg6 = "今天是"..holiday.."，恰好為她的預測排卵日，好好把握唷！" , 
	holidayPre7 = "今天是"..holiday.."，她的經期預計7天後開始，要好好服侍可能陰晴不定的她" , 
	holidayDuring = "今天是"..holiday.."，她的好朋友恰巧來訪，發揮你體貼的一面，與她溫馨共同度過", 
	Mpre7 = "經期前一週肌膚易出油，注意抑油控痘及舒壓，可多泡熱水澡促進血液循環。" ,
	Mstart2 = "生理期間肌膚容易缺水，要特別注意保濕唷！" ,
	Mlast = "經期結束後一週內為瘦身黃金期，可攝取低熱量高纖飲食，進行有氧運動。" , 
	Mend1 = "月經結束至排卵日前是濾泡期，可加強去角質及抗老保養。" ,
	Mdg7 = "排卵日後2~3天肌膚吸收力佳，可多敷面膜或補充高濃度活性成分，調理修復。" , 
	MheiXiu = "可以使用「統藥驗孕棒」測試看看是否做人成功！" , 
	Mno40 = "「女孩日記」提醒您，要記得更新經期記錄唷！" , 
}

alertContent.Girl.Bi = {
	pre7 = "" ,
	pre1 = "明天好朋友可能來訪，記得作好準備唷~" ,
	first = "今天好朋友應會來訪，記得準備唷~" ,
	last = "經期最後一天，安全期明天開始。" , 
	dg1 = "危險期今天開始，嘿咻記得採取避孕措施。" , 
	dg6 = "今天是預測的排卵日，別忘了避孕措施唷~" , 
	dgLast = "" , 
	safe = "預測的安全期今天開始。（僅供參考，建議還是採取避孕措施！）" ,
	holidaySafe = "今天是"..holiday.."，放鬆心情狂歡一下！雖為安全期，建議還是採取避孕措施" ,
	holidayDg = "今天是"..holiday.."，恰好為易孕期，要記得採取避孕措施唷！" ,
	holidayDg6 = "今天是"..holiday.."，恰好為預測排卵日，要記得採取避孕措施唷！" , 
	holidayPre7 = "今天"..holiday.."，為經期前一週，注意抑油控痘舒壓，可多泡熱水澡促進血液循環" , 
	holidayDuring = "今天是"..holiday.."，雖然好朋友來訪，也要溫馨共同度過。" , 
	Mpre7 = "經期前一週肌膚易出油，注意抑油控痘及舒壓，可多泡熱水澡促進血液循環。" ,
	Mstart2 = "生理期間肌膚容易缺水，要特別注意保濕唷！" ,
	Mlast = "經期結束後一週內為瘦身黃金期，可攝取低熱量高纖飲食，進行有氧運動。" , 
	Mend1 = "月經結束至排卵日前是濾泡期，可加強去角質及抗老保養。" ,
	Mdg7 = "排卵日後2~3天肌膚吸收力佳，可多敷面膜或補充高濃度活性成分，調理修復。" , 
	MheiXiu = "可以使用「統藥驗孕棒」測試看看是否做人成功！" , 
	Mno40 = "「女孩日記」提醒您，要記得更新經期記錄唷！" , 
}

alertContent.Girl.Huai = {
	pre7 = "" ,
	pre1 = "明天好朋友可能會來訪，記得作好準備唷~" ,
	first = "今天好朋友可能會來訪，記得準備唷~" ,
	last = "經期最後一天，安全期明天開始。" , 
	dg1 = "推測易孕期今天開始，要努力做人唷！" , 
	dg6 = "今天是預測排卵日，想生寶寶要再接再厲！" , 
	dgLast = "易孕期最後一天，好好把握！" , 
	safe = "預測的安全期今天開始。" ,
	holidaySafe = "今天是"..holiday.."，放鬆心情狂歡一下吧！" ,
	holidayDg = "今天是"..holiday.."，恰好為易孕期，好好把握努力做人！" ,
	holidayDg6 = "今天是"..holiday.."，恰好為預測排卵日，好好把握唷！" , 
	holidayPre7 = "今天"..holiday.."，為經期前一週，注意抑油控痘舒壓，可多泡熱水澡促進血液循環" , 
	holidayDuring = "今天是"..holiday.."，雖然好朋友來訪，也要溫馨共同度過。", 
	Mpre7 = "經期前一週肌膚易出油，注意抑油控痘及舒壓，可多泡熱水澡促進血液循環。" ,
	Mstart2 = "生理期間肌膚容易缺水，要特別注意保濕唷！" ,
	Mlast = "經期結束後一週內為瘦身黃金期，可攝取低熱量高纖飲食，進行有氧運動。" , 
	Mend1 = "月經結束至排卵日前是濾泡期，可加強去角質及抗老保養。" ,
	Mdg7 = "排卵日後2~3天肌膚吸收力佳，可多敷面膜或補充高濃度活性成分，調理修復。" , 
	MheiXiu = "可以使用「統藥驗孕棒」測試看看是否做人成功！" , 
	Mno40 = "「女孩日記」提醒您，要記得更新經期記錄唷！" , 

}

alertContent.Maintain = {
	pre7 = "經期前一週肌膚易出油，注意抑油控痘及舒壓，可多泡熱水澡促進血液循環。" ,
	start2 = "生理期間肌膚容易缺水，要特別注意保濕唷！" ,
	last = "經期結束後一週內為瘦身黃金期，可攝取低熱量高纖飲食，進行有氧運動。" , 
	end1 = "月經結束至排卵日前是濾泡期，可加強去角質及抗老保養。" ,
	dg7 = "排卵日後2~3天肌膚吸收力佳，可多敷面膜或補充高濃度活性成分，調理修復。" , 
	heiXiu = "可以使用「統藥驗孕棒」測試看看是否做人成功！" , 
	no40 = "「女孩日記」提醒您，要記得更新經期記錄唷！" , 
}

function M.startNotify ( notiDate , alertContent , type )
	local open 

	for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
		notifyTime = row.NotifyTime
	end

	for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
		open = row.Notification
	end

	notiHour = string.sub(notifyTime ,1,2 )
	-- print( string.sub(notifyTime ,7,13) )
	if string.sub(notifyTime ,7,13) == "下午" then
		notiHour = tonumber(notiHour) + 12
	end 

	local y = tonumber( os.date( "%Y" ))
	local m = tonumber(os.date( "%m" ))
	local d = tonumber(os.date( "%d" ))
	local H = tonumber(os.date( "%H" ))
	local Min = tonumber(os.date( "%M" ))
	local now = y..m..d..H..Min 

	local notiDay = tonumber(string.sub(notiDate , 1,4)) ..tonumber(string.sub(notiDate , 6,7) )..tonumber(string.sub(notiDate , 9,10) )..notiHour..string.sub(notifyTime ,4,5 )


    local e = os.date(os.time{year=string.sub(notiDay , 1 , 4) ,month=string.sub(notiDay , 5 , 6),day=string.sub(notiDay , 7 , 8) , hour=string.sub(notiDay , 9 , 10) , min=string.sub(notiDay , 11 , 12)})
    local s = os.date(os.time{year=string.sub(now , 1 , 4) ,month=string.sub(now , 5 , 6),day=string.sub(now , 7 , 8) , hour=string.sub(now , 9 , 10) , min=string.sub(now , 11 , 12)})

    local time = e-s
	
    if time >= 0 then 
		randomId = tostring(math.random( os.time( ) ) )

		local options = {
		   alert = alertContent ,
		   -- badge = 1,
		   -- sound = "notification.wav",
		   custom = { id = randomId }
		}		
		
		if open == "ON" then 
			notificationIDtable[randomId] = notifications.scheduleNotification( time , options )
		end

		local notifyDate = string.sub( notiDate, 1 , 4 ).."/"..string.sub( notiDate, 6 , 7 ).."/"..string.sub( notiDate, 9 , 10 )
		  
		local tablesetup =  [[
								INSERT INTO Notifications VALUES ( NULL , ']]..notifyDate..[[' , ']]..notiHour..":"..string.sub(notifyTime ,4,5)..[[' , ']]..randomId..[[' , ']]..type..[[' );
								]]
		                    
		                --     INSERT INTO Diary VALUES( "" , "2017/11/05" , "1" , "" , "" , "" , "" , "" , "");


		                -- ]]
		                -- CREATE TABLE IF NOT EXISTS Diary ( id INTEGER PRIMARY KEY , Data , Start , End , Close , Temperature , Weight , Notes);
		database:exec(tablesetup)	

		print( alertContent )
	end 
end

function M.deleteNotify(  )

	local tablesetup =  [[
	 							DELETE FROM Notifications WHERE Date NotifyDate );
	 							]]
	                        
	database:exec(tablesetup)	
end

function M.closeNotify(  )
	local idTabel = {}
	local index = 0 

	for row in database:nrows([[SELECT * FROM Notifications;]]) do
		index = index + 1 
		idTabel[index] = row.RandomId 
	end

	-- for i = 1 , #idTabel do 
		-- print( idTabel[i] )
		-- notifications.cancelNotification( notificationIDtable[idTabel[i]] )
	-- end 

	notifications.cancelNotification( )

end


 local function changeHoliday ( sex , plan , holiday , dayType )
    
    alertContent.Boy.Bi = { 
	pre7 = "她本週可能較浮躁易怒，心情起伏不定，要多體貼作個好男人唷！" ,
	pre1 = "明天是她的經期第一天，幫她在包包中放入衛生用品吧！" ,
	first = "幫她在包包中放入衛生用品，讓她感受到你的貼心~" ,
	last = "經期最後一天，她的安全期明天開始。" , 
	dg1 = "她的危險期今天開始，嘿咻記得採取避孕措施。" , 
	dg6 = "今天是她的預測排卵日，別忘了避孕措施唷~" , 
	dgLast = "" , 
	safe = "預測的安全期今天開始。（僅供參考，建議還是採取避孕措施！）" ,
	holidaySafe = "今天是"..holiday.."，放鬆心情狂歡一下！雖為安全期，建議還是採取避孕措施" ,
	holidayDg = "今天是"..holiday.."，恰好為她的易孕期，要記得採取避孕措施唷！" ,
	holidayDg6 = "今天是"..holiday.."，恰好為她的預測排卵日，要記得採取避孕措施唷！" , 
	holidayPre7 = "今天是"..holiday.."，她的經期預計7天後開始，要好好服侍可能陰晴不定的她" , 
	holidayDuring = "今天是"..holiday.."，她的好朋友恰巧來訪，發揮你體貼的一面，與她溫馨共同度過" , 
	Mpre7 = "經期前一週肌膚易出油，注意抑油控痘及舒壓，可多泡熱水澡促進血液循環。" ,
	Mstart2 = "生理期間肌膚容易缺水，要特別注意保濕唷！" ,
	Mlast = "經期結束後一週內為瘦身黃金期，可攝取低熱量高纖飲食，進行有氧運動。" , 
	Mend1 = "月經結束至排卵日前是濾泡期，可加強去角質及抗老保養。" ,
	Mdg7 = "排卵日後2~3天肌膚吸收力佳，可多敷面膜或補充高濃度活性成分，調理修復。" , 
	MheiXiu = "可以使用「統藥驗孕棒」測試看看是否做人成功！" , 
	Mno40 = "「女孩日記」提醒您，要記得更新經期記錄唷！" , 
	}

	alertContent.Boy.Huai = {
		pre7 = "她本週可能較浮躁易怒，心情起伏不定，要多體貼作個好男人唷！" ,
		pre1 = "明天是她的經期第一天，幫她在包包中放入衛生用品吧！" ,
		first = "幫她在包包中放入衛生用品，讓她感受到你的貼心~" ,
		last = "經期最後一天，她的安全期明天開始。" , 
		dg1 = "她的推測易孕期今天開始，要努力做人唷！" , 
		dg6 = "今天是預測排卵日，想生寶寶要再接再厲！" , 
		dgLast = "易孕期最後一天，好好把握！" , 
		safe = "她的預測安全期今天開始。" ,	
		holidaySafe = "今天是"..holiday.."，放鬆心情狂歡一下吧！" ,
		holidayDg = "今天是"..holiday.."，恰好為她的易孕期，要好好把握努力做人！" ,
		holidayDg6 = "今天是"..holiday.."，恰好為她的預測排卵日，好好把握唷！" , 
		holidayPre7 = "今天是"..holiday.."，她的經期預計7天後開始，要好好服侍可能陰晴不定的她" , 
		holidayDuring = "今天是"..holiday.."，她的好朋友恰巧來訪，發揮你體貼的一面，與她溫馨共同度過" , 
		Mpre7 = "經期前一週肌膚易出油，注意抑油控痘及舒壓，可多泡熱水澡促進血液循環。" ,
		Mstart2 = "生理期間肌膚容易缺水，要特別注意保濕唷！" ,
		Mlast = "經期結束後一週內為瘦身黃金期，可攝取低熱量高纖飲食，進行有氧運動。" , 
		Mend1 = "月經結束至排卵日前是濾泡期，可加強去角質及抗老保養。" ,
		Mdg7 = "排卵日後2~3天肌膚吸收力佳，可多敷面膜或補充高濃度活性成分，調理修復。" , 
		MheiXiu = "可以使用「統藥驗孕棒」測試看看是否做人成功！" , 
		Mno40 = "「女孩日記」提醒您，要記得更新經期記錄唷！" , 
	}

	alertContent.Girl.Bi = {
		pre7 = "" ,
		pre1 = "明天好朋友可能來訪，記得作好準備唷~" ,
		first = "今天好朋友應會來訪，記得準備唷~" ,
		last = "經期最後一天，安全期明天開始。" , 
		dg1 = "危險期今天開始，嘿咻記得採取避孕措施。" , 
		dg6 = "今天是預測的排卵日，別忘了避孕措施唷~" , 
		dgLast = "" , 
		safe = "預測的安全期今天開始。（僅供參考，建議還是採取避孕措施！）" ,
		holidaySafe = "今天是"..holiday.."，放鬆心情狂歡一下！雖為安全期，建議還是採取避孕措施" ,
		holidayDg = "今天是"..holiday.."，恰好為易孕期，要記得採取避孕措施唷！" ,
		holidayDg6 = "今天是"..holiday.."，恰好為預測排卵日，要記得採取避孕措施唷！" , 
		holidayPre7 = "今天"..holiday.."，為經期前一週，注意抑油控痘舒壓，可多泡熱水澡促進血液循環" , 
		holidayDuring = "今天是"..holiday.."，雖然好朋友來訪，也要溫馨共同度過。" ,
		Mpre7 = "經期前一週肌膚易出油，注意抑油控痘及舒壓，可多泡熱水澡促進血液循環。" ,
		Mstart2 = "生理期間肌膚容易缺水，要特別注意保濕唷！" ,
		Mlast = "經期結束後一週內為瘦身黃金期，可攝取低熱量高纖飲食，進行有氧運動。" , 
		Mend1 = "月經結束至排卵日前是濾泡期，可加強去角質及抗老保養。" ,
		Mdg7 = "排卵日後2~3天肌膚吸收力佳，可多敷面膜或補充高濃度活性成分，調理修復。" , 
		MheiXiu = "可以使用「統藥驗孕棒」測試看看是否做人成功！" , 
		Mno40 = "「女孩日記」提醒您，要記得更新經期記錄唷！" , 
	}

	alertContent.Girl.Huai = {
		pre7 = "" ,
		pre1 = "明天好朋友可能會來訪，記得作好準備唷~" ,
		first = "今天好朋友可能會來訪，記得準備唷~" ,
		last = "經期最後一天，安全期明天開始。" , 
		dg1 = "推測易孕期今天開始，要努力做人唷！" , 
		dg6 = "今天是預測排卵日，想生寶寶要再接再厲！" , 
		dgLast = "易孕期最後一天，好好把握！" , 
		safe = "預測的安全期今天開始。" ,
		holidaySafe = "今天是"..holiday.."，放鬆心情狂歡一下吧！" ,
		holidayDg = "今天是"..holiday.."，恰好為易孕期，好好把握努力做人！" ,
		holidayDg6 = "今天是"..holiday.."，恰好為預測排卵日，好好把握唷！" , 
		holidayPre7 = "今天"..holiday.."，為經期前一週，注意抑油控痘舒壓，可多泡熱水澡促進血液循環" , 
		holidayDuring = "今天是"..holiday.."，雖然好朋友來訪，也要溫馨共同度過。" , 
		Mpre7 = "經期前一週肌膚易出油，注意抑油控痘及舒壓，可多泡熱水澡促進血液循環。" ,
		Mstart2 = "生理期間肌膚容易缺水，要特別注意保濕唷！" ,
		Mlast = "經期結束後一週內為瘦身黃金期，可攝取低熱量高纖飲食，進行有氧運動。" , 
		Mend1 = "月經結束至排卵日前是濾泡期，可加強去角質及抗老保養。" ,
		Mdg7 = "排卵日後2~3天肌膚吸收力佳，可多敷面膜或補充高濃度活性成分，調理修復。" , 
		MheiXiu = "可以使用「統藥驗孕棒」測試看看是否做人成功！" , 
		Mno40 = "「女孩日記」提醒您，要記得更新經期記錄唷！" , 

	}

    return alertContent[sex][plan][dayType]
end

function M.reOpenNotify(  )
	local open 

	for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
		open = row.Notification
	end

	if open == "ON" then 
		local idTabel = {}
		local dateTabel = {}
		local typeTable = {}
		local index = 0 

		for row in database:nrows([[SELECT * FROM Notifications;]]) do
			index = index + 1 
			idTabel[index] = row.RandomId 
			dateTabel[index] = row.NotifyDate 
			typeTable[index] = row.Type
		end

		for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
			sexNoti = row.Sex
			planNoti = row.Plan
		end

		if sexNoti == "女生" then 
		    sexNoti = "Girl"
		elseif  sexNoti == "男生" then 
		    sexNoti = "Boy"
		end 

		if planNoti == "想避孕" then
		    planNoti = "Bi"
		elseif planNoti == "想懷孕" then 
		    planNoti = "Huai"
		end


		for row in database:nrows([[SELECT * FROM Setting WHERE id = 1 ;]]) do
			notifyTime = row.NotifyTime
		end

		for i = 1 , #idTabel do 
			-- print(dateTabel[i])
			notiHour = string.sub(notifyTime ,1,2 )
			
			if string.sub(notifyTime ,7,13) == "下午" then
				notiHour = tonumber(notiHour) + 12
			end 

			local y = tonumber( os.date( "%Y" ))
			local m = tonumber(os.date( "%m" ))
			local d = tonumber(os.date( "%d" ))
			local H = tonumber(os.date( "%H" ))
			local Min = tonumber(os.date( "%M" ))
			local now = y..m..d..H..Min
			local notiDay = tonumber(string.sub(dateTabel[i] , 1,4)) ..tonumber(string.sub(dateTabel[i] , 6,7) )..tonumber(string.sub(dateTabel[i] , 9,10) )..notiHour..string.sub(notifyTime ,4,5 )
			
		    local e = os.date(os.time{year=string.sub(notiDay , 1 , 4) ,month=string.sub(notiDay , 5 , 6),day=string.sub(notiDay , 7 , 8) , hour=string.sub(notiDay , 9 , 10) , min=string.sub(notiDay , 11 , 12)})
		    local s = os.date(os.time{year=string.sub(now , 1 , 4) ,month=string.sub(now , 5 , 6),day=string.sub(now , 7 , 8) , hour=string.sub(now , 9 , 10) , min=string.sub(now , 11 , 12)})

		    local time = e-s




		    
			
			if time >= 0 then   	
				
				local alertCont = alertContent[sexNoti][planNoti][typeTable[i]]

				for j = 1 , #holidayTable do 
					if string.sub(notiDay ,5,6).."/"..string.sub(notiDay ,7,8) == holidayTable[j][1] then
				-- 		-- changeHoliday()
						print( "HHHHHHHHH"..holidayTable[j][2])
						alertCont = changeHoliday(sexNoti,planNoti,holidayTable[j][2],'holidayDg6') 
					end
				end


				local options = {
				   alert = alertCont ,
				   -- badge = 1,
				   -- sound = "notification.wav",
				   custom = { id = idTabel[i] }
				}
				
				notificationIDtable[idTabel[i]] = notifications.scheduleNotification( time , options )
			     print( notiDay.."=========="..time )
			     print( alertCont )
			    
			end
		end 
	end 
end

return M