local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local TransferLocalizationKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Localization/TransferLocalizationKeys")
local transferLocaleFormat = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Localization/transferLocaleFormat")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SignalsReact")
local LocalizationService = game:GetService("LocalizationService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Foundation")
local snackbar = Foundation.Snackbar
local enums = Foundation.Enums

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Localization").Hooks.useLocalization

local handleTransferComplete = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Send/handleTransferComplete")

local useTransferStore = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useTransferStore")

local formatNumber = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/formatNumber")

local function TransferRobuxSuccessToast(p2)
	local v5 = useLocalization(TransferLocalizationKeys.Presets.TransferRobuxSuccessToast)

	local v6 = useTransferStore()
	local v7 = SignalsReact.useSignalState(v6.getSelectedAmount)

	local v8 = not v7 and "0" or formatNumber(LocalizationService.RobloxLocaleId, v7)

	local v9 = React.useMemo(function()
		return transferLocaleFormat.substituteAmount(v5.SuccessNotification, (tostring(v8)))
	end, { v8, v5.SuccessNotification })

	local ref = React.useRef(nil)
	React.useEffect(function()
		if ref.current then
			task.cancel(ref.current)
		end

		ref.current = task.delay(5, function()
			handleTransferComplete(v6)
		end)

		return function()
			if ref.current then
				task.cancel(ref.current)
				ref.current = nil
			end
		end
	end, {})

	return React.createElement(snackbar, {
		title = v9,
		icon = { name = enums.IconName.CircleCheck, variant = enums.IconVariant.Filled },
		Position = UDim2.new(0.5, 0, 0, 50),
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 100,
		onClose = function()
			handleTransferComplete(v6)
		end
	})
end

return TransferRobuxSuccessToast
