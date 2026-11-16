local parent = script:FindFirstAncestor("FriendsChat").Parent

local UserProfiles = require(parent.UserProfiles)
local UserProfileStore = UserProfiles.Stores.UserProfileStore

require(script.Parent.NameInfo)

local function resolveProfileNameInfo(p, p2)
	if p == nil or p.names == nil then
		return { name = nil, username = nil }
	end

	local getCombinedName = p.names.getCombinedName
	local getDisplayName = p.names.getDisplayName
	local getUsername = p.names.getUsername
	local username

	if getUsername then
		username = getUsername(p2)
	end

	local v

	if getCombinedName then
		v = getCombinedName(p2)
	end

	local name

	if getDisplayName then
		name = getDisplayName(p2)
	end

	if v == nil or v == "" then
		if name == nil or name == "" then
			name = username
		end
	else
		name = v
	end

	return { name = name, username = username }
end

local function resolveNameInfos(items, p)
	local set = {}
	local v = {}

	local v2 = {}

	for _, item in items do
		if set[item] then
			continue
		end

		set[item] = true
		table.insert(v, item)
		table.insert(v2, (tostring(item)))
	end

	local v3 = UserProfileStore.get().fetchNamesByUserIds(v2)(p)
	local v4 = not (v3 and v3.data) and {} or v3.data

	local nameInfos = {}

	for k, v5 in v do
		nameInfos[v5] = resolveProfileNameInfo(v4[k], p)
	end

	return nameInfos
end

return resolveNameInfos
