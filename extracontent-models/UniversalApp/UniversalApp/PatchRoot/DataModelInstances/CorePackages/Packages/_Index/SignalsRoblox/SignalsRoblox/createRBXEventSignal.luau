local ParentParent = script.Parent.Parent
local createSignal = require(ParentParent.Signals).createSignal

local function defaultFilter(...) -- line: 10
	return select(1, ...)
end
local function createRBXEventSignal(p1, p2, p3: ((...any) -> ...any)?) -- line: 14
	-- upvalues: createSignal (copy), defaultFilter (copy)
	local v8, v9 = createSignal(p2)
	local v10 = if p3 == nil then defaultFilter else p3

	return v8, (p1:Connect(function(...) -- line: 23
		-- upvalues: v9 (copy), v10 (copy)
		v9(v10(...))
	end))
end

return createRBXEventSignal
