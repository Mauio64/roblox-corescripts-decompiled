local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/CollectionViews")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Foundation")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RobloxAppHooks")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RobloxAppEnums")

local useMarqueeActiveTiles = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/Carousel/useMarqueeActiveTiles").useMarqueeActiveTiles
local MarqueeTextMotion = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/MarqueeText/MarqueeTextMotion")
local useNavigationFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Navigation").useNavigationFocus
local createMarqueeSessionStore = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Stores/MarqueeSession/createMarqueeSessionStore")
local tile = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Enums").Tile
local FFlagSocialCarouselFixColdStartJitter = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselFixColdStartJitter")

local function isOverlaySheetOpen(p2, p3): boolean
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
	useCarouselMarquee = function(p2, list, p3, data)
		local v5 = RobloxAppHooks.useDeviceType()
		local reducedMotion = Foundation.Hooks.usePreferences().reducedMotion
		local v6 = v5 == RobloxAppEnums.DeviceType.Phone or v5 == RobloxAppEnums.DeviceType.Tablet

		local v7 = useNavigationFocus()
		local v8 = v7 ~= true or p3 ~= nil
		local v9 = v5 == RobloxAppEnums.DeviceType.Desktop and v7 == true and p3 == nil

		local v10 = v5 == RobloxAppEnums.DeviceType.Console and v7 == true and p3 == nil

		local v12 = React.useMemo(function()
			return createMarqueeSessionStore()
		end, {})

		React.useEffect(function()
			if v7 == true then
				v12.notifyHomeFocused()
			end
		end, { v7, v12 })
		local v13 = React.useMemo(function()
			local result = {}

			if list == nil then
				return result
			end

			for i, item in ipairs(list) do
				local presence = item.presence

				local v14 = if item.tileType == tile.Friend and presence ~= nil and presence.userPresenceType == "InGame" then presence.lastLocation else nil

				table.insert(result, {
					id = item.id == nil and "" or item.id,
					tileType = item.tileType,
					subtitle = v14,
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
		local v14 = textDirectionFromLocale(LocalizationService.RobloxLocaleId)
		local v15 = not data.containerFrame and 0 or data.containerFrame.AbsoluteSize.X
		local v16 = if data.appCompositionEnabled then data.gutter else data.columnGap
		local v17 = data.appCompositionEnabled and 0 or data.sideMargin
		local v18

		if FFlagSocialCarouselFixColdStartJitter and not data.isColdStartLayoutReady then
			v18 = 0
		elseif data.showSkeleton then
			v18 = (data.itemsPerRow or data.defaultSkeletonCount) + 1
		else
			v18 = list and #list or 0
		end

		local v19 = math.min(data.maxTilesToShow or v18, v18)
		local v20 = data.appCompositionEnabled and 0 or data.fractionalItemAmount or 0
		local v21 = not ((data.itemsPerRow or 0) < v19) and 0 or v20
		local v22 = not data.appCompositionEnabled and 0 or data.carouselPeek
		local v23 = not (data.itemsPerRow > 0 and v15 > 0) and 0
			or CollectionViews.calculateItemWidth(data.itemsPerRow, v16 or 0, v17 or 0, v15, v21 or 0, v22 or 0)

		local v26 = useMarqueeActiveTiles(p2, {
			tileCount = (data.showSkeleton or not list) and 0 or #list,
			containerWidth = math.max(0, v15 - 2 * (v17 or 0)),
			tileWidth = v23,
			columnGap = v16 or 0,
			tiles = v13,
			direction = v14,
			reducedMotion = reducedMotion,
			idleSequenceEnabled = v6,
			manualMarqueeEnabled = v9 or v10,
			loopsRemainingStore = v12
		})

		return {
			activeByIndex = v26.activeByIndex,
			isPaused = v26.isPaused or v8,
			onMarqueeFinished = v26.onMarqueeFinished,
			onManualMarqueeStart = v26.onManualMarqueeStart,
			onManualMarqueeEnd = v26.onManualMarqueeEnd,
			marqueeRunId = v26.marqueeRunId,
			handsOff = v6,
			desktopEnabled = v9,
			consoleEnabled = v10
		}
	end
}
