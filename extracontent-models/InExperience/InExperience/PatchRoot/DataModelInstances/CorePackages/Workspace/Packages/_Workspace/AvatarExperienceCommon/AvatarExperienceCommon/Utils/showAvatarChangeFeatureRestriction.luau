local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

local AbuseVector = require(parent.UniversalFeatureRestrictions.AbuseVector)
local showFeatureRestriction = require(parent.UniversalFeatureRestrictions.showFeatureRestriction)
local getTimeoutStatusStore = require(AvatarExperienceCommon.Stores.TimeoutStatusStore.getTimeoutStatusStore)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXTimeoutAcknowledgementGating = AvatarExperienceFlags.FFlagAXTimeoutAcknowledgementGating

local function showAvatarChangeFeatureRestriction()
	if FFlagAXTimeoutAcknowledgementGating then
		task.spawn(function()
			showFeatureRestriction(AbuseVector.AvatarChange, {
				onAcknowledgementSuccess = function()
					local timeoutStatusStore = getTimeoutStatusStore(false)

					if not timeoutStatusStore.clearStatusIfServed() then
						timeoutStatusStore.refreshStatus()
					end
				end
			})
		end)
	else
		showFeatureRestriction(AbuseVector.AvatarChange)
	end
end

return showAvatarChangeFeatureRestriction
