local CommonMark = script:FindFirstAncestor("CommonMark")
local Escaping = require(CommonMark.internal.util.Escaping)

local DefinitionMap = {}
DefinitionMap.__index = DefinitionMap

function DefinitionMap.new(p: string)
	return (setmetatable({ _type = p, _keys = {}, _definitions = {} }, DefinitionMap))
end

local function putIfAbsentNormalized(p, p2: string, p3) -- 1 equivalent call inferred from this helper
	local definition = p._definitions[p2]

	if definition ~= nil then
		return definition
	end

	table.insert(p._keys, p2)
	p._definitions[p2] = p3
	return nil
end

function DefinitionMap:getType()
	return self._type
end

function DefinitionMap:addAll(p)
	for _, key in ipairs(p._keys) do
		local definition = p._definitions[key]

		if self._definitions[key] ~= nil then
			continue
		end

		table.insert(self._keys, key)
		self._definitions[key] = definition
	end
end

function DefinitionMap.putIfAbsent(p, p2: string, p3)
	return putIfAbsentNormalized(p, Escaping.normalizeLabelContent(p2), p3) -- inferred equivalent call
end

function DefinitionMap:get(p: string)
	local labelContent = Escaping.normalizeLabelContent(p)
	return self._definitions[labelContent]
end

function DefinitionMap:keySet()
	return table.clone(self._keys)
end

function DefinitionMap:values()
	local result = table.create(#self._keys)

	for i, key in ipairs(self._keys) do
		result[i] = self._definitions[key]
	end

	return result
end

return DefinitionMap
