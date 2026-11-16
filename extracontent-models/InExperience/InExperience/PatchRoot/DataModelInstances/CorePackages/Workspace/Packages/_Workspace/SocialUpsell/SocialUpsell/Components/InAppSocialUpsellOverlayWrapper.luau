local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local parent = SocialUpsell.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)

local SocialUpsellType = require(SocialUpsell.Enum.SocialUpsellType)
local UpsellEntrySurfaceType = require(SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType)
local FAEUpsellOverlay = require(SocialUpsell.Components.FAEUpsellOverlay)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableAEGIS2CommsFAEUpsell = SharedFlags.FFlagEnableAEGIS2CommsFAEUpsell

local v = {
	isInExperience = false,
	upsellEntrySurface = UpsellEntrySurfaceType.Unknown,
	upsellType = SocialUpsellType.Unknown
}

return function(data)
	return (React.useMemo(function()
		local v2 = nil
		local union = Cryo.Dictionary.union(v, data.data or {})
		union.containerRef = data.containerRef

		if not FFlagEnableAEGIS2CommsFAEUpsell then
			union.isInExperience = false
		end

		if data.upsellType == SocialUpsellType.FacialAgeEstimation then
			return (React.createElement(FAEUpsellOverlay, union))
		end

		return v2
	end, { data.upsellType, data.data }))
end
