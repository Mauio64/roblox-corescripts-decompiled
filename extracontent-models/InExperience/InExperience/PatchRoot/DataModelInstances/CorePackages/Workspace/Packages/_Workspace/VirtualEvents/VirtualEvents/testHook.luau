local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local React = require(VirtualEvents.Parent.React)
local ReactRoblox = require(VirtualEvents.Parent.ReactRoblox)
local withMockProviders = require(VirtualEvents.withMockProviders)

local function testHook(callback)
	local screenGui = Instance.new("ScreenGui")
	local root = ReactRoblox.createRoot(screenGui)

	local function HookTester(): nil
		callback()
		return nil
	end

	local v = withMockProviders({
		HookTester = React.createElement(HookTester)
	})

	ReactRoblox.act(function()
		root:render(v)
	end)
end

return testHook
