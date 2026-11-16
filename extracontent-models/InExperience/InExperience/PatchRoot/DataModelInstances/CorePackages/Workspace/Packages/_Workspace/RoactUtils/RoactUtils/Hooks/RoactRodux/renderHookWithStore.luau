local parent = script:FindFirstAncestor("RoactUtils").Parent
local RoactRodux = require(parent.RoactRodux)
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local act = ReactRoblox.act

local function renderHookWithStore(store, callback, options)
	local v = {}

	local function fn(p): nil
		v.current = callback(p)
		return nil
	end

	local function createRootElement(p)
		local rootElement = React.createElement(fn, p)

		if store ~= nil then
			rootElement = React.createElement(RoactRodux.StoreProvider, { store = store }, {
				Wrapper = rootElement
			})
		end

		return rootElement
	end

	local frame = Instance.new("Frame")
	local root = ReactRoblox.createRoot(frame)

	act(function()
		root:render(createRootElement(options or {}))
	end)

	return {
		result = v,
		rerender = function(p)
			act(function()
				root:render(createRootElement(p))
			end)
		end,
		cleanup = function()
			root:unmount()
		end
	}
end

return renderHookWithStore
