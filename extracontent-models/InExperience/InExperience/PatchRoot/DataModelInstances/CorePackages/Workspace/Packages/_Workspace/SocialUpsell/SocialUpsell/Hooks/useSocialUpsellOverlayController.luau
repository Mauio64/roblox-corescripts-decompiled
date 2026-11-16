local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local parent = SocialUpsell.Parent

local React = require(parent.React)
local CentralOverlay = require(parent.CentralOverlay)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableAEGIS2CommsFAEUpsell = SharedFlags.FFlagEnableAEGIS2CommsFAEUpsell

local CentralOverlayType = RobloxAppEnums.CentralOverlayType

local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay

require(SocialUpsell.Enum.SocialUpsellType)

local getOverlayStore = require(SocialUpsell.Store.getOverlayStore)

local Constants = require(SocialUpsell.Constants)

local Cryo = require(parent.Cryo)
local v

if FFlagEnableAEGIS2CommsFAEUpsell then
	v = getOverlayStore(false)
else
	v = nil
end

return function(isInExperience: boolean)
	local v2 = useDispatch()

	local openSocialOverlay = React.useCallback(function(upsellType, p)
		if isInExperience then
			if FFlagEnableAEGIS2CommsFAEUpsell and v then
				v.setCurrentOverlay(Constants.OVERLAY_TYPES.SocialUpsell, {
					upsellType = upsellType,
					data = Cryo.Dictionary.join(p, { isInExperience = isInExperience })
				})
			end
		else
			v2(SetCentralOverlay(CentralOverlayType.SocialUpsellOverlay, {
				upsellType = upsellType,
				data = p
			}))
		end
	end, { isInExperience })

	local closeSocialOverlay = React.useCallback(function()
		if isInExperience then
			if FFlagEnableAEGIS2CommsFAEUpsell and v then
				v.dismissCurrentOverlay()
			end
		else
			v2(CloseCentralOverlay())
		end
	end, { isInExperience })

	return React.useMemo(function()
		return { openSocialOverlay = openSocialOverlay, closeSocialOverlay = closeSocialOverlay }
	end, { openSocialOverlay, closeSocialOverlay })
end
