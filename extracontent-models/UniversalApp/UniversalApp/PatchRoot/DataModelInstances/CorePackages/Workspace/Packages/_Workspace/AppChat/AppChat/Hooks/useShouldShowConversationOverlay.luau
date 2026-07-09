local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local ConversationOverlay = require(AppChatParent.AppChatNetworking).Constants.ConversationOverlay
local Logger = require(AppChat.Logger)
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local FFlagAppChatEnableDoubleOptIn = require(AppChatParent.SharedFlags).FFlagAppChatEnableDoubleOptIn
local t1 = {
	[ConversationOverlay.TrustedConnectionCreated] = true,
	[ConversationOverlay.AddTrustedConnectionU18] = FFlagAppChatEnableDoubleOptIn,
	[ConversationOverlay.TrustedConnectionRequestU18] = FFlagAppChatEnableDoubleOptIn
}

return function(s1: string) -- line: 20
	-- upvalues: useSelector (copy), getDeepValue2 (copy), t1 (copy), ConversationOverlay (copy), Logger (copy)
	local v10 = useSelector(function(p1) -- line: 21
		-- upvalues: getDeepValue2 (copy), s1 (copy)
		return getDeepValue2(p1, `ChatAppReducer.Modals.conversationOverlays.{ s1 }.modal_variant`) or ""
	end)
	local v11 = t1[v10]

	if not v11 and (v10 ~= ConversationOverlay.None and v10 ~= "") then
		Logger:warning(`Unsupported ConversationOverlay modal variant: { v10 } for conversationId: { s1 }`)
	end

	return not not v11
end
