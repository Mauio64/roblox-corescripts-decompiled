local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/ReactRoblox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Foundation")

local SplitPaneEducationalTourChrome = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/SplitPaneEducationalTourChrome")
local SplitPaneEducationalTourScrim = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/SplitPaneEducationalTourScrim")
local SplitPaneEducationalTourVideo = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/SplitPaneEducationalTourVideo")
require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/getSplitPaneEducationalTourPresentation")
require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/getSplitPaneEducationalTourTooltipModel")

local buttonVariant = Foundation.Enums.ButtonVariant
local educationalTooltip = Foundation.EducationalTooltip

local function toOverlayLocalRect(p2, p3)
	return Rect.new(p2.Min - p3, p2.Max - p3)
end

local frame = Instance.new("Frame")
frame.BackgroundTransparency = 1

local function SplitPaneEducationalTourView(props)
	local v5 = {}

	if props.tooltipModel ~= nil then
		if props.tooltipModel.isFinal then
			table.insert(v5, {
				text = props.tooltipModel.primaryActionText,
				variant = buttonVariant.Emphasis,
				onActivated = props.onEnd,
				ref = props.setPrimaryActionRef,
				testId = "split-pane-educational-tour--action-finish-tour"
			})
		else
			table.insert(v5, {
				text = props.tooltipModel.primaryActionText,
				variant = buttonVariant.Emphasis,
				onActivated = props.onNext,
				ref = props.setPrimaryActionRef,
				testId = "split-pane-educational-tour--action-next"
			})

			table.insert(v5, {
				text = props.tooltipModel.skipActionText or "",
				variant = buttonVariant.Standard,
				onActivated = props.onEnd,
				testId = "split-pane-educational-tour--action-skip"
			})
		end
	end

	local tooltipModel = props.tooltipModel
	local v6

	if props.presentation.isAnchorReady and tooltipModel ~= nil and props.presentation.anchorRef ~= nil then
		v6 = React.createElement(educationalTooltip, {
			ref = props.setTooltipContentRef,
			isOpen = true,
			anchorRef = props.presentation.anchorRef,
			side = tooltipModel.side,
			align = tooltipModel.align,
			hasArrow = false,
			title = tooltipModel.title,
			text = tooltipModel.text,
			media = React.createElement(SplitPaneEducationalTourVideo, {
				videoAssetId = tooltipModel.videoAssetId,
				mediaWidth = props.mediaWidth,
				videoAspectRatio = props.videoAspectRatio,
				topRadius = props.tokens.Radius.Medium
			}),
			steps = {
				current = tooltipModel.stepIndex,
				total = tooltipModel.totalSteps
			},
			actions = v5,
			selectionGroup = {
				SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
				SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
				SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
				SelectionBehaviorUp = Enum.SelectionBehavior.Stop
			},
			testId = "split-pane-educational-tour"
		})
	end

	local rect

	if props.supportPaneRect ~= nil then
		local supportPaneRect = props.supportPaneRect
		local overlayOrigin = props.overlayOrigin
		rect = Rect.new(supportPaneRect.Min - overlayOrigin, supportPaneRect.Max - overlayOrigin)
	end

	local rect2

	if props.presentation.spotlightRect ~= nil then
		local spotlightRect = props.presentation.spotlightRect
		local overlayOrigin = props.overlayOrigin
		rect2 = Rect.new(spotlightRect.Min - overlayOrigin, spotlightRect.Max - overlayOrigin)
	end

	local v7

	if props.presentation.dimEndX ~= nil then
		v7 = props.presentation.dimEndX - props.overlayOrigin.X
	end

	local isTooltipContentVisible = props.presentation.isAnchorReady and props.isTooltipContentVisible
	local v9

	if props.overlayInstance ~= nil then
		local createPortal = ReactRoblox.createPortal
		local createElement = React.createElement
		local fragment = React.Fragment
		local v12 = if props.presentation.isGamepadCollapsedStepOne then React.createElement("Frame", {
			Name = "GamepadCollapsedTooltipAnchor",
			ref = props.setGamepadCollapsedTooltipAnchorInstance,
			Position = UDim2.new(0.5, props.mediaWidth / 2 + props.tokens.Padding.Small, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}) else nil
		local v13

		if props.hasPresentedTooltip or props.holdsInputBeforeTooltip then
			local createElement2 = React.createElement

			if not isTooltipContentVisible then
				rect2 = nil
			end

			if not isTooltipContentVisible then
				v7 = nil
			end

			v13 = createElement2(SplitPaneEducationalTourScrim, {
				targetRect = rect2,
				dimEndX = v7,
				isTransparent = not props.hasPresentedTooltip
			})
		end

		local v14 = if props.holdsInputBeforeTooltip and props.tooltipModel == nil then React.createElement("Frame", {
			Name = "SplitPaneEducationalTourFocusHold",
			ref = props.setFocusSurfaceRef,
			Size = UDim2.fromOffset(1, 1),
			BackgroundTransparency = 1,
			SelectionGroup = true,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop
		}, {
			FocusTarget = React.createElement("TextButton", {
				Name = "FocusTarget",
				ref = props.setPrimaryActionRef,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				Selectable = true,
				SelectionImageObject = frame,
				Text = ""
			})
		}) else nil

		local v15 = if rect ~= nil and props.supportOverlayTopInset ~= nil and not props.presentation.isCollapsedStepOne then React.createElement(SplitPaneEducationalTourChrome, {
			supportPaneRect = rect,
			topInset = props.supportOverlayTopInset,
			onBottomPaneTooltipAnchorInstanceChanged = props.setBottomPaneTooltipAnchorInstance,
			onGamepadStepTwoTooltipAnchorInstanceChanged = props.setGamepadStepTwoTooltipAnchorInstance,
			onGamepadFinalTooltipAnchorInstanceChanged = props.setGamepadFinalTooltipAnchorInstance,
			onTopRightControlInstanceChanged = props.setTopRightControlInstance
		}) else nil
		v9 = createPortal(
			createElement(fragment, nil, {
				GamepadCollapsedTooltipAnchor = v12,
				Scrim = v13,
				FocusHold = v14,
				Chrome = v15
			}),
			props.overlayInstance
		)
	end

	local v8 = { OverlayPortal = v9 }

	if v6 ~= nil and tooltipModel ~= nil then
		v8[`Tooltip-{tooltipModel.stepIndex}`] = v6
	end

	return React.createElement(React.Fragment, nil, v8)
end

return SplitPaneEducationalTourView
