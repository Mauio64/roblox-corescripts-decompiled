local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local React = require(parent.React)
local CollectionViews = require(parent.CollectionViews)
local Foundation = require(parent.Foundation)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local RobloxAppEnums = require(parent.RobloxAppEnums)

local useMarqueeActiveTiles = require(script.Parent.useMarqueeActiveTiles)
local useMarqueeActiveTiles2 = useMarqueeActiveTiles.useMarqueeActiveTiles
local MarqueeTextMotion = require(SocialCarousel.Components.MarqueeText.MarqueeTextMotion)
local Navigation = require(parent.Navigation)
local useNavigationFocus = Navigation.useNavigationFocus
local createMarqueeSessionStore = require(SocialCarousel.Stores.MarqueeSession.createMarqueeSessionStore)

local getMarqueeSessionStore = require(SocialCarousel.Stores.MarqueeSession.getMarqueeSessionStore)
local getMarqueeSessionStore2 = getMarqueeSessionStore.getMarqueeSessionStore
require(SocialCarousel.Stores.MarqueeSession.MarqueeScrollContext)
local Enums = require(SocialCarousel.Common.Enums)
local Tile = Enums.Tile
local FFlagSocialCarouselFixColdStartJitter = require(SocialCarousel.Flags.FFlagSocialCarouselFixColdStartJitter)
local SharedFlags = require(parent.SharedFlags)
local FFlagSocialCarouselInGameTitleMarquee = SharedFlags.FFlagSocialCarouselInGameTitleMarquee

local v = {}

local function isHomeBlurredOrJoinCardOpen(flag: boolean?, p: string?): boolean -- 1 equivalent call inferred from this helper
	return flag ~= true or p ~= nil
end

local function isIdleMarqueeEnabled(p): boolean -- 2 equivalent calls inferred from this helper
	return p == RobloxAppEnums.DeviceType.Phone or p == RobloxAppEnums.DeviceType.Tablet
end

local function isDesktopHoverEnabled(p, flag: boolean, p2: string?): boolean -- 1 equivalent call inferred from this helper
	return p == RobloxAppEnums.DeviceType.Desktop and flag == true and p2 == nil
end

local function isConsoleFocusEnabled(p, flag: boolean, p2: string?): boolean -- 1 equivalent call inferred from this helper
	return p == RobloxAppEnums.DeviceType.Console and flag == true and p2 == nil
end

