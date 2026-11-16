local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent

local Roact = require(parent4.Roact)
local t = require(parent4.t)
local ImageSetComponent = require(parent3.Core.ImageSet.ImageSetComponent)
local Label = ImageSetComponent.Label
local Cryo = require(parent4.Cryo)

require(parent2.Style.StyleTypes)
local validateColorInfo = require(parent3.Core.Style.Validator.validateColorInfo)

local Images = require(parent2.ImageSet.Images)
local IconButton = require(parent2.Button.IconButton)
local getIconSize = require(parent2.ImageSet.getIconSize)
local IconSize = require(parent2.ImageSet.Enum.IconSize)
local GenericTextLabel = require(parent3.Core.Text.GenericTextLabel.GenericTextLabel)
local withStyle = require(parent3.Core.Style.withStyle)
local VoteStates = require(parent.Enum.VoteStates)

local iconsstatusgamesrating_large = Images["icons/status/games/rating_large"]
local iconsactionsvotevoteDownOff = Images["icons/actions/vote/voteDownOff"]
local iconsactionsvotevoteDownOn = Images["icons/actions/vote/voteDownOn"]
local iconsactionsvotevoteUpOff = Images["icons/actions/vote/voteUpOff"]
local iconsactionsvotevoteUpOn = Images["icons/actions/vote/voteUpOn"]

local v = {
	containerSpacingTop = 12,
	containerSpacingTrailing = 12,
	containerSpacingBottom = 12,
	containerSpacingLeading = 12,
	containerBorderRadius = 8,
	containerGap = 12,
	statWidgetContainerGap = 12,
	statWidgetIconSize = getIconSize(IconSize.Large),
	statWidgetDataGap = 0,
	buttonGroupGap = 12,
	buttonSize = 44,
	buttonIconSizeEnum = IconSize.Medium
}

local extended = Roact.PureComponent:extend("RateCount")

extended.validateProps = t.strictInterface({
	position = t.optional(t.UDim2),
	layoutOrder = t.optional(t.integer),
	anchorPoint = t.optional(t.Vector2),
	width = t.optional(t.integer),
	height = t.optional(t.integer),
	rateText = t.optional(t.string),
	rateLabel = t.optional(t.string),
	voteState = t.optional(VoteStates.isEnumValue),
	onVoteDownActivated = t.optional(t.callback),
	onVoteUpActivated = t.optional(t.callback),
	styleProps = t.optional(t.strictInterface({
		containerSpacingTop = t.optional(t.integer),
		containerSpacingTrailing = t.optional(t.integer),
		containerSpacingBottom = t.optional(t.integer),
		containerSpacingLeading = t.optional(t.integer),
		containerBorderRadius = t.optional(t.integer),
		containerBackgroundColor = t.optional(validateColorInfo),
		containerGap = t.optional(t.integer),
		statWidgetContainerGap = t.optional(t.integer),
		statWidgetIconSize = t.optional(t.integer),
		statWidgetIconContentColor = t.optional(validateColorInfo),
		statWidgetDataGap = t.optional(t.integer),
		statWidgetDataContentColor = t.optional(validateColorInfo),
		statWidgetDataLabelContentColor = t.optional(validateColorInfo),
		buttonGroupGap = t.optional(t.integer),
		buttonSize = t.optional(t.integer),
		buttonIconSizeEnum = t.optional(IconSize.isEnumValue)
	}))
})

extended.defaultProps = {
	height = 72,
	rateText = "",
	rateLabel = "",
	voteState = VoteStates.notVoted
}

function extended:init()
	function self.onVoteDownActivated()
		local onVoteDownActivated = self.props.onVoteDownActivated

		if onVoteDownActivated then
			onVoteDownActivated()
		end
	end

	function self.onVoteUpActivated()
		local onVoteUpActivated = self.props.onVoteUpActivated

		if onVoteUpActivated then
			onVoteUpActivated()
		end
	end
end

