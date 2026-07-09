local Parent = script:FindFirstAncestor("ExpChat").Parent
local ExpChatShared = require(Parent.ExpChatShared)

game:DefineFastFlag("ExpChatGlobalCommandAutocompletePrimaryAliasOnly", false)

return function(p1) -- line: 7
	-- upvalues: ExpChatShared (copy)
	for _, v5 in ExpChatShared.GlobalCommands.getGlobalEnabledCommands() do
		if game:GetFastFlag("ExpChatGlobalCommandAutocompletePrimaryAliasOnly") then
			p1.trie:insert(v5.alias[1])
		else
			for _, v7 in v5.alias do
				p1.trie:insert(v7)
			end
		end
	end

	return p1.trie
end
