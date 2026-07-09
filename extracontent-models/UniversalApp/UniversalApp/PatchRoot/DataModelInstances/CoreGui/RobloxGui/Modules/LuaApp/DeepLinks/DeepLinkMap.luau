local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")
local Workspace = game:GetService("Workspace")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local ExperienceService = require(CorePackages.Workspace.Packages.ExperienceService).ExperienceService
local GamesMultigetPlaceDetails = require(CorePackages.Workspace.Packages.GameDetailRodux).GamesByPlaceId.GamesMultigetPlaceDetails
local default = require(CorePackages.Workspace.Packages.LinkingProtocol).LinkingProtocol.default
local ChatEntryPointNames = require(CorePackages.Workspace.Packages.SocialCommon).Enums.ChatEntryPointNames
local AppPage = require(Modules.LuaApp.AppPage)
local AppChatNetworking = require(CorePackages.Workspace.Packages.AppChatNetworking)
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Constants = require(Modules.AvatarExperience.Common.Constants)
local CreateConversation = AppChatNetworking.http.CreateConversation
local logGameDetailsDeepLinkEvent = require(script.Parent.logGameDetailsDeepLinkEvent)
local logLockScreenWidgetClicked = require(script.Parent.logLockScreenWidgetClicked)

require(CorePackages.Workspace.Packages.NavigationRodux)

local Enums = require(CorePackages.Workspace.Packages.ProfilePlatform.Enums)
local SearchTypes = require(CorePackages.Workspace.Packages.RobloxAppEnums).SearchTypes
local SearchUuid = require(Modules.LuaApp.SearchUuid)
local ShareLinkTypes = require(Modules.LuaApp.DeepLinks.ShareLinks.ShareLinkTypes)
local TransitionAnimation = require(Modules.LuaApp.Enum.TransitionAnimation)
local UrlBase = require(Modules.LuaApp.Http.UrlBase)
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local UseGameDetailsPeekView = require(CorePackages.Workspace.Packages.GameDetail).PeekView.UseGameDetailsPeekView
local Constants2 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local DeepLinkUtils = require(Modules.AvatarExperience.Common.DeepLinkUtils)
local Constants3 = require(CorePackages.Workspace.Packages.ContactImporter).Constants
local UpsellEntrySurfaceType = require(CorePackages.Workspace.Packages.SocialUpsell).Analytics.Enum.UpsellEntrySurfaceType
local contactImporterModalInfo = require(CorePackages.Workspace.Packages.ContactImporter).Utils.contactImporterModalInfo
local ExternalWebUrlNavigationHelper = require(Modules.LuaApp.DeepLinks.Utils.ExternalWebUrlNavigationHelper)
local SortIdMapper = require(Modules.LuaApp.DeepLinks.Utils.SortIdMapper)
local HardwareSafeAreaInsets = require(CorePackages.Workspace.Packages.Responsive).HardwareSafeAreaInsets
local StreamNotificationStore = require(CorePackages.Workspace.Packages.StreamNotifications).StreamNotificationStore
local RobloxSubscriptionPurchaseApp = require(CorePackages.Workspace.Packages.RobloxSubscriptionPurchaseApp)
local SurfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext
local SurfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local handleShareLinkRoot = require(script.Parent.ShareLinks.handleShareLinkRoot)
local handleStaticShareLink = require(script.Parent.ShareLinks.StaticLinks.handleStaticShareLink)
local handleJoinLink = require(script.Parent.ShareLinks.handleJoinLink)
local LocalPlayer = game:GetService("Players").LocalPlayer
local v44 = game:DefineFastFlag("EnablePrivacySettingsDeeplinks", false)
local v45 = game:DefineFastFlag("EnableParentalControlsDeeplinks", false)
local v46 = game:DefineFastFlag("EnableAccountInfoDeeplinks", false)

game:SetFlagVersion("EnableDevicePreferencesDeeplink", 2)

local v47 = game:DefineFastFlag("EnableDevicePreferencesDeeplink", false)
local v48 = game:DefineFastFlag("EnableSettingSubpageDeeplinks", false)
local v49 = game:DefineFastFlag("EnableNotificationSettingsTypeDeeplink", false)
local GetFFlagEnableSecurityAlertDeeplink = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableSecurityAlertDeeplink
local GetFFlagGenerateLinkWithChannel = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagGenerateLinkWithChannel
local FFlagQRCodeItemRedemptionEnabled = require(Modules.AvatarExperience.Flags.FFlagQRCodeItemRedemptionEnabled)
local GetFFlagEnableCrossDeviceLoginUsingQRCodes = require(Modules.LuaApp.Flags.GetFFlagEnableCrossDeviceLoginUsingQRCodes)
local GetFFlagEnableGiftCardsDeepLink = require(Modules.LuaApp.Flags.GetFFlagEnableGiftCardsDeepLink)
local v55 = game:DefineFastFlag("EnableBuyRobuxDeepLink", false)
local FFlagEnableCurrencyTransferDeepLink = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableCurrencyTransferDeepLink
local FFlagCurrencyTransferDeepLinkValidateSender = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCurrencyTransferDeepLinkValidateSender
local FFlagEnablePlusUpsellDeepLink = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnablePlusUpsellDeepLink
local GetFFlagEnableMessagesDeepLink = require(Modules.LuaApp.Flags.GetFFlagEnableMessagesDeepLink)
local FFlagLuaAppForumsDeeplinkFix = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppForumsDeeplinkFix
local v61 = game:DefineFastFlag("EnableBundleItemDetailHttpLink", false)
local FFlagEnableLookDetailsDeepLink = require(Modules.LuaApp.Flags.FFlagEnableLookDetailsDeepLink)
local FFlagEnableCatalogSearchDeepLinks = require(Modules.LuaApp.Flags.FFlagEnableCatalogSearchDeepLinks)
local FFlagEnableSearchDeepLink = require(Modules.LuaApp.Flags.FFlagEnableSearchDeepLink)
local FFlagEnableProfilePictureEditorDeepLink = require(Modules.LuaApp.Flags.FFlagEnableProfilePictureEditorDeepLink)
local FFlagEnableShareLinksInGameDetailEvent = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableShareLinksInGameDetailEvent
local GetFFlagLuaAppFixStudioNotchSupport = require(Modules.LuaApp.Flags.GetFFlagLuaAppFixStudioNotchSupport)
local GetFFlagUseCommunitiesTranslation = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagUseCommunitiesTranslation
local GetFFlagEnableSupportCenter = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableSupportCenter
local FFlagAXEnableCatalogCreatorHttpLink = require(Modules.LuaApp.Flags.FFlagAXEnableCatalogCreatorHttpLink)
local FFlagEnableSquadDeeplinkWithChatId = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableSquadDeeplinkWithChatId
local FFlagLuaAppSortDeeplinkFix = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppSortDeeplinkFix
local FFlagEnableAmpWizardDeepLink = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableAmpWizardDeepLink
local FFlagEnableAccountUnlockDeepLink = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableAccountUnlockDeepLink
local FFlagAccountUnlockAllowMissingUserId = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAccountUnlockAllowMissingUserId
local FFlagEnableAmpWizardDeepLinkValidateUserId = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableAmpWizardDeepLinkValidateUserId
local FFlagEnableFlyoutSidePanel = require(Modules.LuaApp.Flags.FFlagEnableFlyoutSidePanel)
local FFlagCiDeprecateFindFriendsModal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCiDeprecateFindFriendsModal
local FFlagEnableNotificationsDeeplink = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableNotificationsDeeplink
local FFlagStreamNotificationDropdownSingleOwner = require(CorePackages.Workspace.Packages.SharedFlags).FFlagStreamNotificationDropdownSingleOwner
local FFlagTCParentChildAutoUpgrade = require(CorePackages.Workspace.Packages.SharedFlags).FFlagTCParentChildAutoUpgrade
local FFlagLuaAppSduiLandingPageEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppSduiLandingPageEnabled
local FFlagAppNavMyStatsTab = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAppNavMyStatsTab
local FFlagLuaEnableGenreLandingDeeplink = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaEnableGenreLandingDeeplink
local FFlagEnableSchoolEntry = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableSchoolEntry

