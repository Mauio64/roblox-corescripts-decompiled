local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
game:GetService("LocalizationService")
local ContextActionService = game:GetService("ContextActionService")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
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

	return React.createElement(
		"Frame",
		{ AutomaticSize = Enum.AutomaticSize.XY, LayoutOrder = 0, BackgroundTransparency = 1 },
		{
			Header = React.createElement("TextLabel", {
				Text = v2.HeaderText,
				BackgroundTransparency = 1,
				FontFace = normalizeFontFace(typography.header.Font),
				TextSize = typography.header.FontSize,
				TextColor3 = color.textColor.Color3,
				Size = UDim2.fromOffset(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center
			}),
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, space.titlePadding),
				PaddingBottom = UDim.new(0, space.titlePadding),
				PaddingLeft = UDim.new(0, space.bodyPadding),
				PaddingRight = UDim.new(0, space.bodyPadding)
			})
		}
	)
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

	return React.createElement(
		"Frame",
		{ BackgroundTransparency = 1, LayoutOrder = 0, AutomaticSize = Enum.AutomaticSize.XY },
		{
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, space.iconPadding)
			}),
			ButtonLabelGroup = React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					LayoutOrder = 0
				},
				{
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
					ControllerButtonLabel = React.createElement("TextLabel", {
						Text = v2.ButtonLabelText,
						LayoutOrder = 100,
						BackgroundTransparency = 1,
						FontFace = normalizeFontFace(typography.label.Font),
						TextSize = typography.label.FontSize,
						TextColor3 = color.textColor.Color3,
						Size = UDim2.fromOffset(0, 0),
						AutomaticSize = Enum.AutomaticSize.XY,
						TextXAlignment = Enum.TextXAlignment.Center,
						TextYAlignment = Enum.TextYAlignment.Center
					})
				}
			),
			ControllerImage = React.createElement(
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
		}
	)
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

	local v4 = {
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
		ImageDescription = React.createElement("TextLabel", {
			Text = v2.Description,
			LayoutOrder = 100,
			BackgroundTransparency = 1,
			FontFace = normalizeFontFace(typography.caption.Font),
			TextSize = typography.caption.FontSize,
			TextColor3 = color.textColor.Color3,
			TextWrapped = true,
			LineHeight = typography.caption.LineHeight,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center
		}),
		ConfirmationButton = 0
	}

	local createElement2 = React.createElement
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
	v4.ConfirmationButton = createElement2(Button, v5)
	return createElement("Frame", v3, v4)
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
