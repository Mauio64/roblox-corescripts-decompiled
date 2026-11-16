require("@luauforge/deferred/glu")
local module = require("@luauforge/deferred/glB")
local module2 = require("@luauforge/deferred/glC")
local itemTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/AvatarExperienceModel").Enums.ItemTypeEnum
local module3 = require("@luauforge/deferred/glD")

local v5 = {
	["roblox.com"] = true,
	["www.roblox.com"] = true,
	["web.roblox.com"] = true
}

local function invalid(p2)
	return { kind = module2.Invalid, url = p2 }
end

local function item(p2, p3, p4)
	return {
		kind = module2.Item,
		action = module.OpenItem,
		url = p2,
		itemType = p3,
		id = p4
	}
end

local function community(p2, p3)
	return {
		kind = module2.Community,
		action = module.OpenCommunity,
		url = p2,
		id = p3
	}
end

local function communityStore(p2, p3)
	return {
		kind = module2.CommunityStore,
		action = module.OpenCommunityStore,
		url = p2,
		id = p3
	}
end

local function search(p2, p3)
	return {
		kind = module2.Search,
		action = module.OpenCatalog,
		url = p2,
		query = module3(p3)
	}
end

local function parseUrl(value)
	local v6, v7 = string.match(value, "^https?://([%w%.%-]+)(.*)$")

	if v6 == nil or v7 == nil then
		return nil
	end

	local v8, v9 = string.match(v7, "^([^#]*)#?(.*)$")
	local v10, v11 = string.match(v8 or "", "^([^%?]*)%??(.*)$")

	local v12 = {}

	for k in string.gmatch(v10 or "", "[^/]+") do
		table.insert(v12, k)
	end

	return {
		host = v6,
		pathSegments = v12,
		query = v11 or "",
		fragment = v9 or ""
	}
end

local function isStoreFragment(value)
	local v6 = string.lower(value)
	local v7 = string.match(v6, "^!/store$") ~= nil
	local v8 = string.match(v6, "^!/store[%?/]") ~= nil
	return v7 or v8
end

local function isLocaleSegment(value)
	local v6 = string.lower(value)
	local v7 = string.match(v6, "^%a%a$") ~= nil
	local v8 = string.match(v6, "^%a%a%-%w%w%w?%w?$") ~= nil
	return v7 or v8
end

local function leadingId(value)
	if value == nil then
		return nil
	end

	return string.match(value, "^(%d+)")
end

local function classifyDescriptionUrl(p2)
	local v6 = parseUrl(p2)

	if v6 == nil or not v5[v6.host] then
		return { kind = module2.Invalid, url = p2 }
	end

	local pathSegments = v6.pathSegments

	if #pathSegments > 1 then
		local pathSegment = pathSegments[1]
		local v7 = string.lower(pathSegment)
		local v8 = string.match(v7, "^%a%a$") ~= nil
		local v9 = string.match(v7, "^%a%a%-%w%w%w?%w?$") ~= nil

		if v8 or v9 then
			table.remove(pathSegments, 1)
		end
	end

	local v7 = string.lower(pathSegments[1] or "")

	if v7 == "catalog" then
		if pathSegments[2] == nil then
			local query = v6.query
			return {
				kind = module2.Search,
				action = module.OpenCatalog,
				url = p2,
				query = module3(query)
			}
		end

		local pathSegment = pathSegments[2]
		local v8 = if pathSegment ~= nil then string.match(pathSegment, "^(%d+)") else nil

		if not v8 then
			return { kind = module2.Invalid, url = p2 }
		end

		local asset = itemTypeEnum.Asset
		return {
			kind = module2.Item,
			action = module.OpenItem,
			url = p2,
			itemType = asset,
			id = v8
		}
	elseif v7 == "bundles" then
		local pathSegment = pathSegments[2]
		local v8 = if pathSegment ~= nil then string.match(pathSegment, "^(%d+)") else nil

		if not v8 then
			return { kind = module2.Invalid, url = p2 }
		end

		local bundle = itemTypeEnum.Bundle
		return {
			kind = module2.Item,
			action = module.OpenItem,
			url = p2,
			itemType = bundle,
			id = v8
		}
	elseif v7 == "communities" or v7 == "groups" then
		local pathSegment = pathSegments[2]
		local v8 = if pathSegment ~= nil then string.match(pathSegment, "^(%d+)") else nil

		if v8 == nil then
			return { kind = module2.Invalid, url = p2 }
		end

		local fragment = v6.fragment
		local v9 = string.lower(fragment)
		local v10 = string.match(v9, "^!/store$") ~= nil
		local v11 = string.match(v9, "^!/store[%?/]") ~= nil

		if v10 or v11 then
			return {
				kind = module2.CommunityStore,
				action = module.OpenCommunityStore,
				url = p2,
				id = v8
			}
		end

		return {
			kind = module2.Community,
			action = module.OpenCommunity,
			url = p2,
			id = v8
		}
	else
		if v7 ~= "share" or string.lower(pathSegments[2] or "") ~= "g" then
			return { kind = module2.Invalid, url = p2 }
		end

		local pathSegment = pathSegments[3]
		local v8 = if pathSegment ~= nil then string.match(pathSegment, "^(%d+)") else nil

		if v8 then
			return {
				kind = module2.Community,
				action = module.OpenCommunity,
				url = p2,
				id = v8
			}
		end

		return { kind = module2.Invalid, url = p2 }
	end
end

return classifyDescriptionUrl
