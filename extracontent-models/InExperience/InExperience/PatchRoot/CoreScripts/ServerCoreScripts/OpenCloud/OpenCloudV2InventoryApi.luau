local ContentProvider = game:GetService("ContentProvider")
local HttpService = game:GetService("HttpService")
local OpenCloudService = game:GetService("OpenCloudService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

function returnInvalidArgumentError(message: string)
	return {
		StatusCode = 400,
		Body = HttpService:JSONEncode({ code = "INVALID_ARGUMENT", message = message })
	}
end

function verifyPlayerOnServer(p)
	local v = verifyPlayer(p)

	if v ~= nil then
		return v
	end

	local players = Players:GetPlayers()

	for _, player in ipairs(players) do
		if player.UserId == p.UserId then
			return nil
		end
	end

	return returnInvalidArgumentError("Player not found on server.")
end

function verifyPlayer(instance)
	if typeof(instance) == "Instance" and instance.ClassName == "Player" then
		return nil
	end

	return returnInvalidArgumentError("user argument not a Player instance.")
end

function verifyString(value)
	if typeof(value) == "string" then
		return nil
	end

	return returnInvalidArgumentError("Argument not a string.")
end

function verifyNumber(value)
	if typeof(value) == "number" then
		return nil
	end

	return returnInvalidArgumentError("Argument not a number.")
end

function getUrlPrefix(): string
	return if RunService:IsStudio() then "user" else "rcc"
end

function createListInventoryItemsUrl(p: number, p2: number?, p3: string?, p4: string?)
	local baseUrl = ContentProvider.BaseUrl:lower()
	local v = string.gsub(baseUrl, "http:", "https:")
	local v2 = string.gsub(v, "www", "apis")
	local v3 = string.format("%s%s/cloud/v2/users/%d/inventory-items", v2, getUrlPrefix(), p)

	if p2 == nil and p3 == nil and p4 == nil then
		return v3
	end

	local v4 = {}

	if p2 ~= nil then
		table.insert(v4, string.format("maxPageSize=%d", p2))
	end

	if p3 ~= nil then
		table.insert(v4, string.format("pageToken=%s", p3))
	end

	if p4 ~= nil then
		table.insert(v4, string.format("filter=%s", p4))
	end

	return (string.format("%s?%s", v3, table.concat(v4, "&")))
end

function listInventoryItems(data)
	if data.user == nil then
		return returnInvalidArgumentError("user argument was not provided.")
	end

	local v = verifyPlayerOnServer(data.user)

	if v ~= nil then
		return v
	end

	if data.maxPageSize ~= nil then
		local v2 = verifyNumber(data.maxPageSize)

		if v2 ~= nil then
			return v2
		end
	end

	if data.pageToken ~= nil then
		local v2 = verifyString(data.pageToken)

		if v2 ~= nil then
			return v2
		end
	end

	if data.filter ~= nil then
		local v2 = verifyString(data.filter)

		if v2 ~= nil then
			return v2
		end
	end

	return OpenCloudService:HttpRequestAsync({
		["Url"] = createListInventoryItemsUrl(data.user.UserId, data.maxPageSize, data.pageToken, data.filter),
		Request_Type = "GET"
	})
end

OpenCloudService:RegisterOpenCloud("v2", "listInventoryItems", listInventoryItems)
OpenCloudService:RegistrationComplete()
