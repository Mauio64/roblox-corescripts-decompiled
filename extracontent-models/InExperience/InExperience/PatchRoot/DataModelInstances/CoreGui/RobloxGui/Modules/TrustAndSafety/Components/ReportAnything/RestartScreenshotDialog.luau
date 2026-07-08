local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local React = require(CorePackages.Packages.React)
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local HeaderBar = UIBlox.App.Bar.HeaderBar
local useStyle = UIBlox.Core.Style.useStyle
local ParentParent = script.Parent.Parent.Parent
local Dependencies = require(ParentParent.Dependencies)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local GetFFlagReportAnythingLocalizationEnabled = require(ParentParent.Flags.GetFFlagReportAnythingLocalizationEnabled)
local Divider = require(Dependencies.Divider)

local function RestartScreenshotDialog(t1: {[any]: any}) -- line: 27
	-- upvalues: useStyle (copy), GetFFlagReportAnythingLocalizationEnabled (copy), React (copy), HeaderBar (copy), RobloxTranslator (copy), Divider (copy), ButtonStack (copy), ButtonType (copy)
	local v15 = useStyle()
	local Theme = v15.Theme
	local Font = v15.Font
	local n1 = 48
	local n2 = 180
	local n3 = 50

	if GetFFlagReportAnythingLocalizationEnabled() and t1.isSmallPortraitMode then
		n1 = 84
		n2 = 260
		n3 = 100
	end

	local v21 = not t1.isSmallPortraitMode and 480 or 343

	return React.createElement("Frame", {
		ZIndex = 5,
		Size = UDim2.new(0, v21, 0, n2),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundColor3 = Color3.fromHex("#4F545F")
	}, {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
		HeaderAndContent = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Header = React.createElement(HeaderBar, {
				backgroundTransparency = 1,
				barHeight = 48,
				LayoutOrder = 1,
				renderLeft = function() -- line: 64
				end,
				renderRight = function() -- line: 66
				end,
				title = not GetFFlagReportAnythingLocalizationEnabled() and "Retake Scene" or RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.RetakeScene")
			}),
			Divider = React.createElement(Divider, {
				LayoutOrder = 2
			}),
			Description = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 1, -n1 - 1)
			}, {
				Padding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 8),
					PaddingBottom = UDim.new(0, 8),
					PaddingLeft = UDim.new(0, 16),
					PaddingRight = UDim.new(0, 16)
				}),
				TextBody = React.createElement("TextLabel", {
					LayoutOrder = 3,
					TextSize = 16,
					TextWrapped = true,
					BackgroundTransparency = 1,
					Text = not GetFFlagReportAnythingLocalizationEnabled() and "Help us understand what’s happening around you. We’ll capture the scene the moment you select “Report.”" or RobloxTranslator:FormatByKey("Feature.ReportAbuse.Message.RetakeScene"),
					Font = Font.Body.Font,
					TextColor3 = Theme.TextEmphasis.Color,
					TextTransparency = Theme.TextEmphasis.Transparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = if not GetFFlagReportAnythingLocalizationEnabled() then nil else Enum.TextYAlignment.Top,
					Size = UDim2.new(1, 0, 0, n3)
				})
			})
		}),
		Footer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 4,
			Size = UDim2.new(1, 0, 0, n1),
			Position = UDim2.new(0, 0, 1, -n1)
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 6),
				PaddingBottom = UDim.new(0, 6),
				PaddingLeft = UDim.new(0, 16),
				PaddingRight = UDim.new(0, 16)
			}),
			ActionButtons = React.createElement(ButtonStack, {
				forcedFillDirection = if not GetFFlagReportAnythingLocalizationEnabled() or not t1.isSmallPortraitMode then Enum.FillDirection.Horizontal else Enum.FillDirection.Vertical,
				buttons = {
					{
						buttonType = ButtonType.Secondary,
						props = if not t1.isSmallPortraitMode then {
							onActivated = t1.onCancel,
							text = not GetFFlagReportAnythingLocalizationEnabled() and "Cancel" or RobloxTranslator:FormatByKey("InGame.InspectMenu.Action.Cancel")
						} else {
							onActivated = t1.onCancel,
							text = not GetFFlagReportAnythingLocalizationEnabled() and "Cancel" or RobloxTranslator:FormatByKey("InGame.InspectMenu.Action.Cancel"),
							size = if not GetFFlagReportAnythingLocalizationEnabled() then UDim2.new(0, 80, 0, 28) else UDim2.new(1, 0, 0, 28),
							fontStyle = Font.Body2
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = if not t1.isSmallPortraitMode then {
							onActivated = t1.onRestart,
							text = not GetFFlagReportAnythingLocalizationEnabled() and "Back To Experience" or RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.BackToExperience")
						} else {
							onActivated = t1.onRestart,
							text = not GetFFlagReportAnythingLocalizationEnabled() and "Back To Experience" or RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.BackToExperience"),
							size = if not GetFFlagReportAnythingLocalizationEnabled() then UDim2.new(0, 200, 0, 28) else UDim2.new(1, 0, 0, 28),
							fontStyle = Font.Body2
						}
					}
				}
			})
		})
	})
end

return RestartScreenshotDialog
