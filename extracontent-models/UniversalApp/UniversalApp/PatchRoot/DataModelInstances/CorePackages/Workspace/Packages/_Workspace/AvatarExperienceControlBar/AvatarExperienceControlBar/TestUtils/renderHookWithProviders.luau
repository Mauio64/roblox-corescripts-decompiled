local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")
local AvatarExperienceControlBarParent = AvatarExperienceControlBar.Parent
local React = require(AvatarExperienceControlBarParent.React)
local ReactRoblox = require(AvatarExperienceControlBarParent.Dev.ReactRoblox)
local Rodux = require(AvatarExperienceControlBarParent.Rodux)
local act = ReactRoblox.act
local makeTestRoot = require(AvatarExperienceControlBar.TestUtils.makeTestRoot)

local function renderHookWithProviders(p1: ((...any) -> ...any), t1: {[any]: any}?, p2) -- line: 15
	-- upvalues: makeTestRoot (copy), Rodux (copy), React (copy), ReactRoblox (copy), act (copy)
	local u12 = nil

	local function v13() -- line: 18
		-- upvalues: u12 (ref), p1 (copy), t1 (copy)
		u12 = p1(t1)

		return nil
	end
	local function createRootElement() -- line: 23
		-- upvalues: makeTestRoot (copy), Rodux (copy), p2 (copy), React (copy), v13 (copy)
		local v17 = makeTestRoot({
			store = Rodux.Store.new(Rodux.createReducer(p2 or {}, {}))
		})

		return React.createElement(v17, {}, React.createElement(v13, {}))
	end

	local Frame = Instance.new("Frame")
	local v16 = ReactRoblox.createRoot(Frame)

	act(function() -- line: 33
		-- upvalues: v16 (copy), createRootElement (copy)
		v16:render(createRootElement())
	end)

	return {
		getResult = function() -- line: 43
			-- upvalues: u12 (ref)
			return u12
		end,
		cleanup = function() -- line: 37
			-- upvalues: v16 (copy)
			v16:unmount()
		end
	}
end

return renderHookWithProviders
