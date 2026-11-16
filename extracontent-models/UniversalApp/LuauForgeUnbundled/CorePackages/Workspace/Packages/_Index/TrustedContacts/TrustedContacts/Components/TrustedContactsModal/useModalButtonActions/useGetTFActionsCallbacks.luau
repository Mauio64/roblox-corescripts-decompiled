local React = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/React")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Navigation").useNavigation
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/RobloxAppEnums").AppPage

local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/DataHydration")
local contexts = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SocialLuaAnalytics").Analytics.Enums.Contexts
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/UniversalAppPolicy").useAppPolicy
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/UserProfiles")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Localization").Hooks.useLocalization
local AmpUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/AmpUpsell")

local eventNames = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Analytics").EventNames

local fFlagTCUpdateProfileCTAButton = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SharedFlags").FFlagTCUpdateProfileCTAButton
local FFlagTrustedFriendsLinkVPC = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Flags/FFlagTrustedFriendsLinkVPC")
local FFlagTFUpdateAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Flags/FFlagTFUpdateAnalytics")

local v5 = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Flags/FFlagEnableTrustedFriendsWizardVPCPrologue")
	and AmpUpsell.GetFFlagEnableAmpVPCPrologue()
	and AmpUpsell.GetFFlagEnableReusableVPCPrologue()
	and AmpUpsell.GetFFlagEnableAmpWizardVPCNavigationFix()

local fStringConnectionGraphCoreAmpNameSpace = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SharedFlags").FStringConnectionGraphCoreAmpNameSpace

require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Common/Types")

local v6 = DataHydration.TrustedConnections.TrustedConnectionsStore.get()