game:DefineFastString("SearchDeepLinkPattern", "roblox.*://navigation/search.*")
game:DefineFastString("GamesPageDeepLinkPattern", "roblox.*://navigation/games")
game:DefineFastString("HomePageDeepLinkPattern", "roblox.*://navigation/home")
game:DefineFastString("BuildPageDeepLinkPattern", "roblox.*://navigation/build.*")
game:DefineFastString("AvatarClothingSortingView", "roblox.*://navigation/avatar_clothing_sort")
game:DefineFastString("AvatarProfilePictureEditor", "roblox.*://navigation/avatar_profile_picture_editor")
game:DefineFastString("AvatarDeepLinkPattern", "roblox.*://navigation/avatar.*")
game:DefineFastString("AvatarHttpPattern", "/my/avatar")
game:DefineFastString("MorePageDeepLinkPattern", "roblox.*://navigation/more")
game:DefineFastString("NotificationsDeepLinkPattern", "roblox.*://navigation/notifications")
game:DefineFastString("NotificationSettingsDeepLinkPattern", "roblox.*://navigation/notification_settings.*")
game:DefineFastString("RoactChatDeepLinkPattern", "roblox.*://navigation/chat.*")
game:DefineFastString("GameDetailsDeepLinkPattern", "roblox.*://navigation/game_details.*")
game:DefineFastString("GameDetailsHttpPattern", "/games/(%d+)/?[%w_-]*%??r?e?f?P?a?g?e?I?d?=?[%w%-]*")
game:DefineFastString("GameDetailsReferralHttpPattern", "/games/refer.*")
game:DefineFastString("ProfileCardDeepLinkPattern", "roblox.*://navigation/profile_card.*")
game:DefineFastString("ProfileTrustedFriendsDeepLinkPattern", "roblox.*://navigation/profile_trustedfriends.*")
game:DefineFastString("ProfileDeepLinkPattern", "roblox.*://navigation/profile.*")
game:DefineFastString("CatalogSearchDeepLinkPattern", "roblox.*://navigation/catalog?.+")
game:DefineFastString("CatalogEquipDeepLinkPattern", "roblox.*://navigation/catalog/equip?.+")
game:DefineFastString("CatalogDeepLinkPattern", "roblox.*://navigation/catalog")
game:DefineFastString("CatalogHttpPattern", "/catalog[^/]*")
game:DefineFastString("ItemDetailsDeepLinkPattern", "roblox.*://navigation/item_details.*")
game:DefineFastString("ItemDetailsHttpPattern", "/catalog/(%d+)/.*")
game:DefineFastString("BundleItemDetailsHttpPattern", "/bundles/(%d+)/.*")
game:DefineFastString("LookItemDetailsHttpPattern", "/looks/(%d+)/.*")
game:DefineFastString("ItemRedemptionDeepLinkPattern", "roblox.*://navigation/qr_code_redemption.*")

if v48 then
	game:DefineFastString("FriendsPageDeepLinkPattern", "roblox.*://navigation/friends$")
else
	game:DefineFastString("FriendsPageDeepLinkPattern", "roblox.*://navigation/friends")
end

game:DefineFastString("GiftCardsPageDeepLinkPattern", "roblox.*://navigation/gift_cards")
game:DefineFastString("BuyRobuxDeepLinkPattern", "roblox.*://navigation/buy_robux")
game:DefineFastString("PlusUpsellDeepLinkPattern", "roblox.*://navigation/plus_upsell")
game:DefineFastString("CurrencyTransferDeepLinkPattern", "roblox.*://navigation/currency_transfer.*")
game:DefineFastString("GroupsDeepLinkPattern", "roblox.*://navigation/group.*")
game:DefineFastString("CrossDeviceLoginDeepLinkPattern", "roblox.*://navigation/crossdevice.*")
game:DefineFastString("EventDetailsPageDeepLinkPattern", "roblox.*://navigation/event_details.*")
game:DefineFastString("ShareLinkDeepLinkPattern", "roblox.*://navigation/share_links.*")
game:DefineFastString("StaticShareLinkDeepLinkPattern", "roblox.*://navigation/share_links/(%w)/([%w%-]+).*")
game:DefineFastString("JoinLinkHttpPattern", "/join/([%w]+).*")
game:DefineFastString("ShareLinkHttpPattern", "/share.*")
game:DefineFastString("StaticShareLinkHttpPattern", "/share/(%w)/([%w%-]+).*")
game:DefineFastString("ShortShareLinkHttpPattern", "/shortlink.*")
game:DefineFastString("ContentPostDeepLinkPattern", "roblox.*://navigation/content_post.*")
game:DefineFastString("AddSchoolDeepLinkPattern", "roblox.*://navigation/add_school")
game:DefineFastString("ContactsDeepLinkPattern", "roblox.*://navigation/contacts.*")
game:DefineFastString("AppealsPortalDeepLinkPattern", "roblox.*://navigation/appeals.*")
game:DefineFastString("SupportCenterDeepLinkPattern", "roblox.*://navigation/support_center.*")
game:DefineFastString("PrivacySettingsDeepLinkPattern", "roblox.*://navigation/privacy_settings")
game:DefineFastString("AppPermissionsSettingsDeepLinkPattern", "roblox.*://navigation/app_permissions_settings")
game:DefineFastString("ScreentimeSettingsDeepLinkPattern", "roblox.*://navigation/screentime_subsettings")
game:DefineFastString("CommunicationSettingsDeepLinkPattern", "roblox.*://navigation/communication_subsettings")
game:DefineFastString("BlockedUsersSettingsDeepLinkPattern", "roblox.*://navigation/blocked_users_subsettings")
game:DefineFastString("BlockedExpSettingsDeepLinkPattern", "roblox.*://navigation/blocked_experiences_subsettings")
game:DefineFastString("ExperienceChatSettingsDeepLinkPattern", "roblox.*://navigation/experience_chat_subsettings")
game:DefineFastString("PartySettingsDeepLinkPattern", "roblox.*://navigation/party_subsettings")
game:DefineFastString("VoiceSettingsDeepLinkPattern", "roblox.*://navigation/voice_subsettings")
game:DefineFastString("TradingInventorySettingsDeepLinkPattern", "roblox.*://navigation/trading_inventory_subsettings")
game:DefineFastString("PrivateServerSettingsDeepLinkPattern", "roblox.*://navigation/private_server_subsettings")
game:DefineFastString("FriendsContactsSettingsDeepLinkPattern", "roblox.*://navigation/friends_contacts_subsettings")
game:DefineFastString("VisibilitySettingsDeepLinkPattern", "roblox.*://navigation/visibility_subsettings")
game:DefineFastString("ParentalControlsDeepLinkPattern", "roblox.*://navigation/parental_controls")
game:DefineFastString("AccountInfoDeepLinkPattern", "roblox.*://navigation/account_info")
game:DefineFastString("SpendingSettingsDeepLinkPattern", "roblox.*://navigation/spending_settings")
game:DefineFastString("ExternalWebUrlDeepLinkPattern", "roblox.*://navigation/external_web_link.*")
game:DefineFastString("SecurityAlertDeepLinkPattern", "roblox.*://navigation/security_alert.*")
game:DefineFastString("ExperienceSortDeepLinkPattern", "roblox.*://navigation/experience_sort.*")
game:DefineFastString("SquadLobbyDeepLinkPattern", "roblox.*://navigation/party.*")
game:DefineFastString("EnterAppFromLockScreenWidget", "roblox.*://open/lock_screen_widget")
game:DefineFastString("DevicePreferencesDeepLinkPattern", "roblox.*://navigation/device_preferences")
game:DefineFastString("FAEDeepLinkPattern", "roblox.*://navigation/fae.*")
game:DefineFastString("FAEUpsellOverlayDeepLinkPattern", "roblox.*://navigation/fae_upsell_overlay.*")
game:DefineFastString("AmpWizardDeepLinkPattern", "roblox.*://navigation/amp_wizard.*")
game:DefineFastString("AccountUnlockDeepLinkPattern", "roblox.*://navigation/account_unlock.*")
game:DefineFastString("SystemMessageDeepLinkPattern", "roblox.*://navigation/messages.*")
game:DefineFastString("LuaExtraHttpLinkBases", "")
game:DefineFastFlag("EnableExternalWebDeeplink", false)
game:DefineFastFlag("EnableJoinLinkWebDeepLink", false)

local parts = string.split(game:GetFastString("LuaExtraHttpLinkBases"), ",")
local t1 = {}
local t2 = {
	notifstream = UpsellEntrySurfaceType.NotifStream,
	notifpush = UpsellEntrySurfaceType.NotifPush
}

local function addMapping(s1: string, p1: ((...any) -> ...any)) -- line: 216
	-- upvalues: t1 (copy), default (copy)
	table.insert(t1, {
		s1,
		p1
	})

	local v162 = s1:gsub("%%", "\\")

	default:registerURL(v162)
end
local function addHttpMapping(p2, p3) -- line: 224
	-- upvalues: UrlBase (copy), t1 (copy), default (copy), parts (copy)
	for _, v in pairs({
		"www",
		"web",
		""
	}) do
		local v167 = UrlBase.new(v)
		local v168 = UrlBase.new(v, {
			secure = false
		})
		local v169 = v167 .. "(/[A-Za-z][A-Za-z](%-[A-Za-z0-9][A-Za-z0-9][A-Za-z0-9]?)?)?" .. p2

		table.insert(t1, {
			v169,
			p3
		})

		local v170 = v169:gsub("%%", "\\")

		default:registerURL(v170)

		local v171 = v168 .. "(/[A-Za-z][A-Za-z](%-[A-Za-z0-9][A-Za-z0-9][A-Za-z0-9]?)?)?" .. p2

		table.insert(t1, {
			v171,
			p3
		})

		local v172 = v171:gsub("%%", "\\")

		default:registerURL(v172)
	end

	for _, v in ipairs(parts) do
		local v175 = v .. p2

		table.insert(t1, {
			v175,
			p3
		})

		local v176 = v175:gsub("%%", "\\")

		default:registerURL(v176)
	end
end
local function buildHistoryFromRoute(p4) -- line: 239
	local t3 = {}

	for i = 1, #p4 do
		local t4 = {}

		for j = 1, i do
			table.insert(t4, p4[j])
		end

		table.insert(t3, t4)
	end

	return t3
end

