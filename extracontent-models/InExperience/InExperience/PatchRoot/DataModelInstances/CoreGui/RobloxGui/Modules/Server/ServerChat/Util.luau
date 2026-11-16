local Chat = game:GetService("Chat")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local ChatConstants = require(ClientChatModules:WaitForChild("ChatConstants"))

local StandardPriority = ChatConstants.StandardPriority
local v = StandardPriority == nil and 10 or StandardPriority

local Util = {}
Util.__index = Util

local v2 = {}

local class = {}
class.__index = class

function class:RebuildProcessCommandsPriorities()
	self.RegisteredPriorites = {}

	for k, v3 in pairs(self.FunctionMap) do
		local v4 = true

		for _, _ in pairs(v3) do
			v4 = false
			break
		end

		if not v4 then
			table.insert(self.RegisteredPriorites, k)
		end
	end

	table.sort(self.RegisteredPriorites, function(a, b): boolean
		return b < a
	end)
end

function class.HasFunction(p, p2): boolean
	return p.RegisteredFunctions[p2] ~= nil
end

function class:RemoveFunction(p)
	local registeredFunction = self.RegisteredFunctions[p]
	self.RegisteredFunctions[p] = nil
	self.FunctionMap[registeredFunction][p] = nil
	self:RebuildProcessCommandsPriorities()
end

function class:AddFunction(p, p2, p3)
	if p3 == nil then
		p3 = v
	end

	if self.RegisteredFunctions[p] then
		error(p .. " is already in use!")
	end

	self.RegisteredFunctions[p] = p3

	if self.FunctionMap[p3] == nil then
		self.FunctionMap[p3] = {}
	end

	self.FunctionMap[p3][p] = p2
	self:RebuildProcessCommandsPriorities()
end

function class.GetIterator(p)
	local v3 = 1
	local v4 = nil
	local v5 = nil

	return function()
		while not (v3 > #p.RegisteredPriorites) do
			local registeredPriorite = p.RegisteredPriorites[v3]
			v4, v5 = next(p.FunctionMap[registeredPriorite], v4)

			if v4 ~= nil then
				return v4, v5, registeredPriorite
			end

			v3 += 1
		end
	end
end

function v2.new()
	local self = setmetatable({}, class)

	self.RegisteredFunctions = {}
	self.RegisteredPriorites = {}
	self.FunctionMap = {}

	return self
end

function Util.NewSortedFunctionContainer(_)
	return v2.new()
end

return Util
