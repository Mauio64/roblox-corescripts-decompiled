local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")
local UserTile = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/UserTile")

local skeleton = Foundation.Skeleton
local text = Foundation.Text
local view = Foundation.View
local radius = Foundation.Enums.Radius
local userTile = UserTile.UserTile
local layoutMode = UserTile.LayoutMode
local useTokens = Foundation.Hooks.useTokens

local function PeoplePickerListItem(props)
	local v5 = useTokens()
	local size_1400 = v5.Size.Size_1400
	local small = v5.Padding.Small
	local xSmall = v5.Padding.XSmall

	local v6 = {
		avatarSize = size_1400,
		rowVerticalPadding = small,
		wrapperVerticalPadding = xSmall,
		estimatedRowHeight = size_1400 + 2 * small + 2 * xSmall
	}

	local testId = props.testId or "people-picker-list-item"
	local isLoading = props.isLoading == true
	local leading = props.leading

	local createElement = React.createElement

	local createElement2 = React.createElement
	local v11 = {
		tag = "size-full-0 auto-y",
		padding = {
			top = UDim.new(0, v6.wrapperVerticalPadding),
			bottom = UDim.new(0, v6.wrapperVerticalPadding)
		}
	}

	local createElement3 = React.createElement
	local v14 = {
		tag = "row align-y-center gap-medium size-full-0 auto-y radius-medium",
		padding = {
			top = UDim.new(0, v6.rowVerticalPadding),
			bottom = UDim.new(0, v6.rowVerticalPadding)
		},
		onActivated = 0,
		selection = 0,
		testId = 0
	}

	local v15 = if not isLoading then props.onActivated else nil
	v14.onActivated = v15
	v14.selection = {
		Selectable = not isLoading
	}
	v14.testId = testId

	local createElement4 = React.createElement
	local v17 = {
		Size = UDim2.fromOffset(v6.avatarSize, v6.avatarSize),
		LayoutOrder = 1,
		testId = 0
	}

	local v18 = if leading.secondUserId then `{testId}--avatar-pile` else `{testId}--avatar`
	v17.testId = v18

	local v20 = if isLoading then React.createElement(skeleton, {
		radius = radius.Circle,
		testId = `{testId}--avatar-skeleton`
	}) else React.createElement(userTile, {
		userId = leading.userId,
		facePileSecondUserId = leading.secondUserId,
		layoutMode = layoutMode.compact,
		userPresenceType = leading.userPresence
	})
	local children = {
		Leading = createElement4(view, v17, { Tile = v20 }),
		Content = 0
	}

	local createElement5 = React.createElement

	local createElement6 = React.createElement

	local v27 = if isLoading then React.createElement(view, {
		tag = "size-full-500",
		LayoutOrder = 1
	}, {
		Shimmer = React.createElement(skeleton, {
			Size = UDim2.new(0.5, 0, 1, 0),
			radius = radius.Small,
			testId = `{testId}--title-skeleton`
		})
	}) else React.createElement(text, {
		Text = props.title,
		tag = "size-full-0 auto-y text-title-large text-wrap text-align-x-left content-emphasis",
		LayoutOrder = 1
	})
	local v28

	if isLoading then
		v28 = React.createElement(view, { tag = "size-full-400", LayoutOrder = 2 }, {
			Shimmer = React.createElement(skeleton, {
				Size = UDim2.new(0.3, 0, 1, 0),
				radius = radius.Small,
				testId = `{testId}--description-skeleton`
			})
		})
	elseif props.description ~= nil then
		v28 = React.createElement(text, {
			Text = props.description,
			tag = "size-full-0 auto-y text-body-medium text-align-x-left text-truncate-split",
			LayoutOrder = 2
		})
	end

	local v23 = {
		TextContainer = createElement6(view, {
			tag = "col fill gap-xsmall auto-y",
			LayoutOrder = 1
		}, {
			Title = v27,
			Description = v28
		}),
		Trailing = 0
	}

	local v29 = if props.trailing ~= nil and not isLoading then React.createElement(
		view,
		{ tag = "align-x-center align-y-center auto-xy", LayoutOrder = 2 },
		props.trailing
	) else nil
	v23.Trailing = v29
	children.Content = createElement5(
		view,
		{ tag = "row align-y-center fill gap-medium auto-y", LayoutOrder = 2 },
		v23
	)
	return createElement(view, { tag = "col size-full-0 auto-y" }, {
		Wrapper = createElement2(view, v11, {
			Row = createElement3(view, v14, children)
		})
	})
end

return {
	getItemLayoutMetrics = function(p2)
		local size_1400 = p2.Size.Size_1400
		local small = p2.Padding.Small
		local xSmall = p2.Padding.XSmall

		return {
			avatarSize = size_1400,
			rowVerticalPadding = small,
			wrapperVerticalPadding = xSmall,
			estimatedRowHeight = size_1400 + 2 * small + 2 * xSmall
		}
	end,
	Item = PeoplePickerListItem
}
