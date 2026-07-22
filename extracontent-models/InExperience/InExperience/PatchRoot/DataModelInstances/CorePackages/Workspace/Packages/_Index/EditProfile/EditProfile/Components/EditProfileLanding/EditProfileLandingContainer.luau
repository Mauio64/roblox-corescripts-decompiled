local EditProfile = script:FindFirstAncestor("EditProfile")
local IXPService = game:GetService("IXPService")
local EditProfileParent = EditProfile.Parent
local EditProfileLanding = require(EditProfile.Components.EditProfileLanding.EditProfileLanding)
local React = require(EditProfileParent.React)
local useEffect = React.useEffect
local useLocalUserId = require(EditProfileParent.RobloxAppHooks).useLocalUserId
local v8 = require(EditProfileParent.UserProfiles).Stores.UserProfileStore.get()
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
local v19 = Signals.createSignal("")
local AnalyticsServiceV2 = require(EditProfile.Analytics.AnalyticsServiceV2)
local FFlagAXEnableProfileTab = require(EditProfileParent.SharedFlags).FFlagAXEnableProfileTab
local FocusNavigationUtils = require(EditProfileParent.FocusNavigationUtils)
local ReactFocusNavigation = require(EditProfileParent.ReactFocusNavigation)
local FFlagEditProfilePPEStartOnEmotesPage = require(EditProfile.Flags.FFlagEditProfilePPEStartOnEmotesPage)
local NavigationEvents = require(EditProfileParent.RoactNavigation).NavigationEvents
local v26 = game:DefineFastString("EditProfileIXPLayer", "Social.EditProfilePage")

local function EditProfileLandingContainer(t1: {[any]: any}) -- line: 45
	-- upvalues: useLocalUserId (copy), useRealNamesInDisplayNamesEnabled (copy), ProfileRefreshSignal (copy), React (copy), FocusNavigationUtils (copy), ReactFocusNavigation (copy), useEffect (copy), FFlagAXEnableProfileTab (copy), AnalyticsServiceV2 (copy), Enums (copy), Constants (copy), useLocalRobuxBalance (copy), FFlagEditProfilePPEStartOnEmotesPage (copy), v8 (copy), useSignalState (copy), v19 (copy), EditProfileStore (copy), DataHydrationTypes (copy), FocusNavigatorWrapper (copy), NavigationEvents (copy), IXPService (copy), v26 (copy), EditProfileLanding (copy)
	local v29 = useLocalUserId()
	local v30 = useRealNamesInDisplayNamesEnabled()

	local function v31() -- line: 48
		-- upvalues: ProfileRefreshSignal (copy), t1 (copy)
		ProfileRefreshSignal.notifyProfileRefresh()
		t1.navigation.pop()
	end

	local v32 = React.useRef(nil)
	local t2 = {}
	local v34 = FocusNavigationUtils.useAutoFocus(t2, 0.1)
	local v35 = React.useContext(ReactFocusNavigation.FocusNavigationContext)

	useEffect(function() -- line: 58
		-- upvalues: t2 (copy), v32 (copy), v35 (copy), v34 (copy)
		t2[1] = v32.current

		local u52 = nil

		if v35 and (v35.focusedGuiObject:getValue() ~= nil and v34) then
			u52 = v34()
		end

		return function() -- line: 64
			-- upvalues: u52 (ref)
			if u52 then
				u52.cancel()
			end
		end
	end, { v34 })

	local v36 = FFlagAXEnableProfileTab and t1.navigation.getParam("fullBleed") == true

	local function showToast(s1: string) -- line: 84
		-- upvalues: t1 (copy), Enums (copy)
		t1.navigation.goBack()
		t1.navigation.navigate(Enums.Screens.EditProfileToast, {
			text = s1
		})
	end

	local v38 = t1.navigation.getParam(Constants.EditUserNameWebView)

	local function v39() -- line: 91
		-- upvalues: t1 (copy), Enums (copy)
		t1.navigation.navigate(Enums.Screens.UsernameInsufficientFundsModal)
	end

	local v40 = useLocalRobuxBalance()
	local v41 = React.useMemo(function() -- line: 124
		-- upvalues: v8 (copy), v29 (copy)
		return v8.fetchNamesByUserIds({ (tostring(v29)) })
	end, { v29 })

	useEffect(function() -- line: 127
		-- upvalues: AnalyticsServiceV2 (copy)
		AnalyticsServiceV2.sendEditProfileOpened()
	end, {})

	local v42 = useSignalState(v41)
	local v43 = not v42 or v42.status ~= "success"
	local v44 = v42 and (v42.data and v42.data[1])
	local v45 = if not v44 then v19 else v44.names.getUsername
	local v46 = if not v44 then v19 else v44.names.getDisplayName
	local v47 = useSignalState(v45) or ""
	local v48 = useSignalState(v46) or ""
	local v49 = EditProfileStore.getDescription(v29)
	local v50 = useSignalState(v49.status) == DataHydrationTypes.DataStatus.NotReady
	local v51 = useSignalState(v49.data) or ""

	return FocusNavigatorWrapper({
		onClose = v31
	}, {
		EditProfileLandingExposureLogger = React.createElement(NavigationEvents, {
			onDidFocus = function() -- line: 150
				-- upvalues: IXPService (copy), v26 (copy)
				IXPService:LogUserLayerExposure(v26)
			end
		}),
		EditProfileLanding({
			userId = v29,
			fullBleed = v36,
			onClose = v31,
			username = v47,
			displayName = v48,
			areNamesLoading = v43,
			bioText = v51,
			isBioLoading = v50,
			isPolicyEnabled = v30,
			settingButtonOnActivated = {
				displayName = function() -- line: 76
					-- upvalues: AnalyticsServiceV2 (copy), t1 (copy), Enums (copy), v36 (copy)
					AnalyticsServiceV2.sendDisplayNameModalOpened()
					t1.navigation.navigate(Enums.Screens.EditProfileSubScreen, {
						screen = Enums.Screens.EditDisplayName,
						fullBleed = v36
					})
				end,
				username = function() -- line: 96
					-- upvalues: v40 (copy), Constants (copy), v38 (copy), showToast (copy), t1 (copy), Enums (copy), v39 (copy), AnalyticsServiceV2 (copy)
					if v40 >= Constants.ChangeUsernamePrice then
						v38(showToast)
					else
						t1.navigation.navigate(Enums.Screens.UsernameInsufficientFundsModal, {
							robux = Constants.ChangeUsernamePrice - v40,
							navigateDownToPurchaseRobux = v39
						})
					end

					AnalyticsServiceV2.sendEditUsernameOpened()
				end,
				bio = function() -- line: 108
					-- upvalues: t1 (copy), Enums (copy), v36 (copy)
					t1.navigation.navigate(Enums.Screens.EditProfileSubScreen, {
						screen = Enums.Screens.EditBio,
						fullBleed = v36
					})
				end,
				avatar = function() -- line: 115
					-- upvalues: AnalyticsServiceV2 (copy), FFlagEditProfilePPEStartOnEmotesPage (copy), t1 (copy), Enums (copy)
					AnalyticsServiceV2.sendOpenAvatarMarketplace()

					if FFlagEditProfilePPEStartOnEmotesPage then
						t1.navigation.navigate(Enums.Screens.ProfilePictureEditorEmotes)

						return
					end

					t1.navigation.navigate(Enums.Screens.ProfilePictureEditorCamera)
				end
			},
			firstItemRef = v32
		})
	})
end

return EditProfileLandingContainer
