game:DefineFastFlag("EnableShopGiftCardsURL", false)

return function(p)
	local function isQQ() -- 4 equivalent calls inferred from this helper
		return string.find(p.fromString("corp:")(), "qq.com")
	end

	return {
		catalog = p.fromString("www:catalog"),
		buildersClub = p.fromString("www:mobile-app-upgrades/native-ios/bc"),
		trades = p.fromString("www:trades"),
		profile = p.fromString("www:users/profile"),
		friends = p.fromString("www:users/friends"),
		groups = p.fromString("www:my/communities"),
		inventory = p.fromString("www:users/inventory"),
		messages = p.fromString("www:my/messages"),
		feed = p.fromString("www:feeds/inapp"),
		develop = p.fromString("www:develop"),
		creatorHub = p.fromString("create:"),
		blog = p.fromString("blog:"),
		giftCards = function(value)
			local v = game:GetFastFlag("EnableShopGiftCardsURL") and "www:shopgiftcards?ref={source}"
				or "www:giftcards?ref={source}"

			return p.fromString(v)({
				source = value or ""
			})
		end,
		giftCardsWithRedeem = function(source, p2)
			if not p2 or p2 == "" then
				return p.fromString("www:shopgiftcards?ref={source}")({ source = source })
			end

			local v = "www:giftcards-" .. p2 .. "?ref={source}"
			return p.fromString(v)({ source = source })
		end,
		redeem = p.fromString("www:redeem"),
		amazonStore = p.fromString("https://www.amazon.com/roblox"),
		help = p.fromString(isQQ() and "corp:faq" or "www:help"), -- inferred equivalent call
		safetyDashboard = {
			main = p.fromString("www:safety-dashboard?t_source={source|app}"),
			reportInbox = function(p2)
				return p.fromString("www:safety-dashboard?t_source={source|app}")(p2) .. "#/report-inbox"
			end,
			violation = p.fromString("www:safety-dashboard?vid={id}&t_source={source|app}"),
			violations = function(p2)
				return p.fromString("www:safety-dashboard?t_source={source|app}")(p2) .. "#/violations"
			end
		},
		appealsPortal = {
			main = p.fromString("www:report-appeals?t_source={source|app}"),
			violation = p.fromString("www:report-appeals?vid={id}&t_source={source|app}")
		},
		supportCenter = {
			main = p.fromString("www:support-center"),
			ticket = p.fromString("www:support-center#!/tickets/{universeId}/{ticketId}")
		},
		email = {
			getSetEmail = p.fromString("accountSettings:v1/email"),
			sendVerificationEmail = p.fromString("accountSettings:v1/email/verify")
		},
		about = {
			us = function(value)
				return p.fromString("www:info/about-us?locale={localeCode}")({
					localeCode = value or ""
				})
			end,
			careers = function(value)
				if isQQ() then -- inferred equivalent call
					return p.fromString("corp:careers.html")
				end

				return p.fromString("www:info/jobs?locale={localeCode}")({
					localeCode = value or ""
				})
			end,
			parents = function(value)
				return p.fromString("www:info/parents?locale={localeCode}")({
					localeCode = value or ""
				})
			end,
			terms = function(p2)
				if isQQ() and p2.useGameQQUrls then -- inferred equivalent call
					return p.fromString("https://game.qq.com/contract.shtml")()
				end

				return p.fromString("www:info/terms")()
			end,
			privacy = function(p2)
				if isQQ() and p2.useGameQQUrls then -- inferred equivalent call
					return p.fromString("https://game.qq.com/privacy_guide.shtml")()
				end

				return p.fromString("www:info/privacy")()
			end,
			guidelines = p.fromString("www:info/community-guidelines"),
			support = p.fromString("www:support")
		},
		settings = {
			account = p.fromString("www:my/account#!/info"),
			security = p.fromString("www:my/account#!/security"),
			privacy = p.fromString("www:my/account#!/privacy"),
			parentalControls = p.fromString("www:my/account#!/parental-controls"),
			billing = p.fromString("www:my/account#!/billing"),
			subscriptions = p.fromString("www:my/account#!/subscriptions"),
			robux = p.fromString("www:my/account#!/robux"),
			notifications = p.fromString("www:my/account#!/notifications"),
			appPermissions = p.fromString("www:my/account#!/app-permissions"),
			screentimeSettings = p.fromString("www:my/account#!/privacy/Screentime"),
			blockedExperiencesSettings = p.fromString("www:my/account#!/privacy/ContentRestrictions/BlockedExperiences"),
			blockedUsersSettings = p.fromString("www:my/account#!/privacy/BlockedUsers"),
			experienceChatSettings = p.fromString("www:my/account#!/privacy/Communication/ExperienceChat"),
			partySettings = p.fromString("www:my/account#!/privacy/Communication/Party"),
			partySettingsV2 = p.fromString("www:my/account#!/privacy/Communication/PartyAndPartyChat"),
			communicationSettings = p.fromString("www:my/account#!/privacy/Communication"),
			voiceSettings = p.fromString("www:my/account#!/privacy/Communication/Voice"),
			tradingInventorySettings = p.fromString("www:my/account#!/privacy/TradingAndInventory"),
			friendsContactsSettings = p.fromString("www:my/account#!/privacy/FriendsAndContacts"),
			privateServerSettings = p.fromString("www:my/account#!/privacy/VisibilityAndPrivateServers/PrivateServerPrivacy"),
			visibilitySettings = p.fromString("www:my/account#!/privacy/VisibilityAndPrivateServers/Visibility")
		},
		tencent = {
			childrenPrivacyGuide = p.fromString("https://game.qq.com/privacy_guide_children.shtml"),
			luobuRiderTerms = p.fromString("https://roblox.qq.com/web201904/newsdetail.html?newsid=12429812"),
			reputationInfo = p.fromString("https://gamecredit.qq.com/static/games/index.htm"),
			luobuThirdPartyDataUse = p.fromString("https://game.qq.com/zlkdatasys/privacy_SDK.html")
		},
		idVerification = {
			verify = p.fromString("www:id-verification/verify"),
			getAge = p.fromString("apis:age-verification-service/v1/age-verification/get-verified-age")
		},
		notifications = {
			clearUnread = p.fromString("notifications:stream-notifications/clear-unread"),
			unreadCount = p.fromString("notifications:stream-notifications/unread-count")
		},
		securityAlert = p.fromString("www:security-feedback?payload={payload}&username={username}"),
		securityAlertWithChannel = p.fromString("www:security-feedback?payload={payload}&username={username}&channel={channel}")
	}
end
