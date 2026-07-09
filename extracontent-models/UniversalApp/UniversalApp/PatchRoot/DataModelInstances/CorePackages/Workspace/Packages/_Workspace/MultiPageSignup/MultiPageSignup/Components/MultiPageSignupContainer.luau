local MultiPageSignup = script:FindFirstAncestor("MultiPageSignup")
local MultiPageSignupParent = MultiPageSignup.Parent
local React = require(MultiPageSignupParent.React)
local AppBlox = require(MultiPageSignupParent.AppBlox)
local AccountSwitching = require(MultiPageSignupParent.AccountSwitching)
local RoactAppExperiment = require(MultiPageSignupParent.RoactAppExperiment)
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea
local UserActivationFramework = require(MultiPageSignupParent.UserActivationFramework)
local RoactNavigation = require(MultiPageSignupParent.RoactNavigation)
local memoize = require(MultiPageSignupParent.AppCommonLib).memoize
local useNavigation = require(MultiPageSignupParent.Navigation).useNavigation
local getMultipageSignupRoutes = require(MultiPageSignup.Navigation.getMultipageSignupRoutes)
local createMultiPageSignupNavigator = require(MultiPageSignup.Navigation.createMultiPageSignupNavigator)
local useStyle = require(MultiPageSignupParent.UIBlox).Core.Style.useStyle
local LaunchContext = require(MultiPageSignupParent.AppStartup).Enums.LaunchContext
local useDispatch = require(MultiPageSignupParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(MultiPageSignupParent.RobloxAppHooks).useRoactService
local useNavigationProps = require(MultiPageSignupParent.RobloxAppNavigation).useNavigationProps
local useAppPolicy = require(MultiPageSignupParent.UniversalAppPolicy).useAppPolicy
local RoactServiceTags = require(MultiPageSignupParent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local SharedFlags = require(MultiPageSignupParent.SharedFlags)
local AuthCommon = require(MultiPageSignupParent.AuthCommon)
local User = AuthCommon.Thunks.User
local HandleNewAuthCompletion = AccountSwitching.HandleNewAuthCompletion
local AppStorageUtilities = AuthCommon.Utils.AppStorageUtilities
local FullPageActivationFrameworkContextProvider = UserActivationFramework.Context.FullPageActivationFrameworkContextProvider
local Namespace = UserActivationFramework.Enums.Namespace
local CreateActivationWorkflow = UserActivationFramework.Thunks.CreateActivationWorkflow
local PayloadKey = UserActivationFramework.Enums.PayloadKey
local FStringLuaMultiPageSignupIxpLayer = SharedFlags.FStringLuaMultiPageSignupIxpLayer
local default = require(MultiPageSignupParent.LoggingProtocol).default
local TelemetryConfigs = require(MultiPageSignupParent.AuthAnalytics).TelemetryConfigs
local v35 = memoize(function(p1, b1: boolean) -- line: 59
	-- upvalues: getMultipageSignupRoutes (copy), createMultiPageSignupNavigator (copy), RoactNavigation (copy)
	local v38 = getMultipageSignupRoutes()
	local v39 = createMultiPageSignupNavigator(v38, p1, b1)

	return RoactNavigation.createAppContainer(v39)
end)

return function(t1: {[any]: any}) -- line: 66
	-- upvalues: useNavigationProps (copy), React (copy), PayloadKey (copy), User (copy), CreateActivationWorkflow (copy), Namespace (copy), RoactAppExperiment (copy), FStringLuaMultiPageSignupIxpLayer (copy), v35 (copy), useStyle (copy), useDispatch (copy), useNavigation (copy), useRoactService (copy), RoactAnalytics (copy), RoactNetworking (copy), useAppPolicy (copy), LaunchContext (copy), AppStorageUtilities (copy), HandleNewAuthCompletion (copy), default (copy), TelemetryConfigs (copy), FullPageActivationFrameworkContextProvider (copy), FullscreenPageWithSafeArea (copy)
	local v41 = useNavigationProps(function(_: string, t2: {[any]: any}) -- line: 67
		return {
			enforceResetState = t2.enforceResetState or false,
			credProtocolIsAvailableResponse = t2.credProtocolIsAvailableResponse
		}
	end)
	local v42 = React.useMemo(function() -- line: 97
		-- upvalues: v41 (copy), PayloadKey (copy), User (copy), CreateActivationWorkflow (copy), Namespace (copy)
		local t3 = {}

		if v41.credProtocolIsAvailableResponse and v41.credProtocolIsAvailableResponse.isAvailable ~= nil then
			local credProtocolIsAvailableResponse = v41.credProtocolIsAvailableResponse
			local v61 = false
			local v62 = false
			local v63

			if credProtocolIsAvailableResponse.FIDO2 ~= nil then
				v63 = credProtocolIsAvailableResponse.FIDO2.isAvailable and credProtocolIsAvailableResponse.FIDO2.supportsDeviceBoundOnly
				v62 = true
			else
				v63 = not not credProtocolIsAvailableResponse.isAvailable and (credProtocolIsAvailableResponse.supportsDeviceBoundOnly or false)
			end

			if credProtocolIsAvailableResponse.password ~= nil then
				v61 = credProtocolIsAvailableResponse.password.isAvailable
			end

			t3 = {
				[PayloadKey.CredentialsProtocolPasskeyRegistrationAvailable] = tostring(v63),
				[PayloadKey.CredentialsProtocolPasswordRegistrationAvailable] = tostring(v61),
				[PayloadKey.CredentialsProtocolV2InterfaceAvailable] = tostring(v62)
			}
		end

		local v64 = User.fromLocalStorage()

		if v64 and v64.userId ~= -1 then
			t3[PayloadKey.PreviousUserId] = tostring(v64.userId)
		end

		return CreateActivationWorkflow(Namespace.MultiPageSignup, t3, v41.enforceResetState)
	end, {})
	local shouldMultipageSignupEnableLeftRightAnimations = RoactAppExperiment.useBrowserTrackerExperiment({ FStringLuaMultiPageSignupIxpLayer }, function(p2) -- line: 121
		-- upvalues: FStringLuaMultiPageSignupIxpLayer (copy)
		return {
			shouldMultipageSignupEnableLeftRightAnimations = (p2[FStringLuaMultiPageSignupIxpLayer] or {}).shouldMultipageSignupEnableLeftRightAnimations or false
		}
	end).shouldMultipageSignupEnableLeftRightAnimations
	local v44 = v35(v42.state, shouldMultipageSignupEnableLeftRightAnimations)
	local v45 = useStyle()
	local v46 = useDispatch()
	local v47 = useNavigation()
	local v48 = useRoactService(RoactAnalytics)
	local v49 = useRoactService(RoactNetworking)
	local v50 = useAppPolicy(function(p3) -- line: 137
		return p3
	end)

	local function v51() -- line: 145
		-- upvalues: v46 (copy), t1 (copy), v49 (copy), v48 (copy), v50 (copy), LaunchContext (copy)
		return v46(t1.monoDeps.LaunchApp(v49, nil, v48, v50, LaunchContext.SignUp))
	end
	local function v52() -- line: 149
		-- upvalues: v46 (copy), t1 (copy)
		return v46(t1.monoDeps.ResetAppState())
	end

	React.useEffect(function() -- line: 164
		-- upvalues: default (copy), TelemetryConfigs (copy)
		default:logRobloxTelemetryCounter(TelemetryConfigs.SignupPageMountTelemetryConfig, 1, {
			version = 2
		})
	end, {})

	return React.createElement(FullPageActivationFrameworkContextProvider, {
		onClose = function() -- line: 141
			-- upvalues: v47 (copy)
			v47.goBack()
		end,
		onWorkflowComplete = function(t4: {[any]: any}) -- line: 153
			-- upvalues: PayloadKey (copy), AppStorageUtilities (copy), HandleNewAuthCompletion (copy), v52 (copy), v51 (copy)
			local v68 = t4[PayloadKey.PreviousUserId]
			local v69 = AppStorageUtilities.getIncompleteSignupUserId()
			local v70 = v68 ~= nil and (v68 ~= "-1" and v68 ~= v69)

			HandleNewAuthCompletion(v70, v52, v51, true)
		end,
		initialActivationWorkflowState = v42,
		monoDeps = t1.monoDeps
	}, { React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BorderSizePixel = 0,
		BackgroundColor3 = v45.Theme.BackgroundDefault.Color
	}, { React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0)
	}, { React.createElement(v44) }) }) })
end
