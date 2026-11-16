local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local Constants = require(parent.Common.Constants)
local usePreferredBackgroundStyle = require(parent.Hooks.usePreferredBackgroundStyle)

local function LeaderboardRowShell(props)
	local backgroundStyle = usePreferredBackgroundStyle(useTokens().Color.OverMedia.OverMedia_100)

	local flexTag = props.flexTag or Constants.ROW_FLEX_TAG
	local children = {
		RowContent = React.createElement(View, { tag = `size-full {flexTag}` }, props.children)
	}

	if props.isHighlighted then
		children.Highlight = React.createElement(View, {
			backgroundStyle = backgroundStyle,
			tag = "size-full",
			ZIndex = 0
		})
	end

	if props.showDivider then
		children.Divider = React.createElement(Foundation.Divider, {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1)
		})
	end

	local selection = props.selection

	if selection == nil then
		if props.onActivated then
			selection = Constants.SELECTABLE
		else
			selection = Constants.NOT_SELECTABLE
		end
	end

	return React.createElement(View, {
		Size = UDim2.new(1, 0, 0, props.rowHeight),
		LayoutOrder = props.layoutOrder,
		onActivated = props.onActivated,
		ref = props.rowRef,
		selection = selection,
		testId = "leaderboard-row-shell"
	}, children)
end

return React.memo(LeaderboardRowShell)
