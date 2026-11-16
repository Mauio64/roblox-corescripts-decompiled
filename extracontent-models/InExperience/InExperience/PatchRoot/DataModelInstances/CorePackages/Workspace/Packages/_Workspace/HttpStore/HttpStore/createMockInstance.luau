local parent = script.Parent.Parent
local InternalHttpStore = require(parent.InternalHttpStore)
local createMockHttpStore = InternalHttpStore.createMockHttpStore

local function createMockInstance()
	local mockHttpStore = createMockHttpStore()

	return {
		get = function()
			return mockHttpStore
		end,
		_create = function()
			return mockHttpStore
		end,
		_dispose = function()
			mockHttpStore.reset()
		end,
		setResponse = mockHttpStore.setResponse,
		reset = mockHttpStore.reset,
		mockStore = mockHttpStore
	}
end

return createMockInstance
