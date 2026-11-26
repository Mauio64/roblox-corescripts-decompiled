require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Types")
local NodeType = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Enums/NodeType")
local v5 = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Logger"):new("NodeStack")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/Cryo")
local NodeConfig = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/NodeConfig")

local class = {}
class.__index = class

function class.new()
	local object = setmetatable({}, class)
	object.__stack = {}
	object.__index = 1
	return object
end

function class:push(p2)
	if not NodeConfig.getByNode(p2) then
		return {}, false
	end

	local v6 = self:peek()
	local result = {}

	while v6 and not NodeConfig.isDescendant(v6, p2) do
		if not self:__canCloseTop() then
			v5:error("push: Cannot closeAndReduce top node. Last item in stack is not the root node")
			return result, false
		end

		local __closeTopAndReduce = self:__closeTopAndReduce()

		if __closeTopAndReduce then
			v6 = self:peek()
			table.insert(result, __closeTopAndReduce)
		else
			v5:error("push: Failed to closeAndReduce top node")
			return result, false
		end
	end

	if not v6 and p2.type == NodeType.Root then
		self:__push(p2)
		return result, true
	end

	local v7 = v6 and NodeConfig.getByNode(v6)

	if v7 and v7.children[p2.type] then
		self:__push(p2)
		return result, true
	end

	local v8 = NodeConfig.getByNode(p2)
	local defaultParent = v8 and v8.defaultParent

	if not defaultParent then
		v5:error(`push: No default parent found for node type {p2.type}`)
		return result, false
	end

	local v9, v10 = self:pushDefault(defaultParent)
	local joined = Cryo.List.join(result, v9)

	if not v10 then
		return joined, false
	end

	self:__push(p2)
	return joined, true
end

function class:pushDefault(p2)
	local v6 = NodeConfig.getByType(p2)

	if v6 and v6.getDefault then
		return self:push((v6.getDefault()))
	end

	v5:error(`pushDefault: No config or getDefault function found for node type {p2}`)
	return {}, false
end

function class:findAndClose(p2)
	if not self:__has(p2) then
		return {}, false
	end

	local result = {}

	while self:__canCloseTop() do
		local __closeTopAndReduce = self:__closeTopAndReduce()

		if not __closeTopAndReduce then
			v5:error("findAndClose: Failed to closeAndReduce top node")
			return result, false
		end

		table.insert(result, __closeTopAndReduce)

		if __closeTopAndReduce.name == p2 then
			return result, true
		end
	end

	return result, false
end

function class:buildRoot()
	while self:__canCloseTop() do
		if not self:__closeTopAndReduce() then
			v5:error("buildRoot: Failed to closeAndReduce top node")
			break
		end
	end

	if #self.__stack == 0 then
		self:pushDefault(NodeType.Root)
	end

	local v6 = self.__stack[1]

	if v6 and v6.type ~= NodeType.Root then
		v5:error("buildRoot: Last node on stack is not the root node")
	end

	return {
		name = "ROOT",
		text = "",
		type = NodeType.Root,
		children = v6.children,
		attributes = v6.attributes,
		index = v6.index
	}
end

function class:peek()
	return self.__stack[#self.__stack]
end

function class:__push(p2): nil
	local joined = Cryo.Dictionary.join(p2, { index = self.__index })

	table.insert(self.__stack, joined)
	self.__index += 1
	return nil
end

function class:__closeTopAndReduce()
	local v6 = self.__stack[#self.__stack]
	local v7 = self.__stack[#self.__stack - 1]

	if not (v6 and v7) then
		v5:error("closeTop: No top or next node found")
		return nil
	end

	local joined = Cryo.Dictionary.join(v7, {
		children = Cryo.List.join(v7.children, { v6 })
	})

	table.remove(self.__stack, #self.__stack)
	self.__stack[#self.__stack] = joined
	return {
		name = v6.name,
		text = "",
		type = v6.type,
		children = {},
		attributes = v6.attributes,
		index = v6.index
	}
end

function class:__canCloseTop(): boolean
	return #self.__stack > 1
end

function class:__has(p3): boolean
	return Cryo.List.findWhere(self.__stack, function(p4): boolean
		return p4.name == p3
	end) ~= nil
end

return class
