local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local React = require(CorePackages.Packages.React)

local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local HeaderBar = UIBlox.App.Bar.HeaderBar
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local Button = UIBlox.App.Button.Button
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize

local parent = script.Parent.Parent
local Assets = require(parent.Resources.Assets)
local Divider = require(parent.Components.Divider)
local RestartScreenshotDialog = require(parent.Components.RestartScreenshotDialog)
require(parent.Utility.ReportAnythingAnalytics)

local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local usePreferredInput = Responsive.usePreferredInput

local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local function ScreenshotReviewDialogSmallPortraitModeHeaderRight(props)
	local state, setState = React.useState(0)
	local v = React.useCallback(function(p)
		setState(p.AbsoluteSize.X)
	end, { setState })
	local onActivated = React.useCallback(function()
		props.setShowRestartDialog(true)
	end, { props.setShowRestartDialog })

	return React.createElement("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Text = React.createElement("TextLabel", {
			LayoutOrder = -1,
			Text = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.SceneCaptured"),
			Font = props.font.Header2.Font,
			TextColor3 = props.theme.TextEmphasis.Color,
			TextTransparency = props.theme.TextEmphasis.Transparency,
			TextSize = 20,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			Size = UDim2.new(0, props.viewportUISafeAreaWidth - state - 50, 1, 0),
			BackgroundTransparency = 1
		}),
		RetakeButton = React.createElement(Button, {
			buttonType = ButtonType.Secondary,
			text = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.Retake"),
			fitContent = true,
			standardSize = StandardButtonSize.XSmall,
			onActivated = onActivated,
			[React.Change.AbsoluteSize] = v
		})
	})
end

