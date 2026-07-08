local HttpService = game:GetService("HttpService")
local Groups = script:FindFirstAncestor("Groups")
local GroupsParent = Groups.Parent
local Signals = require(GroupsParent.Signals)
local HttpStore = require(GroupsParent.HttpStore)
local Http = require(GroupsParent.Http)

require(Groups.Common.Types)

local FFlagLuaAppUseAppHttpStore = require(GroupsParent.SharedFlags).FFlagLuaAppUseAppHttpStore
local InternalHttpStore = require(GroupsParent.InternalHttpStore)
local GROUPS_URL = Http.Url.GROUPS_URL
local t1 = {}

local function createApiResponse(p1) -- line: 46
	-- upvalues: Signals (copy), HttpService (copy)
	return Signals.createComputed(function(p2) -- line: 47
		-- upvalues: p1 (copy), HttpService (copy)
		local v38 = p1(p2)

		if v38.status == "Success" then
			local ok, result = pcall(HttpService.JSONDecode, HttpService, v38.response.Body)

			return {
				status = not ok and "Failed" or "Success",
				data = if not ok then nil else result,
				error = if ok then nil else "JSON parse error",
				statusCode = v38.response.StatusCode
			}
		end

		if v38.status == "Failed" then
			local response = v38.response

			return {
				status = "Failed",
				data = nil,
				error = not response and "Request failed" or response.ErrorMessage,
				statusCode = if not response then nil else response.StatusCode
			}
		end

		return {
			status = "Loading",
			data = nil,
			error = nil,
			statusCode = nil
		}
	end)
end

function t1.GetUserGroupsWithRoles(s1: string) -- line: 84
	-- upvalues: GROUPS_URL (copy), InternalHttpStore (copy), FFlagLuaAppUseAppHttpStore (copy), HttpStore (copy), Signals (copy), HttpService (copy)
	local v14 = "GetUserGroupsWithRoles_" .. s1
	local v15 = string.format("%sv1/users/%s/groups/roles?includeLocked=true", GROUPS_URL, s1)
	local v16 = InternalHttpStore.GetHttpStore()

	if FFlagLuaAppUseAppHttpStore then
		v16 = HttpStore.Instance.get()
	end

	local v17, v18 = v16.fetch(v14, {
		Method = "GET",
		Url = v15
	})

	return Signals.createComputed(function(p3) -- line: 47
		-- upvalues: v17 (copy), HttpService (copy)
		local v43 = v17(p3)

		if v43.status == "Success" then
			local ok, result = pcall(HttpService.JSONDecode, HttpService, v43.response.Body)

			return {
				status = not ok and "Failed" or "Success",
				data = if not ok then nil else result,
				error = if ok then nil else "JSON parse error",
				statusCode = v43.response.StatusCode
			}
		end

		if v43.status == "Failed" then
			local response = v43.response

			return {
				status = "Failed",
				data = nil,
				error = not response and "Request failed" or response.ErrorMessage,
				statusCode = if not response then nil else response.StatusCode
			}
		end

		return {
			status = "Loading",
			data = nil,
			error = nil,
			statusCode = nil
		}
	end), v18
end
function t1.GetPrimaryGroupRole(s2: string) -- line: 109
	-- upvalues: GROUPS_URL (copy), InternalHttpStore (copy), FFlagLuaAppUseAppHttpStore (copy), HttpStore (copy), Signals (copy), HttpService (copy)
	local v20 = "GetPrimaryGroupRole_" .. s2
	local v21 = string.format("%sv1/users/%s/groups/primary/role", GROUPS_URL, s2)
	local v22 = InternalHttpStore.GetHttpStore()

	if FFlagLuaAppUseAppHttpStore then
		v22 = HttpStore.Instance.get()
	end

	local v23, v24 = v22.fetch(v20, {
		Method = "GET",
		Url = v21
	})

	return Signals.createComputed(function(p4) -- line: 47
		-- upvalues: v23 (copy), HttpService (copy)
		local v48 = v23(p4)

		if v48.status == "Success" then
			local ok, result = pcall(HttpService.JSONDecode, HttpService, v48.response.Body)

			return {
				status = not ok and "Failed" or "Success",
				data = if not ok then nil else result,
				error = if ok then nil else "JSON parse error",
				statusCode = v48.response.StatusCode
			}
		end

		if v48.status == "Failed" then
			local response = v48.response

			return {
				status = "Failed",
				data = nil,
				error = not response and "Request failed" or response.ErrorMessage,
				statusCode = if not response then nil else response.StatusCode
			}
		end

		return {
			status = "Loading",
			data = nil,
			error = nil,
			statusCode = nil
		}
	end), v24
