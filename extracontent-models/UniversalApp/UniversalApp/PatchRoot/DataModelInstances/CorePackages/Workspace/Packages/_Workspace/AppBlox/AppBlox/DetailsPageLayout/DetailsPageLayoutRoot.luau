local Parent = script:FindFirstAncestor("AppBlox").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Responsive = require(Parent.Responsive)
local SharedFlags = require(Parent.SharedFlags)
local Display = require(Parent.Display)
local AppNavBar = require(Parent.AppNavBar)
local View = Foundation.View
local withDefaults = Foundation.Utility.withDefaults
local useTokens = Foundation.Hooks.useTokens
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useDeviceInsets = Responsive.useDeviceInsets
local useNavBarSize = AppNavBar.useNavBarSize
local useNavBarPlacement = AppNavBar.useNavBarPlacement
local CompositionTags = require(Parent.AppComposition).CompositionTags
local DetailsPageLayoutContext = require(script.Parent.DetailsPageLayoutContext)
local DetailsPageLayoutUtils = require(script.Parent.DetailsPageLayoutUtils)
local FFlagSduiExperienceDetailsSupport = SharedFlags.FFlagSduiExperienceDetailsSupport
local FFlagLuaAppClampBannerPaddingToViewport = SharedFlags.FFlagLuaAppClampBannerPaddingToViewport
local FFlagDetailsPageLayoutSeedContainerSize = SharedFlags.FFlagDetailsPageLayoutSeedContainerSize
local t1 = {
	testId = "app-blox-details-page",
	fullBleedAspectRatio = 1.7777777777777777,
	fullBleedOverlapOffset = 180
}

