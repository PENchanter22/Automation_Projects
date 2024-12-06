#Requires AutoHotkey v1.1
;	*** environment configuration ***
#Persistent
#SingleInstance Force
#NoEnv
SetWorkingDir, %A_ScriptDir%
;	DetectHiddenWindows, On
SetTitleMatchMode, 2
;	SetBatchLines -1
;	#NoTrayIcon
;	#Warn All, OutputDebug

;	===========================================================================
;	===========================================================================
;			ADD an "Edit" button to the post-LinkShortener use !!
;	===========================================================================
;	===========================================================================
/*
;	---------------------------------------------------------------------------
;			This script currently processes Amazon, BestBuy, eBay and Temu URLs.
;	---------------------------------------------------------------------------

Amazon / BestBuy / CDkeys / eBay / Home Depot / Reddit / Target / Temu / Walmart

Static regexes := [
"(amazon\.com\/).*([dg]p\/(?:product\/)?\w+)", 
"(bestbuy\.com\/site\/).+(\/[\d]+\.p)", 
"(cdkeys\.com\/).+(g-\d+\.html)",		<<==-- DOES NOT WORK AS OF 2024-08-18
"(ebay\.com\/(?:p|itm)\/\d+)", 
"(homedepot\.com\/p\/)(?:.*\/)(\d{1,9})", 
"(reddit\.com\/r\/.+\/)(comments\/.+\/)(.+\/.+)?.+", 
"(target\.com\/p\/)(?:.+)(-\/.+)(?:\#.+)", 
"(temu\.com\/).+(g-\d+\.html)", 
"(walmart\.com\/ip\/)(?:.+)([0-9]{9})"]

https://www.cdkeys.com/7-days-to-die-pc-steam-cd-key?__currency=usd&utm_source=google&utm_medium=cpc&gad_source=1&gclid=CjwKCAjw8diwBhAbEiwA7i_sJU9065I4a7fLwajBrjzzmncoFUvHLXXnIoZLREPXNU4phwj_tfjYiRoChfEQAvD_BwE

;	https://www.homedepot.com/p/ROBERTS-Indoor-Pressure-Sensitive-15-ft-Carpet-Seaming-Tape-Roll-50-305-6/204470893?source=shoppingads&locale=en-US
;	https://www.homedepot.com/p/204470893/
	https://www.kingsize.com/products/rubber-clog-water-shoe/301921800.html?glCountry=US&glCurrency=USD&utm_source=google&utm_medium=ps_pla&utm_campaign=[ADL]+[PLA]+PMAX+-+Shoes&affiliate_id=049&affiliate_location_id=01&utm_adid=autoag0000x16402365062&gad_source=1&gclid=Cj0KCQjw5cOwBhCiARIsAJ5njuYhHRhcxuCnJNTF4U2uaghqFEwI9Smpn9286T1qQfINOx-Y1VcBk0QaAoDsEALw_wcB
	https://www.kingsize.com/products/rubber-clog-water-shoe/301921800.html
	https://www.kingsize.com/products/301921800.html
;	*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
;		Check below for other website URLs !!
;	*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
*/

TrayTipInfo:															; used in conjunction with 'ForceScriptExit:' labeled routine
	Menu, Tray, Tip, Amazon link stripper`n`nUse [F6]web/[F8]clipboard.`n`nUse [ESCape] to terminate script.

SysTrayIcon:
	If (!v_ScriptIcon)
;		 v_ScriptIcon		:= "rainbow link chain 0234 32x_r_2.ico"
;		 v_ScriptIcon		:= "URL_edit_004_225x225b.ico"
		 v_ScriptIcon		:= "URL shortener v7.1.ico"
		 v_ScriptIconFILE	:= A_ScriptDir . "\_icons_\" . v_ScriptIcon
;	If (!v_GameEXE2)
;		 v_GameEXE2 := ""
;	If FileExist(v_ScriptIconFILE)									;	do +NOT+ concatenate this using "."s (period(s))
;		{
;			v_ScriptIconFILE			:= A_ScriptDir . "\_icons_\" . v_ScriptIcon		;	concatenate this using "."s (period(s))
;		} Else {
;			v_ScriptIconFILE			:= v_GameEXE2
;		}
	If (!v_ScriptIconINDEX)
		 v_ScriptIconINDEX	:= 1
	If FileExist(v_ScriptIconFILE)
		{
			Try, Menu, Tray, Icon, %v_ScriptIconFILE%, %v_ScriptIconINDEX%
		} Else {
			OutputDebug, Custom icon not found in expected location!!`n`n%v_ScriptIconFILE%
		}

