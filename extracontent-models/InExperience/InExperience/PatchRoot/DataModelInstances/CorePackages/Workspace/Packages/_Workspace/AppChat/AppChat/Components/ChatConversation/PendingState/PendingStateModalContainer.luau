local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.types)

local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local Cryo = require(AppChatParent.Cryo)
local LuaAppNavigationContext = require(AppChat.LuaAppNavigationContext)
local React = require(AppChatParent.React)
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local memo = React.memo
local useCallback = React.useCallback
local useContext = React.useContext
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useEffectOnMount = require(AppChatParent.RoactUtils).Hooks.useEffectOnMount
local useLocalUserId = require(AppChatParent.RobloxAppHooks).useLocalUserId
local useNavigation = require(AppChatParent.Navigation).useNavigation
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local useAnalytics = require(AppChat.Analytics.useAnalytics)
local AccessResponseEnum = require(AppChatParent.AmpUpsell).AmpEnums.AccessResponseEnum
local AppPage = require(AppChatParent.RobloxAppEnums).AppPage
local NavigateBack = require(AppChatParent.NavigationRodux).Thunks.NavigateBack
local NavigateDown = require(AppChatParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(AppChatParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v23 = if not FFlagSignalsNavP3Dispatch then nil else require(AppChatParent.RobloxAppNavigation).NavigationCommands
local refreshAllUnfilteredThreadsDetails = require(AppChat.Conversations.Thunks.refreshAllUnfilteredThreadsDetails)
local UnfilteredThreadsAMPFeatureName = require(AppChat.Components.UnfilteredThreadsAMPFeatureName)
local ConversationModal = require(script.Parent.Parent.ConversationModal.ConversationModal)
local t1 = {
	showNetworkErrorToast = function() -- line: 46
	end,
	onHeightChanged = function() -- line: 47
	end
}
local t2 = {
	pending_state_phone_verify = true,
	pending_state_ineligible = true
}
local t3 = {
	pending_state_phone_verify = "ConversationPvUpsell",
	pending_state_ineligible = "ConversationIneligibleModal"
}

function PendingStateModalContainer(t4: {[any]: any}) -- line: 61
	-- upvalues: Cryo (copy), t1 (copy), useLocalUserId (copy), useAnalytics (copy), useContext (copy), LuaAppNavigationContext (copy), useNavigation (copy), useDispatch (copy), useSelector (copy), getDeepValue2 (copy), t3 (copy), t2 (copy), useEffectOnMount (copy), useEffect (copy), AppChatNetworking (copy), useCallback (copy), AppPage (copy), UnfilteredThreadsAMPFeatureName (copy), FFlagSignalsNavP3Dispatch (copy), v23 (copy), NavigateBack (copy), AccessResponseEnum (copy), refreshAllUnfilteredThreadsDetails (copy), NavigateDown (copy), React (copy), ConversationModal (copy)
	local v31 = Cryo.Dictionary.union(t1, t4)
	local v32 = useLocalUserId()
	local v33 = useAnalytics()
	local v34 = useContext(LuaAppNavigationContext)
	local v35 = useNavigation()
	local v36 = useDispatch()
	local v37 = useSelector(function(p1) -- line: 70
		-- upvalues: getDeepValue2 (copy), v31 (copy)
		return getDeepValue2(p1, `ChatAppReducer.Modals.pendingStateModals.{ v31.conversationId }`)
	end) or {}
	local modal_variant = v37.modal_variant
	local v39 = getDeepValue2(v37, "modal_layout.id")
	local v40 = getDeepValue2(v37, "modal_layout.seen_record_action")
	local v41 = t3[modal_variant]
	local v42 = t2[modal_variant]
	local v43 = getDeepValue2(v37, "modal_layout.buttons")
	local v44 = v43 and v43[1]
	local v45 = v43 and v43[2]

	useEffectOnMount(function() -- line: 83
		-- upvalues: v33 (copy), v42 (copy), v41 (copy), v31 (copy)
		if v33 and (v42 and v41) then
			v33.fireAnalyticsEvent(`{ v41 }Rendered`, {
				conversationId = v31.conversationId
			})
		end
	end)
	useEffect(function() -- line: 92
		-- upvalues: v42 (copy), v36 (copy), AppChatNetworking (copy), v40 (copy), v39 (copy)
		if v42 then
			v36(AppChatNetworking.rodux.RecordModalSequenceResponse.API(v40, "pending_state_modal", v39)):catch(function(p2) -- line: 100
				warn("Error in PendingStateModalContainer -> RecordModalSequenceResponse seen: " .. tostring(p2))
			end)
		end
	end, {
		v36,
		v42,
		v40,
		v39,
		v31.conversationId
	})

	local v46 = useCallback(function(p3, p4) -- line: 114
		-- upvalues: v36 (copy), AppChatNetworking (copy)
		return v36(AppChatNetworking.rodux.RemoveUserFromConversation.API(p4, p3))
	end, { v36 })
	local v47 = useCallback(function() -- line: 118
		-- upvalues: v33 (copy), v41 (copy), v31 (copy), v35 (copy), v34 (copy)
		if v33 and v41 then
			v33.fireAnalyticsEvent(`{ v41 }LearnMoreClicked`, {
				conversationId = v31.conversationId
			})
		end

		if v35 then
			v34.navigateToUnfilteredThreadsLearnMore(v35.navigate)

			return
		end

		v34.navigateToUnfilteredThreadsLearnMore()
	end, {
		v34,
		v33,
		v41,
		v31.conversationId,
		v35
	})
	local v48 = useCallback(function() -- line: 130
		-- upvalues: v33 (copy), v41 (copy), v31 (copy), AppPage (copy), UnfilteredThreadsAMPFeatureName (copy), FFlagSignalsNavP3Dispatch (copy), v23 (copy), v36 (copy), NavigateBack (copy), AccessResponseEnum (copy), refreshAllUnfilteredThreadsDetails (copy), NavigateDown (copy)
		if v33 and v41 then
			v33.fireAnalyticsEvent(`{ v41 }ContinueClicked`, {
				conversationId = v31.conversationId
			})
		end

		local t5 = {
			name = AppPage.AmpWizardContainer,
			extraProps = {
				featureName = UnfilteredThreadsAMPFeatureName,
				completionCallback = function(p5, _) -- line: 140
					-- upvalues: FFlagSignalsNavP3Dispatch (copy), v23 (copy), v36 (copy), NavigateBack (copy), AccessResponseEnum (copy), v33 (copy), v41 (copy), v31 (copy), refreshAllUnfilteredThreadsDetails (copy)
					if FFlagSignalsNavP3Dispatch then
						v23.back(true)
					else
						v36(NavigateBack(true))
					end

					if p5 == AccessResponseEnum.Granted then
						if v33 and v41 then
							v33.fireAnalyticsEvent(`{ v41 }Succeeded`, {
								conversationId = v31.conversationId
							})
						end

						v36(refreshAllUnfilteredThreadsDetails(v31.conversationId))

						return
					end

					if v33 and v41 then
						v33.fireAnalyticsEvent(`{ v41 }Failed`, {
							conversationId = v31.conversationId
						})
					end
				end
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v23.down(v23.fromLegacyPage(t5))

			return
		end

		v36(NavigateDown(t5))
	end, {
		v36,
		v41,
		v33,
		v31.conversationId
	})
	local v49 = useCallback(function() -- line: 171
		-- upvalues: v33 (copy), v41 (copy), v31 (copy), v46 (copy), v32 (copy)
		if v33 and v41 then
			v33.fireAnalyticsEvent(`{ v41 }LeftGroup`, {
				conversationId = v31.conversationId
			})
		end

		if v31.conversationId then
			v46(v32, v31.conversationId):catch(function() -- line: 179
				-- upvalues: v31 (copy)
				v31.showNetworkErrorToast()
			end)
		end
	end, {
		v32,
		v31.conversationId,
		v41,
		v33,
		v46,
		v31.showNetworkErrorToast
	})
	local v50 = ({
		pending_state_phone_verify = v48,
		pending_state_ineligible = v47
	})[modal_variant]

	if v42 then
		return React.createElement(ConversationModal, {
			bodyText = getDeepValue2(v37, "modal_layout.body.text"),
			acceptText = if not v45 or not v50 then nil else v45.text,
			denyText = if not v44 then nil else v44.text,
			layoutOrder = v31.layoutOrder,
			onAccepted = v50,
			onDenied = v49,
			onHeightChanged = v31.onHeightChanged
		})
	end

	if modal_variant ~= "none" and modal_variant ~= nil and not t2[modal_variant] then
		warn("Unsupported PendingStateModal variant: " .. modal_variant)
	end

	return nil
end

return memo(PendingStateModalContainer)
