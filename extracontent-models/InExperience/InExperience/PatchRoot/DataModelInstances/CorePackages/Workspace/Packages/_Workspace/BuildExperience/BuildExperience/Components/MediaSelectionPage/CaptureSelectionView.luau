local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)

local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local View = Foundation.View

local MediaPreview = require(script.Parent.MediaPreview)
local CaptureGridItem = require(script.Parent.CaptureGridItem)
local useCaptureSelectionViewModel = require(script.Parent.useCaptureSelectionViewModel)

local ScrollingGridView = MomentsCommon.ScrollingGridView

local function renderEmptyState()
	return React.createElement(View, { tag = "align-x-center align-y-center size-full" })
end

local function CaptureSelectionView(props)
	local renderItem = React.useCallback(function(capture, _: number)
		return React.createElement(CaptureGridItem, {
			capture = capture,
			isSelected = props.selectedCapture == capture,
			onActivated = props.onCaptureSelected
		})
	end, { props.selectedCapture, props.onCaptureSelected })

	return React.createElement(View, { tag = "col gap-medium size-full padding-large" }, {
		Preview = React.createElement(
			View,
			{
				LayoutOrder = 1,
				tag = "align-x-center align-y-center size-full-0 padding-x-xlarge",
				Size = UDim2.new(1, 0, 0.4, 0)
			},
			{
				PreviewContent = React.createElement(MediaPreview, {
					mediaType = "image",
					imageContent = props.previewContent,
					isIcon = false
				})
			}
		),
		CaptureGrid = React.createElement(View, { LayoutOrder = 2, tag = "fill size-full" }, {
			Grid = React.createElement(ScrollingGridView, {
				aspectRatio = 1,
				itemConfig = {
					padding = 2,
					maxItemsPerRow = 4,
					minItemsPerPage = 8,
					minItemWidth = 80
				},
				items = props.captures,
				layoutOrder = 1,
				onShowMoreCallback = props.onShowMore,
				renderEmptyState = renderEmptyState,
				renderItem = renderItem,
				shouldShowShowMoreButton = not props.isFinished,
				showMoreButtonText = "Show More"
			})
		}),
		ConfirmButton = React.createElement(View, { LayoutOrder = 3, tag = "size-full-0 auto-y" }, {
			Button = React.createElement(Button, {
				fillBehavior = Foundation.Enums.FillBehavior.Fill,
				isDisabled = props.selectedCapture == nil,
				onActivated = props.onConfirm,
				size = InputSize.Medium,
				text = "Continue",
				variant = ButtonVariant.Emphasis
			})
		})
	})
end

local function CaptureSelectionContainer(p)
	local v = useCaptureSelectionViewModel({
		captureSource = p.captureSource,
		onCaptureConfirmed = p.onCaptureConfirmed
	})

	return React.createElement(CaptureSelectionView, v)
end

return CaptureSelectionContainer
