local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

game:GetService("LocalizationService")

local ContextActionService = game:GetService("ContextActionService")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local TopBar = script:FindFirstAncestor("TopBar")
local default = require(TopBar.Analytics).default

require(TopBar.TokenMappers.MenuNavigationPromptTokenMapper)

local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local t1 = {
	ButtonSelect = "CoreScripts.InGameMenu.Label.ViewButton",
	ButtonTouchpad = "CoreScripts.InGameMenu.Label.TouchpadButton",
	ButtonShare = "CoreScripts.InGameMenu.Label.ShareButton"
}

local function HeaderArea() -- line: 42
	-- upvalues: useDesignTokens (copy), useLocalization (copy), React (copy)
	local MenuNavigationPrompt = useDesignTokens().LuaApps.MenuNavigationPrompt
	local Typography = MenuNavigationPrompt.Typography
	local MenuNavigationPromptColor = MenuNavigationPrompt.Color
	local Space = MenuNavigationPrompt.Space
	local v21 = useLocalization({
		HeaderText = "CoreScripts.InGameMenu.EducationalPopup.UINavigation.Title"
	})

	return React.createElement("Frame", {
		LayoutOrder = 0,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY
	}, {
		Header = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = v21.HeaderText,
			Font = Typography.header.Font,
			TextSize = Typography.header.FontSize,
			TextColor3 = MenuNavigationPromptColor.textColor.Color3,
			Size = UDim2.fromOffset(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		}),
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, Space.titlePadding),
			PaddingBottom = UDim.new(0, Space.titlePadding),
			PaddingLeft = UDim.new(0, Space.bodyPadding),
			PaddingRight = UDim.new(0, Space.bodyPadding)
		})
	})
end
local function GamepadImageArea() -- line: 78
	-- upvalues: useDesignTokens (copy), UserInputService (copy), t1 (copy), useLocalization (copy), React (copy)
	local MenuNavigationPrompt = useDesignTokens().LuaApps.MenuNavigationPrompt
	local Typography = MenuNavigationPrompt.Typography
	local MenuNavigationPromptColor = MenuNavigationPrompt.Color
	local MenuNavigationPromptSize = MenuNavigationPrompt.Size
	local Space = MenuNavigationPrompt.Space
	local v27 = t1[UserInputService:GetStringForKeyCode(Enum.KeyCode.ButtonSelect)] or "CoreScripts.InGameMenu.Label.ViewButton"
	local v28 = useLocalization({
		ButtonLabelText = v27
	})
	local ImageForKeyCode = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonSelect)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 0,
		AutomaticSize = Enum.AutomaticSize.XY
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, Space.iconPadding)
		}),
		ButtonLabelGroup = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 0,
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, Space.iconPadding)
			}),
			Icon = React.createElement("ImageLabel", {
				LayoutOrder = 0,
				BackgroundTransparency = 1,
				Image = ImageForKeyCode,
				Size = UDim2.fromOffset(MenuNavigationPromptSize.iconSize, MenuNavigationPromptSize.iconSize)
			}),
			ControllerButtonLabel = React.createElement("TextLabel", {
				LayoutOrder = 100,
				BackgroundTransparency = 1,
				Text = v28.ButtonLabelText,
				Font = Typography.label.Font,
				TextSize = Typography.label.FontSize,
				TextColor3 = MenuNavigationPromptColor.textColor.Color3,
				Size = UDim2.fromOffset(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center
			})
		}),
		ControllerImage = React.createElement("ImageLabel", {
			Image = "rbxasset://textures/ui/Gamepad/ControllerSelect.png",
			LayoutOrder = 100,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1)
		}, {
			UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
				AspectRatio = MenuNavigationPromptSize.imageWidth / MenuNavigationPromptSize.imageHeight
			}),
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(MenuNavigationPromptSize.imageWidth, MenuNavigationPromptSize.imageHeight),
				MinSize = Vector2.new(MenuNavigationPromptSize.imageWidth * 0.5, MenuNavigationPromptSize.imageHeight * 0.5)
			})
		})
	})
