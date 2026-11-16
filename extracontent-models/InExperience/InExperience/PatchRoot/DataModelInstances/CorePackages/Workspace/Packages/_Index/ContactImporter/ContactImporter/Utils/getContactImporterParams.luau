local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local Constants = require(parent.Common.Constants)
local RODUX_KEY = Constants.RODUX_KEY

return function(p)
	return getDeepValue(p, RODUX_KEY .. ".ShowContactImporterParams") or {}
end
