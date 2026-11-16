local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/SignalsReact").useSignalState
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/SharedFlags")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Loggers").Logger:new("Moments.Gating")

local fFlagEnableArgus = SharedFlags.FFlagEnableArgus
local fFlagArgoEnableMoments = SharedFlags.FFlagArgoEnableMoments
local fFlagMomentsCreationFeatureGate = SharedFlags.FFlagMomentsCreationFeatureGate
local defineFastFlag = game:DefineFastFlag("DebugMomentsGating", false)
local fFlagFlyoutRemoveMomentsForArgoEnabled = SharedFlags.FFlagFlyoutRemoveMomentsForArgoEnabled

local GetMomentsCapabilities = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Stores/GetMomentsCapabilities")

local v6 = if fFlagFlyoutRemoveMomentsForArgoEnabled then require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Utils/getIsSupportedOnPlatform") else nil

local function useMomentsGating()
	local v7 = fFlagEnableArgus

	local v8 = GetMomentsCapabilities(false)
	local v9 = useSignalState(v8.getHasMomentsAccess)
	local v10 = useSignalState(v8.getIsInfluencerContentEnabled)

	local v11 = if fFlagMomentsCreationFeatureGate then useSignalState(v8.getCanCreateMoments) else nil

	local v12 = if fFlagFlyoutRemoveMomentsForArgoEnabled then v6() else false
	local v13 = v7 and v9

	local function fn()
		return {
			isMasterEnabled = v7,
			isAmpPolicyEnabled = v9,
			isMomentsEnabled = v13,
			isSupportedOnPlatform = v12,
			isFlyoutEntryEnabled = v13,
			isTabEnabled = fFlagArgoEnableMoments and v13,
			isCreationEnabled = v13 and (not fFlagMomentsCreationFeatureGate or v11),
			platformIntegrationEnabled = v13,
			influencerUploadsEnabled = v13 and v10
		}
	end

	local v16 = React.useMemo(fn, {
		v7,
		v9,
		v13,
		v12,
		v9,
		v10,
		if fFlagMomentsCreationFeatureGate then v11 else false
	})

	React.useEffect(function()
		if not defineFastFlag then
			return
		end

		v5:debug(
			"Moments.Gating master={} ampPolicy={} moments={} supportedOnPlatform={} platformIntegration={} influencerUploads={} creation={} flyout={} tab={} forceAll={}",
			tostring(v16.isMasterEnabled),
			tostring(v16.isAmpPolicyEnabled),
			tostring(v16.isMomentsEnabled),
			tostring(v16.isSupportedOnPlatform),
			tostring(v16.platformIntegrationEnabled),
			tostring(v16.influencerUploadsEnabled),
			tostring(v16.isCreationEnabled),
			tostring(v16.isFlyoutEntryEnabled),
			tostring(v16.isTabEnabled),
			(tostring(fFlagArgoEnableMoments))
		)
	end, { defineFastFlag, v16 })

	return v16
end

return useMomentsGating
