local function fetchAdminStatus(p2, object, object2, value): boolean
	local v5 = string.match(value, "^https?://[^.]+%.([^/]+)")

	if v5 == nil then
		return false
	end

	local jsonDecode = object2:JSONDecode((object:PostAsyncFullUrl(
		string.format("https://apis.%s/profile-platform-api/v1/profiles/get", v5),
		object2:JSONEncode({
			profileType = "User",
			profileId = tostring(p2),
			components = {
				{ component = "UserProfileHeader" }
			},
			includeComponentOrdering = false
		}),
		Enum.ThrottlingPriority.Default,
		Enum.HttpContentType.ApplicationJson,
		Enum.HttpRequestType.Players
	)))
	local userProfileHeader

	if type(jsonDecode) == "table" and type(jsonDecode.components) == "table" then
		userProfileHeader = jsonDecode.components.UserProfileHeader
	end

	return type(userProfileHeader) == "table" and userProfileHeader.isRobloxAdmin == true
end

return fetchAdminStatus
