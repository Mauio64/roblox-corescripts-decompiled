local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.ExperienceService)

local GameParams = require(CorePackages.Workspace.Packages.ExperienceService).GameParams
local ExperienceService = require(CorePackages.Workspace.Packages.ExperienceService).ExperienceService
local t1 = {}

local function launchGame(p1, s1: string?, p2: ((...any) -> ...any)?) -- line: 13
	-- upvalues: ExperienceService (copy)
	ExperienceService:LaunchExperience(p1, s1, p2)
end

function t1.ByUser(_: {[any]: any}, t3: {[any]: any}, s2: string?, p3: ((...any) -> ...any)?) -- line: 21
	-- upvalues: GameParams (copy), ExperienceService (copy)
	local v13 = GameParams.fromUserId(t3.id)

	assert(v13.userId ~= nil, "Joining a game by user should always be done by user id")
	ExperienceService:LaunchExperience(v13, s2, p3)
end
function t1.ByUserAndPlaceId(_: {[any]: any}, t5: {[any]: any}, n1: number, s3: string?, p4: ((...any) -> ...any)?) -- line: 38
	-- upvalues: GameParams (copy), ExperienceService (copy)
	local v19 = GameParams.fromUserId(t5.id, n1)

	assert(v19.userId ~= nil, "Joining a game by user and placeId should always contain a user id param")
	assert(v19.placeId ~= nil, "Joining a game by user and placeId should always contain a place id param")
	ExperienceService:LaunchExperience(v19, s3, p4)
end
function t1.ByGame(_: {[any]: any}, p5, s4: string?, p6: ((...any) -> ...any)?) -- line: 57
	-- upvalues: GameParams (copy), ExperienceService (copy)
	local v24 = GameParams.fromPlaceId(p5)

	ExperienceService:LaunchExperience(v24, s4, p6)
end

return t1
