local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local React = require(CorePackages.Packages.React)
local ButtonStack = UIBlox.App.Button.ButtonStack
local _ = UIBlox.App.Button.Enum.ButtonType
local HeaderBar = UIBlox.App.Bar.HeaderBar
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local ParentParent = script.Parent.Parent.Parent
local Assets = require(ParentParent.Resources.Assets)
local Dependencies = require(ParentParent.Dependencies)
local RestartScreenshotDialog = require(ParentParent.Components.ReportAnything.RestartScreenshotDialog)

require(ParentParent.Utility.ReportAnythingAnalytics)

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local GetFFlagReportAnythingLocalizationEnabled = require(ParentParent.Flags.GetFFlagReportAnythingLocalizationEnabled)
local Divider = require(Dependencies.Divider)

local function ScreenshotReviewDialogSmallPortraitModeHeaderRight(p1) -- line: 45
	-- upvalues: React (copy), RobloxTranslator (copy), Button (copy), ButtonType (copy), StandardButtonSize (copy)
	local v25, v26 = React.useState(0)
	local v27 = React.useCallback(function(p2) -- line: 47
		-- upvalues: v26 (copy)
		v26(p2.AbsoluteSize.X)
	end, { v26 })
	local v28 = React.useCallback(function() -- line: 50
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
			Size = UDim2.new(0, p1.viewportWidth - v25 - 50, 1, 0)
		}),
		RetakeButton = React.createElement(Button, {
			buttonType = ButtonType.Secondary,
			text = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.Retake"),
			fitContent = true,
			standardSize = StandardButtonSize.XSmall,
			onActivated = v28,
			[React.Change.AbsoluteSize] = v27
		})
	})
