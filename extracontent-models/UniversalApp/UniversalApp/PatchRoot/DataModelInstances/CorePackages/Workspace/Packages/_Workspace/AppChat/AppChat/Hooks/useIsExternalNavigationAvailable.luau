local AppChat = script:FindFirstAncestor("AppChat")
local isPageAvailable = require(AppChat.Utils.isPageAvailable)
local useChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext).useChatPlacementContext

return function(t1: {[any]: any}) -- line: 16
	-- upvalues: useChatPlacementContext (copy), isPageAvailable (copy)
	local chatPlacement = useChatPlacementContext().chatPlacement
	local t2 = {}

	for _, v8 in t1 do
		t2[v8] = isPageAvailable(v8, chatPlacement)
	end

	return t2
end
