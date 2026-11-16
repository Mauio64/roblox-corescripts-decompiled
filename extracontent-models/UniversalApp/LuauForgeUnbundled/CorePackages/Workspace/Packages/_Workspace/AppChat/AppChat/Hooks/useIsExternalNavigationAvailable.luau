local isPageAvailable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/isPageAvailable")

local useChatPlacementContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPlacementContext").useChatPlacementContext

local fFlagAppChatOnConsoles = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatOnConsoles
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UniversalAppPolicy").useAppPolicy

return function(items)
	local chatPlacement = useChatPlacementContext().chatPlacement
	local v5

	if fFlagAppChatOnConsoles then
		v5 = useAppPolicy(function(p2)
			return p2.getWebViewSupport()
		end)
	end

	local result = {}

	for k, item in items do
		local v7 = if fFlagAppChatOnConsoles then v5 else nil
		result[item] = isPageAvailable(item, chatPlacement, v7)
	end

	return result
end
