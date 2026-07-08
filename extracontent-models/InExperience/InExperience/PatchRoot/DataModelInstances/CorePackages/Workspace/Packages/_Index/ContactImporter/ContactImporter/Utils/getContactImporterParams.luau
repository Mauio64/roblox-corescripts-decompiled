local ParentParent = script.Parent.Parent
local getDeepValue = require(ParentParent.dependencies).SocialLibraries.Dictionary.getDeepValue
local RODUX_KEY = require(ParentParent.Common.Constants).RODUX_KEY

return function(p1) -- line: 6
	-- upvalues: getDeepValue (copy), RODUX_KEY (copy)
	return getDeepValue(p1, RODUX_KEY .. "." .. "ShowContactImporterParams") or {}
end
