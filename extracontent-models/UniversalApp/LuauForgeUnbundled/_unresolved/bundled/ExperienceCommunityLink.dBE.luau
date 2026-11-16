local module = require("@luauforge/bundled/dBi")
local module2 = require("@luauforge/bundled/dBk")

local module3 = require("@luauforge/bundled/dBh")
require("@luauforge/bundled/dBl")

local useLocalization = require("@luauforge/bundled/dBB").Hooks.useLocalization
local useStyle = module2.Core.Style.useStyle

local styledTextLabel = module2.App.Text.StyledTextLabel

local function ExperienceCommunityLink(props)
	local v5 = useStyle()
	local v6 = useLocalization({
		CommunityTitle = "Feature.CommunityLinks.Heading.CommunityTitle"
	})

	return module.createElement(
		"Frame",
		{
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1
		},
		{
			UIListLayout = module.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 8)
			}),
			Title = module.createElement(styledTextLabel, {
				text = v6.CommunityTitle,
				size = UDim2.fromScale(1, 0),
				fontStyle = v5.Font.Header1,
				colorStyle = v5.Theme.TextEmphasis,
				automaticSize = Enum.AutomaticSize.Y,
				richText = false,
				fluidSizing = false,
				layoutOrder = 1
			}),
			Banner = module.createElement(module3, {
				size = UDim2.fromScale(1, 0),
				layoutOrder = 2,
				communityInfo = props.communityInfo,
				linkedEntityName = props.experienceName,
				universeId = props.universeId
			})
		}
	)
end

return ExperienceCommunityLink
