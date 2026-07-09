local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local React = require(CurrencyTransfersParent.React)
local TransferFAEBlockSheet = require(CurrencyTransfers.Components.Generic.TransferFAEBlockSheet)
local VPCBlockContainer = require(CurrencyTransfers.Components.Generic.VPCBlockContainer)
local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)

require(CurrencyTransfers.Enums.TransferDirection)

local AmpWizardTransferConstants = require(CurrencyTransfers.Constants.AmpWizardTransferConstants)

local function ReceiveBlockSheet(_: {[any]: any}) -- line: 22
	-- upvalues: useTransferStore (copy), AmpWizardTransferConstants (copy), React (copy), TransferFAEBlockSheet (copy), VPCBlockContainer (copy)
	local v10 = useTransferStore()
	local v11 = v10.getDirection(false)
	local v12 = v10.getAmpRecourseActions(false)
	local v13 = v10.getAmpFeatureCheck(false)
	local v14 = false
	local v15 = false

	if v12 then
		for _, v in ipairs(v12) do
			if v == AmpWizardTransferConstants.RECOURSE_ID_VERIFICATION or v == AmpWizardTransferConstants.RECOURSE_AGE_ESTIMATION then
				v14 = true
			elseif v == AmpWizardTransferConstants.RECOURSE_PARENT_LINK or v == AmpWizardTransferConstants.RECOURSE_PARENT_CONSENT then
				v15 = true
			end
		end
	end

	if v14 and v11 then
		return React.createElement(TransferFAEBlockSheet, {
			direction = v11,
			ampRecourseActions = v12,
			ampFeatureCheck = v13
		})
	end

	if v15 and v11 then
		return React.createElement(VPCBlockContainer, {
			direction = v11,
			ampRecourseActions = v12,
			ampFeatureCheck = v13
		})
	end

	return React.createElement(React.Fragment)
end

return ReceiveBlockSheet
