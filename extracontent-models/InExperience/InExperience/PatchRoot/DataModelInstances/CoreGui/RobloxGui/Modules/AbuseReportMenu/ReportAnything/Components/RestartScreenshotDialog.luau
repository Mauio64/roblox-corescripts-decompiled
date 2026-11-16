local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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

	local children = {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		HeaderAndContent = 0,
		Footer = 0
	}

	local createElement2 = React.createElement
	local v7 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

	local v8 = {
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
		Description = 0
	}

	local createElement3 = React.createElement
	local v9 = {
		Size = UDim2.new(1, 0, 1, -v3 - 1),
		BackgroundTransparency = 1,
		LayoutOrder = 3
	}

	local v10 = {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 8),
			PaddingBottom = UDim.new(0, 8),
			PaddingLeft = UDim.new(0, 16),
			PaddingRight = UDim.new(0, 16)
		}),
		TextBody = 0
	}

	local createElement4 = React.createElement
	local v11 = {
		Text = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Message.RetakeScene"),
		Font = 0,
		FontFace = 0,
		LayoutOrder = 3,
		TextColor3 = 0,
		TextTransparency = 0,
		TextSize = 16,
		TextWrapped = true,
		TextXAlignment = 0,
		TextYAlignment = 0,
		Size = 0,
		BackgroundTransparency = 1
	}
	local font2

	if not FoundationFontFaceMigration then
		font2 = font.Body.Font
	end

	v11.Font = font2
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font)
	end

	v11.FontFace = fontFace

	v11.TextColor3 = theme.TextEmphasis.Color
	v11.TextTransparency = theme.TextEmphasis.Transparency

	v11.TextXAlignment = Enum.TextXAlignment.Left
	v11.TextYAlignment = Enum.TextYAlignment.Top
	v11.Size = UDim2.new(1, 0, 0, v4)
	v10.TextBody = createElement4("TextLabel", v11)
	v8.Description = createElement3("Frame", v9, v10)
	children.HeaderAndContent = createElement2("Frame", v7, v8)

	local createElement5 = React.createElement
	local v12 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v3),
		Position = UDim2.new(0, 0, 1, -v3),
		BorderSizePixel = 0,
		LayoutOrder = 4
	}

	local v13 = {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 6),
			PaddingBottom = UDim.new(0, 6),
			PaddingLeft = UDim.new(0, 16),
			PaddingRight = UDim.new(0, 16)
		}),
		ActionButtons = 0
	}

	local createElement6 = React.createElement
	local forcedFillDirection

	if props.isSmallPortraitMode then
		forcedFillDirection = Enum.FillDirection.Vertical
	else
		forcedFillDirection = Enum.FillDirection.Horizontal
	end

	local v14 = { buttonType = ButtonType.Secondary, props = 0 }
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

	v14.props = props2

	local v15 = { buttonType = ButtonType.PrimarySystem, props = 0 }
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

	v15.props = props3
	v13.ActionButtons = createElement6(ButtonStack, {
		forcedFillDirection = forcedFillDirection,
		buttons = { v14, v15 }
	})
	children.Footer = createElement5("Frame", v12, v13)
	return createElement("Frame", v6, children)
end

return RestartScreenshotDialog
