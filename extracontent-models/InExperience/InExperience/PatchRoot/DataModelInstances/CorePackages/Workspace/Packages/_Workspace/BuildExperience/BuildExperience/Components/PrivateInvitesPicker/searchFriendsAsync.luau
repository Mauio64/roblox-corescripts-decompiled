local parent = script:FindFirstAncestor("BuildExperience").Parent

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local HttpClient = require(parent.HttpClient)
local Promise = require(parent.Promise)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function searchFriendsAsync(p: string, p2: string?, value: number?, p3: number?)
	if p3 == nil then
		local localPlayer = Players.LocalPlayer

		if localPlayer == nil then
			return Promise.reject("searchFriendsAsync: no local player")
		end

		p3 = localPlayer.UserId
	end

	local url = string.format(
		"%s/users/%d/friends/search?query=%s&limit=%d",
		UrlBase.FRIENDS,
		p3,
		HttpService:UrlEncode(p),
		value or 20
	)

	if p2 ~= nil and p2 ~= "" then
		url = string.format("%s&cursor=%s", url, HttpService:UrlEncode(p2))
	end

	return asPromise((fetch({
		method = "GET",
		url = url,
		analyticsKey = "build-experience.friends-search",
		decode = function(p4)
			return p4
		end
	}))):andThen(function(p4)
		local ids = {}

		for _, v in p4 and p4.PageItems or {} do
			local id

			if v.id ~= nil then
				id = tonumber(v.id)
			end

			if id ~= nil then
				table.insert(ids, id)
			end
		end

		local nextCursor = p4 and p4.NextCursor

		if nextCursor == "" then
			nextCursor = nil
		end

		return { ids = ids, nextCursor = nextCursor }
	end)
end

return searchFriendsAsync
