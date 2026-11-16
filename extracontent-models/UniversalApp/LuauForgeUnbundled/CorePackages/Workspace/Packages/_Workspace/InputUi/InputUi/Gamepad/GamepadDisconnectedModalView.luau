local MemStorageService = game:GetService("MemStorageService")
local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/React")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/Localization").Hooks.useLocalization
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/Style").useDesignTokens
require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/InputUi/Gamepad/GamepadDisconnectTokenMapper")

local engineFeature = game:GetEngineFeature("GamepadMessageKeyEngineFeature")

return function(p2)
	local v5 = useDesignTokens()
	local color3 = v5.Color.Content.Emphasis.Color3
	local transparency = v5.Color.Content.Emphasis.Transparency

	local gamepadDisconnect = v5.LuaApps.GamepadDisconnect
	local designWidth = gamepadDisconnect.designWidth
	local imageWidth = gamepadDisconnect.imageWidth
	local imageHeight = gamepadDisconnect.imageHeight
	local textContainerWidth = gamepadDisconnect.textContainerWidth
	local horizontalInnerPadding = gamepadDisconnect.horizontalInnerPadding
	local verticalPadding = gamepadDisconnect.verticalPadding
	local v6

	if engineFeature then
		local item = MemStorageService:GetItem("GamepadDisconnectMessageKey")
		v6 = item == "" and "Feature.GamepadDisconnect.Label.MessageGeneric" or item
	else
		v6 = "Feature.GamepadDisconnect.Label.Message"
	end

	local v7 = useLocalization({
		title = "Feature.GamepadDisconnect.Label.Title",
		message = v6
	})

	local v8 = string.format(v7.message, p2.username, UserInputService:GetStringForKeyCode(Enum.KeyCode.A))

	local createElement = React.createElement
	local v10 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Active = true
	}

	local createElement2 = React.createElement
	local v13 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, 0, 1, -verticalPadding * 2),
		BackgroundTransparency = v5.Color.OverMedia.OverMedia_0.Transparency,
		BackgroundColor3 = v5.Color.OverMedia.OverMedia_0.Color3,
		BorderSizePixel = 0
	}

	local createElement3 = React.createElement
	local v16 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, 0, 0, imageHeight),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local v17 = {
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
	local v19 = {
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
			Padding = UDim.new(0, v5.Size.Size_800)
		}),
		TitleRow = 0,
		Message = 0
	}

	local createElement5 = React.createElement
	local v21 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}

	local v22 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(24 / textContainerWidth, 0)
		}),
		Icon = React.createElement(imageSetLabel, {
			Image = images["icons/menu/about_large"],
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.fromOffset(v5.Size.Size_1200, v5.Size.Size_1200)
		}),
		Title = 0
	}

	local createElement6 = React.createElement
	local v24 = {
		Text = v7.title,
		BackgroundTransparency = 1,
		TextColor3 = color3,
		TextTransparency = transparency,
		TextSize = v5.Typography.HeadingLarge.FontSize,
		Font = 0,
		FontFace = 0,
		LayoutOrder = 2,
		TextXAlignment = 0
	}

	local v25 = if not foundationFontFaceMigration then v5.Typography.HeadingLarge.Font else nil
	v24.Font = v25

	local v26 = if foundationFontFaceMigration then normalizeFontFace(v5.Typography.HeadingLarge.Font) else nil
	v24.FontFace = v26

	v24.TextXAlignment = Enum.TextXAlignment.Left
	v22.Title = createElement6("TextLabel", v24)
	children.TitleRow = createElement5("Frame", v21, v22)

	local createElement7 = React.createElement
	local v28 = {
		Text = v8,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.fromOffset(0, 0),
		BackgroundTransparency = 1,
		TextColor3 = color3,
		TextTransparency = transparency,
		TextSize = v5.Typography.TitleLarge.FontSize,
		Font = 0,
		FontFace = 0,
		LayoutOrder = 2,
		TextWrapped = true,
		TextXAlignment = 0
	}
	local v29 = if not foundationFontFaceMigration then v5.Typography.TitleLarge.Font else nil
	v28.Font = v29

	local v30 = if foundationFontFaceMigration then normalizeFontFace(v5.Typography.TitleLarge.Font) else nil
	v28.FontFace = v30

	v28.TextXAlignment = Enum.TextXAlignment.Left
	children.Message = createElement7("TextLabel", v28)
	v17.TextContainer = createElement4("Frame", v19, children)
	return createElement("Frame", v10, {
		Modal = createElement2("Frame", v13, {
			Content = createElement3("Frame", v16, v17)
		})
	})
end
