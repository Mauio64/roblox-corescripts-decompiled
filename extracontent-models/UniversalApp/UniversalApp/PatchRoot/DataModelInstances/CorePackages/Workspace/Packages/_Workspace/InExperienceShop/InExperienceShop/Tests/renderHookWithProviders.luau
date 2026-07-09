local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local React = require(Parent.React)
local ReactRoblox = require(Parent.ReactRoblox)
local FoundationProvider = require(Parent.Foundation).FoundationProvider

local function renderHookWithProviders(p1: ((...any) -> ...any)) -- line: 19
	-- upvalues: ReactRoblox (copy), React (copy), FoundationProvider (copy)
	local t1 = {}
	local ScreenGui = Instance.new("ScreenGui")
	local v9 = ReactRoblox.createRoot(ScreenGui)

	local function TestHarness() -- line: 24
		-- upvalues: t1 (copy), p1 (copy)
		t1.current = p1()

		return nil
	end

	ReactRoblox.act(function() -- line: 29
		-- upvalues: v9 (copy), React (copy), FoundationProvider (copy), TestHarness (copy)
		v9:render(React.createElement(FoundationProvider, {
			theme = "Dark"
		}, React.createElement(TestHarness)))
	end)

	local function cleanup() -- line: 35
		-- upvalues: ReactRoblox (copy), v9 (copy), ScreenGui (copy)
		ReactRoblox.act(function() -- line: 36
			-- upvalues: v9 (copy)
			v9:unmount()
		end)
		ScreenGui:Destroy()
	end

	return t1, cleanup
end

return renderHookWithProviders
