local parent = script:FindFirstAncestor("ShareSheet").Parent

local React = require(parent.React)

require(script.Parent.RecipientKind)
local UserProfile = require(parent.DataHydration.UserProfile)
local useExternalChatUserEligibility = require(parent.AppChat.useExternalChatUserEligibility)

return {
	create = function(userId: string)
		return { kind = "user", id = `user:{userId}`, userId = userId }
	end,
	kind = {
		useEligibility = function(p)
			local v = useExternalChatUserEligibility({
				isActive = p.isActive and #p.recipients > 0
			})

			return React.useMemo(function()
				return {
					isLoading = v.isLoading,
					isEligible = function()
						return v.isEligible
					end
				}
			end, { v })
		end,
		canSend = function(p, p2)
			return p.canSendToUser(p2.userId)
		end,
		send = function(p, p2, p3)
			return p.sendToUser(p2.userId, p3)
		end,
		getName = function(p, p2)
			local info = UserProfile.getAndFetchUserInfo(p.userId).info(p2)
			return if info then info.displayName else ""
		end,
		getParticipantIds = function(p)
			return { p.userId }
		end
	}
}
