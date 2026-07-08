game:DefineFastFlag("EnableShopGiftCardsURL", false)

return function(p1) -- line: 3
	local function isQQ() -- line: 4
		-- upvalues: p1 (copy)
		return string.find(p1.fromString("corp:")(), "qq.com")
	end

	return {
		catalog = p1.fromString("www:catalog"),
		buildersClub = p1.fromString("www:mobile-app-upgrades/native-ios/bc"),
		trades = p1.fromString("www:trades"),
		profile = p1.fromString("www:users/profile"),
		friends = p1.fromString("www:users/friends"),
		groups = p1.fromString("www:my/communities"),
		inventory = p1.fromString("www:users/inventory"),
		messages = p1.fromString("www:my/messages"),
		feed = p1.fromString("www:feeds/inapp"),
		develop = p1.fromString("www:develop"),
		creatorHub = p1.fromString("create:"),
		blog = p1.fromString("blog:"),
		giftCards = function(p2) -- line: 21
			-- upvalues: p1 (copy)
			local v4 = p2 or ""
			local s1 = "www:giftcards?ref={source}"

			if game:GetFastFlag("EnableShopGiftCardsURL") then
				s1 = "www:shopgiftcards?ref={source}"
			end

			return p1.fromString(s1)({
				source = v4
			})
		end,
		giftCardsWithRedeem = function(p3, p4) -- line: 29
			-- upvalues: p1 (copy)
			if p4 and p4 ~= "" then
				local v8 = "www:giftcards-" .. p4 .. "?ref={source}"

				return p1.fromString(v8)({
					source = p3
				})
			end

			return p1.fromString("www:shopgiftcards?ref={source}")({
				source = p3
			})
		end,
		redeem = p1.fromString("www:redeem"),
		amazonStore = p1.fromString("https://www.amazon.com/roblox"),
		help = p1.fromString(not string.find(p1.fromString("corp:")(), "qq.com") and "www:help" or "corp:faq"),
		safetyDashboard = {
			main = p1.fromString("www:safety-dashboard?t_source={source|app}"),
			violation = p1.fromString("www:safety-dashboard?vid={id}&t_source={source|app}"),
			violations = p1.fromString("www:safety-dashboard?view=violations&t_source={source|app}")
		},
		appealsPortal = {
			main = p1.fromString("www:report-appeals?t_source={source|app}"),
			violation = p1.fromString("www:report-appeals?vid={id}&t_source={source|app}")
		},
		supportCenter = {
			main = p1.fromString("www:support-center"),
			ticket = p1.fromString("www:support-center#!/tickets/{universeId}/{ticketId}")
		},
		email = {
			getSetEmail = p1.fromString("accountSettings:v1/email"),
			sendVerificationEmail = p1.fromString("accountSettings:v1/email/verify")
		},
		about = {
			us = function(p5) -- line: 62
				-- upvalues: p1 (copy)
				local v10 = p5 or ""

				return p1.fromString("www:info/about-us?locale={localeCode}")({
					localeCode = v10
				})
			end,
			careers = function(p6) -- line: 66
				-- upvalues: p1 (copy)
				if string.find(p1.fromString("corp:")(), "qq.com") then
					return p1.fromString("corp:careers.html")
				end

				local v12 = p6 or ""

				return p1.fromString("www:info/jobs?locale={localeCode}")({
					localeCode = v12
				})
			end,
			parents = function(p7) -- line: 74
				-- upvalues: p1 (copy)
				local v14 = p7 or ""

				return p1.fromString("www:info/parents?locale={localeCode}")({
					localeCode = v14
				})
			end,
			terms = function(p8) -- line: 78
				-- upvalues: p1 (copy)
				if string.find(p1.fromString("corp:")(), "qq.com") and p8.useGameQQUrls then
					return p1.fromString("https://game.qq.com/contract.shtml")()
				end

				return p1.fromString("www:info/terms")()
			end,
			privacy = function(p9) -- line: 85
				-- upvalues: p1 (copy)
				if string.find(p1.fromString("corp:")(), "qq.com") and p9.useGameQQUrls then
					return p1.fromString("https://game.qq.com/privacy_guide.shtml")()
				end

				return p1.fromString("www:info/privacy")()
			end,
			guidelines = p1.fromString("www:info/community-guidelines"),
			support = p1.fromString("www:support")
		},
		settings = {
			account = p1.fromString("www:my/account#!/info"),
			security = p1.fromString("www:my/account#!/security"),
			privacy = p1.fromString("www:my/account#!/privacy"),
			parentalControls = p1.fromString("www:my/account#!/parental-controls"),
			billing = p1.fromString("www:my/account#!/billing"),
			subscriptions = p1.fromString("www:my/account#!/subscriptions"),
			robux = p1.fromString("www:my/account#!/robux"),
			notifications = p1.fromString("www:my/account#!/notifications"),
			appPermissions = p1.fromString("www:my/account#!/app-permissions"),
			screentimeSettings = p1.fromString("www:my/account#!/privacy/Screentime"),
			blockedExperiencesSettings = p1.fromString("www:my/account#!/privacy/ContentRestrictions/BlockedExperiences"),
			blockedUsersSettings = p1.fromString("www:my/account#!/privacy/BlockedUsers"),
			experienceChatSettings = p1.fromString("www:my/account#!/privacy/Communication/ExperienceChat"),
			partySettings = p1.fromString("www:my/account#!/privacy/Communication/Party"),
			partySettingsV2 = p1.fromString("www:my/account#!/privacy/Communication/PartyAndPartyChat"),
			communicationSettings = p1.fromString("www:my/account#!/privacy/Communication"),
			voiceSettings = p1.fromString("www:my/account#!/privacy/Communication/Voice"),
			tradingInventorySettings = p1.fromString("www:my/account#!/privacy/TradingAndInventory"),
			friendsContactsSettings = p1.fromString("www:my/account#!/privacy/FriendsAndContacts"),
			privateServerSettings = p1.fromString("www:my/account#!/privacy/VisibilityAndPrivateServers/PrivateServerPrivacy"),
			visibilitySettings = p1.fromString("www:my/account#!/privacy/VisibilityAndPrivateServers/Visibility")
		},
		tencent = {
			childrenPrivacyGuide = p1.fromString("https://game.qq.com/privacy_guide_children.shtml"),
			luobuRiderTerms = p1.fromString("https://roblox.qq.com/web201904/newsdetail.html?newsid=12429812"),
			reputationInfo = p1.fromString("https://gamecredit.qq.com/static/games/index.htm"),
			luobuThirdPartyDataUse = p1.fromString("https://game.qq.com/zlkdatasys/privacy_SDK.html")
		},
		idVerification = {
			verify = p1.fromString("www:id-verification/verify"),
			getAge = p1.fromString("apis:age-verification-service/v1/age-verification/get-verified-age")
		},
		notifications = {
			clearUnread = p1.fromString("notifications:stream-notifications/clear-unread"),
			unreadCount = p1.fromString("notifications:stream-notifications/unread-count")
		},
		securityAlert = p1.fromString("www:security-feedback?payload={payload}&username={username}"),
		securityAlertWithChannel = p1.fromString("www:security-feedback?payload={payload}&username={username}&channel={channel}")
	}
end
