local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local TrustedContactsParent = TrustedContacts.Parent
local React = require(TrustedContactsParent.React)
local RoactUtils = require(TrustedContactsParent.RoactUtils)
local AppPage = require(TrustedContactsParent.RobloxAppEnums).AppPage
local Foundation = require(TrustedContactsParent.Foundation)
local IconSize = Foundation.Enums.IconSize
local useNavigation = require(TrustedContactsParent.Navigation).useNavigation
local TrustedContactsModalContainer = require(script.Parent.TrustedContactsModalContainer)
local useTrustedFriendAction = require(TrustedContacts.TrustedFriendActions.useTrustedFriendAction)
local TFActionsEnum = require(TrustedContacts.TrustedFriendActions.TFActionsEnum)
local Analytics = require(TrustedContacts.Analytics)
local useTCAnalytics = Analytics.useTCAnalytics
local EventNames = Analytics.EventNames
local FFlagTFUpdateAnalytics = require(TrustedContacts.Flags.FFlagTFUpdateAnalytics)
local FFlagTFPassQRCodeSource = require(TrustedContacts.Flags.FFlagTFPassQRCodeSource)

require(TrustedContacts.Common.Types)

local function TrustedFriendsCardWithActionsCheck(p1) -- line: 33
	-- upvalues: useNavigation (copy), useTrustedFriendAction (copy), FFlagTFPassQRCodeSource (copy), FFlagTFUpdateAnalytics (copy), useTCAnalytics (copy), React (copy), EventNames (copy), AppPage (copy), TFActionsEnum (copy), RoactUtils (copy), Foundation (copy), IconSize (copy), TrustedContactsModalContainer (copy)
	local v19 = useNavigation()
	local userId = p1.userId
	local v21 = useTrustedFriendAction({
		userId = userId,
		tokens = p1.tokens,
		sentFromQrCode = if not FFlagTFPassQRCodeSource then nil else p1.sentFromQrCode
	})
	local isLoading = v21.isLoading
	local enum = v21.enum
	local v24 = if not FFlagTFUpdateAnalytics then nil else useTCAnalytics({
		friendId = userId,
		source = p1.source,
		tfActionsEnum = enum
	}).fireAnalyticsEvent
	local v25 = React.useCallback(function() -- line: 54
		-- upvalues: FFlagTFUpdateAnalytics (copy), v24 (copy), EventNames (copy), p1 (copy), v19 (copy), AppPage (copy)
		if FFlagTFUpdateAnalytics then
			v24(EventNames.TCUpsellAgePrecheckTriggered)
		end

		p1.externalNavigation.openFacialAgeEstimationUpsell({
			onSuccess = function() -- line: 60
				-- upvalues: FFlagTFUpdateAnalytics (copy), v24 (copy), EventNames (copy), v19 (copy), AppPage (copy)
				if FFlagTFUpdateAnalytics then
					v24(EventNames.TCUpsellAgePrecheckSucceeded)
				end

				v19.replace(AppPage.TrustedFriendsUserModal, {})
			end,
			onFailure = function() -- line: 66
				-- upvalues: FFlagTFUpdateAnalytics (copy), v24 (copy), EventNames (copy), p1 (copy)
				if FFlagTFUpdateAnalytics then
					v24(EventNames.TCUpsellAgePrecheckFailed)
				end

				p1.externalNavigation.closeModal()
			end
		})
	end, {
		v19,
		p1.externalNavigation,
		v24
	})
	local v26 = enum == TFActionsEnum.UnlockTrustedFriendByFAE

	RoactUtils.Hooks.useEffectOnce(function() -- line: 77
		-- upvalues: v25 (copy)
		v25()
	end, v26)

	if v26 then
		return nil
	end

	if isLoading then
		return React.createElement(Foundation.View, {
			tag = "position-center-center auto-xy"
		}, {
			LoadingIcon = React.createElement(Foundation.Loading, {
				LayoutOrder = 1,
				size = IconSize.Large
			})
		})
	end

	return React.createElement(TrustedContactsModalContainer, {
		userId = p1.userId,
		source = p1.source,
		tokens = p1.tokens,
		sentFromQrCode = p1.sentFromQrCode,
		isVerticallyConstrained = p1.isVerticallyConstrained,
		onRequestSent = p1.onRequestSent,
		onRequestAccepted = p1.onRequestAccepted,
		onAcknowledged = p1.onAcknowledged,
		externalNavigation = p1.externalNavigation,
		tfActionsEnum = enum
	})
end

return TrustedFriendsCardWithActionsCheck
