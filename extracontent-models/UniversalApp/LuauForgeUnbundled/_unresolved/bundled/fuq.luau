local HttpService = game:GetService("HttpService")

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger

local set = {}

for k, key in require("@luauforge/bundled/fup").Keys do
	set[key] = true
end

local function isValidTheme(value): boolean
	return type(value) == "string" and set[value] == true
end

local function resolveService(p2)
	if p2 then
		return p2
	end

	local success, result = pcall(function()
		return game:GetService("AppStorageService")
	end)

	if success then
		return result
	end

	return nil
end

local function decodeMap(result)
	if not result then
		local success
		success, result = pcall(function()
			return game:GetService("AppStorageService")
		end)

		if not success then
			result = nil
		end
	end

	if not result then
		return {}
	end

	local success, result2 = pcall(function()
		return result:GetItem("UserIdToAccountThemeMap")
	end)

	if not success or result2 == nil or result2 == "" then
		return {}
	end

	local success2, result3 = pcall(function()
		return HttpService:JSONDecode(result2)
	end)

	if success2 and type(result3) == "table" then
		return result3
	end

	return {}
end

return {
	getPersistedAccountTheme = function(p2, p3)
		if p2 == nil or p2 <= 0 then
			return nil
		end

		local v5 = decodeMap(p3)[tostring(p2)]
		local v6 = type(v5) == "string" and set[v5] == true

		if v6 then
			return v5
		end

		return nil
	end,
	setPersistedAccountTheme = function(p2, value, result)
		if p2 == nil or p2 <= 0 then
			return
		end

		local v5 = type(value) == "string" and set[value] == true

		if not v5 then
			logger:warning("[RobloxPlusTheme] Ignoring persist of invalid account theme: " .. tostring(value))
			return
		end

		local v6 = decodeMap(result)

		if v6[tostring(p2)] == value then
			return
		end

		v6[tostring(p2)] = value

		local success, result2 = pcall(function()
			return HttpService:JSONEncode(v6)
		end)

		if not success then
			logger:warning("[RobloxPlusTheme] Failed to encode persisted account theme map")
			return
		end

		if not result then
			local success2
			success2, result = pcall(function()
				return game:GetService("AppStorageService")
			end)

			if not success2 then
				result = nil
			end
		end

		if not result then
			return
		end

		pcall(function()
			result:SetItem("UserIdToAccountThemeMap", result2)
			result:flush()
		end)
	end
}
