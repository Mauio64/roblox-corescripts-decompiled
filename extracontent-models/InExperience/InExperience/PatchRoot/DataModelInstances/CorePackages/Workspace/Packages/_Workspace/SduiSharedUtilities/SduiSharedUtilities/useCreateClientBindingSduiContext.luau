local parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local React = require(parent.React)
local Signals = require(parent.Signals)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiLogger = SduiCoreSystem.SduiLogger
local SduiErrors = SduiCoreSystem.SduiErrors
local CollectionViews = require(parent.CollectionViews)
local useCollectionLayoutConfig = CollectionViews.useCollectionLayoutConfig
local getSduiServiceDependenciesStore = SduiCoreSystem.getSduiServiceDependenciesStore

local CollectionViews2 = require(parent.CollectionViews)
local CollectionItemSize = CollectionViews2.CollectionViewTypes.CollectionItemSize

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local FFlagLuaAppSduiVideoThumbnail = SharedFlags.FFlagLuaAppSduiVideoThumbnail
local FFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags.FFlagLuaAppOneByTwoHoverIdleAutoplay

local v = {
	numColumns = 3,
	fractionalItemAmount = 0,
	columnGap = 24,
	sideMargin = 24,
	verticalPadding = 16
}

local function useCreateClientBindingSduiContext(appPage: string, p, p2: number?, dataUpdatedTimestamp: number?, configKey: string?, flag: boolean?, p3: string?, scrollAway, p4)
	local routeName = p3 or appPage
	local v2 = nil
	local getPageLayoutConfig

	if FFlagLuaAppCompositionAlways then
		getPageLayoutConfig = nil
	else
		v2 = useCollectionLayoutConfig(p, p2)
		getPageLayoutConfig = React.useCallback(function(p5)
			return Signals.createComputed(function(p6)
				if flag ~= false then
					return v
				end

				if v2 then
					return (v2[p5] or v2[CollectionItemSize.Small])(p6)
				end

				SduiLogger.reportError(
					SduiErrors.SduiErrorType.NoPageLayoutConfig,
					{
						message = `No page layout config available for {appPage}, returning default config`
					},
					appPage
				)

				return v
			end)
		end, { v2, appPage, flag })
	end

	local useMemo = React.useMemo
	local function fn()
		local v3 = {
			dependencies = getSduiServiceDependenciesStore().getDependencies(appPage),
			appPage = appPage,
			routeName = routeName,
			getPageLayoutConfig = getPageLayoutConfig,
			appCompositionEnabled = flag == nil or flag,
			dataUpdatedTimestamp = dataUpdatedTimestamp,
			configKey = configKey,
			scrollAway = scrollAway,
			videoPlaybackContext = 0
		}
		local videoPlaybackContext

		if FFlagLuaAppSduiVideoThumbnail or FFlagLuaAppOneByTwoHoverIdleAutoplay then
			videoPlaybackContext = p4
		end

		v3.videoPlaybackContext = videoPlaybackContext
		return v3
	end

	local v3

	if FFlagLuaAppSduiVideoThumbnail or FFlagLuaAppOneByTwoHoverIdleAutoplay then
		v3 = p4
	end

	return (useMemo(fn, {
		appPage,
		routeName,
		getPageLayoutConfig,
		dataUpdatedTimestamp,
		configKey,
		flag,
		scrollAway,
		v3
	}))
end

return useCreateClientBindingSduiContext
