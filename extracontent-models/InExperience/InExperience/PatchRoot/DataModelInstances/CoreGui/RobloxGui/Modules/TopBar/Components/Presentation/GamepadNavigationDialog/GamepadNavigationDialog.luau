local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
game:GetService("LocalizationService")
local ContextActionService = game:GetService("ContextActionService")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local Style = require(CorePackages.Workspace.Packages.Style)
local useDesignTokens = Style.useDesignTokens
local Localization = require(CorePackages.Workspace.Packages.Localization)
local useLocalization = Localization.Hooks.useLocalization

local TopBar = script:FindFirstAncestor("TopBar")
local Analytics = require(TopBar.Analytics)
local default = Analytics.default

require(TopBar.TokenMappers.MenuNavigationPromptTokenMapper)

local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local v = {
	ButtonSelect = "CoreScripts.InGameMenu.Label.ViewButton",
	ButtonTouchpad = "CoreScripts.InGameMenu.Label.TouchpadButton",
	ButtonShare = "CoreScripts.InGameMenu.Label.ShareButton"
}

local function HeaderArea()
	local menuNavigationPrompt = useDesignTokens().LuaApps.MenuNavigationPrompt
	local typography = menuNavigationPrompt.Typography
	local color = menuNavigationPrompt.Color
	local space = menuNavigationPrompt.Space

	local v2 = useLocalization({
		HeaderText = "CoreScripts.InGameMenu.EducationalPopup.UINavigation.Title"
	})

	local createElement = React.createElement
	local v3 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		LayoutOrder = 0,
		BackgroundTransparency = 1
	}

	local createElement2 = React.createElement
	local v4 = {
		Text = v2.HeaderText,
		BackgroundTransparency = 1,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextColor3 = 0,
		Size = 0,
		AutomaticSize = 0,
		TextXAlignment = 0,
		TextYAlignment = 0
	}
	local font

	if not FoundationFontFaceMigration then
		font = typography.header.Font
	end

	v4.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(typography.header.Font)
	end

	v4.FontFace = fontFace
	v4.TextSize = typography.header.FontSize
	v4.TextColor3 = color.textColor.Color3
	v4.Size = UDim2.fromOffset(0, 0)
	v4.AutomaticSize = Enum.AutomaticSize.XY
	v4.TextXAlignment = Enum.TextXAlignment.Center
	v4.TextYAlignment = Enum.TextYAlignment.Center
	return createElement("Frame", v3, {
		Header = createElement2("TextLabel", v4),
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, space.titlePadding),
			PaddingBottom = UDim.new(0, space.titlePadding),
			PaddingLeft = UDim.new(0, space.bodyPadding),
			PaddingRight = UDim.new(0, space.bodyPadding)
		})
	})
end

local function GamepadImageArea()
	local menuNavigationPrompt = useDesignTokens().LuaApps.MenuNavigationPrompt
	local typography = menuNavigationPrompt.Typography
	local color = menuNavigationPrompt.Color
	local size = menuNavigationPrompt.Size
	local space = menuNavigationPrompt.Space

	local v2 = useLocalization({
		ButtonLabelText = v[UserInputService:GetStringForKeyCode(Enum.KeyCode.ButtonSelect)] or "CoreScripts.InGameMenu.Label.ViewButton"
	})

	local imageForKeyCode = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonSelect)

	local createElement = React.createElement
	local v3 = {
		BackgroundTransparency = 1,
		LayoutOrder = 0,
		AutomaticSize = Enum.AutomaticSize.XY
	}
	local children = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, space.iconPadding)
		}),
		ButtonLabelGroup = 0,
		ControllerImage = 0
	}

	local createElement2 = React.createElement
	local v4 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		LayoutOrder = 0
	}

	local v5 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, space.iconPadding)
		}),
		Icon = React.createElement("ImageLabel", {
			LayoutOrder = 0,
			BackgroundTransparency = 1,
			Image = imageForKeyCode,
			Size = UDim2.fromOffset(size.iconSize, size.iconSize)
		}),
		ControllerButtonLabel = 0
	}

	local createElement3 = React.createElement
	local v6 = {
		Text = v2.ButtonLabelText,
		LayoutOrder = 100,
		BackgroundTransparency = 1,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextColor3 = 0,
		Size = 0,
		AutomaticSize = 0,
		TextXAlignment = 0,
		TextYAlignment = 0
	}
	local font

	if not FoundationFontFaceMigration then
		font = typography.label.Font
	end

	v6.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(typography.label.Font)
	end

	v6.FontFace = fontFace
	v6.TextSize = typography.label.FontSize
	v6.TextColor3 = color.textColor.Color3
	v6.Size = UDim2.fromOffset(0, 0)
	v6.AutomaticSize = Enum.AutomaticSize.XY
	v6.TextXAlignment = Enum.TextXAlignment.Center
	v6.TextYAlignment = Enum.TextYAlignment.Center
	v5.ControllerButtonLabel = createElement3("TextLabel", v6)
	children.ButtonLabelGroup = createElement2("Frame", v4, v5)

	children.ControllerImage = React.createElement(
		"ImageLabel",
		{
			Image = "rbxasset://textures/ui/Gamepad/ControllerSelect.png",
			Size = UDim2.fromScale(1, 1),
			LayoutOrder = 100,
			BackgroundTransparency = 1
		},
		{
			UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
				AspectRatio = size.imageWidth / size.imageHeight
			}),
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(size.imageWidth, size.imageHeight),
				MinSize = Vector2.new(size.imageWidth * 0.5, size.imageHeight * 0.5)
			})
		}
	)
	return createElement("Frame", v3, children)
