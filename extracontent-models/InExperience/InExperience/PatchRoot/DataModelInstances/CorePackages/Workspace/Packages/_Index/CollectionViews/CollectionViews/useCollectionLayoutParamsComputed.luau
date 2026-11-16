local CollectionViews = script:FindFirstAncestor("CollectionViews")
local parent = CollectionViews.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Responsive = require(parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local Signals = require(parent.Signals)
local Display = require(parent.Display)
local DiscoveryTypes = require(parent.DiscoveryTypes)

local defineFastFlag = game:DefineFastFlag("LuaAppFixComputedSideMarginResponsiveBreakpoint", false)

local CollectionLayoutCalculators = require(CollectionViews.CollectionLayoutCalculators)
require(CollectionViews.CollectionViewTypes)

local GAME_CAROUSEL_SIDE_COMPACT_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_COMPACT_PADDING
local GAME_CAROUSEL_SIDE_WIDE_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_WIDE_PADDING

local function useCollectionLayoutParamsComputed(instance, p: number?)
	local v = CollectionLayoutCalculators
	local v2 = useTokens()
	local v3 = usePreferredInput()
	local v4 = useAppPolicy(function(p2)
		return p2.useGridPageLayout()
	end)

	local v5, v6 = React.useMemo(function()
		return Signals.createSignal(false)
	end, {})
	local v7

	if defineFastFlag then
		v7 = Responsive.Keys.Small
	else
		v7 = Responsive.Keys.Medium
	end

	v6((useBreakpointXOrSmaller(v7)))

	local v8 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			local viewportSize = Display.GetDisplayStore(p2).getViewportSize(p2)

			return viewportSize and viewportSize.X or 0
		end)
	end, {})

	local v9, v10 = React.useMemo(function()
		local v9 = v8(false)
		return Signals.createSignal(v9)
	end, {})

	local v11 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			if p then
				return p
			end

			if v4 then
				local v11 = v8(p2)
				local v12 = v9(p2)
				return v.calculateSideMargin(v12, v2, v11)
			elseif v5(p2) then
				return GAME_CAROUSEL_SIDE_COMPACT_PADDING
			else
				return GAME_CAROUSEL_SIDE_WIDE_PADDING
			end
		end)
	end, { v8, v9, v5, p, v, v2, v4 })

	local v12 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			local v12 = v8(p2)
			local v13 = v9(p2)
			return v.calculateColumnGap(v13, v2, v12)
		end)
	end, { v8, v9, v, v2 })

	local v13 = React.useCallback(function(p2)
		return Signals.createComputed(function(p3)
			local v13 = v9(p3)
			local v14 = v11(p3)
			local v15 = v12(p3)

			return v.calculateNumColumns(v13, v14, v15, p2, v2)
		end)
	end, { v9, v11, v12, v, v2 })

	local v14 = React.useCallback(function(vector2: Vector2)
		v10(vector2.X)
	end, { v10 })

	React.useEffect(function()
		local absoluteSizeChangedConnection

		if instance then
			v14(instance.AbsoluteSize)
			absoluteSizeChangedConnection = instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				v14(instance.AbsoluteSize)
			end)
		else
			absoluteSizeChangedConnection = nil
		end

		return function()
			if absoluteSizeChangedConnection then
				absoluteSizeChangedConnection:Disconnect()
			end
		end
	end, { v14, instance })

	return (React.useCallback(function(p2)
		return Signals.createComputed(function(p3)
			local numColumns = v13(p2)(p3)
			local columnGap = v12(p3)
			local sideMargin = v11(p3)

			return {
				numColumns = numColumns,
				fractionalItemAmount = v.calculateFractionalItemAmount(p2, v3),
				columnGap = columnGap,
				sideMargin = sideMargin,
				verticalPadding = v.calculateVerticalPadding(v2, p2),
				maxTilesToShow = v.calculateMaxTilesToShow(v3)
			}
		end)
	end, { v13, v12, v11, v3, v2, v }))
end

return useCollectionLayoutParamsComputed
