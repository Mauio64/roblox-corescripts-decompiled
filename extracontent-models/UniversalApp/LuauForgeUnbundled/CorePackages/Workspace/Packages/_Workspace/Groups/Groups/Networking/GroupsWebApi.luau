local HttpService = game:GetService("HttpService")

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Signals")
local HttpStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/HttpStore")
local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Http")
require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/Types")

local fFlagLuaAppUseAppHttpStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/SharedFlags").FFlagLuaAppUseAppHttpStore

local InternalHttpStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/InternalHttpStore")

local GROUPS_URL = Http.Url.GROUPS_URL

local function createApiResponse(callback)
	return Signals.createComputed(function(p2)
		local v6 = callback(p2)

		if v6.status == "Success" then
			local success, result = pcall(HttpService.JSONDecode, HttpService, v6.response.Body)
			local v7 = {
				status = success and "Success" or "Failed",
				data = nil,
				error = nil,
				statusCode = 0
			}

			if not success then
				result = nil
			end

			v7.data = result
			v7.error = not success and "JSON parse error" or nil
			v7.statusCode = v6.response.StatusCode
			return v7
		else
			if v6.status ~= "Failed" then
				return { status = "Loading", data = nil, error = nil, statusCode = nil }
			end

			local response = v6.response
			local v7 = {
				status = "Failed",
				data = nil,
				error = not response and "Request failed" or response.ErrorMessage,
				statusCode = 0
			}
			local v8 = if response then response.StatusCode else nil
			v7.statusCode = v8
			return v7
		end
	end)
end

local v5 = {
	GetUserGroupsWithRoles = function(p2)
		local v6 = "GetUserGroupsWithRoles_" .. p2
		local v7 = string.format("%sv1/users/%s/groups/roles?includeLocked=true", GROUPS_URL, p2)

		local v8 = InternalHttpStore.GetHttpStore()

		if fFlagLuaAppUseAppHttpStore then
			v8 = HttpStore.Instance.get()
		end

		local fetched, v9 = v8.fetch(v6, { Url = v7, Method = "GET" })
		return Signals.createComputed(function(p3)
			local v10 = fetched(p3)

			if v10.status == "Success" then
				local success, result = pcall(HttpService.JSONDecode, HttpService, v10.response.Body)
				local v11 = {
					status = success and "Success" or "Failed",
					data = nil,
					error = nil,
					statusCode = 0
				}

				if not success then
					result = nil
				end

				v11.data = result
				v11.error = not success and "JSON parse error" or nil
				v11.statusCode = v10.response.StatusCode
				return v11
			else
				if v10.status ~= "Failed" then
					return {
						status = "Loading",
						data = nil,
						error = nil,
						statusCode = nil
					}
				end

				local response = v10.response
				local v11 = {
					status = "Failed",
					data = nil,
					error = not response and "Request failed" or response.ErrorMessage,
					statusCode = 0
				}
				local v12 = if response then response.StatusCode else nil
				v11.statusCode = v12
				return v11
			end
		end), v9
	end,
	GetPrimaryGroupRole = function(p2)
		local v6 = "GetPrimaryGroupRole_" .. p2
		local v7 = string.format("%sv1/users/%s/groups/primary/role", GROUPS_URL, p2)

		local v8 = InternalHttpStore.GetHttpStore()

		if fFlagLuaAppUseAppHttpStore then
			v8 = HttpStore.Instance.get()
		end

		local fetched, v9 = v8.fetch(v6, { Url = v7, Method = "GET" })
		return Signals.createComputed(function(p3)
			local v10 = fetched(p3)

			if v10.status == "Success" then
				local success, result = pcall(HttpService.JSONDecode, HttpService, v10.response.Body)
				local v11 = {
					status = success and "Success" or "Failed",
					data = nil,
					error = nil,
					statusCode = 0
				}

				if not success then
					result = nil
				end

				v11.data = result
				v11.error = not success and "JSON parse error" or nil
				v11.statusCode = v10.response.StatusCode
				return v11
			else
				if v10.status ~= "Failed" then
					return {
						status = "Loading",
						data = nil,
						error = nil,
						statusCode = nil
					}
				end

				local response = v10.response
				local v11 = {
					status = "Failed",
					data = nil,
					error = not response and "Request failed" or response.ErrorMessage,
					statusCode = 0
				}
				local v12 = if response then response.StatusCode else nil
				v11.statusCode = v12
				return v11
			end
		end), v9
	end,
	GetGroupPolicies = function(p2)
		local clone = table.clone(p2)
		table.sort(clone)
		local v6 = "GetGroupPolicies_" .. table.concat(clone, "_")

		local v7 = string.format("%sv1/groups/policies", GROUPS_URL)
		local jsonEncode = HttpService:JSONEncode({ groupIds = p2 })

		local v8 = InternalHttpStore.GetHttpStore()

		if fFlagLuaAppUseAppHttpStore then
			v8 = HttpStore.Instance.get()
		end

		local fetched, v9 = v8.fetch(v6, {
			Url = v7,
			Method = "POST",
			Body = jsonEncode,
			Headers = { ["Content-Type"] = "application/json" }
		})
		return Signals.createComputed(function(p3)
			local v10 = fetched(p3)

			if v10.status == "Success" then
				local success, result = pcall(HttpService.JSONDecode, HttpService, v10.response.Body)
				local v11 = {
					status = success and "Success" or "Failed",
					data = nil,
					error = nil,
					statusCode = 0
				}

				if not success then
					result = nil
				end

				v11.data = result
				v11.error = not success and "JSON parse error" or nil
				v11.statusCode = v10.response.StatusCode
				return v11
			else
				if v10.status ~= "Failed" then
					return {
						status = "Loading",
						data = nil,
						error = nil,
						statusCode = nil
					}
				end

				local response = v10.response
				local v11 = {
					status = "Failed",
					data = nil,
					error = not response and "Request failed" or response.ErrorMessage,
					statusCode = 0
				}
				local v12 = if response then response.StatusCode else nil
				v11.statusCode = v12
				return v11
			end
		end), v9
	end,
	GetGroupsMetadata = function()
		local v6 = string.format("%sv1/groups/metadata", GROUPS_URL)

		local v7 = InternalHttpStore.GetHttpStore()

		if fFlagLuaAppUseAppHttpStore then
			v7 = HttpStore.Instance.get()
		end

		local fetched, v8 = v7.fetch("GetGroupsMetadata", { Url = v6, Method = "GET" })
		return Signals.createComputed(function(p2)
			local v9 = fetched(p2)

			if v9.status == "Success" then
				local success, result = pcall(HttpService.JSONDecode, HttpService, v9.response.Body)
				local v10 = {
					status = success and "Success" or "Failed",
					data = nil,
					error = nil,
					statusCode = 0
				}

				if not success then
					result = nil
				end

				v10.data = result
				v10.error = not success and "JSON parse error" or nil
				v10.statusCode = v9.response.StatusCode
				return v10
			else
				if v9.status ~= "Failed" then
					return {
						status = "Loading",
						data = nil,
						error = nil,
						statusCode = nil
					}
				end

				local response = v9.response
				local v10 = {
					status = "Failed",
					data = nil,
					error = not response and "Request failed" or response.ErrorMessage,
					statusCode = 0
				}
				local v11 = if response then response.StatusCode else nil
				v10.statusCode = v11
				return v10
			end
		end), v8
	end,
	GetGroupRoles = function(p2)
		local v6 = "GetGroupRoles_" .. p2
		local v7 = string.format("%sv1/groups/%s/roles", GROUPS_URL, p2)

		local v8 = InternalHttpStore.GetHttpStore()

		if fFlagLuaAppUseAppHttpStore then
			v8 = HttpStore.Instance.get()
		end

		local fetched, v9 = v8.fetch(v6, { Url = v7, Method = "GET" })
		return Signals.createComputed(function(p3)
			local v10 = fetched(p3)

			if v10.status == "Success" then
				local success, result = pcall(HttpService.JSONDecode, HttpService, v10.response.Body)
				local v11 = {
					status = success and "Success" or "Failed",
					data = nil,
					error = nil,
					statusCode = 0
				}

				if not success then
					result = nil
				end

				v11.data = result
				v11.error = not success and "JSON parse error" or nil
				v11.statusCode = v10.response.StatusCode
				return v11
			else
				if v10.status ~= "Failed" then
					return {
						status = "Loading",
						data = nil,
						error = nil,
						statusCode = nil
					}
				end

				local response = v10.response
				local v11 = {
					status = "Failed",
					data = nil,
					error = not response and "Request failed" or response.ErrorMessage,
					statusCode = 0
				}
				local v12 = if response then response.StatusCode else nil
				v11.statusCode = v12
				return v11
			end
		end), v9
	end
}

