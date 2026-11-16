local MemStorageService = game:GetService("MemStorageService")
local UserInputService = game:GetService("UserInputService")
local parent = script:FindFirstAncestor("InputUi").Parent
local React = require(parent.React)

local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
require(script.Parent.GamepadDisconnectTokenMapper)

local engineFeature = game:GetEngineFeature("GamepadMessageKeyEngineFeature")

return function(p)
	local v = useDesignTokens()
	local color3 = v.Color.Content.Emphasis.Color3
	local transparency = v.Color.Content.Emphasis.Transparency

	local gamepadDisconnect = v.LuaApps.GamepadDisconnect
	local designWidth = gamepadDisconnect.designWidth
	local imageWidth = gamepadDisconnect.imageWidth
	local imageHeight = gamepadDisconnect.imageHeight
	local textContainerWidth = gamepadDisconnect.textContainerWidth
	local horizontalInnerPadding = gamepadDisconnect.horizontalInnerPadding
	local verticalPadding = gamepadDisconnect.verticalPadding
	local message

	if engineFeature then
		local item = MemStorageService:GetItem("GamepadDisconnectMessageKey")
		message = item == "" and "Feature.GamepadDisconnect.Label.MessageGeneric" or item
	else
		message = "Feature.GamepadDisconnect.Label.Message"
	end

	local v2 = useLocalization({
		title = "Feature.GamepadDisconnect.Label.Title",
		message = message
	})

	local text = string.format(v2.message, p.username, UserInputService:GetStringForKeyCode(Enum.KeyCode.A))

	local createElement = React.createElement
	local v3 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Active = true
	}

	local createElement2 = React.createElement
	local v4 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, 0, 1, -verticalPadding * 2),
		BackgroundTransparency = v.Color.OverMedia.OverMedia_0.Transparency,
		BackgroundColor3 = v.Color.OverMedia.OverMedia_0.Color3,
		BorderSizePixel = 0
	}

	local createElement3 = React.createElement
	local v5 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, 0, 0, imageHeight),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local v6 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(horizontalInnerPadding / designWidth, 0)
		}),
		ControllerImage = React.createElement("ImageLabel", {
			Image = "rbxasset://textures/ui/Gamepad/Controller.png",
			Size = UDim2.new(imageWidth / designWidth, 0, 0, imageHeight),
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			ScaleType = Enum.ScaleType.Fit
		}, {
			UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
				AspectRatio = imageWidth / imageHeight
			}),
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(imageWidth, imageHeight),
				MinSize = Vector2.new(imageWidth * 0.5, imageHeight * 0.5)
			})
		}),
		TextContainer = 0
	}

	local createElement4 = React.createElement
	local v7 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(textContainerWidth / designWidth, 0, 0, imageHeight),
		BackgroundTransparency = 1,
		LayoutOrder = 2
	}

	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v.Size.Size_800)
		}),
		TitleRow = 0,
		Message = 0
	}

	local createElement5 = React.createElement
	local v8 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}

	local v9 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(24 / textContainerWidth, 0)
		}),
		Icon = React.createElement(ImageSetLabel, {
			Image = Images["icons/menu/about_large"],
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.fromOffset(v.Size.Size_1200, v.Size.Size_1200)
		}),
		Title = 0
	}

	local createElement6 = React.createElement
	local v10 = {
		Text = v2.title,
		BackgroundTransparency = 1,
		TextColor3 = color3,
		TextTransparency = transparency,
		TextSize = v.Typography.HeadingLarge.FontSize,
		Font = 0,
		FontFace = 0,
		LayoutOrder = 2,
		TextXAlignment = 0
	}
	local font

	if not FoundationFontFaceMigration then
		font = v.Typography.HeadingLarge.Font
	end

	v10.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v.Typography.HeadingLarge.Font)
	end

	v10.FontFace = fontFace

	v10.TextXAlignment = Enum.TextXAlignment.Left
	v9.Title = createElement6("TextLabel", v10)
	children.TitleRow = createElement5("Frame", v8, v9)

	local createElement7 = React.createElement
	local v11 = {
		Text = text,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.fromOffset(0, 0),
		BackgroundTransparency = 1,
		TextColor3 = color3,
		TextTransparency = transparency,
		TextSize = v.Typography.TitleLarge.FontSize,
		Font = 0,
		FontFace = 0,
		LayoutOrder = 2,
		TextWrapped = true,
		TextXAlignment = 0
	}
	local font2

	if not FoundationFontFaceMigration then
		font2 = v.Typography.TitleLarge.Font
	end

	v11.Font = font2
	local fontFace2

	if FoundationFontFaceMigration then
		fontFace2 = normalizeFontFace(v.Typography.TitleLarge.Font)
	end

	v11.FontFace = fontFace2

	v11.TextXAlignment = Enum.TextXAlignment.Left
	children.Message = createElement7("TextLabel", v11)
	v6.TextContainer = createElement4("Frame", v7, children)
	return createElement("Frame", v3, {
		Modal = createElement2("Frame", v4, {
			Content = createElement3("Frame", v5, v6)
		})
	})
end
