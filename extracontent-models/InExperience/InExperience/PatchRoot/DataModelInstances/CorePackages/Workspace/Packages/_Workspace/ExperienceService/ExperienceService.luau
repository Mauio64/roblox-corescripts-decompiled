local GameProtocol = require(script.GameProtocol)
local ExperienceServiceWrapper = require(script.ExperienceServiceWrapper)

require(script.GameProtocolTypes)

local GetFFlagMoveLuaExpLaunchBegin = require(script.Flags.GetFFlagMoveLuaExpLaunchBegin)

return {
	GameProtocol = GameProtocol,
	GameParams = require(script.GameParams),
	ExperienceService = ExperienceServiceWrapper,
	Flags = {
		GetFFlagMoveLuaExpLaunchBegin = GetFFlagMoveLuaExpLaunchBegin
	}
}
