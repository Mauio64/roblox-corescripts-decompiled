local parent = script:FindFirstAncestor("InExperienceOffers").Parent

local Promise = require(parent.Promise)

local function networkError(message: string, cause) -- 1 equivalent call inferred from this helper
	return { kind = "Network", message = message, cause = cause }
end

local function parseError(message: string, cause) -- 1 equivalent call inferred from this helper
	return { kind = "Parse", message = message, cause = cause }
end

local function schemaError(message: string, cause) -- 1 equivalent call inferred from this helper
	return { kind = "Schema", message = message, cause = cause }
end

local function engineError(message: string, cause) -- 1 equivalent call inferred from this helper
	return { kind = "Engine", message = message, cause = cause }
end

local Errors = {}
Errors.networkError = networkError
Errors.parseError = parseError
Errors.schemaError = schemaError
Errors.engineError = engineError

function Errors.rejectNetwork(message: string, cause)
	return Promise.reject(networkError(message, cause)) -- inferred equivalent call
end

function Errors.rejectParse(message: string, cause)
	return Promise.reject(parseError(message, cause)) -- inferred equivalent call
end

function Errors.rejectSchema(message: string, cause)
	return Promise.reject(schemaError(message, cause)) -- inferred equivalent call
end

function Errors.rejectEngine(message: string, cause)
	return Promise.reject(engineError(message, cause)) -- inferred equivalent call
end

return Errors
