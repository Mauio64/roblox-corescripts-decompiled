local parent = script:FindFirstAncestor("GameLaunch").Parent

local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default
local Cryo = require(parent.Cryo)
require(parent.ExperienceService)
local ExperienceService = require(parent.ExperienceService)
local experienceService = ExperienceService.ExperienceService

local ExperienceService2 = require(parent.ExperienceService)
local GetFFlagMoveLuaExpLaunchBegin = ExperienceService2.Flags.GetFFlagMoveLuaExpLaunchBegin

local SharedFlags = require(parent.SharedFlags)
local FFlagDeferInExperienceRbxmDownload = SharedFlags.FFlagDeferInExperienceRbxmDownload
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableDeferredAssetManagerService = SharedFlags2.FFlagEnableDeferredAssetManagerService
local DeferredAssetManagerService

if FFlagDeferInExperienceRbxmDownload and FFlagEnableDeferredAssetManagerService then
	DeferredAssetManagerService = game:GetService("DeferredAssetManagerService")
else
	DeferredAssetManagerService = nil
end

local function LaunchGame(p: string?, referralPage: string?, p2, _, p3: string?, callback)
	if not GetFFlagMoveLuaExpLaunchBegin() then
		default:logEvent("experience_launch_begin")
	end

	local joined = { placeId = tonumber(p), referralPage = referralPage }

	if p2 then
		joined = Cryo.Dictionary.join(joined, p2)
	end

	if FFlagDeferInExperienceRbxmDownload and FFlagEnableDeferredAssetManagerService then
		local v = DeferredAssetManagerService
		v.JoiningPlaceId = joined.placeId or 0
		v.JoiningUniverseId = tonumber(joined.universeId) or 0
	end

	experienceService:LaunchExperience(joined, p3, callback)
end

return LaunchGame
