local default = require("@game/CorePackages/Workspace/Packages/_Index/GameLaunch/LoggingProtocol").default
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameLaunch/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameLaunch/ExperienceService")
local experienceService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameLaunch/ExperienceService").ExperienceService

local getFFlagMoveLuaExpLaunchBegin = require("@game/CorePackages/Workspace/Packages/_Workspace/GameLaunch/ExperienceService").Flags.GetFFlagMoveLuaExpLaunchBegin

local fFlagDeferInExperienceRbxmDownload = require("@game/CorePackages/Workspace/Packages/_Workspace/GameLaunch/SharedFlags").FFlagDeferInExperienceRbxmDownload
local fFlagEnableDeferredAssetManagerService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameLaunch/SharedFlags").FFlagEnableDeferredAssetManagerService
local DeferredAssetManagerService

if fFlagDeferInExperienceRbxmDownload and fFlagEnableDeferredAssetManagerService then
	DeferredAssetManagerService = game:GetService("DeferredAssetManagerService")
else
	DeferredAssetManagerService = nil
end

local function LaunchGame(p2, p3, p4, p5, p6, p7)
	if not getFFlagMoveLuaExpLaunchBegin() then
		default:logEvent("experience_launch_begin")
	end

	local joined = { placeId = tonumber(p2), referralPage = p3 }

	if p4 then
		joined = Cryo.Dictionary.join(joined, p4)
	end

	if fFlagDeferInExperienceRbxmDownload and fFlagEnableDeferredAssetManagerService then
		local v5 = DeferredAssetManagerService
		v5.JoiningPlaceId = joined.placeId or 0
		v5.JoiningUniverseId = tonumber(joined.universeId) or 0
	end

	experienceService:LaunchExperience(joined, p6, p7)
end

return LaunchGame