Global Shorted

AtTheTop:
;	----- let's begin -----
MsgBox, 262209, Please take note..., 
	( LTrim
		**** !! WARNING !! ****
		.    The 'Clipboard' will be OVERWRITTEN
		.    if you proceed !!!

		This script works on the following web pages:
		.    Amazon / BestBuy / eBay / Home Depot
		.    Reddit / Target / Temu & Walmart

		[F6] when web browser is on a supported web page
		.    NOTE: This script will only work with 
		.              Google Chrome or Mozilla Firefox.

		* OR *

		[F8] after you have manually copied
		.    a link to the 'Clipboard'
		.    from a supported web page

		[ESCape] to exit script when done.

		... click [OK] to begin ...
	)
	IfMsgBox Ok, {
		Return
	} Else IfMsgBox Cancel, {
		ExitApp
	}
Return

DisplayResults:
	vBefore		:= Clipboard
	vAfter		:= LinkShortener(Clipboard, Sort)
	Clipboard	:= vAfter
	MsgBox, 4160, Status: Link Saved, 
		( LTrim
			Amazon Link Stripper

			before:

			%vBefore%

			after: --- link below has been saved to 'Clipboard' !!!

			%vAfter%
		)
Return


!Escape::ExitApp				; ALT + ESCAPE
+F9::Reload


F6::
	Clipboard := ""
	Send, ^l
	Sleep 500
	Send ^c
	Sleep 500
	FoundPos := ""
	FoundPos := InStr(Clipboard, "http" , 0, 1, 1)
	If (!FoundPos)
		{
;			ErrorMessage("F6", Clipboard)
			ErrorMessage(Clipboard)
			Return
		}
	If (Clipboard)
		GoSub, 	DisplayResults
;		Clipboard := LinkShortener(Clipboard, Sort)
;	MsgBox, 262209, Status?, %Shorted%
Return

+F6::
	Clipboard := ""
	Send, ^l
	Sleep 500
	Send ^c
	Sleep 500
	FoundPos := ""
	FoundPos := InStr(Clipboard, "http" , 0, 1, 1)
	If (!FoundPos)
		{
;			ErrorMessage("+F6", Clipboard)
			ErrorMessage(Clipboard)
			ExitApp
		}
	If (Clipboard)
		GoSub, 	DisplayResults
;		Clipboard := LinkShortener(Clipboard, Sort)
;	MsgBox, 262209, Status?, %Shorted%
	ExitApp
Return

F8::
	FoundPos := ""
	FoundPos := InStr(Clipboard, "http" , 0, 1, 1)
	If (!FoundPos)
		{
;			ErrorMessage("F8", Clipboard)
			ErrorMessage(Clipboard)
			Return
		}
	If (Clipboard)
		GoSub, 	DisplayResults
;		Clipboard := LinkShortener(Clipboard, Sort)
;	MsgBox, 262209, Status?, %Shorted%
Return

+F8::
	FoundPos := ""
	FoundPos := InStr(Clipboard, "http" , 0, 1, 1)
	If (!FoundPos)
		{
;			ErrorMessage("+F8", Clipboard)
			ErrorMessage(Clipboard)
			ExitApp
		}
	If (Clipboard)
		GoSub, 	DisplayResults
;		Clipboard := LinkShortener(Clipboard, Sort)
;	MsgBox, 262209, Status?, %Shorted%
	ExitApp
Return

