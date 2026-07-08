local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Roact = require(CorePackages.Packages.Roact)
local TrackerPrompt = require(RobloxGui.Modules.Tracker.TrackerPrompt)
local t1 = {}

t1.__index = t1

function t1.showPrompt(p1, p2) -- line: 20
	-- upvalues: Roact (copy), TrackerPrompt (copy), CoreGui (copy)
	if p1.trackerPrompt then
		Roact.update(p1.trackerPrompt, Roact.createElement(TrackerPrompt, {
			promptType = p2
		}))

		return
	end

	p1.trackerPrompt = Roact.mount(Roact.createElement(TrackerPrompt, {
		promptType = p2
	}), CoreGui, "RobloxTrackerPromptGui")
end
function t1.new() -- line: 39
	-- upvalues: t1 (copy)
	local t2 = {
		trackerPrompt = nil
	}

	setmetatable(t2, t1)

	return t2
end

return t1.new()
