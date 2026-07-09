local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local AmpUpsell = require(Parent.AmpUpsell)
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local ActionStatusEnum = AmpUpsell.AmpEnums.ActionStatusEnum
local ActionTypeEnum = AmpUpsell.AmpEnums.ActionTypeEnum
local AgeCheckUpsellDismissedData = require(Parent.GameDetail).AgeCheckUpsellDismissedData

local function onAmpWizardCompletion(p1, p2) -- line: 17
	-- upvalues: AccessResponseEnum (copy), ActionTypeEnum (copy), ActionStatusEnum (copy), AgeCheckUpsellDismissedData (copy)
	if p1 == AccessResponseEnum.Granted and (p2 and p2[ActionTypeEnum.AgeEstimation] == ActionStatusEnum.Success) then
		AgeCheckUpsellDismissedData.setAgeCheckUpsellDismissed()
	end
end

return onAmpWizardCompletion
