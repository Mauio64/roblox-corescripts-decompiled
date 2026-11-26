local module = require("@luauforge/bundled/hKr")
require("@luauforge/bundled/hKz")

local v5 = { UserProfile = "user_profile", Place = "place" }

local v6 = { Experience = "experience", Profile = "profile", Item = "item" }

local v7 = { AssetId = "REPORT_TARGET_ASSET_ID", UserId = "REPORT_TARGET_USER_ID" }

local function getAbuseCategoryValueList(items)
	local abuseCategoryValueList = {}

	for k, item in items do
		if not item.tagValues then
			continue
		end

		for k2, tagValue in item.tagValues do
			table.insert(abuseCategoryValueList, { data = tagValue })
		end
	end

	return abuseCategoryValueList
end

local function constructTags(p2)
	return function(data)
		return {
			REPORTED_ABUSE_VECTOR = {
				valueList = {
					{
						data = data.context == "experience" and "place" or data.context == "profile" and "user_profile" or data.reportAbuseVector
					}
				}
			},
			[p2] = {
				valueList = {
					{ data = data.assetId }
				}
			}
		}
	end
end

local v8 = { item = 0, profile = 0, experience = 0 }
local v9
v9 = "REPORT_TARGET_ASSET_ID"
function v8.item(data)
	return {
		REPORTED_ABUSE_VECTOR = {
			valueList = {
				{
					data = data.context == "experience" and "place" or data.context == "profile" and "user_profile" or data.reportAbuseVector
				}
			}
		},
		[v9] = {
			valueList = {
				{ data = data.assetId }
			}
		}
	}
end

local v10
v10 = "REPORT_TARGET_USER_ID"
function v8.profile(data)
	return {
		REPORTED_ABUSE_VECTOR = {
			valueList = {
				{
					data = data.context == "experience" and "place" or data.context == "profile" and "user_profile" or data.reportAbuseVector
				}
			}
		},
		[v10] = {
			valueList = {
				{ data = data.assetId }
			}
		}
	}
end

local v11
v11 = "REPORT_TARGET_ASSET_ID"
function v8.experience(data)
	return {
		REPORTED_ABUSE_VECTOR = {
			valueList = {
				{
					data = data.context == "experience" and "place" or data.context == "profile" and "user_profile" or data.reportAbuseVector
				}
			}
		},
		[v11] = {
			valueList = {
				{ data = data.assetId }
			}
		}
	}
end

local function constructAbuseReportTags(p2, p3)
	local abuseCategoryValueList = getAbuseCategoryValueList(p2)

	local joined = {
		ENTRY_POINT = {
			valueList = {
				{ data = p3.platform }
			}
		},
		REPORTED_ABUSE_CATEGORY = { valueList = abuseCategoryValueList }
	}

	local v12 = v8[p3.context]

	if v12 then
		local v13 = v12(p3)
		joined = module.Dictionary.join(v13, joined)
	end

	return joined
end

return constructAbuseReportTags
