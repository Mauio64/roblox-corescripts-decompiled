local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/React")
local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/CentralOverlay")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/RobloxAppEnums")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/RoactUtils").Hooks.RoactRodux.useDispatch
local fFlagEnableAEGIS2CommsFAEUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SharedFlags").FFlagEnableAEGIS2CommsFAEUpsell

local centralOverlayType = RobloxAppEnums.CentralOverlayType

local setCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local closeCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay

require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Enum/SocialUpsellType")

local getOverlayStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Store/getOverlayStore")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Constants")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/Cryo")

local v5 = if fFlagEnableAEGIS2CommsFAEUpsell then getOverlayStore(false) else nil

return function(p2)
	local v6 = useDispatch()

	local v7 = React.useCallback(function(p3, p4)
		if p2 then
			if fFlagEnableAEGIS2CommsFAEUpsell and v5 then
				v5.setCurrentOverlay(Constants.OVERLAY_TYPES.SocialUpsell, {
					upsellType = p3,
					data = Cryo.Dictionary.join(p4, { isInExperience = p2 })
				})
			end
		else
			v6(setCentralOverlay(centralOverlayType.SocialUpsellOverlay, {
				upsellType = p3,
				data = p4
			}))
		end
	end, { p2 })

	local v8 = React.useCallback(function()
		if p2 then
			if fFlagEnableAEGIS2CommsFAEUpsell and v5 then
				v5.dismissCurrentOverlay()
			end
		else
			v6(closeCentralOverlay())
		end
	end, { p2 })

	return React.useMemo(function()
		return { openSocialOverlay = v7, closeSocialOverlay = v8 }
	end, { v7, v8 })
end