LinkShortener(Url, ByRef Shorted) {
;	static regexes := ["(amazon\.com\/).*([dg]p\/(?:product\/)?\w+)", "(ebay\.com\/(?:p|itm)\/\d+)", "(temu\.com\/).+(g-\d+\.html)"]
;	static regexes := ["(amazon\.com\/).*([dg]p\/(?:product\/)?\w+)", "(bestbuy\.com\/site\/).+(\/[\d]+\.p\?skuId\=[\d]+)", "(ebay\.com\/(?:p|itm)\/\d+)", "(temu\.com\/).+(g-\d+\.html)"]
;	Static regexes := ["(amazon\.com\/).*([dg]p\/(?:product\/)?\w+)", "(bestbuy\.com\/site\/).+(\/[\d]+\.p)", "(ebay\.com\/(?:p|itm)\/\d+)", "(homedepot\.com\/p\/)(?:.*\/)(\d{1,9})", "(reddit\.com\/r\/.+\/)(comments\/.+\/)(.+\/.+)?.+", "(target\.com\/p\/)(?:.+)(-\/.+)(?:\#.+)", "(temu\.com\/).+(g-\d+\.html)", "(walmart\.com\/ip\/)(?:.+)([0-9]{10})"]
;	Static regexes := ["(amazon\.com\/).*([dg]p\/(?:product\/)?\w+)", "(bestbuy\.com\/site\/).+(\/[\d]+\.p)", "(ebay\.com\/(?:p|itm)\/\d+)", "(homedepot\.com\/p\/)(?:.*\/)(\d{1,9})", "(reddit\.com\/r\/.+\/)(comments\/.+\/)(.+\/.+)?.+", "(target\.com\/p\/)(?:.+)(-\/.+)(?:\#.+)", "(temu\.com\/).+(g-\d+\.html)", "(walmart\.com\/ip\/)(?:.+\/)([0-9]+)"]
	Static regexes := ["(amazon\.com\/).*([dg]p\/(?:product\/)?\w+)", "(bestbuy\.com\/site\/).+(\/[\d]+\.p)", "(ebay\.com\/(?:p|itm)\/\d+)", "(homedepot\.com\/p\/)(?:.*\/)(\d{1,9})", "(reddit\.com\/r\/.+\/)(comments\/.+\/)(.+\/.+)?.+", "(target\.com\/p\/)(?:.+)(-\/.+)(?:\#.+)", "(temu\.com\/.+)(g-\d+\.html)", "(walmart\.com\/ip\/)(?:.+\/)([0-9]+)"]
;	Static regexes := ["(amazon\.com\/).*([dg]p\/(?:product\/)?\w+)","(amazon\.com\/).*([dg]p\/aw\/(?:product\/)?d\/\w+)", "(bestbuy\.com\/site\/).+(\/[\d]+\.p)", "(ebay\.com\/(?:p|itm)\/\d+)", "(homedepot\.com\/p\/)(?:.*\/)(\d{1,9})", "(reddit\.com\/r\/.+\/)(comments\/.+\/)(.+\/.+)?.+", "(target\.com\/p\/)(?:.+)(-\/.+)(?:\#.+)", "(temu\.com\/.+)(g-\d+\.html)", "(walmart\.com\/ip\/)(?:.+\/)([0-9]+)"]
	For _, regex In regexes {
		if (RegExMatch(Url, "iO)" regex, match)) {
			Shorted := "https://www." match[1] match[2] match[3]
;			Shorted := "http://" match[1] match[2]
			Return Shorted
;			return true
		}
	}
}