if FFlagEnableSearchDeepLink then
	local t5 = {
		games = SearchTypes.Games,
		players = SearchTypes.Players,
		topresults = SearchTypes.TopResults
	}
	local FastString = game:GetFastString("SearchDeepLinkPattern")

	table.insert(t1, {
		FastString,
		function(p5) -- line: 258
			-- upvalues: SearchUuid (copy), t5 (copy), SearchTypes (copy), AppPage (copy)
			local v183 = SearchUuid()
			local v184 = SearchUuid()
			local v185 = p5.keyword or ""
			local v186 = t5[string.lower(p5.type or "")] or SearchTypes.Games

			return {
				{{
					name = AppPage.Home
				}},
				{
					{
						name = AppPage.Home
					},
					{
						name = AppPage.SearchPage,
						detail = v183,
						extraProps = {
							searchKeyword = v185,
							searchType = v186,
							omniSearchInfo = {
								omniSearchUuid = v184,
								searchKeyword = v185
							}
						}
					}
				}
			}
		end
	})
	default:registerURL((FastString:gsub("%%", "\\")))
end

local FastString = game:GetFastString("GamesPageDeepLinkPattern")

table.insert(t1, {
	FastString,
	function() -- line: 287
		-- upvalues: AppPage (copy)
		return {{{
			name = AppPage.Games
		}}}
	end
})
default:registerURL((FastString:gsub("%%", "\\")))

local FastString2 = game:GetFastString("HomePageDeepLinkPattern")

table.insert(t1, {
	FastString2,
	function() -- line: 291
		-- upvalues: AppPage (copy)
		return {{{
			name = AppPage.Home
		}}}
	end
})
default:registerURL((FastString2:gsub("%%", "\\")))

if FFlagAppNavMyStatsTab then
	local FastString3 = game:GetFastString("BuildPageDeepLinkPattern")

	table.insert(t1, {
		FastString3,
		function(p6) -- line: 298
			-- upvalues: AppPage (copy)
			local num = tonumber(p6.universeid)
			local v189 = if p6.sessionid == "" then nil else p6.sessionid
			local v190 = if num == nil and v189 == nil then nil else {
				universeId = num,
				sessionId = v189
			}

			return {{{
				name = AppPage.MyStats,
				extraProps = v190
			}}}
		end
	})
	default:registerURL((FastString3:gsub("%%", "\\")))
end

if FFlagLuaAppSduiLandingPageEnabled then
	game:DefineFastString("SduiLandingPageDeepLinkPattern", "roblox.*://navigation/landing.*")

	local FastString4 = game:GetFastString("SduiLandingPageDeepLinkPattern")

	table.insert(t1, {
		FastString4,
		function(p7) -- line: 311
			-- upvalues: AppPage (copy)
			local page = p7.page

			if page == nil or page == "" then
				return
			end

			return {{
				{
					name = AppPage.Home
				},
				{
					name = AppPage.SduiLandingPage,
					detail = page,
					extraProps = {
						pageIdentifier = page
					}
				}
			}}
		end
	})
	default:registerURL((FastString4:gsub("%%", "\\")))
end

if FFlagLuaAppSduiLandingPageEnabled and FFlagLuaEnableGenreLandingDeeplink then
	game:DefineFastString("GenreLandingDeepLinkPattern", "roblox.*://navigation/genre.*")

	local FastString5 = game:GetFastString("GenreLandingDeepLinkPattern")

	table.insert(t1, {
		FastString5,
		function(p8) -- line: 335
			-- upvalues: AppPage (copy)
			local page = p8.page

			if page == nil or page == "" then
				return {{{
					name = AppPage.Home
				}}}
			end

			return {{
				{
					name = AppPage.Home
				},
				{
					name = AppPage.SduiLandingPage,
					detail = page,
					extraProps = {
						pageIdentifier = page,
						genre = p8.genre
					}
				}
			}}
		end
	})
	default:registerURL((FastString5:gsub("%%", "\\")))
end

local FastString6 = game:GetFastString("AvatarClothingSortingView")

table.insert(t1, {
	FastString6,
	function() -- line: 357
		-- upvalues: AvatarScreen (copy)
		return {{
			{
				name = AvatarScreen.AvatarExperienceLandingPage
			},
			{
				name = AvatarScreen.Catalog
			},
			{
				name = AvatarScreen.LayeredClothingSort
			}
		}}
	end
})
default:registerURL((FastString6:gsub("%%", "\\")))

if FFlagEnableProfilePictureEditorDeepLink then
	local FastString7 = game:GetFastString("AvatarProfilePictureEditor")

	table.insert(t1, {
		FastString7,
		function() -- line: 368
			-- upvalues: AvatarScreen (copy)
			return {{
				{
					name = AvatarScreen.AvatarExperienceLandingPage
				},
				{
					name = AvatarScreen.Catalog
				},
				{
					name = AvatarScreen.ProfilePictureEditorEmotes
				}
			}}
		end
	})
	default:registerURL((FastString7:gsub("%%", "\\")))
end

local FastString8 = game:GetFastString("AvatarDeepLinkPattern")

table.insert(t1, {
	FastString8,
	function(p9) -- line: 379
		-- upvalues: AvatarScreen (copy), Utils (copy), Constants2 (copy), Constants (copy), buildHistoryFromRoute (copy)
		local t6 = {
			{
				name = AvatarScreen.AvatarExperienceLandingPage
			},
			{
				name = AvatarScreen.AvatarEditor
			}
		}

		if p9.itemtype == "character" then
			local v197, v198 = Utils.findAvatarEditorCategory(Constants2.CharacterKey, Constants2.PurchasedCharacterKey)
			local t7 = {
				itemId = p9.itemid,
				category = v197,
				subcategory = v198
			}

			table.insert(t6, {
				name = AvatarScreen.OutfitDetails,
				extraProps = t7
			})
		elseif p9.itemtype == "asset" then
			local v200, v201 = Utils.getCategoryIndicesFromAssetType(p9.itemsubtype)
			local t8 = {
				mountAsFullView = true,
				itemId = p9.itemid,
				itemType = Constants.ItemType.Asset,
				category = v200,
				subcategory = v201,
				opaquePage = AvatarScreen.AvatarEditor
			}

			table.insert(t6, {
				name = AvatarScreen.ItemDetails,
				extraProps = t8
			})
		end

		return (buildHistoryFromRoute(t6))
	end
})
default:registerURL((FastString8:gsub("%%", "\\")))
addHttpMapping(game:GetFastString("AvatarHttpPattern"), function(_, p11) -- line: 420
	-- upvalues: Cryo (copy), AvatarScreen (copy)
	return Cryo.List.join(p11.history, {
		{{
			name = AvatarScreen.AvatarExperienceLandingPage
		}},
		{
			{
				name = AvatarScreen.AvatarExperienceLandingPage
			},
			{
				name = AvatarScreen.AvatarEditor
			}
		}
	})
end)

local FastString9 = game:GetFastString("MorePageDeepLinkPattern")

table.insert(t1, {
	FastString9,
	function() -- line: 433
		-- upvalues: FFlagEnableFlyoutSidePanel (copy), AppPage (copy)
		return {{{
			name = if not FFlagEnableFlyoutSidePanel then AppPage.More else AppPage.Home
		}}}
	end
})
default:registerURL((FastString9:gsub("%%", "\\")))

local function subSettingsMapping(s2: string, s3: string) -- line: 437
	-- upvalues: FFlagEnableFlyoutSidePanel (copy), AppPage (copy), TransitionAnimation (copy)
	return {
		{{
			name = if not FFlagEnableFlyoutSidePanel then AppPage.More else AppPage.Home
		}},
		{
			{
				name = if not FFlagEnableFlyoutSidePanel then AppPage.More else AppPage.Home
			},
			{
				name = AppPage.Settings
			}
		},
		{
			{
				name = if not FFlagEnableFlyoutSidePanel then AppPage.More else AppPage.Home
			},
			{
				name = AppPage.Settings
			},
			{
				name = AppPage.SettingsSubPage,
				detail = s2,
				extraProps = {
					titleKey = s3,
					transitionAnimation = TransitionAnimation.None
				}
			}
		}
	}
end

local FastString10 = game:GetFastString("NotificationSettingsDeepLinkPattern")

table.insert(t1, {
	FastString10,
	function(p12) -- line: 461
		-- upvalues: UrlBuilder (copy), v49 (copy), subSettingsMapping (copy)
		local v208 = UrlBuilder.static.settings.notifications()

		if v49 and p12 then
			local v209 = if p12.category == "" then nil else p12.category
			local v210 = if p12.type == "" then nil else p12.type

			if v209 and v210 then
				v208 ..= "/" .. v209 .. "/" .. v210
			elseif v209 then
				v208 ..= "/" .. v209
			end
		end

		return (subSettingsMapping(v208, "Feature.AccountSettings.Heading.Tab.Notifications"))
	end
})
default:registerURL((FastString10:gsub("%%", "\\")))

if FFlagEnableNotificationsDeeplink then
	local FastString11 = game:GetFastString("NotificationsDeepLinkPattern")

	table.insert(t1, {
		FastString11,
		function() -- line: 481
			-- upvalues: FFlagStreamNotificationDropdownSingleOwner (copy), StreamNotificationStore (copy)
			if FFlagStreamNotificationDropdownSingleOwner then
				StreamNotificationStore.setActiveBellId(StreamNotificationStore.PrimaryBellId)
			end

			StreamNotificationStore.setStreamPresented(true)

			return nil
		end
	})
	default:registerURL((FastString11:gsub("%%", "\\")))
end

local function getChatEntryPointEnum(p13) -- line: 493
	-- upvalues: ChatEntryPointNames (copy)
	if type(p13) ~= "string" then
		return ChatEntryPointNames.Unknown
	end

	for k, v in pairs(ChatEntryPointNames) do
		if string.lower(k) == string.lower(p13) then
			return v
		end
	end

	return ChatEntryPointNames.Unknown
