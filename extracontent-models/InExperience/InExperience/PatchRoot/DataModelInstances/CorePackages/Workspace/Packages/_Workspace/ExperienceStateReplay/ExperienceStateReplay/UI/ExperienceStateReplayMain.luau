local ExperienceStateReplayMain = {}

if
	not game:GetEngineFeature("RecordingServicePlaybackApiLua")
	or not game:GetEngineFeature("DmctPlaybackClientApp") and game.PlaceId ~= 123012592984338
then
	return ExperienceStateReplayMain
end

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local parent = script.Parent
local PlaybackState = require(parent.PlaybackState)

ExperienceStateReplayMain.state = PlaybackState.new(false, false, false)

ExperienceStateReplayMain.screenGui = Instance.new("ScreenGui")
ExperienceStateReplayMain.screenGui.Parent = RobloxGui

local CreateControlBar = require(parent.CreateControlBar)
CreateControlBar.createControlBar(ExperienceStateReplayMain)

local CreateLoadingOverlay = require(parent.CreateLoadingOverlay)
CreateLoadingOverlay.createLoadingOverlay(ExperienceStateReplayMain)

local CreateButtonsTime = require(parent.CreateButtonsTime)
CreateButtonsTime.createButtonsTime(ExperienceStateReplayMain)

local CreateScrubber = require(parent.CreateScrubber)
CreateScrubber.createScrubber(ExperienceStateReplayMain)

local CreateHelpText = require(parent.CreateHelpText)
CreateHelpText.createHelpText(ExperienceStateReplayMain)

local ControlButtonsTime = require(parent.ControlButtonsTime)
ControlButtonsTime.setupControl(ExperienceStateReplayMain)

local ControlVisibility = require(parent.ControlVisibility)
ControlVisibility.setupControl(ExperienceStateReplayMain)

local LoadSlices = require(parent.LoadSlices)

if not game:GetEngineFeature("DmctPlaybackClientApp") then
	LoadSlices.experienceCallback(ExperienceStateReplayMain)
end

local ControlScrubber = require(parent.ControlScrubber)
ControlScrubber.setupControl(ExperienceStateReplayMain)

local ListenPlaybackStatusUpdated = require(parent.ListenPlaybackStatusUpdated)
ListenPlaybackStatusUpdated.setupListener(ExperienceStateReplayMain)

local CreateSpectatorCamera = require(parent.CreateSpectatorCamera)
CreateSpectatorCamera.createSpectatorCamera(ExperienceStateReplayMain)

if game:GetEngineFeature("DmctPlaybackClientApp") then
	local ReplaySelector = require(parent.ReplaySelector)
	ReplaySelector.create(ExperienceStateReplayMain, function(p)
		LoadSlices.loadGUID(ExperienceStateReplayMain, p)
	end)
end

return ExperienceStateReplayMain
