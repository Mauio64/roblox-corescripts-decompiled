local React = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/RoactUtils")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Localization").Hooks.useLocalization
local sources = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SocialLuaAnalytics").Analytics.Enums.Sources

local trustedConnectionStatus = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Enums").TrustedConnectionStatus
local useModalTexts = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Components/TrustedContactsModal/useModalTexts")
local useModalButtonActions = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Components/TrustedContactsModal/useModalButtonActions")

require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/TrustedFriendActions/TFActionsEnum")

local Analytics = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Analytics")
local useTCAnalytics = Analytics.useTCAnalytics
local eventNames = Analytics.EventNames

local TrustedContactsModal = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Components/TrustedContactsModal/TrustedContactsModal")

local normalizeTFActionsEnumToModalVariant = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/TrustedFriendActions/normalizeTFActionsEnumToModalVariant")

local FFlagTCLearnMoreLink = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Flags/FFlagTCLearnMoreLink")
local FFlagTFUpdateAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Flags/FFlagTFUpdateAnalytics")

local FFlagEnableTrustedFriendsWizardVPCPrologue = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Flags/FFlagEnableTrustedFriendsWizardVPCPrologue")

require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Common/Types")

local defineFastString = game:DefineFastString(
	"TrustedConnectionsLearnMoreLink",
	"https://help.roblox.com/hc/articles/37725513985812"
)

local v5 = {
	trustedConnectionStatus.Friends,
	trustedConnectionStatus.RequestReceived,
	trustedConnectionStatus.TrustedFriends
}

return function(props)
	local tfActionsEnum = props.tfActionsEnum
	local v6 = React.useMemo(function()
		if tfActionsEnum then
			return (normalizeTFActionsEnumToModalVariant(tfActionsEnum))
		end

		return nil
	end, { tfActionsEnum })

	local fireAnalyticsEvent = useTCAnalytics({
		friendId = props.userId,
		modalVariant = v6,
		source = props.source,
		tfActionsEnum = if FFlagTFUpdateAnalytics then tfActionsEnum else nil
	}).fireAnalyticsEvent

	local v10 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.TCUpsellCloseClicked)
		props.externalNavigation.closeModal()
	end, { fireAnalyticsEvent, props.externalNavigation })

	local v11 = useLocalization({
		somethingIsWrongToast = "Feature.Toast.NetworkingError.SomethingIsWrong",
		linkCopiedToast = "Feature.Catalog.Toast.LinkCopied",
		learnMoreText = FFlagTCLearnMoreLink and "Feature.Friends.LinkText.LearnMore" or nil
	})

	React.useEffect(function()
		if v6 then
			fireAnalyticsEvent(eventNames.TCUpsellModalSeen)
		end
	end, { v6, fireAnalyticsEvent })

	local v12 = React.useCallback(function()
		props.externalNavigation.showToast(v11.somethingIsWrongToast)
	end, { v11.somethingIsWrongToast, props.externalNavigation })
	local index = v6 and table.find(v5, v6)

	RoactUtils.Hooks.useEffectOnce(function()
		if FFlagTFUpdateAnalytics then
			fireAnalyticsEvent(eventNames.TCUpsellInvalidTrustedFriendState)
		end

		v10()
		v12()
	end, not index)

	local v13 = useModalTexts(v6)

	local userId = props.userId
	local source = props.source
	local v16 = {
		closeModal = v10,
		onRequestSent = props.onRequestSent,
		onRequestAccepted = props.onRequestAccepted,
		onAcknowledged = props.onAcknowledged,
		sentFromQrCode = props.sentFromQrCode,
		tokens = props.tokens,
		showGenericErrorModal = v12,
		isShareLinkSender = props.modalVariantOverride == sources.ShareLinkSender,
		showToast = props.externalNavigation.showToast,
		shareUrl = props.externalNavigation.shareUrl,
		openAmpWizard = 0,
		dismissModal = 0,
		fireAnalyticsEvent = 0
	}

	local v17 = if FFlagEnableTrustedFriendsWizardVPCPrologue then props.externalNavigation.openAmpWizard else nil
	v16.openAmpWizard = v17

	local v18 = if FFlagEnableTrustedFriendsWizardVPCPrologue then props.externalNavigation.closeModal else nil
	v16.dismissModal = v18

	v16.fireAnalyticsEvent = fireAnalyticsEvent
	local v19 = useModalButtonActions(userId, source, tfActionsEnum, v16)
	local v20

	if FFlagTCLearnMoreLink then
		v20 = React.useCallback(function()
			fireAnalyticsEvent(eventNames.TCUpsellLearnMoreClicked)
			props.externalNavigation.openWebView(defineFastString, "")
		end, { fireAnalyticsEvent, props.externalNavigation })
	end

	local v21 = v6 and table.find(v5, v6)

	if not v21 then
		return v21
	end

	local createElement = React.createElement
	local v23 = {
		isVerticallyConstrained = props.isVerticallyConstrained,
		userId = props.userId,
		source = props.source,
		headerText = v13.header,
		descriptionText = v13.description,
		modalButtonActions = v19,
		onCloseModal = v10,
		learnMoreText = 0,
		onLearnMoreClick = 0
	}

	local v24 = if FFlagTCLearnMoreLink then v11.learnMoreText else nil
	v23.learnMoreText = v24

	if not FFlagTCLearnMoreLink then
		v20 = nil
	end

	v23.onLearnMoreClick = v20
	v21 = createElement(TrustedContactsModal, v23)
	return v21
end