end
local function Body(t2: {[any]: any}) -- line: 154
	-- upvalues: useDesignTokens (copy), UserInputService (copy), t1 (copy), useLocalization (copy), React (copy), GamepadImageArea (copy), Button (copy), ButtonType (copy)
	local MenuNavigationPrompt = useDesignTokens().LuaApps.MenuNavigationPrompt
	local Typography = MenuNavigationPrompt.Typography
	local MenuNavigationPromptColor = MenuNavigationPrompt.Color
	local MenuNavigationPromptSize = MenuNavigationPrompt.Size
	local Space = MenuNavigationPrompt.Space
	local _ = t1[UserInputService:GetStringForKeyCode(Enum.KeyCode.ButtonSelect)] or "CoreScripts.InGameMenu.Label.ViewButton"
	local v37 = useLocalization({
		OkText = "CoreScripts.InGameMenu.Ok",
		Description = "CoreScripts.InGameMenu.EducationalPopup.UINavigation.Description"
	})

	return React.createElement("Frame", {
		LayoutOrder = 200,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, Space.bodyPadding)
		}),
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, Space.bodyPadding),
			PaddingRight = UDim.new(0, Space.bodyPadding),
			PaddingTop = UDim.new(0, Space.bodyPadding),
			PaddingBottom = UDim.new(0, Space.bodyPadding)
		}),
		GamepadImageArea = React.createElement(GamepadImageArea),
		ImageDescription = React.createElement("TextLabel", {
			LayoutOrder = 100,
			BackgroundTransparency = 1,
			TextWrapped = true,
			Text = v37.Description,
			Font = Typography.caption.Font,
			TextSize = Typography.caption.FontSize,
			TextColor3 = MenuNavigationPromptColor.textColor.Color3,
			LineHeight = Typography.caption.LineHeight,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center
		}),
		ConfirmationButton = React.createElement(Button, {
			layoutOrder = 200,
			buttonType = ButtonType.PrimarySystem,
			size = UDim2.new(1, 0, 0, MenuNavigationPromptSize.buttonHeight),
			text = v37.OkText,
			onActivated = t2.onDismissed,
			icon = if not t2.selectButtonDismissesGamepadNavigationDialog then nil else UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonSelect)
		})
	})
end
local function GamepadNavigationDialog(t3: {[any]: any}) -- line: 216
	-- upvalues: useDesignTokens (copy), React (copy), default (copy), ContextActionService (copy), HeaderArea (copy), Body (copy)
	local MenuNavigationPrompt = useDesignTokens().LuaApps.MenuNavigationPrompt
	local MenuNavigationPromptColor = MenuNavigationPrompt.Color
	local MenuNavigationPromptSize = MenuNavigationPrompt.Size
	local Space = MenuNavigationPrompt.Space
	local MenuNavigationPromptRadius = MenuNavigationPrompt.Radius

	React.useEffect(function() -- line: 224
		-- upvalues: default (copy), ContextActionService (copy), t3 (copy)
		default:onShowGamepadNavigationDialog()
		ContextActionService:BindCoreAction("ConfirmBindComponentMapperTokenModule", function(_, p2, _) -- line: 228
			-- upvalues: t3 (copy)
			if p2 == Enum.UserInputState.End then
				t3.onDismissed()
			end
		end, false, if not t3.selectButtonDismissesGamepadNavigationDialog then Enum.KeyCode.ButtonA else Enum.KeyCode.ButtonSelect)

		return function() -- line: 239
			-- upvalues: default (copy), ContextActionService (copy)
			default:onDismissGamepadNavigationDialog()
			ContextActionService:UnbindCoreAction("ConfirmBindComponentMapperTokenModule")
		end
	end)

	return React.createElement("Frame", {
		BackgroundColor3 = MenuNavigationPromptColor.backgroundUiColor.Color3,
		BackgroundTransparency = MenuNavigationPromptColor.backgroundUiColor.Transparency,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(MenuNavigationPromptSize.promptWidth / MenuNavigationPromptSize.displayWidth, 0),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	}, {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, MenuNavigationPromptRadius.cornerRadius)
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
			BorderSizePixel = 0,
			Size = UDim2.new(1, -2 * Space.bodyPadding, 0, 1),
			BackgroundColor3 = MenuNavigationPromptColor.separatorColor.Color3,
			BackgroundTransparency = MenuNavigationPromptColor.separatorColor.Transparency
		}),
		Body = React.createElement(Body, t3),
		UISizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(1e999, 1e999),
			MinSize = Vector2.new(MenuNavigationPromptSize.imageWidth + 2 * Space.bodyPadding, 1)
		})
	})
end

return GamepadNavigationDialog
