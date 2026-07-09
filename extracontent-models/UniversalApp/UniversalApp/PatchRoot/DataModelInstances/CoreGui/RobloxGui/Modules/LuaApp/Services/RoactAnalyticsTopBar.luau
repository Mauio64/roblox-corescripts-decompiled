local Modules = game:GetService("CoreGui").RobloxGui.Modules
local search = require(Modules.LuaApp.Analytics.Events.search)
local nsOpenCTAShown = require(Modules.LuaApp.Analytics.Events.nsOpenCTAShown)
local nsOpenContent = require(Modules.LuaApp.Analytics.Events.nsOpenContent)
local buttonClick = require(Modules.LuaApp.Analytics.Events.buttonClick)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)

return {
	get = function(p1) -- line: 16
		-- upvalues: RoactAnalytics (copy), search (copy), buttonClick (copy), nsOpenContent (copy), nsOpenCTAShown (copy)
		local v8 = RoactAnalytics.get(p1)

		return {
			reportSearchButtonClick = function(p2) -- line: 25
				-- upvalues: buttonClick (copy), v8 (copy)
				buttonClick(v8.EventStream, p2, "search")
			end,
			reportSearchFocused = function(p3) -- line: 29
				-- upvalues: search (copy), v8 (copy)
				search(v8.EventStream, p3, "open", nil)
			end,
			reportSearched = function(p4, p5) -- line: 33
				-- upvalues: search (copy), v8 (copy)
				search(v8.EventStream, p4, "search", p5)
			end,
			reportSearchCanceled = function(p6) -- line: 37
				-- upvalues: search (copy), v8 (copy)
				search(v8.EventStream, p6, "cancel", nil)
			end,
			reportNSButtonTouch = function(p7) -- line: 41
				-- upvalues: nsOpenContent (copy), v8 (copy)
				nsOpenContent(v8.EventStream, "touch", p7)
			end,
			reportNSOpenCTAShown = function(p8) -- line: 45
				-- upvalues: nsOpenCTAShown (copy), v8 (copy)
				nsOpenCTAShown(v8.EventStream, "seen", p8)
			end,
			reportRobuxButtonClick = function(p9) -- line: 49
				-- upvalues: buttonClick (copy), v8 (copy)
				buttonClick(v8.EventStream, p9, "robux")
			end,
			reportBackButtonClick = function(p10) -- line: 53
				-- upvalues: buttonClick (copy), v8 (copy)
				buttonClick(v8.EventStream, p10, "back")
			end,
			reportAddFriendsButtonClick = function(p11) -- line: 57
				-- upvalues: buttonClick (copy), v8 (copy)
				buttonClick(v8.EventStream, p11, "addFriends")
			end
		}
	end
}
