local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseVector")

return React.createContext({
	abuseVector = AbuseVector.Invalid,
	isReportSubmitted = false,
	setIsReportSubmitted = function(p2) end
})
