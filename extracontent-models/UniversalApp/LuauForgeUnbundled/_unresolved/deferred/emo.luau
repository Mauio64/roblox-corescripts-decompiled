local module = require("@luauforge/deferred/eil")

local module2 = require("@luauforge/deferred/eiQ")
local module3 = require("@luauforge/deferred/eiP")
local useTokens = require("@luauforge/deferred/eiU").Hooks.useTokens
local useDesignTokens = require("@luauforge/deferred/eip").useDesignTokens
local useScreenSize = module2.useScreenSize
local useSelector = module3.Hooks.RoactRodux.useSelector

local module4 = require("@luauforge/deferred/eiT")
local useTextSizeOffset = module4.Core.Style.useTextSizeOffset
local gridMetrics = module4.App.Grid.GridMetrics
local getPageMargin = module4.App.Container.getPageMargin
local defineFastFlag = game:DefineFastFlag("AddFriendsScalingFix", false)

return function()
	local v5 = useDesignTokens()
	local v6 = useScreenSize()
	local v7 = if defineFastFlag then useTokens() else nil
	local v8 = useTextSizeOffset()
	local v9 = useSelector(function(p2)
		return p2.GlobalGuiInset
	end)

	local size_2000 = v5.Size.Size_2000
	local v10

	if defineFastFlag then
		v10 = gridMetrics.makeCustomMetricsGetter({
			minimumItemsPerRow = math.floor(2 / v7.Config.UI.Scale),
			minimumItemWidth = 160 * v7.Config.UI.Scale
		})
	else
		v10 = gridMetrics.getMediumMetrics
	end

	local v11 = module.useCallback(function(p2)
		return p2 + size_2000 + 3 * v8
	end, { size_2000, v8 })

	local itemMargin = v5.LuaApps.FriendsLanding.AddFriendsPage.ItemMargin or 12
	local safeAreaMargin = v5.LuaApps.App.Page.SafeAreaMargin
	local v12 = if safeAreaMargin.X > 0 then safeAreaMargin.X else getPageMargin(v6.X)
	local v13 = v6.X - 2 * v12 - v9.left
	local state, setState = module.useState(v13)

	local v14 = v10(state, itemMargin)
	return {
		numColumns = v14.itemsPerRow,
		columnGap = v14.itemsPerRow <= 2 and itemMargin or nil,
		getItemHeight = v11,
		onContainerSizeChanged = function(p2)
			setState(p2.X)
		end
	}, v14
end
