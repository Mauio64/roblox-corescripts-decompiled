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

local function createApiResponse(p1) -- line: 48
	-- upvalues: Signals (copy), HttpService (copy)
	return Signals.createComputed(function(p2) -- line: 49
		-- upvalues: p1 (copy), HttpService (copy)
		local v64 = p1(p2)

		if v64.status == "Success" then
			local ok, result = pcall(HttpService.JSONDecode, HttpService, v64.response.Body)

			return {
				status = not ok and "Failed" or "Success",
				data = if not ok then nil else result,
				error = if ok then nil else "JSON parse error",
				statusCode = v64.response.StatusCode
			}
		end

		if v64.status == "Failed" then
			local response = v64.response

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

function t1.GetUserGroupsWithRoles(s1: string) -- line: 86
	-- upvalues: GROUPS_URL (copy), InternalHttpStore (copy), FFlagLuaAppUseAppHttpStore (copy), HttpStore (copy), Signals (copy), HttpService (copy)
	local v15 = "GetUserGroupsWithRoles_" .. s1
	local v16 = string.format("%sv1/users/%s/groups/roles?includeLocked=true", GROUPS_URL, s1)
	local v17 = InternalHttpStore.GetHttpStore()

	if FFlagLuaAppUseAppHttpStore then
		v17 = HttpStore.Instance.get()
	end

	local v18, v19 = v17.fetch(v15, {
		Method = "GET",
		Url = v16
	})

	return Signals.createComputed(function(p3) -- line: 49
		-- upvalues: v18 (copy), HttpService (copy)
		local v69 = v18(p3)

		if v69.status == "Success" then
			local ok, result = pcall(HttpService.JSONDecode, HttpService, v69.response.Body)

			return {
				status = not ok and "Failed" or "Success",
				data = if not ok then nil else result,
				error = if ok then nil else "JSON parse error",
				statusCode = v69.response.StatusCode
			}
		end

		if v69.status == "Failed" then
			local response = v69.response

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
	end), v19
end
function t1.GetPrimaryGroupRole(s2: string) -- line: 111
	-- upvalues: GROUPS_URL (copy), InternalHttpStore (copy), FFlagLuaAppUseAppHttpStore (copy), HttpStore (copy), Signals (copy), HttpService (copy)
	local v21 = "GetPrimaryGroupRole_" .. s2
	local v22 = string.format("%sv1/users/%s/groups/primary/role", GROUPS_URL, s2)
	local v23 = InternalHttpStore.GetHttpStore()

	if FFlagLuaAppUseAppHttpStore then
		v23 = HttpStore.Instance.get()
	end

	local v24, v25 = v23.fetch(v21, {
		Method = "GET",
		Url = v22
	})

	return Signals.createComputed(function(p4) -- line: 49
		-- upvalues: v24 (copy), HttpService (copy)
		local v74 = v24(p4)

		if v74.status == "Success" then
			local ok, result = pcall(HttpService.JSONDecode, HttpService, v74.response.Body)

			return {
				status = not ok and "Failed" or "Success",
				data = if not ok then nil else result,
				error = if ok then nil else "JSON parse error",
				statusCode = v74.response.StatusCode
			}
		end

		if v74.status == "Failed" then
			local response = v74.response

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
	end), v25
end
function t1.GetGroupPolicies(t2: {[any]: any}) -- line: 136
	-- upvalues: GROUPS_URL (copy), HttpService (copy), InternalHttpStore (copy), FFlagLuaAppUseAppHttpStore (copy), HttpStore (copy), Signals (copy)
	local v27 = table.clone(t2)

	table.sort(v27)

	local v28 = "GetGroupPolicies_" .. table.concat(v27, "_")
	local v29 = string.format("%sv1/groups/policies", GROUPS_URL)
	local json = HttpService:JSONEncode({
		groupIds = t2
	})
	local v31 = InternalHttpStore.GetHttpStore()

	if FFlagLuaAppUseAppHttpStore then
		v31 = HttpStore.Instance.get()
	end

	local v32, v33 = v31.fetch(v28, {
		Method = "POST",
		Url = v29,
		Body = json,
		Headers = {
			["Content-Type"] = "application/json"
		}
	})

	return Signals.createComputed(function(p5) -- line: 49
		-- upvalues: v32 (copy), HttpService (copy)
		local v79 = v32(p5)

		if v79.status == "Success" then
			local ok, result = pcall(HttpService.JSONDecode, HttpService, v79.response.Body)

			return {
				status = not ok and "Failed" or "Success",
				data = if not ok then nil else result,
				error = if ok then nil else "JSON parse error",
				statusCode = v79.response.StatusCode
			}
		end

		if v79.status == "Failed" then
			local response = v79.response

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
	end), v33
end
function t1.GetGroupsMetadata() -- line: 168
	-- upvalues: GROUPS_URL (copy), InternalHttpStore (copy), FFlagLuaAppUseAppHttpStore (copy), HttpStore (copy), Signals (copy), HttpService (copy)
	local v34 = string.format("%sv1/groups/metadata", GROUPS_URL)
	local v35 = InternalHttpStore.GetHttpStore()

	if FFlagLuaAppUseAppHttpStore then
		v35 = HttpStore.Instance.get()
	end

	local v36, v37 = v35.fetch("GetGroupsMetadata", {
		Method = "GET",
		Url = v34
	})

	return Signals.createComputed(function(p6) -- line: 49
		-- upvalues: v36 (copy), HttpService (copy)
		local v84 = v36(p6)

		if v84.status == "Success" then
			local ok, result = pcall(HttpService.JSONDecode, HttpService, v84.response.Body)

			return {
				status = not ok and "Failed" or "Success",
				data = if not ok then nil else result,
				error = if ok then nil else "JSON parse error",
				statusCode = v84.response.StatusCode
			}
		end

		if v84.status == "Failed" then
			local response = v84.response

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
	end), v37
end
function t1.GetGroupRoles(s3: string) -- line: 184
	-- upvalues: GROUPS_URL (copy), InternalHttpStore (copy), FFlagLuaAppUseAppHttpStore (copy), HttpStore (copy), Signals (copy), HttpService (copy)
	local v39 = "GetGroupRoles_" .. s3
	local v40 = string.format("%sv1/groups/%s/roles", GROUPS_URL, s3)
	local v41 = InternalHttpStore.GetHttpStore()

	if FFlagLuaAppUseAppHttpStore then
		v41 = HttpStore.Instance.get()
	end

	local v42, v43 = v41.fetch(v39, {
		Method = "GET",
		Url = v40
	})

	return Signals.createComputed(function(p7) -- line: 49
		-- upvalues: v42 (copy), HttpService (copy)
		local v89 = v42(p7)

		if v89.status == "Success" then
			local ok, result = pcall(HttpService.JSONDecode, HttpService, v89.response.Body)

			return {
				status = not ok and "Failed" or "Success",
				data = if not ok then nil else result,
				error = if ok then nil else "JSON parse error",
				statusCode = v89.response.StatusCode
			}
		end

		if v89.status == "Failed" then
			local response = v89.response

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
	end), v43
end

local function fetchGet(s4: string, s5: string) -- line: 200
	-- upvalues: InternalHttpStore (copy), FFlagLuaAppUseAppHttpStore (copy), HttpStore (copy), Signals (copy), HttpService (copy)
	local v46 = InternalHttpStore.GetHttpStore()

	if FFlagLuaAppUseAppHttpStore then
		v46 = HttpStore.Instance.get()
	end

	local v47, v48 = v46.fetch(s4, {
		Method = "GET",
		Url = s5
	})

	return Signals.createComputed(function(p8) -- line: 49
		-- upvalues: v47 (copy), HttpService (copy)
		local v94 = v47(p8)

		if v94.status == "Success" then
			local ok, result = pcall(HttpService.JSONDecode, HttpService, v94.response.Body)

			return {
				status = not ok and "Failed" or "Success",
				data = if not ok then nil else result,
				error = if ok then nil else "JSON parse error",
				statusCode = v94.response.StatusCode
			}
		end

		if v94.status == "Failed" then
			local response = v94.response

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
	end), v48
end

function t1.GetGroupMembers(s6: string, s7: string?, n1: number?) -- line: 215
	-- upvalues: GROUPS_URL (copy), HttpService (copy), fetchGet (copy)
	local v52 = n1 or 100
	local v53 = "GetGroupMembers_" .. s6 .. "_" .. (s7 or "") .. "_" .. tostring(v52)
	local v54 = string.format("%sv1/groups/%s/users?sortOrder=Asc&limit=%d", GROUPS_URL, s6, v52)

	if s7 then
		v54 ..= "&cursor=" .. HttpService:UrlEncode(s7)
	end

	return fetchGet(v53, v54)
end
function t1.GetGroupRoleMembers(s8: string, n2: number, s9: string?, n3: number?) -- line: 230
	-- upvalues: GROUPS_URL (copy), HttpService (copy), fetchGet (copy)
	local v59 = n3 or 100
	local v60 = s9 or ""
	local v61 = "GetGroupRoleMembers_" .. s8 .. "_" .. tostring(n2) .. "_" .. v60 .. "_" .. tostring(v59)
	local v62 = string.format("%sv1/groups/%s/roles/%d/users?sortOrder=Asc&limit=%d", GROUPS_URL, s8, n2, v59)

	if s9 then
		v62 ..= "&cursor=" .. HttpService:UrlEncode(s9)
	end

	return fetchGet(v61, v62)
end

return t1
