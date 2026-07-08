local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local TrustedContactsParent = TrustedContacts.Parent
local React = require(TrustedContactsParent.React)
local Foundation = require(TrustedContactsParent.Foundation)
local useNavigation = require(TrustedContactsParent.Navigation).useNavigation
local AppPage = require(TrustedContactsParent.RobloxAppEnums).AppPage
local DataHydration = require(TrustedContactsParent.DataHydration)
local AmpApiProvider = require(TrustedContactsParent.AmpUpsell).AmpApiProvider
local AmpEnums = require(TrustedContactsParent.AmpUpsell).AmpEnums
local TrustedConnectionStatus = require(TrustedContacts.Enums).TrustedConnectionStatus
local Contexts = require(TrustedContactsParent.SocialLuaAnalytics).Analytics.Enums.Contexts
local useAppPolicy = require(TrustedContactsParent.UniversalAppPolicy).useAppPolicy
local UserProfiles = require(TrustedContactsParent.UserProfiles)
local useLocalization = require(TrustedContactsParent.Localization).Hooks.useLocalization
local Analytics = require(TrustedContacts.Analytics)
local useTCAnalytics = Analytics.useTCAnalytics
local EventNames = Analytics.EventNames
local FFlagTCUpdateProfileCTAButton = require(TrustedContactsParent.SharedFlags).FFlagTCUpdateProfileCTAButton
local v19 = game:DefineFastFlag("InverseTFRequestEnabled", false)
local FStringConnectionGraphCoreAmpNameSpace = require(TrustedContactsParent.SharedFlags).FStringConnectionGraphCoreAmpNameSpace

require(TrustedContacts.Common.Types)

local v21 = DataHydration.TrustedConnections.TrustedConnectionsStore.get()

