local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local CollectionViews = require(ProfilePlatformParent.CollectionViews)
local Foundation = require(ProfilePlatformParent.Foundation)
local Navigation = require(ProfilePlatformParent.Navigation)

require(ProfilePlatformParent.DataHydration.MomentsStoreTypes)

local MomentTile = require(script.Parent.MomentTile)
local MomentsCarouselMediaProvider = require(script.Parent.MomentsCarouselMediaProvider)
local getVisibleTileRange = require(script.Parent.getVisibleTileRange)
local useDynamicSizeMargin = require(ProfilePlatform.Hooks.useDynamicSizeMargin)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local Enums = require(ProfilePlatform.Common.Enums)
local CollectionCarousel = CollectionViews.CollectionCarousel
local useNavigationFocus = Navigation.useNavigationFocus
local useTokens = Foundation.Hooks.useTokens

local function MomentsCarousel(t1: {[any]: any}) -- line: 44
	-- upvalues: useTokens (copy), useProfileFormFactor (copy), Enums (copy), useNavigationFocus (copy), useDynamicSizeMargin (copy), React (copy), getVisibleTileRange (copy), MomentTile (copy), CollectionCarousel (copy), MomentsCarouselMediaProvider (copy)
	local moments = t1.moments
	local v19 = useTokens()
	local v20 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	local v21 = useNavigationFocus()
	local v22, v23 = useDynamicSizeMargin()
	local v24, v25 = React.useState(0)
	local v26, v27 = React.useState(1)
	local v28 = React.useRef(nil)
	local v29 = React.useRef(nil)
	local v30 = not v20 and 3 or 4
	local v31 = not v20 and 0.2 or nil
	local onTileImpression = t1.onTileImpression
	local v33 = React.useRef({})
	local v34 = React.useRef(nil)
	local v35 = React.useMemo(function() -- line: 69
		-- upvalues: moments (copy)
		for _, v44 in moments do
			if v44.metadata.captureType == Enum.CaptureType.Video then
				return true
			end
		end

		return false
	end, { moments })
	local v36 = moments[v26]
	local v37 = v36 ~= nil and v36.metadata.captureType == Enum.CaptureType.Video
	local v38 = React.useCallback(function(n1: number) -- line: 81
		-- upvalues: v25 (copy)
		v25(n1)

		return n1 * 1.5 + 48
	end, {})
	local v39 = React.useCallback(function() -- line: 90
		-- upvalues: onTileImpression (copy), v24 (copy), v28 (copy), getVisibleTileRange (copy), v30 (copy), v31 (copy), moments (copy), v33 (copy)
		if onTileImpression == nil or v24 <= 0 then
			return
		end

		local current = v28.current
		local v47 = current == nil and 0 or current.CanvasPosition.X
		local v48, v49 = getVisibleTileRange(v47, v24, 12, v30, v31, #moments)

		for i = v48, v49 do
			if not v33.current[i] then
				v33.current[i] = true
				onTileImpression(i)
			end
		end
	end, {
		onTileImpression,
		v24,
		v30,
		v31,
		#moments
	})

	React.useEffect(function() -- line: 106
		-- upvalues: v34 (copy), moments (copy), v33 (copy), v39 (copy)
		if v34.current ~= moments then
			v34.current = moments
			v33.current = {}
		end

		v39()
	end, {
		moments,
		v39
	})

	local v40 = React.useCallback(function() -- line: 117
		-- upvalues: v28 (copy), v24 (copy), v29 (copy), moments (copy), v27 (copy), v39 (copy)
		if v28.current == nil or v24 <= 0 then
			return
		end

		if v29.current ~= nil then
			task.cancel(v29.current)
		end

		v29.current = task.delay(0.2, function() -- line: 125
			-- upvalues: v29 (copy), v28 (copy), v24 (copy), moments (copy), v27 (copy), v39 (copy)
			v29.current = nil

			local current = v28.current

			if current == nil then
				return
			end

			local v55 = v24 + 12
			local v56 = math.clamp(math.round(current.CanvasPosition.X / v55) + 1, 1, #moments)

			v27(v56)
			v39()
		end)
	end, {
		v24,
		#moments,
		v39
	})

	React.useEffect(function() -- line: 140
		-- upvalues: v29 (copy)
		return function() -- line: 141
			-- upvalues: v29 (copy)
			if v29.current ~= nil then
				task.cancel(v29.current)
				v29.current = nil
			end
		end
	end, {})

	local v41 = React.useCallback(function(p1, n2: number, uDim2: UDim2) -- line: 149
		-- upvalues: React (copy), MomentTile (copy), v21 (copy), v26 (copy), t1 (copy)
		return React.createElement(MomentTile, {
			moment = p1,
			layoutOrder = n2,
			itemSize = uDim2,
			isActive = v21 and n2 == v26,
			onActivated = function() -- line: 155
				-- upvalues: t1 (copy), n2 (copy)
				t1.onSelectMoment(n2)
			end
		}), p1.momentId
	end, {
		v21,
		v26,
		t1.onSelectMoment
	})
	local v42 = React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.new(1, 0, 0, v24 * 1.5 + 48),
		[React.Change.AbsoluteSize] = v23
	}, {
		CollectionCarousel = React.createElement(CollectionCarousel, {
			LayoutOrder = 1,
			title = "Moments",
			columnGap = 12,
			items = moments,
			renderItem = v41,
			getItemHeight = v38,
			scrollingFrameRef = v28,
			onChangeCanvasPosition = v40,
			numColumns = v30,
			fractionalItemAmount = v31,
			sideMargin = v22,
			onActivateHeader = t1.onActivateHeader
		})
	})

	if v21 and v35 then
		return React.createElement(MomentsCarouselMediaProvider, {
			moments = moments,
			activeIndex = v26,
			playbackActive = v37,
			mediaCornerRadius = v19.Radius.Large
		}, {
			Carousel = v42
		})
	end

	return v42
end

return MomentsCarousel
