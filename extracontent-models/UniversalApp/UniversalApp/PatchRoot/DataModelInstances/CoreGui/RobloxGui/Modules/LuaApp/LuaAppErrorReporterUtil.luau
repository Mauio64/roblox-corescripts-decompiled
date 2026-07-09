local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local ContentProvider = game:GetService("ContentProvider")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local MemStorageService = game:GetService("MemStorageService")
local AppStorageService = game:GetService("AppStorageService")
local Modules = CoreGui.RobloxGui.Modules
local safeCall = require(Modules.LuaApp.Util.safeCall)
local v10 = game:DefineFastFlag("LuaAppErrorReportCountryCode", false)
local SystemInfoProtocol = require(CorePackages.Workspace.Packages.SystemInfoProtocol).SystemInfoProtocol
local LocalStorageKey = require(CorePackages.Workspace.Packages.LocalStorage).Enums.LocalStorageKey
local t1 = {}
local u14 = nil

function t1.getAppStaticAttributes() -- line: 23
	-- upvalues: safeCall (copy), RunService (copy), HttpService (copy), ContentProvider (copy), MemStorageService (copy), AppStorageService (copy), LocalStorageKey (copy), SystemInfoProtocol (copy)
	return safeCall(function() -- line: 24
		-- upvalues: RunService (copy), HttpService (copy), ContentProvider (copy), MemStorageService (copy), AppStorageService (copy), LocalStorageKey (copy), SystemInfoProtocol (copy)
		local t2 = {
			AppVersion = RunService:GetRobloxVersion(),
			UserAgent = HttpService:GetUserAgent(),
			BaseUrl = ContentProvider.BaseUrl,
			WindowsLaunchType = MemStorageService:GetItem("Backtrace.WindowsLaunchType"),
			CoreScriptVersion = RunService:GetCoreScriptVersion(),
			AppInstallationId = AppStorageService:GetItem(LocalStorageKey.AppInstallationId),
			RobloxChannel = RunService:GetRobloxClientChannel()
		}
		local v18, v19 = RunService:GetControlAndVariantRolloutFlags()

		if v18 ~= nil and v18 ~= "" then
			t2.RolloutFlagsInControl = v18
		end

		if v19 ~= nil and v19 ~= "" then
			t2.RolloutFlagsInVariant = v19
		end

		local ok, result = pcall(function() -- line: 43
			-- upvalues: SystemInfoProtocol (copy)
			return SystemInfoProtocol.default:getSystemInfo(SystemInfoProtocol.ALL_INFO_NAMES)
		end)

		if ok and typeof(result) == "table" then
			for k, v in pairs(result) do
				t2[k] = v
			end
		end

		return t2
	end, {})
end
function t1.getCountryCode() -- line: 65
	-- upvalues: AppStorageService (copy), LocalStorageKey (copy)
	local Item = AppStorageService:GetItem(LocalStorageKey.CountryCode)

	if Item ~= nil and string.len(Item) > 0 then
		return Item
	end

	return "Unknown"
end
function t1.processReport(p1) -- line: 83
	-- upvalues: u14 (ref), t1 (copy), v10 (copy)
	if not u14 then
		u14 = t1.getAppStaticAttributes()
	end

	p1:addAttributes({
		AppRunningTime = string.format("%.02f", elapsedTime()),
		CountryCode = if not v10 then nil else t1.getCountryCode()
	})
	p1:addAttributes(u14)

	return p1
end

return t1
