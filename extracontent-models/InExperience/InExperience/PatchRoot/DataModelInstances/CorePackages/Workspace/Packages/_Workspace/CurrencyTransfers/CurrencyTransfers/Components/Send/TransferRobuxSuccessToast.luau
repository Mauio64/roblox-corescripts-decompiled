local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local React = require(parent.React)
local TransferLocalizationKeys = require(CurrencyTransfers.Localization.TransferLocalizationKeys)
local transferLocaleFormat = require(CurrencyTransfers.Localization.transferLocaleFormat)
local SignalsReact = require(parent.SignalsReact)
local LocalizationService = game:GetService("LocalizationService")

local Foundation = require(parent.Foundation)
local Snackbar = Foundation.Snackbar
local Enums = Foundation.Enums

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local handleTransferComplete = require(CurrencyTransfers.Actions.Send.handleTransferComplete)

local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)

local formatNumber = require(CurrencyTransfers.Utils.formatNumber)

local function TransferRobuxSuccessToast(_)
	local v = useLocalization(TransferLocalizationKeys.Presets.TransferRobuxSuccessToast)

	local v2 = useTransferStore()
	local v3 = SignalsReact.useSignalState(v2.getSelectedAmount)

	local v4 = not v3 and "0" or formatNumber(LocalizationService.RobloxLocaleId, v3)

	local title = React.useMemo(function()
		return transferLocaleFormat.substituteAmount(v.SuccessNotification, (tostring(v4)))
	end, { v4, v.SuccessNotification })

	local ref = React.useRef(nil)
	React.useEffect(function()
		if ref.current then
			task.cancel(ref.current)
		end

		ref.current = task.delay(5, function()
			handleTransferComplete(v2)
		end)

		return function()
			if ref.current then
				task.cancel(ref.current)
				ref.current = nil
			end
		end
	end, {})

	return React.createElement(Snackbar, {
		title = title,
		icon = { name = Enums.IconName.CircleCheck, variant = Enums.IconVariant.Filled },
		Position = UDim2.new(0.5, 0, 0, 50),
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 100,
		onClose = function()
			handleTransferComplete(v2)
		end
	})
end

return TransferRobuxSuccessToast
