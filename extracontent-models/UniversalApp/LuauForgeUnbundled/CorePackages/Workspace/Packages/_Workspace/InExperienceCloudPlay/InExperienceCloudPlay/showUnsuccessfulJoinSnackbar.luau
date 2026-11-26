local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceCloudPlay/Foundation")
local TransientUIOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceCloudPlay/TransientUIOverlay")
local DefaultLoadingScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceCloudPlay/InExperienceCloudPlay/DefaultLoadingScreen")
local UnsuccessfulJoin = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceCloudPlay/InExperienceCloudPlay/UnsuccessfulJoin")

local defineFastInt = game:DefineFastInt("CloudPlayUnsuccessfulJoinSnackbarSeconds", 7)

local function showUnsuccessfulJoinSnackbar()
	if not UnsuccessfulJoin.consumeUnsuccessfulJoin() then
		return
	end

	local function show()
		TransientUIOverlay.displaySnackbar(
			{
				kind = "snackbar",
				title = "Cloud Play isn't working. You're playing normally.",
				icon = Foundation.Enums.IconName.TriangleExclamation
			},
			defineFastInt
		)
	end

	if DefaultLoadingScreen.isRemoved() then
		TransientUIOverlay.displaySnackbar(
			{
				kind = "snackbar",
				title = "Cloud Play isn't working. You're playing normally.",
				icon = Foundation.Enums.IconName.TriangleExclamation
			},
			defineFastInt
		)
		return
	end

	local v5 = nil
	v5 = DefaultLoadingScreen.subscribeRemoved(function()
		v5()
		TransientUIOverlay.displaySnackbar(
			{
				kind = "snackbar",
				title = "Cloud Play isn't working. You're playing normally.",
				icon = Foundation.Enums.IconName.TriangleExclamation
			},
			defineFastInt
		)
	end)
end

return showUnsuccessfulJoinSnackbar
