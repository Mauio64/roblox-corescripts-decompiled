local parent = script:FindFirstAncestor("DataHydration").Parent

local Http = require(parent.Http)
local HttpClient = require(parent.HttpClient)

require(script.Parent.AvatarBackgroundStoreTypes)

local function parseAvatarBackground(p)
	local avatarConfigurations

	if typeof(p) == "table" then
		avatarConfigurations = p.avatarConfigurations
	end

	local background

	if typeof(avatarConfigurations) == "table" then
		background = avatarConfigurations.background
	end

	local backgroundAsset

	if typeof(background) == "table" then
		backgroundAsset = background.backgroundAsset
	end

	local id

	if typeof(backgroundAsset) == "table" then
		id = tonumber(backgroundAsset.id)
	end

	if not (id and id > 0) then
		id = nil
	end

	return { assetId = id }
end

local function fetchAvatarBackground(p: number, options)
	local v = options or {}
	local v2 = string.gsub(v.baseUrl or Http.Url.AVATAR_URL, "/$", "")
	local fetched = HttpClient.fetch({
		network = v.network,
		method = "GET",
		url = `{v2}/v4/avatar/users/{p}?selectionTypes=Background`,
		analyticsKey = "avatar.avatar-background.get",
		decode = parseAvatarBackground
	})

	return HttpClient.asPromise(fetched)
end

return fetchAvatarBackground
