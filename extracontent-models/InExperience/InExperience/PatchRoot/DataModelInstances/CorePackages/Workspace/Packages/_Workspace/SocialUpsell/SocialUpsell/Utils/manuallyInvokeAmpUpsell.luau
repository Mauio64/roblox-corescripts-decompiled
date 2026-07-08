local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local SocialUpsellParent = SocialUpsell.Parent
local AmpUpsell = require(SocialUpsellParent.AmpUpsell)
local Constants = require(SocialUpsell.Constants)
local InExpAmpWizardController = AmpUpsell.InExpAmpWizardController
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local DEFAULT_FAE_ENTRY_POINT_EVENT_CTX = Constants.DEFAULT_FAE_ENTRY_POINT_EVENT_CTX
local FStringCommsFAEFeatureName = require(SocialUpsell.Flag.FStringCommsFAEFeatureName)
local FStringCommsFAENamespace = require(SocialUpsell.Flag.FStringCommsFAENamespace)

return function(s1: string?, p1: ((...any) -> ...any)?, p2: ((...any) -> ...any)?) -- line: 14
	-- upvalues: DEFAULT_FAE_ENTRY_POINT_EVENT_CTX (copy), InExpAmpWizardController (copy), FStringCommsFAEFeatureName (copy), AccessResponseEnum (copy), FStringCommsFAENamespace (copy)
	local v13 = s1 or DEFAULT_FAE_ENTRY_POINT_EVENT_CTX

	return InExpAmpWizardController.OpenAmpWizardContainerInExp(FStringCommsFAEFeatureName, function(p3, _) -- line: 18
		-- upvalues: AccessResponseEnum (copy), p1 (copy), p2 (copy)
		if p3 == AccessResponseEnum.Granted then
			if p1 then
				p1()

				return
			end
		elseif p2 then
			p2()
		end
	end, nil, v13, nil, FStringCommsFAENamespace)
end
