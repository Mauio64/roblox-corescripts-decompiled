local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Http = require(DataHydrationParent.Http)

require(DataHydrationParent.HttpClient)

local FStringArgusApiUrlBase = require(DataHydration.Moments.FStringArgusApiUrlBase)

local function normalizeBaseUrl(s1: string) -- line: 14
	if s1:sub(#s1) == "/" then
		return s1:sub(1, #s1 - 1)
	end

	return s1
end
local function normalizePath(s2: string) -- line: 22
	if s2:sub(1, 1) == "/" then
		return s2
	end

	return `/{ s2 }`
end
local function getFStringApiUrlBase() -- line: 30
	-- upvalues: FStringArgusApiUrlBase (copy)
	local v11 = FStringArgusApiUrlBase()

	if v11 == "" then
		return nil
	end

	local v12 = if v11:sub(#v11) ~= "/" then v11 else v11:sub(1, #v11 - 1)

	if v12:match("^https?://") == nil then
		return nil
	end

	return v12
end
local function constructApiUrl(s3: string) -- line: 44
	-- upvalues: FStringArgusApiUrlBase (copy), Http (copy)
	assert(type(s3) == "string", "path must be a string")

	local LocalPlayer = game:GetService("Players").LocalPlayer
	local v15 = FStringArgusApiUrlBase()
	local v16

	if v15 == "" then
		v16 = nil
	else
		local v17 = if v15:sub(#v15) ~= "/" then v15 else v15:sub(1, #v15 - 1)

		v16 = if v17:match("^https?://") ~= nil then v17 else nil
	end

	local v18 = if v16 == nil then Http.Url.APIS_URL else v16
	local v19 = if v18:sub(#v18) ~= "/" then v18 else v18:sub(1, #v18 - 1)
	local v20 = v19 == "https://apis.roblox.com"
	local v21 = `{ v19 }{ (if s3:sub(1, 1) ~= "/" then `/{ s3 }` else s3) }`

	if not v20 and LocalPlayer ~= nil then
		return v21, {
			["robloxctx-authenticated-userid"] = tostring(LocalPlayer.UserId)
		}
	end

	return v21, nil
end

return constructApiUrl
