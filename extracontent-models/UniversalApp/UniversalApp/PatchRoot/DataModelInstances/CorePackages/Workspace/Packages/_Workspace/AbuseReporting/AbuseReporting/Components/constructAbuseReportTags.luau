local AbuseReporting = script:FindFirstAncestor("AbuseReporting")
local AbuseReportingParent = AbuseReporting.Parent
local Cryo = require(AbuseReportingParent.Cryo)

require(AbuseReporting.Common.Types)

local _ = {
	UserProfile = "user_profile",
	Place = "place"
}
local _ = {
	Experience = "experience",
	Profile = "profile",
	Item = "item"
}
local _ = {
	AssetId = "REPORT_TARGET_ASSET_ID",
	UserId = "REPORT_TARGET_USER_ID"
}

local function getAbuseCategoryValueList(t1: {[any]: any}) -- line: 38
	local t2 = {}

	for _, v17 in t1 do
		if v17.tagValues then
			for _, v19 in v17.tagValues do
				table.insert(t2, {
					data = v19
				})
			end
		end
	end

	return t2
end
local function constructTags(p1) -- line: 51
	return function(t3: {[any]: any}) -- line: 52
		-- upvalues: p1 (copy)
		return {
			REPORTED_ABUSE_VECTOR = {
				valueList = {{
					data = if t3.context ~= "experience" then if t3.context ~= "profile" then t3.reportAbuseVector else "user_profile" else "place"
				}}
			},
			[p1] = {
				valueList = {{
					data = t3.assetId
				}}
			}
		}
	end
end

local t4 = {}
local s1 = "REPORT_TARGET_ASSET_ID"

function t4.item(t5: {[any]: any}) -- line: 52
	-- upvalues: s1 (copy)
	return {
		REPORTED_ABUSE_VECTOR = {
			valueList = {{
				data = if t5.context ~= "experience" then if t5.context ~= "profile" then t5.reportAbuseVector else "user_profile" else "place"
			}}
		},
		[s1] = {
			valueList = {{
				data = t5.assetId
			}}
		}
	}
end

local s2 = "REPORT_TARGET_USER_ID"

function t4.profile(t6: {[any]: any}) -- line: 52
	-- upvalues: s2 (copy)
	return {
		REPORTED_ABUSE_VECTOR = {
			valueList = {{
				data = if t6.context ~= "experience" then if t6.context ~= "profile" then t6.reportAbuseVector else "user_profile" else "place"
			}}
		},
		[s2] = {
			valueList = {{
				data = t6.assetId
			}}
		}
	}
end

local s3 = "REPORT_TARGET_ASSET_ID"

function t4.experience(t7: {[any]: any}) -- line: 52
	-- upvalues: s3 (copy)
	return {
		REPORTED_ABUSE_VECTOR = {
			valueList = {{
				data = if t7.context ~= "experience" then if t7.context ~= "profile" then t7.reportAbuseVector else "user_profile" else "place"
			}}
		},
		[s3] = {
			valueList = {{
				data = t7.assetId
			}}
		}
	}
end

local function constructAbuseReportTags(t8: {[any]: any}, t9: {[any]: any}) -- line: 80
	-- upvalues: getAbuseCategoryValueList (copy), t4 (copy), Cryo (copy)
	local v26 = getAbuseCategoryValueList(t8)
	local t10 = {
		ENTRY_POINT = {
			valueList = {{
				data = t9.platform
			}}
		},
		REPORTED_ABUSE_CATEGORY = {
			valueList = v26
		}
	}
	local v28 = t4[t9.context]

	if v28 then
		local v29 = v28(t9)

		t10 = Cryo.Dictionary.join(v29, t10)
	end

	return t10
end

return constructAbuseReportTags
