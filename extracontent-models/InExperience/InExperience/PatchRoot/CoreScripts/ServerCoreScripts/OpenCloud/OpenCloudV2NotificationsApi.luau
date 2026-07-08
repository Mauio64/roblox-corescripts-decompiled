local ContentProvider = game:GetService("ContentProvider")
local HttpService = game:GetService("HttpService")
local OpenCloudService = game:GetService("OpenCloudService")
local RunService = game:GetService("RunService")

function returnInvalidArgumentError(s1: string) -- line: 20
	-- upvalues: HttpService (copy)
	return {
		StatusCode = 400,
		Body = HttpService:JSONEncode({
			code = "INVALID_ARGUMENT",
			message = s1
		})
	}
end
function verifyUserNotification(p1) -- line: 30
	if p1.path ~= nil then
		local v7 = verifyString(p1.path)

		if v7 ~= nil then
			return v7
		end
	end

	if p1.id ~= nil then
		local v8 = verifyString(p1.id)

		if v8 ~= nil then
			return v8
		end
	end

	if p1.source ~= nil then
		local v9 = verifySource(p1.source)

		if v9 ~= nil then
			return v9
		end
	end

	if p1.payload ~= nil then
		local v10 = verifyPayload(p1.payload)

		if v10 ~= nil then
			return v10
		end
	end

	return nil
end
function verifySource(p2) -- line: 62
	if p2.universe ~= nil then
		local v12 = verifyString(p2.universe)

		if v12 ~= nil then
			return v12
		end
	end

	return nil
end
function verifyPayload(p3) -- line: 73
	if p3.type ~= nil then
		local v14 = verifyString(p3.type)

		if v14 ~= nil then
			return v14
		end
	end

	if p3.messageId ~= nil then
		local v15 = verifyString(p3.messageId)

		if v15 ~= nil then
			return v15
		end
	end

	if p3.joinExperience ~= nil then
		local v16 = verifyJoinExperience(p3.joinExperience)

		if v16 ~= nil then
			return v16
		end
	end

	if p3.analyticsData ~= nil then
		local v17 = verifyAnalyticsData(p3.analyticsData)

		if v17 ~= nil then
			return v17
		end
	end

	if p3.parameters ~= nil then
		local v18 = verifyParameters(p3.parameters)

		if v18 ~= nil then
			return v18
		end
	end

	return nil
end
function verifyJoinExperience(p4) -- line: 112
	if p4.launchData ~= nil then
		local v20 = verifyString(p4.launchData)

		if v20 ~= nil then
			return v20
		end
	end

	return nil
end
function verifyAnalyticsData(p5) -- line: 123
	if p5.category ~= nil then
		local v22 = verifyString(p5.category)

		if v22 ~= nil then
			return v22
		end
	end

	return nil
end
function verifyParameters(p6) -- line: 134
	for _, v in pairs(p6) do
		local n1 = 0

		if v.stringValue ~= nil then
			n1 += 1

			local v27 = verifyString(v.stringValue)

			if v27 ~= nil then
				return v27
			end
		end

		if v.int64Value ~= nil then
			n1 += 1

			local v28 = verifyNumber(v.int64Value)

			if v28 ~= nil then
				return v28
			end
		end

		if n1 > 1 then
			return returnInvalidArgumentError("Too many parameters provided for oneOf object!")
		end
	end

	return nil
end
function verifyNumber(p7) -- line: 159
	if typeof(p7) ~= "number" then
		return returnInvalidArgumentError("Argument not a number.")
	end

	return nil
end
function verifyString(p8) -- line: 166
	if typeof(p8) ~= "string" then
		return returnInvalidArgumentError("Argument not a string.")
	end

	return nil
end
function getUrlPrefix() -- line: 173
	-- upvalues: RunService (copy)
	if RunService:IsStudio() then
		return "user"
	end

	return "rcc"
end
function createUserNotificationUrl(n2: number, _) -- line: 180
	-- upvalues: ContentProvider (copy)
	local v33 = ContentProvider.BaseUrl:lower()
	local v34 = string.gsub(v33, "http:", "https:")
	local v35 = string.gsub(v34, "www", "apis")

	return (string.format("%s%s/cloud/v2/users/%d/notifications", v35, getUrlPrefix(), n2))
end
function userNotification(p10) -- line: 189
	-- upvalues: HttpService (copy), OpenCloudService (copy)
	if p10.user ~= nil then
		local v37 = verifyNumber(p10.user)

		if v37 ~= nil then
			return v37
		end
	end

	if p10.userNotification ~= nil then
		local v38 = verifyUserNotification(p10.userNotification)

		if v38 ~= nil then
			return v38
		end
	end

	local json = HttpService:JSONEncode(p10.userNotification)

	return OpenCloudService:HttpRequestAsync({
		Url = createUserNotificationUrl(p10.user, p10.userNotification),
		Request_Type = "POST",
		Body = json
	})
end

OpenCloudService:RegisterOpenCloud("v2", "userNotification", userNotification)
OpenCloudService:RegistrationComplete()
