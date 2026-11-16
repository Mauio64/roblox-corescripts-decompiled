local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local SharedFlags = require(parent.SharedFlags)
local Loggers = require(parent.Loggers)
local v = Loggers.Logger:new("Moments.Gating")

local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local FFlagArgoEnableMoments = SharedFlags.FFlagArgoEnableMoments
local FFlagMomentsCreationFeatureGate = SharedFlags.FFlagMomentsCreationFeatureGate
local defineFastFlag = game:DefineFastFlag("DebugMomentsGating", false)
local FFlagFlyoutRemoveMomentsForArgoEnabled = SharedFlags.FFlagFlyoutRemoveMomentsForArgoEnabled

local GetMomentsCapabilities = require(MomentsCommon.Stores.GetMomentsCapabilities)
local getIsSupportedOnPlatform

if FFlagFlyoutRemoveMomentsForArgoEnabled then
	getIsSupportedOnPlatform = require(MomentsCommon.Utils.getIsSupportedOnPlatform)
else
	getIsSupportedOnPlatform = nil
end

local function useMomentsGating()
	local isMasterEnabled = FFlagEnableArgus

	local momentsCapabilities = GetMomentsCapabilities(false)
	local isAmpPolicyEnabled = useSignalState(momentsCapabilities.getHasMomentsAccess)
	local v2 = useSignalState(momentsCapabilities.getIsInfluencerContentEnabled)
	local v3

	if FFlagMomentsCreationFeatureGate then
		v3 = useSignalState(momentsCapabilities.getCanCreateMoments)
	else
		v3 = nil
	end

	local isSupportedOnPlatform

	if FFlagFlyoutRemoveMomentsForArgoEnabled then
		isSupportedOnPlatform = getIsSupportedOnPlatform()
	else
		isSupportedOnPlatform = false
	end

	local v4 = isMasterEnabled and isAmpPolicyEnabled

	local useMemo = React.useMemo
	local function fn()
		return {
			isMasterEnabled = isMasterEnabled,
			isAmpPolicyEnabled = isAmpPolicyEnabled,
			isMomentsEnabled = v4,
			isSupportedOnPlatform = isSupportedOnPlatform,
			isFlyoutEntryEnabled = v4,
			isTabEnabled = FFlagArgoEnableMoments and v4,
			isCreationEnabled = v4 and (not FFlagMomentsCreationFeatureGate or v3),
			platformIntegrationEnabled = v4,
			influencerUploadsEnabled = v4 and v2
		}
	end

	local v5 = if FFlagMomentsCreationFeatureGate then v3 else false
	local v6 = useMemo(fn, {
		isMasterEnabled,
		isAmpPolicyEnabled,
		v4,
		isSupportedOnPlatform,
		isAmpPolicyEnabled,
		v2,
		v5
	})

	React.useEffect(function()
		if not defineFastFlag then
			return
		end

		v:debug(
			"Moments.Gating master={} ampPolicy={} moments={} supportedOnPlatform={} platformIntegration={} influencerUploads={} creation={} flyout={} tab={} forceAll={}",
			tostring(v6.isMasterEnabled),
			tostring(v6.isAmpPolicyEnabled),
			tostring(v6.isMomentsEnabled),
			tostring(v6.isSupportedOnPlatform),
			tostring(v6.platformIntegrationEnabled),
			tostring(v6.influencerUploadsEnabled),
			tostring(v6.isCreationEnabled),
			tostring(v6.isFlyoutEntryEnabled),
			tostring(v6.isTabEnabled),
			(tostring(FFlagArgoEnableMoments))
		)
	end, { defineFastFlag, v6 })

	return v6
end

return useMomentsGating
