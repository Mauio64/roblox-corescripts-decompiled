local ContactImporter = script:FindFirstAncestor("ContactImporter")
local devDependencies = require(ContactImporter.devDependencies)
local ReactRoblox = require(ContactImporter.dependencies).ReactRoblox
local act = ReactRoblox.act
local createTreeWithProviders = devDependencies.createTreeWithProviders

local function renderHookWithProviders(p1, p2) -- line: 13
	-- upvalues: createTreeWithProviders (copy), ReactRoblox (copy), act (copy)
	local u9 = nil

	local function v10(p3) -- line: 16
		-- upvalues: u9 (ref), p1 (copy)
		u9 = p1(p3)

		return nil
	end
	local function createRootElement(_) -- line: 21
		-- upvalues: createTreeWithProviders (copy), v10 (copy), p2 (copy)
		return (createTreeWithProviders(v10, p2 or {}))
	end

	local Frame = Instance.new("Frame")
	local v13 = ReactRoblox.createRoot(Frame)

	act(function() -- line: 30
		-- upvalues: v13 (copy), createTreeWithProviders (copy), v10 (copy), p2 (copy)
		v13:render((createTreeWithProviders(v10, p2 or {})))
	end)

	return {
		result = u9,
		rerender = function(p5) -- line: 34
			-- upvalues: act (copy), v13 (copy), createTreeWithProviders (copy), v10 (copy), p2 (copy)
			act(function() -- line: 35
				-- upvalues: v13 (copy), p5 (copy), createTreeWithProviders (copy), v10 (copy), p2 (copy)
				local v17 = v13
				local _ = p5

				v17:render((createTreeWithProviders(v10, p2 or {})))
			end)
		end,
		cleanup = function() -- line: 40
			-- upvalues: v13 (copy)
			v13:unmount()
		end
	}
end

return renderHookWithProviders
