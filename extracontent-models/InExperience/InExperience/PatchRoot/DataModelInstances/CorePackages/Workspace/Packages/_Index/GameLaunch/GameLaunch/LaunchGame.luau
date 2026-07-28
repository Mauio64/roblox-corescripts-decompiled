local Parent = script:FindFirstAncestor("GameLaunch").Parent
local default = require(Parent.LoggingProtocol).default
local Cryo = require(Parent.Cryo)

require(Parent.ExperienceService)

local ExperienceService = require(Parent.ExperienceService).ExperienceService
local GetFFlagMoveLuaExpLaunchBegin = require(Parent.ExperienceService).Flags.GetFFlagMoveLuaExpLaunchBegin

local function LaunchGame(s1: string?, s2: string?, t1: {[any]: any}?, _, s3: string?, p2: ((...any) -> ...any)?) -- line: 10
	-- upvalues: GetFFlagMoveLuaExpLaunchBegin (copy), default (copy), Cryo (copy), ExperienceService (copy)
	if not GetFFlagMoveLuaExpLaunchBegin() then
		default:logEvent("experience_launch_begin")
	end

	local t2 = {
		placeId = tonumber(s1),
		referralPage = s2
	}

	if t1 then
		t2 = Cryo.Dictionary.join(t2, t1)
	end

	ExperienceService:LaunchExperience(t2, s3, p2)
end

return LaunchGame