end
function t1.GetGroupPolicies(t2: {[any]: any}) -- line: 134
	-- upvalues: GROUPS_URL (copy), HttpService (copy), InternalHttpStore (copy), FFlagLuaAppUseAppHttpStore (copy), HttpStore (copy), Signals (copy)
	local v26 = table.clone(t2)

	table.sort(v26)

	local v27 = "GetGroupPolicies_" .. table.concat(v26, "_")
	local v28 = string.format("%sv1/groups/policies", GROUPS_URL)
	local json = HttpService:JSONEncode({
		groupIds = t2
	})
	local v30 = InternalHttpStore.GetHttpStore()

	if FFlagLuaAppUseAppHttpStore then
		v30 = HttpStore.Instance.get()
	end

	local v31, v32 = v30.fetch(v27, {
		Method = "POST",
		Url = v28,
		Body = json,
		Headers = {
			["Content-Type"] = "application/json"
		}
	})

	return Signals.createComputed(function(p5) -- line: 47
		-- upvalues: v31 (copy), HttpService (copy)
		local v53 = v31(p5)

		if v53.status == "Success" then
			local ok, result = pcall(HttpService.JSONDecode, HttpService, v53.response.Body)

			return {
				status = not ok and "Failed" or "Success",
				data = if not ok then nil else result,
				error = if ok then nil else "JSON parse error",
				statusCode = v53.response.StatusCode
			}
		end

		if v53.status == "Failed" then
			local response = v53.response

			return {
				status = "Failed",
				data = nil,
				error = not response and "Request failed" or response.ErrorMessage,
				statusCode = if not response then nil else response.StatusCode
			}
		end

		return {
			status = "Loading",
			data = nil,
			error = nil,
			statusCode = nil
		}
	end), v32
end
function t1.GetGroupsMetadata() -- line: 166
	-- upvalues: GROUPS_URL (copy), InternalHttpStore (copy), FFlagLuaAppUseAppHttpStore (copy), HttpStore (copy), Signals (copy), HttpService (copy)
	local v33 = string.format("%sv1/groups/metadata", GROUPS_URL)
	local v34 = InternalHttpStore.GetHttpStore()

	if FFlagLuaAppUseAppHttpStore then
		v34 = HttpStore.Instance.get()
	end

	local v35, v36 = v34.fetch("GetGroupsMetadata", {
		Method = "GET",
		Url = v33
	})

	return Signals.createComputed(function(p6) -- line: 47
		-- upvalues: v35 (copy), HttpService (copy)
		local v58 = v35(p6)

		if v58.status == "Success" then
			local ok, result = pcall(HttpService.JSONDecode, HttpService, v58.response.Body)

			return {
				status = not ok and "Failed" or "Success",
				data = if not ok then nil else result,
				error = if ok then nil else "JSON parse error",
				statusCode = v58.response.StatusCode
			}
		end

		if v58.status == "Failed" then
			local response = v58.response

			return {
				status = "Failed",
				data = nil,
				error = not response and "Request failed" or response.ErrorMessage,
				statusCode = if not response then nil else response.StatusCode
			}
		end

		return {
			status = "Loading",
			data = nil,
			error = nil,
			statusCode = nil
		}
	end), v36
end

return t1
