local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local React = require(parent.React)

local AbuseVector = require(GenericAbuseReporting.Enums.AbuseVector)

return React.createContext({
	abuseVector = AbuseVector.Invalid,
	isReportSubmitted = false,
	setIsReportSubmitted = function(_: boolean) end
})