end

local FastString12 = game:GetFastString("RoactChatDeepLinkPattern")

table.insert(t1, {
	FastString12,
	function(p14, p15) -- line: 508
		-- upvalues: getChatEntryPointEnum (copy), CreateConversation (copy), AppPage (copy)
		local t9 = {
			entryPoint = getChatEntryPointEnum(p14.entrypoint)
		}

		if p14.chatid == nil and p14.userid ~= nil then
			return CreateConversation(p15.network, "one_to_one", { p14.userid }):andThen(function(p16) -- line: 514
				-- upvalues: AppPage (copy), t9 (copy)
				local str = tostring(p16.responseBody.conversations[1].id)

				return {{{
					name = AppPage.Chat,
					detail = str,
					extraProps = t9
				}}}
			end):catch(function() -- line: 525
				-- upvalues: AppPage (copy), t9 (copy)
				return {{{
					name = AppPage.Chat,
					extraProps = t9
				}}}
			end)
		end

		return {{{
			name = AppPage.Chat,
			detail = p14.chatid,
			extraProps = t9
		}}}
	end
})
default:registerURL((FastString12:gsub("%%", "\\")))

local FastString13 = game:GetFastString("GameDetailsDeepLinkPattern")

table.insert(t1, {
	FastString13,
	function(p17) -- line: 543
		-- upvalues: AppPage (copy), FFlagEnableShareLinksInGameDetailEvent (copy), logGameDetailsDeepLinkEvent (copy), GetFFlagLuaAppFixStudioNotchSupport (copy), HardwareSafeAreaInsets (copy), Workspace (copy), UseGameDetailsPeekView (copy), ArgCheck (copy)
		local GameDetail = AppPage.GameDetail

		if FFlagEnableShareLinksInGameDetailEvent then
			logGameDetailsDeepLinkEvent(p17.gameid, "GameDetailsDeeplink", {})
		else
			logGameDetailsDeepLinkEvent(p17.gameid, "GameDetailsDeeplink")
		end

		if p17.homeroot then
			local v219 = if not GetFFlagLuaAppFixStudioNotchSupport() then Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize or Vector2.zero else HardwareSafeAreaInsets.fullscreenGui().AbsoluteSize
			local v220 = if not (v219.Y > v219.X) or not UseGameDetailsPeekView() then AppPage.ExperienceDetail else AppPage.GameDetail

			return {
				{{
					name = AppPage.Home
				}},
				{
					{
						name = AppPage.Home
					},
					{
						name = v220,
						detail = ArgCheck.isNotNil(p17.gameid, "gameId"),
						extraProps = {
							mountAsFullView = false,
							mountAnimation = true
						}
					}
				}
			}
		end

		return {
			{{
				name = AppPage.Games
			}},
			{
				{
					name = AppPage.Games
				},
				{
					name = GameDetail,
					detail = ArgCheck.isNotNil(p17.gameid, "gameId"),
					extraProps = {
						mountAsFullView = true,
						mountAnimation = false
					}
				}
			}
		}
	end
})
default:registerURL((FastString13:gsub("%%", "\\")))
addHttpMapping(game:GetFastString("GameDetailsHttpPattern"), function(p18, p19, p20) -- line: 602
	-- upvalues: ShareLinkTypes (copy), ExperienceService (copy), AppPage (copy), GamesMultigetPlaceDetails (copy), FFlagEnableShareLinksInGameDetailEvent (copy), logGameDetailsDeepLinkEvent (copy)
	if p19.privateserverlinkcode ~= nil then
		p20.analyticsImpls.shareLinksAnalytics.openAppViaShareLink({
			placeId = p18,
			linkCode = p19.privateserverlinkcode,
			linkType = ShareLinkTypes.LongPrivateServerLink
		})
		ExperienceService:LaunchExperience({
			placeId = if type(p18) ~= "number" then tonumber(p18) else p18,
			linkCode = p19.privateserverlinkcode
		})

		return nil
	end

	local GameDetail = AppPage.GameDetail

	return GamesMultigetPlaceDetails(p20.network, p18):andThen(function(p21) -- line: 620
		-- upvalues: FFlagEnableShareLinksInGameDetailEvent (copy), logGameDetailsDeepLinkEvent (copy), AppPage (copy), GameDetail (copy)
		local str = tostring(p21.responseBody[1].universeId)

		if FFlagEnableShareLinksInGameDetailEvent then
			logGameDetailsDeepLinkEvent(str, "GameDetailsHTTPDeepLink", {})
		else
			logGameDetailsDeepLinkEvent(str, "GameDetailsHTTPDeepLink")
		end

		return {
			{{
				name = AppPage.Games
			}},
			{
				{
					name = AppPage.Games
				},
				{
					name = GameDetail,
					detail = str,
					extraProps = {
						mountAsFullView = true,
						mountAnimation = false
					}
				}
			}
		}
	end)
end)
addHttpMapping(game:GetFastString("GameDetailsReferralHttpPattern"), function(p22, p23) -- line: 649
	-- upvalues: ArgCheck (copy), AppPage (copy), GamesMultigetPlaceDetails (copy), FFlagEnableShareLinksInGameDetailEvent (copy), logGameDetailsDeepLinkEvent (copy)
	local v227 = ArgCheck.isNotNil(p22.placeid, "placeid")
	local GameDetail = AppPage.GameDetail

	return GamesMultigetPlaceDetails(p23.network, v227):andThen(function(p24) -- line: 653
		-- upvalues: FFlagEnableShareLinksInGameDetailEvent (copy), logGameDetailsDeepLinkEvent (copy), AppPage (copy), GameDetail (copy)
		local str = tostring(p24.responseBody[1].universeId)

		if FFlagEnableShareLinksInGameDetailEvent then
			logGameDetailsDeepLinkEvent(str, "GameDetailsHTTPReferralDeepLink", {})
		else
			logGameDetailsDeepLinkEvent(str, "GameDetailsHTTPReferralDeepLink")
		end

		return {
			{{
				name = AppPage.Games
			}},
			{
				{
					name = AppPage.Games
				},
				{
					name = GameDetail,
					detail = str,
					extraProps = {
						mountAsFullView = true,
						mountAnimation = false
					}
				}
			}
		}
	end)
end)

local FastString14 = game:GetFastString("ProfileCardDeepLinkPattern")

table.insert(t1, {
	FastString14,
	function(p25) -- line: 682
		-- upvalues: AppPage (copy), Enums (copy)
		local v230 = p25.userid or ""

		return {{
			{
				name = AppPage.Home
			},
			{
				name = AppPage.ProfilePlatform,
				detail = v230,
				extraProps = {
					source = Enums.Sources.ProfileDeepLink
				}
			}
		}}
	end
})
default:registerURL((FastString14:gsub("%%", "\\")))

if FFlagTCParentChildAutoUpgrade then
	local FastString15 = game:GetFastString("ProfileTrustedFriendsDeepLinkPattern")

	table.insert(t1, {
		FastString15,
		function(p26, _) -- line: 700
			-- upvalues: AppPage (copy), Enums (copy)
			local v233 = p26.userid or ""

			return {{
				{
					name = AppPage.Home
				},
				{
					name = AppPage.ProfilePlatform,
					detail = v233,
					extraProps = {
						source = Enums.Sources.ProfileDeepLink
					}
				},
				{
					name = AppPage.TrustedContactsModal,
					props = {
						source = "Deeplink_Profile_TrustedFriends",
						userId = v233
					}
				}
			}}
		end
	})
	default:registerURL((FastString15:gsub("%%", "\\")))
end

local FastString16 = game:GetFastString("ProfileDeepLinkPattern")

table.insert(t1, {
	FastString16,
	function(p28, p29) -- line: 725
		-- upvalues: ArgCheck (copy), UrlBuilder (copy), AppPage (copy), TransitionAnimation (copy)
		local v236 = ArgCheck.isNotNil(p28.userid, "userId")
		local friendshipsourcetype = p28.friendshipsourcetype
		local v238 = UrlBuilder.user.profile({
			userId = v236,
			sourceType = friendshipsourcetype
		})

		if friendshipsourcetype == "profileshare" then
			p29.analyticsImpls.socialProfileShareAnalytics.inviteePageLoad(v236, "playerProfile")
		end

		return {
			{{
				name = AppPage.Home
			}},
			{
				{
					name = AppPage.Home
				},
				{
					name = AppPage.GenericWebPage,
					detail = v238,
					extraProps = {
						titleKey = "CommonUI.Features.Label.Profile",
						transitionAnimation = TransitionAnimation.None
					}
				}
			}
		}
	end
})
default:registerURL((FastString16:gsub("%%", "\\")))

local FastString17 = game:GetFastString("GroupsDeepLinkPattern")

