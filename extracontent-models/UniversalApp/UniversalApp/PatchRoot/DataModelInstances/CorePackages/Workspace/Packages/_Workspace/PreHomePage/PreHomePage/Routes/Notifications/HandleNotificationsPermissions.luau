local Parent = script:FindFirstAncestor("PreHomePage").Parent
local Logger = require(Parent.Loggers).Logger
local LinkingProtocol = require(Parent.LinkingProtocol).LinkingProtocol
local Promise = require(Parent.Promise)
local FFlagDebugAlwaysShowSystemTrayModal = require(Parent.SharedFlags).FFlagDebugAlwaysShowSystemTrayModal
local EngineFeature = game:GetEngineFeature("EnableSystemTray")
local Players = game:GetService("Players")
local AppStorageService = game:GetService("AppStorageService")
local SetCentralOverlay = require(Parent.CentralOverlay).Actions.SetCentralOverlay
local CentralOverlayType = require(Parent.RobloxAppEnums).CentralOverlayType

local function handleNotificationsPermissions(_, p2, _) -- line: 26
	-- upvalues: LinkingProtocol (copy), Logger (copy), Promise (copy), EngineFeature (copy), Players (copy), FFlagDebugAlwaysShowSystemTrayModal (copy), AppStorageService (copy), SetCentralOverlay (copy), CentralOverlayType (copy)
	if LinkingProtocol:getLastLuaURL() ~= nil and LinkingProtocol:getLastLuaURL() ~= "" then
		Logger:info("Skipping notifications upsell due to deep link")

		return Promise.resolve(false)
	end

	if not EngineFeature then
		return Promise.resolve(false)
	end

	local LocalPlayer = Players.LocalPlayer

	if not LocalPlayer or not LocalPlayer:GetUnder13() then
		return Promise.resolve(false)
	end

	if FFlagDebugAlwaysShowSystemTrayModal then
		AppStorageService:SetItem("DesktopNotificationsModalShown", "false")
		AppStorageService:Flush()
	end

	local ok, result = pcall(function() -- line: 57
		-- upvalues: AppStorageService (copy)
		return AppStorageService:GetItem("DesktopNotificationsModalShown")
	end)

	if not ok or result ~= "true" then
		pcall(function() -- line: 64
			-- upvalues: AppStorageService (copy)
			AppStorageService:SetItem("DesktopNotificationsModalShown", "true")
			AppStorageService:Flush()
		end)
		p2:dispatch(SetCentralOverlay(CentralOverlayType.NotificationsModal, {}))

		return Promise.resolve(false)
	end

	return Promise.resolve(false)
end

return handleNotificationsPermissions
