local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/Promise")

local context = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/context")

require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Commands/types")

local function matchesAlias(autoCastCommand, value): boolean
	for k, item in pairs(autoCastCommand) do
		if string.find(value, "^" .. item .. " ") then
			return true
		end
	end

	return false
end

return function(p2, p3, p4)
	return Promise.try(function()
		assert(context.store, "Store should exist")

		if matchesAlias(context.store:getState().AutoCastCommands[p2.name], p4) then
			local clientRun = p2.clientRun(context.store, p3, p4)

			if clientRun and string.find(clientRun.metadata, "Success") then
				return Promise.resolve(clientRun)
			end
		end

		return Promise.reject()
	end)
end