local function fetchGet(p2, p3)
	local v6 = InternalHttpStore.GetHttpStore()

	if fFlagLuaAppUseAppHttpStore then
		v6 = HttpStore.Instance.get()
	end

	local fetched, v7 = v6.fetch(p2, { Url = p3, Method = "GET" })
	return Signals.createComputed(function(p4)
		local v8 = fetched(p4)

		if v8.status == "Success" then
			local success, result = pcall(HttpService.JSONDecode, HttpService, v8.response.Body)
			local v9 = {
				status = success and "Success" or "Failed",
				data = nil,
				error = nil,
				statusCode = 0
			}

			if not success then
				result = nil
			end

			v9.data = result
			v9.error = not success and "JSON parse error" or nil
			v9.statusCode = v8.response.StatusCode
			return v9
		else
			if v8.status ~= "Failed" then
				return { status = "Loading", data = nil, error = nil, statusCode = nil }
			end

			local response = v8.response
			local v9 = {
				status = "Failed",
				data = nil,
				error = not response and "Request failed" or response.ErrorMessage,
				statusCode = 0
			}
			local v10 = if response then response.StatusCode else nil
			v9.statusCode = v10
			return v9
		end
	end), v7
end

function v5.GetGroupMembers(p2, value, value2)
	local v6 = value2 or 100

	local v7 = "GetGroupMembers_" .. p2 .. "_" .. (value or "") .. "_" .. tostring(v6)
	local v8 = string.format("%sv2/groups/%s/users?sortOrder=Asc&limit=%d", GROUPS_URL, p2, v6)

	if value then
		v8 ..= "&cursor=" .. HttpService:UrlEncode(value)
	end

	return fetchGet(v7, v8)
end

function v5.GetGroupRoleMembers(p2, p3, value, value2)
	local v6 = value2 or 100

	local v7 = "GetGroupRoleMembers_" .. p2 .. "_" .. tostring(p3) .. "_" .. (value or "") .. "_" .. tostring(v6)
	local v8 = string.format(
		"%sv2/groups/%s/users?roleSetId=%d&sortOrder=Asc&limit=%d",
		GROUPS_URL,
		p2,
		p3,
		v6
	)

	if value then
		v8 ..= "&cursor=" .. HttpService:UrlEncode(value)
	end

	return fetchGet(v7, v8)
end

return v5
