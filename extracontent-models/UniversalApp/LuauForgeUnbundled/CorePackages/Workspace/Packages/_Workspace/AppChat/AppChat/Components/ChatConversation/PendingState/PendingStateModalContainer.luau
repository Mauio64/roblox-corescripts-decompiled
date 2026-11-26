require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")

local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local LuaAppNavigationContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/LuaAppNavigationContext")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local getDeepValue2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue2")
local memo = React.memo
local useCallback = React.useCallback
local useContext = React.useContext
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useEffectOnMount = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.useEffectOnMount
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppHooks").useLocalUserId
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Navigation").useNavigation
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/useAnalytics")

local accessResponseEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AmpUpsell").AmpEnums.AccessResponseEnum
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppEnums").AppPage
local navigateBack = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/NavigationRodux").Thunks.NavigateBack
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppNavigation").NavigationCommands
else
	navigationCommands = nil
end

local refreshAllUnfilteredThreadsDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/refreshAllUnfilteredThreadsDetails")
local UnfilteredThreadsAMPFeatureName = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/UnfilteredThreadsAMPFeatureName")

local ConversationModal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ConversationModal/ConversationModal")

local v5 = {
	showNetworkErrorToast = function() end,
	onHeightChanged = function() end
}

local v6 = { pending_state_phone_verify = true, pending_state_ineligible = true }

local v7 = {
	pending_state_phone_verify = "ConversationPvUpsell",
	pending_state_ineligible = "ConversationIneligibleModal"
}

function LUAUFORGE_MODULE_GLOBALS_hCP_PendingStateModalContainer(p2)
	local union = Cryo.Dictionary.union(v5, p2)
	local v8 = useLocalUserId()
	local v9 = useAnalytics()
	local v10 = useContext(LuaAppNavigationContext)
	local v11 = useNavigation()
	local v12 = useDispatch()

	local v13 = useSelector(function(p3)
		return getDeepValue2(p3, `ChatAppReducer.Modals.pendingStateModals.{union.conversationId}`)
	end) or {}
	local modal_variant = v13.modal_variant
	local v14 = getDeepValue2(v13, "modal_layout.id")
	local v15 = getDeepValue2(v13, "modal_layout.seen_record_action")
	local v16 = v7[modal_variant]
	local v17 = v6[modal_variant]
	local v18 = getDeepValue2(v13, "modal_layout.buttons")
	local v19 = v18 and v18[1]
	local v20 = v18 and v18[2]

	useEffectOnMount(function()
		if v9 and v17 and v16 then
			v9.fireAnalyticsEvent(`{v16}Rendered`, {
				conversationId = union.conversationId
			})
		end
	end)

	useEffect(function()
		if v17 then
			v12(AppChatNetworking.rodux.RecordModalSequenceResponse.API(v15, "pending_state_modal", v14)):catch(function(p3)
				warn("Error in PendingStateModalContainer -> RecordModalSequenceResponse seen: " .. tostring(p3))
			end)
		end
	end, { v12, v17, v15, v14, union.conversationId })

	local v21 = useCallback(function(p3, p4)
		return v12(AppChatNetworking.rodux.RemoveUserFromConversation.API(p4, p3))
	end, { v12 })

	local v22 = useCallback(function()
		if v9 and v16 then
			v9.fireAnalyticsEvent(`{v16}LearnMoreClicked`, {
				conversationId = union.conversationId
			})
		end

		if v11 then
			v10.navigateToUnfilteredThreadsLearnMore(v11.navigate)
		else
			v10.navigateToUnfilteredThreadsLearnMore()
		end
	end, { v10, v9, v16, union.conversationId, v11 })
	local v23 = useCallback(function()
		if v9 and v16 then
			v9.fireAnalyticsEvent(`{v16}ContinueClicked`, {
				conversationId = union.conversationId
			})
		end

		local v24 = {
			name = appPage.AmpWizardContainer,
			extraProps = {
				featureName = UnfilteredThreadsAMPFeatureName,
				completionCallback = function(p3, p4)
					if fFlagSignalsNavP3Dispatch then
						navigationCommands.back(true)
					else
						v12(navigateBack(true))
					end

					if p3 == accessResponseEnum.Granted then
						if v9 and v16 then
							v9.fireAnalyticsEvent(`{v16}Succeeded`, {
								conversationId = union.conversationId
							})
						end

						v12(refreshAllUnfilteredThreadsDetails(union.conversationId))
					elseif v9 and v16 then
						v9.fireAnalyticsEvent(`{v16}Failed`, {
							conversationId = union.conversationId
						})
					end
				end
			}
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v24))
		else
			v12(navigateDown(v24))
		end
	end, { v12, v16, v9, union.conversationId })
	local v24 = useCallback(function()
		if v9 and v16 then
			v9.fireAnalyticsEvent(`{v16}LeftGroup`, {
				conversationId = union.conversationId
			})
		end

		if union.conversationId then
			v21(v8, union.conversationId):catch(function()
				union.showNetworkErrorToast()
			end)
		end
	end, { v8, union.conversationId, v16, v9, v21, union.showNetworkErrorToast })

	local v25 = ({ pending_state_phone_verify = v23, pending_state_ineligible = v22 })[modal_variant]

	if v17 then
		local createElement = React.createElement
		local v27 = {
			bodyText = getDeepValue2(v13, "modal_layout.body.text"),
			acceptText = 0,
			denyText = 0,
			layoutOrder = 0,
			onAccepted = 0,
			onDenied = 0,
			onHeightChanged = 0
		}
		local v28 = if v20 and v25 then v20.text else nil
		v27.acceptText = v28
		local v29 = if v19 then v19.text else nil
		v27.denyText = v29

		v27.layoutOrder = union.layoutOrder

		v27.onAccepted = v25
		v27.onDenied = v24
		v27.onHeightChanged = union.onHeightChanged
		return createElement(ConversationModal, v27)
	end

	if modal_variant ~= "none" and modal_variant ~= nil and not v6[modal_variant] then
		warn("Unsupported PendingStateModal variant: " .. modal_variant)
	end

	return nil
end

return memo(LUAUFORGE_MODULE_GLOBALS_hCP_PendingStateModalContainer)
