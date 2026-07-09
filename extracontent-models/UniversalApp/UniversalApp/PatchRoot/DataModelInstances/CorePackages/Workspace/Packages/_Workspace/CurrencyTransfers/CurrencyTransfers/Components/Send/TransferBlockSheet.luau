local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local React = require(CurrencyTransfersParent.React)
local TransferFAEBlockSheet = require(CurrencyTransfers.Components.Generic.TransferFAEBlockSheet)
local SubscriptionUpsellContainer = require(CurrencyTransfers.Components.Generic.SubscriptionUpsellContainer)
local VPCBlockContainer = require(CurrencyTransfers.Components.Generic.VPCBlockContainer)
local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)

require(CurrencyTransfers.Enums.TransferDirection)

local AmpWizardTransferConstants = require(CurrencyTransfers.Constants.AmpWizardTransferConstants)

local function TransferBlockSheet(_: {[any]: any}) -- line: 23
	-- upvalues: useTransferStore (copy), AmpWizardTransferConstants (copy), React (copy), SubscriptionUpsellContainer (copy), TransferFAEBlockSheet (copy), VPCBlockContainer (copy)
	local v11 = useTransferStore()
	local v12 = v11.getDirection(false)
	local v13 = v11.getAmpRecourseActions(false)
	local v14 = v11.getAmpFeatureCheck(false)
	local v15 = false
	local v16 = false
	local v17 = false

	if v13 then
		for _, v in ipairs(v13) do
			if v == AmpWizardTransferConstants.RECOURSE_PLUS_SUBSCRIPTION then
				v15 = true
			elseif v == AmpWizardTransferConstants.RECOURSE_ID_VERIFICATION or v == AmpWizardTransferConstants.RECOURSE_AGE_ESTIMATION then
				v16 = true
			elseif v == AmpWizardTransferConstants.RECOURSE_PARENT_LINK or v == AmpWizardTransferConstants.RECOURSE_PARENT_CONSENT then
				v17 = true
			end
		end
	end

	local t2 = {
		direction = v12,
		ampRecourseActions = v13,
		ampFeatureCheck = v14
	}

	if v15 and v12 then
		return React.createElement(SubscriptionUpsellContainer, {
			direction = t2.direction,
			ampRecourseActions = t2.ampRecourseActions,
			ampFeatureCheck = t2.ampFeatureCheck
		})
	end

	if v16 and v12 then
		return React.createElement(TransferFAEBlockSheet, {
			direction = t2.direction,
			ampRecourseActions = t2.ampRecourseActions,
			ampFeatureCheck = t2.ampFeatureCheck
		})
	end

	if v17 and v12 then
		return React.createElement(VPCBlockContainer, {
			direction = t2.direction,
			ampRecourseActions = t2.ampRecourseActions,
			ampFeatureCheck = t2.ampFeatureCheck
		})
	end

	return React.createElement(React.Fragment)
end

return TransferBlockSheet
