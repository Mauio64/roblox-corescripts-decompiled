local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local FStringArgusApiUrlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/FStringArgusApiUrlBase")

local function normalizeBaseUrl(value)
	if value:sub(#value) == "/" then
		return value:sub(1, #value - 1)
	end

	return value
end

local function normalizePath(value)
	if value:sub(1, 1) == "/" then
		return value
	end

	return `/{value}`
end

local function getFStringApiUrlBase()
	local v5 = FStringArgusApiUrlBase()

	if v5 == "" then
		return nil
	end

	if v5:sub(#v5) == "/" then
		v5 = v5:sub(1, #v5 - 1)
	end

	if v5:match("^https?://") == nil then
		return nil
	end

	return v5
end

local function constructApiUrl(value)
	assert(type(value) == "string", "path must be a string")
	local Players = game:GetService("Players")
	local localPlayer = Players.LocalPlayer
	local v5 = FStringArgusApiUrlBase()

	if v5 == "" then
		v5 = nil
	else
		if v5:sub(#v5) == "/" then
			v5 = v5:sub(1, #v5 - 1)
		end

		if v5:match("^https?://") == nil then
			v5 = nil
		end
	end

	if v5 == nil then
		v5 = Http.Url.APIS_URL
	end

	if v5:sub(#v5) == "/" then
		v5 = v5:sub(1, #v5 - 1)
	end

	local v6 = v5 == "https://apis.roblox.com"

	if value:sub(1, 1) ~= "/" then
		value = `/{value}`
	end

	local formatted = `{v5}{value}`

	if v6 or localPlayer == nil then
		return formatted, nil
	end

	return formatted, {
		["robloxctx-authenticated-userid"] = tostring(localPlayer.UserId)
	}
end

return constructApiUrl
