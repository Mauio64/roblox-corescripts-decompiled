local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local TrustedContactsParent = TrustedContacts.Parent
local React = require(TrustedContactsParent.React)
local useNavigation = require(TrustedContactsParent.Navigation).useNavigation
local AppPage = require(TrustedContactsParent.RobloxAppEnums).AppPage
local DataHydration = require(TrustedContactsParent.DataHydration)
local Contexts = require(TrustedContactsParent.SocialLuaAnalytics).Analytics.Enums.Contexts
local useAppPolicy = require(TrustedContactsParent.UniversalAppPolicy).useAppPolicy
local UserProfiles = require(TrustedContactsParent.UserProfiles)
local useLocalization = require(TrustedContactsParent.Localization).Hooks.useLocalization
local EventNames = require(TrustedContacts.Analytics).EventNames
local FFlagTCUpdateProfileCTAButton = require(TrustedContactsParent.SharedFlags).FFlagTCUpdateProfileCTAButton
local FFlagTrustedFriendsLinkVPC = require(TrustedContacts.Flags.FFlagTrustedFriendsLinkVPC)
local FFlagTFUpdateAnalytics = require(TrustedContacts.Flags.FFlagTFUpdateAnalytics)

require(TrustedContacts.Common.Types)

local v15 = DataHydration.TrustedConnections.TrustedConnectionsStore.get()

