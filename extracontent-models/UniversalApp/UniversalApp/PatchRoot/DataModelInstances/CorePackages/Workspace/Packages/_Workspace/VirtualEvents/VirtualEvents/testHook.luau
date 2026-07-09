local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local React = require(VirtualEvents.Parent.React)
local ReactRoblox = require(VirtualEvents.Parent.ReactRoblox)
local withMockProviders = require(VirtualEvents.withMockProviders)

local function testHook(p1: ((...any) -> ...any)) -- line: 7
	-- upvalues: ReactRoblox (copy), withMockProviders (copy), React (copy)
	local ScreenGui = Instance.new("ScreenGui")
	local v8 = ReactRoblox.createRoot(ScreenGui)

	local function HookTester() -- line: 11
		-- upvalues: p1 (copy)
		p1()

		return nil
	end

	local v10 = withMockProviders({
		HookTester = React.createElement(HookTester)
	})

	ReactRoblox.act(function() -- line: 20
		-- upvalues: v8 (copy), v10 (copy)
		v8:render(v10)
	end)
end

return testHook
