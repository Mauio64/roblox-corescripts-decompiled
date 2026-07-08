local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local Roact = require(scriptParentParentParent.Roact)
local dumpInstanceTree = require(scriptParent.dumpInstanceTree)
local mockStyleComponent = require(scriptParentParent.Utility.mockStyleComponent)

local function testWithStyledComponent(p1, p2, p3) -- line: 33
	-- upvalues: Roact (copy), mockStyleComponent (copy), HttpService (copy), CoreGui (copy), dumpInstanceTree (copy)
	local v13 = Roact.createElement("ScreenGui", {
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		StyleProvider = mockStyleComponent({
			TestComponent = Roact.createElement(p1, p2)
		})
	})
	local v14 = ("TestApp-%s"):format(HttpService:GenerateGUID())
	local v15 = Roact.mount(v13, CoreGui, v14)
	local v16 = ("game.CoreGui.%s.Children.TestComponent"):format(v14)
	local ok, result = pcall(function() -- line: 46
		-- upvalues: p3 (copy), v16 (copy)
		p3(v16)
	end)

	if not ok then
		print("Test instance tree:")
		dumpInstanceTree(CoreGui:FindFirstChild(v14))
		print("Test instance tree end\n")
	end

	Roact.unmount(v15)

	if not ok then
		error(result)
	end
end

return testWithStyledComponent
