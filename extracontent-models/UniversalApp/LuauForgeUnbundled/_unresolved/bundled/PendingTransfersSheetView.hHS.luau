local module = require("@luauforge/bundled/hHr")
local module2 = require("@luauforge/bundled/hHu")

local module3 = require("@luauforge/bundled/hHT")

local sheet = module.Sheet
local text = module.Text
local view = module.View
local dialogSize = module.Enums.DialogSize

local function PendingTransfersSheetView(props)
	local children = {}

	for k, row in props.rows do
		children[`Transfer_{row.transferRequestId}`] = module2.createElement(module3, {
			LayoutOrder = k,
			transferRequestId = row.transferRequestId,
			senderUserId = row.senderUserId,
			senderDisplayName = row.senderDisplayName,
			dateText = row.dateText,
			amountText = row.amountText,
			acceptText = props.acceptText,
			onAccept = props.onAccept
		})
	end

	return module2.createElement(sheet.Root, {
		isOpen = props.isOpen,
		preferCenterSheet = true,
		size = dialogSize.Medium,
		onClose = props.onSheetClosed,
		ref = props.focusRef,
		testId = "pending-transfers-sheet"
	}, {
		Header = module2.createElement(sheet.Header, {}, {
			Title = module2.createElement(text, {
				Text = props.title,
				tag = "size-full-0 auto-y text-heading-small text-align-x-left content-default",
				testId = "pending-transfers-sheet-title"
			})
		}),
		Content = module2.createElement(sheet.Content, {}, {
			Rows = module2.createElement(
				view,
				{ tag = "col gap-medium size-full-0 auto-y padding-bottom-xlarge" },
				children
			)
		})
	})
end

return PendingTransfersSheetView
