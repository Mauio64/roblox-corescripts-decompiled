local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Loggers").Logger
local HttpService = game:GetService("HttpService")

local function attachPackageName(options)
	local v5 = options or {}

	v5.packageName = "IAPExperience"
	return v5
end

return {
	debug = function(options)
		local v7 = options or {}

		v7.packageName = "IAPExperience"

		logger:debug(HttpService:JSONEncode(v7))
	end,
	info = function(options)
		local v7 = options or {}

		v7.packageName = "IAPExperience"

		logger:info(HttpService:JSONEncode(v7))
	end,
	warn = function(options)
		local v7 = options or {}

		v7.packageName = "IAPExperience"

		logger:warn(HttpService:JSONEncode(v7))
	end,
	error = function(options)
		local v7 = options or {}

		v7.packageName = "IAPExperience"

		logger:error(HttpService:JSONEncode(v7))
	end
}
