local EditProfile = script:FindFirstAncestor("EditProfile")
local IXPService = game:GetService("IXPService")
local EditProfileParent = EditProfile.Parent
local EditProfileLanding = require(EditProfile.Components.EditProfileLanding.EditProfileLanding)
local EditProfileLandingV2 = require(EditProfile.Components.EditProfileLanding.EditProfileLandingV2)
local FFlagEditProfileLandingV2Enabled = require(EditProfile.Flags.FFlagEditProfileLandingV2Enabled)
local React = require(EditProfileParent.React)
local useEffect = React.useEffect

require(EditProfileParent.AvatarExperienceNavigation)

local useLocalUserId = require(EditProfileParent.RobloxAppHooks).useLocalUserId
local v10 = require(EditProfileParent.UserProfiles).Stores.UserProfileStore.get()
local EditProfileStore = require(EditProfile.Stores.EditProfileStore)
local ProfileRefreshSignal = require(EditProfileParent.ProfilePlatformCommon).Signals.ProfileRefreshSignal
local Enums = require(EditProfile.Common.Enums)
local Constants = require(EditProfile.Common.Constants)
local useLocalRobuxBalance = require(EditProfileParent.RobloxAppHooks).useLocalRobuxBalance
local useRealNamesInDisplayNamesEnabled = require(EditProfile.Hooks.useRealNamesInDisplayNamesEnabled)
local FocusNavigatorWrapper = require(EditProfile.Utils.FocusNavigatorWrapper)
local useSignalState = require(EditProfileParent.SignalsReact).useSignalState
local Signals = require(EditProfileParent.Signals)
local DataHydrationTypes = require(EditProfileParent.DataHydration).DataHydrationTypes
local v21 = Signals.createSignal("")
local AnalyticsServiceV2 = require(EditProfile.Analytics.AnalyticsServiceV2)
local FFlagAXEnableProfileTab = require(EditProfileParent.SharedFlags).FFlagAXEnableProfileTab
local FFlagAXPPEReturnToEntrySurface = require(EditProfileParent.SharedFlags).FFlagAXPPEReturnToEntrySurface
local FocusNavigationUtils = require(EditProfileParent.FocusNavigationUtils)
local ReactFocusNavigation = require(EditProfileParent.ReactFocusNavigation)
local FFlagEditProfilePPEStartOnEmotesPage = require(EditProfile.Flags.FFlagEditProfilePPEStartOnEmotesPage)
local RoactNavigation = require(EditProfileParent.RoactNavigation)
local NavigationEvents = RoactNavigation.NavigationEvents
local v30 = game:DefineFastString("EditProfileIXPLayer", "Social.EditProfilePage")

local function getHostRoute(p1) -- line: 51
	local v35 = p1._dangerouslyGetParent()
	local v36 = v35 and v35.state

	if v36 and v36.routeName then
		return v36
	end

	return nil
end
local function getCoveredPage(p2, p3) -- line: 58
	local v39 = p2._dangerouslyGetParent()

	while v39 do
		p2 = v39
		v39 = if not p2._dangerouslyGetParent then nil else p2._dangerouslyGetParent()
	end

	local routes = p2.state.routes

	if not routes then
		return nil, nil
	end

	for v41, v42 in routes do
		if v42.routeName == p3.routeName and v41 > 1 then
			local v43 = routes[v41 - 1]
			local v44 = if not v43.routes or not v43.index then v43 else v43.routes[v43.index]

			return v44.routeName, v44.params
		end
	end

	return nil, nil
