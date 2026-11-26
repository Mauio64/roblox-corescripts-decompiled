local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")

local TransferFAEBlockSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/Generic/TransferFAEBlockSheet")
local SubscriptionUpsellContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/Generic/SubscriptionUpsellContainer")
local VPCBlockContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/Generic/VPCBlockContainer")

local useTransferStore = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useTransferStore")

require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferDirection")

local AmpWizardTransferConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Constants/AmpWizardTransferConstants")

local function TransferBlockSheet(p2)
	local v5 = useTransferStore()
	local direction = v5.getDirection(false)
	local ampRecourseActions = v5.getAmpRecourseActions(false)
	local ampFeatureCheck = v5.getAmpFeatureCheck(false)

	local v6 = false
	local v7 = false
	local v8 = false

	if ampRecourseActions then
		for i, ampRecourseAction in ipairs(ampRecourseActions) do
			if ampRecourseAction == AmpWizardTransferConstants.RECOURSE_PLUS_SUBSCRIPTION then
				v6 = true
			elseif
				ampRecourseAction == AmpWizardTransferConstants.RECOURSE_ID_VERIFICATION
				or ampRecourseAction == AmpWizardTransferConstants.RECOURSE_AGE_ESTIMATION
			then
				v7 = true
			elseif
				ampRecourseAction == AmpWizardTransferConstants.RECOURSE_PARENT_LINK
				or ampRecourseAction == AmpWizardTransferConstants.RECOURSE_PARENT_CONSENT
			then
				v8 = true
			end
		end
	end

	local v9 = {
		direction = direction,
		ampRecourseActions = ampRecourseActions,
		ampFeatureCheck = ampFeatureCheck
	}

	if v6 and direction then
		return React.createElement(SubscriptionUpsellContainer, {
			direction = v9.direction,
			ampRecourseActions = v9.ampRecourseActions,
			ampFeatureCheck = v9.ampFeatureCheck
		})
	end

	if v7 and direction then
		return React.createElement(TransferFAEBlockSheet, {
			direction = v9.direction,
			ampRecourseActions = v9.ampRecourseActions,
			ampFeatureCheck = v9.ampFeatureCheck
		})
	end

	if v8 and direction then
		return React.createElement(VPCBlockContainer, {
			direction = v9.direction,
			ampRecourseActions = v9.ampRecourseActions,
			ampFeatureCheck = v9.ampFeatureCheck
		})
	end

	return React.createElement(React.Fragment)
end

return TransferBlockSheet