local function useGetTFActionsCallbacks(p2, data)
	local fireAnalyticsEvent = data.fireAnalyticsEvent

	local v7 = useNavigation()
	local v8 = useAppPolicy(function(p3)
		return p3.getShareSheetEnabled()
	end)

	local v9 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { p2 },
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})

	local v11 = useLocalization({
		isATrustedConnectionNowToast = {
			"Feature.Friends.TrustedFriend.Toast.IsATrustedFriendNow",
			name = v9 and v9.data and UserProfiles.Selectors.getCombinedNameFromId(v9.data, p2) or ""
		},
		linkCopiedToast = "Feature.Catalog.Toast.LinkCopied",
		trustedConnectionRequestSentToast = "Feature.Friends.TrustedFriend.Toast.TrustedFriendRequestSent",
		ask = v5 and "Feature.Friends.Label.Ask" or nil,
		askYourParent = v5 and "Feature.Friends.Label.AskYourParent" or nil,
		vpcRequired = v5 and "Feature.Friends.Label.AddFriendVPC" or nil
	})

	local v12 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.TrustedFriendsModalOkClicked)

		if data.onAcknowledged then
			data.onAcknowledged()
		end

		data.closeModal()
	end, { data.closeModal, data.onAcknowledged, fireAnalyticsEvent })

	local useCallback = React.useCallback
	local function fn()
		fireAnalyticsEvent(eventNames.TrustedFriendsVPCPrologueOpened)

		local v13 = nil

		if fFlagTCUpdateProfileCTAButton then
			if data.onRequestSent then
				v13 = data.onRequestSent
			elseif data.onRequestAccepted then
				v13 = data.onRequestAccepted
			end
		end

		local dismissModal = data.dismissModal
		local openAmpWizard = data.openAmpWizard

		if v5 then
			local v14 = {
				featureName = "TriggerTrustedFriendVPCRecourse",
				completionCallback = function()
					if v13 then
						v13()
					end
				end,
				recourseData = { targetUserId = p2 },
				entryPointEventCtx = contexts.TrustedFriendsVPCPrologue,
				extraParameters = {
					{ name = "targetUser", type = "UserId", value = p2 }
				},
				nameSpace = fStringConnectionGraphCoreAmpNameSpace,
				usePrologue = true,
				prologueOptions = {
					config = {
						titleText = v11.askYourParent,
						bodyText = v11.vpcRequired,
						confirmText = v11.ask
					},
					onConfirm = function()
						fireAnalyticsEvent(eventNames.TrustedFriendsVPCAskClicked)
					end,
					onCancel = function()
						fireAnalyticsEvent(eventNames.TrustedFriendsVPCCancelClicked)
					end
				}
			}

			dismissModal()
			openAmpWizard(v14)
		else
			v7.replace(appPage.TrustedFriendsVPCPrologue, {
				userId = p2,
				completionCallback = v13
			})
		end
	end

	local onRequestSent = if fFlagTCUpdateProfileCTAButton then data.onRequestSent else nil
	local onRequestAccepted = if fFlagTCUpdateProfileCTAButton then data.onRequestAccepted else nil
	local dismissModal = if v5 then data.dismissModal else nil
	local openAmpWizard = if v5 then data.openAmpWizard else nil
	local v15 = useCallback(fn, {
		fireAnalyticsEvent,
		v7,
		p2,
		onRequestSent,
		onRequestAccepted,
		dismissModal,
		openAmpWizard,
		if v5 then v11 else nil
	})

	local v16 = React.useCallback(function()
		if FFlagTFUpdateAnalytics then
			fireAnalyticsEvent(eventNames.TCUpsellIsATrustedConnectionNowToastShown)
		else
			fireAnalyticsEvent(eventNames.TCUpsellAcceptTrustedConnectionClicked)
		end

		data.showToast(v11.isATrustedConnectionNowToast)
	end, { v11.isATrustedConnectionNowToast, fireAnalyticsEvent, data.showToast })

	local v17 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.TCUpsellCancelClicked)
		data.closeModal()
	end, { data.closeModal, fireAnalyticsEvent })

	local v18 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.TCUpsellAddViaLinkClicked)
		v6.createTrustedFriendLink(p2):andThen(function(p3)
			data.shareUrl({
				url = p3.responseBody.link,
				context = contexts.TCUpsellModal
			})
		end):andThen(function()
			return data.onRequestSent and data.onRequestSent()
		end):andThen(function()
			if not v8 then
				data.showToast(v11.linkCopiedToast)
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
		p2,
		v11,
		v8,
		data.shareUrl,
		data.showToast
	})

	local v19 = React.useCallback(function()
		if FFlagTFUpdateAnalytics then
			fireAnalyticsEvent(eventNames.TCUpsellAcceptTrustedConnectionClicked)
		end

		v6.acceptTrustedConnectionRequest(p2):andThen(function()
			v16()
		end):andThen(function()
			return data.onRequestAccepted and data.onRequestAccepted()
		end):andThen(function()
			data.closeModal()
		end):catch(function()
			data.showGenericErrorModal()
		end)
	end, { data, p2, v16, fireAnalyticsEvent })

	local v20 = React.useCallback(function()
		if FFlagTFUpdateAnalytics then
			fireAnalyticsEvent(eventNames.TCUpsellAcceptTrustedConnectionClicked)
		end

		v6.addTrustedFriendFromLink(p2, data.tokens or {}):andThen(function()
			v16()
		end):andThen(fFlagTCUpdateProfileCTAButton and function()
			return data.onRequestAccepted and data.onRequestAccepted()
		end or nil):andThen(function()
			data.closeModal()
		end):catch(function()
			data.showGenericErrorModal()
		end)
	end, { data, p2, v16, fireAnalyticsEvent })

	local v21 = React.useCallback(function()
		if FFlagTFUpdateAnalytics then
			fireAnalyticsEvent(eventNames.TCUpsellAddTrustedConnectionClicked)
		end

		v6.sendTrustedConnectionRequest(p2, data.sentFromQrCode and "qr" or nil):andThen(function()
			if not FFlagTFUpdateAnalytics then
				fireAnalyticsEvent(eventNames.TCUpsellAddTrustedConnectionClicked)
			end

			data.showToast(v11.trustedConnectionRequestSentToast)
		end):andThen(function()
			return data.onRequestSent and data.onRequestSent()
		end):andThen(function()
			data.closeModal()
		end):catch(function()
			data.showGenericErrorModal()
		end)
	end, { data, p2, v11, fireAnalyticsEvent, data.showToast })
	local v22

	if FFlagTrustedFriendsLinkVPC then
		v22 = React.useCallback(function()
			if FFlagTFUpdateAnalytics then
				fireAnalyticsEvent(eventNames.TCUpsellAcceptTrustedConnectionClicked)
			end

			v6.addTrustedFriendFromLink(p2, data.tokens or {}):andThen(function()
				v15()
			end):catch(function()
				data.showGenericErrorModal()
			end)
		end, { p2, data.tokens, v15, data.showGenericErrorModal, fireAnalyticsEvent })
	end

	local v23 = {
		onOkButtonPress = v12,
		onOpenVPCProloguePress = v15,
		onCancelButtonPress = v17,
		onAcceptRequestReceived = v19,
		onAddTrustedFriendFromLink = v20,
		onSendTrustedConnectionRequest = v21,
		onAddViaLinkButtonPress = v18,
		onAddTrustedFriendFromLinkWithVPC = nil
	}

	if not FFlagTrustedFriendsLinkVPC then
		v22 = nil
	end

	v23.onAddTrustedFriendFromLinkWithVPC = v22
	return v23
end

return useGetTFActionsCallbacks
