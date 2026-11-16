local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")

local ChatCaptureGrid = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCaptureGallery/ChatCaptureGrid")

local button = Foundation.Button
local sheet = Foundation.Sheet
local text = Foundation.Text

local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize

local function ChatCaptureGalleryView(props)
	return React.createElement(sheet.Root, {
		defaultSnapPointIndex = 1,
		isOpen = props.isOpen,
		onClose = props.onClose,
		snapPoints = { 0.5, 1 },
		testId = "ChatCaptureGalleryView"
	}, {
		Header = React.createElement(sheet.Header, { hasCloseAffordance = true }, {
			Title = React.createElement(text, {
				LayoutOrder = 1,
				Text = props.titleText,
				TextXAlignment = Enum.TextXAlignment.Left,
				tag = "fill auto-y padding-y-small text-heading-small text-align-x-left content-emphasis"
			}),
			SelectionCount = React.createElement(text, {
				LayoutOrder = 2,
				Text = props.selectionCountText,
				tag = "auto-xy text-caption-small content-muted"
			})
		}),
		Content = React.createElement(sheet.Content, nil, {
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
		Actions = React.createElement(sheet.Actions, nil, {
			Confirm = React.createElement(button, {
				fillBehavior = fillBehavior.Fill,
				onActivated = props.onConfirm,
				size = inputSize.Medium,
				text = props.addText,
				variant = buttonVariant.Emphasis,
				testId = "ChatCaptureGalleryView.Confirm"
			})
		})
	})
end

return ChatCaptureGalleryView
