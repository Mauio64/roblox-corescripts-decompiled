local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)

local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local useStyle = UIBlox.Core.Style.useStyle

local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local parent = script.Parent.Parent
local Assets = require(parent.Resources.Assets)
local Divider = require(parent.Components.Divider)
local ScreenshotHighlighter = require(parent.Components.ScreenshotHighlighter)
local VirtualKeyboardMonitor = require(parent.Utility.VirtualKeyboardMonitor)
local ScreenshotDialogPortraitModeHeader = require(parent.Components.ScreenshotDialogPortraitModeHeader)
local ScreenshotDialogLandscapeModeHeader = require(parent.Components.ScreenshotDialogLandscapeModeHeader)
require(parent.Utility.ReportAnythingAnalytics)

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local function PortraitModeFooter(p)
	return React.createElement("Frame", {
		BackgroundTransparency = 0,
		Size = UDim2.new(1, 0, 0, 60),
		BackgroundColor3 = Color3.fromHex("#4F545F"),
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		LayoutOrder = 4
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		Container = React.createElement("Frame", {
			Size = UDim2.new(0, 400, 1, 0),
			BackgroundTransparency = 1
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 12),
				PaddingLeft = UDim.new(0, 32),
				PaddingRight = UDim.new(0, 32)
			}),
			ActionButtons = React.createElement(ButtonStack, {
				marginBetween = 8,
				buttons = {
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = function()
								p.finishAnnotationAction(p.annotationPoints)
							end,
							text = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.Next")
						}
					}
				}
			})
		})
	})
end

local function ScreenshotDialog(props)
	local theme = useStyle().Theme

	local instance = VirtualKeyboardMonitor.getInstance()

	local state, setState = React.useState(Cryo.Dictionary.join({}, props.initialAnnotationPoints or {}))
	local state2, setState2 = React.useState({})

	local v = React.useCallback(function()
		setState(table.clone(state))
	end, { setState, state })

	local backAction = React.useCallback(function()
		props.reportAnythingAnalytics.incrementAnnotationBack()
		props.backAction()
	end, { props.backAction, props.reportAnythingAnalytics })

	local handleAnnotationPoints = React.useCallback(function(_)
		props.reportAnythingAnalytics.incrementAnnotationPlace()
		v()

		setState2({})
	end, { setState2, v, props.reportAnythingAnalytics })

	local undoAnnotationPoints = React.useCallback(function()
		if #state > 0 then
			props.reportAnythingAnalytics.incrementAnnotationUndo()

			table.insert(state2, 1, state[#state])
			table.remove(state, #state)
			v()
		end
	end, { v, state, state2, props.reportAnythingAnalytics })

	local redoAnnotationPoints = React.useCallback(function()
		if #state2 > 0 then
			props.reportAnythingAnalytics.incrementAnnotationRedo()

			table.insert(state, state2[1])
			table.remove(state2, 1)
			v()
		end
	end, { v, state, state2, props.reportAnythingAnalytics })

	local finishAnnotationAction = React.useCallback(function(p)
		props.reportAnythingAnalytics.setAnnotationNext()
		props.finishAnnotationAction(p)
	end, { props.finishAnnotationAction, props.reportAnythingAnalytics })

	local isUndoEnabled = #state > 0
	local isRedoEnabled = #state2 > 0

	local createElement = React.createElement
	local v2 = {
		AutoButtonColor = false,
		BorderSizePixel = 0,
		BackgroundColor3 = theme.Overlay.Color,
		BackgroundTransparency = theme.Overlay.Transparency,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		ZIndex = 10,
		Text = "",
		[React.Event.Activated] = function()
			warn("OverlayActivated")

			if instance:isKeyboardJustOff() then
				return
			end

			if props.dismissAction then
				warn("Menu dismissed")
				props.dismissAction()
			end
		end
	}

	local createElement2 = React.createElement
	local v3 = {
		Active = true,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Image = Assets.Images.RoundedRect.Image,
		ImageColor3 = theme.BackgroundUIDefault.Color,
		ImageTransparency = theme.BackgroundUIDefault.Transparency,
		ScaleType = Assets.Images.RoundedRect.ScaleType,
		SliceCenter = Assets.Images.RoundedRect.SliceCenter
	}

	local createElement3 = React.createElement
	local v4 = {
		Size = UDim2.new(1, 0, 1, props.isSmallPortraitMode and -60 or 0),
		BackgroundTransparency = 1
	}

	local children = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Header = 0,
		Divider = 0,
		ScreenshotAnnotation = 0
	}
	local header

	if props.isSmallPortraitMode then
		header = React.createElement(ScreenshotDialogPortraitModeHeader, {
			titleText = props.titleText,
			backAction = backAction,
			undoAnnotationPoints = undoAnnotationPoints,
			redoAnnotationPoints = redoAnnotationPoints,
			isRedoEnabled = isRedoEnabled,
			isUndoEnabled = isUndoEnabled,
			annotationPoints = state
		})
	else
		header = React.createElement(ScreenshotDialogLandscapeModeHeader, {
			titleText = props.titleText,
			backAction = backAction,
			finishAnnotationAction = finishAnnotationAction,
			undoAnnotationPoints = undoAnnotationPoints,
			redoAnnotationPoints = redoAnnotationPoints,
			isRedoEnabled = isRedoEnabled,
			isUndoEnabled = isUndoEnabled,
			annotationPoints = state
		})
	end

	children.Header = header

	children.Divider = React.createElement(Divider, { LayoutOrder = 2 })

	children.ScreenshotAnnotation = React.createElement(
		"Frame",
		{ BackgroundTransparency = 1, LayoutOrder = 3, Size = UDim2.new(1, 0, 1, -49), ZIndex = 1 },
		{
			Container = React.createElement(
				"Frame",
				{
					Size = UDim2.fromScale(1, 1),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					BackgroundTransparency = 1
				},
				{
					Layout = React.createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					Padding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 16),
						PaddingBottom = UDim.new(0, 16),
						PaddingLeft = UDim.new(0, 16),
						PaddingRight = UDim.new(0, 16)
					}),
					AnnotationLayer = React.createElement(
						"Frame",
						{
							Size = UDim2.new(1, 0, 1, 0),
							BorderSizePixel = 2,
							BorderMode = Enum.BorderMode.Outline,
							BorderColor3 = Color3.fromRGB(255, 255, 255)
						},
						{
							UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
								AspectRatio = props.imageAspectRatio
							}),
							ScreenshotImage = React.createElement(
								"ImageLabel",
								{
									Size = UDim2.fromScale(1, 1),
									Image = props.screenshot,
									ScaleType = Enum.ScaleType.Fit,
									ZIndex = 1
								},
								{}
							),
							Highlighter = React.createElement(ScreenshotHighlighter, {
								annotationPoints = state,
								handleAnnotationPoints = handleAnnotationPoints,
								setAnnotationCircleRadius = props.setAnnotationCircleRadius,
								setAnnotationAreaDimensions = props.setAnnotationAreaDimensions,
								ZIndex = 3
							}, {})
						}
					)
				}
			)
		}
	)
	local v5 = {
		HeaderAndContent = createElement3("Frame", v4, children),
		Footer = 0
	}
	local footer

	if props.isSmallPortraitMode then
		footer = React.createElement(PortraitModeFooter, {
			finishAnnotationAction = finishAnnotationAction,
			annotationPoints = state
		})
	end

	v5.Footer = footer
	return createElement("TextButton", v2, {
		ScreenshotDialog = createElement2(ImageSetButton, v3, v5)
	})
end

return ScreenshotDialog
