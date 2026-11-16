local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local parent = SocialUpsell.Parent

local AmpUpsell = require(parent.AmpUpsell)
local Constants = require(SocialUpsell.Constants)
local InExpAmpWizardController = AmpUpsell.InExpAmpWizardController
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum

local DEFAULT_FAE_ENTRY_POINT_EVENT_CTX = Constants.DEFAULT_FAE_ENTRY_POINT_EVENT_CTX

local FStringCommsFAEFeatureName = require(SocialUpsell.Flag.FStringCommsFAEFeatureName)
local FStringCommsFAENamespace = require(SocialUpsell.Flag.FStringCommsFAENamespace)

return function(p: string?, callback, callback2)
	return InExpAmpWizardController.OpenAmpWizardContainerInExp(FStringCommsFAEFeatureName, function(p2, _)
		if p2 == AccessResponseEnum.Granted then
			if callback then
				callback()
			end
		elseif callback2 then
			callback2()
		end
	end, nil, p or DEFAULT_FAE_ENTRY_POINT_EVENT_CTX, nil, FStringCommsFAENamespace)
end
