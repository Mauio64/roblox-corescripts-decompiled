local defineFastFlag = game:DefineFastFlag("OpenCloudNotificationScheduledTimeEnabled", false)

local ContentProvider = game:GetService("ContentProvider")
local HttpService = game:GetService("HttpService")
local OpenCloudService = game:GetService("OpenCloudService")
local RunService = game:GetService("RunService")

function returnInvalidArgumentError(message: string)
	return {
		StatusCode = 400,
		Body = HttpService:JSONEncode({ code = "INVALID_ARGUMENT", message = message })
	}
end

function verifyUserNotification(data)
	if data.path ~= nil then
		local v = verifyString(data.path)

		if v ~= nil then
			return v
		end
	end

	if data.id ~= nil then
		local v = verifyString(data.id)

		if v ~= nil then
			return v
		end
	end

	if data.source ~= nil then
		local v = verifySource(data.source)

		if v ~= nil then
			return v
		end
	end

	if data.payload ~= nil then
		local v = verifyPayload(data.payload)

		if v ~= nil then
			return v
		end
	end

	return nil
end

function verifySource(p)
	if p.universe ~= nil then
		local v = verifyString(p.universe)

		if v ~= nil then
			return v
		end
	end

	return nil
end

function verifyPayload(data)
	if data.type ~= nil then
		local v = verifyString(data.type)

		if v ~= nil then
			return v
		end
	end

	if data.messageId ~= nil then
		local v = verifyString(data.messageId)

		if v ~= nil then
			return v
		end
	end

	if data.joinExperience ~= nil then
		local v = verifyJoinExperience(data.joinExperience)

		if v ~= nil then
			return v
		end
	end

	if data.analyticsData ~= nil then
		local v = verifyAnalyticsData(data.analyticsData)

		if v ~= nil then
			return v
		end
	end

	if data.parameters ~= nil then
		local v = verifyParameters(data.parameters)

		if v ~= nil then
			return v
		end
	end

	if defineFastFlag and data.scheduleTime ~= nil then
		local v = verifyString(data.scheduleTime)

		if v ~= nil then
			return v
		end
	end

	return nil
end

function verifyJoinExperience(p)
	if p.launchData ~= nil then
		local v = verifyString(p.launchData)

		if v ~= nil then
			return v
		end
	end

	return nil
end

function verifyAnalyticsData(p)
	if p.category ~= nil then
		local v = verifyString(p.category)

		if v ~= nil then
			return v
		end
	end

	return nil
end

function verifyParameters(items)
	for _, item in pairs(items) do
		local count = 0

		if item.stringValue ~= nil then
			count += 1
			local v = verifyString(item.stringValue)

			if v ~= nil then
				return v
			end
		end

		if item.int64Value ~= nil then
			count += 1
			local v = verifyNumber(item.int64Value)

			if v ~= nil then
				return v
			end
		end

		if count > 1 then
			return returnInvalidArgumentError("Too many parameters provided for oneOf object!")
		end
	end

	return nil
end

function verifyNumber(value)
	if typeof(value) == "number" then
		return nil
	end

	return returnInvalidArgumentError("Argument not a number.")
end

function verifyString(value)
	if typeof(value) == "string" then
		return nil
	end

	return returnInvalidArgumentError("Argument not a string.")
end

function getUrlPrefix(): string
	return if RunService:IsStudio() then "user" else "rcc"
end

function createUserNotificationUrl(p: number, _)
	local baseUrl = ContentProvider.BaseUrl:lower()
	local v = string.gsub(baseUrl, "http:", "https:")
	local v2 = string.gsub(v, "www", "apis")
	return (string.format("%s%s/cloud/v2/users/%d/notifications", v2, getUrlPrefix(), p))
end

function userNotification(p)
	if p.user ~= nil then
		local v = verifyNumber(p.user)

		if v ~= nil then
			return v
		end
	end

	if p.userNotification ~= nil then
		local v = verifyUserNotification(p.userNotification)

		if v ~= nil then
			return v
		end
	end

	local jsonEncode = HttpService:JSONEncode(p.userNotification)

	return OpenCloudService:HttpRequestAsync({
		["Url"] = createUserNotificationUrl(p.user, p.userNotification),
		Request_Type = "POST",
		Body = jsonEncode
	})
end

OpenCloudService:RegisterOpenCloud("v2", "userNotification", userNotification)
OpenCloudService:RegistrationComplete()
