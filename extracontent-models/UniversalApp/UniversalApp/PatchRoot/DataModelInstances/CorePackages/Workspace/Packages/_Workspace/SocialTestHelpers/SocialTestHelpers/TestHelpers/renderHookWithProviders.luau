local SocialTestHelpers = script:FindFirstAncestor("SocialTestHelpers")
local dependencies = require(SocialTestHelpers.dependencies)
local ReactRoblox = dependencies.ReactRoblox
local act = ReactRoblox.act
local Dash = dependencies.Dash
local createTreeWithProviders = require(script.Parent.createTreeWithProviders)

local function renderHookWithProviders(p1, p2) -- line: 48
	-- upvalues: Dash (copy), createTreeWithProviders (copy), ReactRoblox (copy), act (copy)
	local t1 = nil

	local function v11(p3) -- line: 51
		-- upvalues: t1 (ref), p1 (copy)
		t1 = { p1(p3) }

		return nil
	end
	local function createRootElement(p4, p5) -- line: 56
		-- upvalues: Dash (copy), p2 (copy), createTreeWithProviders (copy), v11 (copy)
		local v18 = Dash.join(p2 or {}, p5 or {})

		v18.props = Dash.join(v18.props or {}, p4 or {})

		return (createTreeWithProviders(v11, v18))
	end

	local Frame = Instance.new("Frame")
	local v14 = ReactRoblox.createRoot(Frame)

	act(function() -- line: 68
		-- upvalues: v14 (copy), createRootElement (copy)
		v14:render((createRootElement({})))
	end)

	return {
		result = if not t1 then nil else t1[1],
		getResult = function() -- line: 85
			-- upvalues: t1 (ref)
			if t1 then
				return t1[1]
			end

			return nil
		end,
		getResults = function() -- line: 88
			-- upvalues: t1 (ref)
			return unpack(t1)
		end,
		rerender = function(p6, p7) -- line: 72
			-- upvalues: act (copy), v14 (copy), createRootElement (copy)
			act(function() -- line: 73
				-- upvalues: v14 (copy), createRootElement (copy), p6 (copy), p7 (copy)
				v14:render((createRootElement(p6, p7)))
			end)
		end,
		cleanup = function() -- line: 78
			-- upvalues: v14 (copy)
			v14:unmount()
		end
	}
end

return renderHookWithProviders
