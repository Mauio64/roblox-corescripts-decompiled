local SocialOnboardingButtons = script:FindFirstAncestor("SocialOnboardingButtons")
local Analytics = require(SocialOnboardingButtons.Analytics)
local EventNames = Analytics.EventNames
local SocialOnboardingButtonsParent = SocialOnboardingButtons.Parent
local React = require(SocialOnboardingButtonsParent.React)
local useLocalization = require(SocialOnboardingButtonsParent.Localization).Hooks.useLocalization
local useNavigation = require(SocialOnboardingButtonsParent.Navigation).useNavigation
local useSelector = require(SocialOnboardingButtonsParent.RoactUtils).Hooks.RoactRodux.useSelector
local Images = require(SocialOnboardingButtonsParent.UIBlox).App.ImageSet.Images
local getContactImporterParams = require(SocialOnboardingButtonsParent.ContactImporter).Utils.getContactImporterParams
local SocialModalsCommon = require(SocialOnboardingButtonsParent.SocialModalsCommon)
local useLocalUserId = require(SocialOnboardingButtonsParent.RobloxAppHooks).useLocalUserId
local AppStartup = require(SocialOnboardingButtonsParent.AppStartup)
local useLaunchContext = AppStartup.Hooks.useLaunchContext
local LaunchContext = AppStartup.Enums.LaunchContext
local EnumScreens = SocialModalsCommon.EnumScreens
local SocialOnboardingButtonsEnum = require(SocialOnboardingButtons.Enums.SocialOnboardingButtonsEnum)
local SocialOnboardingButtonsIXP = require(SocialOnboardingButtons.Experiments.SocialOnboardingButtonsIXP)
local useSocialOnboardingButtonsColors = require(SocialOnboardingButtons.Hooks.useSocialOnboardingButtonsColors)
local useAppPolicy = require(SocialOnboardingButtonsParent.UniversalAppPolicy).useAppPolicy
local v21 = Images[game:DefineFastString("FindContactsIcon_v3", "icons/actions/friend_sort/find_contacts")]
local v22 = Images[game:DefineFastString("MyQRCodeIcon_v3", "icons/actions/friend_sort/qr_code")]
local v23 = Images[game:DefineFastString("SearchPeopleIcon_v3", "icons/actions/friend_sort/search_people")]
local v24 = Images[game:DefineFastString("UnlockVoiceIcon_v3", "icons/actions/friend_sort/unlock_voice")]
local v25 = Images[game:DefineFastString("MyProfileIcon_v3", "icons/actions/friend_sort/my_profile")]
local v26 = Images[game:DefineFastString("AddFriendsIcon_v3", "icons/actions/friend_sort/add_friends")]

