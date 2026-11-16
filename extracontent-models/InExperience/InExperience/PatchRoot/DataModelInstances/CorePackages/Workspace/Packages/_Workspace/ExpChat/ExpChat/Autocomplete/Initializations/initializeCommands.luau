local TextChatService = game:GetService("TextChatService")
local parent = script:FindFirstAncestor("ExpChat").Parent
local llama = require(parent.llama)
local list = llama.List
local ExpChatShared = require(parent.ExpChatShared)
local initialCommands = require(script.Parent.initialCommands)

local descendants = {}

local function getCommandKeys()
	local descendants2 = TextChatService:GetDescendants()
	local primaryAlias = {}

	for _, descendant in ipairs(descendants2) do
		if not (descendant.ClassName == "TextChatCommand" and string.sub(descendant.PrimaryAlias, 1, 1) == "/") then
			continue
		end

		if descendant.AutocompleteVisible then
			table.insert(primaryAlias, descendant.PrimaryAlias)
		end

		table.insert(descendants, descendant)
	end

	return primaryAlias
end

return function(p)
	local commandKeys = getCommandKeys()
	list.map(commandKeys, function(p2)
		p.trie:insert(p2)
	end)

	for _, v in ExpChatShared.Commands.getVirtualLocalEnabledCommands() do
		for _, alia in v.alias do
			p.trie:insert(alia)
		end
	end

	initialCommands(descendants)
	return p.trie
end
