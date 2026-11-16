local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local isPageAvailable = require(AppChat.Utils.isPageAvailable)

local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)
local useChatPlacementContext = ChatPlacementContext.useChatPlacementContext

local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatOnConsoles = SharedFlags.FFlagAppChatOnConsoles
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

return function(items)
	local chatPlacement = useChatPlacementContext().chatPlacement
	local v

	if FFlagAppChatOnConsoles then
		v = useAppPolicy(function(p)
			return p.getWebViewSupport()
		end)
	end

	local result = {}

	for _, item in items do
		local v2

		if FFlagAppChatOnConsoles then
			v2 = v
		end

		result[item] = isPageAvailable(item, chatPlacement, v2)
	end

	return result
end
