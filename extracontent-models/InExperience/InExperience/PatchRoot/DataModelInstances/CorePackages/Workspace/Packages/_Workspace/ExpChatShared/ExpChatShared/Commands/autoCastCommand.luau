local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local ExpChatSharedParent = ExpChatShared.Parent
local Promise = require(ExpChatSharedParent.Promise)
local context = require(ExpChatShared.context)
local Commands = script:FindFirstAncestor("Commands")

require(Commands.types)

local function matchesAlias(t1: {[any]: any}, s1: string) -- line: 10
	for _, v in pairs(t1) do
		if string.find(s1, "^" .. v .. " ") then
			return true
		end
	end

	return false
end

return function(p1, n1: number, s2: string) -- line: 20
	-- upvalues: Promise (copy), context (copy), matchesAlias (copy)
	return Promise.try(function() -- line: 21
		-- upvalues: context (copy), p1 (copy), matchesAlias (copy), s2 (copy), n1 (copy), Promise (copy)
		assert(context.store, "Store should exist")

		local v14 = context.store:getState().AutoCastCommands[p1.name]

		if matchesAlias(v14, s2) then
			local v15 = p1.clientRun(context.store, n1, s2)

			if v15 and string.find(v15.metadata, "Success") then
				return Promise.resolve(v15)
			end
		end

		return Promise.reject()
	end)
end
