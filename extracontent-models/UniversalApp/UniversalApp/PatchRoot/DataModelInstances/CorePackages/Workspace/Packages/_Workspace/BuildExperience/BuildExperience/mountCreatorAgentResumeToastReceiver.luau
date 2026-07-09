local CoreGui = game:GetService("CoreGui")
local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)
local ReactRoblox = require(BuildExperienceParent.ReactRoblox)
local BuildEventReceiver = require(BuildExperience.BuildEventReceiver)

local function mountCreatorAgentResumeToastReceiver(b1: boolean) -- line: 13
	-- upvalues: CoreGui (copy), ReactRoblox (copy), React (copy), BuildEventReceiver (copy)
	local Folder = Instance.new("Folder")

	Folder.Name = "BuildEventReceiver"
	Folder.Parent = CoreGui

	local v10 = ReactRoblox.createRoot(Folder)

	v10:render(React.createElement(BuildEventReceiver, {
		isInExperience = true,
		isBuildModeActive = b1
	}))

	return v10
end

return mountCreatorAgentResumeToastReceiver
