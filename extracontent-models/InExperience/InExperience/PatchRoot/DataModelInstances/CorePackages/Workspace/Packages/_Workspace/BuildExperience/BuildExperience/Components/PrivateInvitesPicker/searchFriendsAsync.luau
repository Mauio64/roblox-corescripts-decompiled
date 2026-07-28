local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local HttpClient = require(Parent.HttpClient)
local Promise = require(Parent.Promise)
local UrlBase = require(Parent.UrlBuilder).UrlBase
local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function searchFriendsAsync(s1: string, s2: string?, n1: number?, n2: number?) -- line: 40
	-- upvalues: Players (copy), Promise (copy), UrlBase (copy), HttpService (copy), fetch (copy), asPromise (copy)
	if n2 == nil then
		local LocalPlayer = Players.LocalPlayer

		if LocalPlayer == nil then
			return Promise.reject("searchFriendsAsync: no local player")
		end

		n2 = LocalPlayer.UserId
	end

	local v15 = string.format("%s/users/%d/friends/search?query=%s&limit=%d", UrlBase.FRIENDS, n2, HttpService:UrlEncode(s1), n1 or 20)

	if s2 ~= nil and s2 ~= "" then
		v15 = string.format("%s&cursor=%s", v15, HttpService:UrlEncode(s2))
	end

	local v16 = fetch({
		method = "GET",
		analyticsKey = "build-experience.friends-search",
		url = v15,
		decode = function(p1) -- line: 65
			return p1
		end
	})

	return asPromise(v16):andThen(function(t1: {[any]: any}?) -- line: 70
		local t2 = {}

		for _, v21 in t1 and t1.PageItems or {} do
			local v22 = if v21.id == nil then nil else tonumber(v21.id)

			if v22 ~= nil then
				table.insert(t2, v22)
			end
		end

		local v23 = t1 and t1.NextCursor

		if v23 == "" then
			v23 = nil
		end

		return {
			ids = t2,
			nextCursor = v23
		}
	end)
end

return searchFriendsAsync
