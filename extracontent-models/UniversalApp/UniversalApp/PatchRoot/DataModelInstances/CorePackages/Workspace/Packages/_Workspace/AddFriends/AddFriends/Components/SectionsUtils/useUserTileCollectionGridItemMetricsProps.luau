local Parent = script:FindFirstAncestor("AddFriends").Parent
local React = require(Parent.React)
local RobloxAppHooks = require(Parent.RobloxAppHooks)
local RoactUtils = require(Parent.RoactUtils)
local useTokens = require(Parent.Foundation).Hooks.useTokens
local useDesignTokens = require(Parent.Style).useDesignTokens
local useScreenSize = RobloxAppHooks.useScreenSize
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local UIBlox = require(Parent.UIBlox)
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local GridMetrics = UIBlox.App.Grid.GridMetrics
local getPageMargin = UIBlox.App.Container.getPageMargin
local v13 = game:DefineFastFlag("AddFriendsScalingFix", false)

return function() -- line: 23
	-- upvalues: useDesignTokens (copy), useScreenSize (copy), v13 (copy), useTokens (copy), useTextSizeOffset (copy), useSelector (copy), GridMetrics (copy), React (copy), getPageMargin (copy)
	local v14 = useDesignTokens()
	local v15 = useScreenSize()
	local v16 = if not v13 then nil else useTokens()
	local v17 = useTextSizeOffset()
	local v18 = useSelector(function(p1) -- line: 28
		return p1.GlobalGuiInset
	end)
	local Size_2000 = v14.Size.Size_2000
	local v20 = if not v13 then GridMetrics.getMediumMetrics else GridMetrics.makeCustomMetricsGetter({
		minimumItemsPerRow = math.floor(2 / v16.Config.UI.Scale),
		minimumItemWidth = 160 * v16.Config.UI.Scale
	})
	local v21 = React.useCallback(function(n1: number) -- line: 44
		-- upvalues: Size_2000 (copy), v17 (copy)
		return n1 + Size_2000 + 3 * v17
	end, {
		Size_2000,
		v17
	})
	local v22 = v14.LuaApps.FriendsLanding.AddFriendsPage.ItemMargin or 12
	local SafeAreaMargin = v14.LuaApps.App.Page.SafeAreaMargin
	local v24 = if not (SafeAreaMargin.X > 0) then getPageMargin(v15.X) else SafeAreaMargin.X
	local v25 = v15.X - 2 * v24 - v18.left
	local v26, v27 = React.useState(v25)
	local v28 = v20(v26, v22)

	return {
		numColumns = v28.itemsPerRow,
		columnGap = v28.itemsPerRow <= 2 and v22 or nil,
		getItemHeight = v21,
		onContainerSizeChanged = function(vector2: Vector2) -- line: 54
			-- upvalues: v27 (copy)
			v27(vector2.X)
		end
	}, v28
end
