local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Roact = require(CorePackages.Packages.Roact)

local TrackerPrompt = require(RobloxGui.Modules.Tracker.TrackerPrompt)

local class = {}
class.__index = class

function class:showPrompt(promptType)
	if self.trackerPrompt then
		Roact.update(self.trackerPrompt, Roact.createElement(TrackerPrompt, {
			promptType = promptType
		}))
	else
		self.trackerPrompt = Roact.mount(
			Roact.createElement(TrackerPrompt, { promptType = promptType }),
			CoreGui,
			"RobloxTrackerPromptGui"
		)
	end
end

function class.new()
	local v = { trackerPrompt = nil }
	setmetatable(v, class)

	return v
end

return class.new()
