local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
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
local ParentParent = script.Parent.Parent
local Assets = require(ParentParent.Resources.Assets)
local Divider = require(ParentParent.Components.Divider)
local RestartScreenshotDialog = require(ParentParent.Components.RestartScreenshotDialog)

require(ParentParent.Utility.ReportAnythingAnalytics)

local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local GetFFlagAvatarIdentificationSafeAreaFix = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagAvatarIdentificationSafeAreaFix

local function ScreenshotReviewDialogSmallPortraitModeHeaderRight(p1) -- line: 60
	-- upvalues: React (copy), RobloxTranslator (copy), Button (copy), ButtonType (copy), StandardButtonSize (copy)
	local v28, v29 = React.useState(0)
	local v30 = React.useCallback(function(p2) -- line: 62
		-- upvalues: v29 (copy)
		v29(p2.AbsoluteSize.X)
	end, { v29 })
	local v31 = React.useCallback(function() -- line: 65
		-- upvalues: p1 (copy)
		p1.setShowRestartDialog(true)
	end, { p1.setShowRestartDialog })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Text = React.createElement("TextLabel", {
			LayoutOrder = -1,
			TextSize = 20,
			TextWrapped = true,
			BackgroundTransparency = 1,
			Text = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.SceneCaptured"),
			Font = p1.font.Header2.Font,
			TextColor3 = p1.theme.TextEmphasis.Color,
			TextTransparency = p1.theme.TextEmphasis.Transparency,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			Size = UDim2.new(0, p1.viewportUISafeAreaWidth - v28 - 50, 1, 0)
		}),
		RetakeButton = React.createElement(Button, {
			buttonType = ButtonType.Secondary,
			text = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.Retake"),
			fitContent = true,
			standardSize = StandardButtonSize.XSmall,
			onActivated = v31,
			[React.Change.AbsoluteSize] = v30
		})
	})
