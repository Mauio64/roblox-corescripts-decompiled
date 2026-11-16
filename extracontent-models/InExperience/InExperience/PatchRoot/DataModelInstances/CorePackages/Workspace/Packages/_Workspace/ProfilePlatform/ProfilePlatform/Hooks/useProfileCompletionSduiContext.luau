local parent = script:FindFirstAncestor("ProfilePlatform").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local Foundation = require(parent.Foundation)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local CollectionViews = require(parent.CollectionViews)
local calculateItemWidth = CollectionViews.calculateItemWidth
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local useTokens = Foundation.Hooks.useTokens

local getSduiServiceDependenciesStore = SduiCoreSystem.getSduiServiceDependenciesStore

local function computePeekFraction(p: number, p2: number, p3: number, p4: number, p5: number)
	local v = p5 - p4

	if v <= 0 then
		return 0
	end

	local v2 = p - p2 - (p3 - 1) * p4 - p5

	if v2 <= 0 then
		return 0
	end

	return (math.clamp(p3 * v / v2, 0, 0.5))
end

local function useProfileCompletionSduiContext(p)
	local v = useTokens()
	local medium = v.Gap.Medium
	local size_1500 = v.Size.Size_1500

	local fractionalItemAmount = React.useMemo(function()
		local containerWidth = p.containerWidth
		local sideMargin = p.sideMargin
		local v2 = medium
		local v3 = size_1500
		local v4 = v3 - v2

		if v4 <= 0 then
			return 0
		end

		local v5 = containerWidth - sideMargin - v2 * 0 - v3

		if v5 <= 0 then
			return 0
		end

		return (math.clamp(v4 * 1 / v5, 0, 0.5))
	end, { p.containerWidth, p.sideMargin, medium, size_1500 })

	local itemWidth = React.useMemo(function()
		return calculateItemWidth(1, medium, p.sideMargin, p.containerWidth, fractionalItemAmount)
	end, { medium, p.sideMargin, p.containerWidth, fractionalItemAmount })

	local v2, v3 = React.useMemo(function()
		return Signals.createSignal({
			numColumns = 1,
			fractionalItemAmount = fractionalItemAmount,
			columnGap = medium,
			sideMargin = p.sideMargin,
			verticalPadding = 0,
			itemWidth = itemWidth
		})
	end, {})

	React.useEffect(function()
		v3({
			numColumns = 1,
			fractionalItemAmount = fractionalItemAmount,
			columnGap = medium,
			sideMargin = p.sideMargin,
			verticalPadding = 0,
			itemWidth = itemWidth
		})
	end, { fractionalItemAmount, medium, p.sideMargin, itemWidth, v3 })

	local getPageLayoutConfig = React.useCallback(function(_)
		return Signals.createComputed(function(p2)
			return v2(p2)
		end)
	end, { v2 })

	local profilePlatform = AppPage.ProfilePlatform
	return (React.useMemo(function()
		return {
			dependencies = getSduiServiceDependenciesStore().getDependencies(profilePlatform),
			appPage = profilePlatform,
			getPageLayoutConfig = getPageLayoutConfig
		}
	end, { profilePlatform, getPageLayoutConfig }))
end

return useProfileCompletionSduiContext
