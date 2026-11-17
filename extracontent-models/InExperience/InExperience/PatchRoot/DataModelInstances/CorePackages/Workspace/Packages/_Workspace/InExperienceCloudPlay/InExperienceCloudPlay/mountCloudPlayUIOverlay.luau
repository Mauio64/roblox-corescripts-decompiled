local CoreGui = game:GetService("CoreGui")

local InExperienceCloudPlay = script:FindFirstAncestor("InExperienceCloudPlay")
local parent = InExperienceCloudPlay.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local TransientUIOverlay = require(parent.TransientUIOverlay)
local RestyleTimeLimitSnackbar = require(InExperienceCloudPlay.Components.RestyleTimeLimitSnackbar)
local showUnsuccessfulJoinSnackbar = require(InExperienceCloudPlay.showUnsuccessfulJoinSnackbar)

local defineFastInt = game:DefineFastInt("CloudPlayUIOverlayDisplayOrder", 6)

local function mountCloudPlayUIOverlay()
	local inExperienceCloudPlay = Instance.new("Folder")
	inExperienceCloudPlay.Name = "InExperienceCloudPlay"
	inExperienceCloudPlay.Parent = CoreGui

	local root = ReactRoblox.createRoot(inExperienceCloudPlay)
	root:render(React.createElement(Foundation.FoundationProvider, {
		colorMode = Foundation.Enums.ColorMode.Dark
	}, {
		OverlayScreen = React.createElement(TransientUIOverlay.OverlayScreen, {
			displayOrder = defineFastInt
		}),
		RestyleTimeLimitSnackbar = React.createElement(RestyleTimeLimitSnackbar)
	}))

	showUnsuccessfulJoinSnackbar()

	return root
end

return mountCloudPlayUIOverlay