return {
	useCarouselMarquee = function(p, list, joinPopoverUserId: string?, data, joinPopoverUserIdRef, joinSheetUserIdRef, p2: string?, flag: boolean?)
		local v2 = RobloxAppHooks.useDeviceType()
		local reducedMotion = Foundation.Hooks.usePreferences().reducedMotion
		local v3 = useNavigationFocus()
		local homeBlurredOrJoinCardOpen = isHomeBlurredOrJoinCardOpen(v3, joinPopoverUserId) -- inferred equivalent call
		local v4 = flag == true
		local v5 = v4 and isIdleMarqueeEnabled(v2) -- inferred equivalent call
		local desktopEnabled

		if v4 then
			desktopEnabled = isDesktopHoverEnabled(v2, v3, joinPopoverUserId) -- inferred equivalent call
		else
			desktopEnabled = v4
		end

		local consoleEnabled

		if v4 then
			consoleEnabled = isConsoleFocusEnabled(v2, v3, joinPopoverUserId) -- inferred equivalent call
		else
			consoleEnabled = v4
		end

		local marqueeShortTitlesEnabled = v4 and isIdleMarqueeEnabled(v2) -- inferred equivalent call
		local v6 = React.useMemo(function()
			return createMarqueeSessionStore()
		end, {})

		if v4 and p2 ~= nil then
			v6 = getMarqueeSessionStore2(p2)
		end

		local ref = React.useRef(nil)
		local ref2 = React.useRef(false)
		local ref3 = React.useRef(0)

		if not ref2.current then
			ref2.current = true

			if v4 then
				ref3.current = v6.beginMount()
				local currentScroll = v6.getCurrentScroll()
				local heldScroll = v6.getHeldScroll()

				if homeBlurredOrJoinCardOpen and currentScroll ~= nil then
					ref.current = currentScroll
					v6.holdCurrentScroll()
				elseif heldScroll ~= nil then
					ref.current = heldScroll
					v6.discardHeldScroll()
				end
			end
		end

		local ref4 = React.useRef(v6)
		ref4.current = v6
		local ref5 = React.useRef(homeBlurredOrJoinCardOpen)
		ref5.current = homeBlurredOrJoinCardOpen
		local ref6 = React.useRef(v4)
		ref6.current = v4

		local useEffect = React.useEffect
		local function fn()
			if v3 == true then
				if FFlagSocialCarouselInGameTitleMarquee and joinSheetUserIdRef ~= nil then
					joinSheetUserIdRef.current = nil
				end

				v6.notifyHomeFocused()
			end
		end

		local v7

		if FFlagSocialCarouselInGameTitleMarquee then
			v7 = joinSheetUserIdRef
		end

		useEffect(fn, { v3, v6, v7 })

		React.useEffect(function()
			if not v4 then
				return
			end

			if homeBlurredOrJoinCardOpen then
				v6.holdCurrentScroll()
			elseif v6.isCurrentMount(ref3.current) then
				v6.discardHeldScroll()
			end
		end, { homeBlurredOrJoinCardOpen, v6, v4, ref3 })
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
		local scrollContext = React.useMemo(function()
			if v4 then
				return {
					initialOffsetFor = function(p3: string)
						local current = ref.current

						if current == nil or current.tileId ~= p3 then
							return nil
						end

						return current.offset
					end,
					saveOffset = function(p3: string, p4: number)
						ref4.current.setCurrentScroll(p3, p4)
					end,
					clearCurrentScroll = function(p3: string)
						local current = ref.current

						if current ~= nil and current.tileId == p3 then
							ref.current = nil
						end

						ref4.current.clearCurrentScroll(p3)
					end
				}
			end

			return nil
		end, { v4, ref, ref4 })
		local tiles = React.useMemo(function()
			local result = {}

			if list == nil then
				return result
			end

			for _, item in ipairs(list) do
				local presence = item.presence
				local subtitle

				if item.tileType == Tile.Friend and presence ~= nil and presence.userPresenceType == "InGame" then
					subtitle = presence.lastLocation
				end

				table.insert(result, {
					id = item.id == nil and "" or item.id,
					tileType = item.tileType,
					subtitle = subtitle,
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
		local direction = textDirectionFromLocale(LocalizationService.RobloxLocaleId)
		local v8 = not data.containerFrame and 0 or data.containerFrame.AbsoluteSize.X
		local v9

		if data.appCompositionEnabled then
			v9 = data.gutter
		else
			v9 = data.columnGap
		end

		local v10 = data.appCompositionEnabled and 0 or data.sideMargin
		local v11

		if FFlagSocialCarouselFixColdStartJitter and not data.isColdStartLayoutReady then
			v11 = 0
		elseif data.showSkeleton then
			v11 = (data.itemsPerRow or data.defaultSkeletonCount) + 1
		else
			v11 = list and #list or 0
		end

		local v12 = math.min(data.maxTilesToShow or v11, v11)
		local v13 = data.appCompositionEnabled and 0 or data.fractionalItemAmount or 0
		local v14 = not ((data.itemsPerRow or 0) < v12) and 0 or v13
		local v15 = not data.appCompositionEnabled and 0 or data.carouselPeek
		local tileWidth = not (data.itemsPerRow > 0 and v8 > 0) and 0
			or CollectionViews.calculateItemWidth(data.itemsPerRow, v9 or 0, v10 or 0, v8, v14 or 0, v15 or 0)

		local v16 = {
			tileCount = (data.showSkeleton or not list) and 0 or #list,
			containerWidth = math.max(0, v8 - 2 * (v10 or 0)),
			tileWidth = tileWidth,
			columnGap = v9 or 0,
			tiles = tiles,
			direction = direction,
			reducedMotion = reducedMotion,
			idleSequenceEnabled = v5,
			manualMarqueeEnabled = desktopEnabled or consoleEnabled,
			homeBlurredOrJoinCardOpen = homeBlurredOrJoinCardOpen,
			joinPopoverUserId = joinPopoverUserId,
			joinPopoverUserIdRef = joinPopoverUserIdRef,
			joinSheetUserIdRef = joinSheetUserIdRef,
			isDesktop = v2 == RobloxAppEnums.DeviceType.Desktop,
			loopsRemainingStore = v6,
			restoredTileId = 0,
			marqueeEnabled = 0
		}
		local restoredTileId

		if ref.current ~= nil then
			restoredTileId = ref.current.tileId
		end

		v16.restoredTileId = restoredTileId
		v16.marqueeEnabled = v4
		local v17 = useMarqueeActiveTiles2(p, v16)

		local activeByIndex = if v4 then v17.activeByIndex else v
		local v18 = {
			activeByIndex = activeByIndex,
			isPaused = v17.isPaused or homeBlurredOrJoinCardOpen,
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
		local onMarqueeFinished

		if v4 then
			onMarqueeFinished = v17.onMarqueeFinished
		end

		v18.onMarqueeFinished = onMarqueeFinished
		local onManualMarqueeStart

		if v4 then
			onManualMarqueeStart = v17.onManualMarqueeStart
		end

		v18.onManualMarqueeStart = onManualMarqueeStart
		local onManualMarqueeEnd

		if v4 then
			onManualMarqueeEnd = v17.onManualMarqueeEnd
		end

		v18.onManualMarqueeEnd = onManualMarqueeEnd
		local marqueeRunId

		if v4 then
			marqueeRunId = v17.marqueeRunId
		end

		v18.marqueeRunId = marqueeRunId
		v18.handsOff = v5
		v18.desktopEnabled = desktopEnabled
		v18.consoleEnabled = consoleEnabled
		v18.marqueeShortTitlesEnabled = marqueeShortTitlesEnabled
		v18.scrollContext = scrollContext
		return v18
	end
}
