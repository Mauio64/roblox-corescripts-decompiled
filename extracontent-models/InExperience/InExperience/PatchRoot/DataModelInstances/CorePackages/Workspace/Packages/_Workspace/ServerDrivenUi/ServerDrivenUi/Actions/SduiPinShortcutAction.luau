local IXPService = game:GetService("IXPService")

local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local SharedFlags = require(parent.SharedFlags)
local FFlagPinShortcutEnableOnCompleteCallback = SharedFlags.FFlagPinShortcutEnableOnCompleteCallback
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEdpPinnedShortcutsLogExposure = SharedFlags2.FFlagEdpPinnedShortcutsLogExposure
local SharedFlags3 = require(parent.SharedFlags)
local FStringEdpPinnedShortcutsIxpLayer = SharedFlags3.FStringEdpPinnedShortcutsIxpLayer
local PinShortcut = require(parent.PinShortcut)
local pinExperienceAndNotify = PinShortcut.pinExperienceAndNotify

local PinExperienceShortcut = SduiActionType.PinExperienceShortcut

local function isPinShortcutServiceEnabled() -- 1 equivalent call inferred from this helper
	return game:GetEngineFeature("PinShortcutServiceEnabled")
end

local function SduiPinShortcutAction(p, _, p2, _)
	local actionParams

	if p then
		actionParams = p.actionParams
	end

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = PinExperienceShortcut, message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	local placeId = tonumber(actionParams.placeId)

	if placeId == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = PinExperienceShortcut, message = "Missing placeId", propName = "placeId" },
			p2.appPage
		)
		return
	end

	local universeId = tonumber(actionParams.universeId) or 0
	local gameName = actionParams.gameName or ""

	if not isPinShortcutServiceEnabled() then -- inferred equivalent call
		return
	end

	if FFlagEdpPinnedShortcutsLogExposure and game:GetEngineFeature("EnableLogFlagLinkedUserLayerExposure") then
		pcall(function()
			IXPService:LogFlagLinkedUserLayerExposure(FStringEdpPinnedShortcutsIxpLayer)
		end)
	end

	task.spawn(function()
		if FFlagPinShortcutEnableOnCompleteCallback then
			local success, result = pcall(function()
				pinExperienceAndNotify(placeId, universeId, gameName, p2.dependencies.dispatch)
			end)

			if not success then
				p2.dependencies.logger.reportError(
					SduiErrorType.FailedToExecuteAction,
					{ name = PinExperienceShortcut, message = tostring(result) },
					p2.appPage
				)
			end
		else
			local success, service = pcall(game.GetService, game, "PinShortcutService")

			if not success or service == nil then
				p2.dependencies.logger.reportError(
					SduiErrorType.FailedToExecuteAction,
					{ name = PinExperienceShortcut, message = "PinShortcutService unavailable" },
					p2.appPage
				)
				return
			end

			local success2, result = pcall(function()
				service:PinExperience(placeId, universeId, gameName)
			end)

			if not success2 then
				p2.dependencies.logger.reportError(
					SduiErrorType.FailedToExecuteAction,
					{ name = PinExperienceShortcut, message = tostring(result) },
					p2.appPage
				)
			end
		end
	end)
end

return SduiPinShortcutAction
