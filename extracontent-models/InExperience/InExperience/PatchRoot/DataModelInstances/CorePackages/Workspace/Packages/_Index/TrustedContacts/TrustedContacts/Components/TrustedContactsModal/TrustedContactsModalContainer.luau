local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local TrustedContactsParent = TrustedContacts.Parent
local React = require(TrustedContactsParent.React)
local RoactUtils = require(TrustedContactsParent.RoactUtils)
local useLocalization = require(TrustedContactsParent.Localization).Hooks.useLocalization
local Sources = require(TrustedContactsParent.SocialLuaAnalytics).Analytics.Enums.Sources
local getTCStatus = require(TrustedContacts.Requests.getTCStatus)
local TrustedConnectionStatus = require(TrustedContacts.Enums).TrustedConnectionStatus
local useModalTexts = require(script.Parent.useModalTexts)
local useModalButtonActions = require(script.Parent.useModalButtonActions)

require(TrustedContacts.TrustedFriendActions.TFActionsEnum)

local Analytics = require(script.Parent.Parent.Parent.Analytics)
local useTCAnalytics = Analytics.useTCAnalytics
local EventNames = Analytics.EventNames
local TrustedContactsModal = require(script.Parent.TrustedContactsModal)
local normalizeTFActionsEnumToModalVariant = require(TrustedContacts.TrustedFriendActions.normalizeTFActionsEnumToModalVariant)
local FFlagTCLearnMoreLink = require(TrustedContacts.Flags.FFlagTCLearnMoreLink)
local FFlagTFWithActionsCheck = require(TrustedContactsParent.SharedFlags).FFlagTFWithActionsCheck
local FFlagTrustedFriendsUseEnumCTA = require(TrustedContactsParent.SharedFlags).FFlagTrustedFriendsUseEnumCTA
local FFlagTFUpdateAnalytics = require(TrustedContacts.Flags.FFlagTFUpdateAnalytics)
local FFlagTFNonFriendsPermitted = require(TrustedContacts.Flags.FFlagTFNonFriendsPermitted)

require(TrustedContacts.Common.Types)

local v21 = game:DefineFastString("TrustedConnectionsLearnMoreLink", "https://help.roblox.com/hc/articles/37725513985812")
local t1 = {
	TrustedConnectionStatus.Friends,
	TrustedConnectionStatus.RequestReceived,
	TrustedConnectionStatus.TrustedFriends
}

local function normalizeModalOverride(s1: string) -- line: 51
	-- upvalues: Sources (copy), TrustedConnectionStatus (copy), FFlagTFNonFriendsPermitted (copy)
	if s1 == Sources.ShareLinkSender then
		return TrustedConnectionStatus.Friends
	end

	if s1 == Sources.ShareLinkReceiver then
		return TrustedConnectionStatus.RequestReceived
	end

	if s1 == TrustedConnectionStatus.RequestIgnored then
		return TrustedConnectionStatus.RequestReceived
	end

	if s1 == TrustedConnectionStatus.NotFriends and FFlagTFNonFriendsPermitted then
		return TrustedConnectionStatus.Friends
	end

	return s1
end