table.insert(t1, {
	FastString17,
	function(p30) -- line: 756
		-- upvalues: UrlBuilder (copy), ArgCheck (copy), FFlagLuaAppForumsDeeplinkFix (copy), AppPage (copy), GetFFlagUseCommunitiesTranslation (copy), TransitionAnimation (copy)
		local v240 = if not p30.forumcategoryid or (p30.forumcategoryid == "" or (not p30.forumpostid or (p30.forumpostid == "" or (not p30.forumcommentid or p30.forumcommentid == "")))) then UrlBuilder.user.group({
			groupId = ArgCheck.isNotNil(p30.groupid, "groupId")
		}) else UrlBuilder.user.forumComment({
			groupId = ArgCheck.isNotNil(p30.groupid, "groupId"),
			categoryId = if not FFlagLuaAppForumsDeeplinkFix then ArgCheck.isNotNil(p30.forumcategoryid, "categoryId") else "category-" .. ArgCheck.isNotNil(p30.forumcategoryid, "categoryId"),
			postId = if not FFlagLuaAppForumsDeeplinkFix then ArgCheck.isNotNil(p30.forumpostid, "postId") else "post-" .. ArgCheck.isNotNil(p30.forumpostid, "postId"),
			commentId = ArgCheck.isNotNil(p30.forumcommentid, "commentId")
		})

		return {
			{{
				name = AppPage.Home
			}},
			{
				{
					name = AppPage.Home
				},
				{
					name = AppPage.GenericWebPage,
					detail = v240,
					extraProps = {
						titleKey = not GetFFlagUseCommunitiesTranslation() and "CommonUI.Features.Label.sGroups" or "CommonUI.Features.Label.Groups",
						transitionAnimation = TransitionAnimation.None
					}
				}
			}
		}
	end
})
default:registerURL((FastString17:gsub("%%", "\\")))

local FastString18 = game:GetFastString("ContactsDeepLinkPattern")

table.insert(t1, {
	FastString18,
	function(p31, _) -- line: 801
		-- upvalues: AppPage (copy), Constants3 (copy), FFlagCiDeprecateFindFriendsModal (copy), contactImporterModalInfo (copy), AppStorageService (copy), LocalPlayer (copy)
		local v243 = if not p31.contactid or p31.contactid == "" then {
			detail = "",
			name = if not FFlagCiDeprecateFindFriendsModal then if contactImporterModalInfo:isUserOptedInLocalStorage(AppStorageService, (not LocalPlayer or not LocalPlayer.UserId) and "" or tostring(LocalPlayer.UserId)) then AppPage.ContactsList else AppPage.ContactImporter else AppPage.ContactImporter,
			extraProps = {
				isPhoneVerified = true,
				entryPoint = if not FFlagCiDeprecateFindFriendsModal then nil else p31.entryPoint
			}
		} else {
			name = AppPage.ProfilePlatform,
			detail = p31.contactid,
			extraProps = {
				profileType = Constants3.CONTACT
			}
		}

		return { if not FFlagCiDeprecateFindFriendsModal then {
			{
				name = AppPage.Home
			},
			{
				name = AppPage.AddFriendsPage
			},
			v243
		} else {
			{
				name = AppPage.Home
			},
			v243
		} }
	end
})
default:registerURL((FastString18:gsub("%%", "\\")))
addHttpMapping(game:GetFastString("StaticShareLinkHttpPattern"), function(p33, p34, p35, p36) -- line: 849
	-- upvalues: handleStaticShareLink (copy), Cryo (copy)
	return handleStaticShareLink(p33, p34, Cryo.Dictionary.join(p35, {
		isViaAppsFlyer = false
	}), p36)
end)

local FastString19 = game:GetFastString("StaticShareLinkDeepLinkPattern")

table.insert(t1, {
	FastString19,
	function(p37, p38, p39, p40) -- line: 856
		-- upvalues: handleStaticShareLink (copy), Cryo (copy)
		return handleStaticShareLink(p37, p38, Cryo.Dictionary.join(p39, {
			isViaAppsFlyer = true
		}), p40)
	end
})
default:registerURL((FastString19:gsub("%%", "\\")))

local FastString20 = game:GetFastString("ShareLinkDeepLinkPattern")

table.insert(t1, {
	FastString20,
	function(p41, p42) -- line: 861
		-- upvalues: handleShareLinkRoot (copy), Cryo (copy)
		return handleShareLinkRoot(Cryo.Dictionary.join(p41, {
			isViaAppsFlyer = true
		}), p42)
	end
})
default:registerURL((FastString20:gsub("%%", "\\")))

local function v116(p43, p44) -- line: 865
	-- upvalues: handleShareLinkRoot (copy), Cryo (copy)
	return handleShareLinkRoot(Cryo.Dictionary.join(p43, {
		isViaAppsFlyer = false
	}), p44)
end

addHttpMapping(game:GetFastString("ShareLinkHttpPattern"), v116)
addHttpMapping(game:GetFastString("ShortShareLinkHttpPattern"), v116)

if game:GetFastFlag("EnableJoinLinkWebDeepLink") then
	addHttpMapping(game:GetFastString("JoinLinkHttpPattern"), function(p45, p46, p47) -- line: 873
		-- upvalues: handleJoinLink (copy)
		return handleJoinLink(p45, p46, p47)
	end)
end

local FastString21 = game:GetFastString("CatalogEquipDeepLinkPattern")

table.insert(t1, {
	FastString21,
	function(p48) -- line: 878
		-- upvalues: AvatarScreen (copy)
		local t10 = {
			wasItemEquipped = false,
			fetchItemFailed = false,
			itemId = p48.itemid,
			itemType = p48.itemtype
		}

		return {
			{{
				name = AvatarScreen.AvatarExperienceLandingPage
			}},
			{
				{
					name = AvatarScreen.AvatarExperienceLandingPage
				},
				{
					name = AvatarScreen.Catalog,
					extraProps = t10
				}
			}
		}
	end
})
default:registerURL((FastString21:gsub("%%", "\\")))

if FFlagEnableCatalogSearchDeepLinks then
	local FastString22 = game:GetFastString("CatalogSearchDeepLinkPattern")

	table.insert(t1, {
		FastString22,
		function(p49) -- line: 901
			-- upvalues: AvatarScreen (copy)
			local t11 = {}
			local t12 = {{{
				name = AvatarScreen.AvatarExperienceLandingPage
			}}}

			t11.creatorName = p49.creatorname
			t11.minPrice = p49.minprice
			t11.maxPrice = p49.maxprice
			t11.salesTypeFilter = p49.salestypefilter
			t11.includeNotForSale = p49.includenotforsale
			t11.sortType = p49.sorttype
			t11.sortAggregation = p49.sortaggregation
			t11.category = p49.category
			t11.subcategory = p49.subcategory
			t11.taxonomy = p49.taxonomy
			t11.keyword = p49.keyword
			t11.topics = p49.topics
			t11.wearTimeFilter = p49.wearTimeFilter

			if t11.keyword then
				table.insert(t12, {
					{
						name = AvatarScreen.AvatarExperienceLandingPage
					},
					{
						name = AvatarScreen.CatalogSearch,
						extraProps = t11
					}
				})

				return t12
			end

			table.insert(t12, {
				{
					name = AvatarScreen.AvatarExperienceLandingPage
				},
				{
					name = AvatarScreen.Catalog,
					extraProps = t11
				}
			})

			return t12
		end
	})
	default:registerURL((FastString22:gsub("%%", "\\")))
end

local FastString23 = game:GetFastString("ExperienceSortDeepLinkPattern")

table.insert(t1, {
	FastString23,
	function(p50, ...) -- line: 946
		-- upvalues: SortIdMapper (copy), AppPage (copy), FFlagLuaAppSortDeeplinkFix (copy)
		if not p50.sortId then
			return
		end

		local v265, v266 = SortIdMapper(p50.sortId)

		return {{
			{
				name = AppPage.Home
			},
			{
				name = if not FFlagLuaAppSortDeeplinkFix then AppPage.GamesList else AppPage.DeeplinkGamesList,
				detail = v265,
				extraProps = {
					sortName = v265,
					pageContext = not FFlagLuaAppSortDeeplinkFix and "Deeplink" or nil,
					isOmni = v266,
					sortIndex = if FFlagLuaAppSortDeeplinkFix or not v266 then nil else 1
				}
			}
		}}
	end
})
default:registerURL((FastString23:gsub("%%", "\\")))

local FastString24 = game:GetFastString("CatalogDeepLinkPattern")

table.insert(t1, {
	FastString24,
	function() -- line: 970
		-- upvalues: AvatarScreen (copy)
		return {
			{{
				name = AvatarScreen.AvatarExperienceLandingPage
			}},
			{
				{
					name = AvatarScreen.AvatarExperienceLandingPage
				},
				{
					name = AvatarScreen.Catalog
				}
			}
		}
	end
})
default:registerURL((FastString24:gsub("%%", "\\")))

local FastString25 = game:GetFastString("ItemDetailsDeepLinkPattern")

table.insert(t1, {
	FastString25,
	function(p51) -- line: 982
		-- upvalues: ArgCheck (copy), Constants (copy), AvatarScreen (copy), FFlagEnableLookDetailsDeepLink (copy)
		local v268 = ArgCheck.isNotNil(p51.itemid, "itemId")
		local v269 = ArgCheck.isNotNil(p51.itemtype, "itemType")
		local v270 = nil

		for _, v in pairs(Constants.ItemType) do
			if string.lower(v269) == string.lower(v) then
				v270 = v

				break
			end
		end

		local t13 = {
			{{
				name = AvatarScreen.AvatarExperienceLandingPage
			}},
			{
				{
					name = AvatarScreen.AvatarExperienceLandingPage
				},
				{
					name = AvatarScreen.Catalog
				}
			}
		}
		local v274 = tostring(v270) .. tostring(v268)
		local ItemDetails = AvatarScreen.ItemDetails

		if FFlagEnableLookDetailsDeepLink and v270 == Constants.ItemType.Look then
			ItemDetails = AvatarScreen.LookDetails
		end

		local t14 = {
			name = ItemDetails,
			detail = v274,
			extraProps = {
				mountAsFullView = true,
				mountAnimation = false,
				itemId = v268,
				itemType = v270
			}
		}

		if v270 ~= nil then
			table.insert(t13, {
				{
					name = AvatarScreen.AvatarExperienceLandingPage
				},
				{
					name = AvatarScreen.Catalog
				},
				t14
			})
		end

		return t13
	end
})
default:registerURL((FastString25:gsub("%%", "\\")))
addHttpMapping(game:GetFastString("ItemDetailsHttpPattern"), function(p52, _, p54) -- line: 1033
	-- upvalues: Constants (copy), Cryo (copy), AvatarScreen (copy)
	local Asset = Constants.ItemType.Asset
	local v281 = Asset .. p52

	return Cryo.List.join(p54.history, {{
		{
			name = AvatarScreen.AvatarExperienceLandingPage
		},
		{
			name = AvatarScreen.Catalog
		}
	}}, {{
		{
			name = AvatarScreen.AvatarExperienceLandingPage
		},
		{
			name = AvatarScreen.Catalog
		},
		{
			name = AvatarScreen.ItemDetails,
			detail = v281,
			extraProps = {
				mountAsFullView = true,
				mountAnimation = false,
				itemId = p52,
				itemType = Asset
			}
		}
	}})
end)

