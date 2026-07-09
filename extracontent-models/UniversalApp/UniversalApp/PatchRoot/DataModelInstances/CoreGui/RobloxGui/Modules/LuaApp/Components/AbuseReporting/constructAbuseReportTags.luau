local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules.LuaApp.Components.AbuseReporting.Constants)

local function getAbuseCategoryValueList(t1: {[any]: any}) -- line: 4
	local t2 = {}

	for _, v14 in t1 do
		for _, v16 in v14.tagValues do
			table.insert(t2, {
				data = v16
			})
		end
	end

	return t2
end
local function constructItemReportTags(p1) -- line: 16
	local t3 = {}

	if p1.assetTypeName and p1.itemId then
		t3.REPORTED_ABUSE_VECTOR = {
			valueList = {{
				data = p1.assetTypeName
			}}
		}
		t3.REPORT_TARGET_ASSET_ID = {
			valueList = {{
				data = p1.itemId
			}}
		}
	end

	return t3
end
local function constructProfileReportTags(p2) -- line: 34
	-- upvalues: Constants (copy)
	local t4 = {
		REPORTED_ABUSE_VECTOR = {
			valueList = {{
				data = Constants.ABUSE_VECTOR.UserProfile
			}}
		}
	}

	if p2.profileUserId then
		t4.REPORT_TARGET_USER_ID = {
			valueList = {{
				data = p2.profileUserId
			}}
		}
	end

	return t4
end
local function constructChatReportTags(p3) -- line: 52
	-- upvalues: Constants (copy)
	local t5 = {
		REPORTED_ABUSE_VECTOR = {
			valueList = {{
				data = Constants.ABUSE_VECTOR.UserProfile
			}}
		}
	}

	if p3.userId then
		t5.REPORT_TARGET_USER_ID = {
			valueList = {{
				data = p3.userId
			}}
		}
	end

	return t5
end
local function constructExperienceReportTags(p4) -- line: 70
	-- upvalues: Constants (copy)
	local t6 = {}

	if p4.rootPlaceId then
		t6.REPORTED_ABUSE_VECTOR = {
			valueList = {{
				data = Constants.ABUSE_VECTOR.Place
			}}
		}
		t6.REPORT_TARGET_ASSET_ID = {
			valueList = {{
				data = p4.rootPlaceId
			}}
		}
	end

	return t6
end
local function constructNotificationReportTags(p5) -- line: 89
	-- upvalues: Constants (copy)
	local t7 = {
		REPORTED_ABUSE_VECTOR = {
			valueList = {{
				data = Constants.ABUSE_VECTOR.Notification
			}}
		}
	}

	if p5.submitterUserId then
		t7.SUBMITTER_USER_ID = {
			valueList = {{
				data = p5.submitterUserId
			}}
		}
	end

	if p5.assetId then
		t7.NOTIFICATION_ID = {
			valueList = {{
				data = p5.assetId
			}}
		}
	end

	return t7
end

local t8 = {
	Item = constructItemReportTags,
	Chat = constructChatReportTags,
	Profile = constructProfileReportTags,
	ExperienceDetails = constructExperienceReportTags,
	Notification = constructNotificationReportTags
}

local function constructAbuseReportTags(t9: {[any]: any}, p6, p7) -- line: 124
	-- upvalues: getAbuseCategoryValueList (copy), t8 (copy)
	local v30 = getAbuseCategoryValueList(t9)
	local t10 = {
		ENTRY_POINT = {
			valueList = {{
				data = p7
			}}
		},
		REPORTED_ABUSE_CATEGORY = {
			valueList = v30
		}
	}
	local v32 = t8[p6.reportEntryPoint]

	for v33, v34 in if not v32 then {} else v32(p6) do
		t10[v33] = v34
	end

	return t10
end

return constructAbuseReportTags
