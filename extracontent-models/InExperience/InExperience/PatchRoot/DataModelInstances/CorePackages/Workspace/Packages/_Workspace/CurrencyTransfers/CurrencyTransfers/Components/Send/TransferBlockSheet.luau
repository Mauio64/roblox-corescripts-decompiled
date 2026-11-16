local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local React = require(parent.React)

local TransferFAEBlockSheet = require(CurrencyTransfers.Components.Generic.TransferFAEBlockSheet)
local SubscriptionUpsellContainer = require(CurrencyTransfers.Components.Generic.SubscriptionUpsellContainer)
local VPCBlockContainer = require(CurrencyTransfers.Components.Generic.VPCBlockContainer)

local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)

require(CurrencyTransfers.Enums.TransferDirection)

local AmpWizardTransferConstants = require(CurrencyTransfers.Constants.AmpWizardTransferConstants)

local function TransferBlockSheet(_)
	local v = useTransferStore()
	local direction = v.getDirection(false)
	local ampRecourseActions = v.getAmpRecourseActions(false)
	local ampFeatureCheck = v.getAmpFeatureCheck(false)

	local v2 = false
	local v3 = false
	local v4 = false

	if ampRecourseActions then
		for _, ampRecourseAction in ipairs(ampRecourseActions) do
			if ampRecourseAction == AmpWizardTransferConstants.RECOURSE_PLUS_SUBSCRIPTION then
				v2 = true
			elseif
				ampRecourseAction == AmpWizardTransferConstants.RECOURSE_ID_VERIFICATION
				or ampRecourseAction == AmpWizardTransferConstants.RECOURSE_AGE_ESTIMATION
			then
				v3 = true
			elseif
				ampRecourseAction == AmpWizardTransferConstants.RECOURSE_PARENT_LINK
				or ampRecourseAction == AmpWizardTransferConstants.RECOURSE_PARENT_CONSENT
			then
				v4 = true
			end
		end
	end

	local v5 = {
		direction = direction,
		ampRecourseActions = ampRecourseActions,
		ampFeatureCheck = ampFeatureCheck
	}

	if v2 and direction then
		return React.createElement(SubscriptionUpsellContainer, {
			direction = v5.direction,
			ampRecourseActions = v5.ampRecourseActions,
			ampFeatureCheck = v5.ampFeatureCheck
		})
	end

	if v3 and direction then
		return React.createElement(TransferFAEBlockSheet, {
			direction = v5.direction,
			ampRecourseActions = v5.ampRecourseActions,
			ampFeatureCheck = v5.ampFeatureCheck
		})
	end

	if v4 and direction then
		return React.createElement(VPCBlockContainer, {
			direction = v5.direction,
			ampRecourseActions = v5.ampRecourseActions,
			ampFeatureCheck = v5.ampFeatureCheck
		})
	end

	return React.createElement(React.Fragment)
end

return TransferBlockSheet
