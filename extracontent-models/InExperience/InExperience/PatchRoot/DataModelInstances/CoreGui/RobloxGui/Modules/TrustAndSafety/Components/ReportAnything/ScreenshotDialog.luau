local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local useStyle = UIBlox.Core.Style.useStyle
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ParentParent = script.Parent.Parent.Parent
local Assets = require(ParentParent.Resources.Assets)
local Dependencies = require(ParentParent.Dependencies)
local DebugCanvas = require(ParentParent.Components.DebugCanvas)
local ScreenshotHighlighter = require(ParentParent.Components.ReportAnything.ScreenshotHighlighter)
local VirtualKeyboardMonitor = require(ParentParent.Components.VirtualKeyboardMonitor)
local ScreenshotDialogPortraitModeHeader = require(ParentParent.Components.ReportAnything.ScreenshotDialogPortraitModeHeader)
local ScreenshotDialogLandscapeModeHeader = require(ParentParent.Components.ReportAnything.ScreenshotDialogLandscapeModeHeader)
local AbuseReportBuilder = require(ParentParent.Utility.AbuseReportBuilder)

require(ParentParent.Utility.ReportAnythingAnalytics)

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local GetFFlagReportAnythingLocalizationEnabled = require(ParentParent.Flags.GetFFlagReportAnythingLocalizationEnabled)
local Divider = require(Dependencies.Divider)

local function PortraitModeFooter(t1: {[any]: any}) -- line: 47
	-- upvalues: React (copy), ButtonStack (copy), ButtonType (copy), GetFFlagReportAnythingLocalizationEnabled (copy), RobloxTranslator (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 0,
		LayoutOrder = 4,
		Size = UDim2.new(1, 0, 0, 60),
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
			Size = UDim2.new(0, 400, 1, 0)
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 12),
				PaddingLeft = UDim.new(0, 32),
				PaddingRight = UDim.new(0, 32)
			}),
			ActionButtons = React.createElement(ButtonStack, {
				marginBetween = 8,
				buttons = {{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = function() -- line: 76
							-- upvalues: t1 (copy)
							t1.reportAction(t1.annotationPoints)
						end,
						text = not GetFFlagReportAnythingLocalizationEnabled() and "Next" or RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.Next")
					}
				}}
			})
		})
	})
