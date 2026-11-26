local CoreGui = game:GetService("CoreGui")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceCloudPlay/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceCloudPlay/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceCloudPlay/ReactRoblox")
local TransientUIOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceCloudPlay/TransientUIOverlay")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceCloudPlay/InExperienceCloudPlay/Components/RestyleTimeLimitSnackbar")
local showUnsuccessfulJoinSnackbar = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceCloudPlay/InExperienceCloudPlay/showUnsuccessfulJoinSnackbar")

local defineFastInt = game:DefineFastInt("CloudPlayUIOverlayDisplayOrder", 6)

local function mountCloudPlayUIOverlay()
	local inExperienceCloudPlay = Instance.new("Folder")
	inExperienceCloudPlay.Name = "InExperienceCloudPlay"
	inExperienceCloudPlay.Parent = CoreGui

	local root = ReactRoblox.createRoot(inExperienceCloudPlay)
	root:render(React.createElement(
		Foundation.FoundationProvider,
		{ colorMode = Foundation.Enums.ColorMode.Dark },
		{
			OverlayScreen = React.createElement(TransientUIOverlay.OverlayScreen, {
				displayOrder = defineFastInt
			}),
			RestyleTimeLimitSnackbar = React.createElement(module5)
		}
	))

	showUnsuccessfulJoinSnackbar()

	return root
end

return mountCloudPlayUIOverlay
