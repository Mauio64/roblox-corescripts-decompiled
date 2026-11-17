local InExperienceCloudPlay = script:FindFirstAncestor("InExperienceCloudPlay")
local parent = InExperienceCloudPlay.Parent

local Foundation = require(parent.Foundation)
local TransientUIOverlay = require(parent.TransientUIOverlay)
local DefaultLoadingScreen = require(InExperienceCloudPlay.DefaultLoadingScreen)
local UnsuccessfulJoin = require(InExperienceCloudPlay.UnsuccessfulJoin)

local defineFastInt = game:DefineFastInt("CloudPlayUnsuccessfulJoinSnackbarSeconds", 7)

local function showUnsuccessfulJoinSnackbar()
	if not UnsuccessfulJoin.consumeUnsuccessfulJoin() then
		return
	end

	local function show() -- 2 equivalent calls inferred from this helper
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
		show() -- inferred equivalent call
		return
	end

	local v = nil
	v = DefaultLoadingScreen.subscribeRemoved(function()
		v()
		show() -- inferred equivalent call
	end)
end

return showUnsuccessfulJoinSnackbar
