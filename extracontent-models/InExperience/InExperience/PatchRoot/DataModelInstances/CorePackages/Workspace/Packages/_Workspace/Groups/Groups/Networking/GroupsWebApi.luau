local HttpService = game:GetService("HttpService")

local Groups = script:FindFirstAncestor("Groups")
local parent = Groups.Parent

local Signals = require(parent.Signals)
local HttpStore = require(parent.HttpStore)
local Http = require(parent.Http)
require(Groups.Common.Types)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppUseAppHttpStore = SharedFlags.FFlagLuaAppUseAppHttpStore

local InternalHttpStore = require(parent.InternalHttpStore)

local GROUPS_URL = Http.Url.GROUPS_URL

local function createApiResponse(fetched) -- 6 equivalent calls inferred from this helper
	return Signals.createComputed(function(p)
		local v = fetched(p)

		if v.status == "Success" then
			local success, result = pcall(HttpService.JSONDecode, HttpService, v.response.Body)
			local v2 = {
				status = success and "Success" or "Failed",
				data = nil,
				error = nil,
				statusCode = 0
			}

			if not success then
				result = nil
			end

			v2.data = result
			v2.error = not success and "JSON parse error" or nil
			v2.statusCode = v.response.StatusCode
			return v2
		else
			if v.status ~= "Failed" then
				return { status = "Loading", data = nil, error = nil, statusCode = nil }
			end

			local response = v.response
			local v2 = {
				status = "Failed",
				data = nil,
				error = not response and "Request failed" or response.ErrorMessage,
				statusCode = 0
			}
			local statusCode

			if response then
				statusCode = response.StatusCode
			end

			v2.statusCode = statusCode
			return v2
		end
	end)
end

local GroupsWebApi = {
	GetUserGroupsWithRoles = function(p: string)
		local v = "GetUserGroupsWithRoles_" .. p
		local url = string.format("%sv1/users/%s/groups/roles?includeLocked=true", GROUPS_URL, p)

		local v2 = InternalHttpStore.GetHttpStore()

		if FFlagLuaAppUseAppHttpStore then
			v2 = HttpStore.Instance.get()
		end

		local fetched, v3 = v2.fetch(v, { Url = url, Method = "GET" })

		return createApiResponse(fetched), v3 -- inferred equivalent call
	end,
	GetPrimaryGroupRole = function(p: string)
		local v = "GetPrimaryGroupRole_" .. p
		local url = string.format("%sv1/users/%s/groups/primary/role", GROUPS_URL, p)

		local v2 = InternalHttpStore.GetHttpStore()

		if FFlagLuaAppUseAppHttpStore then
			v2 = HttpStore.Instance.get()
		end

		local fetched, v3 = v2.fetch(v, { Url = url, Method = "GET" })

		return createApiResponse(fetched), v3 -- inferred equivalent call
	end,
	GetGroupPolicies = function(groupIds)
		local clone = table.clone(groupIds)
		table.sort(clone)
		local v = "GetGroupPolicies_" .. table.concat(clone, "_")

		local url = string.format("%sv1/groups/policies", GROUPS_URL)
		local jsonEncode = HttpService:JSONEncode({ groupIds = groupIds })

		local v2 = InternalHttpStore.GetHttpStore()

		if FFlagLuaAppUseAppHttpStore then
			v2 = HttpStore.Instance.get()
		end

		local fetched, v3 = v2.fetch(v, {
			Url = url,
			Method = "POST",
			Body = jsonEncode,
			Headers = { ["Content-Type"] = "application/json" }
		})

		return createApiResponse(fetched), v3 -- inferred equivalent call
	end,
	GetGroupsMetadata = function()
		local url = string.format("%sv1/groups/metadata", GROUPS_URL)

		local v = InternalHttpStore.GetHttpStore()

		if FFlagLuaAppUseAppHttpStore then
			v = HttpStore.Instance.get()
		end

		local fetched, v2 = v.fetch("GetGroupsMetadata", { Url = url, Method = "GET" })

		return createApiResponse(fetched), v2 -- inferred equivalent call
	end,
	GetGroupRoles = function(p: string)
		local v = "GetGroupRoles_" .. p
		local url = string.format("%sv1/groups/%s/roles", GROUPS_URL, p)

		local v2 = InternalHttpStore.GetHttpStore()

		if FFlagLuaAppUseAppHttpStore then
			v2 = HttpStore.Instance.get()
		end

		local fetched, v3 = v2.fetch(v, { Url = url, Method = "GET" })

		return createApiResponse(fetched), v3 -- inferred equivalent call
	end
}

local function fetchGet(p: string, url: string)
	local v = InternalHttpStore.GetHttpStore()

	if FFlagLuaAppUseAppHttpStore then
		v = HttpStore.Instance.get()
	end

	local fetched, v2 = v.fetch(p, { Url = url, Method = "GET" })

	return createApiResponse(fetched), v2 -- inferred equivalent call
end

function GroupsWebApi.GetGroupMembers(p: string, value: string?, value2: number?)
	local v = value2 or 100

	local v2 = "GetGroupMembers_" .. p .. "_" .. (value or "") .. "_" .. tostring(v)
	local v3 = string.format("%sv2/groups/%s/users?sortOrder=Asc&limit=%d", GROUPS_URL, p, v)

	if value then
		v3 ..= "&cursor=" .. HttpService:UrlEncode(value)
	end

	return fetchGet(v2, v3)
end

function GroupsWebApi.GetGroupRoleMembers(p: string, p2: number, value: string?, value2: number?)
	local v = value2 or 100

	local v2 = "GetGroupRoleMembers_" .. p .. "_" .. tostring(p2) .. "_" .. (value or "") .. "_" .. tostring(v)
	local v3 = string.format("%sv2/groups/%s/users?roleSetId=%d&sortOrder=Asc&limit=%d", GROUPS_URL, p, p2, v)

	if value then
		v3 ..= "&cursor=" .. HttpService:UrlEncode(value)
	end

	return fetchGet(v2, v3)
end

return GroupsWebApi
