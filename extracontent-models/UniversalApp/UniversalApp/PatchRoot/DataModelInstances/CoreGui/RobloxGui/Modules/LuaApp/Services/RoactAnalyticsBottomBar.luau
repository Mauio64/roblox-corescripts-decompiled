local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RoactAnalytics = require(script.Parent.RoactAnalytics)
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local buttonClick = require(Modules.LuaApp.Analytics.Events.buttonClick)

return {
	get = function(p1) -- line: 8
		-- upvalues: RoactAnalytics (copy), ArgCheck (copy), buttonClick (copy)
		local EventStream = RoactAnalytics.get(p1).EventStream

		return {
			ButtonActivated = function(p2, p3) -- line: 13
				-- upvalues: ArgCheck (copy), buttonClick (copy), EventStream (copy)
				ArgCheck.isType(p2, "string", "associatedPageType")
				ArgCheck.isType(p3, "string", "currentPage")
				buttonClick(EventStream, "BottomBarButton", p2, p3)
			end
		}
	end
}
