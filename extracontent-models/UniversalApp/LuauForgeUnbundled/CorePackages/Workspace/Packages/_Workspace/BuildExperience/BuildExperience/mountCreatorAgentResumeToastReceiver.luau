local CoreGui = game:GetService("CoreGui")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ReactRoblox")

local BuildEventReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/BuildEventReceiver")

local function mountCreatorAgentResumeToastReceiver(p2)
	local buildEventReceiver = Instance.new("Folder")
	buildEventReceiver.Name = "BuildEventReceiver"
	buildEventReceiver.Parent = CoreGui

	local root = ReactRoblox.createRoot(buildEventReceiver)
	root:render(React.createElement(BuildEventReceiver, {
		isInExperience = true,
		isBuildModeActive = p2
	}))

	return root
end

return mountCreatorAgentResumeToastReceiver
