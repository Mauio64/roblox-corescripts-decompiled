game:DefineFastFlag("LoggingRethrowUsingError", false)

local function GetFFlagLoggingRethrowUsingError() -- 1 equivalent call inferred from this helper
	return game:GetFastFlag("LoggingRethrowUsingError")
end

local v = true
local v2 = {}

local function createLogInfo()
	local logInfo = { warnings = {} }

	setmetatable(logInfo, {
		__tostring = function(p)
			return ("LogInfo\n\tWarnings (%d):\n\t\t%s"):format(#p.warnings, table.concat(p.warnings, "\n\t\t"))
		end
	})

	return logInfo
end

local Logging = {}

function Logging.capture(callback)
	local logInfo = createLogInfo()

	local v3 = v
	v = false
	v2[logInfo] = true

	local success, result = pcall(callback)

	v2[logInfo] = nil
	v = v3

	if GetFFlagLoggingRethrowUsingError() then -- inferred equivalent call
		if not success then
			error(result)
			return logInfo
		end
	else
		assert(success, result)
	end

	return logInfo
end

function Logging.warn(p)
	for k in pairs(v2) do
		table.insert(k.warnings, p)
	end

	if v then
		warn(p)
	end
end

return Logging
