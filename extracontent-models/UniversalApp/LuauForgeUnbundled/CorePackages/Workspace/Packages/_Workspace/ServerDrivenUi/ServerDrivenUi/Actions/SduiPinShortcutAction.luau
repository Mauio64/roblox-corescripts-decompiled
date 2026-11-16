local IXPService = game:GetService("IXPService")

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local fFlagPinShortcutEnableOnCompleteCallback = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagPinShortcutEnableOnCompleteCallback
local fFlagEdpPinnedShortcutsLogExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagEdpPinnedShortcutsLogExposure
local fStringEdpPinnedShortcutsIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FStringEdpPinnedShortcutsIxpLayer
local pinExperienceAndNotify = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/PinShortcut").pinExperienceAndNotify

local pinExperienceShortcut = sduiActionType.PinExperienceShortcut

local function isPinShortcutServiceEnabled()
	return game:GetEngineFeature("PinShortcutServiceEnabled")
end

local function SduiPinShortcutAction(p2, p3, p4, p5)
	local actionParams = if p2 then p2.actionParams else nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = pinExperienceShortcut, message = "Missing actionParams" },
			p4.appPage
		)
		return
	end

	local placeId = tonumber(actionParams.placeId)

	if placeId == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = pinExperienceShortcut,
				message = "Missing placeId",
				propName = "placeId"
			},
			p4.appPage
		)
		return
	end

	local universeId = tonumber(actionParams.universeId) or 0
	local gameName = actionParams.gameName or ""

	if not game:GetEngineFeature("PinShortcutServiceEnabled") then
		return
	end

	if
		fFlagEdpPinnedShortcutsLogExposure
		and game:GetEngineFeature("EnableLogFlagLinkedUserLayerExposure")
	then
		pcall(function()
			IXPService:LogFlagLinkedUserLayerExposure(fStringEdpPinnedShortcutsIxpLayer)
		end)
	end

	task.spawn(function()
		if fFlagPinShortcutEnableOnCompleteCallback then
			local success, result = pcall(function()
				pinExperienceAndNotify(placeId, universeId, gameName, p4.dependencies.dispatch)
			end)

			if not success then
				p4.dependencies.logger.reportError(
					sduiErrorType.FailedToExecuteAction,
					{ name = pinExperienceShortcut, message = tostring(result) },
					p4.appPage
				)
			end
		else
			local success, service = pcall(game.GetService, game, "PinShortcutService")

			if not success or service == nil then
				p4.dependencies.logger.reportError(
					sduiErrorType.FailedToExecuteAction,
					{
						name = pinExperienceShortcut,
						message = "PinShortcutService unavailable"
					},
					p4.appPage
				)
				return
			end

			local success2, result = pcall(function()
				service:PinExperience(placeId, universeId, gameName)
			end)

			if not success2 then
				p4.dependencies.logger.reportError(
					sduiErrorType.FailedToExecuteAction,
					{ name = pinExperienceShortcut, message = tostring(result) },
					p4.appPage
				)
			end
		end
	end)
end

return SduiPinShortcutAction
