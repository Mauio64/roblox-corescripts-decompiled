local CoreGui = game:GetService("CoreGui")

local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local BuildEventReceiver = require(BuildExperience.BuildEventReceiver)

local function mountCreatorAgentResumeToastReceiver(isBuildModeActive: boolean)
	local buildEventReceiver = Instance.new("Folder")
	buildEventReceiver.Name = "BuildEventReceiver"
	buildEventReceiver.Parent = CoreGui

	local root = ReactRoblox.createRoot(buildEventReceiver)
	root:render(React.createElement(BuildEventReceiver, {
		isInExperience = true,
		isBuildModeActive = isBuildModeActive
	}))

	return root
end

return mountCreatorAgentResumeToastReceiver
