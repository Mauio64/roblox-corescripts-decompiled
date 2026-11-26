local HttpService = game:GetService("HttpService")

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger
local module = require("@luauforge/bundled/fHC")

local appIcon = module.AppIcon

local function resolveService(p2)
	return p2 or game:GetService("AppStorageService")
end

local function read(p2)
	local v5 = { applied = appIcon.Default, plusActivity = {}, picks = {} }
	local v6 = p2 or game:GetService("AppStorageService")

	local success, item = pcall(v6.GetItem, v6, "CustomAppIcon")

	if not success or type(item) ~= "string" or item == "" then
		return v5
	end

	local success2, result = pcall(HttpService.JSONDecode, HttpService, item)

	if not success2 or type(result) ~= "table" then
		return v5
	end

	if module.isAppIcon(result.applied) then
		v5.applied = result.applied
	end

	if type(result.plusActivity) == "table" then
		for k, v7 in result.plusActivity do
			if not (type(k) == "string" and type(v7) == "number" and v7 > 0) then
				continue
			end

			v5.plusActivity[k] = v7
		end
	end

	if type(result.picks) ~= "table" then
		return v5
	end

	for k, pick in result.picks do
		if not (type(k) == "string" and module.isAppIcon(pick)) then
			continue
		end

		v5.picks[k] = pick
	end

	return v5
end

local function write(p2, p3)
	local v5 = p3 or game:GetService("AppStorageService")

	local success, result = pcall(function()
		v5:SetItem("CustomAppIcon", HttpService:JSONEncode(p2))
		v5:Flush()
	end)

	if not success then
		logger:warning("[AppIcon] Failed to save app icon: " .. tostring(result))
	end

	return success
end

return {
	STORAGE_KEY = "CustomAppIcon",
	getAppliedAppIcon = function(p2)
		return read(p2).applied
	end,
	setAppliedAppIcon = function(applied, p2)
		local v5 = read(p2)
		v5.applied = applied
		local v6 = p2 or game:GetService("AppStorageService")

		local success, result = pcall(function()
			v6:SetItem("CustomAppIcon", HttpService:JSONEncode(v5))
			v6:Flush()
		end)

		if not success then
			logger:warning("[AppIcon] Failed to save app icon: " .. tostring(result))
		end

		return success
	end,
	getPlusActivity = function(p2)
		return read(p2).plusActivity
	end,
	setPlusActivity = function(plusActivity, p2)
		local v5 = read(p2)
		v5.plusActivity = plusActivity
		local v6 = p2 or game:GetService("AppStorageService")

		local success, result = pcall(function()
			v6:SetItem("CustomAppIcon", HttpService:JSONEncode(v5))
			v6:Flush()
		end)

		if not success then
			logger:warning("[AppIcon] Failed to save app icon: " .. tostring(result))
		end

		return success
	end,
	getPicks = function(p2)
		return read(p2).picks
	end,
	setPick = function(p2, p3, p4)
		local v5 = read(p4)
		v5.picks[tostring(p2)] = p3
		local v6 = p4 or game:GetService("AppStorageService")

		local success, result = pcall(function()
			v6:SetItem("CustomAppIcon", HttpService:JSONEncode(v5))
			v6:Flush()
		end)

		if not success then
			logger:warning("[AppIcon] Failed to save app icon: " .. tostring(result))
		end

		return success
	end
}
