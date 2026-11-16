local LocalizationService = game:GetService("LocalizationService")

local module = require("@luauforge/bundled/hwN")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/React")

require("@luauforge/bundled/hwK")
require("@luauforge/bundled/hwO")
local module3 = require("@luauforge/bundled/hwS")

local useLocalization = module.Hooks.useLocalization
local numberLocalization = module.NumberLocalization

local function usePendingTransfersSheetViewModel(p2)
	local onClosed = p2.onClosed
	local pendingTransfers = p2.pendingTransfers

	local state, setState = React.useState(true)
	local ref = React.useRef(nil)

	local v5 = useLocalization({ title = "Feature.BuyRobux.Heading.PendingTransfers" })

	local v6 = React.useMemo(function()
		local robloxLocaleId = LocalizationService.RobloxLocaleId
		local result = {}

		for k, transfer in pendingTransfers.transfers do
			table.insert(result, {
				transferRequestId = transfer.transferRequestId,
				senderUserId = transfer.senderUserId,
				senderDisplayName = transfer.senderDisplayName,
				dateText = DateTime.fromUnixTimestampMillis(transfer.createdTimestampMs):FormatLocalTime(
					"ll",
					robloxLocaleId
				),
				amountText = numberLocalization.localize(transfer.robuxAmount, robloxLocaleId)
			})
		end

		return result
	end, { pendingTransfers })

	local v7 = React.useCallback(function()
		setState(false)
	end, {})

	local v8 = React.useCallback(function(current)
		ref.current = current
		setState(false)
	end, {})

	return {
		isOpen = state,
		onSheetClosed = React.useCallback(function()
			onClosed(ref.current)
		end, { onClosed }),
		focusRef = module3(v7),
		title = v5.title,
		rows = v6,
		acceptText = pendingTransfers.acceptText,
		onAccept = v8
	}
end

return usePendingTransfersSheetViewModel
