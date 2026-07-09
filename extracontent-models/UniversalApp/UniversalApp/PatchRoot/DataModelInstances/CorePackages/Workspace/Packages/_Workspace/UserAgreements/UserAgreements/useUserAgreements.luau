local Parent = script:FindFirstAncestor("UserAgreements").Parent
local React = require(Parent.React)
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local RoactNetworking = require(Parent.RoactServiceTags).RoactNetworking
local RoactAnalytics = require(Parent.RoactServiceTags).RoactAnalytics
local AppAppLifecycleObserverService = require(Parent.RoactServiceTags).AppAppLifecycleObserverService
local LoginStatus = require(Parent.RobloxAppEnums).LoginStatus
local SetCentralOverlay = require(Parent.CentralOverlay).Actions.SetCentralOverlay
local CentralOverlayType = require(Parent.RobloxAppEnums).CentralOverlayType
local FetchUpdatedUserAgreements = require(script.Parent.FetchUpdatedUserAgreements)
local useAppPolicy = require(Parent.UniversalAppPolicy).useAppPolicy
local GetFFlagUseUpdatedVNGAgreementsWorkflow = require(Parent.SharedFlags).GetFFlagUseUpdatedVNGAgreementsWorkflow

local function selectIsUserLoggedIn(p1) -- line: 22
	-- upvalues: LoginStatus (copy)
	return p1.AuthenticationStatus.status == LoginStatus.LOGGED_IN
end
local function showOverlay(p2, p3, p4, p5) -- line: 26
	-- upvalues: SetCentralOverlay (copy)
	p2(SetCentralOverlay(p3, {
		agreements = p4,
		agreementAccepted = p5
	}, {
		DisableBackButtonClose = true
	}))
end
local function shouldShowVngOverlay(p6) -- line: 35
	for _, v29 in p6 do
		if v29.action == "ConvertToVngUser" then
			return true
		end
	end

	return false
end
local function useFetchAndHandle() -- line: 44
	-- upvalues: useRoactService (copy), RoactNetworking (copy), RoactAnalytics (copy), useDispatch (copy), GetFFlagUseUpdatedVNGAgreementsWorkflow (copy), useAppPolicy (copy), SetCentralOverlay (copy), CentralOverlayType (copy), React (copy), FetchUpdatedUserAgreements (copy), showOverlay (copy)
	local v30 = useRoactService(RoactNetworking)
	local v31 = useRoactService(RoactAnalytics)
	local v32 = useDispatch()
	local v33 = if not GetFFlagUseUpdatedVNGAgreementsWorkflow() then nil else useAppPolicy(function(p7) -- line: 49
		return p7.getVNGFormRequired()
	end)

	local function u34() -- line: 54
	end

	if GetFFlagUseUpdatedVNGAgreementsWorkflow() and v33 then
		function u34() -- line: 57
			-- upvalues: v32 (copy), SetCentralOverlay (copy), CentralOverlayType (copy)
			v32(SetCentralOverlay(CentralOverlayType.VngContactInfoFormWebviewPopup, {}, {
				DisableBackButtonClose = true
			}))
		end
	end

	return React.useCallback(function() -- line: 64
		-- upvalues: v30 (copy), v31 (copy), v32 (copy), GetFFlagUseUpdatedVNGAgreementsWorkflow (copy), v33 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), FetchUpdatedUserAgreements (copy), u34 (ref), showOverlay (copy)
		if not v30 or (not v31 or not v32) then
			return
		end

		if GetFFlagUseUpdatedVNGAgreementsWorkflow() and v33 then
			v32(SetCentralOverlay(CentralOverlayType.VngComplianceLoadingPopup, {}, {
				DisableBackButtonClose = true
			}))
		end

		FetchUpdatedUserAgreements(v30, v31):andThen(function(p8) -- line: 76
			-- upvalues: GetFFlagUseUpdatedVNGAgreementsWorkflow (copy), u34 (ref), showOverlay (copy), v32 (copy), CentralOverlayType (copy), SetCentralOverlay (copy)
			if not p8 or #p8 == 0 then
				if GetFFlagUseUpdatedVNGAgreementsWorkflow() then
					u34()
				end

				return
			end

			local g50 = nil
			local v49 = nil

			for _, v48 in p8 do
				if v48.action == "ConvertToVngUser" then
					v49 = true
					g50 = true
				end

				if g50 then
					break
				end
			end

			if not g50 then
				v49 = false
			end

			g50 = false

			if v49 then
				if GetFFlagUseUpdatedVNGAgreementsWorkflow() then
					showOverlay(v32, CentralOverlayType.VNGUserAgreementsPopup, p8, u34)

					return
				end

				showOverlay(v32, CentralOverlayType.VNGUserAgreementsPopup, p8, function(_) -- line: 88
					-- upvalues: v32 (copy), SetCentralOverlay (copy), CentralOverlayType (copy)
					v32(SetCentralOverlay(CentralOverlayType.VngContactInfoFormWebviewPopup, {}))
				end)

				return
			end

			showOverlay(v32, CentralOverlayType.UserAgreementsUpdatedPopup, p8, nil)
		end, function(_) -- line: 95
			-- upvalues: GetFFlagUseUpdatedVNGAgreementsWorkflow (copy), u34 (ref)
			if GetFFlagUseUpdatedVNGAgreementsWorkflow() then
				u34()
			end
		end)
	end, {
		v30,
		v31,
		v32
	})
end
local function useFetchOnForegrounded() -- line: 103
	-- upvalues: useRoactService (copy), AppAppLifecycleObserverService (copy), useSelector (copy), selectIsUserLoggedIn (copy), useFetchAndHandle (copy), React (copy)
	local v35 = useRoactService(AppAppLifecycleObserverService)
	local v36 = useSelector(selectIsUserLoggedIn)
	local v37 = useFetchAndHandle()

	React.useEffect(function() -- line: 108
		-- upvalues: v35 (copy), v36 (copy), v37 (copy)
		if not v35 or not v36 then
			return
		end

		local connection = v35.OnBecomeActive:Connect(v37)

		return function() -- line: 114
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		v35,
		v36,
		v37
	})
end
local function useFetchOnUserChanged() -- line: 120
	-- upvalues: useFetchAndHandle (copy), useSelector (copy), selectIsUserLoggedIn (copy), useAppPolicy (copy), React (copy)
	local v38 = useFetchAndHandle()
	local v39 = useSelector(selectIsUserLoggedIn)
	local v40 = useAppPolicy(function(p11) -- line: 123
		return p11.getCheckUserAgreementsUpdatedOnLogin()
	end)
	local v41, v42 = React.useState(false)

	React.useEffect(function() -- line: 128
		-- upvalues: v39 (copy), v42 (copy), v40 (copy), v41 (copy), v38 (copy)
		if not v39 then
			v42(false)

			return
		end

		if v40 and not v41 then
			v42(true)
			v38()
		end
	end, {
		v38,
		v39,
		v41,
		v40
	})
end
local function useUserAgreements() -- line: 141
	-- upvalues: useFetchOnUserChanged (copy), useFetchOnForegrounded (copy)
	useFetchOnUserChanged()
	useFetchOnForegrounded()
end

return useUserAgreements
