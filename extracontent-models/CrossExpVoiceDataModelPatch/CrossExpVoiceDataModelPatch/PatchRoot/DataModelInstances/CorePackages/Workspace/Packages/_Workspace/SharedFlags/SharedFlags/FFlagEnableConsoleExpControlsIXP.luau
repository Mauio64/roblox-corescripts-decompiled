local AppStorageService = game:GetService("AppStorageService")
local v2 = game:DefineFastFlag("EnableConsoleExpControlsIXP684", false)
local _ = {
	HAMBURGER = "hamburger",
	SUBMENU = "submenu"
}
local ok, result = pcall(function() -- line: 12
	-- upvalues: AppStorageService (copy)
	return AppStorageService:GetItem("ExperienceMenuVersion")
end)

if ok and (result == "hamburger" or result == "submenu") then
	return v2
end

return false
