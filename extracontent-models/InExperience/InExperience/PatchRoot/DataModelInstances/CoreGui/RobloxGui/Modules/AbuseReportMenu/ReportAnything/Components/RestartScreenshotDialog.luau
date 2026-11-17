local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local React = require(CorePackages.Packages.React)

local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local HeaderBar = UIBlox.App.Bar.HeaderBar

local useStyle = UIBlox.Core.Style.useStyle
local parent = script.Parent.Parent
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local Divider = require(parent.Components.Divider)

local function RestartScreenshotDialog(props)
	local v = useStyle()
	local theme = v.Theme
	local font = v.Font
	local v2, v3, v4

	if props.isSmallPortraitMode then
		v2 = 260
		v3 = 84
		v4 = 100
	else
		v2 = 180
		v3 = 48
		v4 = 50
	end

	local v5 = props.isSmallPortraitMode and 343 or 480
	local createElement = React.createElement
	local v6 = {
		Size = UDim2.new(0, v5, 0, v2),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundColor3 = Color3.fromHex("#4F545F"),
		ZIndex = 5
	}

	local v7 = {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		HeaderAndContent = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Header = React.createElement(HeaderBar, {
				backgroundTransparency = 1,
				barHeight = 48,
				renderLeft = function() end,
				renderRight = function() end,
				title = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.RetakeScene"),
				LayoutOrder = 1
			}),
			Divider = React.createElement(Divider, { LayoutOrder = 2 }),
			Description = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, -v3 - 1),
				BackgroundTransparency = 1,
				LayoutOrder = 3
			}, {
				Padding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 8),
					PaddingBottom = UDim.new(0, 8),
					PaddingLeft = UDim.new(0, 16),
					PaddingRight = UDim.new(0, 16)
				}),
				TextBody = React.createElement("TextLabel", {
					Text = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Message.RetakeScene"),
					FontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font),
					LayoutOrder = 3,
					TextColor3 = theme.TextEmphasis.Color,
					TextTransparency = theme.TextEmphasis.Transparency,
					TextSize = 16,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					Size = UDim2.new(1, 0, 0, v4),
					BackgroundTransparency = 1
				})
			})
		}),
		Footer = 0
	}

	local createElement2 = React.createElement
	local v8 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v3),
		Position = UDim2.new(0, 0, 1, -v3),
		BorderSizePixel = 0,
		LayoutOrder = 4
	}

	local v9 = {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 6),
			PaddingBottom = UDim.new(0, 6),
			PaddingLeft = UDim.new(0, 16),
			PaddingRight = UDim.new(0, 16)
		}),
		ActionButtons = 0
	}

	local createElement3 = React.createElement
	local forcedFillDirection

	if props.isSmallPortraitMode then
		forcedFillDirection = Enum.FillDirection.Vertical
	else
		forcedFillDirection = Enum.FillDirection.Horizontal
	end

	local v10 = { buttonType = ButtonType.Secondary, props = 0 }
	local props2

	if props.isSmallPortraitMode then
		props2 = {
			onActivated = props.onCancel,
			text = RobloxTranslator:FormatByKey("InGame.InspectMenu.Action.Cancel"),
			size = UDim2.new(1, 0, 0, 28),
			fontStyle = font.Body2
		}
	else
		props2 = {
			onActivated = props.onCancel,
			text = RobloxTranslator:FormatByKey("InGame.InspectMenu.Action.Cancel")
		}
	end

	v10.props = props2

	local v11 = { buttonType = ButtonType.PrimarySystem, props = 0 }
	local props3

	if props.isSmallPortraitMode then
		props3 = {
			onActivated = props.onRestart,
			text = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.BackToExperience"),
			size = UDim2.new(1, 0, 0, 28),
			fontStyle = font.Body2
		}
	else
		props3 = {
			onActivated = props.onRestart,
			text = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.BackToExperience")
		}
	end

	v11.props = props3
	v9.ActionButtons = createElement3(ButtonStack, {
		forcedFillDirection = forcedFillDirection,
		buttons = { v10, v11 }
	})
	v7.Footer = createElement2("Frame", v8, v9)
	return createElement("Frame", v6, v7)
end

return RestartScreenshotDialog
