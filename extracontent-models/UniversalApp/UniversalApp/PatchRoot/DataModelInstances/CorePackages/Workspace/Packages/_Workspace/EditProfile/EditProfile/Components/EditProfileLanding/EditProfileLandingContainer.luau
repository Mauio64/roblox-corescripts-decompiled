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
local FFlagEditProfileNavigateToProfilePictureEditor = require(EditProfile.Flags.FFlagEditProfileNavigateToProfilePictureEditor)
local FFlagEditProfilePPEStartOnEmotesPage = require(EditProfile.Flags.FFlagEditProfilePPEStartOnEmotesPage)
local NavigationEvents = require(EditProfileParent.RoactNavigation).NavigationEvents
local v27 = game:DefineFastString("EditProfileIXPLayer", "Social.EditProfilePage")

local function EditProfileLandingContainer(t1: {[any]: any}) -- line: 48
	-- upvalues: useLocalUserId (copy), useRealNamesInDisplayNamesEnabled (copy), ProfileRefreshSignal (copy), React (copy), FocusNavigationUtils (copy), ReactFocusNavigation (copy), useEffect (copy), FFlagAXEnableProfileTab (copy), AnalyticsServiceV2 (copy), Enums (copy), Constants (copy), useLocalRobuxBalance (copy), FFlagEditProfileNavigateToProfilePictureEditor (copy), FFlagEditProfilePPEStartOnEmotesPage (copy), v8 (copy), useSignalState (copy), v19 (copy), EditProfileStore (copy), DataHydrationTypes (copy), FocusNavigatorWrapper (copy), NavigationEvents (copy), IXPService (copy), v27 (copy), EditProfileLanding (copy)
	local v30 = useLocalUserId()
	local v31 = useRealNamesInDisplayNamesEnabled()

	local function v32() -- line: 51
		-- upvalues: ProfileRefreshSignal (copy), t1 (copy)
		ProfileRefreshSignal.notifyProfileRefresh()
		t1.navigation.pop()
	end

	local v33 = React.useRef(nil)
	local t2 = {}
	local v35 = FocusNavigationUtils.useAutoFocus(t2, 0.1)
	local v36 = React.useContext(ReactFocusNavigation.FocusNavigationContext)

	useEffect(function() -- line: 61
		-- upvalues: t2 (copy), v33 (copy), v36 (copy), v35 (copy)
		t2[1] = v33.current

		local u53 = nil

		if v36 and (v36.focusedGuiObject:getValue() ~= nil and v35) then
			u53 = v35()
		end

		return function() -- line: 67
			-- upvalues: u53 (ref)
			if u53 then
				u53.cancel()
			end
		end
	end, { v35 })

	local v37 = FFlagAXEnableProfileTab and t1.navigation.getParam("fullBleed") == true

	local function showToast(s1: string) -- line: 87
		-- upvalues: t1 (copy), Enums (copy)
		t1.navigation.goBack()
		t1.navigation.navigate(Enums.Screens.EditProfileToast, {
			text = s1
		})
	end

	local v39 = t1.navigation.getParam(Constants.EditUserNameWebView)

	local function v40() -- line: 94
		-- upvalues: t1 (copy), Enums (copy)
		t1.navigation.navigate(Enums.Screens.UsernameInsufficientFundsModal)
	end

	local v41 = useLocalRobuxBalance()
	local v42 = React.useMemo(function() -- line: 131
		-- upvalues: v8 (copy), v30 (copy)
		return v8.fetchNamesByUserIds({ (tostring(v30)) })
	end, { v30 })

	useEffect(function() -- line: 134
		-- upvalues: AnalyticsServiceV2 (copy)
		AnalyticsServiceV2.sendEditProfileOpened()
	end, {})

	local v43 = useSignalState(v42)
	local v44 = not v43 or v43.status ~= "success"
	local v45 = v43 and (v43.data and v43.data[1])
	local v46 = if not v45 then v19 else v45.names.getUsername
	local v47 = if not v45 then v19 else v45.names.getDisplayName
	local v48 = useSignalState(v46) or ""
	local v49 = useSignalState(v47) or ""
	local v50 = EditProfileStore.getDescription(v30)
	local v51 = useSignalState(v50.status) == DataHydrationTypes.DataStatus.NotReady
	local v52 = useSignalState(v50.data) or ""

	return FocusNavigatorWrapper({
		onClose = v32
	}, {
		EditProfileLandingExposureLogger = React.createElement(NavigationEvents, {
			onDidFocus = function() -- line: 157
				-- upvalues: IXPService (copy), v27 (copy)
				IXPService:LogUserLayerExposure(v27)
			end
		}),
		EditProfileLanding({
			userId = v30,
			fullBleed = v37,
			onClose = v32,
			username = v48,
			displayName = v49,
			areNamesLoading = v44,
			bioText = v52,
			isBioLoading = v51,
			isPolicyEnabled = v31,
			settingButtonOnActivated = {
				displayName = function() -- line: 79
					-- upvalues: AnalyticsServiceV2 (copy), t1 (copy), Enums (copy), v37 (copy)
					AnalyticsServiceV2.sendDisplayNameModalOpened()
					t1.navigation.navigate(Enums.Screens.EditProfileSubScreen, {
						screen = Enums.Screens.EditDisplayName,
						fullBleed = v37
					})
				end,
				username = function() -- line: 99
					-- upvalues: v41 (copy), Constants (copy), v39 (copy), showToast (copy), t1 (copy), Enums (copy), v40 (copy), AnalyticsServiceV2 (copy)
					if v41 >= Constants.ChangeUsernamePrice then
						v39(showToast)
					else
						t1.navigation.navigate(Enums.Screens.UsernameInsufficientFundsModal, {
							robux = Constants.ChangeUsernamePrice - v41,
							navigateDownToPurchaseRobux = v40
						})
					end

					AnalyticsServiceV2.sendEditUsernameOpened()
				end,
				bio = function() -- line: 111
					-- upvalues: t1 (copy), Enums (copy), v37 (copy)
					t1.navigation.navigate(Enums.Screens.EditProfileSubScreen, {
						screen = Enums.Screens.EditBio,
						fullBleed = v37
					})
				end,
				avatar = function() -- line: 118
					-- upvalues: AnalyticsServiceV2 (copy), FFlagEditProfileNavigateToProfilePictureEditor (copy), FFlagEditProfilePPEStartOnEmotesPage (copy), t1 (copy), Enums (copy)
					AnalyticsServiceV2.sendOpenAvatarMarketplace()

					if FFlagEditProfileNavigateToProfilePictureEditor then
						if FFlagEditProfilePPEStartOnEmotesPage then
							t1.navigation.navigate(Enums.Screens.ProfilePictureEditorEmotes)

							return
						end

						t1.navigation.navigate(Enums.Screens.ProfilePictureEditorCamera)

						return
					end

					t1.navigation.navigate(Enums.Screens.AvatarCatalog)
				end
			},
			firstItemRef = v33
		})
	})
end

return EditProfileLandingContainer
