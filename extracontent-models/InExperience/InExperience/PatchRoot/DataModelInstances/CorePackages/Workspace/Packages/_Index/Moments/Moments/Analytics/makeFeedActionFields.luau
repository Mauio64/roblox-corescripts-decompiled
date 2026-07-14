local Parent = script:FindFirstAncestor("Moments").Parent
local MomentsCommon = require(Parent.MomentsCommon)
local GetFFlagMomentsAnalyticsSchemaIdentity = MomentsCommon.Flags.GetFFlagMomentsAnalyticsSchemaIdentity

local function makeFeedActionFields(s1: string, s2: string?, s3: string?, s4: string?) -- line: 34
	-- upvalues: GetFFlagMomentsAnalyticsSchemaIdentity (copy), MomentsCommon (copy)
	if GetFFlagMomentsAnalyticsSchemaIdentity() then
		if s2 == nil or s2 == "" then
			local v9 = s2 ~= nil and "empty" or "nil"

			MomentsCommon.Analytics.reportMomentSkip("feed_action", v9, {
				action = s4
			})

			return nil
		end

		return {
			momentId = s1,
			feedItemId = s2,
			feedSessionId = s3 or ""
		}
	end

	return {
		momentId = s1
	}
end

return makeFeedActionFields
