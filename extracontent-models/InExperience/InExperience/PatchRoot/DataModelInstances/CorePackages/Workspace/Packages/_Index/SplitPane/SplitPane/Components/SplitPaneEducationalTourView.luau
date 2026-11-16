local parent = script:FindFirstAncestor("SplitPane").Parent

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Foundation = require(parent.Foundation)

local SplitPaneEducationalTourChrome = require(script.Parent.SplitPaneEducationalTourChrome)
local SplitPaneEducationalTourScrim = require(script.Parent.SplitPaneEducationalTourScrim)
local SplitPaneEducationalTourVideo = require(script.Parent.SplitPaneEducationalTourVideo)
require(script.Parent.getSplitPaneEducationalTourPresentation)
require(script.Parent.getSplitPaneEducationalTourTooltipModel)

local ButtonVariant = Foundation.Enums.ButtonVariant
local EducationalTooltip = Foundation.EducationalTooltip

local function toOverlayLocalRect(rect: Rect, overlayOrigin: Vector2) -- 2 equivalent calls inferred from this helper
	return Rect.new(rect.Min - overlayOrigin, rect.Max - overlayOrigin)
end

local frame = Instance.new("Frame")
frame.BackgroundTransparency = 1

local function SplitPaneEducationalTourView(props)
	local actions = {}

	if props.tooltipModel ~= nil then
		if props.tooltipModel.isFinal then
			table.insert(actions, {
				text = props.tooltipModel.primaryActionText,
				variant = ButtonVariant.Emphasis,
				onActivated = props.onEnd,
				ref = props.setPrimaryActionRef,
				testId = "split-pane-educational-tour--action-finish-tour"
			})
		else
			table.insert(actions, {
				text = props.tooltipModel.primaryActionText,
				variant = ButtonVariant.Emphasis,
				onActivated = props.onNext,
				ref = props.setPrimaryActionRef,
				testId = "split-pane-educational-tour--action-next"
			})

			table.insert(actions, {
				text = props.tooltipModel.skipActionText or "",
				variant = ButtonVariant.Standard,
				onActivated = props.onEnd,
				testId = "split-pane-educational-tour--action-skip"
			})
		end
	end

	local tooltipModel = props.tooltipModel
	local v

	if props.presentation.isAnchorReady and tooltipModel ~= nil and props.presentation.anchorRef ~= nil then
		v = React.createElement(EducationalTooltip, {
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
			steps = { current = tooltipModel.stepIndex, total = tooltipModel.totalSteps },
			actions = actions,
			selectionGroup = {
				SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
				SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
				SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
				SelectionBehaviorUp = Enum.SelectionBehavior.Stop
			},
			testId = "split-pane-educational-tour"
		})
	end

	local supportPaneRect

	if props.supportPaneRect ~= nil then
		supportPaneRect = toOverlayLocalRect(props.supportPaneRect, props.overlayOrigin) -- inferred equivalent call
	end

	local targetRect

	if props.presentation.spotlightRect ~= nil then
		targetRect = toOverlayLocalRect(props.presentation.spotlightRect, props.overlayOrigin) -- inferred equivalent call
	end

	local dimEndX

	if props.presentation.dimEndX ~= nil then
		dimEndX = props.presentation.dimEndX - props.overlayOrigin.X
	end

	local isTooltipContentVisible = props.presentation.isAnchorReady and props.isTooltipContentVisible
	local overlayPortal

	if props.overlayInstance ~= nil then
		local createPortal = ReactRoblox.createPortal
		local createElement = React.createElement
		local fragment = React.Fragment
		local gamepadCollapsedTooltipAnchor

		if props.presentation.isGamepadCollapsedStepOne then
			gamepadCollapsedTooltipAnchor = React.createElement("Frame", {
				Name = "GamepadCollapsedTooltipAnchor",
				ref = props.setGamepadCollapsedTooltipAnchorInstance,
				Position = UDim2.new(0.5, props.mediaWidth / 2 + props.tokens.Padding.Small, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			})
		end

		local scrim

		if props.hasPresentedTooltip or props.holdsInputBeforeTooltip then
			local createElement2 = React.createElement

			if not isTooltipContentVisible then
				targetRect = nil
			end

			if not isTooltipContentVisible then
				dimEndX = nil
			end

			scrim = createElement2(SplitPaneEducationalTourScrim, {
				targetRect = targetRect,
				dimEndX = dimEndX,
				isTransparent = not props.hasPresentedTooltip
			})
		end

		local focusHold

		if props.holdsInputBeforeTooltip and props.tooltipModel == nil then
			focusHold = React.createElement("Frame", {
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
			})
		end

		local chrome

		if not (supportPaneRect == nil or props.supportOverlayTopInset == nil or props.presentation.isCollapsedStepOne) then
			chrome = React.createElement(SplitPaneEducationalTourChrome, {
				supportPaneRect = supportPaneRect,
				topInset = props.supportOverlayTopInset,
				onBottomPaneTooltipAnchorInstanceChanged = props.setBottomPaneTooltipAnchorInstance,
				onGamepadStepTwoTooltipAnchorInstanceChanged = props.setGamepadStepTwoTooltipAnchorInstance,
				onGamepadFinalTooltipAnchorInstanceChanged = props.setGamepadFinalTooltipAnchorInstance,
				onTopRightControlInstanceChanged = props.setTopRightControlInstance
			})
		end

		overlayPortal = createPortal(
			createElement(fragment, nil, {
				GamepadCollapsedTooltipAnchor = gamepadCollapsedTooltipAnchor,
				Scrim = scrim,
				FocusHold = focusHold,
				Chrome = chrome
			}),
			props.overlayInstance
		)
	end

	local v2 = { OverlayPortal = overlayPortal }

	if v ~= nil and tooltipModel ~= nil then
		v2[`Tooltip-{tooltipModel.stepIndex}`] = v
	end

	return React.createElement(React.Fragment, nil, v2)
end

return SplitPaneEducationalTourView
