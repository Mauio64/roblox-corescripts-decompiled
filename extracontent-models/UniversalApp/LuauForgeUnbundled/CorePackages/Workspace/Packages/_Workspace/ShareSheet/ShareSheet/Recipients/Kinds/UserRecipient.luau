local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/Kinds/RecipientKind")
local UserProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/DataHydration/UserProfile")
local useExternalChatUserEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/AppChat/useExternalChatUserEligibility")

return {
	create = function(p2)
		return { kind = "user", id = `user:{p2}`, userId = p2 }
	end,
	kind = {
		useEligibility = function(p2)
			local v5 = useExternalChatUserEligibility({
				isActive = p2.isActive and #p2.recipients > 0
			})

			return React.useMemo(function()
				return {
					isLoading = v5.isLoading,
					isEligible = function()
						return v5.isEligible
					end
				}
			end, { v5 })
		end,
		canSend = function(p2, p3)
			return p2.canSendToUser(p3.userId)
		end,
		send = function(p2, p3, p4)
			return p2.sendToUser(p3.userId, p4)
		end,
		getName = function(p2, p3)
			local info = UserProfile.getAndFetchUserInfo(p2.userId).info(p3)

			if info then
				return info.displayName
			end

			return ""
		end,
		getParticipantIds = function(p2)
			return { p2.userId }
		end
	}
}
