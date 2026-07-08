local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Foundation = require(AppChatParent.Foundation)

require(AppChat.types)

local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local memo = React.memo
local useAnalytics = require(AppChat.Analytics.useAnalytics)
local useCallback = React.useCallback
local useConversationTopModal = require(AppChat.Hooks.useConversationTopModal)
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useRef = React.useRef
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local useStyle = require(AppChatParent.UIBlox).Core.Style.useStyle
local AccessResponseEnum = require(AppChatParent.AmpUpsell).AmpEnums.AccessResponseEnum
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local AppPage = require(AppChatParent.RobloxAppEnums).AppPage

require(AppChat.Models.ConversationChannels)

local DismissedConversationTopModal = require(AppChat.Conversations.Actions.DismissedConversationTopModal)
local EnumScreens = require(AppChat.EnumScreens)
local EventNames = require(AppChat.Analytics.EventNames)
local NavigateBack = require(AppChatParent.NavigationRodux).Thunks.NavigateBack
local NavigateDown = require(AppChatParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(AppChatParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v25 = if not FFlagSignalsNavP3Dispatch then nil else require(AppChatParent.RobloxAppNavigation).NavigationCommands
local refreshAllUnfilteredThreadsDetails = require(AppChat.Conversations.Thunks.refreshAllUnfilteredThreadsDetails)
local UnfilteredThreadsAMPFeatureName = require(AppChat.Components.UnfilteredThreadsAMPFeatureName)
local ConversationModal = require(script.Parent.ConversationModal.ConversationModal)
local ConversationBannerDeprecated = require(script.Parent.ConversationBanner.ConversationBannerDeprecated)
local t1 = {
	conversation = {},
	navigateToScreen = function(...) -- line: 50
	end,
	setModalHeight = function(_) -- line: 51
	end
}
local t2 = {
	conversation_banner_group_phone_verification = true,
	conversation_banner_group_duplicate_upgrade = true,
	conversation_banner_learn_more = true,
	conversation_banner_one_to_one_phone_verification = true
}
local CreateUnfilteredChatPartialModal = EnumScreens.CreateUnfilteredChatPartialModal
local LearnMorePartialModal = EnumScreens.LearnMorePartialModal
local t3 = {
	conversation_banner_group_phone_verification = "ConversationPvBanner",
	conversation_banner_one_to_one_phone_verification = "ConversationPvBanner",
	conversation_banner_group_duplicate_upgrade = "ConversationUpgradeBanner",
	conversation_banner_learn_more = "ConversationLearnMoreBanner"
}

local function ConversationTopModalContainer(t4: {[any]: any}) -- line: 71
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), useAnalytics (copy), useDispatch (copy), useRef (copy), useEffect (copy), useSelector (copy), getDeepValue2 (copy), useConversationTopModal (copy), t3 (copy), t2 (copy), useCallback (copy), EventNames (copy), AppChatNetworking (copy), DismissedConversationTopModal (copy), AppPage (copy), UnfilteredThreadsAMPFeatureName (copy), FFlagSignalsNavP3Dispatch (copy), v25 (copy), NavigateBack (copy), AccessResponseEnum (copy), refreshAllUnfilteredThreadsDetails (copy), NavigateDown (copy), CreateUnfilteredChatPartialModal (copy), LearnMorePartialModal (copy), React (copy), ConversationBannerDeprecated (copy), ConversationModal (copy), Foundation (copy)
	local v38 = Cryo.Dictionary.union(t1, t4)
	local v39 = useStyle()
	local v40 = useAnalytics()
	local v41 = useDispatch()
	local Size_1000 = v39.Tokens.Size.Size_1000
	local v43 = useRef(v38.setModalHeight)

	useEffect(function() -- line: 80
		-- upvalues: v43 (copy), v38 (copy)
		v43.current = v38.setModalHeight
	end, { v38.setModalHeight })
	useEffect(function() -- line: 83
		-- upvalues: v43 (copy)
		return function() -- line: 84
			-- upvalues: v43 (copy)
			if v43.current then
				v43.current(0)
			end
		end
	end, {})

	local v44 = useSelector(function(p2) -- line: 91
		-- upvalues: getDeepValue2 (copy), v38 (copy)
		return getDeepValue2(p2, `ChatAppReducer.Modals.conversationTopModalsDismissed.{ v38.conversation.id }`) or {}
	end)
	local v45 = useConversationTopModal(v38.conversation.id) or {}
	local modal_variant = v45.modal_variant
	local v47 = getDeepValue2(v45, "modal_layout.id")
	local v48 = getDeepValue2(v45, "modal_layout.seen_record_action")
	local v49 = getDeepValue2(v45, "modal_layout.dismiss_record_action")
	local v50 = t3[modal_variant]
	local v51 = t2[modal_variant] and not v44[modal_variant]
	local v52 = getDeepValue2(v45, "modal_layout.buttons")
	local v53 = v52 and v52[1]
	local v54 = v52 and v52[2]
	local v55 = useCallback(function() -- line: 107
		-- upvalues: v40 (copy), v50 (copy), EventNames (copy), v38 (copy)
		if v40 and v50 then
			v40.fireAnalyticsEvent(EventNames[`{ v50 }ActionClicked`], {
				conversationId = v38.conversation.id
			})
		end
	end, {
		v40,
		v50,
		v38.conversation.id
	})
	local v56 = useCallback(function() -- line: 115
		-- upvalues: v41 (copy), AppChatNetworking (copy), v49 (copy), v47 (copy), DismissedConversationTopModal (copy), v38 (copy), modal_variant (copy)
		v41(AppChatNetworking.rodux.RecordModalSequenceResponse.API(v49, "conversation_top_modal", v47)):catch(function(p3) -- line: 122
			warn("Error in ConversationTopModalContainer -> RecordModalSequenceResponse dismissed: " .. tostring(p3))
		end)
		v41(DismissedConversationTopModal(v38.conversation.id, modal_variant))
	end, {
		v41,
		v49,
		modal_variant,
		v47,
		v38.conversation.id
	})
	local v57 = useCallback(function() -- line: 127
		-- upvalues: v55 (copy), AppPage (copy), UnfilteredThreadsAMPFeatureName (copy), FFlagSignalsNavP3Dispatch (copy), v25 (copy), v41 (copy), NavigateBack (copy), AccessResponseEnum (copy), refreshAllUnfilteredThreadsDetails (copy), v38 (copy), NavigateDown (copy)
		v55()

		local t5 = {
			name = AppPage.AmpWizardContainer,
			extraProps = {
				featureName = UnfilteredThreadsAMPFeatureName,
				completionCallback = function(p4, _) -- line: 133
					-- upvalues: FFlagSignalsNavP3Dispatch (copy), v25 (copy), v41 (copy), NavigateBack (copy), AccessResponseEnum (copy), refreshAllUnfilteredThreadsDetails (copy), v38 (copy)
					if FFlagSignalsNavP3Dispatch then
						v25.back(true)
					else
						v41(NavigateBack(true))
					end

					if p4 == AccessResponseEnum.Granted then
						v41(refreshAllUnfilteredThreadsDetails(v38.conversation.id))
					end
				end
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v25.down(v25.fromLegacyPage(t5))

			return
		end

		v41(NavigateDown(t5))
	end, {
		v55,
		v41,
		v38.conversation.id
	})
	local v58 = useCallback(function() -- line: 153
		-- upvalues: v55 (copy), v38 (copy), CreateUnfilteredChatPartialModal (copy)
		v55()
		v38.navigateToScreen(CreateUnfilteredChatPartialModal, {}, true)
	end, {
		v38.navigateToScreen,
		v55
	})
	local v59 = useCallback(function() -- line: 157
		-- upvalues: v55 (copy), v38 (copy), LearnMorePartialModal (copy)
		v55()
		v38.navigateToScreen(LearnMorePartialModal, {}, true)
	end, {
		v38.navigateToScreen,
		v55
	})

	useEffect(function() -- line: 163
		-- upvalues: v51 (copy), v41 (copy), AppChatNetworking (copy), v48 (copy), v47 (copy)
		if v51 then
			v41(AppChatNetworking.rodux.RecordModalSequenceResponse.API(v48, "conversation_top_modal", v47)):catch(function(p6) -- line: 171
				warn("Error in ConversationTopModalContainer -> RecordModalSequenceResponse seen: " .. tostring(p6))
			end)
		end
	end, {
		v41,
		v51,
		v48,
		v47,
		v38.conversation.id
	})
	useEffect(function() -- line: 188
		-- upvalues: v51 (copy), v40 (copy), v50 (copy), EventNames (copy), v38 (copy)
		if v51 and (v40 and v50) then
			v40.fireAnalyticsEvent(EventNames[`{ v50 }Rendered`], {
				conversationId = v38.conversation.id
			})
		end
	end, {
		v51,
		v40,
		v50,
		v38.conversation.id
	})

	local v60 = ({
		conversation_banner_group_phone_verification = v57,
		conversation_banner_one_to_one_phone_verification = v57,
		conversation_banner_group_duplicate_upgrade = v58
	})[modal_variant]
	local v61 = nil

	if v51 then
		v61 = if modal_variant ~= "conversation_banner_learn_more" then React.createElement(ConversationModal, {
			bodyText = getDeepValue2(v45, "modal_layout.body.text"),
			denyText = if not v53 then nil else v53.text,
			acceptText = if not v54 or not v60 then nil else v54.text,
			paddingTop = v39.Tokens.Size.Size_300,
			paddingBottom = v39.Tokens.Size.Size_300,
			verticalSpacing = v39.Tokens.Size.Size_300,
			onAccepted = v60,
			onDenied = v56,
			style = v39
		}) else React.createElement(ConversationBannerDeprecated, {
			actionText = if not v53 then nil else v53.text,
			bodyText = getDeepValue2(v45, "modal_layout.body.text"),
			height = Size_1000,
			onActivated = v59,
			style = v39
		})
	elseif modal_variant ~= "none" and modal_variant ~= nil and not t2[modal_variant] then
		warn("Unsupported ConversationTopModal variant: " .. modal_variant)
	end

	return React.createElement(Foundation.View, {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = v38.layoutOrder,
		onAbsoluteSizeChanged = function(p7) -- line: 242
			-- upvalues: v38 (copy)
			v38.setModalHeight(p7.AbsoluteSize.Y)
		end
	}, {
		conversationTopModal = v61
	})
end

return memo(ConversationTopModalContainer)
