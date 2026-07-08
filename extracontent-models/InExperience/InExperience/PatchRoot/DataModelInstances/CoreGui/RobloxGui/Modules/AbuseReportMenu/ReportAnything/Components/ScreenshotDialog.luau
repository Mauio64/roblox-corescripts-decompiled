local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local useStyle = UIBlox.Core.Style.useStyle
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ParentParent = script.Parent.Parent
local Assets = require(ParentParent.Resources.Assets)
local Divider = require(ParentParent.Components.Divider)
local ScreenshotHighlighter = require(ParentParent.Components.ScreenshotHighlighter)
local VirtualKeyboardMonitor = require(ParentParent.Utility.VirtualKeyboardMonitor)
local ScreenshotDialogPortraitModeHeader = require(ParentParent.Components.ScreenshotDialogPortraitModeHeader)
local ScreenshotDialogLandscapeModeHeader = require(ParentParent.Components.ScreenshotDialogLandscapeModeHeader)

require(ParentParent.Utility.ReportAnythingAnalytics)

local GetFFlagAvatarIdentificationSafeAreaFix = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagAvatarIdentificationSafeAreaFix
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local function PortraitModeFooter(t1: {[any]: any}) -- line: 45
	-- upvalues: React (copy), ButtonStack (copy), ButtonType (copy), RobloxTranslator (copy)
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
							t1.finishAnnotationAction(t1.annotationPoints)
						end,
						text = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.Next")
					}
				}}
			})
		})
	})
end
local function ScreenshotDialog(t2: {[any]: any}) -- line: 88
	-- upvalues: useStyle (copy), VirtualKeyboardMonitor (copy), React (copy), Cryo (copy), ImageSetButton (copy), Assets (copy), ScreenshotDialogPortraitModeHeader (copy), ScreenshotDialogLandscapeModeHeader (copy), Divider (copy), GetFFlagAvatarIdentificationSafeAreaFix (copy), ScreenshotHighlighter (copy), PortraitModeFooter (copy)
	local Theme = useStyle().Theme
	local v23 = VirtualKeyboardMonitor.getInstance()
	local v24, v25 = React.useState(Cryo.Dictionary.join({}, t2.initialAnnotationPoints or {}))
	local v26, v27 = React.useState({})
	local v28 = React.useCallback(function() -- line: 111
		-- upvalues: v25 (copy), v24 (copy)
		v25(table.clone(v24))
	end, {
		v25,
		v24
	})
	local v29 = React.useCallback(function() -- line: 115
		-- upvalues: t2 (copy)
		t2.reportAnythingAnalytics.incrementAnnotationBack()
		t2.backAction()
	end, {
		t2.backAction,
		t2.reportAnythingAnalytics
	})
	local v30 = React.useCallback(function(_: {[any]: any}) -- line: 120
		-- upvalues: t2 (copy), v28 (copy), v27 (copy)
		t2.reportAnythingAnalytics.incrementAnnotationPlace()
		v28()
		v27({})
	end, {
		v27,
		v28,
		t2.reportAnythingAnalytics
	})
	local v31 = React.useCallback(function() -- line: 127
		-- upvalues: v24 (copy), t2 (copy), v26 (copy), v28 (copy)
		if #v24 > 0 then
			t2.reportAnythingAnalytics.incrementAnnotationUndo()
			table.insert(v26, 1, v24[#v24])
			table.remove(v24, #v24)
			v28()
		end
	end, {
		v28,
		v24,
		v26,
		t2.reportAnythingAnalytics
	})
	local v32 = React.useCallback(function() -- line: 137
		-- upvalues: v26 (copy), t2 (copy), v24 (copy), v28 (copy)
		if #v26 > 0 then
			t2.reportAnythingAnalytics.incrementAnnotationRedo()
			table.insert(v24, v26[1])
			table.remove(v26, 1)
			v28()
		end
	end, {
		v28,
		v24,
		v26,
		t2.reportAnythingAnalytics
	})
	local v33 = React.useCallback(function(t4: {[any]: any}) -- line: 147
		-- upvalues: t2 (copy)
		t2.reportAnythingAnalytics.setAnnotationNext()
		t2.finishAnnotationAction(t4)
	end, {
		t2.finishAnnotationAction,
		t2.reportAnythingAnalytics
	})
	local v34 = #v24 > 0
	local v35 = #v26 > 0

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
		[React.Event.Activated] = function() -- line: 94
			-- upvalues: v23 (copy), t2 (copy)
			warn("OverlayActivated")

			if v23:isKeyboardJustOff() then
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
					backAction = v29,
					finishAnnotationAction = v33,
					undoAnnotationPoints = v31,
					redoAnnotationPoints = v32,
					isRedoEnabled = v35,
					isUndoEnabled = v34,
					annotationPoints = v24
				}) else React.createElement(ScreenshotDialogPortraitModeHeader, {
					titleText = t2.titleText,
					backAction = v29,
					undoAnnotationPoints = v31,
					redoAnnotationPoints = v32,
					isRedoEnabled = v35,
					isUndoEnabled = v34,
					annotationPoints = v24
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
						UIAspectRatioConstraint = if not GetFFlagAvatarIdentificationSafeAreaFix() then React.createElement("UIAspectRatioConstraint", {
							AspectRatio = t2.imageAspectRatio
						}) else nil,
						Layout = if not GetFFlagAvatarIdentificationSafeAreaFix() then nil else React.createElement("UIListLayout", {
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							VerticalAlignment = Enum.VerticalAlignment.Center
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
							BorderMode = if not GetFFlagAvatarIdentificationSafeAreaFix() then Enum.BorderMode.Inset else Enum.BorderMode.Outline,
							BorderColor3 = Color3.fromRGB(255, 255, 255)
						}, {
							UIAspectRatioConstraint = if not GetFFlagAvatarIdentificationSafeAreaFix() then nil else React.createElement("UIAspectRatioConstraint", {
								AspectRatio = t2.imageAspectRatio
							}),
							ScreenshotImage = React.createElement("ImageLabel", {
								ZIndex = 1,
								Size = UDim2.fromScale(1, 1),
								Image = t2.screenshot,
								ScaleType = Enum.ScaleType.Fit
							}, {}),
							Highlighter = React.createElement(ScreenshotHighlighter, {
								ZIndex = 3,
								annotationPoints = v24,
								handleAnnotationPoints = v30,
								setAnnotationCircleRadius = t2.setAnnotationCircleRadius,
								setAnnotationAreaDimensions = t2.setAnnotationAreaDimensions
							}, {})
						})
					})
				})
			}),
			Footer = if not t2.isSmallPortraitMode then nil else React.createElement(PortraitModeFooter, {
				finishAnnotationAction = v33,
				annotationPoints = v24
			})
		})
	})
end

return ScreenshotDialog
