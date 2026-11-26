local AmpUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/AmpUpsell")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Constants")
local inExpAmpWizardController = AmpUpsell.InExpAmpWizardController
local accessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum

local DEFAULT_FAE_ENTRY_POINT_EVENT_CTX = Constants.DEFAULT_FAE_ENTRY_POINT_EVENT_CTX

local FStringCommsFAEFeatureName = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Flag/FStringCommsFAEFeatureName")
local FStringCommsFAENamespace = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Flag/FStringCommsFAENamespace")

return function(p2, callback, callback2)
	return inExpAmpWizardController.OpenAmpWizardContainerInExp(FStringCommsFAEFeatureName, function(p3, p4)
		if p3 == accessResponseEnum.Granted then
			if callback then
				callback()
			end
		elseif callback2 then
			callback2()
		end
	end, nil, p2 or DEFAULT_FAE_ENTRY_POINT_EVENT_CTX, nil, FStringCommsFAENamespace)
end
