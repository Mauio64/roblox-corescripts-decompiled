local ParentParent = script.Parent.Parent
local createMockHttpStore = require(ParentParent.InternalHttpStore).createMockHttpStore

local function createMockInstance() -- line: 67
	-- upvalues: createMockHttpStore (copy)
	local v4 = createMockHttpStore()

	return {
		get = function() -- line: 72
			-- upvalues: v4 (copy)
			return v4
		end,
		_create = function() -- line: 75
			-- upvalues: v4 (copy)
			return v4
		end,
		_dispose = function() -- line: 78
			-- upvalues: v4 (copy)
			v4.reset()
		end,
		setResponse = v4.setResponse,
		reset = v4.reset,
		mockStore = v4
	}
end

return createMockInstance
