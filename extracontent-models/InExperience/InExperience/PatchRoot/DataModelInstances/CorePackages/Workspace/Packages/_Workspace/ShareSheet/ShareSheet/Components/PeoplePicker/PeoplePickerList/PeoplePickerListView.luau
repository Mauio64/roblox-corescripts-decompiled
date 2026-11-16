local parent = script:FindFirstAncestor("ShareSheet").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local UserTile = require(parent.UserTile)

local Skeleton = Foundation.Skeleton
local Text = Foundation.Text
local View = Foundation.View
local Radius = Foundation.Enums.Radius
local userTile = UserTile.UserTile
local LayoutMode = UserTile.LayoutMode
local useTokens = Foundation.Hooks.useTokens

local function getItemLayoutMetrics(p) -- 1 equivalent call inferred from this helper
	local size_1400 = p.Size.Size_1400
	local small = p.Padding.Small
	local xSmall = p.Padding.XSmall

	return {
		avatarSize = size_1400,
		rowVerticalPadding = small,
		wrapperVerticalPadding = xSmall,
		estimatedRowHeight = size_1400 + 2 * small + 2 * xSmall
	}
end

local function PeoplePickerListItem(props)
	local itemLayoutMetrics = getItemLayoutMetrics(useTokens()) -- inferred equivalent call

	local testId = props.testId or "people-picker-list-item"
	local isLoading = props.isLoading == true
	local leading = props.leading

	local createElement = React.createElement

	local createElement2 = React.createElement
	local v = {
		tag = "size-full-0 auto-y",
		padding = {
			top = UDim.new(0, itemLayoutMetrics.wrapperVerticalPadding),
			bottom = UDim.new(0, itemLayoutMetrics.wrapperVerticalPadding)
		}
	}

	local createElement3 = React.createElement
	local v2 = {
		tag = "row align-y-center gap-medium size-full-0 auto-y radius-medium",
		padding = {
			top = UDim.new(0, itemLayoutMetrics.rowVerticalPadding),
			bottom = UDim.new(0, itemLayoutMetrics.rowVerticalPadding)
		},
		onActivated = 0,
		selection = 0,
		testId = 0
	}
	local onActivated

	if not isLoading then
		onActivated = props.onActivated
	end

	v2.onActivated = onActivated
	v2.selection = {
		Selectable = not isLoading
	}
	v2.testId = testId

	local createElement4 = React.createElement
	local v3 = {
		Size = UDim2.fromOffset(itemLayoutMetrics.avatarSize, itemLayoutMetrics.avatarSize),
		LayoutOrder = 1,
		testId = 0
	}
	local testId2

	if leading.secondUserId then
		testId2 = `{testId}--avatar-pile`
	else
		testId2 = `{testId}--avatar`
	end

	v3.testId = testId2
	local tile

	if isLoading then
		tile = React.createElement(Skeleton, {
			radius = Radius.Circle,
			testId = `{testId}--avatar-skeleton`
		})
	else
		tile = React.createElement(userTile, {
			userId = leading.userId,
			facePileSecondUserId = leading.secondUserId,
			layoutMode = LayoutMode.compact,
			userPresenceType = leading.userPresence
		})
	end

	local children = {
		Leading = createElement4(View, v3, { Tile = tile }),
		Content = 0
	}

	local createElement5 = React.createElement

	local createElement6 = React.createElement
	local title

	if isLoading then
		title = React.createElement(View, { tag = "size-full-500", LayoutOrder = 1 }, {
			Shimmer = React.createElement(Skeleton, {
				Size = UDim2.new(0.5, 0, 1, 0),
				radius = Radius.Small,
				testId = `{testId}--title-skeleton`
			})
		})
	else
		title = React.createElement(Text, {
			Text = props.title,
			tag = "size-full-0 auto-y text-title-large text-wrap text-align-x-left content-emphasis",
			LayoutOrder = 1
		})
	end

	local description

	if isLoading then
		description = React.createElement(View, { tag = "size-full-400", LayoutOrder = 2 }, {
			Shimmer = React.createElement(Skeleton, {
				Size = UDim2.new(0.3, 0, 1, 0),
				radius = Radius.Small,
				testId = `{testId}--description-skeleton`
			})
		})
	elseif props.description ~= nil then
		description = React.createElement(Text, {
			Text = props.description,
			tag = "size-full-0 auto-y text-body-medium text-align-x-left text-truncate-split",
			LayoutOrder = 2
		})
	end

	local v4 = {
		TextContainer = createElement6(View, { tag = "col fill gap-xsmall auto-y", LayoutOrder = 1 }, {
			Title = title,
			Description = description
		}),
		Trailing = 0
	}
	local trailing

	if not (props.trailing == nil or isLoading) then
		trailing = React.createElement(
			View,
			{ tag = "align-x-center align-y-center auto-xy", LayoutOrder = 2 },
			props.trailing
		)
	end

	v4.Trailing = trailing
	children.Content = createElement5(View, {
		tag = "row align-y-center fill gap-medium auto-y",
		LayoutOrder = 2
	}, v4)
	return createElement(View, { tag = "col size-full-0 auto-y" }, {
		Wrapper = createElement2(View, v, {
			Row = createElement3(View, v2, children)
		})
	})
end

return { getItemLayoutMetrics = getItemLayoutMetrics, Item = PeoplePickerListItem }
