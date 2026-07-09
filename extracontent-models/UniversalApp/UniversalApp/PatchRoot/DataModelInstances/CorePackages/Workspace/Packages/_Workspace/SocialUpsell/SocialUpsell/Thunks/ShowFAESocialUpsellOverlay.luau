local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local SocialUpsellParent = SocialUpsell.Parent
local SetCentralOverlay = require(SocialUpsellParent.CentralOverlay).Actions.SetCentralOverlay
local SocialUpsellType = require(SocialUpsell.Enum.SocialUpsellType)
local CentralOverlayType = require(SocialUpsellParent.RobloxAppEnums).CentralOverlayType

return function(t1: {[any]: any}) -- line: 15
	-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy), SocialUpsellType (copy)
	return function(p1) -- line: 16
		-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy), t1 (copy), SocialUpsellType (copy)
		p1:dispatch(SetCentralOverlay(CentralOverlayType.SocialUpsellOverlay, {
			data = t1,
			upsellType = SocialUpsellType.FacialAgeEstimation
		}))
	end
end
