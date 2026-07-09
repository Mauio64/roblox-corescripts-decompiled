local Parent = script:FindFirstAncestor("AccountRecovery").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local useDesignTokens = require(Parent.Style).useDesignTokens
local getStandardSizeAvatarHeadShotRbxthumb = require(Parent.UserLib).Utils.getStandardSizeAvatarHeadShotRbxthumb
local LoadableImage = UIBlox.App.Loading.LoadableImage
local Foundation = require(Parent.Foundation)
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

return function(t1: {[any]: any}) -- line: 26
	-- upvalues: useTokens (copy), useDesignTokens (copy), React (copy), LoadableImage (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), FoundationText (copy)
	local v11 = useTokens()
	local v12 = useDesignTokens()

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t1.LayoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}, {
		VerticalLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, v12.Size.Size_50)
		}),
		AvatarImage = React.createElement(LoadableImage, {
			LayoutOrder = 1,
			useShimmerAnimationWhileLoading = true,
			shouldHandleReloads = true,
			Size = UDim2.new(0, 96, 0, 96),
			Image = getStandardSizeAvatarHeadShotRbxthumb(t1.userId),
			cornerRadius = UDim.new(0.5, 0)
		}),
		AvatarImageSpacing = React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v11.Size.Size_400)
		}),
		DisplayName = React.createElement(FoundationText, {
			LayoutOrder = 3,
			Text = t1.displayName,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			fontStyle = v11.Typography.HeadingSmall,
			textStyle = v11.Color.Content.Emphasis,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		}),
		Username = React.createElement(FoundationText, {
			LayoutOrder = 4,
			Text = `@{ t1.username }`,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			fontStyle = v11.Typography.BodyMedium,
			textStyle = v11.Color.Content.Default,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		})
	})
end