end
local function ScreenshotReviewDialog(t1: {[any]: any}) -- line: 91
	-- upvalues: React (copy), GetFFlagReportAnythingLocalizationEnabled (copy), useStyle (copy), RestartScreenshotDialog (copy), ImageSetButton (copy), Assets (copy), HeaderBar (copy), IconButton (copy), IconSize (copy), Images (copy), ScreenshotReviewDialogSmallPortraitModeHeaderRight (copy), Button (copy), ButtonType (copy), RobloxTranslator (copy), StandardButtonSize (copy), Divider (copy), ButtonStack (copy)
	React.useEffect(function() -- line: 92
		-- upvalues: t1 (copy)
		if t1.reportAnythingAnalytics then
			t1.reportAnythingAnalytics.incrementAnnotationOptionSeen()
		end
	end, {})

	local n1 = 60

	if GetFFlagReportAnythingLocalizationEnabled() and t1.isSmallPortraitMode then
		n1 = 104
	end

	local v31, v32 = React.useState(false)
	local v33 = useStyle()
	local Theme = v33.Theme
	local Font = v33.Font
	local v36 = if not (t1.viewportHeight >= 800) then UDim2.new(1, 0, 1, 0) else UDim2.new(0, 800, 0, 800)

	return React.createElement("TextButton", {
		AutoButtonColor = false,
		BorderSizePixel = 0,
		BackgroundColor3 = Theme.Overlay.Color,
		BackgroundTransparency = Theme.Overlay.Transparency,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 10,
		Text = "",
		[React.Event.Activated] = t1.onBack
	}, {
		Container = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 0,
			ZIndex = 10,
			Size = if not t1.isSmallPortraitMode then v36 else UDim2.new(1, 0, 1, 0),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Theme.Overlay.Color
		}, {
			RestartDialog = v31 and React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				DialogBody = React.createElement(RestartScreenshotDialog, {
					ZIndex = 3,
					isSmallPortraitMode = t1.isSmallPortraitMode,
					onCancel = function() -- line: 135
						-- upvalues: v32 (copy)
						v32(false)
					end,
					onRestart = t1.onRestart
				})
			}),
			RestartDialogMask = v31 and React.createElement(ImageSetButton, {
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
							renderLeft = function() -- line: 193
								-- upvalues: React (copy), IconButton (copy), IconSize (copy), Images (copy), t1 (copy)
								return React.createElement(IconButton, {
									iconSize = IconSize.Medium,
									icon = Images["icons/navigation/pushBack"],
									onActivated = function() -- line: 197
										-- upvalues: t1 (copy)
										t1.onBack()
									end
								})
							end,
							renderRight = function() -- line: 203
								-- upvalues: GetFFlagReportAnythingLocalizationEnabled (copy), t1 (copy), React (copy), ScreenshotReviewDialogSmallPortraitModeHeaderRight (copy), v32 (copy), Font (copy), Theme (copy), Button (copy), ButtonType (copy), RobloxTranslator (copy), StandardButtonSize (copy)
								if GetFFlagReportAnythingLocalizationEnabled() and t1.isSmallPortraitMode then
									return React.createElement(ScreenshotReviewDialogSmallPortraitModeHeaderRight, {
										setShowRestartDialog = v32,
										font = Font,
										theme = Theme,
										viewportWidth = t1.viewportWidth
									})
								end

								local v38 = not t1.isSmallPortraitMode and 120 or 72
								local v39 = not t1.isSmallPortraitMode and 36 or 28

								return React.createElement(Button, {
									buttonType = ButtonType.Secondary,
									size = if not GetFFlagReportAnythingLocalizationEnabled() then UDim2.new(0, v38, 0, v39) else nil,
									text = not GetFFlagReportAnythingLocalizationEnabled() and "Retake" or RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.Retake"),
									fitContent = GetFFlagReportAnythingLocalizationEnabled(),
									standardSize = if not GetFFlagReportAnythingLocalizationEnabled() then nil else StandardButtonSize.XSmall,
									onActivated = function() -- line: 227
										-- upvalues: v32 (copy)
										v32(true)
									end
								})
							end,
							title = not GetFFlagReportAnythingLocalizationEnabled() and "Scene Captured" or if not t1.isSmallPortraitMode then RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.SceneCaptured") else nil,
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
								BorderMode = Enum.BorderMode.Inset,
								BorderColor3 = Color3.fromRGB(255, 255, 255)
							}, {
								UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
									AspectRatio = t1.imageAspectRatio
								}),
								ScreenshotImage = React.createElement(ImageSetButton, {
									Active = true,
									Size = UDim2.fromScale(1, 1),
									Image = t1.screenshot,
									ZIndex = 1,
									AnchorPoint = Vector2.new(0.5, 0.5),
									Position = UDim2.fromScale(0.5, 0.5),
									BackgroundTransparency = 1,
									ScaleType = Enum.ScaleType.Fit,
									SliceCenter = Assets.Images.RoundedRect.SliceCenter,
									[React.Event.Activated] = function() -- line: 290
										-- upvalues: t1 (copy)
										t1.onNextPage()
									end
								})
							})
						}),
						Description = React.createElement("TextLabel", {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							Text = not GetFFlagReportAnythingLocalizationEnabled() and "If the problem is not in this scene, you can “Retake”\nthe screenshot." or RobloxTranslator:FormatByKey("Feature.ReportAbuse.Message.ProblemNotInScene"),
							Font = Font.Header1.Font,
							TextColor3 = Theme.TextEmphasis.Color,
							TextTransparency = Theme.TextEmphasis.Transparency,
							TextSize = not t1.isSmallPortraitMode and 20 or 12,
							TextXAlignment = Enum.TextXAlignment.Center,
							TextWrapped = GetFFlagReportAnythingLocalizationEnabled(),
							Size = if not GetFFlagReportAnythingLocalizationEnabled() then UDim2.new(1, 0, 0, 20) else UDim2.new(1, -24, 0, not t1.isSmallPortraitMode and 40 or 24)
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
						Size = if not GetFFlagReportAnythingLocalizationEnabled() or not t1.isSmallPortraitMode then UDim2.new(0, not t1.isSmallPortraitMode and 612 or 400, 1, 0) else UDim2.new(1, 0, 1, 0)
					}, {
						Padding = React.createElement("UIPadding", {
							PaddingTop = UDim.new(0, 12),
							PaddingBottom = UDim.new(0, 12),
							PaddingLeft = UDim.new(0, 16),
							PaddingRight = UDim.new(0, 16)
						}),
						ActionButtons = React.createElement(ButtonStack, {
							marginBetween = 8,
							forcedFillDirection = if not GetFFlagReportAnythingLocalizationEnabled() or not t1.isSmallPortraitMode then nil else Enum.FillDirection.Vertical,
							buttons = {
								{
									buttonType = ButtonType.Secondary,
									props = {
										onActivated = t1.onSkip,
										text = not GetFFlagReportAnythingLocalizationEnabled() and "Attach Screenshot" or RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.AttachScreenshot")
									}
								},
								{
									buttonType = ButtonType.PrimarySystem,
									props = {
										onActivated = function() -- line: 360
											-- upvalues: t1 (copy)
											t1.onNextPage()
										end,
										text = not GetFFlagReportAnythingLocalizationEnabled() and "Highlight Scene" or RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.HighlightScene")
									}
								}
							}
						})
					})
				})
			})
		})
	})
end

return ScreenshotReviewDialog
