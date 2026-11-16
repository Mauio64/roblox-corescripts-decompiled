local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("DataHydration").Parent

local Http = require(parent.Http)
local HttpClient = require(parent.HttpClient)
local Promise = require(parent.Promise)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed

local function nonEmptyString(value) -- 4 equivalent calls inferred from this helper
	if type(value) == "string" and value ~= "" then
		return value
	end

	return nil
end

local function normalizeLookByOutfit(p)
	if type(p) ~= "table" then
		return nil, `Type table required, got {type(p)}.`
	end

	if type(p.look) ~= "table" then
		return {}, "look normalization failed with: \"look\" is absent or not a table"
	end

	local look = p.look
	local lookId = look.lookId

	if type(lookId) ~= "string" then
		return nil, "look normalization failed with: required field \"lookId\" is absent or not a string"
	end

	local look2

	if FFlagMomentsRenderAvatarPostsInFeed then
		look2 = table.clone(look)
		look2.lookId = lookId
		local outfitId

		if type(look.outfitId) == "number" then
			outfitId = look.outfitId
		end

		look2.outfitId = outfitId
		look2.name = nonEmptyString(look.name) -- inferred equivalent call
		look2.description = nonEmptyString(look.description) -- inferred equivalent call
		local totalPrice

		if type(look.totalPrice) == "number" then
			totalPrice = look.totalPrice
		end

		look2.totalPrice = totalPrice
		look2.items = type(look.items) ~= "table" and {} or look.items
		look2.itemCount = #look2.items
	else
		look2 = {
			lookId = lookId,
			outfitId = 0,
			name = 0,
			description = 0,
			totalPrice = 0,
			itemCount = 0
		}
		local outfitId

		if type(look.outfitId) == "number" then
			outfitId = look.outfitId
		end

		look2.outfitId = outfitId
		look2.name = nonEmptyString(look.name) -- inferred equivalent call
		look2.description = nonEmptyString(look.description) -- inferred equivalent call
		local totalPrice

		if type(look.totalPrice) == "number" then
			totalPrice = look.totalPrice
		end

		look2.totalPrice = totalPrice
		look2.itemCount = type(look.items) == "table" and #look.items or 0
	end

	return { look = look2 }, nil
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
		local _, v = string.find(data.errorMessage, "^http %d+: ")

		if v then
			result = string.sub(data.errorMessage, v + 1)
		end
	end

	if type(result) == "string" then
		local success
		success, result = pcall(HttpService.JSONDecode, HttpService, result)

		if not success then
			result = nil
		end
	end

	return type(result) == "table" and result.errorCode == 98
end

local function fetchLookByOutfit(p: number, options)
	local v = options or {}
	local baseUrl = v.baseUrl or Http.Url.APIS_URL

	local fetched = HttpClient.fetch({
		network = v.network,
		method = "GET",
		url = baseUrl .. "look-api/v2/looks/by-outfit/" .. tostring(p),
		analyticsKey = "look-api.get-by-outfit",
		decode = function(p2)
			local lookByOutfit, _ = normalizeLookByOutfit(p2)
			return lookByOutfit or {}
		end
	})

	return HttpClient.asPromise(fetched):catch(function(p2)
		if isLookNotFound(p2) then
			return {}
		end

		return Promise.reject(p2)
	end)
end

return fetchLookByOutfit
