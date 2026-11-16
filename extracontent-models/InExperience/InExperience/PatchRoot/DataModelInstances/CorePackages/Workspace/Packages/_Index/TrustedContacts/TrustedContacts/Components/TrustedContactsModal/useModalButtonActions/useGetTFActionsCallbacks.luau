local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local parent = TrustedContacts.Parent

local React = require(parent.React)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local DataHydration = require(parent.DataHydration)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local UserProfiles = require(parent.UserProfiles)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local AmpUpsell = require(parent.AmpUpsell)

local Analytics = require(TrustedContacts.Analytics)
local EventNames = Analytics.EventNames

local SharedFlags = require(parent.SharedFlags)
local FFlagTCUpdateProfileCTAButton = SharedFlags.FFlagTCUpdateProfileCTAButton
local FFlagTrustedFriendsLinkVPC = require(TrustedContacts.Flags.FFlagTrustedFriendsLinkVPC)
local FFlagTFUpdateAnalytics = require(TrustedContacts.Flags.FFlagTFUpdateAnalytics)

local FFlagEnableTrustedFriendsWizardVPCPrologue = require(TrustedContacts.Flags.FFlagEnableTrustedFriendsWizardVPCPrologue)

local v = FFlagEnableTrustedFriendsWizardVPCPrologue
	and AmpUpsell.GetFFlagEnableAmpVPCPrologue()
	and AmpUpsell.GetFFlagEnableReusableVPCPrologue()
	and AmpUpsell.GetFFlagEnableAmpWizardVPCNavigationFix()

local SharedFlags2 = require(parent.SharedFlags)
local FStringConnectionGraphCoreAmpNameSpace = SharedFlags2.FStringConnectionGraphCoreAmpNameSpace

require(TrustedContacts.Common.Types)

local v2 = DataHydration.TrustedConnections.TrustedConnectionsStore.get()

