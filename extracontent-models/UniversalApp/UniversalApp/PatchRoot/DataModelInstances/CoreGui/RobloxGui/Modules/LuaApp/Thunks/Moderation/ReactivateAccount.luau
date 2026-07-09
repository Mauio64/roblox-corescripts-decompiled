local GuiService = game:GetService("GuiService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local Promise = require(Modules.LuaApp.Promise)
local PostReactivate = require(Modules.LuaApp.Http.Requests.ModerationAPI.PostReactivate)
local SetModerationStatus = require(Modules.LuaApp.Actions.Moderation.SetModerationStatus)

return function(p1, p2) -- line: 13
	-- upvalues: PostReactivate (copy), SetModerationStatus (copy), GuiService (copy), NotificationType (copy), Promise (copy)
	return function(p3) -- line: 14
		-- upvalues: PostReactivate (copy), p1 (copy), p2 (copy), SetModerationStatus (copy), GuiService (copy), NotificationType (copy), Promise (copy)
		return PostReactivate(p1, p2):andThen(function(_) -- line: 15
			-- upvalues: p3 (copy), SetModerationStatus (copy), GuiService (copy), NotificationType (copy), Promise (copy)
			p3:dispatch(SetModerationStatus(false))
			GuiService:BroadcastNotification("", NotificationType.RESTART_LUA_APP)

			return Promise.resolve()
		end, function(p5) -- line: 20
			-- upvalues: Promise (copy)
			return Promise.reject({
				error = p5
			})
		end)
	end
end
