local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local TransferLocalizationKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Localization/TransferLocalizationKeys")
local transferLocaleFormat = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Localization/transferLocaleFormat")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SignalsReact")
local LocalizationService = game:GetService("LocalizationService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Foundation")
local snackbar = Foundation.Snackbar
local enums = Foundation.Enums

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Localization").Hooks.useLocalization

local handleReceiveComplete = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Receive/handleReceiveComplete")

local useTransferStore = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useTransferStore")

local formatNumber = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/formatNumber")

local function ReceiveRobuxSuccessToast(p2)
	local v5 = useLocalization(TransferLocalizationKeys.Presets.ReceiveRobuxSuccessToast)

	local v6 = useTransferStore()
	local v7 = SignalsReact.useSignalState(v6.getRobuxTransfer)
	local v8 = SignalsReact.useSignalState(v6.getIsAlreadyAccepted)

	local v9 = not v7 and 0 or v7.receivingAmount or v7.transferAmount
	local v10 = formatNumber(LocalizationService.RobloxLocaleId, v9)
	local v11 = React.useMemo(function()
		if v8 then
			return v5.AlreadyAcceptedNotification
		end

		return transferLocaleFormat.substituteAmount(v5.SuccessNotification, (tostring(v10)))
	end, { v8, v10, v5.SuccessNotification, v5.AlreadyAcceptedNotification })

	local ref = React.useRef(nil)
	React.useEffect(function()
		if ref.current then
			task.cancel(ref.current)
		end

		ref.current = task.delay(5, function()
			handleReceiveComplete(v6)
		end)

		return function()
			if ref.current then
				task.cancel(ref.current)
				ref.current = nil
			end
		end
	end, {})

	return React.createElement(snackbar, {
		title = v11,
		icon = not v8 and {
			name = enums.IconName.CircleCheck,
			variant = enums.IconVariant.Filled
		} or nil,
		Position = UDim2.new(0.5, 0, 0, 50),
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 100,
		onClose = function()
			handleReceiveComplete(v6)
		end
	})
end

return ReceiveRobuxSuccessToast
