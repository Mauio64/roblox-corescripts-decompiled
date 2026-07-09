local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local PostReactivateAccount = require(NotApprovedPage.Http.PostReactivateAccount)
local NotApprovedPageParent = NotApprovedPage.Parent
local Promise = require(NotApprovedPageParent.Promise)
local NotificationType = require(NotApprovedPageParent.RobloxAppEnums).NotificationType
local SetModerationStatus = require(NotApprovedPageParent.NotApprovedPageShared).SetModerationStatus
local GuiService = game:GetService("GuiService")

local function ReactivateAccount(p1, n1: number) -- line: 12
	-- upvalues: PostReactivateAccount (copy), SetModerationStatus (copy), GuiService (copy), NotificationType (copy), Promise (copy)
	return function(p2) -- line: 13
		-- upvalues: PostReactivateAccount (copy), p1 (copy), n1 (copy), SetModerationStatus (copy), GuiService (copy), NotificationType (copy), Promise (copy)
		return PostReactivateAccount(p1, n1):andThen(function(_) -- line: 14
			-- upvalues: p2 (copy), SetModerationStatus (copy), GuiService (copy), NotificationType (copy), Promise (copy)
			p2:dispatch(SetModerationStatus(false))
			GuiService:BroadcastNotification("", NotificationType.RESTART_LUA_APP)

			return Promise.resolve()
		end, function(p4) -- line: 18
			-- upvalues: Promise (copy)
			return Promise.reject({
				error = p4
			})
		end)
	end
end

return ReactivateAccount
