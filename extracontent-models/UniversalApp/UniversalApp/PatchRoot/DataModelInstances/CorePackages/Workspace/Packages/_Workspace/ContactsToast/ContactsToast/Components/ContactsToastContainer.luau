local ContactsToast = script:FindFirstAncestor("ContactsToast")
local UserInputService = game:GetService("UserInputService")
local AppStorageService = game:GetService("AppStorageService")
local ContactsToastParent = ContactsToast.Parent
local ExperienceService = require(ContactsToastParent.ExperienceService)
local Promise = require(ContactsToastParent.Promise)
local React = require(ContactsToastParent.React)
local Cryo = require(ContactsToastParent.Cryo)
local getDeepValue = require(ContactsToastParent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Dictionary.getDeepValue
local RobloxAppHooks = require(ContactsToastParent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local useScreenSize = RobloxAppHooks.useScreenSize
local SetCurrentToastMessage = require(ContactsToastParent.ToastRodux).Actions.SetCurrentToastMessage
local PermissionsProtocol = require(ContactsToastParent.PermissionsProtocol).PermissionsProtocol
local SocialModalsCommon = require(ContactsToastParent.SocialModalsCommon)
local EnumScreens = SocialModalsCommon.EnumScreens
local updateOptedInUsers = SocialModalsCommon.Utils.updateOptedInUsers
local UpdateContactImporterModalLogic = SocialModalsCommon.Actions.UpdateContactImporterModalLogic
local setTimeout = require(ContactsToastParent.LuauPolyfill).setTimeout
local UIBlox = require(ContactsToastParent.UIBlox)
local Toast = UIBlox.App.Dialog.Toast
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.Constant.IconSize
local useLocalization = require(ContactsToastParent.Localization).Hooks.useLocalization
local useSelector = require(ContactsToastParent.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(ContactsToastParent.RoactUtils).Hooks.RoactRodux.useDispatch
local GetFFlagContactsToastEnabled = require(ContactsToastParent.SharedFlags).GetFFlagContactsToastEnabled
local ExperienceService2 = ExperienceService.ExperienceService
local Constants = require(ContactsToast.Common.Constants)
local localStorageContactsToast = require(ContactsToast.Utils.localStorageContactsToast)
local configureRoduxUsers = require(ContactsToast.Networking.configureRoduxUsers)
local ContactsToastIXP = require(ContactsToast.Experiments.ContactsToastIXP)
local Analytics = require(ContactsToast.Analytics).Analytics
local EventNames = require(ContactsToast.Analytics.EventNames)
local Platform = UserInputService:GetPlatform()
local v36 = game:DefineFastInt("ContactsToastAccountAgeThresholdInDays", 7)
local v37 = Images["icons/graphic/connectcontacts_large"]
local vector2 = Vector2.new(IconSize.Large, IconSize.Large)

return function(t1: {[any]: any}) -- line: 63
	-- upvalues: React (copy), useDispatch (copy), Analytics (copy), useLocalization (copy), Constants (copy), ContactsToastIXP (copy), useSelector (copy), useScreenSize (copy), useLocalUserId (copy), GetFFlagContactsToastEnabled (copy), getDeepValue (copy), PermissionsProtocol (copy), SetCurrentToastMessage (copy), Cryo (copy), EventNames (copy), UpdateContactImporterModalLogic (copy), Platform (copy), updateOptedInUsers (copy), AppStorageService (copy), EnumScreens (copy), Promise (copy), Toast (copy), v37 (copy), vector2 (copy), configureRoduxUsers (copy), v36 (copy), localStorageContactsToast (copy), ExperienceService2 (copy), setTimeout (copy)
	local v40, v41 = React.useState(false)
	local v42 = useDispatch()
	local v43 = Analytics()
	local v44 = useLocalization({
		title = Constants.Translations.title,
		subtitle = Constants.Translations.subtitle,
		button = Constants.Translations.button,
		buttonV2 = Constants.Translations.buttonV2
	})
	local v45 = ContactsToastIXP.useContactsToastVariant()
	local v46 = useSelector(t1.getContactImporterParams)
	local isDiscoverabilityUnset = v46.isDiscoverabilityUnset
	local isPhoneVerified = v46.isPhoneVerified
	local v49 = useScreenSize()
	local v50 = useLocalUserId()
	local v51 = useSelector(function(p1) -- line: 80
		return p1.IsLocalUserUnder13
	end)
	local v52 = useSelector(function(p2) -- line: 84
		-- upvalues: GetFFlagContactsToastEnabled (copy), v45 (copy), getDeepValue (copy), Constants (copy), v50 (copy)
		if GetFFlagContactsToastEnabled() or v45 then
			return (getDeepValue(p2, `{ Constants.RODUX_KEY }.Users.byUserId.{ v50 }`))
		end

		return {}
	end)
	local default = PermissionsProtocol.default

	local function v54(p3) -- line: 92
		-- upvalues: v42 (copy), SetCurrentToastMessage (copy)
		v42(SetCurrentToastMessage({
			toastMessage = p3
		}))
	end
	local function v55() -- line: 97
		-- upvalues: v42 (copy), t1 (copy)
		v42(t1.openContactImporterLearnMoreLink())
	end
	local function v56(p4, p5) -- line: 100
		-- upvalues: v42 (copy), t1 (copy)
		v42(t1.openProfilePeekView(p4, p5))
	end
	local function v57(p6, p7) -- line: 104
		-- upvalues: v42 (copy), t1 (copy)
		v42(t1.openAmpWizardContainer(p6, p7))
	end
	local function v58(p8, p9) -- line: 108
		-- upvalues: v42 (copy), t1 (copy), Cryo (copy)
		v42(t1.navigateToRoute({ Cryo.Dictionary.join({
			name = p8
		}, p9) }))
	end

	local v59 = React.createElement(Toast, {
		duration = 4,
		toastContent = {
			swipeUpDismiss = true,
			iconImage = v37,
			toastTitle = v44.title,
			toastSubtitle = v44.subtitle,
			iconSize = vector2,
			onActivated = function() -- line: 138
				-- upvalues: Platform (copy), default (copy), PermissionsProtocol (copy), updateOptedInUsers (copy), AppStorageService (copy), v50 (copy), v42 (copy), UpdateContactImporterModalLogic (copy), v58 (copy), EnumScreens (copy), v54 (copy), isPhoneVerified (copy), v55 (copy), v57 (copy), Promise (copy), v49 (copy), isDiscoverabilityUnset (copy), v56 (copy), v41 (copy), v43 (copy), EventNames (copy), v45 (copy)
				if Platform == Enum.Platform.IOS then
					default:checkOrRequestPermissions({ PermissionsProtocol.Permissions.CONTACTS_ACCESS }):andThen(function(p10) -- line: 140
						-- upvalues: PermissionsProtocol (copy), updateOptedInUsers (copy), AppStorageService (copy), v50 (copy), v42 (copy), UpdateContactImporterModalLogic (copy), v58 (copy), EnumScreens (copy), v54 (copy), isPhoneVerified (copy), v55 (copy), v57 (copy), Promise (copy), v49 (copy)
						if p10 == PermissionsProtocol.Status.AUTHORIZED then
							updateOptedInUsers:addUserToLocalStorage(AppStorageService, v50)
							v42(UpdateContactImporterModalLogic({
								hasOSPermissions = true,
								shouldShowContactImporterUpsellModal = false
							}))
							v58(EnumScreens.ContactsList, {
								shouldUpdateUserSettings = true,
								showToast = v54,
								isPhoneVerified = isPhoneVerified,
								openLearnMoreLink = v55,
								openAmpUpsell = v57
							})

							return Promise.resolve()
						end

						if p10 == PermissionsProtocol.Status.DENIED then
							v58(EnumScreens.ContactsRevokedAccessDialog, {
								screenSize = v49
							})

							return Promise.resolve()
						end

						return Promise.reject()
					end)
				else
					v58(EnumScreens.ContactImporter, {
						isFromAddFriendsPage = false,
						showToast = v54,
						openLearnMoreLink = v55,
						isDiscoverabilityUnset = isDiscoverabilityUnset,
						isPhoneVerified = isPhoneVerified,
						openProfilePeekView = v56,
						openAmpUpsell = v57
					})
				end

				v41(false)
				v43.fireAnalyticsEvent(EventNames.ContactsToastButtonPressed, {
					variant = v45
				})
			end,
			onDismissed = function() -- line: 124
				-- upvalues: v41 (copy), v43 (copy), EventNames (copy), v45 (copy)
				v41(false)
				v43.fireAnalyticsEvent(EventNames.ContactsToastDismissed, {
					variant = v45
				})
			end,
			buttonText = if v45 ~= Constants.Experiment.FIND_FRIENDS then v44.buttonV2 else v44.button
		}
	})

	React.useEffect(function() -- line: 200
		-- upvalues: v50 (copy), v42 (copy), configureRoduxUsers (copy)
		if v50 and (string.len(v50) > 0 and v50 ~= "0") then
			v42(configureRoduxUsers.GetUserV2FromUserId.API(v50))
		end
	end, { v50 })
	React.useEffect(function() -- line: 204
		-- upvalues: v50 (copy), v52 (copy), v36 (copy), t1 (copy), v51 (copy), localStorageContactsToast (copy), default (copy), PermissionsProtocol (copy), ExperienceService2 (copy), setTimeout (copy), v41 (copy), v43 (copy), EventNames (copy), v45 (copy)
		if v50 and (string.len(v50) > 0 and v52 and v52.created) then
			local v69, v70, v71 = v52.created:match("(%d+)-(%d+)-(%d+)")

			if math.floor((os.time() - os.time({
				year = v69,
				month = v70,
				day = v71
			})) / 86400) <= v36 and t1.isContactsToastPolicyEnabled and not v51 and localStorageContactsToast:CheckUserHasNotSeen(v50) then
				((if not t1.hasPermissions then default:hasPermissions({ PermissionsProtocol.Permissions.CONTACTS_ACCESS }) else t1.hasPermissions())):andThen(function(p11) -- line: 215
					-- upvalues: PermissionsProtocol (copy), localStorageContactsToast (copy), v50 (copy), ExperienceService2 (copy), setTimeout (copy), v41 (copy), v43 (copy), EventNames (copy), v45 (copy)
					if p11.status == PermissionsProtocol.Status.DENIED and p11.missingPermissions[1] == PermissionsProtocol.Permissions.CONTACTS_ACCESS or p11.status ~= PermissionsProtocol.Status.DENIED and localStorageContactsToast:CheckUserHasNotOptedIn(v50) then
						ExperienceService2:RegisterForExperienceLeave(function() -- line: 224
							-- upvalues: localStorageContactsToast (copy), v50 (copy), setTimeout (copy), v41 (copy), v43 (copy), EventNames (copy), v45 (copy)
							if localStorageContactsToast:CheckUserHasNotSeen(v50) then
								setTimeout(function() -- line: 227
									-- upvalues: v41 (copy), localStorageContactsToast (copy), v50 (copy), v43 (copy), EventNames (copy), v45 (copy)
									v41(true)
									localStorageContactsToast:AddUser(v50)
									v43.fireAnalyticsEvent(EventNames.ContactsToastSeen, {
										variant = v45
									})
								end, 1000)
							end
						end)
					end
				end)
			end
		end
	end, {
		v50,
		t1.isContactsToastPolicyEnabled,
		v51,
		v52
	})

	if t1.isContactsToastPolicyEnabled and (not v51 and v40) or t1.testOverride then
		return (React.createElement("ScreenGui", {
			DisplayOrder = 13
		}, { React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -20),
			Position = UDim2.new(0, 0, 0, 20)
		}, v59) }))
	end

	return nil
end
