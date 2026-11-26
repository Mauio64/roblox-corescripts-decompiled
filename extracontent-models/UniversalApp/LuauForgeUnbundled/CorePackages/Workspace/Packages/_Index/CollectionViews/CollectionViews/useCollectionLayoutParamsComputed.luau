local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/React")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Foundation").Hooks.useTokens
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Responsive")
local usePreferredInput = Responsive.usePreferredInput
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/UniversalAppPolicy").useAppPolicy
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Signals")
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Display")
local DiscoveryTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/DiscoveryTypes")

local defineFastFlag = game:DefineFastFlag("LuaAppFixComputedSideMarginResponsiveBreakpoint", false)

local CollectionLayoutCalculators = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionLayoutCalculators")
require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionViewTypes")

local GAME_CAROUSEL_SIDE_COMPACT_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_COMPACT_PADDING
local GAME_CAROUSEL_SIDE_WIDE_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_WIDE_PADDING

local function useCollectionLayoutParamsComputed(instance, p2)
	local v5 = CollectionLayoutCalculators
	local v6 = useTokens()
	local v7 = usePreferredInput()
	local v8 = useAppPolicy(function(p3)
		return p3.useGridPageLayout()
	end)

	local v9, v10 = React.useMemo(function()
		return Signals.createSignal(false)
	end, {})

	local v12 = if defineFastFlag then Responsive.Keys.Small else Responsive.Keys.Medium
	v10((useBreakpointXOrSmaller(v12)))

	local v13 = React.useMemo(function()
		return Signals.createComputed(function(p3)
			local viewportSize = Display.GetDisplayStore(p3).getViewportSize(p3)

			return viewportSize and viewportSize.X or 0
		end)
	end, {})

	local v14, v15 = React.useMemo(function()
		local v16 = v13(false)
		return Signals.createSignal(v16)
	end, {})

	local v16 = React.useMemo(function()
		return Signals.createComputed(function(p3)
			if p2 then
				return p2
			end

			if v8 then
				local v17 = v13(p3)
				local v18 = v14(p3)
				return v5.calculateSideMargin(v18, v6, v17)
			elseif v9(p3) then
				return GAME_CAROUSEL_SIDE_COMPACT_PADDING
			else
				return GAME_CAROUSEL_SIDE_WIDE_PADDING
			end
		end)
	end, { v13, v14, v9, p2, v5, v6, v8 })

	local v17 = React.useMemo(function()
		return Signals.createComputed(function(p3)
			local v18 = v13(p3)
			local v19 = v14(p3)
			return v5.calculateColumnGap(v19, v6, v18)
		end)
	end, { v13, v14, v5, v6 })

	local v18 = React.useCallback(function(p3)
		return Signals.createComputed(function(p4)
			local v19 = v14(p4)
			local v20 = v16(p4)
			local v21 = v17(p4)

			return v5.calculateNumColumns(v19, v20, v21, p3, v6)
		end)
	end, { v14, v16, v17, v5, v6 })

	local v19 = React.useCallback(function(p3)
		v15(p3.X)
	end, { v15 })

	React.useEffect(function()
		local absoluteSizeChangedConnection

		if instance then
			v19(instance.AbsoluteSize)
			absoluteSizeChangedConnection = instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				v19(instance.AbsoluteSize)
			end)
		else
			absoluteSizeChangedConnection = nil
		end

		return function()
			if absoluteSizeChangedConnection then
				absoluteSizeChangedConnection:Disconnect()
			end
		end
	end, { v19, instance })

	return (React.useCallback(function(p3)
		return Signals.createComputed(function(p4)
			local v20 = v18(p3)(p4)
			local v21 = v17(p4)
			local v22 = v16(p4)

			return {
				numColumns = v20,
				fractionalItemAmount = v5.calculateFractionalItemAmount(p3, v7),
				columnGap = v21,
				sideMargin = v22,
				verticalPadding = v5.calculateVerticalPadding(v6, p3),
				maxTilesToShow = v5.calculateMaxTilesToShow(v7)
			}
		end)
	end, { v18, v17, v16, v7, v6, v5 }))
end

return useCollectionLayoutParamsComputed
