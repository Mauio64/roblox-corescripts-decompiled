local parent = script:FindFirstAncestor("InExperienceShop").Parent

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider

local function renderHookWithProviders(callback)
	local v = {}
	local screenGui = Instance.new("ScreenGui")
	local root = ReactRoblox.createRoot(screenGui)

	local function TestHarness(): nil
		v.current = callback()
		return nil
	end

	ReactRoblox.act(function()
		root:render(React.createElement(FoundationProvider, { colorMode = "Dark" }, React.createElement(TestHarness)))
	end)

	local function cleanup()
		ReactRoblox.act(function()
			root:unmount()
		end)
		screenGui:Destroy()
	end

	return v, cleanup
end

return renderHookWithProviders
