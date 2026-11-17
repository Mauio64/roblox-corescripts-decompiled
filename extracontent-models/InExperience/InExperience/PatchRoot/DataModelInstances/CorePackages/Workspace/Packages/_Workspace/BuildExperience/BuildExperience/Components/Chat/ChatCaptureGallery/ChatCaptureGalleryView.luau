local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local ChatCaptureEmptyState = require(script.Parent.ChatCaptureEmptyState)
local ChatCaptureGrid = require(script.Parent.ChatCaptureGrid)
require(script.Parent.ChatCaptureToolbarIllustration)

local FFlagBuildExperienceChatCaptureGalleryEmptyEducationEnabled = require(BuildExperience.Flags.FFlagBuildExperienceChatCaptureGalleryEmptyEducationEnabled)

local Button = Foundation.Button
local Sheet = Foundation.Sheet
local Text = Foundation.Text

local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize

local function ChatCaptureGalleryView(props)
	local education

	if
		FFlagBuildExperienceChatCaptureGalleryEmptyEducationEnabled
		and props.education ~= nil
		and props.education.isShown
	then
		education = props.education
	end

	local createElement = React.createElement
	local root = Sheet.Root
	local v = {
		defaultSnapPointIndex = education == nil and 1 or 2,
		isOpen = props.isOpen,
		onClose = props.onClose,
		snapPoints = { 0.5, 1 },
		testId = "ChatCaptureGalleryView"
	}

	local children = {
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
				Visible = education == nil,
				tag = "auto-xy text-caption-small content-muted"
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = Sheet.Content
	local emptyState

	if education ~= nil then
		emptyState = React.createElement(ChatCaptureEmptyState, {
			descriptionText = education.descriptionText,
			emptyText = props.emptyText,
			howToSteps = education.howToSteps,
			toolbarLayout = education.toolbarLayout
		})
	end

	local grid

	if education == nil then
		grid = React.createElement(ChatCaptureGrid, {
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
	end

	children.Content = createElement2(content, nil, { EmptyState = emptyState, Grid = grid })

	local createElement3 = React.createElement
	local actions = Sheet.Actions
	local createElement4 = React.createElement
	local v2 = {
		fillBehavior = FillBehavior.Fill,
		onActivated = props.onConfirm,
		size = InputSize.Medium,
		text = 0,
		variant = 0,
		testId = "ChatCaptureGalleryView.Confirm"
	}
	local text

	if education == nil then
		text = props.addText
	else
		text = education.dismissText
	end

	v2.text = text
	v2.variant = ButtonVariant.Emphasis
	children.Actions = createElement3(actions, nil, { Confirm = createElement4(Button, v2) })
	return createElement(root, v, children)
end

return ChatCaptureGalleryView
