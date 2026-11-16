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
local Enums = require(SocialCarousel.Common.Enums)
local Tile = Enums.Tile
local FFlagSocialCarouselFixColdStartJitter = require(SocialCarousel.Flags.FFlagSocialCarouselFixColdStartJitter)

local function isOverlaySheetOpen(flag: boolean?, p: string?): boolean -- 1 equivalent call inferred from this helper
	return flag ~= true or p ~= nil
end

local function isIdleMarqueeEnabled(p): boolean -- 1 equivalent call inferred from this helper
	return p == RobloxAppEnums.DeviceType.Phone or p == RobloxAppEnums.DeviceType.Tablet
end

local function isDesktopHoverEnabled(p, flag: boolean, p2: string?): boolean -- 1 equivalent call inferred from this helper
	return p == RobloxAppEnums.DeviceType.Desktop and flag == true and p2 == nil
end

local function isConsoleFocusEnabled(p, flag: boolean, p2: string?): boolean -- 1 equivalent call inferred from this helper
	return p == RobloxAppEnums.DeviceType.Console and flag == true and p2 == nil
end

return {
	useCarouselMarquee = function(p, list, p2: string?, data)
		local v = RobloxAppHooks.useDeviceType()
		local reducedMotion = Foundation.Hooks.usePreferences().reducedMotion
		local idleMarqueeEnabled = isIdleMarqueeEnabled(v) -- inferred equivalent call
		local v2 = useNavigationFocus()
		local overlaySheetOpen = isOverlaySheetOpen(v2, p2) -- inferred equivalent call
		local desktopHoverEnabled = isDesktopHoverEnabled(v, v2, p2) -- inferred equivalent call
		local consoleFocusEnabled = isConsoleFocusEnabled(v, v2, p2) -- inferred equivalent call
		local loopsRemainingStore = React.useMemo(function()
			return createMarqueeSessionStore()
		end, {})

		React.useEffect(function()
			if v2 == true then
				loopsRemainingStore.notifyHomeFocused()
			end
		end, { v2, loopsRemainingStore })
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
		local v3 = not data.containerFrame and 0 or data.containerFrame.AbsoluteSize.X
		local v4

		if data.appCompositionEnabled then
			v4 = data.gutter
		else
			v4 = data.columnGap
		end

		local v5 = data.appCompositionEnabled and 0 or data.sideMargin
		local v6

		if FFlagSocialCarouselFixColdStartJitter and not data.isColdStartLayoutReady then
			v6 = 0
		elseif data.showSkeleton then
			v6 = (data.itemsPerRow or data.defaultSkeletonCount) + 1
		else
			v6 = list and #list or 0
		end

		local v7 = math.min(data.maxTilesToShow or v6, v6)
		local v8 = data.appCompositionEnabled and 0 or data.fractionalItemAmount or 0
		local v9 = not ((data.itemsPerRow or 0) < v7) and 0 or v8
		local v10 = not data.appCompositionEnabled and 0 or data.carouselPeek
		local tileWidth = not (data.itemsPerRow > 0 and v3 > 0) and 0
			or CollectionViews.calculateItemWidth(data.itemsPerRow, v4 or 0, v5 or 0, v3, v9 or 0, v10 or 0)

		local v11 = useMarqueeActiveTiles2(p, {
			tileCount = (data.showSkeleton or not list) and 0 or #list,
			containerWidth = math.max(0, v3 - 2 * (v5 or 0)),
			tileWidth = tileWidth,
			columnGap = v4 or 0,
			tiles = tiles,
			direction = direction,
			reducedMotion = reducedMotion,
			idleSequenceEnabled = idleMarqueeEnabled,
			manualMarqueeEnabled = desktopHoverEnabled or consoleFocusEnabled,
			loopsRemainingStore = loopsRemainingStore
		})

		return {
			activeByIndex = v11.activeByIndex,
			isPaused = v11.isPaused or overlaySheetOpen,
			onMarqueeFinished = v11.onMarqueeFinished,
			onManualMarqueeStart = v11.onManualMarqueeStart,
			onManualMarqueeEnd = v11.onManualMarqueeEnd,
			marqueeRunId = v11.marqueeRunId,
			handsOff = idleMarqueeEnabled,
			desktopEnabled = desktopHoverEnabled,
			consoleEnabled = consoleFocusEnabled
		}
	end
}
