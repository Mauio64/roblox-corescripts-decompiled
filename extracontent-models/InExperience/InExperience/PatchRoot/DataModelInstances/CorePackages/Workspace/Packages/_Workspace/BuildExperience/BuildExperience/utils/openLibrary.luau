local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary
local ProgressLoading = require(parent.ProgressLoading)
local launchExperience = require(parent.BuildExperiencePlaytestLaunch.launchExperience)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)

local PregameOverride = ProgressLoading.PregameOverride

local function renderPregameSkeleton(p)
	local LibraryPregameSkeleton = require(BuildExperience.Components.Library.LibraryPregameSkeleton)
	return React.createElement(LibraryPregameSkeleton, p)
end

local function openLibrary(placeId: number, p: string?)
	sendBuildExperienceEvent("LIBRARY_IMPRESSION", { placeId = placeId, conversationId = p }, {
		phase = "requested",
		surface = "App"
	})

	if FFlagBuildExperienceLibrary then
		PregameOverride.setPregameOverride({ placeId = placeId, render = renderPregameSkeleton })
	end

	launchExperience(placeId, "BuildLibrary", false, { sessionId = p })
end

return openLibrary
