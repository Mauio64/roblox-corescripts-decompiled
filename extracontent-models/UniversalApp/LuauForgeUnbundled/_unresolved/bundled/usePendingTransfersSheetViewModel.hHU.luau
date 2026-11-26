local LocalizationService = game:GetService("LocalizationService")

local module = require("@luauforge/bundled/hHV")
local module2 = require("@luauforge/bundled/hHu")

require("@luauforge/bundled/hHS")
require("@luauforge/bundled/hHW")
local module3 = require("@luauforge/bundled/hIa")

local useLocalization = module.Hooks.useLocalization
local numberLocalization = module.NumberLocalization

local function usePendingTransfersSheetViewModel(p2)
	local onClosed = p2.onClosed
	local pendingTransfers = p2.pendingTransfers

	local state, setState = module2.useState(true)
	local ref = module2.useRef(nil)

	local v5 = useLocalization({ title = "Feature.BuyRobux.Heading.PendingTransfers" })

	local v6 = module2.useMemo(function()
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

	local v7 = module2.useCallback(function()
		setState(false)
	end, {})

	local v8 = module2.useCallback(function(current)
		ref.current = current
		setState(false)
	end, {})

	return {
		isOpen = state,
		onSheetClosed = module2.useCallback(function()
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
