local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local FriendsLandingParent = FriendsLanding.Parent
local dependencies = require(FriendsLanding.dependencies)
local llama = dependencies.llama
local Roact = dependencies.Roact
local memoize = dependencies.memoize
local Dictionary = llama.Dictionary
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
local React = dependencies.React
local GridMetrics = dependencies.UIBlox.App.Grid.GridMetrics
local useDesignTokens = require(FriendsLandingParent.Style).useDesignTokens
local useUiModeInfo = require(FriendsLandingParent.RobloxAppHooks).useUiModeInfo
local UiMode = require(FriendsLandingParent.RobloxAppEnums).UiMode
local v23 = Roact.PureComponent:extend("ShowMoreWrapper")

v23.defaultProps = {
	itemSize = 175,
	visibleRows = 6,
	analytics = nil,
	overrideRenderShowMore = nil,
	handleShowMore = nil,
	spacingIfEmpty = 48,
	listComponent = FriendsLandingPage,
	friends = {},
	filter = filterStates.All,
	sectionType = ShowMoreSectionTypeEnum.Friends
}

function v23.init(p1) -- line: 49
	-- upvalues: Dictionary (copy), filterStates (copy), updateFriendsWithWidth (copy), friendsPerLoadGroup (copy), ButtonClickEvents (copy), friendsPerRow (copy), loadFriendGroup (copy), memoize (copy), limitFriends (copy), Roact (copy), ShowMoreButton (copy)
	p1.state = {
		width = 100,
		selectedItemIndex = nil,
		filterFriendCounts = Dictionary.map(filterStates, function() -- line: 52
			-- upvalues: p1 (copy)
			return p1.props.visibleRows
		end)
	}

	function p1.updateWidth(p2) -- line: 58
		-- upvalues: p1 (copy), updateFriendsWithWidth (copy)
		p1:setState(updateFriendsWithWidth(p2.AbsoluteSize.X))

		if p1.props.onWidthUpdated then
			p1.props.onWidthUpdated(p2.AbsoluteSize.X)
		end
	end
	function p1.reset() -- line: 66
		-- upvalues: p1 (copy), Dictionary (copy), friendsPerLoadGroup (copy)
		p1:setState(function(p3, p4) -- line: 67
			-- upvalues: Dictionary (copy), p1 (copy), friendsPerLoadGroup (copy)
			return {
				filterFriendCounts = Dictionary.join(p1.state.filterFriendCounts, {
					[p1.props.filter] = friendsPerLoadGroup(p3, p4)
				})
			}
		end)
	end
	function p1.showMore() -- line: 77
		-- upvalues: p1 (copy), ButtonClickEvents (copy), friendsPerRow (copy), Dictionary (copy), loadFriendGroup (copy)
		if p1.props.analytics then
			p1.props.analytics:buttonClick(ButtonClickEvents.LoadMoreUsers, {
				sectionType = p1.props.sectionType
			})
		end

		if p1.props.fireOnShowMore then
			p1.props.fireOnShowMore(p1.props.sectionType)
		end

		if p1.props.handleShowMore then
			p1.props.handleShowMore(friendsPerRow(Dictionary.join({
				width = p1.state.width
			}, p1.props)))

			return
		end

		p1:setState(function(p5, p6) -- line: 95
			-- upvalues: Dictionary (copy), loadFriendGroup (copy)
			local v49 = p5.filterFriendCounts[p6.filter]

			return Dictionary.join(loadFriendGroup(p5, p6), {
				selectedItemIndex = v49 + 1
			})
		end)
	end

	p1.limitFriends = memoize(limitFriends)
	p1.renderShowMore = memoize(function(p7, p8, p9) -- line: 108
		-- upvalues: Roact (copy), ShowMoreButton (copy), p1 (copy)
		return function(p10) -- line: 109
			-- upvalues: p9 (copy), p8 (copy), p7 (copy), Roact (copy), ShowMoreButton (copy), p1 (copy)
			local v51 = p9 and p9(p8)

			if p7 > p8 or v51 then
				return Roact.createElement(ShowMoreButton, {
					layoutOrder = p10,
					onSizeChange = p1.updateWidth,
					onActivated = p1.showMore
				})
			end

			return Roact.createElement("Frame", {
				Name = "showMoreSpacing",
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(0, p1.props.spacingIfEmpty),
				LayoutOrder = p10
			})
		end
	end)

	function p1.checkAndResetIfNeeded(p11) -- line: 130
		-- upvalues: p1 (copy)
		if #p1.props.friends ~= #p11.friends or p11.visibleRows ~= p1.props.visibleRows then
			p1.reset()
		end
	end
end
function v23.didUpdate(p12, p13) -- line: 137
	p12.checkAndResetIfNeeded(p13)
end
function v23.render(p14) -- line: 141
	-- upvalues: Roact (copy), Dictionary (copy)
	local v29 = p14.state.filterFriendCounts[p14.props.filter]

	return Roact.createElement(p14.props.listComponent, Dictionary.join(p14.props, {
		friends = p14.limitFriends(v29, p14.props.friends),
		showMore = p14.showMore,
		totalFilteredFriends = #p14.props.friends,
		renderShowMore = p14.renderShowMore(#p14.props.friends, v29, p14.props.overrideRenderShowMore),
		resetShowMore = p14.reset,
		totalInactiveFriends = p14.props.totalInactiveFriends,
		selectedItemIndex = p14.state.selectedItemIndex
	}))
end

local function ShowMoreWrapperFn(p15) -- line: 159
	-- upvalues: useDesignTokens (copy), useUiModeInfo (copy), UiMode (copy), React (copy), GridMetrics (copy), v23 (copy), llama (copy)
	local v31 = useDesignTokens()
	local v32 = useUiModeInfo().uiMode == UiMode.TenFoot
	local GridViewItemMetrics = v31.LuaApps.FriendsLanding.FriendsLandingPage.GridViewItemMetrics
	local GridHorizontalSpacing = v31.LuaApps.FriendsLanding.FriendsLandingPage.GridHorizontalSpacing
	local GridVerticalSpacing = v31.LuaApps.FriendsLanding.FriendsLandingPage.GridVerticalSpacing
	local v36 = React.useMemo(function() -- line: 168
		-- upvalues: v32 (copy), GridMetrics (copy), GridViewItemMetrics (copy)
		if v32 then
			return GridMetrics.makeCustomMetricsGetter(GridViewItemMetrics)
		end

		return nil
	end, {
		v32,
		GridViewItemMetrics
	})
	local v37, v38 = React.useState(100)
	local v39 = React.useMemo(function() -- line: 177
		-- upvalues: v32 (copy), v36 (copy), GridHorizontalSpacing (copy), v37 (copy)
		if v32 and (v36 and GridHorizontalSpacing) then
			return v36(v37, GridHorizontalSpacing).itemWidth
		end

		return nil
	end, {
		v32,
		v36,
		v37,
		GridHorizontalSpacing
	})

	return React.createElement(v23, llama.Dictionary.join({
		onWidthUpdated = if not v32 then nil else v38,
		itemSize = v39,
		getItemMetrics = v36,
		gridHorizontalSpacing = GridHorizontalSpacing,
		gridVerticalSpacing = GridVerticalSpacing
	}, p15))
end

return ShowMoreWrapperFn