if v61 then
	addHttpMapping(game:GetFastString("BundleItemDetailsHttpPattern"), function(p55, _, p57) -- line: 1068
		-- upvalues: Constants (copy), Cryo (copy), AvatarScreen (copy)
		local Bundle = Constants.ItemType.Bundle
		local v286 = Bundle .. p55
		local history = p57.history

		return Cryo.List.join(history, {{
			{
				name = AvatarScreen.AvatarExperienceLandingPage
			},
			{
				name = AvatarScreen.Catalog
			},
			{
				name = AvatarScreen.ItemDetails,
				detail = v286,
				extraProps = {
					mountAsFullView = true,
					mountAnimation = false,
					itemId = p55,
					itemType = Bundle
				}
			}
		}})
	end)
end

if FFlagEnableLookDetailsDeepLink then
	addHttpMapping(game:GetFastString("LookItemDetailsHttpPattern"), function(p58, _, p60) -- line: 1095
		-- upvalues: Constants (copy), Cryo (copy), AvatarScreen (copy)
		local v291 = Constants.ItemType.Look .. p58
		local history = p60.history

		return Cryo.List.join(history, {{
			{
				name = AvatarScreen.AvatarExperienceLandingPage
			},
			{
				name = AvatarScreen.Catalog
			},
			{
				name = AvatarScreen.LookDetails,
				detail = v291,
				extraProps = {
					mountAsFullView = true,
					itemId = p58
				}
			}
		}})
	end)
end

if FFlagQRCodeItemRedemptionEnabled then
	local FastString26 = game:GetFastString("ItemRedemptionDeepLinkPattern")

	table.insert(t1, {
		FastString26,
		function(p61) -- line: 1121
			-- upvalues: ArgCheck (copy), Constants (copy), AvatarScreen (copy)
			local v294 = ArgCheck.isNotNil(p61.itemid, "itemId")
			local v295 = ArgCheck.isNotNil(p61.itemtype, "itemType")
			local v296 = nil

			for _, v in pairs(Constants.ItemType) do
				if string.lower(v295) == string.lower(v) then
					v296 = v

					break
				end
			end

			local t15 = {
				{{
					name = AvatarScreen.AvatarExperienceLandingPage
				}},
				{
					{
						name = AvatarScreen.AvatarExperienceLandingPage
					},
					{
						name = AvatarScreen.Catalog
					}
				}
			}
			local v300 = tostring(v296) .. tostring(v294)
			local t16 = {
				name = AvatarScreen.ItemDetails,
				detail = v300,
				extraProps = {
					mountAsFullView = true,
					mountAnimation = false,
					redeemQRCodeItem = true,
					itemId = v294,
					itemType = v296
				}
			}

			if v296 ~= nil then
				table.insert(t15, {
					{
						name = AvatarScreen.AvatarExperienceLandingPage
					},
					{
						name = AvatarScreen.Catalog
					},
					t16
				})
			end

			return t15
		end
	})
	default:registerURL((FastString26:gsub("%%", "\\")))
end

addHttpMapping(game:GetFastString("CatalogHttpPattern"), function(p62, p63) -- line: 1169
	-- upvalues: FFlagAXEnableCatalogCreatorHttpLink (copy), Cryo (copy), AvatarScreen (copy), DeepLinkUtils (copy)
	if FFlagAXEnableCatalogCreatorHttpLink then
		return Cryo.List.join(p63.history, {{
			{
				name = AvatarScreen.AvatarExperienceLandingPage
			},
			{
				name = AvatarScreen.Catalog,
				extraProps = DeepLinkUtils.convertCatalogSearchParamsV1ToV2(p62)
			}
		}})
	end

	return Cryo.List.join(p63.history, {{
		{
			name = AvatarScreen.AvatarExperienceLandingPage
		},
		{
			name = AvatarScreen.Catalog
		}
	}})
end)

local FastString27 = game:GetFastString("FriendsPageDeepLinkPattern")

table.insert(t1, {
	FastString27,
	function() -- line: 1193
		-- upvalues: AppPage (copy)
		return {
			{{
				name = AppPage.Home
			}},
			{
				{
					name = AppPage.Home
				},
				{
					name = AppPage.ViewFriends
				}
			}
		}
	end
})
default:registerURL((FastString27:gsub("%%", "\\")))

if FFlagEnablePlusUpsellDeepLink then
	local FastString28 = game:GetFastString("PlusUpsellDeepLinkPattern")

	table.insert(t1, {
		FastString28,
		function() -- line: 1206
			-- upvalues: RobloxSubscriptionPurchaseApp (copy), SurfaceName (copy), SurfaceContext (copy)
			RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase(nil, nil, nil, SurfaceName.DeepLinkUpsell, SurfaceContext.InApp)

			return nil
		end
	})
	default:registerURL((FastString28:gsub("%%", "\\")))
end

if v55 then
	local FastString29 = game:GetFastString("BuyRobuxDeepLinkPattern")

	table.insert(t1, {
		FastString29,
		function(p64) -- line: 1220
			-- upvalues: AppPage (copy)
			local t17 = {}

			if p64.analyticid and p64.analyticid ~= "" then
				t17.analyticId = p64.analyticid
			end

			if p64.product_id and p64.product_id ~= "" then
				t17.productId = p64.product_id
			end

			return {
				{{
					name = AppPage.Home
				}},
				{
					{
						name = AppPage.Home
					},
					{
						name = AppPage.PurchaseRobux,
						extraProps = if not next(t17) then nil else t17
					}
				}
			}
		end
	})
	default:registerURL((FastString29:gsub("%%", "\\")))
end

if FFlagEnableSchoolEntry then
	local FastString30 = game:GetFastString("AddSchoolDeepLinkPattern")

	table.insert(t1, {
		FastString30,
		function(p65) -- line: 1244
			-- upvalues: AppPage (copy)
			local t18 = {}

			if p65.source and p65.source ~= "" then
				t18.source = p65.source
			end

			return {
				{{
					name = AppPage.AddFriendsPage
				}},
				{
					{
						name = AppPage.AddFriendsPage
					},
					{
						name = AppPage.Schools,
						extraProps = if not next(t18) then nil else t18
					}
				}
			}
		end
	})
	default:registerURL((FastString30:gsub("%%", "\\")))
end

if GetFFlagEnableGiftCardsDeepLink() then
	local FastString31 = game:GetFastString("GiftCardsPageDeepLinkPattern")

	table.insert(t1, {
		FastString31,
		function() -- line: 1265
			-- upvalues: AppPage (copy), UrlBuilder (copy), TransitionAnimation (copy)
			return {
				{{
					name = AppPage.Home
				}},
				{
					{
						name = AppPage.Home
					},
					{
						name = AppPage.GenericWebPage,
						detail = UrlBuilder.static.giftCards(),
						extraProps = {
							titleKey = "CommonUI.Features.Label.GiftCards",
							transitionAnimation = TransitionAnimation.None
						}
					}
				}
			}
		end
	})
	default:registerURL((FastString31:gsub("%%", "\\")))
end

local function handleCurrencyTransferLink(p66, _) -- line: 1288
	-- upvalues: FFlagCurrencyTransferDeepLinkValidateSender (copy), LocalPlayer (copy), AppPage (copy)
	local direction = p66.direction

	if not direction or direction ~= "send" and direction ~= "receive" then
		return nil
	end

	if direction == "send" then
		if not p66.userid or p66.userid == "" then
			return nil
		end

		if FFlagCurrencyTransferDeepLinkValidateSender and p66.senderid and p66.senderid ~= "" then
			local v311 = if not LocalPlayer or (not LocalPlayer.UserId or LocalPlayer.UserId == 0) then nil else tostring(LocalPlayer.UserId)

			if v311 == nil or v311 ~= p66.senderid then
				return nil
			end
		end
	elseif not p66.transferrequestid or p66.transferrequestid == "" then
		return nil
	end

	local t19 = {
		direction = direction
	}

	if direction == "send" then
		t19.recipientUserId = p66.userid

		if p66.transferorigination then
			t19.transferOrigination = p66.transferorigination
		end
	else
		t19.transferId = p66.transferrequestid
	end

	return {
		{{
			name = AppPage.Home
		}},
		{
			{
				name = AppPage.Home
			},
			{
				name = AppPage.TransferRobuxFlow,
				extraProps = t19
			}
		}
	}
