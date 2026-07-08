local ParentParent = script.Parent.Parent
local createComputed = require(ParentParent.Signals).createComputed

local function createReducer(p1: ((...any) -> ...any), p2) -- line: 8
	-- upvalues: createComputed (copy)
	local u6 = false
	local u7 = nil

	local function ensureInitialized() -- line: 12
		-- upvalues: u6 (ref), u7 (ref), p2 (copy)
		if not u6 then
			u6 = true
			u7 = if typeof(p2) ~= "function" then p2 else p2()
		end
	end

	return createComputed(function(p3) -- line: 19
		-- upvalues: u6 (ref), u7 (ref), p2 (copy), p1 (copy)
		if not u6 then
			u6 = true
			u7 = if typeof(p2) ~= "function" then p2 else p2()
		end

		u7 = p1(p3, u7)

		return u7
	end)
end

return createReducer
