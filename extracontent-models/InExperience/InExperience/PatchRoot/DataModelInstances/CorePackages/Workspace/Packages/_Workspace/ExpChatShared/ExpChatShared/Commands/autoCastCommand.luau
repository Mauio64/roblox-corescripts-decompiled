local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local parent = ExpChatShared.Parent
local Promise = require(parent.Promise)

local context = require(ExpChatShared.context)

local Commands = script:FindFirstAncestor("Commands")
require(Commands.types)

local function matchesAlias(autoCastCommand, value: string): boolean
	for _, item in pairs(autoCastCommand) do
		if string.find(value, "^" .. item .. " ") then
			return true
		end
	end

	return false
end

return function(p, p2: number, p3: string)
	return Promise.try(function()
		assert(context.store, "Store should exist")

		if matchesAlias(context.store:getState().AutoCastCommands[p.name], p3) then
			local clientRun = p.clientRun(context.store, p2, p3)

			if clientRun and string.find(clientRun.metadata, "Success") then
				return Promise.resolve(clientRun)
			end
		end

		return Promise.reject()
	end)
end
