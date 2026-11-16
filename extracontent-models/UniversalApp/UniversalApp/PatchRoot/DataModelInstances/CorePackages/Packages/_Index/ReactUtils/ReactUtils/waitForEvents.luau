local parent = script:FindFirstAncestor("ReactUtils").Parent
local ReactRoblox = require(parent.ReactRoblox)

local function waitForEvents() -- 1 equivalent call inferred from this helper
	task.wait(0)
end

local function actWaitForEvents()
	ReactRoblox.act(function()
		waitForEvents() -- inferred equivalent call
	end)
end

return (setmetatable({ act = actWaitForEvents }, { __call = waitForEvents }))
