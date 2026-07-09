local ParentParent = script.Parent.Parent
local ReactRoblox = require(ParentParent.Dev.ReactRoblox)
local dumpInstanceTree = require(ParentParent.AppDebug).dumpInstanceTree

local function runWhileMounted(p1, p2: ((...any) -> ...any)) -- line: 16
	-- upvalues: ReactRoblox (copy), dumpInstanceTree (copy)
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Parent = game:GetService("CoreGui")

	local v8 = ReactRoblox.createRoot(ScreenGui)

	ReactRoblox.act(function() -- line: 22
		-- upvalues: v8 (copy), p1 (copy)
		v8:render(p1)
	end)

	local ok, result = pcall(function() -- line: 26
		-- upvalues: p2 (copy), ScreenGui (copy), v8 (copy)
		p2(ScreenGui, v8)

		return "Success"
	end)
	local v11 = nil

	if not ok then
		v11 = string.format("%s\n\nInstance Tree:\n\n%s", tostring(result), dumpInstanceTree(ScreenGui))
	end

	v8:unmount()

	if not ok then
		error(v11)
	end
end

return runWhileMounted
