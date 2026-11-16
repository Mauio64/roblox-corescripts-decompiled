local module = require("@luauforge/deferred/ghE")

local function getAbuseCategoryValueList(items)
	local abuseCategoryValueList = {}

	for k, item in items do
		for k2, tagValue in item.tagValues do
			table.insert(abuseCategoryValueList, { data = tagValue })
		end
	end

	return abuseCategoryValueList
end

local function constructItemReportTags(p2)
	local v5 = {}

	if p2.assetTypeName and p2.itemId then
		v5.REPORTED_ABUSE_VECTOR = {
			valueList = {
				{ data = p2.assetTypeName }
			}
		}

		v5.REPORT_TARGET_ASSET_ID = {
			valueList = {
				{ data = p2.itemId }
			}
		}
	end

	return v5
end

local function constructProfileReportTags(p2)
	local v5 = {
		REPORTED_ABUSE_VECTOR = {
			valueList = {
				{ data = module.ABUSE_VECTOR.UserProfile }
			}
		}
	}

	if p2.profileUserId then
		v5.REPORT_TARGET_USER_ID = {
			valueList = {
				{ data = p2.profileUserId }
			}
		}
	end

	return v5
end

local function constructChatReportTags(p2)
	local v5 = {
		REPORTED_ABUSE_VECTOR = {
			valueList = {
				{ data = module.ABUSE_VECTOR.UserProfile }
			}
		}
	}

	if p2.userId then
		v5.REPORT_TARGET_USER_ID = {
			valueList = {
				{ data = p2.userId }
			}
		}
	end

	return v5
end

local function constructExperienceReportTags(p2)
	local v5 = {}

	if p2.rootPlaceId then
		v5.REPORTED_ABUSE_VECTOR = {
			valueList = {
				{ data = module.ABUSE_VECTOR.Place }
			}
		}

		v5.REPORT_TARGET_ASSET_ID = {
			valueList = {
				{ data = p2.rootPlaceId }
			}
		}
	end

	return v5
end

local function constructNotificationReportTags(p2)
	local v5 = {}
	v5.REPORTED_ABUSE_VECTOR = {
		valueList = {
			{ data = module.ABUSE_VECTOR.Notification }
		}
	}

	if p2.submitterUserId then
		v5.SUBMITTER_USER_ID = {
			valueList = {
				{ data = p2.submitterUserId }
			}
		}
	end

	if p2.assetId then
		v5.NOTIFICATION_ID = {
			valueList = {
				{ data = p2.assetId }
			}
		}
	end

	return v5
end

local v5 = {
	Item = constructItemReportTags,
	Chat = constructChatReportTags,
	Profile = constructProfileReportTags,
	ExperienceDetails = constructExperienceReportTags,
	Notification = constructNotificationReportTags
}

local function constructAbuseReportTags(p2, p3, p4)
	local result = {
		ENTRY_POINT = {
			valueList = {
				{ data = p4 }
			}
		},
		REPORTED_ABUSE_CATEGORY = { valueList = getAbuseCategoryValueList(p2) }
	}

	local v6 = v5[p3.reportEntryPoint]

	for k, v7 in not v6 and {} or v6(p3) do
		result[k] = v7
	end

	return result
end

return constructAbuseReportTags
