local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local AmpUpsell = require(parent.AmpUpsell)
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local ActionStatusEnum = AmpUpsell.AmpEnums.ActionStatusEnum
local ActionTypeEnum = AmpUpsell.AmpEnums.ActionTypeEnum

local GameDetail = require(parent.GameDetail)
local AgeCheckUpsellDismissedData = GameDetail.AgeCheckUpsellDismissedData

local function onAmpWizardCompletion(p, p2)
	if p == AccessResponseEnum.Granted and p2 and p2[ActionTypeEnum.AgeEstimation] == ActionStatusEnum.Success then
		AgeCheckUpsellDismissedData.setAgeCheckUpsellDismissed()
	end
end

return onAmpWizardCompletion
