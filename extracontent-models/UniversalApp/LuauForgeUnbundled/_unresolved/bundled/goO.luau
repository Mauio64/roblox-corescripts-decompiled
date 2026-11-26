local module = require("@luauforge/bundled/gnx")
local module2 = require("@luauforge/bundled/gnz")

local useDesignTokens = require("@luauforge/bundled/gox").useDesignTokens
local getStandardSizeAvatarHeadShotRbxthumb = require("@luauforge/bundled/goP").Utils.getStandardSizeAvatarHeadShotRbxthumb

local loadableImage = module2.App.Loading.LoadableImage

local module3 = require("@luauforge/bundled/goz")

local text = module3.Text
local useTokens = module3.Hooks.useTokens

return function(props)
	local v5 = useTokens()
	local v6 = useDesignTokens()

	return module.createElement(
		"Frame",
		{
			LayoutOrder = props.LayoutOrder,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		},
		{
			VerticalLayout = module.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, v6.Size.Size_50)
			}),
			AvatarImage = module.createElement(loadableImage, {
				LayoutOrder = 1,
				Size = UDim2.new(0, 96, 0, 96),
				Image = getStandardSizeAvatarHeadShotRbxthumb(props.userId),
				useShimmerAnimationWhileLoading = true,
				cornerRadius = UDim.new(0.5, 0),
				shouldHandleReloads = true
			}),
			AvatarImageSpacing = module.createElement("Frame", {
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, v5.Size.Size_400),
				BackgroundTransparency = 1
			}),
			DisplayName = module.createElement(text, {
				Text = props.displayName,
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				fontStyle = v5.Typography.HeadingSmall,
				textStyle = v5.Color.Content.Emphasis,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center
			}),
			Username = module.createElement(text, {
				Text = `@{props.username}`,
				LayoutOrder = 4,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				fontStyle = v5.Typography.BodyMedium,
				textStyle = v5.Color.Content.Default,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center
			})
		}
	)
end
