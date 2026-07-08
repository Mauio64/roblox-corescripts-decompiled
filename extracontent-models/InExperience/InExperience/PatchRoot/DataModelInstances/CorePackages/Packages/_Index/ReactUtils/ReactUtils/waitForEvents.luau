local Parent = script:FindFirstAncestor("ReactUtils").Parent
local ReactRoblox = require(Parent.ReactRoblox)

local function waitForEvents() -- line: 6
	task.wait(0)
end
local function actWaitForEvents() -- line: 13
	-- upvalues: ReactRoblox (copy)
	ReactRoblox.act(function() -- line: 14
		task.wait(0)
	end)
end

return (setmetatable({
	act = actWaitForEvents
}, {
	__call = waitForEvents
}))
