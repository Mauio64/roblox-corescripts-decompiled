local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)

return {
	get = function(p1) -- line: 10
		-- upvalues: RoactAnalytics (copy)
		local v4 = RoactAnalytics.get(p1)

		return {
			inviteePageLoad = function(p2, p3) -- line: 15
				-- upvalues: v4 (copy)
				v4.EventStream:setRBXEventStream("profileShareLink", "luaPageLoad", {
					target = "mobile",
					referringUserId = p2,
					page = p3
				})
			end,
			inviterButtonClick = function(p4) -- line: 25
				-- upvalues: v4 (copy)
				v4.EventStream:setRBXEventStream("profileShareLink", "buttonClick", {
					btn = "userShareProfileLink",
					target = "mobile",
					page = p4
				})
			end
		}
	end
}
