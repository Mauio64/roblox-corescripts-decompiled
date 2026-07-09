local MemStorageService = game:GetService("MemStorageService")
local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("InputUi").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useDesignTokens = require(Parent.Style).useDesignTokens

require(script.Parent.GamepadDisconnectTokenMapper)

local EngineFeature = game:GetEngineFeature("GamepadMessageKeyEngineFeature")

return function(p1) -- line: 23
	-- upvalues: useDesignTokens (copy), EngineFeature (copy), MemStorageService (copy), useLocalization (copy), UserInputService (copy), React (copy), ImageSetLabel (copy), Images (copy)
	local v12 = useDesignTokens()
	local EmphasisColor3 = v12.Color.Content.Emphasis.Color3
	local EmphasisTransparency = v12.Color.Content.Emphasis.Transparency
	local GamepadDisconnect = v12.LuaApps.GamepadDisconnect
	local designWidth = GamepadDisconnect.designWidth
	local imageWidth = GamepadDisconnect.imageWidth
	local imageHeight = GamepadDisconnect.imageHeight
	local textContainerWidth = GamepadDisconnect.textContainerWidth
	local horizontalInnerPadding = GamepadDisconnect.horizontalInnerPadding
	local verticalPadding = GamepadDisconnect.verticalPadding
	local Item

	if EngineFeature then
		Item = MemStorageService:GetItem("GamepadDisconnectMessageKey")

		if Item == "" then
			Item = "Feature.GamepadDisconnect.Label.MessageGeneric"
		end
	else
		Item = "Feature.GamepadDisconnect.Label.Message"
	end

	local v23 = useLocalization({
		title = "Feature.GamepadDisconnect.Label.Title",
		message = Item
	})
	local v24 = string.format(v23.message, p1.username, UserInputService:GetStringForKeyCode(Enum.KeyCode.A))

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Active = true,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		Modal = React.createElement("Frame", {
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, 0, 1, -verticalPadding * 2),
			BackgroundTransparency = v12.Color.OverMedia.OverMedia_0.Transparency,
			BackgroundColor3 = v12.Color.OverMedia.OverMedia_0.Color3
		}, {
			Content = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(1, 0, 0, imageHeight)
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
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(imageWidth / designWidth, 0, 0, imageHeight),
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
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(textContainerWidth / designWidth, 0, 0, imageHeight)
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, v12.Size.Size_800)
					}),
					TitleRow = React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.fromScale(1, 0)
					}, {
						UIListLayout = React.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							SortOrder = Enum.SortOrder.LayoutOrder,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							Padding = UDim.new(24 / textContainerWidth, 0)
						}),
						Icon = React.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							LayoutOrder = 1,
							Image = Images["icons/menu/about_large"],
							Size = UDim2.fromOffset(v12.Size.Size_1200, v12.Size.Size_1200)
						}),
						Title = React.createElement("TextLabel", {
							BackgroundTransparency = 1,
							LayoutOrder = 2,
							Text = v23.title,
							TextColor3 = EmphasisColor3,
							TextTransparency = EmphasisTransparency,
							TextSize = v12.Typography.HeadingLarge.FontSize,
							Font = v12.Typography.HeadingLarge.Font,
							TextXAlignment = Enum.TextXAlignment.Left
						})
					}),
					Message = React.createElement("TextLabel", {
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						TextWrapped = true,
						Text = v24,
						AutomaticSize = Enum.AutomaticSize.XY,
						Size = UDim2.fromOffset(0, 0),
						TextColor3 = EmphasisColor3,
						TextTransparency = EmphasisTransparency,
						TextSize = v12.Typography.TitleLarge.FontSize,
						Font = v12.Typography.TitleLarge.Font,
						TextXAlignment = Enum.TextXAlignment.Left
					})
				})
			})
		})
	})
end
