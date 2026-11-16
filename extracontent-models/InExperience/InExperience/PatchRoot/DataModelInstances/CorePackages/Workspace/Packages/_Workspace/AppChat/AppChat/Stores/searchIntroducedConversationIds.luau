local v = {}
local SearchIntroducedConversationIds = {}

function SearchIntroducedConversationIds.add(p: string)
	v[p] = true
end

function SearchIntroducedConversationIds.remove(p: string)
	v[p] = nil
end

function SearchIntroducedConversationIds.has(p: string): boolean
	return v[p] == true
end

function SearchIntroducedConversationIds.clear()
	v = {}
end

return SearchIntroducedConversationIds
