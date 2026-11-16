local parent = script:FindFirstAncestor("ExpChat").Parent
local ExpChatShared = require(parent.ExpChatShared)

game:DefineFastFlag("ExpChatGlobalCommandAutocompletePrimaryAliasOnly", false)

return function(p)
	for _, v in ExpChatShared.GlobalCommands.getGlobalEnabledCommands() do
		if game:GetFastFlag("ExpChatGlobalCommandAutocompletePrimaryAliasOnly") then
			p.trie:insert(v.alias[1])
		else
			for _, alia in v.alias do
				p.trie:insert(alia)
			end
		end
	end

	return p.trie
end
