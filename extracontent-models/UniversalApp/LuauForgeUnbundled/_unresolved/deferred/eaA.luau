local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/React")

local module2 = require("@luauforge/deferred/eau")
local module3 = require("@luauforge/deferred/eal")
local module4 = require("@luauforge/deferred/ear")

local styledTextLabel = module4.App.Text.StyledTextLabel

local useLocalization = module2.Hooks.useLocalization
local useScreenSize = module3.useScreenSize
local useStyle = module4.Core.Style.useStyle

return function(p2)
	local v5 = useScreenSize()
	local v6 = useStyle()

	local v7 = useLocalization({
		postsNotFound = "Feature.ContentFeed.Body.PostsNotFound"
	})

	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		LayoutOrder = p2.layoutOrder,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, 0, 0, v5.Y)
	}, {
		NotFoundMessage = React.createElement(styledTextLabel, {
			fluidSizing = false,
			fontStyle = v6.Font.Header1,
			colorStyle = v6.Theme.TextEmphasis,
			layoutOrder = 1,
			size = UDim2.fromScale(1, 1),
			text = v7.postsNotFound,
			textTruncate = Enum.TextTruncate.AtEnd,
			textXAlignment = Enum.TextXAlignment.Center,
			textYAlignment = Enum.TextYAlignment.Center
		})
	})
end
