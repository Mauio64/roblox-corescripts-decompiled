local MemStorageService = game:GetService("MemStorageService")
local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/React")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/UIBlox")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/Foundation").Utility.normalizeFontFace

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

	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Active = true
	}, {
		Modal = React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, 0, 1, -verticalPadding * 2),
			BackgroundTransparency = v5.Color.OverMedia.OverMedia_0.Transparency,
			BackgroundColor3 = v5.Color.OverMedia.OverMedia_0.Color3,
			BorderSizePixel = 0
		}, {
			Content = React.createElement("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(1, 0, 0, imageHeight),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}, {
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
				TextContainer = React.createElement("Frame", {
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(textContainerWidth / designWidth, 0, 0, imageHeight),
					BackgroundTransparency = 1,
					LayoutOrder = 2
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, v5.Size.Size_800)
					}),
					TitleRow = React.createElement(
						"Frame",
						{
							AutomaticSize = Enum.AutomaticSize.Y,
							Size = UDim2.fromScale(1, 0),
							BackgroundTransparency = 1,
							LayoutOrder = 1
						},
						{
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
							Title = React.createElement("TextLabel", {
								Text = v7.title,
								BackgroundTransparency = 1,
								TextColor3 = color3,
								TextTransparency = transparency,
								TextSize = v5.Typography.HeadingLarge.FontSize,
								FontFace = normalizeFontFace(v5.Typography.HeadingLarge.Font),
								LayoutOrder = 2,
								TextXAlignment = Enum.TextXAlignment.Left
							})
						}
					),
					Message = React.createElement("TextLabel", {
						Text = v8,
						AutomaticSize = Enum.AutomaticSize.XY,
						Size = UDim2.fromOffset(0, 0),
						BackgroundTransparency = 1,
						TextColor3 = color3,
						TextTransparency = transparency,
						TextSize = v5.Typography.TitleLarge.FontSize,
						FontFace = normalizeFontFace(v5.Typography.TitleLarge.Font),
						LayoutOrder = 2,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left
					})
				})
			})
		})
	})
end
