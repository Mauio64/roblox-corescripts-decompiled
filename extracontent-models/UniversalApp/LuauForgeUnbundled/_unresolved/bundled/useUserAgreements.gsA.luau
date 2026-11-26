local module = require("@luauforge/bundled/gsB")
local useSelector = require("@luauforge/bundled/gsC").Hooks.RoactRodux.useSelector
local useDispatch = require("@luauforge/bundled/gsC").Hooks.RoactRodux.useDispatch
local useSignalState = require("@luauforge/bundled/gsD").useSignalState

local useRoactService = require("@luauforge/bundled/gsE").useRoactService
local roactNetworking = require("@luauforge/bundled/gsF").RoactNetworking
local roactAnalytics = require("@luauforge/bundled/gsF").RoactAnalytics
local appAppLifecycleObserverService = require("@luauforge/bundled/gsF").AppAppLifecycleObserverService

local loginStatus = require("@luauforge/bundled/gsG").LoginStatus

local fFlagUseSignalsForAuthenticationStatus = require("@luauforge/bundled/gsH").FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@luauforge/bundled/gsI").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local setCentralOverlay = require("@luauforge/bundled/gsJ").Actions.SetCentralOverlay
local centralOverlayType = require("@luauforge/bundled/gsG").CentralOverlayType
local module2 = require("@luauforge/bundled/gsK")

local useAppPolicy = require("@luauforge/bundled/gsO").useAppPolicy
local getFFlagUseUpdatedVNGAgreementsWorkflow = require("@luauforge/bundled/gsH").GetFFlagUseUpdatedVNGAgreementsWorkflow

local function selectIsUserLoggedIn(p2): boolean
	return p2.AuthenticationStatus.status == loginStatus.LOGGED_IN
end

local function showOverlay(callback, p2, list, p3)
	callback(setCentralOverlay(p2, { agreements = list, agreementAccepted = p3 }, {
		DisableBackButtonClose = true
	}))
end

local function shouldShowVngOverlay(items): boolean
	for k, item in items do
		if item.action == "ConvertToVngUser" then
			return true
		end
	end

	return false
end

local function useFetchAndHandle()
	local v5 = useRoactService(roactNetworking)
	local v6 = useRoactService(roactAnalytics)
	local v7 = useDispatch()
	local v8

	if getFFlagUseUpdatedVNGAgreementsWorkflow() then
		v8 = useAppPolicy(function(p2)
			return p2.getVNGFormRequired()
		end)
	else
		v8 = nil
	end

	local fn = getFFlagUseUpdatedVNGAgreementsWorkflow() and v8 and function()
		v7(setCentralOverlay(centralOverlayType.VngContactInfoFormWebviewPopup, {}, {
			DisableBackButtonClose = true
		}))
	end or function() end

	return module.useCallback(function()
		if not (v5 and v6 and v7) then
			return
		end

		if getFFlagUseUpdatedVNGAgreementsWorkflow() and v8 then
			v7(setCentralOverlay(centralOverlayType.VngComplianceLoadingPopup, {}, {
				DisableBackButtonClose = true
			}))
		end

		module2(v5, v6):andThen(function(list)
			if list and #list ~= 0 then
				local flag = true
				local v9

				for k, item in list do
					if item.action == "ConvertToVngUser" then
						v9 = true
						flag = false
						break
					end
				end

				if flag then
					v9 = false
				end

				if not v9 then
					showOverlay(v7, centralOverlayType.UserAgreementsUpdatedPopup, list, nil)
				elseif getFFlagUseUpdatedVNGAgreementsWorkflow() then
					showOverlay(v7, centralOverlayType.VNGUserAgreementsPopup, list, fn)
				else
					showOverlay(v7, centralOverlayType.VNGUserAgreementsPopup, list, function(p2)
						v7(setCentralOverlay(centralOverlayType.VngContactInfoFormWebviewPopup, {}))
					end)
				end
			elseif getFFlagUseUpdatedVNGAgreementsWorkflow() then
				fn()
			end
		end, function(p2)
			if getFFlagUseUpdatedVNGAgreementsWorkflow() then
				fn()
			end
		end)
	end, { v5, v6, v7 })
end

local function useFetchOnForegrounded()
	local v5 = useRoactService(appAppLifecycleObserverService)
	local v6

	if fFlagUseSignalsForAuthenticationStatus then
		v6 = useSignalState(getAuthenticationStatusStore(false).getStatus) == loginStatus.LOGGED_IN
	else
		v6 = useSelector(selectIsUserLoggedIn)
	end

	local v7 = useFetchAndHandle()

	module.useEffect(function()
		if v5 and v6 then
			local onBecomeActiveConnection = v5.OnBecomeActive:Connect(v7)
			return function()
				onBecomeActiveConnection:Disconnect()
			end
		end
	end, { v5, v6, v7 })
end

local function useFetchOnUserChanged()
	local v5 = useFetchAndHandle()
	local v6

	if fFlagUseSignalsForAuthenticationStatus then
		v6 = useSignalState(getAuthenticationStatusStore(false).getStatus) == loginStatus.LOGGED_IN
	else
		v6 = useSelector(selectIsUserLoggedIn)
	end

	local v7 = useAppPolicy(function(p2)
		return p2.getCheckUserAgreementsUpdatedOnLogin()
	end)

	local state, setState = module.useState(false)

	module.useEffect(function()
		if not v6 then
			setState(false)
		elseif v7 and not state then
			setState(true)
			v5()
		end
	end, { v5, v6, state, v7 })
end

local function useUserAgreements()
	useFetchOnUserChanged()
	useFetchOnForegrounded()
end

return useUserAgreements
