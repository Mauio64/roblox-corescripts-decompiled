local parent = script:FindFirstAncestor("DataHydration").Parent

require(parent.MomentsTypes)
local isCanonicalNonzeroUuid = require(script.Parent.isCanonicalNonzeroUuid)

local function normalizeName(value: string) -- 5 equivalent calls inferred from this helper
	local v = string.gsub(string.lower(value), "%-", "")
	return if v == "crying" then "cry" else v
end

local ResolveEmoteId = {}

function ResolveEmoteId.resolveEmoteIdForReaction(items, value)
	local name = normalizeName(value) -- inferred equivalent call

	for _, item in items do
		if not (item.id ~= value and normalizeName(item.name) ~= name) then -- inferred equivalent call
			return item.id
		end
	end

	return value
end

function ResolveEmoteId.resolveOptionalEmoteIdForReaction(items, value)
	local name = normalizeName(value) -- inferred equivalent call

	for _, item in items do
		if normalizeName(item.name) == name and isCanonicalNonzeroUuid(item.id) then -- inferred equivalent call
			return item.id
		end
	end

	return nil
end

function ResolveEmoteId.reactionTypeForEmoteId(items, p: string)
	for _, item in items do
		if item.id == p then
			return normalizeName(item.name) -- inferred equivalent call
		end
	end

	return p
end

ResolveEmoteId.normalizeName = normalizeName
return ResolveEmoteId
