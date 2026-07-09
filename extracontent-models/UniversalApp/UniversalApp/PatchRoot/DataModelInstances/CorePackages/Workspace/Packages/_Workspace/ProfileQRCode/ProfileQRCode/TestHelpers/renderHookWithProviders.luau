local Parent = script:FindFirstAncestor("ProfileQRCode").Parent
local ReactRoblox = require(Parent.Dev.ReactRoblox)
local act = ReactRoblox.act
local createTreeWithProviders = require(script.Parent.createTreeWithProviders)

local function renderHookWithProviders(p1, p2) -- line: 8
	-- upvalues: createTreeWithProviders (copy), ReactRoblox (copy), act (copy)
	local u8 = nil

	local function v9(p3) -- line: 11
		-- upvalues: u8 (ref), p1 (copy)
		u8 = p1(p3)

		return nil
	end
	local function createRootElement(_) -- line: 16
		-- upvalues: createTreeWithProviders (copy), v9 (copy), p2 (copy)
		return (createTreeWithProviders(v9, p2 or {}))
	end

	local Frame = Instance.new("Frame")
	local v12 = ReactRoblox.createRoot(Frame)

	act(function() -- line: 25
		-- upvalues: v12 (copy), createTreeWithProviders (copy), v9 (copy), p2 (copy)
		v12:render((createTreeWithProviders(v9, p2 or {})))
	end)

	return {
		result = u8,
		rerender = function(p5) -- line: 29
			-- upvalues: act (copy), v12 (copy), createTreeWithProviders (copy), v9 (copy), p2 (copy)
			act(function() -- line: 30
				-- upvalues: v12 (copy), p5 (copy), createTreeWithProviders (copy), v9 (copy), p2 (copy)
				local v16 = v12
				local _ = p5

				v16:render((createTreeWithProviders(v9, p2 or {})))
			end)
		end,
		cleanup = function() -- line: 35
			-- upvalues: v12 (copy)
			v12:unmount()
		end
	}
end

return renderHookWithProviders
