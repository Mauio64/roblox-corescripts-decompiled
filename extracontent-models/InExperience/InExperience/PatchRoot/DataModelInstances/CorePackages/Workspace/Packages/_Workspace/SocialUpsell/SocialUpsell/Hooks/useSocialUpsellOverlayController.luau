local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local SocialUpsellParent = SocialUpsell.Parent
local React = require(SocialUpsellParent.React)
local CentralOverlay = require(SocialUpsellParent.CentralOverlay)
local RobloxAppEnums = require(SocialUpsellParent.RobloxAppEnums)
local useDispatch = require(SocialUpsellParent.RoactUtils).Hooks.RoactRodux.useDispatch
local FFlagEnableAEGIS2CommsFAEUpsell = require(SocialUpsellParent.SharedFlags).FFlagEnableAEGIS2CommsFAEUpsell
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay

require(SocialUpsell.Enum.SocialUpsellType)

local getOverlayStore = require(SocialUpsell.Store.getOverlayStore)
local Constants = require(SocialUpsell.Constants)
local Cryo = require(SocialUpsellParent.Cryo)
local u14 = nil

if FFlagEnableAEGIS2CommsFAEUpsell then
	u14 = getOverlayStore(false)
end

return function(b1: boolean) -- line: 32
	-- upvalues: useDispatch (copy), React (copy), FFlagEnableAEGIS2CommsFAEUpsell (copy), u14 (ref), Constants (copy), Cryo (copy), SetCentralOverlay (copy), CentralOverlayType (copy), CloseCentralOverlay (copy)
	local v16 = useDispatch()
	local v17 = React.useCallback(function(p1, p2) -- line: 35
		-- upvalues: b1 (copy), FFlagEnableAEGIS2CommsFAEUpsell (copy), u14 (ref), Constants (copy), Cryo (copy), v16 (copy), SetCentralOverlay (copy), CentralOverlayType (copy)
		if b1 then
			if FFlagEnableAEGIS2CommsFAEUpsell and u14 then
				u14.setCurrentOverlay(Constants.OVERLAY_TYPES.SocialUpsell, {
					upsellType = p1,
					data = Cryo.Dictionary.join(p2, {
						isInExperience = b1
					})
				})

				return
			end
		else
			v16(SetCentralOverlay(CentralOverlayType.SocialUpsellOverlay, {
				upsellType = p1,
				data = p2
			}))
		end
	end, { b1 })
	local v18 = React.useCallback(function() -- line: 53
		-- upvalues: b1 (copy), FFlagEnableAEGIS2CommsFAEUpsell (copy), u14 (ref), v16 (copy), CloseCentralOverlay (copy)
		if b1 then
			if FFlagEnableAEGIS2CommsFAEUpsell and u14 then
				u14.dismissCurrentOverlay()

				return
			end
		else
			v16(CloseCentralOverlay())
		end
	end, { b1 })

	return React.useMemo(function() -- line: 63
		-- upvalues: v17 (copy), v18 (copy)
		return {
			openSocialOverlay = v17,
			closeSocialOverlay = v18
		}
	end, {
		v17,
		v18
	})
end
