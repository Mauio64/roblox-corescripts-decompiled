local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Signals")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SduiCoreSystem")
local calculateItemWidth = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/CollectionViews").calculateItemWidth
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums").AppPage
local useTokens = Foundation.Hooks.useTokens

local getSduiServiceDependenciesStore = SduiCoreSystem.getSduiServiceDependenciesStore

local function computePeekFraction(p2, p3, p4, p5, p6)
	local v5 = p6 - p5

	if v5 <= 0 then
		return 0
	end

	local v6 = p2 - p3 - (p4 - 1) * p5 - p6

	if v6 <= 0 then
		return 0
	end

	return (math.clamp(p4 * v5 / v6, 0, 0.5))
end

local function useProfileCompletionSduiContext(p2)
	local v5 = useTokens()
	local medium = v5.Gap.Medium
	local size_1500 = v5.Size.Size_1500

	local v6 = React.useMemo(function()
		local containerWidth = p2.containerWidth
		local sideMargin = p2.sideMargin
		local v7 = medium
		local v8 = size_1500
		local v9 = v8 - v7

		if v9 <= 0 then
			return 0
		end

		local v10 = containerWidth - sideMargin - 0 * v7 - v8

		if v10 <= 0 then
			return 0
		end

		return (math.clamp(1 * v9 / v10, 0, 0.5))
	end, { p2.containerWidth, p2.sideMargin, medium, size_1500 })

	local v7 = React.useMemo(function()
		return calculateItemWidth(1, medium, p2.sideMargin, p2.containerWidth, v6)
	end, { medium, p2.sideMargin, p2.containerWidth, v6 })

	local v8, v9 = React.useMemo(function()
		return Signals.createSignal({
			numColumns = 1,
			fractionalItemAmount = v6,
			columnGap = medium,
			sideMargin = p2.sideMargin,
			verticalPadding = 0,
			itemWidth = v7
		})
	end, {})

	React.useEffect(function()
		v9({
			numColumns = 1,
			fractionalItemAmount = v6,
			columnGap = medium,
			sideMargin = p2.sideMargin,
			verticalPadding = 0,
			itemWidth = v7
		})
	end, { v6, medium, p2.sideMargin, v7, v9 })

	local v10 = React.useCallback(function(p3)
		return Signals.createComputed(function(p4)
			return v8(p4)
		end)
	end, { v8 })

	local profilePlatform = appPage.ProfilePlatform
	return (React.useMemo(function()
		return {
			dependencies = getSduiServiceDependenciesStore().getDependencies(profilePlatform),
			appPage = profilePlatform,
			getPageLayoutConfig = v10
		}
	end, { profilePlatform, v10 }))
end

return useProfileCompletionSduiContext