local function DetailsPageLayoutRoot(t2: {[any]: any}, p1) -- line: 68
	-- upvalues: useDeviceInsets (copy), useTokens (copy), withDefaults (copy), t1 (copy), CompositionTags (copy), React (copy), Responsive (copy), FFlagDetailsPageLayoutSeedContainerSize (copy), useNavBarSize (copy), useNavBarPlacement (copy), Display (copy), AppNavBar (copy), DetailsPageLayoutUtils (copy), FFlagLuaAppClampBannerPaddingToViewport (copy), DetailsPageLayoutContext (copy), View (copy), StateLayerAffordance (copy), FFlagSduiExperienceDetailsSupport (copy)
	local v25 = useDeviceInsets()
	local v26 = useTokens()
	local v27 = withDefaults(t2, t1)
	local v28 = v27.compositionLayoutTag or CompositionTags.Layout.Detail
	local fullBleedAspectRatio = v27.fullBleedAspectRatio
	local v30 = (fullBleedAspectRatio == nil or not (fullBleedAspectRatio > 0)) and 1.7777777777777777 or fullBleedAspectRatio
	local v31 = v27.fullBleedContent ~= nil and not v27.isFullscreen
	local v32, v33 = React.useBinding(false)
	local v34, v35 = React.useBinding(false)
	local v36, v37 = React.useBinding(0)
	local UIScale = v26.Config.UI.Scale
	local v39 = v27.fullBleedOverlapOffset * UIScale
	local v40 = if not v27.gradientTopBleedOffset then v26.Size.Size_2000 else v27.gradientTopBleedOffset * UIScale
	local v41 = v26.Size.Size_1000 + v26.Padding.Large + v26.Padding.Medium
	local v42 = ((if not Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small) then v26.Size.Size_2000 else v41)) + v25.top
	local v43, v44 = React.useState(nil)
	local v45 = v43 ~= nil
	local v46, v47 = React.useState(nil)
	local v48, v49 = React.useState(false)
	local v50 = not v31 or (v48 or v45)
	local containerSize = nil
	local n1 = 0

	if FFlagDetailsPageLayoutSeedContainerSize then
		local v53 = useNavBarSize()
		local v54 = useNavBarPlacement()
		local v55 = React.useMemo(function() -- line: 119
			-- upvalues: Display (copy), v54 (copy), AppNavBar (copy), v53 (copy), v31 (copy), DetailsPageLayoutUtils (copy), v30 (copy), v42 (copy), v39 (copy), t2 (copy)
			local v77 = Display.GetDisplayStore(false).getViewportSize(false)
			local v78 = if v54 ~= AppNavBar.Placement.Left then v77.X else math.max(0, v77.X - v53)
			local vector2 = Vector2.new(v78, v77.Y)
			local v80 = not v31 and 0 or DetailsPageLayoutUtils.computeInitialScrollYForSize(vector2, {
				fullBleedAspectRatio = v30,
				headerBarHeight = v42,
				fullBleedOverlapOffset = v39,
				hasFullBleed = v31,
				bannerBottomVisiblePercent = t2.bannerBottomVisiblePercent
			})

			return {
				containerSize = vector2,
				initialScrollY = v80
			}
		end, {})

		containerSize = v55.containerSize
		n1 = v55.initialScrollY
	end

	local v56, v57 = React.useBinding(if not FFlagDetailsPageLayoutSeedContainerSize then Vector2.new(0, 0) else containerSize)
	local v58, v59 = React.useBinding(not FFlagDetailsPageLayoutSeedContainerSize and 0 or n1)
	local v60, v61 = React.useBinding(0)
	local v62, v63 = React.useState(not FFlagDetailsPageLayoutSeedContainerSize and 0 or n1)
	local v64, v65 = React.useState(not not FFlagDetailsPageLayoutSeedContainerSize)
	local v66 = React.useRef(not not FFlagDetailsPageLayoutSeedContainerSize and v31)
	local v67 = v56:map(function(vector2: Vector2) -- line: 157
		return vector2.Y
	end)
	local v68 = v56:map(function(vector2: Vector2) -- line: 161
		-- upvalues: v30 (copy)
		return UDim2.new(0, vector2.X, 0, vector2.X / v30)
	end)
	local v69 = v56:map(function(vector2: Vector2) -- line: 167
		-- upvalues: v31 (copy), DetailsPageLayoutUtils (copy), v30 (copy), v42 (copy)
		if not v31 then
			return 0
		end

		return DetailsPageLayoutUtils.computeContentTopOffset(vector2.X, v30, v42)
	end)
	local v70 = React.joinBindings({
		v69,
		v58
	}):map(function(p2) -- line: 176
		-- upvalues: v42 (copy)
		local v85 = p2[1]
		local v86 = p2[2]
		local v87 = math.max(0, v85 + v42 - v86) / 2

		return UDim2.new(0.5, 0, 0, v87)
	end)
	local v71 = React.joinBindings({
		v58,
		v69,
		v60
	}):map(function(p3) -- line: 186
		-- upvalues: DetailsPageLayoutUtils (copy), v42 (copy), v39 (copy)
		local v89 = p3[1]
		local v90 = p3[2]
		local v91 = p3[3]

		if v90 == 0 then
			return (math.clamp(v89 / DetailsPageLayoutUtils.getNoBannerFadeParams(v42), 0, 1))
		end

		local v92, v93 = DetailsPageLayoutUtils.getHeaderFadeParams(v90, v91, v39)

		return (math.clamp((v89 - v92) / v93, 0, 1))
	end)
	local v72 = React.useCallback(function(p4) -- line: 202
		-- upvalues: v57 (copy), v65 (copy), v31 (copy), v66 (copy), FFlagDetailsPageLayoutSeedContainerSize (copy), DetailsPageLayoutUtils (copy), v30 (copy), v42 (copy), v39 (copy), t2 (copy), FFlagLuaAppClampBannerPaddingToViewport (copy), v63 (copy), v59 (copy)
		local AbsoluteSize = p4.AbsoluteSize

		v57(AbsoluteSize)

		if AbsoluteSize.X > 0 and AbsoluteSize.Y > 0 then
			v65(true)

			if v31 and not v66.current then
				v66.current = true

				local v96

				if FFlagDetailsPageLayoutSeedContainerSize then
					v96 = DetailsPageLayoutUtils.computeInitialScrollYForSize(AbsoluteSize, {
						fullBleedAspectRatio = v30,
						headerBarHeight = v42,
						fullBleedOverlapOffset = v39,
						hasFullBleed = v31,
						bannerBottomVisiblePercent = t2.bannerBottomVisiblePercent
					})
				else
					local v97 = AbsoluteSize.X / v30
					local v98 = if t2.bannerBottomVisiblePercent == nil then DetailsPageLayoutUtils.computeInitialScrollY(AbsoluteSize.X, v30, v42, v39) else math.max(0, (math.floor(v97 - t2.bannerBottomVisiblePercent * v97)))
					local v99 = DetailsPageLayoutUtils.computeContentTopOffset(AbsoluteSize.X, v30, v42)
					local v100 = DetailsPageLayoutUtils.computeCanvasPaddingTop(v99, v31, v39, v42)

					if FFlagLuaAppClampBannerPaddingToViewport then
						v100 = math.min(v100, AbsoluteSize.Y * 0.75)
					end

					v96 = math.min(v98, (math.max(0, v100 - v42)))
				end

				v63(v96)
				v59(v96)
			end
		end
	end, {
		v31,
		v30,
		v42,
		v39,
		t2.bannerBottomVisiblePercent,
		if not FFlagDetailsPageLayoutSeedContainerSize then nil else containerSize
	})
	local v73 = React.useRef(0)
	local v74 = React.useCallback(function(n2: number) -- line: 264
		-- upvalues: v73 (copy), v61 (copy)
		if math.abs(n2 - v73.current) > 0.5 then
			v73.current = n2
			v61(n2)
		end
	end, {})
	local v75 = React.useCallback(function(p5) -- line: 271
		-- upvalues: v59 (copy), v31 (copy), v69 (copy), v60 (copy), DetailsPageLayoutUtils (copy), v39 (copy), v49 (copy)
		local CanvasPositionY = p5.CanvasPosition.Y

		v59(CanvasPositionY)

		if v31 then
			local v104 = v69:getValue()
			local v105 = v60:getValue()
			local v106, v107 = DetailsPageLayoutUtils.getHeaderFadeParams(v104, v105, v39)

			v49(DetailsPageLayoutUtils.shouldShowStickyBar(CanvasPositionY, v104, v106, v107))
		end
	end, {
		v31,
		v39
	})
	local v76 = React.useMemo(function() -- line: 293
		-- upvalues: v31 (copy), v32 (copy), v33 (copy), v34 (copy), v35 (copy), v27 (copy), v42 (copy), v36 (copy), v37 (copy), v75 (copy), v69 (copy), v39 (copy), v40 (copy), v62 (copy), v64 (copy), v67 (copy), v71 (copy), v50 (copy), v74 (copy), v45 (copy), v44 (copy), v46 (copy), v47 (copy)
		return {
			hasFullBleed = v31,
			hasHeader = v32,
			setHasHeader = v33,
			hasActions = v34,
			setHasActions = v35,
			isFullscreen = v27.isFullscreen,
			headerBarHeight = v42,
			actionBarHeight = v36,
			setActionBarHeight = v37,
			onCanvasPositionChanged = v75,
			contentTopOffset = v69,
			fullBleedOverlapOffset = v39,
			gradientTopBleedOffset = v40,
			initialScrollY = v62,
			hasValidContainerSize = v64,
			containerHeight = v67,
			headerOpacity = v71,
			stickyHeaderActive = v50,
			onClose = v27.onClose,
			testId = v27.testId,
			onCanvasSizeChanged = v74,
			isFullscreenOverlay = v45,
			setFullscreenContent = v44,
			onExitFullscreenOverlay = v46,
			setOnExitFullscreenOverlay = v47
		}
	end, {
		v31,
		v27.isFullscreen,
		v42,
		v39,
		v40,
		v62,
		v64,
		v50,
		v27.onClose,
		v27.testId,
		v67,
		v71,
		v75,
		v74,
		v45,
		v46
	})

	return React.createElement(DetailsPageLayoutContext.Provider, {
		value = v76
	}, React.createElement(View, {
		tag = `size-full clip bg-surface-0 { v28 }`,
		stateLayer = {
			affordance = StateLayerAffordance.None
		},
		onAbsoluteSizeChanged = v72,
		ref = p1,
		selectionGroup = v27.selectionGroup,
		testId = `{ v27.testId }--root`
	}, {
		FullBleed = if not v31 then nil else React.createElement(View, {
			tag = "position-top-center anchor-top-center size-full clip",
			ZIndex = 0,
			testId = `{ v27.testId }--fullbleed`
		}, {
			ParallaxFrame = React.createElement(View, {
				tag = "anchor-center-center clip",
				Position = v70,
				Size = v68
			}, v27.fullBleedContent)
		}),
		Children = React.createElement(React.Fragment, nil, v27.children),
		FullscreenOverlay = if not v45 then nil else React.createElement(View, {
			ZIndex = 10,
			tag = "clip",
			Size = if not FFlagSduiExperienceDetailsSupport then UDim2.new(1, 0, 1, -v42) else v32:map(function(b1: boolean) -- line: 371
				-- upvalues: v42 (copy)
				if b1 then
					return (UDim2.new(1, 0, 1, -v42))
				end

				return (UDim2.fromScale(1, 1))
			end),
			Position = if not FFlagSduiExperienceDetailsSupport then UDim2.fromOffset(0, v42) else v32:map(function(b2: boolean) -- line: 376
				-- upvalues: v42 (copy)
				if b2 then
					return (UDim2.fromOffset(0, v42))
				end

				return (UDim2.fromOffset(0, 0))
			end),
			testId = `{ v27.testId }--fullscreen-overlay`
		}, v43)
	}))
end

return React.memo(React.forwardRef(DetailsPageLayoutRoot))
