local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/UniversalFeatureRestrictions/AbuseVector")
local showFeatureRestriction = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/UniversalFeatureRestrictions/showFeatureRestriction")
local getTimeoutStatusStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/TimeoutStatusStore/getTimeoutStatusStore")

local fFlagAXTimeoutAcknowledgementGating = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags").FFlagAXTimeoutAcknowledgementGating

local function showAvatarChangeFeatureRestriction()
	if fFlagAXTimeoutAcknowledgementGating then
		task.spawn(function()
			showFeatureRestriction(AbuseVector.AvatarChange, {
				onAcknowledgementSuccess = function()
					local v5 = getTimeoutStatusStore(false)

					if not v5.clearStatusIfServed() then
						v5.refreshStatus()
					end
				end
			})
		end)
	else
		showFeatureRestriction(AbuseVector.AvatarChange)
	end
end

return showAvatarChangeFeatureRestriction
