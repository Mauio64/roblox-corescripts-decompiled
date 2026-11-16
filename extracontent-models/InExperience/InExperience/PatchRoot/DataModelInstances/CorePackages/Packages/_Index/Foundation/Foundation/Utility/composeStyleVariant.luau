local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local Dash = require(parent.Dash)

require(Foundation.Components.Types)

local function tagToTable(value) -- 2 equivalent calls inferred from this helper
	if type(value) == "string" then
		return { [value] = true }
	end

	return value
end

local function mergeTags(tag, tag2)
	if not tag then
		return tag2
	end

	if not tag2 then
		return tag
	end

	if type(tag) ~= "table" and type(tag2) ~= "table" then
		return `{tag} {tag2}`
	end

	local v = tagToTable(tag) -- inferred equivalent call
	local v2 = tagToTable(tag2) -- inferred equivalent call
	return Dash.join(v, v2)
end

local function mergeProps(p, item) -- 1 equivalent call inferred from this helper
	local joined = Dash.join(p, item)
	joined.tag = mergeTags(p.tag, item.tag)
	return joined
end

function composeStyleVariant(p, ...)
	local copy = Dash.copy(p)
	Dash.forEachArgs(function(items)
		if items == nil then
			return
		end

		for k, item in items do
			copy[k] = mergeProps(copy[k] or {}, item) -- inferred equivalent call
		end
	end, ...)
	return copy
end

return composeStyleVariant
