local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")

local ChatCaptureEmptyState = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCaptureGallery/ChatCaptureEmptyState")
local ChatCaptureGrid = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCaptureGallery/ChatCaptureGrid")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCaptureGallery/ChatCaptureToolbarIllustration")

local FFlagBuildExperienceChatCaptureGalleryEmptyEducationEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatCaptureGalleryEmptyEducationEnabled")

local button = Foundation.Button
local sheet = Foundation.Sheet
local text = Foundation.Text

local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize

local function ChatCaptureGalleryView(props)
	local education

	if FFlagBuildExperienceChatCaptureGalleryEmptyEducationEnabled and props.education ~= nil and props.education.isShown then
		education = props.education
	end

	local createElement = React.createElement
	local root = sheet.Root
	local v5 = {
		defaultSnapPointIndex = education == nil and 1 or 2,
		isOpen = props.isOpen,
		onClose = props.onClose,
		snapPoints = { 0.5, 1 },
		testId = "ChatCaptureGalleryView"
	}

	local children = {
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
				Visible = education == nil,
				tag = "auto-xy text-caption-small content-muted"
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = sheet.Content

	local v8 = if education ~= nil then React.createElement(ChatCaptureEmptyState, {
		descriptionText = education.descriptionText,
		emptyText = props.emptyText,
		howToSteps = education.howToSteps,
		toolbarLayout = education.toolbarLayout
	}) else nil

	local v9 = if education == nil then React.createElement(ChatCaptureGrid, {
		captures = props.captures,
		isFinished = props.isFinished,
		isLoading = props.isLoading,
		isSelected = props.isSelected,
		emptyText = props.emptyText,
		onCaptureToggled = props.onCaptureToggled,
		onShowMore = props.onShowMore,
		shouldProgressivelyLoad = props.shouldProgressivelyLoad,
		showMoreText = props.showMoreText
	}) else nil
	children.Content = createElement2(content, nil, { EmptyState = v8, Grid = v9 })

	local createElement3 = React.createElement
	local actions = sheet.Actions
	local createElement4 = React.createElement
	local v13 = {
		fillBehavior = fillBehavior.Fill,
		onActivated = props.onConfirm,
		size = inputSize.Medium,
		text = 0,
		variant = 0,
		testId = "ChatCaptureGalleryView.Confirm"
	}
	local v14 = if education == nil then props.addText else education.dismissText
	v13.text = v14
	v13.variant = buttonVariant.Emphasis
	children.Actions = createElement3(actions, nil, {
		Confirm = createElement4(button, v13)
	})
	return createElement(root, v5, children)
end

return ChatCaptureGalleryView
