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
local handleTransferComplete = require(CurrencyTransfers.Actions.Send.handleTransferComplete)
local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)
local formatNumber = require(CurrencyTransfers.Utils.formatNumber)

local function TransferRobuxSuccessToast(_: {[any]: any}) -- line: 31
	-- upvalues: useLocalization (copy), TransferLocalizationKeys (copy), useTransferStore (copy), SignalsReact (copy), formatNumber (copy), LocalizationService (copy), React (copy), transferLocaleFormat (copy), handleTransferComplete (copy), Snackbar (copy), Enums (copy)
	local v17 = useLocalization(TransferLocalizationKeys.Presets.TransferRobuxSuccessToast)
	local v18 = useTransferStore()
	local v19 = SignalsReact.useSignalState(v18.getSelectedAmount)
	local v20 = not v19 and "0" or formatNumber(LocalizationService.RobloxLocaleId, v19)
	local v21 = React.useMemo(function() -- line: 40
		-- upvalues: transferLocaleFormat (copy), v17 (copy), v20 (copy)
		return transferLocaleFormat.substituteAmount(v17.SuccessNotification, (tostring(v20)))
	end, {
		v20,
		v17.SuccessNotification
	})
	local v22 = React.useRef(nil)

	React.useEffect(function() -- line: 46
		-- upvalues: v22 (copy), handleTransferComplete (copy), v18 (copy)
		if v22.current then
			task.cancel(v22.current)
		end

		v22.current = task.delay(5, function() -- line: 53
			-- upvalues: handleTransferComplete (copy), v18 (copy)
			handleTransferComplete(v18)
		end)

		return function() -- line: 59
			-- upvalues: v22 (copy)
			if v22.current then
				task.cancel(v22.current)
				v22.current = nil
			end
		end
	end, {})

	return React.createElement(Snackbar, {
		ZIndex = 100,
		title = v21,
		icon = {
			name = Enums.IconName.CircleCheck,
			variant = Enums.IconVariant.Filled
		},
		Position = UDim2.new(0.5, 0, 0, 50),
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		onClose = function() -- line: 81
			-- upvalues: handleTransferComplete (copy), v18 (copy)
			handleTransferComplete(v18)
		end
	})
end

return TransferRobuxSuccessToast