end

local function Body(p)
	local menuNavigationPrompt = useDesignTokens().LuaApps.MenuNavigationPrompt
	local typography = menuNavigationPrompt.Typography
	local color = menuNavigationPrompt.Color
	local size = menuNavigationPrompt.Size
	local space = menuNavigationPrompt.Space

	local _ = v[UserInputService:GetStringForKeyCode(Enum.KeyCode.ButtonSelect)]
		or "CoreScripts.InGameMenu.Label.ViewButton"

	local v2 = useLocalization({
		OkText = "CoreScripts.InGameMenu.Ok",
		Description = "CoreScripts.InGameMenu.EducationalPopup.UINavigation.Description"
	})

	local createElement = React.createElement
	local v3 = {
		LayoutOrder = 200,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1
	}

	local children = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, space.bodyPadding)
		}),
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, space.bodyPadding),
			PaddingRight = UDim.new(0, space.bodyPadding),
			PaddingTop = UDim.new(0, space.bodyPadding),
			PaddingBottom = UDim.new(0, space.bodyPadding)
		}),
		GamepadImageArea = React.createElement(GamepadImageArea),
		ImageDescription = 0,
		ConfirmationButton = 0
	}
	local createElement2 = React.createElement
	local v4 = {
		Text = v2.Description,
		LayoutOrder = 100,
		BackgroundTransparency = 1,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextColor3 = 0,
		TextWrapped = true,
		LineHeight = 0,
		Size = 0,
		AutomaticSize = 0,
		TextXAlignment = 0,
		TextYAlignment = 0
	}
	local font

	if not FoundationFontFaceMigration then
		font = typography.caption.Font
	end

	v4.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(typography.caption.Font)
	end

	v4.FontFace = fontFace
	v4.TextSize = typography.caption.FontSize
	v4.TextColor3 = color.textColor.Color3

	v4.LineHeight = typography.caption.LineHeight
	v4.Size = UDim2.new(1, 0, 0, 0)
	v4.AutomaticSize = Enum.AutomaticSize.Y
	v4.TextXAlignment = Enum.TextXAlignment.Left
	v4.TextYAlignment = Enum.TextYAlignment.Center
	children.ImageDescription = createElement2("TextLabel", v4)

	local createElement3 = React.createElement
	local v5 = {
		buttonType = ButtonType.PrimarySystem,
		layoutOrder = 200,
		size = UDim2.new(1, 0, 0, size.buttonHeight),
		text = v2.OkText,
		onActivated = p.onDismissed,
		icon = 0
	}
	local icon

	if p.selectButtonDismissesGamepadNavigationDialog then
		icon = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonSelect)
	end

	v5.icon = icon
	children.ConfirmationButton = createElement3(Button, v5)
	return createElement("Frame", v3, children)
end

local function GamepadNavigationDialog(p)
	local menuNavigationPrompt = useDesignTokens().LuaApps.MenuNavigationPrompt
	local color = menuNavigationPrompt.Color
	local size = menuNavigationPrompt.Size
	local space = menuNavigationPrompt.Space
	local radius = menuNavigationPrompt.Radius

	React.useEffect(function()
		default:onShowGamepadNavigationDialog()

		local function fn(_, p2, _)
			if p2 == Enum.UserInputState.End then
				p.onDismissed()
			end
		end

		local v2

		if p.selectButtonDismissesGamepadNavigationDialog then
			v2 = Enum.KeyCode.ButtonSelect
		else
			v2 = Enum.KeyCode.ButtonA
		end

		ContextActionService:BindCoreAction("ConfirmBindComponentMapperTokenModule", fn, false, v2)

		return function()
			default:onDismissGamepadNavigationDialog()
			ContextActionService:UnbindCoreAction("ConfirmBindComponentMapperTokenModule")
		end
	end)

	return React.createElement("Frame", {
		BackgroundColor3 = color.backgroundUiColor.Color3,
		BackgroundTransparency = color.backgroundUiColor.Transparency,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(size.promptWidth / size.displayWidth, 0),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	}, {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, radius.cornerRadius)
		}),
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		HeaderArea = React.createElement(HeaderArea),
		Separator = React.createElement("Frame", {
			LayoutOrder = 100,
			Size = UDim2.new(1, -2 * space.bodyPadding, 0, 1),
			BackgroundColor3 = color.separatorColor.Color3,
			BackgroundTransparency = color.separatorColor.Transparency,
			BorderSizePixel = 0
		}),
		Body = React.createElement(Body, p),
		UISizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(1e999, 1e999),
			MinSize = Vector2.new(size.imageWidth + 2 * space.bodyPadding, 1)
		})
	})
end

return GamepadNavigationDialog
