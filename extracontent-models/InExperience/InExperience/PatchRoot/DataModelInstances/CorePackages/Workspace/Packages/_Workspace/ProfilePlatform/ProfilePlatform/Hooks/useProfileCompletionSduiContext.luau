local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)
local Foundation = require(Parent.Foundation)
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local calculateItemWidth = require(Parent.CollectionViews).calculateItemWidth
local AppPage = require(Parent.RobloxAppEnums).AppPage
local useTokens = Foundation.Hooks.useTokens
local getSduiServiceDependenciesStore = SduiCoreSystem.getSduiServiceDependenciesStore

local function computePeekFraction(n1: number, n2: number, n3: number, n4: number, n5: number) -- line: 24
	local v17 = n5 - n4

	if v17 <= 0 then
		return 0
	end

	local v18 = n1 - n2 - (n3 - 1) * n4 - n5

	if v18 <= 0 then
		return 0
	end

	return (math.clamp(n3 * v17 / v18, 0, 0.5))
end
local function useProfileCompletionSduiContext(t1: {[any]: any}) -- line: 50
	-- upvalues: useTokens (copy), React (copy), calculateItemWidth (copy), Signals (copy), AppPage (copy), getSduiServiceDependenciesStore (copy)
	local v20 = useTokens()
	local Medium = v20.Gap.Medium
	local Size_1500 = v20.Size.Size_1500
	local v23 = React.useMemo(function() -- line: 55
		-- upvalues: t1 (copy), Medium (copy), Size_1500 (copy)
		local containerWidth = t1.containerWidth
		local sideMargin = t1.sideMargin
		local v31 = Medium
		local v32 = Size_1500
		local v33 = v32 - v31

		if v33 <= 0 then
			return 0
		end

		local v34 = containerWidth - sideMargin - v31 * 0 - v32

		if v34 <= 0 then
			return 0
		end

		return (math.clamp(v33 * 1 / v34, 0, 0.5))
	end, {
		t1.containerWidth,
		t1.sideMargin,
		Medium,
		Size_1500
	})
	local v24 = React.useMemo(function() -- line: 59
		-- upvalues: calculateItemWidth (copy), Medium (copy), t1 (copy), v23 (copy)
		return calculateItemWidth(1, Medium, t1.sideMargin, t1.containerWidth, v23)
	end, {
		Medium,
		t1.sideMargin,
		t1.containerWidth,
		v23
	})
	local v25, v26 = React.useMemo(function() -- line: 63
		-- upvalues: Signals (copy), v23 (copy), Medium (copy), t1 (copy), v24 (copy)
		return Signals.createSignal({
			numColumns = 1,
			verticalPadding = 0,
			fractionalItemAmount = v23,
			columnGap = Medium,
			sideMargin = t1.sideMargin,
			itemWidth = v24
		})
	end, {})

	React.useEffect(function() -- line: 74
		-- upvalues: v26 (copy), v23 (copy), Medium (copy), t1 (copy), v24 (copy)
		v26({
			numColumns = 1,
			verticalPadding = 0,
			fractionalItemAmount = v23,
			columnGap = Medium,
			sideMargin = t1.sideMargin,
			itemWidth = v24
		})
	end, {
		v23,
		Medium,
		t1.sideMargin,
		v24,
		v26
	})

	local v27 = React.useCallback(function(_) -- line: 85
		-- upvalues: Signals (copy), v25 (copy)
		return Signals.createComputed(function(p2) -- line: 86
			-- upvalues: v25 (copy)
			return v25(p2)
		end)
	end, { v25 })
	local ProfilePlatform = AppPage.ProfilePlatform

	return (React.useMemo(function() -- line: 92
		-- upvalues: getSduiServiceDependenciesStore (copy), ProfilePlatform (copy), v27 (copy)
		return {
			dependencies = getSduiServiceDependenciesStore().getDependencies(ProfilePlatform),
			appPage = ProfilePlatform,
			getPageLayoutConfig = v27
		}
	end, {
		ProfilePlatform,
		v27
	}))
end

return useProfileCompletionSduiContext