return function(t1: {[any]: any}, t2: {[any]: any}) -- line: 71
	-- upvalues: useLocalUserId (copy), useNavigation (copy), useLaunchContext (copy), useLocalization (copy), SocialOnboardingButtonsIXP (copy), useSocialOnboardingButtonsColors (copy), React (copy), Analytics (copy), useSelector (copy), useAppPolicy (copy), getContactImporterParams (copy), EventNames (copy), EnumScreens (copy), SocialOnboardingButtonsEnum (copy), v22 (copy), v23 (copy), v24 (copy), v25 (copy), v21 (copy), v26 (copy), LaunchContext (copy)
	local v29 = useLocalUserId()
	local v30 = useNavigation()
	local v31 = useLaunchContext()
	local v32 = useLocalization({
		addFriends = "Feature.Friends.Feature.Friends.Heading.AddFriends",
		searchPeople = "Feature.Friends.Label.SearchPeople",
		findContacts = "Feature.Contacts.Label.FindContacts",
		unlockVoice = "Feature.Friends.Label.UnlockVoice",
		myProfile = "Feature.Friends.Label.MyProfile",
		shareQRCode = "Feature.AddFriends.Label.MyQrCode"
	})
	local v33 = SocialOnboardingButtonsIXP.useSocialOnboardingBtnsEnabled()
	local v34, v35, v36 = useSocialOnboardingButtonsColors()
	local v37 = SocialOnboardingButtonsIXP.useSocialOnboardingBtnsOrder()
	local v38 = SocialOnboardingButtonsIXP.useSocialOnboardingBtnsHideAfterSignup()
	local v39 = React.useMemo(function() -- line: 92
		-- upvalues: Analytics (copy), t1 (copy)
		return Analytics.getAnalytics(t1.entryPoint)().fireAnalyticsEvent
	end, {
		t1,
		Analytics
	})
	local v40 = useSelector(function(p1) -- line: 97
		local HomePageUpsellCardVariation = p1.HomePageUpsellCardVariation

		return HomePageUpsellCardVariation ~= nil and (HomePageUpsellCardVariation.upsellCardType ~= nil and HomePageUpsellCardVariation.upsellCardType ~= "")
	end)
	local v41 = useAppPolicy(function(p2) -- line: 104
		return {
			contactImporterEnabled = p2.getContactImporterEnabled(),
			upsellVoiceForPhoneVerification = p2.getUpsellVoiceForPhoneVerification()
		}
	end)
	local v42 = useSelector(getContactImporterParams)
	local v43 = v42.hasOSPermissions or false
	local v44 = v42.isDiscoverabilityUnset or false
	local v45 = v42.isPhoneVerified or false
	local contactImporterEnabled = v41.contactImporterEnabled
	local v47 = v41.upsellVoiceForPhoneVerification and (not v45 and not v40)
	local v48 = React.useCallback(function() -- line: 119
		-- upvalues: v39 (copy), EventNames (copy), v43 (copy), t2 (copy), v44 (copy), v45 (copy), v30 (copy), EnumScreens (copy)
		v39(EventNames.FindContactsBtn)

		local v55 = v43
		local t3 = {
			isFromAddFriendsPage = false,
			isFromSocialOnboardingButtons = true,
			openLearnMoreLink = t2.openLearnMoreLink,
			showToast = t2.showToast,
			isDiscoverabilityUnset = v44,
			isPhoneVerified = v45,
			openAmpUpsell = t2.openAmpUpsell
		}

		if not v55 then
			v30.navigate(EnumScreens.ContactImporter, t3)

			return
		end

		v30.navigate(EnumScreens.ContactsList, t3)
	end, {
		t2,
		v44,
		v45,
		v30,
		v39
	})
	local v49 = React.useCallback(function() -- line: 138
		-- upvalues: t2 (copy), t1 (copy)
		t2.hideUpsellCard()
		t2.openDiscoverabilityModal({
			isStandaloneDiscoverabilityModal = true,
			showToast = t2.showToast,
			openLearnMoreLink = t2.openLearnMoreLink,
			entryPoint = t1.entryPoint,
			onClose = t2.closeCentralOverlay,
			navigateOnActivated = t2.closeCentralOverlay
		})
	end, {
		t2,
		t1
	})
	local v50, v51 = React.useMemo(function() -- line: 151
		-- upvalues: v39 (copy), EventNames (copy), t2 (copy), SocialOnboardingButtonsEnum (copy), v32 (copy), v22 (copy), v34 (copy), v35 (copy), v36 (copy), v23 (copy), v47 (copy), v49 (copy), v24 (copy), v29 (copy), v25 (copy), contactImporterEnabled (copy), v21 (copy), v48 (copy), v37 (copy), v26 (copy)
		local t4 = {
			[SocialOnboardingButtonsEnum.ShareQRCodeBtn] = {
				id = SocialOnboardingButtonsEnum.ShareQRCodeBtn,
				text = v32.shareQRCode,
				icon = v22,
				onActivated = function() -- line: 156
					-- upvalues: v39 (copy), EventNames (copy), t2 (copy)
					v39(EventNames.MyQRCodeBtn)
					t2.navigateToQRCodePage()
				end,
				backgroundColor = v34.myQRCode,
				iconColor = v35,
				extraId = v36
			},
			[SocialOnboardingButtonsEnum.SearchFriendsBtn] = {
				id = SocialOnboardingButtonsEnum.SearchFriendsBtn,
				text = v32.searchPeople,
				icon = v23,
				onActivated = function() -- line: 173
					-- upvalues: v39 (copy), EventNames (copy), t2 (copy)
					v39(EventNames.SearchPeopleBtn)
					t2.navigateToSearchFriends()
				end,
				backgroundColor = v34.searchPeople,
				iconColor = v35,
				extraId = v36
			}
		}

		if v47 then
			t4[SocialOnboardingButtonsEnum.UnlockVoiceBtn] = {
				id = SocialOnboardingButtonsEnum.UnlockVoiceBtn,
				text = v32.unlockVoice,
				icon = v24,
				onActivated = function() -- line: 191
					-- upvalues: v39 (copy), EventNames (copy), t2 (copy), v49 (copy)
					v39(EventNames.UnlockVoiceBtn)
					t2.openPhoneVerificationModal(v49)
				end,
				backgroundColor = v34.unlockVoice,
				iconColor = v35,
				extraId = v36
			}
		end

		if v29 then
			t4[SocialOnboardingButtonsEnum.CompleteProfileBtn] = {
				id = SocialOnboardingButtonsEnum.CompleteProfileBtn,
				text = v32.myProfile,
				icon = v25,
				onActivated = function() -- line: 209
					-- upvalues: v39 (copy), EventNames (copy), t2 (copy), v29 (copy)
					v39(EventNames.MyProfileBtn)
					t2.openProfilePeekView((tostring(v29)))
				end,
				backgroundColor = v34.myProfile,
				iconColor = v35,
				extraId = v36
			}
		end

		if contactImporterEnabled then
			t4[SocialOnboardingButtonsEnum.FindContactsBtn] = {
				id = SocialOnboardingButtonsEnum.FindContactsBtn,
				text = v32.findContacts,
				icon = v21,
				onActivated = v48,
				backgroundColor = v34.findContacts,
				iconColor = v35,
				extraId = v36
			}
		end

		local t5 = {}

		for match in string.gmatch(v37 or "", "([^,]+)") do
			if t4[match] then
				table.insert(t5, t4[match])
			end
		end

		return t5, {
			id = SocialOnboardingButtonsEnum.AddFriendsBtn,
			icon = v26,
			backgroundColor = v34.addFriends,
			iconColor = v35,
			extraId = v36
		}
	end, {
		t1,
		t2,
		contactImporterEnabled,
		v47,
		v49,
		v48,
		v32,
		v39,
		v34,
		v35,
		v36,
		v37
	})

	if v33 then
		if v38 and v31 == LaunchContext.SignUp then
			return nil, v51
		end

		return v50, v51
	end

	return nil, nil
end
