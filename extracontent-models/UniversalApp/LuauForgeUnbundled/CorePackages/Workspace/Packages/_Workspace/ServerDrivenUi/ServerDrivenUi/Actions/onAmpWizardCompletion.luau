local AmpUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AmpUpsell")
local accessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local actionStatusEnum = AmpUpsell.AmpEnums.ActionStatusEnum
local actionTypeEnum = AmpUpsell.AmpEnums.ActionTypeEnum

local ageCheckUpsellDismissedData = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GameDetail").AgeCheckUpsellDismissedData

local function onAmpWizardCompletion(p2, p3)
	if
		p2 == accessResponseEnum.Granted
		and p3
		and p3[actionTypeEnum.AgeEstimation] == actionStatusEnum.Success
	then
		ageCheckUpsellDismissedData.setAgeCheckUpsellDismissed()
	end
end

return onAmpWizardCompletion
