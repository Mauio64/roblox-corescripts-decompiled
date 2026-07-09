local ParentParent = script.Parent.Parent
local FFlagLuaAppInExperienceDetailsPrompt = require(ParentParent.SharedFlags).FFlagLuaAppInExperienceDetailsPrompt

return {
	ExperienceUnavailable = "ExperienceUnavailable",
	NetworkError = if not FFlagLuaAppInExperienceDetailsPrompt then nil else "NetworkError"
}
