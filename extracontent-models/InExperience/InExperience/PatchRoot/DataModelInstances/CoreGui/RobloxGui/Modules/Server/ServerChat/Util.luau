local ClientChatModules = game:GetService("Chat"):WaitForChild("ClientChatModules")
local StandardPriority = require(ClientChatModules:WaitForChild("ChatConstants")).StandardPriority

if StandardPriority == nil then
	StandardPriority = 10
end

local t1 = {}

t1.__index = t1

local t2 = {}
local t3 = {}

t3.__index = t3

function t3.RebuildProcessCommandsPriorities(p1) -- line: 25
	p1.RegisteredPriorites = {}

	for k, v in pairs(p1.FunctionMap) do
		local v9 = true

		for _, _ in pairs(v) do
			v9 = false

			break
		end

		if not v9 then
			table.insert(p1.RegisteredPriorites, k)
		end
	end

	table.sort(p1.RegisteredPriorites, function(p2, p3) -- line: 37
		return p3 < p2
	end)
end
function t3.HasFunction(p4, p5) -- line: 42
	if p4.RegisteredFunctions[p5] == nil then
		return false
	end

	return true
end
function t3.RemoveFunction(p6, p7) -- line: 49
	local v16 = p6.RegisteredFunctions[p7]

	p6.RegisteredFunctions[p7] = nil
	p6.FunctionMap[v16][p7] = nil
	p6:RebuildProcessCommandsPriorities()
end
function t3.AddFunction(p8, p9, p10, p11) -- line: 56
	-- upvalues: StandardPriority (ref)
	if p11 == nil then
		p11 = StandardPriority
	end

	if p8.RegisteredFunctions[p9] then
		error(p9 .. " is already in use!")
	end

	p8.RegisteredFunctions[p9] = p11

	if p8.FunctionMap[p11] == nil then
		p8.FunctionMap[p11] = {}
	end

	p8.FunctionMap[p11][p9] = p10
	p8:RebuildProcessCommandsPriorities()
end
function t3.GetIterator(p12) -- line: 75
	local n1 = 1
	local u23 = nil
	local u24 = nil

	return function() -- line: 80
		-- upvalues: n1 (ref), p12 (copy), u23 (ref), u24 (ref)
		while not (n1 > #p12.RegisteredPriorites) do
			local v29 = p12.RegisteredPriorites[n1]
			local v30, v31 = next(p12.FunctionMap[v29], u23)

			u23 = v30
			u24 = v31

			if u23 ~= nil then
				return u23, u24, v29
			end

			n1 += 1
		end
	end
end
function t2.new() -- line: 96
	-- upvalues: t3 (copy)
	local self = setmetatable({}, t3)

	self.RegisteredFunctions = {}
	self.RegisteredPriorites = {}
	self.FunctionMap = {}

	return self
end
function t1.NewSortedFunctionContainer(_) -- line: 107
	-- upvalues: t2 (copy)
	return t2.new()
end

return t1
