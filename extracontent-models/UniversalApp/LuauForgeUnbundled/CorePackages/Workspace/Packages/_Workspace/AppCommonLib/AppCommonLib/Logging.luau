game:DefineFastFlag("LoggingRethrowUsingError", false)

local function GetFFlagLoggingRethrowUsingError()
	return game:GetFastFlag("LoggingRethrowUsingError")
end

local v5 = true
local v6 = {}

local function createLogInfo()
	local logInfo = { warnings = {} }

	setmetatable(logInfo, {
		__tostring = function(p2)
			return ("LogInfo\n\tWarnings (%d):\n\t\t%s"):format(
				#p2.warnings,
				table.concat(p2.warnings, "\n\t\t")
			)
		end
	})

	return logInfo
end

return {
	capture = function(callback)
		local logInfo = createLogInfo()

		local v7 = v5
		v5 = false
		v6[logInfo] = true

		local success, result = pcall(callback)

		v6[logInfo] = nil
		v5 = v7

		if game:GetFastFlag("LoggingRethrowUsingError") then
			if not success then
				error(result)
				return logInfo
			end
		else
			assert(success, result)
		end

		return logInfo
	end,
	warn = function(p2)
		for k in pairs(v6) do
			table.insert(k.warnings, p2)
		end

		if v5 then
			warn(p2)
		end
	end
}