local function useGetTFActionsCallbacks(s1: string, t1: {[any]: any}) -- line: 54
	-- upvalues: useNavigation (copy), useAppPolicy (copy), UserProfiles (copy), useLocalization (copy), React (copy), EventNames (copy), FFlagTCUpdateProfileCTAButton (copy), AppPage (copy), FFlagTFUpdateAnalytics (copy), v15 (copy), Contexts (copy), FFlagTrustedFriendsLinkVPC (copy)
	local fireAnalyticsEvent = t1.fireAnalyticsEvent
	local v20 = useNavigation()
	local v21 = useAppPolicy(function(p1) -- line: 58
		return p1.getShareSheetEnabled()
	end)
	local s2 = ""
	local v23 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { s1 },
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})

	if v23 and v23.data then
		s2 = UserProfiles.Selectors.getCombinedNameFromId(v23.data, s1) or ""
	end

	local v24 = useLocalization({
		linkCopiedToast = "Feature.Catalog.Toast.LinkCopied",
		trustedConnectionRequestSentToast = "Feature.Friends.TrustedFriend.Toast.TrustedFriendRequestSent",
		isATrustedConnectionNowToast = {
			"Feature.Friends.TrustedFriend.Toast.IsATrustedFriendNow",
			name = s2
		}
	})
	local v25 = React.useCallback(function() -- line: 81
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), t1 (copy)
		fireAnalyticsEvent(EventNames.TrustedFriendsModalOkClicked)

		if t1.onAcknowledged then
			t1.onAcknowledged()
		end

		t1.closeModal()
	end, {
		t1.closeModal,
		t1.onAcknowledged,
		fireAnalyticsEvent
	})
	local v26 = React.useCallback(function() -- line: 90
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), FFlagTCUpdateProfileCTAButton (copy), t1 (copy), v20 (copy), AppPage (copy), s1 (copy)
		fireAnalyticsEvent(EventNames.TrustedFriendsVPCPrologueOpened)

		local onRequestSent = nil

		if FFlagTCUpdateProfileCTAButton then
			if t1.onRequestSent then
				onRequestSent = t1.onRequestSent
			elseif t1.onRequestAccepted then
				onRequestSent = t1.onRequestAccepted
			end
		end

		v20.replace(AppPage.TrustedFriendsVPCPrologue, {
			userId = s1,
			completionCallback = onRequestSent
		})
	end, {
		fireAnalyticsEvent,
		v20,
		s1,
		if not FFlagTCUpdateProfileCTAButton then nil else t1.onRequestSent,
		if not FFlagTCUpdateProfileCTAButton then nil else t1.onRequestAccepted
	})
	local v27 = React.useCallback(function() -- line: 117
		-- upvalues: FFlagTFUpdateAnalytics (copy), fireAnalyticsEvent (copy), EventNames (copy), t1 (copy), v24 (copy)
		if FFlagTFUpdateAnalytics then
			fireAnalyticsEvent(EventNames.TCUpsellIsATrustedConnectionNowToastShown)
		else
			fireAnalyticsEvent(EventNames.TCUpsellAcceptTrustedConnectionClicked)
		end

		t1.showToast(v24.isATrustedConnectionNowToast)
	end, {
		v24.isATrustedConnectionNowToast,
		fireAnalyticsEvent,
		t1.showToast
	})
	local v28 = React.useCallback(function() -- line: 132
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), t1 (copy)
		fireAnalyticsEvent(EventNames.TCUpsellCancelClicked)
		t1.closeModal()
	end, {
		t1.closeModal,
		fireAnalyticsEvent
	})
	local v29 = React.useCallback(function() -- line: 138
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v15 (copy), s1 (copy), t1 (copy), Contexts (copy), v21 (copy), v24 (copy)
		fireAnalyticsEvent(EventNames.TCUpsellAddViaLinkClicked)
		v15.createTrustedFriendLink(s1):andThen(function(p2) -- line: 141
			-- upvalues: t1 (copy), Contexts (copy)
			t1.shareUrl({
				url = p2.responseBody.link,
				context = Contexts.TCUpsellModal
			})
		end):andThen(function() -- line: 147
			-- upvalues: t1 (copy)
			return t1.onRequestSent and t1.onRequestSent()
		end):andThen(function() -- line: 150
			-- upvalues: v21 (copy), t1 (copy), v24 (copy)
			if not v21 then
				t1.showToast(v24.linkCopiedToast)
			end

			t1.closeModal()
		end):catch(function() -- line: 156
			-- upvalues: t1 (copy)
			t1.showGenericErrorModal()
			t1.closeModal()
		end)
	end, {
		t1.closeModal,
		t1.showGenericErrorModal,
		t1.onRequestSent,
		fireAnalyticsEvent,
		s1,
		v24,
		v21,
		t1.shareUrl,
		t1.showToast
	})
	local v30 = React.useCallback(function() -- line: 174
		-- upvalues: FFlagTFUpdateAnalytics (copy), fireAnalyticsEvent (copy), EventNames (copy), v15 (copy), s1 (copy), v27 (copy), t1 (copy)
		if FFlagTFUpdateAnalytics then
			fireAnalyticsEvent(EventNames.TCUpsellAcceptTrustedConnectionClicked)
		end

		v15.acceptTrustedConnectionRequest(s1):andThen(function() -- line: 180
			-- upvalues: v27 (copy)
			v27()
		end):andThen(function() -- line: 183
			-- upvalues: t1 (copy)
			return t1.onRequestAccepted and t1.onRequestAccepted()
		end):andThen(function() -- line: 186
			-- upvalues: t1 (copy)
			t1.closeModal()
		end):catch(function() -- line: 189
			-- upvalues: t1 (copy)
			t1.showGenericErrorModal()
		end)
	end, {
		t1,
		s1,
		v27,
		fireAnalyticsEvent
	})
	local v31 = React.useCallback(function() -- line: 194
		-- upvalues: FFlagTFUpdateAnalytics (copy), fireAnalyticsEvent (copy), EventNames (copy), v15 (copy), s1 (copy), t1 (copy), v27 (copy), FFlagTCUpdateProfileCTAButton (copy)
		if FFlagTFUpdateAnalytics then
			fireAnalyticsEvent(EventNames.TCUpsellAcceptTrustedConnectionClicked)
		end

		v15.addTrustedFriendFromLink(s1, t1.tokens or {}):andThen(function() -- line: 200
			-- upvalues: v27 (copy)
			v27()
		end):andThen((if not FFlagTCUpdateProfileCTAButton then nil else function() -- line: 204
			-- upvalues: t1 (copy)
			return t1.onRequestAccepted and t1.onRequestAccepted()
		end)):andThen(function() -- line: 208
			-- upvalues: t1 (copy)
			t1.closeModal()
		end):catch(function() -- line: 211
			-- upvalues: t1 (copy)
			t1.showGenericErrorModal()
		end)
	end, {
		t1,
		s1,
		v27,
		fireAnalyticsEvent
	})
	local v32 = React.useCallback(function() -- line: 217
		-- upvalues: FFlagTFUpdateAnalytics (copy), fireAnalyticsEvent (copy), EventNames (copy), v15 (copy), s1 (copy), t1 (copy), v24 (copy)
		if FFlagTFUpdateAnalytics then
			fireAnalyticsEvent(EventNames.TCUpsellAddTrustedConnectionClicked)
		end

		v15.sendTrustedConnectionRequest(s1, (if not t1.sentFromQrCode then nil else "qr")):andThen(function() -- line: 226
			-- upvalues: FFlagTFUpdateAnalytics (copy), fireAnalyticsEvent (copy), EventNames (copy), t1 (copy), v24 (copy)
			if not FFlagTFUpdateAnalytics then
				fireAnalyticsEvent(EventNames.TCUpsellAddTrustedConnectionClicked)
			end

			t1.showToast(v24.trustedConnectionRequestSentToast)
		end):andThen(function() -- line: 232
			-- upvalues: t1 (copy)
			return t1.onRequestSent and t1.onRequestSent()
		end):andThen(function() -- line: 235
			-- upvalues: t1 (copy)
			t1.closeModal()
		end):catch(function() -- line: 238
			-- upvalues: t1 (copy)
			t1.showGenericErrorModal()
		end)
	end, {
		t1,
		s1,
		v24,
		fireAnalyticsEvent,
		t1.showToast
	})
	local v33 = if not FFlagTrustedFriendsLinkVPC then nil else React.useCallback(function() -- line: 253
		-- upvalues: FFlagTFUpdateAnalytics (copy), fireAnalyticsEvent (copy), EventNames (copy), v15 (copy), s1 (copy), t1 (copy), v26 (copy)
		if FFlagTFUpdateAnalytics then
			fireAnalyticsEvent(EventNames.TCUpsellAcceptTrustedConnectionClicked)
		end

		v15.addTrustedFriendFromLink(s1, t1.tokens or {}):andThen(function() -- line: 259
			-- upvalues: v26 (copy)
			v26()
		end):catch(function() -- line: 262
			-- upvalues: t1 (copy)
			t1.showGenericErrorModal()
		end)
	end, {
		s1,
		t1.tokens,
		v26,
		t1.showGenericErrorModal,
		fireAnalyticsEvent
	})

	return {
		onOkButtonPress = v25,
		onOpenVPCProloguePress = v26,
		onCancelButtonPress = v28,
		onAcceptRequestReceived = v30,
		onAddTrustedFriendFromLink = v31,
		onSendTrustedConnectionRequest = v32,
		onAddViaLinkButtonPress = v29,
		onAddTrustedFriendFromLinkWithVPC = if not FFlagTrustedFriendsLinkVPC then nil else v33
	}
end

return useGetTFActionsCallbacks
