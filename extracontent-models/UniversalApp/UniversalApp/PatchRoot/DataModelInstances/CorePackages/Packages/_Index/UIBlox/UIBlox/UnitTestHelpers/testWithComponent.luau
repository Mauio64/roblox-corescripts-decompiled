local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local FoundationProvider = require(ParentParent.Foundation).FoundationProvider
local Roact = require(ParentParent.Roact)
local dumpInstanceTree = require(scriptParent.dumpInstanceTree)

local function TestApp(p1) -- line: 34
	-- upvalues: Roact (copy)
	return Roact.createElement("ScreenGui", {
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, p1[Roact.Children])
end
local function testWithComponent(p2, p3) -- line: 40
	-- upvalues: Roact (copy), TestApp (copy), FoundationProvider (copy), HttpService (copy), CoreGui (copy), dumpInstanceTree (copy)
	local v13 = Roact.createElement(TestApp, nil, {
		FoundationProvider = Roact.createElement(FoundationProvider, {
			theme = "Dark"
		}, {
			TestComponent = p2
		})
	})
	local v14 = ("TestApp-%s"):format(HttpService:GenerateGUID(false))
	local v15 = Roact.mount(v13, CoreGui, v14)
	local v16 = ("game.CoreGui.%s.TestComponent"):format(v14)
	local ok, result = pcall(function() -- line: 51
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

return testWithComponent