end
local function ScreenshotDialog(t2: {[any]: any}) -- line: 90
	-- upvalues: React (copy), useStyle (copy), VirtualKeyboardMonitor (copy), Cryo (copy), ImageSetButton (copy), Assets (copy), ScreenshotDialogPortraitModeHeader (copy), ScreenshotDialogLandscapeModeHeader (copy), Divider (copy), DebugCanvas (copy), AbuseReportBuilder (copy), ScreenshotHighlighter (copy), PortraitModeFooter (copy)
	React.useEffect(function() -- line: 92
		-- upvalues: t2 (copy)
		if t2.reportAnythingAnalytics then
			t2.reportAnythingAnalytics.incrementAnnotationPageSeen()
		end
	end, {})

	local Theme = useStyle().Theme
	local v26 = VirtualKeyboardMonitor.getInstance()
	local v27, v28 = React.useState(Cryo.Dictionary.join({}, t2.initialAnnotationPoints or {}))
	local v29, v30 = React.useState({})

	local function updatePointsAndRerender() -- line: 120
		-- upvalues: v27 (copy), v28 (copy)
		local t3 = {}

		for k, v in pairs(v27) do
			t3[k] = v
		end

		v28(t3)
	end
	local function v32() -- line: 138
		-- upvalues: v27 (copy), t2 (copy), v29 (copy), v28 (copy)
		if #v27 > 0 then
			if t2.reportAnythingAnalytics then
				t2.reportAnythingAnalytics.incrementAnnotationUndo()
			end

			table.insert(v29, 1, v27[#v27])
			table.remove(v27, #v27)

			local t4 = {}

			for k, v in pairs(v27) do
				t4[k] = v
			end

			v28(t4)
		end
	end
	local function v33() -- line: 150
		-- upvalues: v29 (copy), t2 (copy), v27 (copy), v28 (copy)
		if #v29 > 0 then
			if t2.reportAnythingAnalytics then
				t2.reportAnythingAnalytics.incrementAnnotationRedo()
			end

			table.insert(v27, v29[1])
			table.remove(v29, 1)

			local t5 = {}

			for k, v in pairs(v27) do
				t5[k] = v
			end

			v28(t5)
		end
	end

	local v34 = #v27 > 0
	local v35 = #v29 > 0

	return React.createElement("TextButton", {
		AutoButtonColor = false,
		BorderSizePixel = 0,
		BackgroundColor3 = Theme.Overlay.Color,
		BackgroundTransparency = Theme.Overlay.Transparency,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		ZIndex = 10,
		Text = "",
		[React.Event.Activated] = function() -- line: 103
			-- upvalues: v26 (copy), t2 (copy)
			warn("OverlayActivated")

			if v26:isKeyboardJustOff() then
				return
			end

			if t2.dismissAction then
				warn("Menu dismissed")
				t2.dismissAction()
			end
		end
	}, {
		ScreenshotDialog = React.createElement(ImageSetButton, {
			Active = true,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Image = Assets.Images.RoundedRect.Image,
			ImageColor3 = Theme.BackgroundUIDefault.Color,
			ImageTransparency = Theme.BackgroundUIDefault.Transparency,
			ScaleType = Assets.Images.RoundedRect.ScaleType,
			SliceCenter = Assets.Images.RoundedRect.SliceCenter
		}, {
			HeaderAndContent = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, not t2.isSmallPortraitMode and 0 or -60)
			}, {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Header = if not t2.isSmallPortraitMode then React.createElement(ScreenshotDialogLandscapeModeHeader, {
					titleText = t2.titleText,
					backAction = t2.backAction,
					reportAction = t2.reportAction,
					undoAnnotationPoints = v32,
					redoAnnotationPoints = v33,
					isRedoEnabled = v35,
					isUndoEnabled = v34,
					annotationPoints = v27
				}) else React.createElement(ScreenshotDialogPortraitModeHeader, {
					titleText = t2.titleText,
					backAction = t2.backAction,
					undoAnnotationPoints = v32,
					redoAnnotationPoints = v33,
					isRedoEnabled = v35,
					isUndoEnabled = v34,
					annotationPoints = v27
				}),
				Divider = React.createElement(Divider, {
					LayoutOrder = 2
				}),
				ScreenshotAnnotation = React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					ZIndex = 1,
					Size = UDim2.new(1, 0, 1, -49)
				}, {
					Container = React.createElement("Frame", {
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 1),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5)
					}, {
						UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
							AspectRatio = t2.imageAspectRatio
						}),
						Padding = React.createElement("UIPadding", {
							PaddingTop = UDim.new(0, 16),
							PaddingBottom = UDim.new(0, 16),
							PaddingLeft = UDim.new(0, 16),
							PaddingRight = UDim.new(0, 16)
						}),
						AnnotationLayer = React.createElement("Frame", {
							BorderSizePixel = 2,
							Size = UDim2.new(1, 0, 1, 0),
							BorderMode = Enum.BorderMode.Inset,
							BorderColor3 = Color3.fromRGB(255, 255, 255)
						}, {
							ScreenshotImage = React.createElement("ImageLabel", {
								ZIndex = 1,
								Size = UDim2.fromScale(1, 1),
								Image = t2.screenshot
							}, {}),
							DebugCanvas = React.createElement(DebugCanvas, {
								ZIndex = 2,
								identifiedAvatars = AbuseReportBuilder.getIdentifiedAvatars(),
								identifiedAds = AbuseReportBuilder.getIdentifiedAds()
							}),
							Highlighter = React.createElement(ScreenshotHighlighter, {
								ZIndex = 3,
								annotationPoints = v27,
								handleAnnotationPoints = function(_: {[any]: any}) -- line: 128
									-- upvalues: t2 (copy), v27 (copy), v28 (copy), v30 (copy)
									if t2.reportAnythingAnalytics then
										t2.reportAnythingAnalytics.incrementAnnotationPlace()
									end

									local t7 = {}

									for k, v in pairs(v27) do
										t7[k] = v
									end

									v28(t7)
									v30({})
								end,
								setAnnotationCircleRadius = AbuseReportBuilder.setAnnotationCircleRadius,
								setAspectRatioDimensions = AbuseReportBuilder.setAspectRatioDimensions
							}, {})
						})
					})
				})
			}),
			Footer = if not t2.isSmallPortraitMode then nil else React.createElement(PortraitModeFooter, {
				reportAction = t2.reportAction,
				annotationPoints = v27
			})
		})
	})
end

return ScreenshotDialog
