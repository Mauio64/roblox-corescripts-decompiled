local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")

local getTimeoutStatusStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/TimeoutStatusStore/getTimeoutStatusStore")
local showAvatarChangeFeatureRestriction = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/showAvatarChangeFeatureRestriction")

local function useAvatarChangeAcknowledgementPrompt(p2)
	local v5 = getTimeoutStatusStore()

	React.useEffect(function()
		if not p2 then
			return nil
		end

		local v6 = false
		v5.fetchStatusAsync():andThen(function(p3)
			if not v6 and p3.requiresAcknowledgement then
				showAvatarChangeFeatureRestriction()
			end
		end)

		return function()
			v6 = true
		end
	end, { p2, v5 })
end

return useAvatarChangeAcknowledgementPrompt
