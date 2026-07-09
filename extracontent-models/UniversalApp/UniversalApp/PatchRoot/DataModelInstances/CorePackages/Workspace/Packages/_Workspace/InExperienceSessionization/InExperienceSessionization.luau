local scriptParent = script.Parent
local SessionServiceWrapper = require(scriptParent.SessionizationUtil).SessionServiceWrapper
local SessionType = require(script.SessionType)
local v4 = require(script.ExperienceMenuSessionManager).new(SessionServiceWrapper)

return {
	["jest.config"] = script["jest.config"],
	SessionType = SessionType,
	ExperienceMenuSessionManagerInstance = v4
}
