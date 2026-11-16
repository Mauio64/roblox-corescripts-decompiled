local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/React")

local SocialUpsellType = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Enum/SocialUpsellType")
local UpsellEntrySurfaceType = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Analytics/Enum/UpsellEntrySurfaceType")
local FAEUpsellOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Components/FAEUpsellOverlay")

local fFlagEnableAEGIS2CommsFAEUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SharedFlags").FFlagEnableAEGIS2CommsFAEUpsell

local v5 = {
	isInExperience = false,
	upsellEntrySurface = UpsellEntrySurfaceType.Unknown,
	upsellType = SocialUpsellType.Unknown
}

return function(data)
	return (React.useMemo(function()
		local v6 = nil
		local union = Cryo.Dictionary.union(v5, data.data or {})
		union.containerRef = data.containerRef

		if not fFlagEnableAEGIS2CommsFAEUpsell then
			union.isInExperience = false
		end

		if data.upsellType == SocialUpsellType.FacialAgeEstimation then
			v6 = React.createElement(FAEUpsellOverlay, union)
		end

		return v6
	end, { data.upsellType, data.data }))
end
