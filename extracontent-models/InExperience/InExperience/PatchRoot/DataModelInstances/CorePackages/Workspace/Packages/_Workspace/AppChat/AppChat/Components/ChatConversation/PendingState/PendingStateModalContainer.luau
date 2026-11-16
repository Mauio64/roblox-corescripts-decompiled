local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(AppChat.types)

local AppChatNetworking = require(parent.AppChatNetworking)
local Cryo = require(parent.Cryo)
local LuaAppNavigationContext = require(AppChat.LuaAppNavigationContext)
local React = require(parent.React)
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local memo = React.memo
local useCallback = React.useCallback
local useContext = React.useContext
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local RoactUtils2 = require(parent.RoactUtils)
local useEffectOnMount = RoactUtils2.Hooks.useEffectOnMount
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RoactUtils3 = require(parent.RoactUtils)
local useSelector = RoactUtils3.Hooks.RoactRodux.useSelector
local useAnalytics = require(AppChat.Analytics.useAnalytics)

local AmpUpsell = require(parent.AmpUpsell)
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateBack = NavigationRodux.Thunks.NavigateBack
local NavigationRodux2 = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux2.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local refreshAllUnfilteredThreadsDetails = require(AppChat.Conversations.Thunks.refreshAllUnfilteredThreadsDetails)
local UnfilteredThreadsAMPFeatureName = require(AppChat.Components.UnfilteredThreadsAMPFeatureName)

local ConversationModal = require(script.Parent.Parent.ConversationModal.ConversationModal)

local v = {
	showNetworkErrorToast = function() end,
	onHeightChanged = function() end
}

local v2 = { pending_state_phone_verify = true, pending_state_ineligible = true }

local v3 = {
	pending_state_phone_verify = "ConversationPvUpsell",
	pending_state_ineligible = "ConversationIneligibleModal"
}

function PendingStateModalContainer(p)
	local union = Cryo.Dictionary.union(v, p)
	local v4 = useLocalUserId()
	local v5 = useAnalytics()
	local v6 = useContext(LuaAppNavigationContext)
	local v7 = useNavigation()
	local v8 = useDispatch()

	local v9 = useSelector(function(p2)
		return getDeepValue2(p2, `ChatAppReducer.Modals.pendingStateModals.{union.conversationId}`)
	end) or {}
	local modal_variant = v9.modal_variant
	local deepValue2 = getDeepValue2(v9, "modal_layout.id")
	local deepValue2_2 = getDeepValue2(v9, "modal_layout.seen_record_action")
	local v10 = v3[modal_variant]
	local v11 = v2[modal_variant]
	local deepValue2_3 = getDeepValue2(v9, "modal_layout.buttons")
	local v12 = deepValue2_3 and deepValue2_3[1]
	local v13 = deepValue2_3 and deepValue2_3[2]

	useEffectOnMount(function()
		if v5 and v11 and v10 then
			v5.fireAnalyticsEvent(`{v10}Rendered`, { conversationId = union.conversationId })
		end
	end)

	useEffect(function()
		if v11 then
			v8(AppChatNetworking.rodux.RecordModalSequenceResponse.API(deepValue2_2, "pending_state_modal", deepValue2)):catch(function(p2)
				warn("Error in PendingStateModalContainer -> RecordModalSequenceResponse seen: " .. tostring(p2))
			end)
		end
	end, { v8, v11, deepValue2_2, deepValue2, union.conversationId })

	local v14 = useCallback(function(p2, p3)
		return v8(AppChatNetworking.rodux.RemoveUserFromConversation.API(p3, p2))
	end, { v8 })

	local pending_state_ineligible = useCallback(function()
		if v5 and v10 then
			v5.fireAnalyticsEvent(`{v10}LearnMoreClicked`, { conversationId = union.conversationId })
		end

		if v7 then
			v6.navigateToUnfilteredThreadsLearnMore(v7.navigate)
		else
			v6.navigateToUnfilteredThreadsLearnMore()
		end
	end, { v6, v5, v10, union.conversationId, v7 })
	local pending_state_phone_verify = useCallback(function()
		if v5 and v10 then
			v5.fireAnalyticsEvent(`{v10}ContinueClicked`, { conversationId = union.conversationId })
		end

		local v15 = {
			name = AppPage.AmpWizardContainer,
			extraProps = {
				featureName = UnfilteredThreadsAMPFeatureName,
				completionCallback = function(p2, _)
					if FFlagSignalsNavP3Dispatch then
						navigationCommands.back(true)
					else
						v8(NavigateBack(true))
					end

					if p2 == AccessResponseEnum.Granted then
						if v5 and v10 then
							v5.fireAnalyticsEvent(`{v10}Succeeded`, {
								conversationId = union.conversationId
							})
						end

						v8(refreshAllUnfilteredThreadsDetails(union.conversationId))
					elseif v5 and v10 then
						v5.fireAnalyticsEvent(`{v10}Failed`, {
							conversationId = union.conversationId
						})
					end
				end
			}
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v15))
		else
			v8(NavigateDown(v15))
		end
	end, { v8, v10, v5, union.conversationId })
	local onDenied = useCallback(function()
		if v5 and v10 then
			v5.fireAnalyticsEvent(`{v10}LeftGroup`, { conversationId = union.conversationId })
		end

		if union.conversationId then
			v14(v4, union.conversationId):catch(function()
				union.showNetworkErrorToast()
			end)
		end
	end, { v4, union.conversationId, v10, v5, v14, union.showNetworkErrorToast })

	local onAccepted = ({
		pending_state_phone_verify = pending_state_phone_verify,
		pending_state_ineligible = pending_state_ineligible
	})[modal_variant]

	if v11 then
		local createElement = React.createElement
		local v15 = {
			bodyText = getDeepValue2(v9, "modal_layout.body.text"),
			acceptText = 0,
			denyText = 0,
			layoutOrder = 0,
			onAccepted = 0,
			onDenied = 0,
			onHeightChanged = 0
		}
		local acceptText

		if v13 and onAccepted then
			acceptText = v13.text
		end

		v15.acceptText = acceptText
		local denyText

		if v12 then
			denyText = v12.text
		end

		v15.denyText = denyText

		v15.layoutOrder = union.layoutOrder

		v15.onAccepted = onAccepted
		v15.onDenied = onDenied
		v15.onHeightChanged = union.onHeightChanged
		return createElement(ConversationModal, v15)
	end

	if modal_variant ~= "none" and modal_variant ~= nil and not v2[modal_variant] then
		warn("Unsupported PendingStateModal variant: " .. modal_variant)
	end

	return nil
end

return memo(PendingStateModalContainer)