return function(p1) -- line: 64
	-- upvalues: FFlagTFWithActionsCheck (copy), React (copy), normalizeTFActionsEnumToModalVariant (copy), Sources (copy), TrustedConnectionStatus (copy), FFlagTFNonFriendsPermitted (copy), getTCStatus (copy), useTCAnalytics (copy), FFlagTFUpdateAnalytics (copy), EventNames (copy), useLocalization (copy), FFlagTCLearnMoreLink (copy), t1 (copy), RoactUtils (copy), useModalTexts (copy), useModalButtonActions (copy), FFlagTrustedFriendsUseEnumCTA (copy), v21 (copy), TrustedContactsModal (copy)
	local u26 = nil
	local tfActionsEnum = nil
	local u28

	if FFlagTFWithActionsCheck then
		tfActionsEnum = p1.tfActionsEnum
		u28 = React.useMemo(function() -- line: 69
			-- upvalues: tfActionsEnum (ref), normalizeTFActionsEnumToModalVariant (copy)
			if tfActionsEnum then
				return (normalizeTFActionsEnumToModalVariant(tfActionsEnum))
			end

			return nil
		end, { tfActionsEnum })
	else
		local v29, v30 = React.useState(nil)

		u28 = v29
		u26 = v30
		React.useEffect(function() -- line: 78
			-- upvalues: p1 (copy), u26 (ref), Sources (copy), TrustedConnectionStatus (copy), FFlagTFNonFriendsPermitted (copy), getTCStatus (copy)
			if p1.modalVariantOverride then
				local v39 = u26
				local modalVariantOverride = p1.modalVariantOverride

				v39(if modalVariantOverride ~= Sources.ShareLinkSender then if modalVariantOverride ~= Sources.ShareLinkReceiver then if modalVariantOverride ~= TrustedConnectionStatus.RequestIgnored then if modalVariantOverride ~= TrustedConnectionStatus.NotFriends or not FFlagTFNonFriendsPermitted then modalVariantOverride else TrustedConnectionStatus.Friends else TrustedConnectionStatus.RequestReceived else TrustedConnectionStatus.RequestReceived else TrustedConnectionStatus.Friends)

				return
			end

			getTCStatus(p1.userId):andThen(function(p2) -- line: 85
				-- upvalues: u26 (ref), Sources (copy), TrustedConnectionStatus (copy), FFlagTFNonFriendsPermitted (copy)
				u26(if p2 ~= Sources.ShareLinkSender then if p2 ~= Sources.ShareLinkReceiver then if p2 ~= TrustedConnectionStatus.RequestIgnored then if p2 ~= TrustedConnectionStatus.NotFriends or not FFlagTFNonFriendsPermitted then p2 else TrustedConnectionStatus.Friends else TrustedConnectionStatus.RequestReceived else TrustedConnectionStatus.RequestReceived else TrustedConnectionStatus.Friends)
			end):catch(function() -- line: 88
				-- upvalues: u26 (ref), TrustedConnectionStatus (copy)
				u26(TrustedConnectionStatus.Friends)
			end)
		end, {
			p1.userId,
			p1.modalVariantOverride
		})
	end

	local fireAnalyticsEvent = useTCAnalytics({
		friendId = p1.userId,
		modalVariant = u28,
		source = p1.source,
		tfActionsEnum = if not FFlagTFUpdateAnalytics then nil else tfActionsEnum
	}).fireAnalyticsEvent
	local v32 = React.useCallback(function() -- line: 106
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), p1 (copy)
		fireAnalyticsEvent(EventNames.TCUpsellCloseClicked)
		p1.externalNavigation.closeModal()
	end, {
		fireAnalyticsEvent,
		p1.externalNavigation
	})
	local v33 = useLocalization({
		somethingIsWrongToast = "Feature.Toast.NetworkingError.SomethingIsWrong",
		linkCopiedToast = "Feature.Catalog.Toast.LinkCopied",
		learnMoreText = if not FFlagTCLearnMoreLink then nil else "Feature.Friends.LinkText.LearnMore"
	})

	React.useEffect(function() -- line: 117
		-- upvalues: u28 (ref), fireAnalyticsEvent (copy), EventNames (copy)
		if u28 then
			fireAnalyticsEvent(EventNames.TCUpsellModalSeen)
		end
	end, {
		u28,
		fireAnalyticsEvent
	})

	local v34 = React.useCallback(function() -- line: 123
		-- upvalues: p1 (copy), v33 (copy)
		p1.externalNavigation.showToast(v33.somethingIsWrongToast)
	end, {
		v33.somethingIsWrongToast,
		p1.externalNavigation
	})

	if FFlagTFWithActionsCheck then
		local v35 = u28 and table.find(t1, u28)

		RoactUtils.Hooks.useEffectOnce(function() -- line: 130
			-- upvalues: FFlagTFUpdateAnalytics (copy), fireAnalyticsEvent (copy), EventNames (copy), v32 (copy), v34 (copy)
			if FFlagTFUpdateAnalytics then
				fireAnalyticsEvent(EventNames.TCUpsellInvalidTrustedFriendState)
			end

			v32()
			v34()
		end, not v35)
	else
		React.useEffect(function() -- line: 138
			-- upvalues: u28 (ref), t1 (copy), FFlagTFUpdateAnalytics (copy), fireAnalyticsEvent (copy), EventNames (copy), v32 (copy), v34 (copy)
			if u28 and not table.find(t1, u28) then
				if FFlagTFUpdateAnalytics then
					fireAnalyticsEvent(EventNames.TCUpsellInvalidTrustedFriendState)
				end

				v32()
				v34()
			end
		end, {
			v32,
			u28
		})
	end

	local v36 = useModalTexts(u28)
	local v37 = useModalButtonActions(p1.userId, p1.source, if not FFlagTFWithActionsCheck then u28 else tfActionsEnum, {
		closeModal = v32,
		onRequestSent = p1.onRequestSent,
		onRequestAccepted = p1.onRequestAccepted,
		onAcknowledged = p1.onAcknowledged,
		sentFromQrCode = p1.sentFromQrCode,
		tokens = p1.tokens,
		showGenericErrorModal = v34,
		isShareLinkSender = p1.modalVariantOverride == Sources.ShareLinkSender,
		showToast = p1.externalNavigation.showToast,
		shareUrl = p1.externalNavigation.shareUrl,
		fireAnalyticsEvent = if not FFlagTrustedFriendsUseEnumCTA then nil else fireAnalyticsEvent
	})
	local v38 = if not FFlagTCLearnMoreLink then nil else React.useCallback(function() -- line: 171
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), p1 (copy), v21 (copy)
		fireAnalyticsEvent(EventNames.TCUpsellLearnMoreClicked)
		p1.externalNavigation.openWebView(v21, "")
	end, {
		fireAnalyticsEvent,
		p1.externalNavigation
	})

	return u28 and (table.find(t1, u28) and React.createElement(TrustedContactsModal, {
		isVerticallyConstrained = p1.isVerticallyConstrained,
		userId = p1.userId,
		source = p1.source,
		headerText = v36.header,
		descriptionText = v36.description,
		modalButtonActions = v37,
		onCloseModal = v32,
		learnMoreText = if not FFlagTCLearnMoreLink then nil else v33.learnMoreText,
		onLearnMoreClick = if not FFlagTCLearnMoreLink then nil else v38
	}))
end
