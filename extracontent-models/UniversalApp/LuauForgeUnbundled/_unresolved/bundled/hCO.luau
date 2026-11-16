local module = require("@luauforge/bundled/hCf")
local module2 = require("@luauforge/bundled/hCP")
local module3 = require("@luauforge/bundled/hCQ")
local module4 = require("@luauforge/bundled/hCD")
local fullscreenPageWithSafeArea = module2.FullscreenPageWithSafeArea
local module5 = require("@luauforge/bundled/hBs")
local module6 = require("@luauforge/bundled/hBq")
local memoize = require("@luauforge/bundled/hCR").memoize
local useNavigation = require("@luauforge/bundled/hBr").useNavigation
local module7 = require("@luauforge/bundled/hCe")
local module8 = require("@luauforge/bundled/hBp")
local useStyle = require("@luauforge/bundled/hCj").Core.Style.useStyle
local launchContext = require("@luauforge/bundled/hCS").Enums.LaunchContext
local useDispatch = require("@luauforge/bundled/hCt").Hooks.RoactRodux.useDispatch
local useRoactService = require("@luauforge/bundled/hCu").useRoactService
local useNavigationProps = require("@luauforge/bundled/hCT").useNavigationProps
local useAppPolicy = require("@luauforge/bundled/hCw").useAppPolicy
local module9 = require("@luauforge/bundled/hCx")
local roactNetworking = module9.RoactNetworking
local roactAnalytics = module9.RoactAnalytics
local module10 = require("@luauforge/bundled/hCn")
local module11 = require("@luauforge/bundled/hCh")
local user = module11.Thunks.User
local handleNewAuthCompletion = module3.HandleNewAuthCompletion
local appStorageUtilities = module11.Utils.AppStorageUtilities

local fullPageActivationFrameworkContextProvider = module5.Context.FullPageActivationFrameworkContextProvider
local namespace = module5.Enums.Namespace
local createActivationWorkflow = module5.Thunks.CreateActivationWorkflow
local payloadKey = module5.Enums.PayloadKey

local fStringLuaMultiPageSignupIxpLayer = module10.FStringLuaMultiPageSignupIxpLayer

local default = require("@luauforge/bundled/hCU").default
local telemetryConfigs = require("@luauforge/bundled/hCq").TelemetryConfigs

local v5 = memoize(function(p2, p3)
	local v7 = module8(module7(), p2, p3)
	return module6.createAppContainer(v7)
end)

return function(p2)
	local v6 = useNavigationProps(function(p3, p4)
		return {
			enforceResetState = p4.enforceResetState or false,
			credProtocolIsAvailableResponse = p4.credProtocolIsAvailableResponse
		}
	end)

	local v7 = module.useMemo(function()
		local v8

		if v6.credProtocolIsAvailableResponse and v6.credProtocolIsAvailableResponse.isAvailable ~= nil then
			local credProtocolIsAvailableResponse = v6.credProtocolIsAvailableResponse
			local v9 = false
			local v10 = false
			local v11

			if credProtocolIsAvailableResponse.FIDO2 == nil then
				if credProtocolIsAvailableResponse.isAvailable then
					v11 = credProtocolIsAvailableResponse.supportsDeviceBoundOnly or false
				else
					v11 = false
				end
			else
				v11 = credProtocolIsAvailableResponse.FIDO2.isAvailable
					and credProtocolIsAvailableResponse.FIDO2.supportsDeviceBoundOnly
				v10 = true
			end

			if credProtocolIsAvailableResponse.password ~= nil then
				v9 = credProtocolIsAvailableResponse.password.isAvailable
			end

			v8 = {}
			v8[payloadKey.CredentialsProtocolPasskeyRegistrationAvailable] = tostring(v11)
			v8[payloadKey.CredentialsProtocolPasswordRegistrationAvailable] = tostring(v9)
			v8[payloadKey.CredentialsProtocolV2InterfaceAvailable] = tostring(v10)
		else
			v8 = {}
		end

		local v9 = user.fromLocalStorage()

		if v9 and v9.userId ~= -1 then
			v8[payloadKey.PreviousUserId] = tostring(v9.userId)
		end

		return createActivationWorkflow(namespace.MultiPageSignup, v8, v6.enforceResetState)
	end, {})

	local shouldMultipageSignupEnableLeftRightAnimations = module4.useBrowserTrackerExperiment(
		{ fStringLuaMultiPageSignupIxpLayer },
		function(p3)
			return {
				shouldMultipageSignupEnableLeftRightAnimations = (p3[fStringLuaMultiPageSignupIxpLayer] or {}).shouldMultipageSignupEnableLeftRightAnimations or false
			}
		end
	).shouldMultipageSignupEnableLeftRightAnimations
	local v8 = v5(v7.state, shouldMultipageSignupEnableLeftRightAnimations)
	local v9 = useStyle()
	local v10 = useDispatch()
	local v11 = useNavigation()
	local v12 = useRoactService(roactAnalytics)

	local v13 = useRoactService(roactNetworking)
	local v14 = useAppPolicy(function(p3)
		return p3
	end)

	local function fn()
		return v10(p2.monoDeps.LaunchApp(v13, nil, v12, v14, launchContext.SignUp))
	end

	local function fn2()
		return v10(p2.monoDeps.ResetAppState())
	end

	local function onWorkflowComplete(p3)
		local v15 = p3[payloadKey.PreviousUserId]
		local incompleteSignupUserId = appStorageUtilities.getIncompleteSignupUserId()

		handleNewAuthCompletion(v15 ~= nil and v15 ~= "-1" and v15 ~= incompleteSignupUserId, fn2, fn, true)
	end

	module.useEffect(function()
		default:logRobloxTelemetryCounter(telemetryConfigs.SignupPageMountTelemetryConfig, 1, {
			version = 2
		})
	end, {})
	return module.createElement(fullPageActivationFrameworkContextProvider, {
		onClose = function()
			v11.goBack()
		end,
		onWorkflowComplete = onWorkflowComplete,
		initialActivationWorkflowState = v7,
		monoDeps = p2.monoDeps
	}, { module.createElement(
			fullscreenPageWithSafeArea,
			{
				includeStatusBar = true,
				BackgroundColor3 = v9.Theme.BackgroundDefault.Color,
				BorderSizePixel = 0
			},
			{ module.createElement(
					"Frame",
					{
						Size = UDim2.new(1, 0, 1, 0),
						Position = UDim2.new(0, 0, 0, 0),
						BorderSizePixel = 0,
						BackgroundTransparency = 1
					},
					{ module.createElement(v8) }
				) }
		) })
end
