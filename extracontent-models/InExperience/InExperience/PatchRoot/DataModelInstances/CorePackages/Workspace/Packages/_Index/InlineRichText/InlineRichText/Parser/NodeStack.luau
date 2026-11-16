local InlineRichText = script:FindFirstAncestor("InlineRichText")
local parent = InlineRichText.Parent

require(InlineRichText.Types)
local NodeType = require(InlineRichText.Enums.NodeType)
local Logger = require(InlineRichText.Logger)
local v = Logger:new(script.Name)
local Cryo = require(parent.Cryo)
local NodeConfig = require(InlineRichText.NodeConfig)

local NodeStack = {}
NodeStack.__index = NodeStack

function NodeStack.new()
	local self = setmetatable({}, NodeStack)
	self.__stack = {}
	self.__index = 1
	return self
end

function NodeStack:push(p)
	if not NodeConfig.getByNode(p) then
		return {}, false
	end

	local v2 = self:peek()
	local result = {}

	while v2 and not NodeConfig.isDescendant(v2, p) do
		if not self:__canCloseTop() then
			v:error("push: Cannot closeAndReduce top node. Last item in stack is not the root node")
			return result, false
		end

		local __closeTopAndReduce = self:__closeTopAndReduce()

		if __closeTopAndReduce then
			v2 = self:peek()
			table.insert(result, __closeTopAndReduce)
		else
			v:error("push: Failed to closeAndReduce top node")
			return result, false
		end
	end

	if not v2 and p.type == NodeType.Root then
		self:__push(p)
		return result, true
	end

	local v3 = v2 and NodeConfig.getByNode(v2)

	if v3 and v3.children[p.type] then
		self:__push(p)
		return result, true
	end

	local v4 = NodeConfig.getByNode(p)
	local defaultParent = v4 and v4.defaultParent

	if not defaultParent then
		v:error(`push: No default parent found for node type {p.type}`)
		return result, false
	end

	local v5, v6 = self:pushDefault(defaultParent)
	local joined = Cryo.List.join(result, v5)

	if not v6 then
		return joined, false
	end

	self:__push(p)
	return joined, true
end

function NodeStack:pushDefault(p)
	local v2 = NodeConfig.getByType(p)

	if v2 and v2.getDefault then
		return self:push((v2.getDefault()))
	end

	v:error(`pushDefault: No config or getDefault function found for node type {p}`)
	return {}, false
end

function NodeStack:findAndClose(p: string)
	if not self:__has(p) then
		return {}, false
	end

	local result = {}

	while self:__canCloseTop() do
		local __closeTopAndReduce = self:__closeTopAndReduce()

		if not __closeTopAndReduce then
			v:error("findAndClose: Failed to closeAndReduce top node")
			return result, false
		end

		table.insert(result, __closeTopAndReduce)

		if __closeTopAndReduce.name == p then
			return result, true
		end
	end

	return result, false
end

function NodeStack:buildRoot()
	while self:__canCloseTop() do
		if not self:__closeTopAndReduce() then
			v:error("buildRoot: Failed to closeAndReduce top node")
			break
		end
	end

	if #self.__stack == 0 then
		self:pushDefault(NodeType.Root)
	end

	local v2 = self.__stack[1]

	if v2 and v2.type ~= NodeType.Root then
		v:error("buildRoot: Last node on stack is not the root node")
	end

	return {
		name = "ROOT",
		text = "",
		type = NodeType.Root,
		children = v2.children,
		attributes = v2.attributes,
		index = v2.index
	}
end

function NodeStack:peek()
	return self.__stack[#self.__stack]
end

function NodeStack:__push(p): nil
	local joined = Cryo.Dictionary.join(p, { index = self.__index })

	table.insert(self.__stack, joined)
	self.__index += 1
	return nil
end

function NodeStack:__closeTopAndReduce()
	local v2 = self.__stack[#self.__stack]
	local v3 = self.__stack[#self.__stack - 1]

	if not (v2 and v3) then
		v:error("closeTop: No top or next node found")
		return nil
	end

	local joined = Cryo.Dictionary.join(v3, {
		children = Cryo.List.join(v3.children, { v2 })
	})

	table.remove(self.__stack, #self.__stack)
	self.__stack[#self.__stack] = joined
	return {
		name = v2.name,
		text = "",
		type = v2.type,
		children = {},
		attributes = v2.attributes,
		index = v2.index
	}
end

function NodeStack:__canCloseTop(): boolean
	return #self.__stack > 1
end

function NodeStack:__has(p: string): boolean
	return Cryo.List.findWhere(self.__stack, function(p2): boolean
		return p2.name == p
	end) ~= nil
end

return NodeStack
