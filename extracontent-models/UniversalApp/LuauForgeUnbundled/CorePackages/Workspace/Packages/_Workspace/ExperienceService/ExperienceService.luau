local module = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceService/ExperienceService/GameProtocol")
local ExperienceServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceService/ExperienceService/ExperienceServiceWrapper")
require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceService/ExperienceService/GameProtocolTypes")

local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceService/ExperienceService/Flags/GetFFlagMoveLuaExpLaunchBegin")

return {
	GameProtocol = module,
	GameParams = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceService/ExperienceService/GameParams"),
	ExperienceService = ExperienceServiceWrapper,
	Flags = { GetFFlagMoveLuaExpLaunchBegin = module3 }
}
