local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local React = require(CurrencyTransfersParent.React)
local TransferLocalizationKeys = require(CurrencyTransfers.Localization.TransferLocalizationKeys)
local transferLocaleFormat = require(CurrencyTransfers.Localization.transferLocaleFormat)
local SignalsReact = require(CurrencyTransfersParent.SignalsReact)
local LocalizationService = game:GetService("LocalizationService")
local Foundation = require(CurrencyTransfersParent.Foundation)
local Snackbar = Foundation.Snackbar
local Enums = Foundation.Enums
local useLocalization = require(CurrencyTransfersParent.Localization).Hooks.useLocalization
local handleReceiveComplete = require(CurrencyTransfers.Actions.Receive.handleReceiveComplete)
local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)
local formatNumber = require(CurrencyTransfers.Utils.formatNumber)

local function ReceiveRobuxSuccessToast(_: {[any]: any}) -- line: 34
	-- upvalues: useLocalization (copy), TransferLocalizationKeys (copy), useTransferStore (copy), SignalsReact (copy), formatNumber (copy), LocalizationService (copy), React (copy), transferLocaleFormat (copy), handleReceiveComplete (copy), Snackbar (copy), Enums (copy)
	local v17 = useLocalization(TransferLocalizationKeys.Presets.ReceiveRobuxSuccessToast)
	local v18 = useTransferStore()
	local v19 = SignalsReact.useSignalState(v18.getRobuxTransfer)
	local v20 = SignalsReact.useSignalState(v18.getIsAlreadyAccepted)
	local v21 = not v19 and 0 or (v19.receivingAmount or v19.transferAmount)
	local v22 = formatNumber(LocalizationService.RobloxLocaleId, v21)
	local v23 = React.useMemo(function() -- line: 44
		-- upvalues: v20 (copy), v17 (copy), transferLocaleFormat (copy), v22 (copy)
		if v20 then
			return v17.AlreadyAcceptedNotification
		end

		return transferLocaleFormat.substituteAmount(v17.SuccessNotification, (tostring(v22)))
	end, {
		v20,
		v22,
		v17.SuccessNotification,
		v17.AlreadyAcceptedNotification
	})
	local v24 = React.useRef(nil)

	React.useEffect(function() -- line: 55
		-- upvalues: v24 (copy), handleReceiveComplete (copy), v18 (copy)
		if v24.current then
			task.cancel(v24.current)
		end

		v24.current = task.delay(5, function() -- line: 62
			-- upvalues: handleReceiveComplete (copy), v18 (copy)
			handleReceiveComplete(v18)
		end)

		return function() -- line: 68
			-- upvalues: v24 (copy)
			if v24.current then
				task.cancel(v24.current)
				v24.current = nil
			end
		end
	end, {})

	return React.createElement(Snackbar, {
		ZIndex = 100,
		title = v23,
		icon = if v20 then nil else {
			name = Enums.IconName.CircleCheck,
			variant = Enums.IconVariant.Filled
		},
		Position = UDim2.new(0.5, 0, 0, 50),
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		onClose = function() -- line: 89
			-- upvalues: handleReceiveComplete (copy), v18 (copy)
			handleReceiveComplete(v18)
		end
	})
end

return ReceiveRobuxSuccessToast
