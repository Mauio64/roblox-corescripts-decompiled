local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local SocialUpsellParent = SocialUpsell.Parent
local Cryo = require(SocialUpsellParent.Cryo)
local React = require(SocialUpsellParent.React)
local SocialUpsellType = require(SocialUpsell.Enum.SocialUpsellType)
local UpsellEntrySurfaceType = require(SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType)
local FAEUpsellOverlay = require(SocialUpsell.Components.FAEUpsellOverlay)
local FFlagEnableAEGIS2CommsFAEUpsell = require(SocialUpsellParent.SharedFlags).FFlagEnableAEGIS2CommsFAEUpsell
local t1 = {
	isInExperience = false,
	upsellEntrySurface = UpsellEntrySurfaceType.Unknown,
	upsellType = SocialUpsellType.Unknown
}

return function(t2: {[any]: any}) -- line: 27
	-- upvalues: React (copy), Cryo (copy), t1 (copy), FFlagEnableAEGIS2CommsFAEUpsell (copy), SocialUpsellType (copy), FAEUpsellOverlay (copy)
	return (React.useMemo(function() -- line: 28
		-- upvalues: Cryo (copy), t1 (copy), t2 (copy), FFlagEnableAEGIS2CommsFAEUpsell (copy), SocialUpsellType (copy), React (copy), FAEUpsellOverlay (copy)
		local v11 = nil
		local v12 = Cryo.Dictionary.union(t1, t2.data or {})

		v12.containerRef = t2.containerRef

		if not FFlagEnableAEGIS2CommsFAEUpsell then
			v12.isInExperience = false
		end

		if t2.upsellType == SocialUpsellType.FacialAgeEstimation then
			v11 = React.createElement(FAEUpsellOverlay, v12)
		end

		return v11
	end, {
		t2.upsellType,
		t2.data
	}))
end
