local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local parent = SocialUpsell.Parent

local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local SocialUpsellType = require(SocialUpsell.Enum.SocialUpsellType)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType

return function(p)
	return function(object)
		object:dispatch(SetCentralOverlay(CentralOverlayType.SocialUpsellOverlay, {
			data = p,
			upsellType = SocialUpsellType.FacialAgeEstimation
		}))
	end
end
