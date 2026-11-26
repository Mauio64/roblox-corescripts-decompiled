local module = require("@luauforge/bundled/fvU")
local module2 = require("@luauforge/bundled/fvV")
local module3 = require("@luauforge/bundled/fvW")
local module4 = require("@luauforge/bundled/fvX")
local module5 = require("@luauforge/bundled/ecq")

return {
	get = function(p2)
		local v5 = module5.get(p2)

		return {
			reportSearchButtonClick = function(p3)
				module4(v5.EventStream, p3, "search")
			end,
			reportSearchFocused = function(p3)
				module(v5.EventStream, p3, "open", nil)
			end,
			reportSearched = function(p3, p4)
				module(v5.EventStream, p3, "search", p4)
			end,
			reportSearchCanceled = function(p3)
				module(v5.EventStream, p3, "cancel", nil)
			end,
			reportNSButtonTouch = function(p3)
				module3(v5.EventStream, "touch", p3)
			end,
			reportNSOpenCTAShown = function(p3)
				module2(v5.EventStream, "seen", p3)
			end,
			reportRobuxButtonClick = function(p3)
				module4(v5.EventStream, p3, "robux")
			end,
			reportBackButtonClick = function(p3)
				module4(v5.EventStream, p3, "back")
			end,
			reportAddFriendsButtonClick = function(p3)
				module4(v5.EventStream, p3, "addFriends")
			end
		}
	end
}
