local ParentParent = script.Parent.Parent
local ReactRoblox = require(ParentParent.Dev.ReactRoblox)
local act = ReactRoblox.act
local createTreeWithProviders = require(script.Parent.createTreeWithProviders)

local function renderHookWithProviders(p1: ((...any) -> ...any), p2) -- line: 12
	-- upvalues: createTreeWithProviders (copy), ReactRoblox (copy), act (copy)
	local u8 = nil
	local u9 = nil

	local function v10(p3) -- line: 16
		-- upvalues: u8 (ref), p1 (copy)
		u8 = p1(p3)

		return nil
	end
	local function createRootElement(p4) -- line: 21
		-- upvalues: createTreeWithProviders (copy), v10 (copy)
		return (createTreeWithProviders(v10, p4))
	end

	local Frame = Instance.new("Frame")
	local v13 = ReactRoblox.createRoot(Frame)

	act(function() -- line: 30
		-- upvalues: v13 (copy), p2 (copy), createTreeWithProviders (copy), v10 (copy)
		local v18 = v13
		local v19 = p2

		v18:render((createTreeWithProviders(v10, v19)))
	end)

	local function rerender(p5) -- line: 34
		-- upvalues: act (copy), v13 (copy), p2 (copy), createTreeWithProviders (copy), v10 (copy), u9 (ref)
		act(function() -- line: 35
			-- upvalues: v13 (copy), p5 (copy), p2 (copy), createTreeWithProviders (copy), v10 (copy)
			local v21 = v13
			local v22 = p5 or p2

			v21:render((createTreeWithProviders(v10, v22)))
		end)

		return u9()
	end
	local function cleanup() -- line: 42
		-- upvalues: v13 (copy)
		v13:unmount()
	end

	function u9() -- line: 46
		-- upvalues: u8 (ref), rerender (copy), cleanup (copy)
		return {
			result = u8,
			rerender = rerender,
			cleanup = cleanup
		}
	end

	return u9()
end

return renderHookWithProviders
