local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)
local AbuseVector = require(GenericAbuseReporting.Enums.AbuseVector)

return React.createContext({
	isReportSubmitted = false,
	abuseVector = AbuseVector.Invalid,
	setIsReportSubmitted = function(_: boolean) -- line: 11
	end
})
