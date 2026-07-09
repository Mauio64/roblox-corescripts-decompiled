local TextChatService = game:GetService("TextChatService")
local Parent = script:FindFirstAncestor("ExpChat").Parent
local List = require(Parent.llama).List
local ExpChatShared = require(Parent.ExpChatShared)
local initialCommands = require(script.Parent.initialCommands)
local t1 = {}

local function getCommandKeys() -- line: 10
	-- upvalues: TextChatService (copy), t1 (copy)
	local t2 = {}
	local descendants = TextChatService:GetDescendants()

	for _, v in ipairs(descendants) do
		if v.ClassName == "TextChatCommand" and string.sub(v.PrimaryAlias, 1, 1) == "/" then
			if v.AutocompleteVisible then
				table.insert(t2, v.PrimaryAlias)
			end

			table.insert(t1, v)
		end
	end

	return t2
end

return function(p1) -- line: 25
	-- upvalues: getCommandKeys (copy), List (copy), ExpChatShared (copy), initialCommands (copy), t1 (copy)
	local v13 = getCommandKeys()

	List.map(v13, function(p2) -- line: 27
		-- upvalues: p1 (copy)
		p1.trie:insert(p2)
	end)

	for _, v15 in ExpChatShared.Commands.getVirtualLocalEnabledCommands() do
		for _, v17 in v15.alias do
			p1.trie:insert(v17)
		end
	end

	initialCommands(t1)

	return p1.trie
end
