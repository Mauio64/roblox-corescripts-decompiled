local t1 = {}

if not game:GetEngineFeature("RecordingServicePlaybackApiLua") then
	return t1
end

if not game:GetEngineFeature("DmctPlaybackClientApp") and game.PlaceId ~= 123012592984338 then
	return t1
end

local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local scriptParent = script.Parent

t1.state = require(scriptParent.PlaybackState).new(false, false, false)
t1.screenGui = Instance.new("ScreenGui")
t1.screenGui.Parent = RobloxGui
require(scriptParent.CreateControlBar).createControlBar(t1)
require(scriptParent.CreateLoadingOverlay).createLoadingOverlay(t1)
require(scriptParent.CreateButtonsTime).createButtonsTime(t1)
require(scriptParent.CreateScrubber).createScrubber(t1)
require(scriptParent.CreateHelpText).createHelpText(t1)
require(scriptParent.ControlButtonsTime).setupControl(t1)
require(scriptParent.ControlVisibility).setupControl(t1)

local LoadSlices = require(scriptParent.LoadSlices)

if not game:GetEngineFeature("DmctPlaybackClientApp") then
	LoadSlices.experienceCallback(t1)
end

require(scriptParent.ControlScrubber).setupControl(t1)
require(scriptParent.ListenPlaybackStatusUpdated).setupListener(t1)
require(scriptParent.CreateSpectatorCamera).createSpectatorCamera(t1)

if game:GetEngineFeature("DmctPlaybackClientApp") then
	require(scriptParent.ReplaySelector).create(t1, function(p1) -- line: 59
		-- upvalues: LoadSlices (copy), t1 (copy)
		LoadSlices.loadGUID(t1, p1)
	end)
end

return t1
