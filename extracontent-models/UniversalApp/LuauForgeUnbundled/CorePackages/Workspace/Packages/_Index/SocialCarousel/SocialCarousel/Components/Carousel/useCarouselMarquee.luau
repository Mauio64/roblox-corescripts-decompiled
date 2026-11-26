local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/CollectionViews")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Foundation")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RobloxAppHooks")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RobloxAppEnums")

local useMarqueeActiveTiles = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/Carousel/useMarqueeActiveTiles").useMarqueeActiveTiles
local MarqueeTextMotion = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/MarqueeText/MarqueeTextMotion")
local useNavigationFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Navigation").useNavigationFocus
local createMarqueeSessionStore = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Stores/MarqueeSession/createMarqueeSessionStore")

local getMarqueeSessionStore = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Stores/MarqueeSession/getMarqueeSessionStore").getMarqueeSessionStore
require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Stores/MarqueeSession/MarqueeScrollContext")
local tile = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Enums").Tile
local FFlagSocialCarouselFixColdStartJitter = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselFixColdStartJitter")
local fFlagSocialCarouselInGameTitleMarquee = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselInGameTitleMarquee

local v5 = {}

local function isHomeBlurredOrJoinCardOpen(p2, p3): boolean
	return p2 ~= true or p3 ~= nil
end

local function isIdleMarqueeEnabled(p2): boolean
	return p2 == RobloxAppEnums.DeviceType.Phone or p2 == RobloxAppEnums.DeviceType.Tablet
end

local function isDesktopHoverEnabled(p2, p3, p4): boolean
	return p2 == RobloxAppEnums.DeviceType.Desktop and p3 == true and p4 == nil
end

local function isConsoleFocusEnabled(p2, p3, p4): boolean
	return p2 == RobloxAppEnums.DeviceType.Console and p3 == true and p4 == nil
end

