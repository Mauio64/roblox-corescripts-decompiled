local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Http = require(parent.Http)
require(parent.HttpClient)
local FStringArgusApiUrlBase = require(DataHydration.Moments.FStringArgusApiUrlBase)

local function normalizeBaseUrl(value: string) -- 2 equivalent calls inferred from this helper
	if value:sub(#value) == "/" then
		return value:sub(1, #value - 1)
	end

	return value
end

local function normalizePath(value: string) -- 1 equivalent call inferred from this helper
	if value:sub(1, 1) == "/" then
		return value
	end

	return `/{value}`
end

local function getFStringApiUrlBase() -- 1 equivalent call inferred from this helper
	local fStringArgusApiUrlBase = FStringArgusApiUrlBase()

	if fStringArgusApiUrlBase == "" then
		return nil
	end

	fStringArgusApiUrlBase = normalizeBaseUrl(fStringArgusApiUrlBase) -- inferred equivalent call

	if fStringArgusApiUrlBase:match("^https?://") == nil then
		return nil
	end

	return fStringArgusApiUrlBase
end

local function constructApiUrl(value: string)
	assert(type(value) == "string", "path must be a string")
	local Players = game:GetService("Players")
	local localPlayer = Players.LocalPlayer
	local fStringApiUrlBase = getFStringApiUrlBase() -- inferred equivalent call

	if fStringApiUrlBase == nil then
		fStringApiUrlBase = Http.Url.APIS_URL
	end

	fStringApiUrlBase = normalizeBaseUrl(fStringApiUrlBase) -- inferred equivalent call
	local v = fStringApiUrlBase == "https://apis.roblox.com"
	value = normalizePath(value) -- inferred equivalent call
	local formatted = `{fStringApiUrlBase}{value}`

	if v or localPlayer == nil then
		return formatted, nil
	end

	return formatted, { ["robloxctx-authenticated-userid"] = tostring(localPlayer.UserId) }
end

return constructApiUrl
