local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local scriptParentParentParentParent = scriptParentParentParent.Parent
local Roact = require(scriptParentParentParentParent.Roact)
local t = require(scriptParentParentParentParent.t)
local Label = require(scriptParentParentParent.Core.ImageSet.ImageSetComponent).Label
local Cryo = require(scriptParentParentParentParent.Cryo)

require(scriptParentParent.Style.StyleTypes)

local validateColorInfo = require(scriptParentParentParent.Core.Style.Validator.validateColorInfo)
local Images = require(scriptParentParent.ImageSet.Images)
local IconButton = require(scriptParentParent.Button.IconButton)
local getIconSize = require(scriptParentParent.ImageSet.getIconSize)
local IconSize = require(scriptParentParent.ImageSet.Enum.IconSize)
local GenericTextLabel = require(scriptParentParentParent.Core.Text.GenericTextLabel.GenericTextLabel)
local withStyle = require(scriptParentParentParent.Core.Style.withStyle)
local VoteStates = require(scriptParent.Enum.VoteStates)
local v17 = Images["icons/status/games/rating_large"]
local v18 = Images["icons/actions/vote/voteDownOff"]
local v19 = Images["icons/actions/vote/voteDownOn"]
local v20 = Images["icons/actions/vote/voteUpOff"]
local v21 = Images["icons/actions/vote/voteUpOn"]
local t1 = {
	containerSpacingTop = 12,
	containerSpacingTrailing = 12,
	containerSpacingBottom = 12,
	containerSpacingLeading = 12,
	containerBorderRadius = 8,
	containerGap = 12,
	statWidgetContainerGap = 12,
	statWidgetDataGap = 0,
	buttonGroupGap = 12,
	buttonSize = 44,
	statWidgetIconSize = getIconSize(IconSize.Large),
	buttonIconSizeEnum = IconSize.Medium
}
local v23 = Roact.PureComponent:extend("RateCount")

v23.validateProps = t.strictInterface({
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
v23.defaultProps = {
	height = 72,
	rateText = "",
	rateLabel = "",
	voteState = VoteStates.notVoted
}

function v23.init(p1) -- line: 151
	function p1.onVoteDownActivated() -- line: 152
		-- upvalues: p1 (copy)
		local onVoteDownActivated = p1.props.onVoteDownActivated

		if onVoteDownActivated then
			onVoteDownActivated()
		end
	end
	function p1.onVoteUpActivated() -- line: 159
		-- upvalues: p1 (copy)
		local onVoteUpActivated = p1.props.onVoteUpActivated

		if onVoteUpActivated then
			onVoteUpActivated()
		end
	end
end
function v23.render(p2) -- line: 167
	-- upvalues: VoteStates (copy), withStyle (copy), Cryo (copy), t1 (copy), getIconSize (copy), Roact (copy), Label (copy), v17 (copy), GenericTextLabel (copy), IconButton (copy), v19 (copy), v18 (copy), v21 (copy), v20 (copy)
	local position = p2.props.position
	local layoutOrder = p2.props.layoutOrder
	local anchorPoint = p2.props.anchorPoint
	local width = p2.props.width
	local height = p2.props.height
	local u31 = if not width then UDim2.new(1, 0, 0, height) else UDim2.new(0, width, 0, height)
	local rateText = p2.props.rateText
	local rateLabel = p2.props.rateLabel
	local voteState = p2.props.voteState
	local v35 = voteState == VoteStates.votedDown
	local v36 = voteState == VoteStates.votedUp

	return withStyle(function(p3) -- line: 187
		-- upvalues: Cryo (copy), t1 (copy), p2 (copy), getIconSize (copy), Roact (copy), u31 (ref), position (copy), anchorPoint (copy), layoutOrder (copy), Label (copy), v17 (copy), GenericTextLabel (copy), rateText (copy), rateLabel (copy), IconButton (copy), v35 (copy), v19 (copy), v18 (copy), v36 (copy), v21 (copy), v20 (copy)
		local v40 = Cryo.Dictionary.join(t1, p2.props.styleProps or {})
		local containerSpacingLeading = v40.containerSpacingLeading
		local containerSpacingTrailing = v40.containerSpacingTrailing
		local containerBorderRadius = v40.containerBorderRadius
		local v44 = v40.containerBackgroundColor or p3.Theme.BackgroundContrast
		local containerGap = v40.containerGap
		local statWidgetContainerGap = v40.statWidgetContainerGap
		local statWidgetIconSize = v40.statWidgetIconSize
		local v48 = v40.statWidgetIconContentColor or p3.Theme.IconEmphasis
		local statWidgetDataGap = v40.statWidgetDataGap
		local v50 = v40.statWidgetDataContentColor or p3.Theme.TextEmphasis
		local v51 = v40.statWidgetDataLabelContentColor or p3.Theme.TextEmphasis
		local buttonGroupGap = v40.buttonGroupGap
		local buttonSize = v40.buttonSize
		local buttonIconSizeEnum = v40.buttonIconSizeEnum
		local v55 = -(statWidgetIconSize + math.max(getIconSize(buttonIconSizeEnum, p3), buttonSize) * 2 + statWidgetContainerGap + containerGap + buttonGroupGap)

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = u31,
			Position = position,
			AnchorPoint = anchorPoint,
			BackgroundColor3 = v44.Color,
			BackgroundTransparency = v44.Transparency,
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
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(statWidgetIconSize, statWidgetIconSize),
				Image = v17,
				ImageColor3 = v48.Color,
				ImageTransparency = v48.Transparency
			}),
			TextSection = Roact.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, v55, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				ListLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, statWidgetDataGap)
				}),
				RateText = Roact.createElement(GenericTextLabel, {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = rateText,
					colorStyle = v50,
					fontStyle = p3.Font.Title
				}),
				RateLabel = Roact.createElement(GenericTextLabel, {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = rateLabel,
					colorStyle = v51,
					fontStyle = p3.Font.CaptionHeader
				})
			}),
			VoteDown = Roact.createElement(IconButton, {
				layoutOrder = 3,
				showBackground = true,
				size = UDim2.fromOffset(buttonSize, buttonSize),
				icon = v35 and v19 or v18,
				iconColor3 = p3.Theme.IconEmphasis.Color,
				iconSize = buttonIconSizeEnum,
				onActivated = p2.onVoteDownActivated
			}),
			VoteUp = Roact.createElement(IconButton, {
				layoutOrder = 4,
				showBackground = true,
				size = UDim2.fromOffset(buttonSize, buttonSize),
				icon = v36 and v21 or v20,
				iconColor3 = p3.Theme.IconEmphasis.Color,
				iconSize = buttonIconSizeEnum,
				onActivated = p2.onVoteUpActivated
			})
		})
	end)
end

return v23
