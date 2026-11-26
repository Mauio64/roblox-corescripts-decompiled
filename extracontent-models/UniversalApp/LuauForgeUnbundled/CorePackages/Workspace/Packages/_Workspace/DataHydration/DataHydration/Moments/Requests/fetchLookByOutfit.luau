local HttpService = game:GetService("HttpService")

local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local fFlagMomentsRenderAvatarPostsInFeed = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagMomentsRenderAvatarPostsInFeed

local function nonEmptyString(value)
	if type(value) == "string" and value ~= "" then
		return value
	end

	return nil
end

local function normalizeLookByOutfit(p2)
	if type(p2) ~= "table" then
		return nil, `Type table required, got {type(p2)}.`
	end

	if type(p2.look) ~= "table" then
		return {}, "look normalization failed with: \"look\" is absent or not a table"
	end

	local look = p2.look
	local lookId = look.lookId

	if type(lookId) ~= "string" then
		return nil, "look normalization failed with: required field \"lookId\" is absent or not a string"
	end

	local v5

	if fFlagMomentsRenderAvatarPostsInFeed then
		v5 = table.clone(look)
		v5.lookId = lookId
		local v6 = if type(look.outfitId) == "number" then look.outfitId else nil
		v5.outfitId = v6
		local name = look.name

		if type(name) ~= "string" or name == "" then
			name = nil
		end

		v5.name = name
		local description = look.description

		if type(description) ~= "string" or description == "" then
			description = nil
		end

		v5.description = description
		local v7 = if type(look.totalPrice) == "number" then look.totalPrice else nil
		v5.totalPrice = v7
		v5.items = type(look.items) ~= "table" and {} or look.items
		v5.itemCount = #v5.items
	else
		v5 = {
			lookId = lookId,
			outfitId = 0,
			name = 0,
			description = 0,
			totalPrice = 0,
			itemCount = 0
		}

		local v6 = if type(look.outfitId) == "number" then look.outfitId else nil
		v5.outfitId = v6
		local name = look.name

		if type(name) ~= "string" or name == "" then
			name = nil
		end

		v5.name = name
		local description = look.description

		if type(description) ~= "string" or description == "" then
			description = nil
		end

		v5.description = description
		local v7 = if type(look.totalPrice) == "number" then look.totalPrice else nil
		v5.totalPrice = v7
		v5.itemCount = type(look.items) == "table" and #look.items or 0
	end

	return { look = v5 }, nil
end

local function isLookNotFound(data): boolean
	if not (type(data) == "table" and data.responseCode == 400) then
		return false
	end

	local result = nil
	local response = data.response

	if type(response) == "table" then
		result = response.responseBody
	elseif type(data.errorMessage) == "string" then
		local v5, v6 = string.find(data.errorMessage, "^http %d+: ")

		if v6 then
			result = string.sub(data.errorMessage, v6 + 1)
		end
	end

	if (type)(result) == "string" then
		local success
		success, result = pcall(HttpService.JSONDecode, HttpService, result)

		if not success then
			result = nil
		end
	end

	return (type)(result) == "table" and result.errorCode == 98
end

local function fetchLookByOutfit(p2, options)
	local v5 = options or {}
	local baseUrl = v5.baseUrl or Http.Url.APIS_URL

	local fetched = HttpClient.fetch({
		network = v5.network,
		method = "GET",
		url = baseUrl .. "look-api/v2/looks/by-outfit/" .. tostring(p2),
		analyticsKey = "look-api.get-by-outfit",
		decode = function(p3)
			local lookByOutfit, v6 = normalizeLookByOutfit(p3)
			return lookByOutfit or {}
		end
	})

	return HttpClient.asPromise(fetched):catch(function(p3)
		if isLookNotFound(p3) then
			return {}
		end

		return Promise.reject(p3)
	end)
end

return fetchLookByOutfit