local function ScreenshotReviewDialog(props)
	local v = usePreferredInput() == Responsive.Input.Directional

	if not RobloxTranslator then
		return nil
	end

	local v2 = props.isSmallPortraitMode and 104 or 60

	local onActivated = React.useCallback(function()
		props.reportAnythingAnalytics.incrementPreviewBack()
		props.onBack()
	end, { props.onBack, props.reportAnythingAnalytics })

	local onActivated2 = React.useCallback(function()
		props.reportAnythingAnalytics.incrementPreviewAttach()
		props.onSkip()
	end, { props.onSkip, props.reportAnythingAnalytics })

	local state, setState = React.useState(false)

	local onActivated3 = React.useCallback(function()
		props.reportAnythingAnalytics.incrementRetake()
		setState(true)
	end, { setState, props.reportAnythingAnalytics })

	local onRestart = React.useCallback(function()
		props.reportAnythingAnalytics.setRetakeAbandon()
		props.onRestart()
	end, { props.onRestart, props.reportAnythingAnalytics })

	local onActivated4 = React.useCallback(function()
		props.reportAnythingAnalytics.incrementHighlightScene()
		props.onNextPage()
	end, { props.onNextPage, props.reportAnythingAnalytics })

	local v3 = useStyle()
	local theme = v3.Theme
	local font = v3.Font
	local udim

	if props.viewportUISafeAreaHeight >= 800 then
		udim = UDim2.new(0, 800, 0, 800)
	else
		udim = UDim2.new(1, 0, 1, 0)
	end

	local createElement = React.createElement
	local v4 = {
		Selectable = false,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		BackgroundColor3 = theme.Overlay.Color,
		BackgroundTransparency = theme.Overlay.Transparency,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 10,
		Text = "",
		[React.Event.Activated] = onActivated
	}

	local createElement2 = React.createElement

	if props.isSmallPortraitMode then
		udim = UDim2.new(1, 0, 1, 0)
	end

	local v5 = {
		Size = udim,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BorderSizePixel = 0,
		BackgroundColor3 = theme.Overlay.Color,
		BackgroundTransparency = 0,
		ZIndex = 10
	}

	local v6 = {
		RestartDialog = state and React.createElement(
			"Frame",
			{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 },
			{
				FocusNavigationCoreScriptsWrapper = React.createElement(
					FocusRoot,
					{
						surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
						isIsolated = true,
						isAutoFocusRoot = true
					},
					{
						DialogBody = React.createElement(RestartScreenshotDialog, {
							ZIndex = 3,
							isSmallPortraitMode = props.isSmallPortraitMode,
							onCancel = function()
								setState(false)
							end,
							onRestart = onRestart
						})
					}
				)
			}
		),
		RestartDialogMask = state and React.createElement(ImageSetButton, {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 0.2,
			BackgroundColor3 = theme.BackgroundUIDefault.Color,
			Active = true,
			AutoButtonColor = false,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Image = Assets.Images.RoundedRect.Image,
			ImageColor3 = theme.BackgroundUIDefault.Color,
			ImageTransparency = 1,
			ScaleType = Assets.Images.RoundedRect.ScaleType,
			SliceCenter = Assets.Images.RoundedRect.SliceCenter
		}, {}),
		ScreenshotDialog = 0
	}
	local createElement3 = React.createElement
	local v7 = {
		Active = true,
		Selectable = false,
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = Assets.Images.RoundedRect.Image,
		ImageColor3 = theme.BackgroundUIDefault.Color,
		ImageTransparency = theme.BackgroundUIDefault.Transparency,
		ScaleType = Assets.Images.RoundedRect.ScaleType,
		SliceCenter = Assets.Images.RoundedRect.SliceCenter
	}
	local children = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		HeaderAndContent = 0,
		Footer = 0
	}

	local createElement4 = React.createElement
	local v8 = {
		Size = UDim2.new(1, 0, 1, -v2),
		BackgroundTransparency = 1
	}

	local children2 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Header = 0,
		Divider = 0,
		ScreenshotBody = 0
	}

	local createElement5 = React.createElement
	local v9 = {
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromHex("#4F545F"),
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 48)
	}

	local createElement6 = React.createElement
	local v10 = {
		backgroundTransparency = 1,
		barHeight = 48,
		margin = 12,
		renderLeft = function()
			return React.createElement(IconButton, {
				iconSize = IconSize.Medium,
				icon = Images["icons/navigation/pushBack"],
				onActivated = onActivated
			})
		end,
		renderRight = function()
			if props.isSmallPortraitMode then
				return React.createElement(ScreenshotReviewDialogSmallPortraitModeHeaderRight, {
					onActivated = onActivated3,
					font = font,
					theme = theme,
					viewportUISafeAreaWidth = props.viewportUISafeAreaWidth
				})
			end

			return React.createElement(Button, {
				buttonType = ButtonType.Secondary,
				text = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.Retake"),
				fitContent = true,
				standardSize = StandardButtonSize.XSmall,
				onActivated = onActivated3
			})
		end,
		title = 0,
		isSecondary = 0
	}
	local title

	if not props.isSmallPortraitMode then
		title = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.SceneCaptured")
	end

	v10.title = title

	v10.isSecondary = props.isSmallPortraitMode
	children2.Header = createElement5("Frame", v9, { Bar = createElement6(HeaderBar, v10) })

	children2.Divider = React.createElement(Divider, { LayoutOrder = 2 })

	children2.ScreenshotBody = React.createElement(
		"Frame",
		{ BackgroundTransparency = 1, LayoutOrder = 3, Size = UDim2.new(1, 0, 1, -60), ZIndex = 10 },
		{
			Padding = React.createElement("UIPadding", { PaddingTop = UDim.new(0, 16) }),
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			ScreenshotContainer = React.createElement(
				"Frame",
				{ Size = UDim2.new(1, 0, 1, -32), BackgroundTransparency = 2, LayoutOrder = 1 },
				{
					Padding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 12),
						PaddingBottom = UDim.new(0, 12),
						PaddingLeft = UDim.new(0, 16),
						PaddingRight = UDim.new(0, 16)
					}),
					Screenshot = React.createElement("Frame", {
						Size = UDim2.new(1, 0, 1, 0),
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BorderSizePixel = 2,
						BorderMode = Enum.BorderMode.Outline,
						BorderColor3 = Color3.fromRGB(255, 255, 255),
						LayoutOrder = 1
					}, {
						UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
							AspectRatio = props.imageAspectRatio
						}),
						ScreenshotImage = React.createElement(ImageSetButton, {
							Active = true,
							Selectable = not v,
							Size = UDim2.fromScale(1, 1),
							Image = props.screenshot,
							ZIndex = 1,
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.fromScale(0.5, 0.5),
							BackgroundTransparency = 1,
							ScaleType = Enum.ScaleType.Fit,
							SliceCenter = Assets.Images.RoundedRect.SliceCenter,
							[React.Event.Activated] = onActivated4
						})
					})
				}
			),
			Description = React.createElement("TextLabel", {
				Text = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Message.ProblemNotInScene"),
				FontFace = normalizeFontFace(v3.Tokens.Typography.HeadingSmall.Font),
				LayoutOrder = 2,
				TextColor3 = theme.TextEmphasis.Color,
				TextTransparency = theme.TextEmphasis.Transparency,
				TextSize = props.isSmallPortraitMode and 12 or 20,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextWrapped = true,
				Size = UDim2.new(1, -24, 0, props.isSmallPortraitMode and 24 or 40),
				BackgroundTransparency = 1
			})
		}
	)
	children.HeaderAndContent = createElement4("Frame", v8, children2)

	local createElement7 = React.createElement
	local v11 = {
		BackgroundTransparency = 0,
		Size = UDim2.new(1, 0, 0, v2),
		BackgroundColor3 = Color3.fromHex("#4F545F"),
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		LayoutOrder = 4
	}

	local v12 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		Container = 0
	}

	local createElement8 = React.createElement
	local size

	if props.isSmallPortraitMode then
		size = UDim2.new(1, 0, 1, 0)
	else
		size = UDim2.new(0, props.isSmallPortraitMode and 400 or 612, 1, 0)
	end

	local v13 = {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 12),
			PaddingLeft = UDim.new(0, 16),
			PaddingRight = UDim.new(0, 16)
		}),
		ActionButtons = 0
	}

	local createElement9 = React.createElement
	local forcedFillDirection

	if props.isSmallPortraitMode then
		forcedFillDirection = Enum.FillDirection.Vertical
	end

	v13.ActionButtons = createElement9(ButtonStack, {
		forcedFillDirection = forcedFillDirection,
		marginBetween = 8,
		buttons = {
			{
				buttonType = ButtonType.Secondary,
				props = {
					onActivated = onActivated2,
					text = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.AttachScreenshot")
				}
			},
			not v and {
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = onActivated4,
					text = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.HighlightScene")
				}
			} or nil
		}
	})
	v12.Container = createElement8("Frame", { Size = size, BackgroundTransparency = 1 }, v13)
	children.Footer = createElement7("Frame", v11, v12)
	v6.ScreenshotDialog = createElement3(ImageSetButton, v7, children)
	return createElement("TextButton", v4, {
		Container = createElement2("Frame", v5, v6)
	})
end

return ScreenshotReviewDialog