local function useModalButtonActions(s1: string, s2: string?, s3: string, t1: {[any]: any}) -- line: 58
	-- upvalues: useNavigation (copy), useAppPolicy (copy), React (copy), AmpApiProvider (copy), FStringConnectionGraphCoreAmpNameSpace (copy), AmpEnums (copy), UserProfiles (copy), useLocalization (copy), useTCAnalytics (copy), EventNames (copy), FFlagTCUpdateProfileCTAButton (copy), AppPage (copy), v19 (copy), v21 (copy), Contexts (copy), TrustedConnectionStatus (copy), Foundation (copy)
	local v27 = useNavigation()
	local v28 = useAppPolicy(function(p1) -- line: 65
		return p1.getShareSheetEnabled()
	end)
	local v29, v30 = React.useState(false)
	local v31, v32 = React.useState(true)

	React.useEffect(function() -- line: 72
		-- upvalues: s1 (copy), AmpApiProvider (copy), FStringConnectionGraphCoreAmpNameSpace (copy), AmpEnums (copy), v30 (copy), v32 (copy)
		local t2 = {
			name = "targetUser",
			type = "UserId",
			value = s1
		}

		if AmpApiProvider.upsellFeatureAccess("ShowTrustedFriendVPCModalVariant", {}, FStringConnectionGraphCoreAmpNameSpace, { t2 }).access == AmpEnums.AccessResponseEnum.Granted then
			v30(true)
		end

		v32(false)
	end, { s1 })

	local s4 = ""
	local v34 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { s1 },
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})

	if v34 and v34.data then
		s4 = UserProfiles.Selectors.getCombinedNameFromId(v34.data, s1) or ""
	end

	local v35 = useLocalization({
		cancel = "CommonUI.Controls.Action.Cancel",
		add = "Feature.Friends.Action.Add",
		addViaLink = "Feature.Friends.Button.AddViaLink",
		ok = "CommonUI.Controls.Action.OK",
		accept = "CommonUI.Controls.Action.Accept",
		somethingIsWrongToast = "Feature.Toast.NetworkingError.SomethingIsWrong",
		trustedConnectionRequestSentToast = "Feature.Friends.TrustedFriend.Toast.TrustedFriendRequestSent",
		linkCopiedToast = "Feature.Catalog.Toast.LinkCopied",
		isATrustedConnectionNowToast = {
			"Feature.Friends.TrustedFriend.Toast.IsATrustedFriendNow",
			name = s4
		}
	})
	local fireAnalyticsEvent = useTCAnalytics({
		friendId = s1,
		modalVariant = s3,
		source = s2
	}).fireAnalyticsEvent
	local v37 = React.useCallback(function() -- line: 115
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
	local v38 = React.useCallback(function() -- line: 124
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), FFlagTCUpdateProfileCTAButton (copy), t1 (copy), v27 (copy), AppPage (copy), s1 (copy)
		fireAnalyticsEvent(EventNames.TrustedFriendsVPCPrologueOpened)

		local onRequestSent = nil

		if FFlagTCUpdateProfileCTAButton then
			if t1.onRequestSent then
				onRequestSent = t1.onRequestSent
			elseif t1.onRequestAccepted then
				onRequestSent = t1.onRequestAccepted
			end
		end

		v27.replace(AppPage.TrustedFriendsVPCPrologue, {
			userId = s1,
			completionCallback = onRequestSent
		})
	end, {
		fireAnalyticsEvent,
		v27,
		s1,
		if not FFlagTCUpdateProfileCTAButton then nil else t1.onRequestSent,
		if not FFlagTCUpdateProfileCTAButton then nil else t1.onRequestAccepted
	})
	local v39 = if not v19 then nil else React.useCallback(function() -- line: 152
		-- upvalues: v21 (copy), s1 (copy), t1 (copy), v38 (copy)
		v21.addTrustedFriendFromLink(s1, t1.tokens or {}):andThen(function() -- line: 154
			-- upvalues: v38 (copy)
			v38()
		end):catch(function() -- line: 157
			-- upvalues: t1 (copy)
			t1.showGenericErrorModal()
		end)
	end, {
		s1,
		t1.tokens,
		v38,
		t1.showGenericErrorModal
	})
	local v40 = React.useCallback(function() -- line: 171
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), t1 (copy), v35 (copy)
		fireAnalyticsEvent(EventNames.TCUpsellAcceptTrustedConnectionClicked)
		t1.showToast(v35.isATrustedConnectionNowToast)
	end, {
		v35.isATrustedConnectionNowToast,
		fireAnalyticsEvent,
		t1.showToast
	})
	local v41 = React.useCallback(function() -- line: 182
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), t1 (copy)
		fireAnalyticsEvent(EventNames.TCUpsellCancelClicked)
		t1.closeModal()
	end, {
		t1.closeModal,
		fireAnalyticsEvent
	})
	local v42 = React.useCallback(function() -- line: 188
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v21 (copy), s1 (copy), t1 (copy), Contexts (copy), v28 (copy), v35 (copy)
		fireAnalyticsEvent(EventNames.TCUpsellAddViaLinkClicked)
		v21.createTrustedFriendLink(s1):andThen(function(p2) -- line: 191
			-- upvalues: t1 (copy), Contexts (copy)
			t1.shareUrl({
				url = p2.responseBody.link,
				context = Contexts.TCUpsellModal
			})
		end):andThen(function() -- line: 197
			-- upvalues: t1 (copy)
			return t1.onRequestSent and t1.onRequestSent()
		end):andThen(function() -- line: 200
			-- upvalues: v28 (copy), t1 (copy), v35 (copy)
			if not v28 then
				t1.showToast(v35.linkCopiedToast)
			end

			t1.closeModal()
		end):catch(function() -- line: 206
			-- upvalues: t1 (copy)
			t1.showGenericErrorModal()
			t1.closeModal()
		end)
	end, {
		t1.closeModal,
		t1.showGenericErrorModal,
		fireAnalyticsEvent,
		s1,
		v35,
		v28,
		t1.shareUrl,
		t1.showToast
	})
	local v43 = React.useCallback(function() -- line: 223
		-- upvalues: v21 (copy), s1 (copy), v40 (copy), t1 (copy)
		v21.acceptTrustedConnectionRequest(s1):andThen(function() -- line: 225
			-- upvalues: v40 (copy)
			v40()
		end):andThen(function() -- line: 228
			-- upvalues: t1 (copy)
			return t1.onRequestAccepted and t1.onRequestAccepted()
		end):andThen(function() -- line: 231
			-- upvalues: t1 (copy)
			t1.closeModal()
		end):catch(function() -- line: 234
			-- upvalues: t1 (copy)
			t1.showGenericErrorModal()
		end)
	end, {
		t1,
		s1,
		v40
	})
	local v44 = React.useCallback(function() -- line: 239
		-- upvalues: v21 (copy), s1 (copy), t1 (copy), v40 (copy), FFlagTCUpdateProfileCTAButton (copy)
		v21.addTrustedFriendFromLink(s1, t1.tokens or {}):andThen(function() -- line: 241
			-- upvalues: v40 (copy)
			v40()
		end):andThen((if not FFlagTCUpdateProfileCTAButton then nil else function() -- line: 245
			-- upvalues: t1 (copy)
			return t1.onRequestAccepted and t1.onRequestAccepted()
		end)):andThen(function() -- line: 249
			-- upvalues: t1 (copy)
			t1.closeModal()
		end):catch(function() -- line: 252
			-- upvalues: t1 (copy)
			t1.showGenericErrorModal()
		end)
	end, {
		t1,
		s1,
		v40
	})
	local v45 = React.useCallback(function() -- line: 258
		-- upvalues: v21 (copy), s1 (copy), t1 (copy), fireAnalyticsEvent (copy), EventNames (copy), v35 (copy)
		v21.sendTrustedConnectionRequest(s1, (if not t1.sentFromQrCode then nil else "qr")):andThen(function() -- line: 263
			-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), t1 (copy), v35 (copy)
			fireAnalyticsEvent(EventNames.TCUpsellAddTrustedConnectionClicked)
			t1.showToast(v35.trustedConnectionRequestSentToast)
		end):andThen(function() -- line: 267
			-- upvalues: t1 (copy)
			return t1.onRequestSent and t1.onRequestSent()
		end):andThen(function() -- line: 270
			-- upvalues: t1 (copy)
			t1.closeModal()
		end):catch(function() -- line: 273
			-- upvalues: t1 (copy)
			t1.showGenericErrorModal()
		end)
	end, {
		t1,
		s1,
		v35,
		fireAnalyticsEvent
	})

	return React.useMemo(function() -- line: 286
		-- upvalues: s3 (copy), TrustedConnectionStatus (copy), v35 (copy), v37 (copy), v41 (copy), v31 (copy), v19 (copy), t1 (copy), v29 (copy), Foundation (copy), v39 (copy), v38 (copy), v44 (copy), v43 (copy), v42 (copy), v45 (copy)
		if not s3 then
			return nil
		end

		if s3 == TrustedConnectionStatus.TrustedFriends then
			return {{
				text = v35.ok,
				onActivated = v37
			}}
		end

		local t3 = {
			icon = nil,
			isLoading = false,
			text = v35.cancel,
			onActivated = v41
		}

		if v31 then
			return {
				{
					isLoading = true,
					onActivated = function() -- line: 306
					end
				},
				t3
			}
		end

		if s3 == TrustedConnectionStatus.RequestReceived then
			local v50 = nil

			if v19 and t1.tokens and #t1.tokens > 0 then
				v50 = true
			end

			if v29 then
				return {
					{
						text = v35.accept,
						icon = Foundation.Enums.IconName.LockClosed,
						onActivated = if not v19 or not v50 then v38 else v39
					},
					t3
				}
			end

			if t1.tokens and #t1.tokens > 0 then
				return {
					{
						text = v35.accept,
						onActivated = v44
					},
					t3
				}
			end

			return {
				{
					text = v35.accept,
					onActivated = v43
				},
				t3
			}
		end

		if s3 == TrustedConnectionStatus.Friends then
			if v29 then
				return {
					{
						text = v35.add,
						icon = Foundation.Enums.IconName.LockClosed,
						onActivated = v38
					},
					t3
				}
			end

			if t1.isShareLinkSender then
				return {
					{
						text = v35.addViaLink,
						onActivated = v42
					},
					t3
				}
			end

			return {
				{
					text = v35.add,
					onActivated = v45
				},
				t3
			}
		end

		return nil
	end, {
		s3,
		v31,
		v29,
		v35,
		t1.tokens,
		t1.isShareLinkSender,
		v37,
		v38,
		v41,
		v43,
		v44,
		v45,
		v42,
		v39
	})
end

return useModalButtonActions
