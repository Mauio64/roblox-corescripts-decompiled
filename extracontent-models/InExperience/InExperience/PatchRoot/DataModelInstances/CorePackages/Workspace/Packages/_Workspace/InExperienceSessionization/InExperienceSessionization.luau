local parent = script.Parent
local SessionizationUtil = require(parent.SessionizationUtil)
local SessionServiceWrapper = SessionizationUtil.SessionServiceWrapper

local SessionType = require(script.SessionType)
local ExperienceMenuSessionManager = require(script.ExperienceMenuSessionManager)
local experienceMenuSessionManagerInstance = ExperienceMenuSessionManager.new(SessionServiceWrapper)

return {
	["jest.config"] = script["jest.config"],
	SessionType = SessionType,
	ExperienceMenuSessionManagerInstance = experienceMenuSessionManagerInstance
}
