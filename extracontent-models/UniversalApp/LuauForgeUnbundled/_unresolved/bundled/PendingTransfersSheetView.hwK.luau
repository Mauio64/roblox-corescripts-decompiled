local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/React")

local module3 = require("@luauforge/bundled/hwL")

local sheet = Foundation.Sheet
local text = Foundation.Text
local view = Foundation.View
local dialogSize = Foundation.Enums.DialogSize

local function PendingTransfersSheetView(props)
	local children = {}

	for k, row in props.rows do
		children[`Transfer_{row.transferRequestId}`] = React.createElement(module3, {
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

	return React.createElement(sheet.Root, {
		isOpen = props.isOpen,
		preferCenterSheet = true,
		size = dialogSize.Medium,
		onClose = props.onSheetClosed,
		ref = props.focusRef,
		testId = "pending-transfers-sheet"
	}, {
		Header = React.createElement(sheet.Header, {}, {
			Title = React.createElement(text, {
				Text = props.title,
				tag = "size-full-0 auto-y text-heading-small text-align-x-left content-default",
				testId = "pending-transfers-sheet-title"
			})
		}),
		Content = React.createElement(sheet.Content, {}, {
			Rows = React.createElement(
				view,
				{ tag = "col gap-medium size-full-0 auto-y padding-bottom-xlarge" },
				children
			)
		})
	})
end

return PendingTransfersSheetView
