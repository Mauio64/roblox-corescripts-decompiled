local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local CollectionViews = require(ProfilePlatformParent.CollectionViews)
local Foundation = require(ProfilePlatformParent.Foundation)
local Navigation = require(ProfilePlatformParent.Navigation)

require(ProfilePlatformParent.DataHydration.MomentsStoreTypes)

local MomentTile = require(script.Parent.MomentTile)
local MomentsCarouselMediaProvider = require(script.Parent.MomentsCarouselMediaProvider)
local useDynamicSizeMargin = require(ProfilePlatform.Hooks.useDynamicSizeMargin)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local Enums = require(ProfilePlatform.Common.Enums)
local CollectionCarousel = CollectionViews.CollectionCarousel
local useNavigationFocus = Navigation.useNavigationFocus
local useTokens = Foundation.Hooks.useTokens

local function MomentsCarousel(t1: {[any]: any}) -- line: 40
	-- upvalues: useTokens (copy), useProfileFormFactor (copy), Enums (copy), useNavigationFocus (copy), useDynamicSizeMargin (copy), React (copy), MomentTile (copy), CollectionCarousel (copy), MomentsCarouselMediaProvider (copy)
	local moments = t1.moments
	local v18 = useTokens()
	local v19 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	local v20 = useNavigationFocus()
	local v21, v22 = useDynamicSizeMargin()
	local v23, v24 = React.useState(0)
	local v25, v26 = React.useState(1)
	local v27 = React.useRef(nil)
	local v28 = React.useRef(nil)
	local v29 = React.useMemo(function() -- line: 53
		-- upvalues: moments (copy)
		for _, v37 in moments do
			if v37.metadata.captureType == Enum.CaptureType.Video then
				return true
			end
		end

		return false
	end, { moments })
	local v30 = moments[v25]
	local v31 = v30 ~= nil and v30.metadata.captureType == Enum.CaptureType.Video
	local v32 = React.useCallback(function(n1: number) -- line: 65
		-- upvalues: v24 (copy)
		v24(n1)

		return n1 * 1.5 + 48
	end, {})
	local v33 = React.useCallback(function() -- line: 70
		-- upvalues: v27 (copy), v23 (copy), v28 (copy), moments (copy), v26 (copy)
		if v27.current == nil or v23 <= 0 then
			return
		end

		if v28.current ~= nil then
			task.cancel(v28.current)
		end

		v28.current = task.delay(0.2, function() -- line: 78
			-- upvalues: v28 (copy), v27 (copy), v23 (copy), moments (copy), v26 (copy)
			v28.current = nil

			local current = v27.current

			if current == nil then
				return
			end

			local v43 = v23 + 12
			local v44 = math.clamp(math.round(current.CanvasPosition.X / v43) + 1, 1, #moments)

			v26(v44)
		end)
	end, {
		v23,
		#moments
	})

	React.useEffect(function() -- line: 90
		-- upvalues: v28 (copy)
		return function() -- line: 91
			-- upvalues: v28 (copy)
			if v28.current ~= nil then
				task.cancel(v28.current)
				v28.current = nil
			end
		end
	end, {})

	local v34 = React.useCallback(function(p1, n2: number, uDim2: UDim2) -- line: 99
		-- upvalues: React (copy), MomentTile (copy), v20 (copy), v25 (copy), t1 (copy)
		return React.createElement(MomentTile, {
			moment = p1,
			layoutOrder = n2,
			itemSize = uDim2,
			isActive = v20 and n2 == v25,
			onActivated = function() -- line: 105
				-- upvalues: t1 (copy), n2 (copy)
				t1.onSelectMoment(n2)
			end
		}), p1.momentId
	end, {
		v20,
		v25,
		t1.onSelectMoment
	})
	local v35 = React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.new(1, 0, 0, v23 * 1.5 + 48),
		[React.Change.AbsoluteSize] = v22
	}, {
		CollectionCarousel = React.createElement(CollectionCarousel, {
			LayoutOrder = 1,
			title = "Moments",
			columnGap = 12,
			items = moments,
			renderItem = v34,
			getItemHeight = v32,
			scrollingFrameRef = v27,
			onChangeCanvasPosition = v33,
			numColumns = not v19 and 3 or 4,
			fractionalItemAmount = not v19 and 0.2 or nil,
			sideMargin = v21,
			onActivateHeader = t1.onActivateHeader
		})
	})

	if v20 and v29 then
		return React.createElement(MomentsCarouselMediaProvider, {
			moments = moments,
			activeIndex = v25,
			playbackActive = v31,
			mediaCornerRadius = v18.Radius.Large
		}, {
			Carousel = v35
		})
	end

	return v35
end

return MomentsCarousel
