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

require(TrustedContacts.Common.Types)

local function TrustedFriendsCardWithActionsCheck(p1) -- line: 32
	-- upvalues: useNavigation (copy), useTrustedFriendAction (copy), FFlagTFUpdateAnalytics (copy), useTCAnalytics (copy), React (copy), EventNames (copy), AppPage (copy), TFActionsEnum (copy), RoactUtils (copy), Foundation (copy), IconSize (copy), TrustedContactsModalContainer (copy)
	local v18 = useNavigation()
	local userId = p1.userId
	local v20 = useTrustedFriendAction({
		userId = userId,
		tokens = p1.tokens
	})
	local isLoading = v20.isLoading
	local enum = v20.enum
	local v23 = if not FFlagTFUpdateAnalytics then nil else useTCAnalytics({
		friendId = userId,
		source = p1.source,
		tfActionsEnum = enum
	}).fireAnalyticsEvent
	local v24 = React.useCallback(function() -- line: 52
		-- upvalues: FFlagTFUpdateAnalytics (copy), v23 (copy), EventNames (copy), p1 (copy), v18 (copy), AppPage (copy)
		if FFlagTFUpdateAnalytics then
			v23(EventNames.TCUpsellAgePrecheckTriggered)
		end

		p1.externalNavigation.openFacialAgeEstimationUpsell({
			onSuccess = function() -- line: 58
				-- upvalues: FFlagTFUpdateAnalytics (copy), v23 (copy), EventNames (copy), v18 (copy), AppPage (copy)
				if FFlagTFUpdateAnalytics then
					v23(EventNames.TCUpsellAgePrecheckSucceeded)
				end

				v18.replace(AppPage.TrustedFriendsUserModal, {})
			end,
			onFailure = function() -- line: 64
				-- upvalues: FFlagTFUpdateAnalytics (copy), v23 (copy), EventNames (copy), p1 (copy)
				if FFlagTFUpdateAnalytics then
					v23(EventNames.TCUpsellAgePrecheckFailed)
				end

				p1.externalNavigation.closeModal()
			end
		})
	end, {
		v18,
		p1.externalNavigation,
		v23
	})
	local v25 = enum == TFActionsEnum.UnlockTrustedFriendByFAE

	RoactUtils.Hooks.useEffectOnce(function() -- line: 75
		-- upvalues: v24 (copy)
		v24()
	end, v25)

	if v25 then
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
