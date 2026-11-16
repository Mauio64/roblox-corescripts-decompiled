local parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local ChatCaptureGrid = require(script.Parent.ChatCaptureGrid)

local Button = Foundation.Button
local Sheet = Foundation.Sheet
local Text = Foundation.Text

local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize

local function ChatCaptureGalleryView(props)
	return React.createElement(Sheet.Root, {
		defaultSnapPointIndex = 1,
		isOpen = props.isOpen,
		onClose = props.onClose,
		snapPoints = { 0.5, 1 },
		testId = "ChatCaptureGalleryView"
	}, {
		Header = React.createElement(Sheet.Header, { hasCloseAffordance = true }, {
			Title = React.createElement(Text, {
				LayoutOrder = 1,
				Text = props.titleText,
				TextXAlignment = Enum.TextXAlignment.Left,
				tag = "fill auto-y padding-y-small text-heading-small text-align-x-left content-emphasis"
			}),
			SelectionCount = React.createElement(Text, {
				LayoutOrder = 2,
				Text = props.selectionCountText,
				tag = "auto-xy text-caption-small content-muted"
			})
		}),
		Content = React.createElement(Sheet.Content, nil, {
			Grid = React.createElement(ChatCaptureGrid, {
				captures = props.captures,
				isFinished = props.isFinished,
				isLoading = props.isLoading,
				isSelected = props.isSelected,
				emptyText = props.emptyText,
				onCaptureToggled = props.onCaptureToggled,
				onShowMore = props.onShowMore,
				shouldProgressivelyLoad = props.shouldProgressivelyLoad,
				showMoreText = props.showMoreText
			})
		}),
		Actions = React.createElement(Sheet.Actions, nil, {
			Confirm = React.createElement(Button, {
				fillBehavior = FillBehavior.Fill,
				onActivated = props.onConfirm,
				size = InputSize.Medium,
				text = props.addText,
				variant = ButtonVariant.Emphasis,
				testId = "ChatCaptureGalleryView.Confirm"
			})
		})
	})
end

return ChatCaptureGalleryView
