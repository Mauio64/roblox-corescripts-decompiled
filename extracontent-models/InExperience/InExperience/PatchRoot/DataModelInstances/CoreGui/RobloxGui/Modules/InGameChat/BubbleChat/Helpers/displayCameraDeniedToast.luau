local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local TrackerMenu = require(RobloxGui.Modules.Tracker.TrackerMenu)
local TrackerPromptType = require(RobloxGui.Modules.Tracker.TrackerPromptType)

return function() -- line: 10
	-- upvalues: TrackerMenu (copy), TrackerPromptType (copy), Promise (copy)
	TrackerMenu:showPrompt(TrackerPromptType.None)
	Promise.delay(0.016666666666666666):andThen(function() -- line: 12
		-- upvalues: TrackerMenu (copy), TrackerPromptType (copy)
		TrackerMenu:showPrompt(TrackerPromptType.VideoNoPermission)
	end)
end
