local CollectionViews = script:FindFirstAncestor("CollectionViews")
local CollectionViewsParent = CollectionViews.Parent
local React = require(CollectionViewsParent.React)
local useTokens = require(CollectionViewsParent.Foundation).Hooks.useTokens
local Responsive = require(CollectionViewsParent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local useAppPolicy = require(CollectionViewsParent.UniversalAppPolicy).useAppPolicy
local Signals = require(CollectionViewsParent.Signals)
local Display = require(CollectionViewsParent.Display)
local DiscoveryTypes = require(CollectionViewsParent.DiscoveryTypes)
local v12 = game:DefineFastFlag("LuaAppFixComputedSideMarginResponsiveBreakpoint", false)
local CollectionLayoutCalculators = require(CollectionViews.CollectionLayoutCalculators)

require(CollectionViews.CollectionViewTypes)

local GAME_CAROUSEL_SIDE_COMPACT_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_COMPACT_PADDING
local GAME_CAROUSEL_SIDE_WIDE_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_WIDE_PADDING

local function useCollectionLayoutParamsComputed(p1, n1: number?) -- line: 28
	-- upvalues: CollectionLayoutCalculators (copy), useTokens (copy), usePreferredInput (copy), useAppPolicy (copy), React (copy), Signals (copy), useBreakpointXOrSmaller (copy), v12 (copy), Responsive (copy), Display (copy), GAME_CAROUSEL_SIDE_COMPACT_PADDING (copy), GAME_CAROUSEL_SIDE_WIDE_PADDING (copy)
	local v19 = CollectionLayoutCalculators
	local v20 = useTokens()
	local v21 = usePreferredInput()
	local v22 = useAppPolicy(function(p2) -- line: 35
		return p2.useGridPageLayout()
	end)
	local v23, v24 = React.useMemo(function() -- line: 39
		-- upvalues: Signals (copy)
		return Signals.createSignal(false)
	end, {})

	v24((useBreakpointXOrSmaller(if not v12 then Responsive.Keys.Medium else Responsive.Keys.Small)))

	local v25 = React.useMemo(function() -- line: 47
		-- upvalues: Signals (copy), Display (copy)
		return Signals.createComputed(function(p3) -- line: 48
			-- upvalues: Display (copy)
			local v40 = Display.GetDisplayStore(p3).getViewportSize(p3)

			return v40 and v40.X or 0
		end)
	end, {})
	local v26, v27 = React.useMemo(function() -- line: 56
		-- upvalues: v25 (copy), Signals (copy)
		local v33 = v25(false)

		return Signals.createSignal(v33)
	end, {})
	local v28 = React.useMemo(function() -- line: 62
		-- upvalues: Signals (copy), n1 (copy), v22 (copy), v23 (copy), GAME_CAROUSEL_SIDE_COMPACT_PADDING (copy), GAME_CAROUSEL_SIDE_WIDE_PADDING (copy), v25 (copy), v26 (copy), v19 (copy), v20 (copy)
		return Signals.createComputed(function(p4) -- line: 63
			-- upvalues: n1 (copy), v22 (copy), v23 (copy), GAME_CAROUSEL_SIDE_COMPACT_PADDING (copy), GAME_CAROUSEL_SIDE_WIDE_PADDING (copy), v25 (copy), v26 (copy), v19 (copy), v20 (copy)
			if n1 then
				return n1
			end

			if not v22 then
				if v23(p4) then
					return GAME_CAROUSEL_SIDE_COMPACT_PADDING
				end

				return GAME_CAROUSEL_SIDE_WIDE_PADDING
			end

			local v42 = v25(p4)
			local v43 = v26(p4)

			return v19.calculateSideMargin(v43, v20, v42)
		end)
	end, {
		v25,
		v26,
		v23,
		n1,
		v19,
		v20,
		v22
	})
	local v29 = React.useMemo(function() -- line: 87
		-- upvalues: Signals (copy), v25 (copy), v26 (copy), v19 (copy), v20 (copy)
		return Signals.createComputed(function(p5) -- line: 88
			-- upvalues: v25 (copy), v26 (copy), v19 (copy), v20 (copy)
			local v45 = v25(p5)
			local v46 = v26(p5)

			return v19.calculateColumnGap(v46, v20, v45)
		end)
	end, {
		v25,
		v26,
		v19,
		v20
	})
	local v30 = React.useCallback(function(p6) -- line: 95
		-- upvalues: Signals (copy), v26 (copy), v28 (copy), v29 (copy), v19 (copy), v20 (copy)
		return Signals.createComputed(function(p7) -- line: 96
			-- upvalues: v26 (copy), v28 (copy), v29 (copy), v19 (copy), p6 (copy), v20 (copy)
			local v48 = v26(p7)
			local v49 = v28(p7)
			local v50 = v29(p7)

			return v19.calculateNumColumns(v48, v49, v50, p6, v20)
		end)
	end, {
		v26,
		v28,
		v29,
		v19,
		v20
	})
	local v31 = React.useCallback(function(vector2: Vector2) -- line: 105
		-- upvalues: v27 (copy)
		local vector2X = vector2.X

		v27(vector2X)
	end, { v27 })

	React.useEffect(function() -- line: 113
		-- upvalues: p1 (copy), v31 (copy)
		local connection = nil

		if p1 then
			v31(p1.AbsoluteSize)
			connection = p1:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 117
				-- upvalues: v31 (copy), p1 (copy)
				v31(p1.AbsoluteSize)
			end)
		end

		return function() -- line: 121
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, {
		v31,
		p1
	})

	return (React.useCallback(function(p8) -- line: 129
		-- upvalues: Signals (copy), v30 (copy), v29 (copy), v28 (copy), v19 (copy), v21 (copy), v20 (copy)
		return Signals.createComputed(function(p9) -- line: 130
			-- upvalues: v30 (copy), p8 (copy), v29 (copy), v28 (copy), v19 (copy), v21 (copy), v20 (copy)
			local v52 = v30(p8)(p9)
			local v53 = v29(p9)
			local v54 = v28(p9)
			local v55 = v19.calculateFractionalItemAmount(p8, v21)
			local v56 = v19.calculateVerticalPadding(v20, p8)
			local v57 = v19.calculateMaxTilesToShow(v21)

			return {
				numColumns = v52,
				fractionalItemAmount = v55,
				columnGap = v53,
				sideMargin = v54,
				verticalPadding = v56,
				maxTilesToShow = v57
			}
		end)
	end, {
		v30,
		v29,
		v28,
		v21,
		v20,
		v19
	}))
end

return useCollectionLayoutParamsComputed
