local Parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent
local React = require(Parent.React)
local ReactRoblox = require(Parent.Dev.ReactRoblox)
local Rodux = require(Parent.Rodux)
local act = ReactRoblox.act
local makeTestRoot = require(script.Parent.makeTestRoot)

local function renderHookWithProviders(p1: ((...any) -> ...any), t1: {[any]: any}?, p2) -- line: 15
	-- upvalues: React (copy), makeTestRoot (copy), Rodux (copy), ReactRoblox (copy), act (copy)
	local u11 = nil

	local function v12() -- line: 18
		-- upvalues: u11 (ref), p1 (copy), t1 (copy), React (copy)
		u11 = p1(t1)

		return React.createElement("Frame")
	end
	local function createRootElement() -- line: 23
		-- upvalues: makeTestRoot (copy), p2 (copy), Rodux (copy), React (copy), v12 (copy)
		local v16 = makeTestRoot({
			store = p2 or Rodux.Store.new(Rodux.createReducer({}, {}))
		})

		return React.createElement(v16, {
			children = React.createElement(v12, {})
		})
	end

	local Frame = Instance.new("Frame")
	local v15 = ReactRoblox.createRoot(Frame)

	act(function() -- line: 35
		-- upvalues: v15 (copy), createRootElement (copy)
		v15:render(createRootElement())
	end)

	return {
		getResult = function() -- line: 45
			-- upvalues: u11 (ref)
			return u11
		end,
		cleanup = function() -- line: 39
			-- upvalues: v15 (copy)
			v15:unmount()
		end
	}
end

return renderHookWithProviders
