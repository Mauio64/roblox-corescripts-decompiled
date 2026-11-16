local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local parent = TrustedContacts.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local Foundation = require(parent.Foundation)
local IconSize = Foundation.Enums.IconSize

local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

local TrustedContactsModalContainer = require(script.Parent.TrustedContactsModalContainer)

local useTrustedFriendAction = require(TrustedContacts.TrustedFriendActions.useTrustedFriendAction)
local TFActionsEnum = require(TrustedContacts.TrustedFriendActions.TFActionsEnum)

local Analytics = require(TrustedContacts.Analytics)
local useTCAnalytics = Analytics.useTCAnalytics
local EventNames = Analytics.EventNames

local FFlagTFUpdateAnalytics = require(TrustedContacts.Flags.FFlagTFUpdateAnalytics)
local FFlagTFPassQRCodeSource = require(TrustedContacts.Flags.FFlagTFPassQRCodeSource)

require(TrustedContacts.Common.Types)

local function TrustedFriendsCardWithActionsCheck(props)
	local v = useNavigation()
	local userId = props.userId

	local v2 = { userId = userId, tokens = props.tokens, sentFromQrCode = 0 }
	local sentFromQrCode

	if FFlagTFPassQRCodeSource then
		sentFromQrCode = props.sentFromQrCode
	end

	v2.sentFromQrCode = sentFromQrCode
	local v3 = useTrustedFriendAction(v2)

	local isLoading = v3.isLoading
	local enum = v3.enum
	local fireAnalyticsEvent

	if FFlagTFUpdateAnalytics then
		fireAnalyticsEvent = useTCAnalytics({
			friendId = userId,
			source = props.source,
			tfActionsEnum = enum
		}).fireAnalyticsEvent
	else
		fireAnalyticsEvent = nil
	end

	local v4 = React.useCallback(function()
		if FFlagTFUpdateAnalytics then
			fireAnalyticsEvent(EventNames.TCUpsellAgePrecheckTriggered)
		end

		props.externalNavigation.openFacialAgeEstimationUpsell({
			onSuccess = function()
				if FFlagTFUpdateAnalytics then
					fireAnalyticsEvent(EventNames.TCUpsellAgePrecheckSucceeded)
				end

				v.replace(AppPage.TrustedFriendsUserModal, {})
			end,
			onFailure = function()
				if FFlagTFUpdateAnalytics then
					fireAnalyticsEvent(EventNames.TCUpsellAgePrecheckFailed)
				end

				props.externalNavigation.closeModal()
			end
		})
	end, { v, props.externalNavigation, fireAnalyticsEvent })

	local v5 = enum == TFActionsEnum.UnlockTrustedFriendByFAE

	RoactUtils.Hooks.useEffectOnce(function()
		v4()
	end, v5)

	if v5 then
		return nil
	end

	if isLoading then
		return React.createElement(Foundation.View, { tag = "position-center-center auto-xy" }, {
			LoadingIcon = React.createElement(Foundation.Loading, {
				LayoutOrder = 1,
				size = IconSize.Large
			})
		})
	end

	return React.createElement(TrustedContactsModalContainer, {
		userId = props.userId,
		source = props.source,
		tokens = props.tokens,
		sentFromQrCode = props.sentFromQrCode,
		isVerticallyConstrained = props.isVerticallyConstrained,
		onRequestSent = props.onRequestSent,
		onRequestAccepted = props.onRequestAccepted,
		onAcknowledged = props.onAcknowledged,
		externalNavigation = props.externalNavigation,
		tfActionsEnum = enum
	})
end

return TrustedFriendsCardWithActionsCheck
