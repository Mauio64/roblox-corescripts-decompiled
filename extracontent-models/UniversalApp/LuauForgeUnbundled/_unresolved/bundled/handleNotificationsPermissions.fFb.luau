local logger = require("@luauforge/bundled/fDX").Logger
local linkingProtocol = require("@luauforge/bundled/fEP").LinkingProtocol
local module = require("@luauforge/bundled/fDY")
local fFlagDebugAlwaysShowSystemTrayModal = require("@luauforge/bundled/fDZ").FFlagDebugAlwaysShowSystemTrayModal

local engineFeature = game:GetEngineFeature("EnableSystemTray")
local Players = game:GetService("Players")
local AppStorageService = game:GetService("AppStorageService")
local setCentralOverlay = require("@luauforge/bundled/fFc").Actions.SetCentralOverlay
local centralOverlayType = require("@luauforge/bundled/fEQ").CentralOverlayType

local function handleNotificationsPermissions(p2, object, p3)
	local v5 = not (linkingProtocol:getLastLuaURL() == nil) and linkingProtocol:getLastLuaURL() ~= ""

	if v5 then
		logger:info("Skipping notifications upsell due to deep link")
		return module.resolve(false)
	end

	if not engineFeature then
		return module.resolve(false)
	end

	local localPlayer = Players.LocalPlayer

	if not (localPlayer and localPlayer:GetUnder13()) then
		return module.resolve(false)
	end

	if fFlagDebugAlwaysShowSystemTrayModal then
		AppStorageService:SetItem("DesktopNotificationsModalShown", "false")
		AppStorageService:Flush()
	end

	local success, result = pcall(function()
		return AppStorageService:GetItem("DesktopNotificationsModalShown")
	end)

	if success and result == "true" then
		return module.resolve(false)
	end

	pcall(function()
		AppStorageService:SetItem("DesktopNotificationsModalShown", "true")
		AppStorageService:Flush()
	end)

	object:dispatch(setCentralOverlay(centralOverlayType.NotificationsModal, {}))
	return module.resolve(false)
end

return handleNotificationsPermissions
