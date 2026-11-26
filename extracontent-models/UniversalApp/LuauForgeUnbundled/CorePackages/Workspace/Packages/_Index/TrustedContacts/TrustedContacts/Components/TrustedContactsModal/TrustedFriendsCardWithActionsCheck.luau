local React = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/RoactUtils")

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/RobloxAppEnums").AppPage

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Foundation")
local iconSize = Foundation.Enums.IconSize

local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Navigation").useNavigation

local TrustedContactsModalContainer = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Components/TrustedContactsModal/TrustedContactsModalContainer")

local useTrustedFriendAction = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/TrustedFriendActions/useTrustedFriendAction")
local TFActionsEnum = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/TrustedFriendActions/TFActionsEnum")

local Analytics = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Analytics")
local useTCAnalytics = Analytics.useTCAnalytics
local eventNames = Analytics.EventNames

local FFlagTFUpdateAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Flags/FFlagTFUpdateAnalytics")
local FFlagTFPassQRCodeSource = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Flags/FFlagTFPassQRCodeSource")

require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Common/Types")

local function TrustedFriendsCardWithActionsCheck(props)
	local v5 = useNavigation()
	local userId = props.userId

	local v7 = { userId = userId, tokens = props.tokens, sentFromQrCode = 0 }
	local v8 = if FFlagTFPassQRCodeSource then props.sentFromQrCode else nil
	v7.sentFromQrCode = v8
	local v9 = useTrustedFriendAction(v7)

	local isLoading = v9.isLoading
	local enum = v9.enum
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

	local v10 = React.useCallback(function()
		if FFlagTFUpdateAnalytics then
			fireAnalyticsEvent(eventNames.TCUpsellAgePrecheckTriggered)
		end

		props.externalNavigation.openFacialAgeEstimationUpsell({
			onSuccess = function()
				if FFlagTFUpdateAnalytics then
					fireAnalyticsEvent(eventNames.TCUpsellAgePrecheckSucceeded)
				end

				v5.replace(appPage.TrustedFriendsUserModal, {})
			end,
			onFailure = function()
				if FFlagTFUpdateAnalytics then
					fireAnalyticsEvent(eventNames.TCUpsellAgePrecheckFailed)
				end

				props.externalNavigation.closeModal()
			end
		})
	end, { v5, props.externalNavigation, fireAnalyticsEvent })

	local v11 = enum == TFActionsEnum.UnlockTrustedFriendByFAE

	RoactUtils.Hooks.useEffectOnce(function()
		v10()
	end, v11)

	if v11 then
		return nil
	end

	if isLoading then
		return React.createElement(Foundation.View, {
			tag = "position-center-center auto-xy"
		}, {
			LoadingIcon = React.createElement(Foundation.Loading, {
				LayoutOrder = 1,
				size = iconSize.Large
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
