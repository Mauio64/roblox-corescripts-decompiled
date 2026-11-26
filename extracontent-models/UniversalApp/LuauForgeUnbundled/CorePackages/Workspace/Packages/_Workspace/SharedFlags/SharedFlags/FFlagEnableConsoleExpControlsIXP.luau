local AppStorageService = game:GetService("AppStorageService")

local defineFastFlag = game:DefineFastFlag("EnableConsoleExpControlsIXP684", false)

local v5 = { HAMBURGER = "hamburger", SUBMENU = "submenu" }

local success, result = pcall(function()
	return AppStorageService:GetItem("ExperienceMenuVersion")
end)

if success and (result == "hamburger" or result == "submenu") then
	return defineFastFlag
end

return false