return {
	useCarouselMarquee = function(p2, list, p3, data, p4, p5, p6, p7)
		local v6 = RobloxAppHooks.useDeviceType()
		local reducedMotion = Foundation.Hooks.usePreferences().reducedMotion
		local v7 = useNavigationFocus()
		local v8 = v7 ~= true or p3 ~= nil
		local v9 = p7 == true
		local v10 = v9 and (v6 == RobloxAppEnums.DeviceType.Phone or v6 == RobloxAppEnums.DeviceType.Tablet)

		local v11 = if v9 then v6 == RobloxAppEnums.DeviceType.Desktop and v7 == true and p3 == nil else v9

		local v12 = if v9 then v6 == RobloxAppEnums.DeviceType.Console and v7 == true and p3 == nil else v9

		local v14 = v9 and (v6 == RobloxAppEnums.DeviceType.Phone or v6 == RobloxAppEnums.DeviceType.Tablet)

		local v15 = React.useMemo(function()
			return createMarqueeSessionStore()
		end, {})

		if v9 and p6 ~= nil then
			v15 = getMarqueeSessionStore(p6)
		end

		local ref = React.useRef(nil)
		local ref2 = React.useRef(false)
		local ref3 = React.useRef(0)

		if not ref2.current then
			ref2.current = true

			if v9 then
				ref3.current = v15.beginMount()
				local currentScroll = v15.getCurrentScroll()
				local heldScroll = v15.getHeldScroll()

				if v8 and currentScroll ~= nil then
					ref.current = currentScroll
					v15.holdCurrentScroll()
				elseif heldScroll ~= nil then
					ref.current = heldScroll
					v15.discardHeldScroll()
				end
			end
		end

		local ref4 = React.useRef(v15)
		ref4.current = v15
		local ref5 = React.useRef(v8)
		ref5.current = v8
		local ref6 = React.useRef(v9)
		ref6.current = v9

		local function fn()
			if v7 == true then
				if fFlagSocialCarouselInGameTitleMarquee and p5 ~= nil then
					p5.current = nil
				end

				v15.notifyHomeFocused()
			end
		end

		React.useEffect(fn, { v7, v15, if fFlagSocialCarouselInGameTitleMarquee then p5 else nil })

		React.useEffect(function()
			if not v9 then
				return
			end

			if v8 then
				v15.holdCurrentScroll()
			elseif v15.isCurrentMount(ref3.current) then
				v15.discardHeldScroll()
			end
		end, { v8, v15, v9, ref3 })
		React.useEffect(function()
			return function()
				if ref6.current ~= true or not ref5.current then
					return
				end

				if ref4.current.isCurrentMount(ref3.current) then
					ref4.current.holdCurrentScroll()
				end
			end
		end, {})
		local v18 = React.useMemo(function()
			if v9 then
				return {
					initialOffsetFor = function(p8)
						local current = ref.current

						if current == nil or current.tileId ~= p8 then
							return nil
						end

						return current.offset
					end,
					saveOffset = function(p8, p9)
						ref4.current.setCurrentScroll(p8, p9)
					end,
					clearCurrentScroll = function(p8)
						local current = ref.current

						if current ~= nil and current.tileId == p8 then
							ref.current = nil
						end

						ref4.current.clearCurrentScroll(p8)
					end
				}
			end

			return nil
		end, { v9, ref, ref4 })
		local v19 = React.useMemo(function()
			local result = {}

			if list == nil then
				return result
			end

			for i, item in ipairs(list) do
				local presence = item.presence

				local v20 = if item.tileType == tile.Friend and presence ~= nil and presence.userPresenceType == "InGame" then presence.lastLocation else nil

				table.insert(result, {
					id = item.id == nil and "" or item.id,
					tileType = item.tileType,
					subtitle = v20,
					presence = presence ~= nil and {
						userPresenceType = presence.userPresenceType,
						lastLocation = presence.lastLocation
					} or nil
				})
			end

			return result
		end, { list })

		local textDirectionFromLocale = MarqueeTextMotion.textDirectionFromLocale
		local LocalizationService = game:GetService("LocalizationService")
		local v20 = textDirectionFromLocale(LocalizationService.RobloxLocaleId)
		local v21 = not data.containerFrame and 0 or data.containerFrame.AbsoluteSize.X
		local v22 = if data.appCompositionEnabled then data.gutter else data.columnGap
		local v23 = data.appCompositionEnabled and 0 or data.sideMargin
		local v24

		if FFlagSocialCarouselFixColdStartJitter and not data.isColdStartLayoutReady then
			v24 = 0
		elseif data.showSkeleton then
			v24 = (data.itemsPerRow or data.defaultSkeletonCount) + 1
		else
			v24 = list and #list or 0
		end

		local v25 = math.min(data.maxTilesToShow or v24, v24)
		local v26 = data.appCompositionEnabled and 0 or data.fractionalItemAmount or 0
		local v27 = not ((data.itemsPerRow or 0) < v25) and 0 or v26
		local v28 = not data.appCompositionEnabled and 0 or data.carouselPeek
		local v29 = not (data.itemsPerRow > 0 and v21 > 0) and 0
			or CollectionViews.calculateItemWidth(data.itemsPerRow, v22 or 0, v23 or 0, v21, v27 or 0, v28 or 0)

		local v33 = {
			tileCount = (data.showSkeleton or not list) and 0 or #list,
			containerWidth = math.max(0, v21 - 2 * (v23 or 0)),
			tileWidth = v29,
			columnGap = v22 or 0,
			tiles = v19,
			direction = v20,
			reducedMotion = reducedMotion,
			idleSequenceEnabled = v10,
			manualMarqueeEnabled = v11 or v12,
			homeBlurredOrJoinCardOpen = v8,
			joinPopoverUserId = p3,
			joinPopoverUserIdRef = p4,
			joinSheetUserIdRef = p5,
			isDesktop = v6 == RobloxAppEnums.DeviceType.Desktop,
			loopsRemainingStore = v15,
			restoredTileId = 0,
			marqueeEnabled = 0
		}

		local v34 = if ref.current ~= nil then ref.current.tileId else nil
		v33.restoredTileId = v34
		v33.marqueeEnabled = v9
		local v35 = useMarqueeActiveTiles(p2, v33)

		local v37 = if v9 then v35.activeByIndex else v5
		local v36 = {
			activeByIndex = v37,
			isPaused = v35.isPaused or v8,
			onMarqueeFinished = 0,
			onManualMarqueeStart = 0,
			onManualMarqueeEnd = 0,
			marqueeRunId = 0,
			handsOff = 0,
			desktopEnabled = 0,
			consoleEnabled = 0,
			marqueeShortTitlesEnabled = 0,
			scrollContext = 0
		}
		local v38 = if v9 then v35.onMarqueeFinished else nil
		v36.onMarqueeFinished = v38
		local v39 = if v9 then v35.onManualMarqueeStart else nil
		v36.onManualMarqueeStart = v39
		local v40 = if v9 then v35.onManualMarqueeEnd else nil
		v36.onManualMarqueeEnd = v40
		local v41 = if v9 then v35.marqueeRunId else nil
		v36.marqueeRunId = v41
		v36.handsOff = v10
		v36.desktopEnabled = v11
		v36.consoleEnabled = v12
		v36.marqueeShortTitlesEnabled = v14
		v36.scrollContext = v18
		return v36
	end
}
