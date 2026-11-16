local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local parent = FriendsLanding.Parent

local dependencies = require(FriendsLanding.dependencies)
local llama = dependencies.llama
local roact = dependencies.Roact
local memoize = dependencies.memoize

local dictionary = llama.Dictionary

local FriendsLandingPage = require(FriendsLanding.Components.FriendsLandingPage)
local limitFriends = require(script.helpers.limitFriends)
local updateFriendsWithWidth = require(script.helpers.updateFriendsWithWidth)
local loadFriendGroup = require(script.helpers.loadFriendGroup)
local friendsPerRow = require(script.helpers.friendsPerRow)
local friendsPerLoadGroup = require(script.helpers.friendsPerLoadGroup)
local ShowMoreButton = require(FriendsLanding.Components.ShowMoreButton)
local ButtonClickEvents = require(FriendsLanding.FriendsLandingAnalytics.ButtonClickEvents)
local filterStates = require(FriendsLanding.Friends.filterStates)
local ShowMoreSectionTypeEnum = require(FriendsLanding.Enums.ShowMoreSectionTypeEnum)

local react = dependencies.React
local gridMetrics = dependencies.UIBlox.App.Grid.GridMetrics
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local RobloxAppEnums = require(parent.RobloxAppEnums)
local UiMode = RobloxAppEnums.UiMode

local extended = roact.PureComponent:extend("ShowMoreWrapper")

extended.defaultProps = {
	listComponent = FriendsLandingPage,
	itemSize = 175,
	visibleRows = 6,
	friends = {},
	analytics = nil,
	filter = filterStates.All,
	overrideRenderShowMore = nil,
	handleShowMore = nil,
	spacingIfEmpty = 48,
	sectionType = ShowMoreSectionTypeEnum.Friends
}

function extended:init()
	self.state = {
		width = 100,
		filterFriendCounts = dictionary.map(filterStates, function()
			return self.props.visibleRows
		end),
		selectedItemIndex = nil
	}

	function self.updateWidth(p)
		self:setState(updateFriendsWithWidth(p.AbsoluteSize.X))

		if self.props.onWidthUpdated then
			self.props.onWidthUpdated(p.AbsoluteSize.X)
		end
	end

	function self.reset()
		self:setState(function(p, p2)
			return {
				filterFriendCounts = dictionary.join(self.state.filterFriendCounts, {
					[self.props.filter] = friendsPerLoadGroup(p, p2)
				})
			}
		end)
	end

	function self.showMore()
		if self.props.analytics then
			self.props.analytics:buttonClick(ButtonClickEvents.LoadMoreUsers, {
				sectionType = self.props.sectionType
			})
		end

		if self.props.fireOnShowMore then
			self.props.fireOnShowMore(self.props.sectionType)
		end

		if self.props.handleShowMore then
			self.props.handleShowMore(friendsPerRow(dictionary.join({ width = self.state.width }, self.props)))
		else
			self:setState(function(p, p2)
				local filterFriendCount = p.filterFriendCounts[p2.filter]

				return dictionary.join(loadFriendGroup(p, p2), {
					selectedItemIndex = filterFriendCount + 1
				})
			end)
		end
	end

	self.limitFriends = memoize(limitFriends)

	self.renderShowMore = memoize(function(p, p2, callback)
		return function(layoutOrder)
			local v = callback and callback(p2)

			if p2 < p or v then
				return roact.createElement(ShowMoreButton, {
					layoutOrder = layoutOrder,
					onSizeChange = self.updateWidth,
					onActivated = self.showMore
				})
			end

			return roact.createElement("Frame", {
				Name = "showMoreSpacing",
				Size = UDim2.fromOffset(0, self.props.spacingIfEmpty),
				BackgroundTransparency = 1,
				LayoutOrder = layoutOrder
			})
		end
	end)

	function self.checkAndResetIfNeeded(p)
		if #self.props.friends ~= #p.friends or p.visibleRows ~= self.props.visibleRows then
			self.reset()
		end
	end
end

function extended.didUpdate(p, p2)
	p.checkAndResetIfNeeded(p2)
end

function extended.render(props)
	local filterFriendCount = props.state.filterFriendCounts[props.props.filter]
	return roact.createElement(props.props.listComponent, dictionary.join(props.props, {
		friends = props.limitFriends(filterFriendCount, props.props.friends),
		showMore = props.showMore,
		totalFilteredFriends = #props.props.friends,
		renderShowMore = props.renderShowMore(
			#props.props.friends,
			filterFriendCount,
			props.props.overrideRenderShowMore
		),
		resetShowMore = props.reset,
		totalInactiveFriends = props.props.totalInactiveFriends,
		selectedItemIndex = props.state.selectedItemIndex
	}))
end

local function ShowMoreWrapperFn(p)
	local v = useDesignTokens()
	local v2 = useUiModeInfo().uiMode == UiMode.TenFoot

	local gridViewItemMetrics = v.LuaApps.FriendsLanding.FriendsLandingPage.GridViewItemMetrics
	local gridHorizontalSpacing = v.LuaApps.FriendsLanding.FriendsLandingPage.GridHorizontalSpacing
	local gridVerticalSpacing = v.LuaApps.FriendsLanding.FriendsLandingPage.GridVerticalSpacing

	local getItemMetrics = react.useMemo(function()
		if v2 then
			return gridMetrics.makeCustomMetricsGetter(gridViewItemMetrics)
		end

		return nil
	end, { v2, gridViewItemMetrics })

	local state, setState = react.useState(100)

	local itemSize = react.useMemo(function()
		if v2 and getItemMetrics and gridHorizontalSpacing then
			return getItemMetrics(state, gridHorizontalSpacing).itemWidth
		end

		return nil
	end, { v2, getItemMetrics, state, gridHorizontalSpacing })

	local createElement = react.createElement

	local join = llama.Dictionary.join

	if not v2 then
		setState = nil
	end

	return createElement(extended, join({
		onWidthUpdated = setState,
		itemSize = itemSize,
		getItemMetrics = getItemMetrics,
		gridHorizontalSpacing = gridHorizontalSpacing,
		gridVerticalSpacing = gridVerticalSpacing
	}, p))
end

return ShowMoreWrapperFn