function extended.render(data)
	local position = data.props.position
	local layoutOrder = data.props.layoutOrder
	local anchorPoint = data.props.anchorPoint

	local width = data.props.width
	local height = data.props.height
	local udim

	if width then
		udim = UDim2.new(0, width, 0, height)
	else
		udim = UDim2.new(1, 0, 0, height)
	end

	local rateText = data.props.rateText
	local rateLabel = data.props.rateLabel
	local voteState = data.props.voteState
	local v2 = voteState == VoteStates.votedDown
	local v3 = voteState == VoteStates.votedUp

	return withStyle(function(p)
		local joined = Cryo.Dictionary.join(v, data.props.styleProps or {})
		local containerSpacingLeading = joined.containerSpacingLeading
		local containerSpacingTrailing = joined.containerSpacingTrailing
		local containerBorderRadius = joined.containerBorderRadius
		local containerBackgroundColor = joined.containerBackgroundColor or p.Theme.BackgroundContrast
		local containerGap = joined.containerGap

		local statWidgetContainerGap = joined.statWidgetContainerGap
		local statWidgetIconSize = joined.statWidgetIconSize
		local statWidgetIconContentColor = joined.statWidgetIconContentColor or p.Theme.IconEmphasis
		local statWidgetDataGap = joined.statWidgetDataGap
		local statWidgetDataContentColor = joined.statWidgetDataContentColor or p.Theme.TextEmphasis
		local statWidgetDataLabelContentColor = joined.statWidgetDataLabelContentColor or p.Theme.TextEmphasis

		local buttonGroupGap = joined.buttonGroupGap
		local buttonSize = joined.buttonSize
		local buttonIconSizeEnum = joined.buttonIconSizeEnum
		local v4 = -(statWidgetIconSize + math.max(getIconSize(buttonIconSizeEnum, p), buttonSize) * 2 + statWidgetContainerGap + containerGap + buttonGroupGap)

		return Roact.createElement("Frame", {
			Size = udim,
			Position = position,
			AnchorPoint = anchorPoint,
			BackgroundColor3 = containerBackgroundColor.Color,
			BackgroundTransparency = containerBackgroundColor.Transparency,
			BorderSizePixel = 0,
			LayoutOrder = layoutOrder
		}, {
			RoundCorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, containerBorderRadius)
			}),
			ListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, containerGap)
			}),
			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, containerSpacingLeading),
				PaddingRight = UDim.new(0, containerSpacingTrailing)
			}),
			Icon = Roact.createElement(Label, {
				LayoutOrder = 1,
				Size = UDim2.fromOffset(statWidgetIconSize, statWidgetIconSize),
				Image = iconsstatusgamesrating_large,
				ImageColor3 = statWidgetIconContentColor.Color,
				ImageTransparency = statWidgetIconContentColor.Transparency,
				BackgroundTransparency = 1
			}),
			TextSection = Roact.createElement(
				"Frame",
				{
					LayoutOrder = 2,
					Size = UDim2.new(1, v4, 0, 0),
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y
				},
				{
					ListLayout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						Padding = UDim.new(0, statWidgetDataGap)
					}),
					RateText = Roact.createElement(GenericTextLabel, {
						LayoutOrder = 1,
						AutomaticSize = Enum.AutomaticSize.XY,
						Text = rateText,
						colorStyle = statWidgetDataContentColor,
						fontStyle = p.Font.Title,
						BackgroundTransparency = 1
					}),
					RateLabel = Roact.createElement(GenericTextLabel, {
						LayoutOrder = 2,
						AutomaticSize = Enum.AutomaticSize.XY,
						Text = rateLabel,
						colorStyle = statWidgetDataLabelContentColor,
						fontStyle = p.Font.CaptionHeader,
						BackgroundTransparency = 1
					})
				}
			),
			VoteDown = Roact.createElement(IconButton, {
				layoutOrder = 3,
				size = UDim2.fromOffset(buttonSize, buttonSize),
				icon = v2 and iconsactionsvotevoteDownOn or iconsactionsvotevoteDownOff,
				iconColor3 = p.Theme.IconEmphasis.Color,
				iconSize = buttonIconSizeEnum,
				onActivated = data.onVoteDownActivated,
				showBackground = true
			}),
			VoteUp = Roact.createElement(IconButton, {
				layoutOrder = 4,
				size = UDim2.fromOffset(buttonSize, buttonSize),
				icon = v3 and iconsactionsvotevoteUpOn or iconsactionsvotevoteUpOff,
				iconColor3 = p.Theme.IconEmphasis.Color,
				iconSize = buttonIconSizeEnum,
				onActivated = data.onVoteUpActivated,
				showBackground = true
			})
		})
	end)
end

return extended