local function useGetTFActionsCallbacks(p: string, data)
	local fireAnalyticsEvent = data.fireAnalyticsEvent

	local v3 = useNavigation()
	local v4 = useAppPolicy(function(p2)
		return p2.getShareSheetEnabled()
	end)

	local v5 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { p },
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})

	local v6 = useLocalization({
		isATrustedConnectionNowToast = {
			"Feature.Friends.TrustedFriend.Toast.IsATrustedFriendNow",
			name = v5 and v5.data and UserProfiles.Selectors.getCombinedNameFromId(v5.data, p) or ""
		},
		linkCopiedToast = "Feature.Catalog.Toast.LinkCopied",
		trustedConnectionRequestSentToast = "Feature.Friends.TrustedFriend.Toast.TrustedFriendRequestSent",
		ask = v and "Feature.Friends.Label.Ask" or nil,
		askYourParent = v and "Feature.Friends.Label.AskYourParent" or nil,
		vpcRequired = v and "Feature.Friends.Label.AddFriendVPC" or nil
	})

	local onOkButtonPress = React.useCallback(function()
		fireAnalyticsEvent(EventNames.TrustedFriendsModalOkClicked)

		if data.onAcknowledged then
			data.onAcknowledged()
		end

		data.closeModal()
	end, { data.closeModal, data.onAcknowledged, fireAnalyticsEvent })

	local useCallback = React.useCallback
	local function fn()
		fireAnalyticsEvent(EventNames.TrustedFriendsVPCPrologueOpened)

		local completionCallback = nil

		if FFlagTCUpdateProfileCTAButton then
			if data.onRequestSent then
				completionCallback = data.onRequestSent
			elseif data.onRequestAccepted then
				completionCallback = data.onRequestAccepted
			end
		end

		local dismissModal = data.dismissModal
		local openAmpWizard = data.openAmpWizard

		if v then
			local v7 = {
				featureName = "TriggerTrustedFriendVPCRecourse",
				completionCallback = function()
					if completionCallback then
						completionCallback()
					end
				end,
				recourseData = { targetUserId = p },
				entryPointEventCtx = Contexts.TrustedFriendsVPCPrologue,
				extraParameters = {
					{ name = "targetUser", type = "UserId", value = p }
				},
				nameSpace = FStringConnectionGraphCoreAmpNameSpace,
				usePrologue = true,
				prologueOptions = {
					config = {
						titleText = v6.askYourParent,
						bodyText = v6.vpcRequired,
						confirmText = v6.ask
					},
					onConfirm = function()
						fireAnalyticsEvent(EventNames.TrustedFriendsVPCAskClicked)
					end,
					onCancel = function()
						fireAnalyticsEvent(EventNames.TrustedFriendsVPCCancelClicked)
					end
				}
			}

			dismissModal()
			openAmpWizard(v7)
		else
			v3.replace(AppPage.TrustedFriendsVPCPrologue, {
				userId = p,
				completionCallback = completionCallback
			})
		end
	end

	local onRequestSent

	if FFlagTCUpdateProfileCTAButton then
		onRequestSent = data.onRequestSent
	end

	local onRequestAccepted

	if FFlagTCUpdateProfileCTAButton then
		onRequestAccepted = data.onRequestAccepted
	end

	local dismissModal

	if v then
		dismissModal = data.dismissModal
	end

	local openAmpWizard

	if v then
		openAmpWizard = data.openAmpWizard
	end

	local v7

	if v then
		v7 = v6
	end

	local onOpenVPCProloguePress = useCallback(fn, {
		fireAnalyticsEvent,
		v3,
		p,
		onRequestSent,
		onRequestAccepted,
		dismissModal,
		openAmpWizard,
		v7
	})

	local v8 = React.useCallback(function()
		if FFlagTFUpdateAnalytics then
			fireAnalyticsEvent(EventNames.TCUpsellIsATrustedConnectionNowToastShown)
		else
			fireAnalyticsEvent(EventNames.TCUpsellAcceptTrustedConnectionClicked)
		end

		data.showToast(v6.isATrustedConnectionNowToast)
	end, { v6.isATrustedConnectionNowToast, fireAnalyticsEvent, data.showToast })

	local onCancelButtonPress = React.useCallback(function()
		fireAnalyticsEvent(EventNames.TCUpsellCancelClicked)
		data.closeModal()
	end, { data.closeModal, fireAnalyticsEvent })

	local onAddViaLinkButtonPress = React.useCallback(function()
		fireAnalyticsEvent(EventNames.TCUpsellAddViaLinkClicked)
		v2.createTrustedFriendLink(p):andThen(function(p2)
			data.shareUrl({ url = p2.responseBody.link, context = Contexts.TCUpsellModal })
		end):andThen(function()
			return data.onRequestSent and data.onRequestSent()
		end):andThen(function()
			if not v4 then
				data.showToast(v6.linkCopiedToast)
			end

			data.closeModal()
		end):catch(function()
			data.showGenericErrorModal()
			data.closeModal()
		end)
	end, {
		data.closeModal,
		data.showGenericErrorModal,
		data.onRequestSent,
		fireAnalyticsEvent,
		p,
		v6,
		v4,
		data.shareUrl,
		data.showToast
	})

	local onAcceptRequestReceived = React.useCallback(function()
		if FFlagTFUpdateAnalytics then
			fireAnalyticsEvent(EventNames.TCUpsellAcceptTrustedConnectionClicked)
		end

		v2.acceptTrustedConnectionRequest(p):andThen(function()
			v8()
		end):andThen(function()
			return data.onRequestAccepted and data.onRequestAccepted()
		end):andThen(function()
			data.closeModal()
		end):catch(function()
			data.showGenericErrorModal()
		end)
	end, { data, p, v8, fireAnalyticsEvent })

	local onAddTrustedFriendFromLink = React.useCallback(function()
		if FFlagTFUpdateAnalytics then
			fireAnalyticsEvent(EventNames.TCUpsellAcceptTrustedConnectionClicked)
		end

		v2.addTrustedFriendFromLink(p, data.tokens or {}):andThen(function()
			v8()
		end):andThen(FFlagTCUpdateProfileCTAButton and function()
			return data.onRequestAccepted and data.onRequestAccepted()
		end or nil):andThen(function()
			data.closeModal()
		end):catch(function()
			data.showGenericErrorModal()
		end)
	end, { data, p, v8, fireAnalyticsEvent })

	local onSendTrustedConnectionRequest = React.useCallback(function()
		if FFlagTFUpdateAnalytics then
			fireAnalyticsEvent(EventNames.TCUpsellAddTrustedConnectionClicked)
		end

		v2.sendTrustedConnectionRequest(p, data.sentFromQrCode and "qr" or nil):andThen(function()
			if not FFlagTFUpdateAnalytics then
				fireAnalyticsEvent(EventNames.TCUpsellAddTrustedConnectionClicked)
			end

			data.showToast(v6.trustedConnectionRequestSentToast)
		end):andThen(function()
			return data.onRequestSent and data.onRequestSent()
		end):andThen(function()
			data.closeModal()
		end):catch(function()
			data.showGenericErrorModal()
		end)
	end, { data, p, v6, fireAnalyticsEvent, data.showToast })
	local onAddTrustedFriendFromLinkWithVPC

	if FFlagTrustedFriendsLinkVPC then
		onAddTrustedFriendFromLinkWithVPC = React.useCallback(function()
			if FFlagTFUpdateAnalytics then
				fireAnalyticsEvent(EventNames.TCUpsellAcceptTrustedConnectionClicked)
			end

			v2.addTrustedFriendFromLink(p, data.tokens or {}):andThen(function()
				onOpenVPCProloguePress()
			end):catch(function()
				data.showGenericErrorModal()
			end)
		end, {
			p,
			data.tokens,
			onOpenVPCProloguePress,
			data.showGenericErrorModal,
			fireAnalyticsEvent
		})
	end

	local v9 = {
		onOkButtonPress = onOkButtonPress,
		onOpenVPCProloguePress = onOpenVPCProloguePress,
		onCancelButtonPress = onCancelButtonPress,
		onAcceptRequestReceived = onAcceptRequestReceived,
		onAddTrustedFriendFromLink = onAddTrustedFriendFromLink,
		onSendTrustedConnectionRequest = onSendTrustedConnectionRequest,
		onAddViaLinkButtonPress = onAddViaLinkButtonPress,
		onAddTrustedFriendFromLinkWithVPC = nil
	}

	if not FFlagTrustedFriendsLinkVPC then
		onAddTrustedFriendFromLinkWithVPC = nil
	end

	v9.onAddTrustedFriendFromLinkWithVPC = onAddTrustedFriendFromLinkWithVPC
	return v9
end

return useGetTFActionsCallbacks
