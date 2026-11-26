local updateUserSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/SettingsSdui/LegallySensitiveContent").updateUserSettings

local LinkingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/SettingsSdui/LinkingProtocol")
local linkingProtocol = LinkingProtocol.LinkingProtocol
local adConsentAttributionAdapter = LinkingProtocol.AdConsentAttributionAdapter
local readCachedAdConsentRegion = LinkingProtocol.readCachedAdConsentRegion
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SettingsSdui/SharedFlags")
local fFlagEnableAdConsentUserSettingsPublish = SharedFlags.FFlagEnableAdConsentUserSettingsPublish
local fFlagAdConsentForwardCachedRegion = SharedFlags.FFlagAdConsentForwardCachedRegion

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SettingsSdui/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

return function(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.UpdateUserSettings,
				message = "Missing actionParams"
			},
			p4.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")

	local settings2 = actionParams.settings

	if typeof(settings2) ~= "table" or next(settings2) == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.UpdateUserSettings,
				message = `Invalid settings {settings2}`
			},
			p4.appPage
		)
		return
	end

	local auditData = actionParams.auditData

	if auditData ~= nil and typeof(auditData) ~= "string" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.UpdateUserSettings,
				message = `Invalid auditData {auditData}`
			},
			p4.appPage
		)
		return
	end

	local success, result = pcall(function()
		local v5 = updateUserSettings(settings2, auditData)

		if fFlagEnableAdConsentUserSettingsPublish then
			v5 = v5:andThen(function()
				local allowSellShareData = settings2.allowSellShareData

				if allowSellShareData ~= nil then
					local v6 = if fFlagAdConsentForwardCachedRegion then readCachedAdConsentRegion() else nil
					adConsentAttributionAdapter.resolveAndPublish(
						linkingProtocol.default,
						"ConsentChanged",
						function()
							return allowSellShareData
						end,
						v6
					)
				end
			end)
		end

		v5:catch(function(p6)
			p4.dependencies.logger.reportError(
				sduiErrorType.FailedToExecuteAction,
				{ name = sduiActionType.UpdateUserSettings, message = tostring(p6) },
				p4.appPage
			)
		end)
	end)

	if success then
		return
	end

	p4.dependencies.logger.reportError(
		sduiErrorType.FailedToExecuteAction,
		{ name = sduiActionType.UpdateUserSettings, message = tostring(result) },
		p4.appPage
	)
end
