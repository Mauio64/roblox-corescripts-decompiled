local SocialTestHelpers = script:FindFirstAncestor("SocialTestHelpers")
local SocialTestHelpersParent = SocialTestHelpers.Parent
local dependencies = require(SocialTestHelpers.dependencies)
local dumpInstanceTree = require(script.Parent.dumpInstanceTree)
local Dash = require(SocialTestHelpersParent.Dash)
local Roact = dependencies.Roact

local function runWhileMounted(p1, p2: ((...any) -> ...any), t1: {[any]: any}?) -- line: 22
	-- upvalues: Roact (copy), Dash (copy), dumpInstanceTree (copy)
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = game:GetService("CoreGui")

	local v12 = Roact.mount(p1, ScreenGui)

	if t1 and t1.shouldPrintFailedTree then
		local ok, result = pcall(function() -- line: 29
			-- upvalues: p2 (copy), ScreenGui (copy)
			p2(ScreenGui)

			return "Success"
		end)

		if not ok then
			warn(`Test Failure\n -----CallStack----- \n { Dash.pretty(result) }, \n-----Instance Tree----- \n { dumpInstanceTree(ScreenGui) }`)
		end
	else
		p2(ScreenGui)
	end

	Roact.unmount(v12)
	ScreenGui:Destroy()
end

return runWhileMounted
