local conversationOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking").Constants.ConversationOverlay
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger")
local getDeepValue2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue2")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector

local set = {
	[conversationOverlay.TrustedConnectionCreated] = true,
	[conversationOverlay.AddTrustedConnectionU18] = true,
	[conversationOverlay.TrustedConnectionRequestU18] = true
}

return function(p2)
	local v5 = useSelector(function(p3)
		return getDeepValue2(p3, `ChatAppReducer.Modals.conversationOverlays.{p2}.modal_variant`) or ""
	end)

	local v6 = set[v5]

	if not v6 and v5 ~= conversationOverlay.None and v5 ~= "" then
		Logger:warning(`Unsupported ConversationOverlay modal variant: {v5} for conversationId: {p2}`)
	end

	return v6 and true or false
end
