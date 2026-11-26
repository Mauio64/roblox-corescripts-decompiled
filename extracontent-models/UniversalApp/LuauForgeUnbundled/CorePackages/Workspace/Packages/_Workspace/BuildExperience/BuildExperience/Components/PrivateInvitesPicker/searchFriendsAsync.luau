local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/HttpClient")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Promise")
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/UrlBuilder").UrlBase

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function searchFriendsAsync(p2, p3, value, p4)
	if p4 == nil then
		local localPlayer = Players.LocalPlayer

		if localPlayer == nil then
			return Promise.reject("searchFriendsAsync: no local player")
		end

		p4 = localPlayer.UserId
	end

	local v5 = string.format(
		"%s/users/%d/friends/search?query=%s&limit=%d",
		urlBase.FRIENDS,
		p4,
		HttpService:UrlEncode(p2),
		value or 20
	)

	if p3 ~= nil and p3 ~= "" then
		v5 = string.format("%s&cursor=%s", v5, HttpService:UrlEncode(p3))
	end

	return asPromise((fetch({
		method = "GET",
		url = v5,
		analyticsKey = "build-experience.friends-search",
		decode = function(p5)
			return p5
		end
	}))):andThen(function(p5)
		local ids = {}

		for k, v6 in p5 and p5.PageItems or {} do
			local id = if v6.id ~= nil then tonumber(v6.id) else nil

			if id ~= nil then
				table.insert(ids, id)
			end
		end

		local nextCursor = p5 and p5.NextCursor

		if nextCursor == "" then
			nextCursor = nil
		end

		return { ids = ids, nextCursor = nextCursor }
	end)
end

return searchFriendsAsync
