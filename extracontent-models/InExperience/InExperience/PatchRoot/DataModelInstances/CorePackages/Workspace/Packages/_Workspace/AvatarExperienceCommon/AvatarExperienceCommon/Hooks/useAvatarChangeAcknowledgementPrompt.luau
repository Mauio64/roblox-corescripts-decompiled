local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

local React = require(parent.React)

local getTimeoutStatusStore = require(AvatarExperienceCommon.Stores.TimeoutStatusStore.getTimeoutStatusStore)
local showAvatarChangeFeatureRestriction = require(AvatarExperienceCommon.Utils.showAvatarChangeFeatureRestriction)

local function useAvatarChangeAcknowledgementPrompt(flag: boolean)
	local timeoutStatusStore = getTimeoutStatusStore()

	React.useEffect(function()
		if not flag then
			return nil
		end

		local v = false
		timeoutStatusStore.fetchStatusAsync():andThen(function(p)
			if not v and p.requiresAcknowledgement then
				showAvatarChangeFeatureRestriction()
			end
		end)

		return function()
			v = true
		end
	end, { flag, timeoutStatusStore })
end

return useAvatarChangeAcknowledgementPrompt