;ErrorMessage(hotkey, errmsg)
ErrorMessage(errmsg)
	{
;		MsgBox, 262160, x*x ERROR x*x, An error has occurred!!`n`nUnrecognized string below:`n`n%hotkey%`n%errmsg%
		MsgBox, 262160, x*x ERROR x*x, An error has occurred!!`n`nUnrecognized string below:`n`n%errmsg%
	}

;"https://www.reddit.com/r/nightingale/comments/1btv22c/comment/kxpgscx/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button"

/*	============================================================================
;	https://www.bestbuy.com/site/frigidaire-retro-3-2-cu-ft-mini-fridge-with-top-freezer/6546997.p?skuId=6546997

#~# Amazon
	https://www.amazon.com/Gagster-Dancing-Pickle-Yodeling-Hysterically/dp/B09YMFXDCJ/ref=sr_1_1_sspa?crid=216CJ0Y8IA98F&keywords=pickle&qid=1688666419&sprefix=pickle%2Caps%2C115&sr=8-1-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&psc=1

	RegEx this: https://www.amazon.com/Gagster-Dancing-Pickle-Yodeling-Hysterically/dp/B09YMFXDCJ/ref=...

	just need: https://www.amazon.com/dp/B09YMFXDCJ

	RegEx this: https://www.amazon.com/Gagster-Dancing-Pickle-Yodeling-Hysterically/dp/B09YMFXDCJ/ref=...

	just need : https://www.amazon.com/dp/B09YMFXDCJ

	RegExMatch(vURL, "\/[dg]p\/(product\/)?\w+", linkId)
	Return, "http://www.amazon.com" linkId

	static regexes := ["(amazon\.com\/).*([dg]p\/(?:product\/)?\w+)", "(http.+bestbuy.+site\/)(?:.+\/)([\d]+.+)", "(ebay\.com\/(?:p|itm)\/\d+)","(temu\.com\/).+(g-\d+\.html)"]

### BestBuy

	[original]
	https://www.bestbuy.com/site/frigidaire-retro-3-2-cu-ft-mini-fridge-with-top-freezer/6546997.p?skuId=6546997

	[RegEx]
	(bestbuy\.com\/site\/).+(\/[\d]+\.p\?skuId\=[\d]+)

	[post-processed]
	https://www.bestbuy.com/site/6546997.p?skuId=6546997

	$1 = https://www.bestbuy.com/site/
	$2 = 6546997.p?skuId=6546997

### eBay
	https://www.ebay.com/itm/255417038511?itemid=255417038511&norover=1&siteid=0&mkevt=1&mkrid=711-198453-24755-9&mkcid=16&chn=psoc&tag4=23852939748870478&tracking=23852939754250478&utm_medium=social&utm_source=facebook+instagram+audience_network+messenger&utm_campaign=US_SOC_All_FB_DPA_LF_AA%28Control%29+&utm_content=DABA_AdID_23852939754250478&utm_id=63d04545cbf5c1e84d74d4ac&fbclid=IwAR0dwpeQORHkg8EYQrhjl_H7raiRnB8W7UEvz7_q6yRounh9AhuRgYMtjWs

	RegEx this: https://www.ebay.com/itm/255417038511?...

	just need: https://www.ebay.com/itm/255417038511

	RegExMatch(vURL, "...", linkId)
	Return, "http://www.ebay.com" linkId

	RegExMatch(vURL, "^(.+\.com\/.+)\?", linkId)

#~# TEMU
	https://www.temu.com/1pcyodelling-pickle-musical-toy-fun-for-all-ages-great-gift-mindless-entertainment-toy-g-601099515952740.html?top_gallery_url=https%3A%2F%2Fimg.kwcdn.com%2Fproduct%2FFancyalgo%2FVirtualModelMatting%2F062dbebedd4b940b98c5322f0ced1a1d.jpg&spec_gallery_id=24681991&refer_page_sn=10009&refer_source=0&freesia_scene=2&_oak_freesia_scene=2&search_key=pickle&_x_channel_scene=spike&_x_channel_src=1&_x_vst_scene=adg&_x_ads_sub_channel=search&_x_ads_channel=google&_x_ads_account=1213016319&_x_ads_set=19694142866&_x_ads_id=141345685810&_x_ads_creative_id=648389974220&_x_ns_source=g&_x_ns_gclid=CjwKCAjwzJmlBhBBEiwAEJyLu79mWtb1-UnI8LGl6m-K8fMIvzGMJtJj2wX8z3DKxxaGPUeD8cymMxoCebQQAvD_BwE&_x_ns_placement=&_x_ns_match_type=e&_x_ns_ad_position=&_x_ns_product_id=&_x_ns_target=&_x_ns_devicemodel=&_x_ns_wbraid=CjkKCQjwqZSlBhCzARIoAGEplCd45S0EinzCsdpNObdKKHQK7USc4JqgtujIwg4vwi8yxKlsKxoCd_Y&_x_ns_gbraid=0AAAAAo4mICFgQLaWwmSKzaA0K0VdV9DET&_x_ns_keyword=temu&_x_ns_targetid=kwd-5681707004&_x_sessn_id=z5vktfiamt&refer_page_name=search_result&refer_page_id=10009_1688666186341_dbbx9q5lbg

	RegEx this: https://www.temu.com/1pcyodelling-pickle-musical-toy-fun-for-all-ages-great-gift-mindless-entertainment-toy-g-601099515952740.html?....
	just need: https://www.temu.com/1pcyodelling-pickle-musical-toy-fun-for-all-ages-great-gift-mindless-entertainment-toy-g-601099515952740.html

	RegEx this: https://www.temu.com/1pcyodelling-pickle-musical-toy-fun-for-all-ages-great-gift-mindless-entertainment-toy-g-601099515952740.html?....

	just need : https://www.temu.com/1pcyodelling-pickle-musical-toy-fun-for-all-ages-great-gift-mindless-entertainment-toy-g-601099515952740.html

	RegExMatch(vURL, "...", linkId)
	Return, "http://www.temu.com" linkId

;	============================================================================
*/
