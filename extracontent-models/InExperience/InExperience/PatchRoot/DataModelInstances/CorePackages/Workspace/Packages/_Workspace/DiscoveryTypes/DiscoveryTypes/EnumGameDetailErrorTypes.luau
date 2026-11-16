local parent = script.Parent.Parent
local SharedFlags = require(parent.SharedFlags)
return {
	ExperienceUnavailable = "ExperienceUnavailable",
	NetworkError = SharedFlags.FFlagLuaAppInExperienceDetailsPrompt and "NetworkError" or nil
}
