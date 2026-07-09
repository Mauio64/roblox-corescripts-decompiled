local Parent = script:FindFirstAncestor("RoactUtils").Parent
local RoactRodux = require(Parent.RoactRodux)
local React = require(Parent.React)
local ReactRoblox = require(Parent.ReactRoblox)
local act = ReactRoblox.act

local function renderHookWithStore(p1, p2: ((...any) -> ...any), p3) -- line: 12
	-- upvalues: React (copy), RoactRodux (copy), ReactRoblox (copy), act (copy)
	local t1 = {}

	local function v11(p4) -- line: 15
		-- upvalues: t1 (copy), p2 (copy)
		t1.current = p2(p4)

		return nil
	end
	local function createRootElement(p5) -- line: 20
		-- upvalues: React (copy), v11 (copy), p1 (copy), RoactRodux (copy)
		local v17 = React.createElement(v11, p5)

		if p1 ~= nil then
			v17 = React.createElement(RoactRodux.StoreProvider, {
				store = p1
			}, {
				Wrapper = v17
			})
		end

		return v17
	end

	local Frame = Instance.new("Frame")
	local v14 = ReactRoblox.createRoot(Frame)

	act(function() -- line: 35
		-- upvalues: v14 (copy), createRootElement (copy), p3 (copy)
		v14:render((createRootElement(p3 or {})))
	end)

	return {
		result = t1,
		rerender = function(p6) -- line: 39
			-- upvalues: act (copy), v14 (copy), createRootElement (copy)
			act(function() -- line: 40
				-- upvalues: v14 (copy), createRootElement (copy), p6 (copy)
				v14:render((createRootElement(p6)))
			end)
		end,
		cleanup = function() -- line: 45
			-- upvalues: v14 (copy)
			v14:unmount()
		end
	}
end

return renderHookWithStore
