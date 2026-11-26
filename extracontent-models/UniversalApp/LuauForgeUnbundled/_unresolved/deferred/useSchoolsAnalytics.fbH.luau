local useSchoolsEntrySource = require("@luauforge/deferred/fbI").useSchoolsEntrySource

local useSchoolVerificationFlowOptional = require("@luauforge/deferred/eln").useSchoolVerificationFlowOptional
local module = require("@luauforge/deferred/fbG")
require("@luauforge/deferred/elo")
local module2 = require("@luauforge/deferred/elp")

local function useSchoolsAnalytics()
	local v5 = useSchoolsEntrySource()

	local v6 = if module2 then useSchoolVerificationFlowOptional() else nil

	return module(v5, v6)
end

return useSchoolsAnalytics
