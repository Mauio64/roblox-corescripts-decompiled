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

local handleReceiveComplete = require(CurrencyTransfers.Actions.Receive.handleReceiveComplete)

local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)

local formatNumber = require(CurrencyTransfers.Utils.formatNumber)

local function ReceiveRobuxSuccessToast(_)
	local v = useLocalization(TransferLocalizationKeys.Presets.ReceiveRobuxSuccessToast)

	local v2 = useTransferStore()
	local v3 = SignalsReact.useSignalState(v2.getRobuxTransfer)
	local v4 = SignalsReact.useSignalState(v2.getIsAlreadyAccepted)

	local v5 = not v3 and 0 or v3.receivingAmount or v3.transferAmount
	local v6 = formatNumber(LocalizationService.RobloxLocaleId, v5)
	local title = React.useMemo(function()
		if v4 then
			return v.AlreadyAcceptedNotification
		end

		return transferLocaleFormat.substituteAmount(v.SuccessNotification, (tostring(v6)))
	end, { v4, v6, v.SuccessNotification, v.AlreadyAcceptedNotification })

	local ref = React.useRef(nil)
	React.useEffect(function()
		if ref.current then
			task.cancel(ref.current)
		end

		ref.current = task.delay(5, function()
			handleReceiveComplete(v2)
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
		icon = not v4 and { name = Enums.IconName.CircleCheck, variant = Enums.IconVariant.Filled } or nil,
		Position = UDim2.new(0.5, 0, 0, 50),
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 100,
		onClose = function()
			handleReceiveComplete(v2)
		end
	})
end

return ReceiveRobuxSuccessToast
