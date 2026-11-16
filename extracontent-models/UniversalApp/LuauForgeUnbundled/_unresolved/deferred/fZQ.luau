local module = require("@luauforge/deferred/fZR")
local module2 = require("@luauforge/deferred/fZS")

local retrievalStatus = module2.App.Loading.Enum.RetrievalStatus
local styledTextLabel = module2.App.Text.StyledTextLabel
local useStyle = module2.Core.Style.useStyle

local useDesignTokens = require("@luauforge/deferred/fZT").useDesignTokens

return module.memo(function(props)
	local v5 = useStyle()
	local v6 = useDesignTokens()
	local bodyLarge = v6.Typography.BodyLarge or {}
	local headingSmall = v6.Typography.HeadingSmall or {}

	local v7 = props.dataStatus == retrievalStatus.Done
	local v8 = props.descriptionText and #props.descriptionText > 0

	if v7 and v8 then
		return module.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = props.LayoutOrder
			},
			{
				UIListLayout = module.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, props.listPadding or 16)
				}),
				Title = module.createElement(styledTextLabel, {
					text = props.titleText,
					size = UDim2.fromScale(1, 0),
					fontStyle = headingSmall,
					colorStyle = v5.Theme.TextEmphasis,
					automaticSize = Enum.AutomaticSize.Y,
					richText = false,
					fluidSizing = false
				}),
				Description = module.createElement(styledTextLabel, {
					text = props.descriptionText,
					size = UDim2.new(1, 0, 0, 0),
					textYAlignment = Enum.TextYAlignment.Top,
					fontStyle = bodyLarge,
					colorStyle = v5.Theme.TextDefault,
					automaticSize = Enum.AutomaticSize.Y,
					lineHeight = bodyLarge.LineHeight,
					richText = false,
					fluidSizing = false
				})
			}
		)
	end

	return nil
end)
