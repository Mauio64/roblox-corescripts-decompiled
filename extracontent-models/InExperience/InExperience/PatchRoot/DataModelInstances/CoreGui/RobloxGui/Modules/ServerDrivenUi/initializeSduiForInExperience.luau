local function initializeSduiForInExperience()
	local registerInExperienceComponents = require(script.Parent.registerInExperienceComponents)
	registerInExperienceComponents()
	local registerInExperienceActions = require(script.Parent.registerInExperienceActions)
	registerInExperienceActions()
	local registerInExperienceTelemetryHandlers = require(script.Parent.registerInExperienceTelemetryHandlers)
	registerInExperienceTelemetryHandlers()
end

return initializeSduiForInExperience
