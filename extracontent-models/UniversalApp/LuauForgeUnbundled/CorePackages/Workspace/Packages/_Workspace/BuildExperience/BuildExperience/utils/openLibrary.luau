local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local fFlagBuildExperienceLibrary = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceLibrary
local ProgressLoading = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ProgressLoading")
local launchExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperiencePlaytestLaunch/launchExperience")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")

local pregameOverride = ProgressLoading.PregameOverride

local function renderPregameSkeleton(p2)
	local LibraryPregameSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryPregameSkeleton")
	return React.createElement(LibraryPregameSkeleton, p2)
end

local function openLibrary(p2, p3)
	sendBuildExperienceEvent("LIBRARY_IMPRESSION", { placeId = p2, conversationId = p3 }, {
		phase = "requested",
		surface = "App"
	})

	if fFlagBuildExperienceLibrary then
		pregameOverride.setPregameOverride({
			placeId = p2,
			render = renderPregameSkeleton
		})
	end

	launchExperience(p2, "BuildLibrary", false, { sessionId = p3 })
end

return openLibrary
