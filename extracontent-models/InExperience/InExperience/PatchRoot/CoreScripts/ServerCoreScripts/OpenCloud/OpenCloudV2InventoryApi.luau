local ContentProvider = game:GetService("ContentProvider")
local HttpService = game:GetService("HttpService")
local OpenCloudService = game:GetService("OpenCloudService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

function returnInvalidArgumentError(s1: string) -- line: 23
	-- upvalues: HttpService (copy)
	return {
		StatusCode = 400,
		Body = HttpService:JSONEncode({
			code = "INVALID_ARGUMENT",
			message = s1
		})
	}
end
function verifyPlayerOnServer(p1) -- line: 33
	-- upvalues: Players (copy)
	local v8 = verifyPlayer(p1)

	if v8 ~= nil then
		return v8
	end

	local players = Players:GetPlayers()

	for _, v in ipairs(players) do
		if v.UserId == p1.UserId then
			return nil
		end
	end

	return returnInvalidArgumentError("Player not found on server.")
end
function verifyPlayer(p2) -- line: 49
	if typeof(p2) ~= "Instance" or p2.ClassName ~= "Player" then
		return returnInvalidArgumentError("user argument not a Player instance.")
	end

	return nil
end
function verifyString(p3) -- line: 56
	if typeof(p3) ~= "string" then
		return returnInvalidArgumentError("Argument not a string.")
	end

	return nil
end
function verifyNumber(p4) -- line: 63
	if typeof(p4) ~= "number" then
		return returnInvalidArgumentError("Argument not a number.")
	end

	return nil
end
function getUrlPrefix() -- line: 70
	-- upvalues: RunService (copy)
	if RunService:IsStudio() then
		return "user"
	end

	return "rcc"
end
function createListInventoryItemsUrl(n1: number, n2: number?, s2: string?, s3: string?) -- line: 77
	-- upvalues: ContentProvider (copy)
	local v19 = ContentProvider.BaseUrl:lower()
	local v20 = string.gsub(v19, "http:", "https:")
	local v21 = string.gsub(v20, "www", "apis")
	local v22 = string.format("%s%s/cloud/v2/users/%d/inventory-items", v21, getUrlPrefix(), n1)

	if n2 == nil and (s2 == nil and s3 == nil) then
		return v22
	end

	local t1 = {}

	if n2 ~= nil then
		table.insert(t1, string.format("maxPageSize=%d", n2))
	end

	if s2 ~= nil then
		table.insert(t1, string.format("pageToken=%s", s2))
	end

	if s3 ~= nil then
		table.insert(t1, string.format("filter=%s", s3))
	end

	return (string.format("%s?%s", v22, table.concat(t1, "&")))
end
function listInventoryItems(p5) -- line: 102
	-- upvalues: OpenCloudService (copy)
	if p5.user == nil then
		return returnInvalidArgumentError("user argument was not provided.")
	end

	local v25 = verifyPlayerOnServer(p5.user)

	if v25 ~= nil then
		return v25
	end

	if p5.maxPageSize ~= nil then
		local v26 = verifyNumber(p5.maxPageSize)

		if v26 ~= nil then
			return v26
		end
	end

	if p5.pageToken ~= nil then
		local v27 = verifyString(p5.pageToken)

		if v27 ~= nil then
			return v27
		end
	end

	if p5.filter ~= nil then
		local v28 = verifyString(p5.filter)

		if v28 ~= nil then
			return v28
		end
	end

	return OpenCloudService:HttpRequestAsync({
		Url = createListInventoryItemsUrl(p5.user.UserId, p5.maxPageSize, p5.pageToken, p5.filter),
		Request_Type = "GET"
	})
end

OpenCloudService:RegisterOpenCloud("v2", "listInventoryItems", listInventoryItems)
OpenCloudService:RegistrationComplete()
