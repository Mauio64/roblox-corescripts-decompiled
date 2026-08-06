local Parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local MomentsCommon = require(Parent.MomentsCommon)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local View = Foundation.View
local MediaPreview = require(script.Parent.MediaPreview)
local CaptureGridItem = require(script.Parent.CaptureGridItem)
local useCaptureSelectionViewModel = require(script.Parent.useCaptureSelectionViewModel)
local ScrollingGridView = MomentsCommon.ScrollingGridView

local function renderEmptyState() -- line: 26
	-- upvalues: React (copy), View (copy)
	return React.createElement(View, {
		tag = "align-x-center align-y-center size-full"
	})
end
local function CaptureSelectionView(p1) -- line: 37
	-- upvalues: React (copy), CaptureGridItem (copy), View (copy), MediaPreview (copy), ScrollingGridView (copy), renderEmptyState (copy), Button (copy), Foundation (copy), InputSize (copy), ButtonVariant (copy)
	local v17 = React.useCallback(function(p2, _: number) -- line: 38
		-- upvalues: React (copy), CaptureGridItem (copy), p1 (copy)
		return React.createElement(CaptureGridItem, {
			capture = p2,
			isSelected = p2 == p1.selectedCapture,
			onActivated = p1.onCaptureSelected
		})
	end, {
		p1.selectedCapture,
		p1.onCaptureSelected
	})

	return React.createElement(View, {
		tag = "col gap-medium size-full padding-large"
	}, {
		Preview = React.createElement(View, {
			LayoutOrder = 1,
			tag = "align-x-center align-y-center size-full-0 padding-x-xlarge",
			Size = UDim2.new(1, 0, 0.4, 0)
		}, {
			PreviewContent = React.createElement(MediaPreview, {
				mediaType = "image",
				isIcon = false,
				imageContent = p1.previewContent
			})
		}),
		CaptureGrid = React.createElement(View, {
			LayoutOrder = 2,
			tag = "fill size-full"
		}, {
			Grid = React.createElement(ScrollingGridView, {
				aspectRatio = 1,
				layoutOrder = 1,
				showMoreButtonText = "Show More",
				itemConfig = {
					padding = 2,
					maxItemsPerRow = 4,
					minItemsPerPage = 8,
					minItemWidth = 80
				},
				items = p1.captures,
				onShowMoreCallback = p1.onShowMore,
				renderEmptyState = renderEmptyState,
				renderItem = v17,
				shouldShowShowMoreButton = not p1.isFinished
			})
		}),
		ConfirmButton = React.createElement(View, {
			LayoutOrder = 3,
			tag = "size-full-0 auto-y"
		}, {
			Button = React.createElement(Button, {
				text = "Continue",
				fillBehavior = Foundation.Enums.FillBehavior.Fill,
				isDisabled = p1.selectedCapture == nil,
				onActivated = p1.onConfirm,
				size = InputSize.Medium,
				variant = ButtonVariant.Emphasis
			})
		})
	})
end
local function CaptureSelectionContainer(t1: {[any]: any}) -- line: 99
	-- upvalues: useCaptureSelectionViewModel (copy), React (copy), CaptureSelectionView (copy)
	local v19 = useCaptureSelectionViewModel({
		captureSource = t1.captureSource,
		onCaptureConfirmed = t1.onCaptureConfirmed
	})

	return React.createElement(CaptureSelectionView, v19)
end

return CaptureSelectionContainer
