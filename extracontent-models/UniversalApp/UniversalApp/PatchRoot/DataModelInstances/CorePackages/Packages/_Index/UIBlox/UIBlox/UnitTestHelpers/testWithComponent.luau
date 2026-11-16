local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local parent = script.Parent
local parent2 = parent.Parent.Parent

local Foundation = require(parent2.Foundation)
local FoundationProvider = Foundation.FoundationProvider

local Roact = require(parent2.Roact)

local dumpInstanceTree = require(parent.dumpInstanceTree)

local function TestApp(props)
	return Roact.createElement("ScreenGui", { ZIndexBehavior = Enum.ZIndexBehavior.Sibling }, props[Roact.Children])
end

local function testWithComponent(testComponent, callback)
	local element = Roact.createElement(TestApp, nil, {
		FoundationProvider = Roact.createElement(FoundationProvider, { theme = "Dark" }, {
			TestComponent = testComponent
		})
	})

	local formatted = ("TestApp-%s"):format(HttpService:GenerateGUID(false))
	local v = Roact.mount(element, CoreGui, formatted)
	local formatted2 = ("game.CoreGui.%s.TestComponent"):format(formatted)

	local success, result = pcall(function()
		callback(formatted2)
	end)

	if not success then
		print("Test instance tree:")
		dumpInstanceTree(CoreGui:FindFirstChild(formatted))
		print("Test instance tree end\n")
	end

	Roact.unmount(v)

	if not success then
		error(result)
	end
end

return testWithComponent