end
local function EditProfileLandingContainer(t1: {[any]: any}) -- line: 82
	-- upvalues: useLocalUserId (copy), useRealNamesInDisplayNamesEnabled (copy), ProfileRefreshSignal (copy), React (copy), FocusNavigationUtils (copy), ReactFocusNavigation (copy), useEffect (copy), FFlagAXEnableProfileTab (copy), AnalyticsServiceV2 (copy), Enums (copy), Constants (copy), useLocalRobuxBalance (copy), FFlagAXPPEReturnToEntrySurface (copy), FFlagEditProfilePPEStartOnEmotesPage (copy), getCoveredPage (copy), RoactNavigation (copy), v10 (copy), useSignalState (copy), v21 (copy), EditProfileStore (copy), DataHydrationTypes (copy), FocusNavigatorWrapper (copy), NavigationEvents (copy), IXPService (copy), v30 (copy), FFlagEditProfileLandingV2Enabled (copy), EditProfileLandingV2 (copy), EditProfileLanding (copy)
	local v46 = useLocalUserId()
	local v47 = useRealNamesInDisplayNamesEnabled()

	local function v48() -- line: 85
		-- upvalues: ProfileRefreshSignal (copy), t1 (copy)
		ProfileRefreshSignal.notifyProfileRefresh()
		t1.navigation.pop()
	end

	local v49 = React.useRef(nil)
	local t2 = {}
	local v51 = FocusNavigationUtils.useAutoFocus(t2, 0.1)
	local v52 = React.useContext(ReactFocusNavigation.FocusNavigationContext)

	useEffect(function() -- line: 95
		-- upvalues: t2 (copy), v49 (copy), v52 (copy), v51 (copy)
		t2[1] = v49.current

		local u70 = nil

		if v52 and (v52.focusedGuiObject:getValue() ~= nil and v51) then
			u70 = v51()
		end

		return function() -- line: 101
			-- upvalues: u70 (ref)
			if u70 then
				u70.cancel()
			end
		end
	end, { v51 })

	local v53 = FFlagAXEnableProfileTab and t1.navigation.getParam("fullBleed") == true

	local function showToast(s1: string) -- line: 121
		-- upvalues: t1 (copy), Enums (copy)
		t1.navigation.goBack()
		t1.navigation.navigate(Enums.Screens.EditProfileToast, {
			text = s1
		})
	end

	local v55 = t1.navigation.getParam(Constants.EditUserNameWebView)

	local function v56() -- line: 128
		-- upvalues: t1 (copy), Enums (copy)
		t1.navigation.navigate(Enums.Screens.UsernameInsufficientFundsModal)
	end

	local v57 = useLocalRobuxBalance()
	local v58 = React.useMemo(function() -- line: 185
		-- upvalues: v10 (copy), v46 (copy)
		return v10.fetchNamesByUserIds({ (tostring(v46)) })
	end, { v46 })

	useEffect(function() -- line: 188
		-- upvalues: AnalyticsServiceV2 (copy)
		AnalyticsServiceV2.sendEditProfileOpened()
	end, {})

	local v59 = useSignalState(v58)
	local v60 = not v59 or v59.status ~= "success"
	local v61 = v59 and (v59.data and v59.data[1])
	local v62 = if not v61 then v21 else v61.names.getUsername
	local v63 = if not v61 then v21 else v61.names.getDisplayName
	local v64 = useSignalState(v62) or ""
	local v65 = useSignalState(v63) or ""
	local v66 = EditProfileStore.getDescription(v46)
	local v67 = useSignalState(v66.status) == DataHydrationTypes.DataStatus.NotReady
	local v68 = useSignalState(v66.data) or ""
	local t4 = {
		userId = v46,
		fullBleed = v53,
		onClose = v48,
		username = v64,
		displayName = v65,
		areNamesLoading = v60,
		bioText = v68,
		isBioLoading = v67,
		isPolicyEnabled = v47,
		settingButtonOnActivated = {
			displayName = function() -- line: 113
				-- upvalues: AnalyticsServiceV2 (copy), t1 (copy), Enums (copy), v53 (copy)
				AnalyticsServiceV2.sendDisplayNameModalOpened()
				t1.navigation.navigate(Enums.Screens.EditProfileSubScreen, {
					screen = Enums.Screens.EditDisplayName,
					fullBleed = v53
				})
			end,
			username = function() -- line: 133
				-- upvalues: v57 (copy), Constants (copy), v55 (copy), showToast (copy), t1 (copy), Enums (copy), v56 (copy), AnalyticsServiceV2 (copy)
				if v57 >= Constants.ChangeUsernamePrice then
					v55(showToast)
				else
					t1.navigation.navigate(Enums.Screens.UsernameInsufficientFundsModal, {
						robux = Constants.ChangeUsernamePrice - v57,
						navigateDownToPurchaseRobux = v56
					})
				end

				AnalyticsServiceV2.sendEditUsernameOpened()
			end,
			bio = function() -- line: 145
				-- upvalues: t1 (copy), Enums (copy), v53 (copy)
				t1.navigation.navigate(Enums.Screens.EditProfileSubScreen, {
					screen = Enums.Screens.EditBio,
					fullBleed = v53
				})
			end,
			avatar = function() -- line: 152
				-- upvalues: AnalyticsServiceV2 (copy), FFlagAXPPEReturnToEntrySurface (copy), FFlagEditProfilePPEStartOnEmotesPage (copy), Enums (copy), t1 (copy), getCoveredPage (copy), RoactNavigation (copy)
				AnalyticsServiceV2.sendOpenAvatarMarketplace()

				if FFlagAXPPEReturnToEntrySurface then
					local v72 = if not FFlagEditProfilePPEStartOnEmotesPage then Enums.Screens.ProfilePictureEditorCamera else Enums.Screens.ProfilePictureEditorEmotes
					local v73 = t1.navigation._dangerouslyGetParent()
					local v74 = v73 and v73.state
					local v75 = if not v74 or not v74.routeName then nil else v74

					if v75 then
						local v76, v77 = getCoveredPage(t1.navigation, v75)
						local t3 = {
							screenName = v75.routeName,
							screenParams = v75.params,
							reopenAction = RoactNavigation.Actions.navigate({
								routeName = t1.navigation.state.routeName,
								params = t1.navigation.state.params
							}),
							coveredScreenName = v76,
							coveredScreenParams = v77
						}

						t1.navigation.navigate(v72, {
							entryOrigin = t3
						})

						return
					end
				end

				if FFlagEditProfilePPEStartOnEmotesPage then
					t1.navigation.navigate(Enums.Screens.ProfilePictureEditorEmotes)

					return
				end

				t1.navigation.navigate(Enums.Screens.ProfilePictureEditorCamera)
			end
		},
		firstItemRef = v49
	}

	return FocusNavigatorWrapper({
		onClose = v48
	}, {
		EditProfileLandingExposureLogger = React.createElement(NavigationEvents, {
			onDidFocus = function() -- line: 233
				-- upvalues: IXPService (copy), v30 (copy)
				IXPService:LogUserLayerExposure(v30)
			end
		}),
		EditProfileLanding = if not FFlagEditProfileLandingV2Enabled then React.createElement(EditProfileLanding, t4) else React.createElement(EditProfileLandingV2, t4)
	})
end

return EditProfileLandingContainer
