local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/MomentsCommon")

local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local view = Foundation.View

local FFlagBuildExperienceLocalizeCaptureShowMore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceLocalizeCaptureShowMore")
local MediaPreview = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MediaSelectionPage/MediaPreview")
local CaptureGridItem = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MediaSelectionPage/CaptureGridItem")
local useCaptureSelectionViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MediaSelectionPage/useCaptureSelectionViewModel")

local scrollingGridView = MomentsCommon.ScrollingGridView

local function renderEmptyState()
	return React.createElement(view, {
		tag = "align-x-center align-y-center size-full"
	})
end

local function CaptureSelectionView(props)
	local v5 = React.useCallback(function(p2, p3)
		return React.createElement(CaptureGridItem, {
			capture = p2,
			isSelected = props.selectedCapture == p2,
			onActivated = props.onCaptureSelected
		})
	end, { props.selectedCapture, props.onCaptureSelected })

	return React.createElement(view, { tag = "col gap-medium size-full padding-large" }, {
		Preview = React.createElement(
			view,
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
		CaptureGrid = React.createElement(view, {
			LayoutOrder = 2,
			tag = "fill size-full"
		}, {
			Grid = React.createElement(scrollingGridView, {
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
				renderItem = v5,
				shouldShowShowMoreButton = not props.isFinished,
				showMoreButtonText = not FFlagBuildExperienceLocalizeCaptureShowMore and "Show More" or props.showMoreText
			})
		}),
		ConfirmButton = React.createElement(view, {
			LayoutOrder = 3,
			tag = "size-full-0 auto-y"
		}, {
			Button = React.createElement(button, {
				fillBehavior = Foundation.Enums.FillBehavior.Fill,
				isDisabled = props.selectedCapture == nil,
				onActivated = props.onConfirm,
				size = inputSize.Medium,
				text = "Continue",
				variant = buttonVariant.Emphasis
			})
		})
	})
end

local function CaptureSelectionContainer(p2)
	local v5 = useCaptureSelectionViewModel({
		captureSource = p2.captureSource,
		onCaptureConfirmed = p2.onCaptureConfirmed
	})

	return React.createElement(CaptureSelectionView, v5)
end

return CaptureSelectionContainer
