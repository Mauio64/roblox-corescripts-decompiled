local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppChatNetworking = require(parent.AppChatNetworking)
local ConversationOverlay = AppChatNetworking.Constants.ConversationOverlay
local Logger = require(AppChat.Logger)
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local set = {
	[ConversationOverlay.TrustedConnectionCreated] = true,
	[ConversationOverlay.AddTrustedConnectionU18] = true,
	[ConversationOverlay.TrustedConnectionRequestU18] = true
}

return function(p: string)
	local v = useSelector(function(p2)
		return getDeepValue2(p2, `ChatAppReducer.Modals.conversationOverlays.{p}.modal_variant`) or ""
	end)

	local v2 = set[v]

	if not v2 and v ~= ConversationOverlay.None and v ~= "" then
		Logger:warning(`Unsupported ConversationOverlay modal variant: {v} for conversationId: {p}`)
	end

	return v2 and true or false
end
