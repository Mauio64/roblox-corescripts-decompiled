local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local isPageAvailable = require(AppChat.Utils.isPageAvailable)
local useChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext).useChatPlacementContext
local FFlagAppChatOnConsoles = require(AppChatParent.SharedFlags).FFlagAppChatOnConsoles
local useAppPolicy = require(AppChatParent.UniversalAppPolicy).useAppPolicy

return function(t1: {[any]: any}) -- line: 21
	-- upvalues: useChatPlacementContext (copy), FFlagAppChatOnConsoles (copy), useAppPolicy (copy), isPageAvailable (copy)
	local chatPlacement = useChatPlacementContext().chatPlacement
	local v9 = if not FFlagAppChatOnConsoles then nil else useAppPolicy(function(p1) -- line: 24
		return p1.getWebViewSupport()
	end)
	local t2 = {}

	for _, v12 in t1 do
		t2[v12] = isPageAvailable(v12, chatPlacement, if not FFlagAppChatOnConsoles then nil else v9)
	end

	return t2
end