end

if FFlagEnableCurrencyTransferDeepLink then
	local FastString32 = game:GetFastString("CurrencyTransferDeepLinkPattern")

	table.insert(t1, {
		FastString32,
		handleCurrencyTransferLink
	})
	default:registerURL((FastString32:gsub("%%", "\\")))
end

if GetFFlagEnableMessagesDeepLink() then
	local FastString33 = game:GetFastString("SystemMessageDeepLinkPattern")

	table.insert(t1, {
		FastString33,
		function() -- line: 1346
			-- upvalues: AppPage (copy), UrlBuilder (copy), TransitionAnimation (copy)
			return {
				{{
					name = AppPage.Home
				}},
				{
					{
						name = AppPage.Home
					},
					{
						name = AppPage.GenericWebPage,
						detail = UrlBuilder.static.messages(),
						extraProps = {
							titleKey = "CommonUI.Features.Label.Messages",
							transitionAnimation = TransitionAnimation.None
						}
					}
				}
			}
		end
	})
	default:registerURL((FastString33:gsub("%%", "\\")))
end

if game:GetFastFlag("EnableExternalWebDeeplink") then
	local FastString34 = game:GetFastString("ExternalWebUrlDeepLinkPattern")

	table.insert(t1, {
		FastString34,
		function(p68) -- line: 1367
			-- upvalues: ExternalWebUrlNavigationHelper (copy), AppPage (copy), TransitionAnimation (copy)
			local v314 = nil
			local v315 = nil

			if p68.domain == ExternalWebUrlNavigationHelper.ExternalWebDomainEnum.Zendesk then
				v314 = ExternalWebUrlNavigationHelper.getZendeskUrl(p68)
				v315 = ExternalWebUrlNavigationHelper.getZendeskWebViewTitleKey(p68.type)
			end

			if not v314 then
				return nil
			end

			return {
				{{
					name = AppPage.Home
				}},
				{
					{
						name = AppPage.Home
					},
					{
						name = AppPage.GenericWebPage,
						detail = v314,
						extraProps = {
							titleKey = v315,
							transitionAnimation = TransitionAnimation.None
						}
					}
				}
			}
		end
	})
	default:registerURL((FastString34:gsub("%%", "\\")))
end

if GetFFlagEnableCrossDeviceLoginUsingQRCodes() then
	local FastString35 = game:GetFastString("CrossDeviceLoginDeepLinkPattern")

	table.insert(t1, {
		FastString35,
		function(p69) -- line: 1402
			-- upvalues: ArgCheck (copy), FFlagEnableFlyoutSidePanel (copy), AppPage (copy)
			local v317 = ArgCheck.isNotNil(p69.code, "code")
			local source = p69.source

			return {{
				{
					name = if not FFlagEnableFlyoutSidePanel then AppPage.More else AppPage.Home
				},
				{
					name = AppPage.CrossDeviceLogin,
					extraProps = {
						code = v317,
						source = source
					}
				}
			}}
		end
	})
	default:registerURL((FastString35:gsub("%%", "\\")))
end

local FastString36 = game:GetFastString("EventDetailsPageDeepLinkPattern")

table.insert(t1, {
	FastString36,
	function(p70) -- line: 1421
		-- upvalues: AppPage (copy), ArgCheck (copy)
		return {
			{{
				name = AppPage.Home
			}},
			{
				{
					name = AppPage.Home
				},
				{
					name = AppPage.EventDetails,
					detail = ArgCheck.isNotNil(p70.eventid, "eventid")
				}
			}
		}
	end
})
default:registerURL((FastString36:gsub("%%", "\\")))

local FastString37 = game:GetFastString("AppealsPortalDeepLinkPattern")

table.insert(t1, {
	FastString37,
	function(p71) -- line: 1436
		-- upvalues: FFlagEnableFlyoutSidePanel (copy), AppPage (copy), UrlBuilder (copy)
		return {{
			{
				name = if not FFlagEnableFlyoutSidePanel then AppPage.More else AppPage.Home
			},
			{
				name = AppPage.GenericWebPage,
				detail = if not p71.vid then UrlBuilder.static.appealsPortal.main({
					source = "deeplink"
				}) else UrlBuilder.static.appealsPortal.violation({
					source = "deeplink",
					id = p71.vid
				}),
				extraProps = {
					titleKey = "Feature.AppealsPortal.Label.ReportAndAppeals"
				}
			}
		}}
	end
})
default:registerURL((FastString37:gsub("%%", "\\")))

if GetFFlagEnableSupportCenter() then
	local FastString38 = game:GetFastString("SupportCenterDeepLinkPattern")

	table.insert(t1, {
		FastString38,
		function(p72) -- line: 1457
			-- upvalues: UrlBuilder (copy), FFlagEnableFlyoutSidePanel (copy), AppPage (copy)
			local v322 = p72.ticketid or p72.ticketId
			local v323 = p72.universeid or p72.universeId
			local v324 = if not v323 or v323 == "" then nil else tonumber(v323)
			local v325 = if not v322 or (v322 == "" or not v324) then UrlBuilder.static.supportCenter.main() else UrlBuilder.static.supportCenter.ticket({
				universeId = v324,
				ticketId = v322
			})

			return {{
				{
					name = if not FFlagEnableFlyoutSidePanel then AppPage.More else AppPage.Home
				},
				{
					name = AppPage.GenericWebPage,
					detail = v325,
					extraProps = {
						titleKey = "CommonUI.Features.Label.SupportCenter"
					}
				}
			}}
		end
	})
	default:registerURL((FastString38:gsub("%%", "\\")))
end

if v44 then
	local FastString39 = game:GetFastString("PrivacySettingsDeepLinkPattern")

	table.insert(t1, {
		FastString39,
		function() -- line: 1489
			-- upvalues: UrlBuilder (copy), subSettingsMapping (copy)
			local v326 = UrlBuilder.static.settings.privacy()

			return (subSettingsMapping(v326, "Feature.AccountSettings.Heading.Tab.Privacy"))
		end
	})
	default:registerURL((FastString39:gsub("%%", "\\")))
end

if v48 then
	local FastString40 = game:GetFastString("AppPermissionsSettingsDeepLinkPattern")

	table.insert(t1, {
		FastString40,
		function() -- line: 1496
			-- upvalues: UrlBuilder (copy), subSettingsMapping (copy)
			local v327 = UrlBuilder.static.settings.appPermissions()

			return (subSettingsMapping(v327, "Feature.AccountSettings.Heading.Tab.AppPermissions"))
		end
	})
	default:registerURL((FastString40:gsub("%%", "\\")))

	local FastString41 = game:GetFastString("ScreentimeSettingsDeepLinkPattern")

	table.insert(t1, {
		FastString41,
		function() -- line: 1501
			-- upvalues: UrlBuilder (copy), subSettingsMapping (copy)
			local v328 = UrlBuilder.static.settings.screentimeSettings()

			return (subSettingsMapping(v328, "Feature.AccountSettings.Heading.ScreenTime"))
		end
	})
	default:registerURL((FastString41:gsub("%%", "\\")))

	local FastString42 = game:GetFastString("CommunicationSettingsDeepLinkPattern")

	table.insert(t1, {
		FastString42,
		function() -- line: 1505
			-- upvalues: UrlBuilder (copy), subSettingsMapping (copy)
			local v329 = UrlBuilder.static.settings.communicationSettings()

			return (subSettingsMapping(v329, "Feature.AccountSettings.Heading.Communications"))
		end
	})
	default:registerURL((FastString42:gsub("%%", "\\")))

	local FastString43 = game:GetFastString("BlockedUsersSettingsDeepLinkPattern")

	table.insert(t1, {
		FastString43,
		function() -- line: 1510
			-- upvalues: UrlBuilder (copy), subSettingsMapping (copy)
			local v330 = UrlBuilder.static.settings.blockedUsersSettings()

			return (subSettingsMapping(v330, "Feature.AccountSettings.Heading.BlockedUsersV2"))
		end
	})
	default:registerURL((FastString43:gsub("%%", "\\")))

	local FastString44 = game:GetFastString("BlockedExpSettingsDeepLinkPattern")

	table.insert(t1, {
		FastString44,
		function() -- line: 1515
			-- upvalues: UrlBuilder (copy), subSettingsMapping (copy)
			local v331 = UrlBuilder.static.settings.blockedExperiencesSettings()

			return (subSettingsMapping(v331, "Feature.AccountSettings.Heading.BlockedExperiences"))
		end
	})
	default:registerURL((FastString44:gsub("%%", "\\")))

	local FastString45 = game:GetFastString("ExperienceChatSettingsDeepLinkPattern")

	table.insert(t1, {
		FastString45,
		function() -- line: 1520
			-- upvalues: UrlBuilder (copy), subSettingsMapping (copy)
			local v332 = UrlBuilder.static.settings.experienceChatSettings()

			return (subSettingsMapping(v332, "Feature.AccountSettings.Heading.ExperienceChat"))
		end
	})
	default:registerURL((FastString45:gsub("%%", "\\")))

	local FastString46 = game:GetFastString("PartySettingsDeepLinkPattern")

	table.insert(t1, {
		FastString46,
		function() -- line: 1525
			-- upvalues: UrlBuilder (copy), subSettingsMapping (copy)
			local v333 = UrlBuilder.static.settings.partySettings()

			return (subSettingsMapping(v333, "Feature.AccountSettings.Label.Party"))
		end
	})
	default:registerURL((FastString46:gsub("%%", "\\")))

	local FastString47 = game:GetFastString("VoiceSettingsDeepLinkPattern")

	table.insert(t1, {
		FastString47,
		function() -- line: 1530
			-- upvalues: UrlBuilder (copy), subSettingsMapping (copy)
			local v334 = UrlBuilder.static.settings.voiceSettings()

			return (subSettingsMapping(v334, "Feature.AccountSettings.Heading.VoiceChat"))
		end
	})
	default:registerURL((FastString47:gsub("%%", "\\")))

	local FastString48 = game:GetFastString("TradingInventorySettingsDeepLinkPattern")

	table.insert(t1, {
		FastString48,
		function() -- line: 1535
			-- upvalues: UrlBuilder (copy), subSettingsMapping (copy)
			local v335 = UrlBuilder.static.settings.tradingInventorySettings()

			return (subSettingsMapping(v335, "Feature.AccountSettings.Heading.TradingAndInventory"))
		end
	})
	default:registerURL((FastString48:gsub("%%", "\\")))

	local FastString49 = game:GetFastString("FriendsContactsSettingsDeepLinkPattern")

	table.insert(t1, {
		FastString49,
		function() -- line: 1540
			-- upvalues: UrlBuilder (copy), subSettingsMapping (copy)
			local v336 = UrlBuilder.static.settings.friendsContactsSettings()

			return (subSettingsMapping(v336, "Feature.AccountSettings.Heading.FriendsAndContacts"))
		end
	})
	default:registerURL((FastString49:gsub("%%", "\\")))

	local FastString50 = game:GetFastString("PrivateServerSettingsDeepLinkPattern")

	table.insert(t1, {
		FastString50,
		function() -- line: 1545
			-- upvalues: UrlBuilder (copy), subSettingsMapping (copy)
			local v337 = UrlBuilder.static.settings.privateServerSettings()

			return (subSettingsMapping(v337, "Feature.AccountSettings.Heading.PrivateServers"))
		end
	})
	default:registerURL((FastString50:gsub("%%", "\\")))

	local FastString51 = game:GetFastString("VisibilitySettingsDeepLinkPattern")

	table.insert(t1, {
		FastString51,
		function() -- line: 1550
			-- upvalues: UrlBuilder (copy), subSettingsMapping (copy)
			local v338 = UrlBuilder.static.settings.visibilitySettings()

			return (subSettingsMapping(v338, "Feature.AccountSettings.Heading.Visibility"))
		end
	})
	default:registerURL((FastString51:gsub("%%", "\\")))
