local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local function getLocalUserKey() -- line: 12
	-- upvalues: Players (copy)
	local LocalPlayer = Players.LocalPlayer

	if LocalPlayer == nil then
		return ""
	end

	return (tostring(LocalPlayer.UserId))
end
local function readLookup(s1: string) -- line: 20
	-- upvalues: AppStorageService (copy), HttpService (copy)
	local ok, result = pcall(function() -- line: 21
		-- upvalues: AppStorageService (copy), s1 (copy)
		return AppStorageService:GetItem(s1)
	end)

	if not ok or (type(result) ~= "string" or result == "") then
		return {}
	end

	local ok2, result2 = pcall(function() -- line: 27
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok2 or type(result2) ~= "table" then
		return {}
	end

	return result2
end
local function writeLookup(s2: string, t1: {[any]: any}) -- line: 36
	-- upvalues: HttpService (copy), AppStorageService (copy)
	local ok, result = pcall(function() -- line: 37
		-- upvalues: HttpService (copy), t1 (copy)
		return HttpService:JSONEncode(t1)
	end)

	if not ok or type(result) ~= "string" then
		return false
	end

	return (pcall(function() -- line: 43
		-- upvalues: AppStorageService (copy), s2 (copy), result (copy)
		AppStorageService:SetItem(s2, result)
		AppStorageService:Flush()
	end))
end

return {
	getEntry = function(s3: string) -- line: 54
		-- upvalues: Players (copy), readLookup (copy)
		local LocalPlayer = Players.LocalPlayer
		local v19 = if LocalPlayer ~= nil then tostring(LocalPlayer.UserId) else ""

		if v19 == "" then
			return {}
		end

		local v20 = readLookup(s3)[v19]

		if type(v20) == "table" then
			return v20
		end

		return {}
	end,
	updateEntry = function(s4: string, p1: ((...any) -> ...any)) -- line: 71
		-- upvalues: Players (copy), readLookup (copy), writeLookup (copy)
		local LocalPlayer = Players.LocalPlayer
		local v24 = if LocalPlayer ~= nil then tostring(LocalPlayer.UserId) else ""

		if v24 == "" then
			return
		end

		local v25 = readLookup(s4)
		local v26 = v25[v24]
		local v27 = p1(if type(v26) ~= "table" then {} else v26)

		if v27 == nil then
			return
		end

		v25[v24] = v27
		writeLookup(s4, v25)
	end
}