end
local function ScreenshotReviewDialog(t1: {[any]: any}) -- line: 106
	-- upvalues: usePreferredInput (copy), Responsive (copy), RobloxTranslator (copy), React (copy), useStyle (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), RestartScreenshotDialog (copy), ImageSetButton (copy), Assets (copy), HeaderBar (copy), IconButton (copy), IconSize (copy), Images (copy), ScreenshotReviewDialogSmallPortraitModeHeaderRight (copy), Button (copy), ButtonType (copy), StandardButtonSize (copy), Divider (copy), GetFFlagAvatarIdentificationSafeAreaFix (copy), ButtonStack (copy)
	local v33 = usePreferredInput() == Responsive.Input.Directional

	if not RobloxTranslator then
		return nil
	end

	local n1 = 60

	if t1.isSmallPortraitMode then
		n1 = 104
	end

	local v35 = React.useCallback(function() -- line: 118
		-- upvalues: t1 (copy)
		t1.reportAnythingAnalytics.incrementPreviewBack()
		t1.onBack()
	end, {
		t1.onBack,
		t1.reportAnythingAnalytics
	})
	local v36 = React.useCallback(function() -- line: 123
		-- upvalues: t1 (copy)
		t1.reportAnythingAnalytics.incrementPreviewAttach()
		t1.onSkip()
	end, {
		t1.onSkip,
		t1.reportAnythingAnalytics
	})
	local v37, v38 = React.useState(false)
	local v39 = React.useCallback(function() -- line: 130
		-- upvalues: t1 (copy), v38 (copy)
		t1.reportAnythingAnalytics.incrementRetake()
		v38(true)
	end, {
		v38,
		t1.reportAnythingAnalytics
	})
	local v40 = React.useCallback(function() -- line: 135
		-- upvalues: t1 (copy)
		t1.reportAnythingAnalytics.setRetakeAbandon()
		t1.onRestart()
	end, {
		t1.onRestart,
		t1.reportAnythingAnalytics
	})
	local v41 = React.useCallback(function() -- line: 140
		-- upvalues: t1 (copy)
		t1.reportAnythingAnalytics.incrementHighlightScene()
		t1.onNextPage()
	end, {
		t1.onNextPage,
		t1.reportAnythingAnalytics
	})
	local v42 = useStyle()
	local Theme = v42.Theme
	local Font = v42.Font
	local v45 = if not (t1.viewportUISafeAreaHeight >= 800) then UDim2.new(1, 0, 1, 0) else UDim2.new(0, 800, 0, 800)

	return React.createElement("TextButton", {
		Selectable = false,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		BackgroundColor3 = Theme.Overlay.Color,
		BackgroundTransparency = Theme.Overlay.Transparency,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 10,
		Text = "",
		[React.Event.Activated] = v35
	}, {
		Container = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 0,
			ZIndex = 10,
			Size = if not t1.isSmallPortraitMode then v45 else UDim2.new(1, 0, 1, 0),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Theme.Overlay.Color
		}, {
			RestartDialog = v37 and React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				FocusNavigationCoreScriptsWrapper = React.createElement(FocusRoot, {
					isIsolated = true,
					isAutoFocusRoot = true,
					surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
				}, {
					DialogBody = React.createElement(RestartScreenshotDialog, {
						ZIndex = 3,
						isSmallPortraitMode = t1.isSmallPortraitMode,
						onCancel = function() -- line: 185
							-- upvalues: v38 (copy)
							v38(false)
						end,
						onRestart = v40
					})
				})
			}),
			RestartDialogMask = v37 and React.createElement(ImageSetButton, {
				BackgroundTransparency = 0.2,
				Active = true,
				AutoButtonColor = false,
				ImageTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = Theme.BackgroundUIDefault.Color,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Image = Assets.Images.RoundedRect.Image,
				ImageColor3 = Theme.BackgroundUIDefault.Color,
				ScaleType = Assets.Images.RoundedRect.ScaleType,
				SliceCenter = Assets.Images.RoundedRect.SliceCenter
			}, {}),
			ScreenshotDialog = React.createElement(ImageSetButton, {
				Active = true,
				Selectable = false,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Image = Assets.Images.RoundedRect.Image,
				ImageColor3 = Theme.BackgroundUIDefault.Color,
				ImageTransparency = Theme.BackgroundUIDefault.Transparency,
				ScaleType = Assets.Images.RoundedRect.ScaleType,
				SliceCenter = Assets.Images.RoundedRect.SliceCenter
			}, {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				HeaderAndContent = React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, -n1)
				}, {
					Layout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					Header = React.createElement("Frame", {
						BackgroundTransparency = 0,
						LayoutOrder = 1,
						BackgroundColor3 = Color3.fromHex("#4F545F"),
						Size = UDim2.new(1, 0, 0, 48)
					}, {
						Bar = React.createElement(HeaderBar, {
							backgroundTransparency = 1,
							barHeight = 48,
							margin = 12,
							renderLeft = function() -- line: 245
								-- upvalues: React (copy), IconButton (copy), IconSize (copy), Images (copy), v35 (copy)
								return React.createElement(IconButton, {
									iconSize = IconSize.Medium,
									icon = Images["icons/navigation/pushBack"],
									onActivated = v35
								})
							end,
							renderRight = function() -- line: 253
								-- upvalues: t1 (copy), React (copy), ScreenshotReviewDialogSmallPortraitModeHeaderRight (copy), v39 (copy), Font (copy), Theme (copy), Button (copy), ButtonType (copy), RobloxTranslator (copy), StandardButtonSize (copy)
								if t1.isSmallPortraitMode then
									return React.createElement(ScreenshotReviewDialogSmallPortraitModeHeaderRight, {
										onActivated = v39,
										font = Font,
										theme = Theme,
										viewportUISafeAreaWidth = t1.viewportUISafeAreaWidth
									})
								end

								return React.createElement(Button, {
									fitContent = true,
									buttonType = ButtonType.Secondary,
									text = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.Retake"),
									standardSize = StandardButtonSize.XSmall,
									onActivated = v39
								})
							end,
							title = if not t1.isSmallPortraitMode then RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.SceneCaptured") else nil,
							isSecondary = t1.isSmallPortraitMode
						})
					}),
					Divider = React.createElement(Divider, {
						LayoutOrder = 2
					}),
					ScreenshotBody = React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 3,
						ZIndex = 10,
						Size = UDim2.new(1, 0, 1, -60)
					}, {
						Padding = React.createElement("UIPadding", {
							PaddingTop = UDim.new(0, 16)
						}),
						Layout = React.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder
						}),
						ScreenshotContainer = React.createElement("Frame", {
							BackgroundTransparency = 2,
							LayoutOrder = 1,
							Size = UDim2.new(1, 0, 1, -32)
						}, {
							Padding = React.createElement("UIPadding", {
								PaddingTop = UDim.new(0, 12),
								PaddingBottom = UDim.new(0, 12),
								PaddingLeft = UDim.new(0, 16),
								PaddingRight = UDim.new(0, 16)
							}),
							Screenshot = React.createElement("Frame", {
								BorderSizePixel = 2,
								LayoutOrder = 1,
								Size = UDim2.new(1, 0, 1, 0),
								Position = UDim2.fromScale(0.5, 0.5),
								AnchorPoint = Vector2.new(0.5, 0.5),
								BorderMode = if not GetFFlagAvatarIdentificationSafeAreaFix() then Enum.BorderMode.Inset else Enum.BorderMode.Outline,
								BorderColor3 = Color3.fromRGB(255, 255, 255)
							}, {
								UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
									AspectRatio = t1.imageAspectRatio
								}),
								ScreenshotImage = React.createElement(ImageSetButton, {
									Active = true,
									Selectable = not v33,
									Size = UDim2.fromScale(1, 1),
									Image = t1.screenshot,
									ZIndex = 1,
									AnchorPoint = Vector2.new(0.5, 0.5),
									Position = UDim2.fromScale(0.5, 0.5),
									BackgroundTransparency = 1,
									ScaleType = Enum.ScaleType.Fit,
									SliceCenter = Assets.Images.RoundedRect.SliceCenter,
									[React.Event.Activated] = v41
								})
							})
						}),
						Description = React.createElement("TextLabel", {
							LayoutOrder = 2,
							TextWrapped = true,
							BackgroundTransparency = 1,
							Text = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Message.ProblemNotInScene"),
							Font = Font.Header1.Font,
							TextColor3 = Theme.TextEmphasis.Color,
							TextTransparency = Theme.TextEmphasis.Transparency,
							TextSize = not t1.isSmallPortraitMode and 20 or 12,
							TextXAlignment = Enum.TextXAlignment.Center,
							Size = UDim2.new(1, -24, 0, not t1.isSmallPortraitMode and 40 or 24)
						})
					})
				}),
				Footer = React.createElement("Frame", {
					BackgroundTransparency = 0,
					LayoutOrder = 4,
					Size = UDim2.new(1, 0, 0, n1),
					BackgroundColor3 = Color3.fromHex("#4F545F"),
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.fromScale(0, 1)
				}, {
					Layout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center
					}),
					Container = React.createElement("Frame", {
						BackgroundTransparency = 1,
						Size = if not t1.isSmallPortraitMode then UDim2.new(0, not t1.isSmallPortraitMode and 612 or 400, 1, 0) else UDim2.new(1, 0, 1, 0)
					}, {
						Padding = React.createElement("UIPadding", {
							PaddingTop = UDim.new(0, 12),
							PaddingBottom = UDim.new(0, 12),
							PaddingLeft = UDim.new(0, 16),
							PaddingRight = UDim.new(0, 16)
						}),
						ActionButtons = React.createElement(ButtonStack, {
							marginBetween = 8,
							forcedFillDirection = if not t1.isSmallPortraitMode then nil else Enum.FillDirection.Vertical,
							buttons = {
								{
									buttonType = ButtonType.Secondary,
									props = {
										onActivated = v36,
										text = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.AttachScreenshot")
									}
								},
								if not v33 then {
									buttonType = ButtonType.PrimarySystem,
									props = {
										onActivated = v41,
										text = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.HighlightScene")
									}
								} else nil
							}
						})
					})
				})
			})
		})
	})
end

return ScreenshotReviewDialog
