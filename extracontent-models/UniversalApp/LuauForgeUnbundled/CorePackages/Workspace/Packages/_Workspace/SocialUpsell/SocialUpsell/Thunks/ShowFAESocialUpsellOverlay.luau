local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/CentralOverlay").Actions.SetCentralOverlay
local SocialUpsellType = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Enum/SocialUpsellType")
local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/RobloxAppEnums").CentralOverlayType

return function(p2)
	return function(object)
		object:dispatch(setCentralOverlay(centralOverlayType.SocialUpsellOverlay, {
			data = p2,
			upsellType = SocialUpsellType.FacialAgeEstimation
		}))
	end
end