end

if v45 then
	local FastString52 = game:GetFastString("ParentalControlsDeepLinkPattern")

	table.insert(t1, {
		FastString52,
		function() -- line: 1557
			-- upvalues: UrlBuilder (copy), subSettingsMapping (copy)
			local v339 = UrlBuilder.static.settings.parentalControls()

			return (subSettingsMapping(v339, "Feature.AccountSettings.Heading.Tab.ParentalControls"))
		end
	})
	default:registerURL((FastString52:gsub("%%", "\\")))
end

if v46 then
	local FastString53 = game:GetFastString("AccountInfoDeepLinkPattern")

	table.insert(t1, {
		FastString53,
		function() -- line: 1564
			-- upvalues: UrlBuilder (copy), subSettingsMapping (copy)
			local v340 = UrlBuilder.static.settings.account()

			return (subSettingsMapping(v340, "Feature.AccountSettings.Heading.Tab.AccountInfo"))
		end
	})
	default:registerURL((FastString53:gsub("%%", "\\")))
end

local FastString54 = game:GetFastString("SpendingSettingsDeepLinkPattern")

table.insert(t1, {
	FastString54,
	function() -- line: 1570
		-- upvalues: UrlBuilder (copy), subSettingsMapping (copy)
		local v341 = UrlBuilder.static.settings.billing()

		return (subSettingsMapping(v341, "Feature.AccountSettings.Heading.Tab.Billing"))
	end
})
default:registerURL((FastString54:gsub("%%", "\\")))

if v47 then
	local FastString55 = game:GetFastString("DevicePreferencesDeepLinkPattern")

	table.insert(t1, {
		FastString55,
		function() -- line: 1576
			-- upvalues: FFlagEnableFlyoutSidePanel (copy), AppPage (copy)
			return {{
				{
					name = if not FFlagEnableFlyoutSidePanel then AppPage.More else AppPage.Home
				},
				{
					name = AppPage.Settings
				},
				{
					name = AppPage.Accessibility
				}
			}}
		end
	})
	default:registerURL((FastString55:gsub("%%", "\\")))
end

if GetFFlagEnableSecurityAlertDeeplink() then
	local FastString56 = game:GetFastString("SecurityAlertDeepLinkPattern")

	table.insert(t1, {
		FastString56,
		function(p73, _) -- line: 1588
			-- upvalues: GetFFlagGenerateLinkWithChannel (copy), UrlBuilder (copy), AppPage (copy), TransitionAnimation (copy)
			if p73.payload and (p73.payload ~= "" and p73.username and p73.username ~= "") then
				local v344 = if not GetFFlagGenerateLinkWithChannel() then UrlBuilder.static.securityAlert({
					payload = p73.payload,
					username = p73.username
				}) else UrlBuilder.static.securityAlertWithChannel({
					payload = p73.payload,
					username = p73.username,
					channel = p73.channel or ""
				})

				return {
					{{
						name = AppPage.Home
					}},
					{
						{
							name = AppPage.Home
						},
						{
							name = AppPage.SecurityAlertInfo,
							detail = v344,
							extraProps = {
								transitionAnimation = TransitionAnimation.None
							}
						}
					}
				}
			end

			return {{{
				name = AppPage.Home
			}}}
		end
	})
	default:registerURL((FastString56:gsub("%%", "\\")))
end

local FastString57 = game:GetFastString("SquadLobbyDeepLinkPattern")

table.insert(t1, {
	FastString57,
	function(p75, _) -- line: 1629
		-- upvalues: ArgCheck (copy), AppPage (copy), FFlagEnableSquadDeeplinkWithChatId (copy)
		local v347 = ArgCheck.isNotNil(p75.partyid, "partyId")

		return {{{
			name = AppPage.SquadLobby,
			detail = v347,
			extraProps = if not FFlagEnableSquadDeeplinkWithChatId then nil else {
				conversationId = p75.chatid
			}
		}}}
	end
})
default:registerURL((FastString57:gsub("%%", "\\")))

local FastString58 = game:GetFastString("FAEUpsellOverlayDeepLinkPattern")

table.insert(t1, {
	FastString58,
	function(p77) -- line: 1645
		-- upvalues: ArgCheck (copy), t2 (copy), AppPage (copy)
		local v349 = t2[ArgCheck.isNotNil(p77.source, "source")] or ""
		local v350 = p77.is_phase2 == "true"

		return {{{
			name = AppPage.FAEUpsellOverlay,
			extraProps = {
				source = v349,
				isPhase2 = v350
			}
		}}}
	end
})
default:registerURL((FastString58:gsub("%%", "\\")))

local FastString59 = game:GetFastString("FAEDeepLinkPattern")

table.insert(t1, {
	FastString59,
	function(p78) -- line: 1663
		-- upvalues: ArgCheck (copy), t2 (copy), AppPage (copy)
		local v352 = t2[ArgCheck.isNotNil(p78.source, "source")] or ""

		return {{{
			name = AppPage.FAE,
			extraProps = {
				source = v352
			}
		}}}
	end
})
default:registerURL((FastString59:gsub("%%", "\\")))

if FFlagEnableAmpWizardDeepLink then
	local FastString60 = game:GetFastString("AmpWizardDeepLinkPattern")

	table.insert(t1, {
		FastString60,
		function(p79) -- line: 1675
			-- upvalues: ArgCheck (copy), AppPage (copy), FFlagEnableAmpWizardDeepLinkValidateUserId (copy)
			local v354 = ArgCheck.isNotNil(p79.feature_name, "feature_name")

			return {{{
				name = AppPage.AmpWizardContainer,
				extraProps = {
					featureName = v354,
					nameSpace = p79.namespace,
					entryPointEventCtx = p79.entry_point,
					returnPage = p79.returnpage,
					targetUserId = if not FFlagEnableAmpWizardDeepLinkValidateUserId then nil else p79.user_id
				}
			}}}
		end
	})
	default:registerURL((FastString60:gsub("%%", "\\")))
end

if FFlagEnableAccountUnlockDeepLink then
	local FastString61 = game:GetFastString("AccountUnlockDeepLinkPattern")

	table.insert(t1, {
		FastString61,
		function(p80) -- line: 1709
			-- upvalues: FFlagAccountUnlockAllowMissingUserId (copy), ArgCheck (copy), AppPage (copy)
			local v356 = if not FFlagAccountUnlockAllowMissingUserId then ArgCheck.isNotNil(p80.user_id, "user_id") else p80.user_id

			return {{
				{
					name = AppPage.Home
				},
				{
					name = AppPage.AccountUnlock,
					extraProps = {
						targetUserId = v356
					}
				}
			}}
		end
	})
	default:registerURL((FastString61:gsub("%%", "\\")))
end

local FastString62 = game:GetFastString("EnterAppFromLockScreenWidget")

table.insert(t1, {
	FastString62,
	function(_, _) -- line: 1731
		-- upvalues: logLockScreenWidgetClicked (copy)
		logLockScreenWidgetClicked("Default")

		return nil
	end
})
default:registerURL((FastString62:gsub("%%", "\\")))

return t1
