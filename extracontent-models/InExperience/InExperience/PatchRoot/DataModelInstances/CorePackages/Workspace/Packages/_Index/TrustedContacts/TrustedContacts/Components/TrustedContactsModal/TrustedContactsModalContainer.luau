local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local parent = TrustedContacts.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local Sources = SocialLuaAnalytics.Analytics.Enums.Sources

local Enums = require(TrustedContacts.Enums)
local TrustedConnectionStatus = Enums.TrustedConnectionStatus
local useModalTexts = require(script.Parent.useModalTexts)
local useModalButtonActions = require(script.Parent.useModalButtonActions)

require(TrustedContacts.TrustedFriendActions.TFActionsEnum)

local Analytics = require(script.Parent.Parent.Parent.Analytics)
local useTCAnalytics = Analytics.useTCAnalytics
local EventNames = Analytics.EventNames

local TrustedContactsModal = require(script.Parent.TrustedContactsModal)

local normalizeTFActionsEnumToModalVariant = require(TrustedContacts.TrustedFriendActions.normalizeTFActionsEnumToModalVariant)

local FFlagTCLearnMoreLink = require(TrustedContacts.Flags.FFlagTCLearnMoreLink)
local FFlagTFUpdateAnalytics = require(TrustedContacts.Flags.FFlagTFUpdateAnalytics)

local FFlagEnableTrustedFriendsWizardVPCPrologue = require(TrustedContacts.Flags.FFlagEnableTrustedFriendsWizardVPCPrologue)

require(TrustedContacts.Common.Types)

local defineFastString = game:DefineFastString(
	"TrustedConnectionsLearnMoreLink",
	"https://help.roblox.com/hc/articles/37725513985812"
)

local v = {
	TrustedConnectionStatus.Friends,
	TrustedConnectionStatus.RequestReceived,
	TrustedConnectionStatus.TrustedFriends
}

return function(props)
	local tfActionsEnum = props.tfActionsEnum
	local modalVariant = React.useMemo(function()
		if tfActionsEnum then
			return (normalizeTFActionsEnumToModalVariant(tfActionsEnum))
		end

		return nil
	end, { tfActionsEnum })

	local v2 = {
		friendId = props.userId,
		modalVariant = modalVariant,
		source = props.source,
		tfActionsEnum = 0
	}
	local tfActionsEnum2

	if FFlagTFUpdateAnalytics then
		tfActionsEnum2 = tfActionsEnum
	end

	v2.tfActionsEnum = tfActionsEnum2
	local fireAnalyticsEvent = useTCAnalytics(v2).fireAnalyticsEvent

	local v3 = React.useCallback(function()
		fireAnalyticsEvent(EventNames.TCUpsellCloseClicked)
		props.externalNavigation.closeModal()
	end, { fireAnalyticsEvent, props.externalNavigation })

	local v4 = useLocalization({
		somethingIsWrongToast = "Feature.Toast.NetworkingError.SomethingIsWrong",
		linkCopiedToast = "Feature.Catalog.Toast.LinkCopied",
		learnMoreText = FFlagTCLearnMoreLink and "Feature.Friends.LinkText.LearnMore" or nil
	})

	React.useEffect(function()
		if modalVariant then
			fireAnalyticsEvent(EventNames.TCUpsellModalSeen)
		end
	end, { modalVariant, fireAnalyticsEvent })

	local showGenericErrorModal = React.useCallback(function()
		props.externalNavigation.showToast(v4.somethingIsWrongToast)
	end, { v4.somethingIsWrongToast, props.externalNavigation })
	local index = modalVariant and table.find(v, modalVariant)

	RoactUtils.Hooks.useEffectOnce(function()
		if FFlagTFUpdateAnalytics then
			fireAnalyticsEvent(EventNames.TCUpsellInvalidTrustedFriendState)
		end

		v3()
		showGenericErrorModal()
	end, not index)

	local v5 = useModalTexts(modalVariant)

	local userId = props.userId
	local source = props.source
	local v6 = {
		closeModal = v3,
		onRequestSent = props.onRequestSent,
		onRequestAccepted = props.onRequestAccepted,
		onAcknowledged = props.onAcknowledged,
		sentFromQrCode = props.sentFromQrCode,
		tokens = props.tokens,
		showGenericErrorModal = showGenericErrorModal,
		isShareLinkSender = props.modalVariantOverride == Sources.ShareLinkSender,
		showToast = props.externalNavigation.showToast,
		shareUrl = props.externalNavigation.shareUrl,
		openAmpWizard = 0,
		dismissModal = 0,
		fireAnalyticsEvent = 0
	}
	local openAmpWizard

	if FFlagEnableTrustedFriendsWizardVPCPrologue then
		openAmpWizard = props.externalNavigation.openAmpWizard
	end

	v6.openAmpWizard = openAmpWizard
	local dismissModal

	if FFlagEnableTrustedFriendsWizardVPCPrologue then
		dismissModal = props.externalNavigation.closeModal
	end

	v6.dismissModal = dismissModal

	v6.fireAnalyticsEvent = fireAnalyticsEvent
	local modalButtonActions = useModalButtonActions(userId, source, tfActionsEnum, v6)
	local onLearnMoreClick

	if FFlagTCLearnMoreLink then
		onLearnMoreClick = React.useCallback(function()
			fireAnalyticsEvent(EventNames.TCUpsellLearnMoreClicked)
			props.externalNavigation.openWebView(defineFastString, "")
		end, { fireAnalyticsEvent, props.externalNavigation })
	end

	local v7 = modalVariant and table.find(v, modalVariant)

	if not v7 then
		return v7
	end

	local createElement = React.createElement
	local v8 = {
		isVerticallyConstrained = props.isVerticallyConstrained,
		userId = props.userId,
		source = props.source,
		headerText = v5.header,
		descriptionText = v5.description,
		modalButtonActions = modalButtonActions,
		onCloseModal = v3,
		learnMoreText = 0,
		onLearnMoreClick = 0
	}
	local learnMoreText

	if FFlagTCLearnMoreLink then
		learnMoreText = v4.learnMoreText
	end

	v8.learnMoreText = learnMoreText

	if not FFlagTCLearnMoreLink then
		onLearnMoreClick = nil
	end

	v8.onLearnMoreClick = onLearnMoreClick
	return (createElement(TrustedContactsModal, v8))
end
