local Parent = script:FindFirstAncestor("AppBlox").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local ReactUtils = require(Parent.ReactUtils)
local SharedFlags = require(Parent.SharedFlags)
local FFlagSduiExperienceDetailsSupport = SharedFlags.FFlagSduiExperienceDetailsSupport
local FFlagLuaAppClampBannerPaddingToViewport = SharedFlags.FFlagLuaAppClampBannerPaddingToViewport
local ScrollView = Foundation.ScrollView
local View = Foundation.View
local DetailsPageLayoutContext = require(script.Parent.DetailsPageLayoutContext)
local DetailsPageLayoutUtils = require(script.Parent.DetailsPageLayoutUtils)
local t1 = {
	Selectable = false
}
local v13 = if not FFlagLuaAppClampBannerPaddingToViewport then nil else React.createBinding(0)

local function DetailsPageLayoutContent(t2: {[any]: any}, p1) -- line: 39
	-- upvalues: React (copy), DetailsPageLayoutContext (copy), ReactUtils (copy), FFlagLuaAppClampBannerPaddingToViewport (copy), v13 (copy), DetailsPageLayoutUtils (copy), View (copy), ScrollView (copy), FFlagSduiExperienceDetailsSupport (copy), t1 (copy)
	local v17 = React.useContext(DetailsPageLayoutContext)
	local contentTopOffset = v17.contentTopOffset
	local hasFullBleed = v17.hasFullBleed
	local isFullscreen = v17.isFullscreen
	local isFullscreenOverlay = v17.isFullscreenOverlay
	local headerBarHeight = v17.headerBarHeight
	local hasHeader = v17.hasHeader
	local onCanvasPositionChanged = v17.onCanvasPositionChanged
	local fullBleedOverlapOffset = v17.fullBleedOverlapOffset
	local initialScrollY = v17.initialScrollY
	local hasValidContainerSize = v17.hasValidContainerSize
	local containerHeight = v17.containerHeight
	local onCanvasSizeChanged = v17.onCanvasSizeChanged
	local hasActions = v17.hasActions
	local actionBarHeight = v17.actionBarHeight
	local testId = v17.testId
	local gradientTopBleedOffset = v17.gradientTopBleedOffset

	assert(testId, "DetailsPageLayout.Content must be used within DetailsPageLayout.Root")

	local v34 = React.useCallback(function(p2) -- line: 61
		-- upvalues: initialScrollY (copy)
		if p2 and initialScrollY > 0 then
			p2.CanvasPosition = Vector2.new(0, initialScrollY)
		end
	end, { initialScrollY })
	local v35 = ReactUtils.useComposedRef(t2.scrollingFrameRef, v34)
	local v36, v37 = React.useBinding(initialScrollY)
	local v38, v39 = React.useBinding(0)
	local v40 = React.useCallback(function(p3) -- line: 74
		-- upvalues: v37 (copy), onCanvasPositionChanged (copy)
		v37(p3.CanvasPosition.Y)

		if onCanvasPositionChanged then
			onCanvasPositionChanged(p3)
		end
	end, { onCanvasPositionChanged })
	local v41 = React.useMemo(function() -- line: 84
		-- upvalues: hasHeader (copy), hasActions (copy), actionBarHeight (copy), React (copy), headerBarHeight (copy)
		if not hasHeader or (not hasActions or not actionBarHeight) then
			return nil
		end

		return React.joinBindings({
			hasHeader,
			hasActions,
			actionBarHeight
		}):map(function(t3: {[any]: any}) -- line: 88
			-- upvalues: headerBarHeight (copy)
			local v55 = t3[1]
			local v56 = t3[2]
			local v57 = t3[3]
			local v58 = not v55 and 0 or headerBarHeight
			local v59 = not v56 and 0 or v57

			return UDim2.new(1, 0, 1, -(v58 + v59))
		end)
	end, {
		hasHeader,
		hasActions,
		actionBarHeight,
		headerBarHeight
	})
	local v42 = React.useMemo(function() -- line: 98
		-- upvalues: hasHeader (copy), headerBarHeight (copy)
		if not hasHeader then
			return nil
		end

		return hasHeader:map(function(b1: boolean) -- line: 102
			-- upvalues: headerBarHeight (copy)
			return UDim2.new(0, 0, 0, not b1 and 0 or headerBarHeight)
		end)
	end, {
		hasHeader,
		headerBarHeight
	})
	local v43 = React.useMemo(function() -- line: 111
		-- upvalues: contentTopOffset (copy), FFlagLuaAppClampBannerPaddingToViewport (copy), React (copy), containerHeight (copy), v13 (copy), DetailsPageLayoutUtils (copy), hasFullBleed (copy), fullBleedOverlapOffset (copy), headerBarHeight (copy)
		if not contentTopOffset then
			return nil
		end

		if FFlagLuaAppClampBannerPaddingToViewport then
			return React.joinBindings({
				contentTopOffset,
				containerHeight or v13
			}):map(function(t4: {[any]: any}) -- line: 117
				-- upvalues: DetailsPageLayoutUtils (copy), hasFullBleed (copy), fullBleedOverlapOffset (copy), headerBarHeight (copy)
				local v62 = t4[1]
				local v63 = t4[2]
				local v64 = DetailsPageLayoutUtils.computeCanvasPaddingTop(v62, hasFullBleed, fullBleedOverlapOffset, headerBarHeight)

				if v63 > 0 then
					v64 = math.min(v64, v63 * 0.75)
				end

				return UDim.new(0, v64)
			end)
		end

		return contentTopOffset:map(function(n1: number) -- line: 132
			-- upvalues: DetailsPageLayoutUtils (copy), hasFullBleed (copy), fullBleedOverlapOffset (copy), headerBarHeight (copy)
			local v66 = DetailsPageLayoutUtils.computeCanvasPaddingTop(n1, hasFullBleed, fullBleedOverlapOffset, headerBarHeight)

			return UDim.new(0, v66)
		end)
	end, {
		contentTopOffset,
		if not FFlagLuaAppClampBannerPaddingToViewport then nil else containerHeight,
		hasFullBleed,
		fullBleedOverlapOffset,
		headerBarHeight
	})
	local v44 = React.useMemo(function() -- line: 151
		-- upvalues: hasActions (copy), actionBarHeight (copy), React (copy)
		if not hasActions or not actionBarHeight then
			return nil
		end

		return React.joinBindings({
			hasActions,
			actionBarHeight
		}):map(function(t5: {[any]: any}) -- line: 155
			local v68 = t5[1]
			local v69 = t5[2]

			if v68 then
				return (UDim.new(0, v69))
			end

			return (UDim.new(0, 0))
		end)
	end, {
		hasActions,
		actionBarHeight
	})
	local v45 = React.useMemo(function() -- line: 164
		-- upvalues: v43 (copy), React (copy), v36 (copy), gradientTopBleedOffset (copy)
		if not v43 then
			return nil
		end

		return React.joinBindings({
			v43,
			v36
		}):map(function(t6: {[any]: any}) -- line: 168
			-- upvalues: gradientTopBleedOffset (copy)
			local v71 = t6[1]
			local v72 = t6[2]

			return UDim2.new(0, 0, 0, v71.Offset - v72 - gradientTopBleedOffset)
		end)
	end, {
		v43,
		v36,
		gradientTopBleedOffset
	})
	local v46 = React.useMemo(function() -- line: 175
		-- upvalues: containerHeight (copy), React (copy), v38 (copy), gradientTopBleedOffset (copy)
		if not containerHeight then
			return nil
		end

		return React.joinBindings({
			v38,
			containerHeight
		}):map(function(t7: {[any]: any}) -- line: 179
			-- upvalues: gradientTopBleedOffset (copy)
			local v74 = t7[1]
			local v75 = t7[2]
			local v76 = if not (v74 > 0) then math.max(v75, 1) else v74

			return UDim2.new(1, 0, 0, v76 + gradientTopBleedOffset)
		end)
	end, {
		v38,
		containerHeight,
		gradientTopBleedOffset
	})

	if isFullscreen then
		assert(v41 and v42, "bindings required in fullscreen mode")

		return React.createElement(View, {
			ZIndex = 1,
			tag = "col bg-surface-0",
			Size = v41,
			Position = v42,
			testId = `{ testId }--content`,
			ref = p1
		}, {
			Children = React.createElement(React.Fragment, nil, t2.children)
		})
	end

	assert(v43 and (onCanvasPositionChanged and (containerHeight and (hasActions and actionBarHeight))), "DetailsPageLayout.Content requires bindings in scroll mode")

	if hasFullBleed and not hasValidContainerSize then
		return React.createElement(View, {
			tag = "size-full clip bg-surface-0",
			ZIndex = 1,
			testId = `{ testId }--content`,
			ref = p1
		})
	end

	local v47 = React.createElement(View, {
		tag = "col",
		ZIndex = 0,
		Position = v45,
		Size = v46
	}, {
		GradientBar = if not hasFullBleed or not contentTopOffset then nil else React.createElement(View, {
			tag = "bg-surface-0",
			LayoutOrder = 0,
			Size = contentTopOffset:map(function(n2: number) -- line: 229
				-- upvalues: fullBleedOverlapOffset (copy), gradientTopBleedOffset (copy)
				return UDim2.new(1, 0, 0, math.min(n2, fullBleedOverlapOffset) + gradientTopBleedOffset)
			end)
		}, {
			Gradient = React.createElement("UIGradient", {
				Rotation = 270,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(0.5, 0.25),
					NumberSequenceKeypoint.new(1, 1)
				})
			})
		}),
		SolidFill = React.createElement(View, {
			tag = "fill size-full-0 bg-surface-0",
			LayoutOrder = 1
		})
	})

	return React.createElement(View, {
		tag = "size-full clip",
		ZIndex = 1,
		ref = p1,
		testId = `{ testId }--content`
	}, {
		BackgroundLayers = v47,
		ScrollContent = React.createElement(ScrollView, {
			tag = "size-full clip",
			ZIndex = 1,
			scrollingFrameRef = v35,
			selection = if not FFlagSduiExperienceDetailsSupport then nil else t1,
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ScrollingEnabled = not isFullscreenOverlay
			},
			onAbsoluteCanvasSizeChanged = function(p4) -- line: 271
				-- upvalues: v39 (copy), onCanvasSizeChanged (copy)
				v39(p4.AbsoluteCanvasSize.Y)

				if onCanvasSizeChanged then
					local v52 = p4.AbsoluteCanvasSize.Y - p4.AbsoluteSize.Y

					onCanvasSizeChanged(v52)
				end
			end,
			onCanvasPositionChanged = v40
		}, React.createElement(View, {
			tag = "col size-full-0 auto-y"
		}, {
			CanvasPadding = React.createElement("UIPadding", {
				PaddingTop = v43,
				PaddingBottom = v44
			}),
			ContentSection = React.createElement(View, {
				tag = "auto-y",
				LayoutOrder = 1,
				Size = containerHeight:map(function(n3: number) -- line: 291
					return UDim2.new(1, 0, 0, n3)
				end)
			}, {
				ContentBackground = React.createElement(View, {
					tag = "col align-x-center size-full-0 auto-y"
				}, {
					Children = React.createElement(React.Fragment, nil, t2.children)
				})
			})
		}))
	})
end

return React.memo(React.forwardRef(DetailsPageLayoutContent))
