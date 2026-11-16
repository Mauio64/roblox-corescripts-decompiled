local useSchoolsEntrySource = require("@luauforge/deferred/eUJ").useSchoolsEntrySource

local useSchoolVerificationFlowOptional = require("@luauforge/deferred/ehT").useSchoolVerificationFlowOptional
local module = require("@luauforge/deferred/eUH")
require("@luauforge/deferred/ehU")
local module2 = require("@luauforge/deferred/ehV")

local function useSchoolsAnalytics()
	local v5 = useSchoolsEntrySource()

	local v6 = if module2 then useSchoolVerificationFlowOptional() else nil

	return module(v5, v6)
end

return useSchoolsAnalytics
