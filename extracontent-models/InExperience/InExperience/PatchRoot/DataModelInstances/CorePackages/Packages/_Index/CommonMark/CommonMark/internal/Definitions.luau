local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.node.DefinitionMap)

local Definitions = {}
Definitions.__index = Definitions

function Definitions.new()
	return (setmetatable({ _definitionsByType = {} }, Definitions))
end

function Definitions:addDefinitions(object)
	local map = self:getMap(object:getType())

	if map == nil then
		self._definitionsByType[object:getType()] = object
	else
		map:addAll(object)
	end
end

function Definitions:getDefinition(p: string, p2: string)
	local map = self:getMap(p)

	if map == nil then
		return nil
	end

	return map:get(p2)
end

function Definitions:getMap(p: string)
	return self._definitionsByType[p]
end

return Definitions
