local parent = script.Parent.Parent.Parent
local Loggers = require(parent.Loggers)
local logger = Loggers.Logger
local HttpService = game:GetService("HttpService")

local function attachPackageName(options) -- 4 equivalent calls inferred from this helper
	local selected = options or {}

	selected.packageName = "IAPExperience"
	return selected
end

local Logger = {}

function Logger:debug()
	logger:debug(HttpService:JSONEncode(attachPackageName(self))) -- inferred equivalent call
end
function Logger:info()
	logger:info(HttpService:JSONEncode(attachPackageName(self))) -- inferred equivalent call
end
function Logger:warn()
	logger:warn(HttpService:JSONEncode(attachPackageName(self))) -- inferred equivalent call
end
function Logger:error()
	logger:error(HttpService:JSONEncode(attachPackageName(self))) -- inferred equivalent call
end

return Logger
