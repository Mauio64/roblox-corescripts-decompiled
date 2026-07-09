local ParentParent = script.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local Localization = require(ParentParent.Localization)
local RobloxAppHooks = require(ParentParent.RobloxAppHooks)
local UIBlox = require(ParentParent.UIBlox)
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useLocalization = Localization.Hooks.useLocalization
local useScreenSize = RobloxAppHooks.useScreenSize
local useStyle = UIBlox.Core.Style.useStyle

return function(t1: {[any]: any}) -- line: 20
	-- upvalues: useScreenSize (copy), useStyle (copy), useLocalization (copy), React (copy), StyledTextLabel (copy)
	local v11 = useScreenSize()
	local v12 = useStyle()
	local v13 = useLocalization({
		postsNotFound = "Feature.ContentFeed.Body.PostsNotFound"
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		LayoutOrder = t1.layoutOrder,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, 0, 0, v11.Y)
	}, {
		NotFoundMessage = React.createElement(StyledTextLabel, {
			fluidSizing = false,
			layoutOrder = 1,
			fontStyle = v12.Font.Header1,
			colorStyle = v12.Theme.TextEmphasis,
			size = UDim2.fromScale(1, 1),
			text = v13.postsNotFound,
			textTruncate = Enum.TextTruncate.AtEnd,
			textXAlignment = Enum.TextXAlignment.Center,
			textYAlignment = Enum.TextYAlignment.Center
		})
	})
end
