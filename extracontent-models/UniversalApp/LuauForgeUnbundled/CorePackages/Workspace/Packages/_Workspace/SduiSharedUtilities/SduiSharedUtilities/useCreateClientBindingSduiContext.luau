local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Signals")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiCoreSystem")
local sduiLogger = SduiCoreSystem.SduiLogger
local sduiErrors = SduiCoreSystem.SduiErrors
local useCollectionLayoutConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/CollectionViews").useCollectionLayoutConfig
local getSduiServiceDependenciesStore = SduiCoreSystem.getSduiServiceDependenciesStore

local collectionItemSize = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/CollectionViews").CollectionViewTypes.CollectionItemSize

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags")
local fFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local fFlagLuaAppSduiVideoThumbnail = SharedFlags.FFlagLuaAppSduiVideoThumbnail
local fFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags.FFlagLuaAppOneByTwoHoverIdleAutoplay

local v5 = {
	numColumns = 3,
	fractionalItemAmount = 0,
	columnGap = 24,
	sideMargin = 24,
	verticalPadding = 16
}

local function useCreateClientBindingSduiContext(p2, p3, p4, p5, p6, p7, p8, p9, p10)
	local v6 = p8 or p2
	local v7 = nil
	local v8

	if fFlagLuaAppCompositionAlways then
		v8 = nil
	else
		v7 = useCollectionLayoutConfig(p3, p4)
		v8 = React.useCallback(function(p11)
			return Signals.createComputed(function(p12)
				if p7 ~= false then
					return v5
				end

				if v7 then
					return (v7[p11] or v7[collectionItemSize.Small])(p12)
				end

				sduiLogger.reportError(
					sduiErrors.SduiErrorType.NoPageLayoutConfig,
					{
						message = `No page layout config available for {p2}, returning default config`
					},
					p2
				)

				return v5
			end)
		end, { v7, p2, p7 })
	end

	local function fn()
		local v9 = {
			dependencies = getSduiServiceDependenciesStore().getDependencies(p2),
			appPage = p2,
			routeName = v6,
			getPageLayoutConfig = v8,
			appCompositionEnabled = p7 == nil or p7,
			dataUpdatedTimestamp = p5,
			configKey = p6,
			scrollAway = p9,
			videoPlaybackContext = 0
		}
		local v10 = if fFlagLuaAppSduiVideoThumbnail or fFlagLuaAppOneByTwoHoverIdleAutoplay then p10 else nil
		v9.videoPlaybackContext = v10
		return v9
	end

	local v11 = if fFlagLuaAppSduiVideoThumbnail or fFlagLuaAppOneByTwoHoverIdleAutoplay then p10 else nil
	return (React.useMemo(fn, { p2, v6, v8, p5, p6, p7, p9, v11 }))
end

return useCreateClientBindingSduiContext
