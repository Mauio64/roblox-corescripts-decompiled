local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local dumpInstanceTree = require(parent.dumpInstanceTree)

local mockStyleComponent = require(parent2.Utility.mockStyleComponent)

local function testWithStyledComponent(p, p2, callback)
	local element = Roact.createElement("ScreenGui", {
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		StyleProvider = mockStyleComponent({ TestComponent = Roact.createElement(p, p2) })
	})

	local formatted = ("TestApp-%s"):format(HttpService:GenerateGUID())
	local v = Roact.mount(element, CoreGui, formatted)
	local formatted2 = ("game.CoreGui.%s.Children.TestComponent"):format(formatted)

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

return testWithStyledComponent
