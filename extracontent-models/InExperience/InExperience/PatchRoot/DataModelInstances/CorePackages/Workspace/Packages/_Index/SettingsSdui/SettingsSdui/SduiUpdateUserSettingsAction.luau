local parent = script:FindFirstAncestor("SettingsSdui").Parent
local LegallySensitiveContent = require(parent.LegallySensitiveContent)
local updateUserSettings = LegallySensitiveContent.updateUserSettings

local LinkingProtocol = require(parent.LinkingProtocol)
local linkingProtocol = LinkingProtocol.LinkingProtocol
local AdConsentAttributionAdapter = LinkingProtocol.AdConsentAttributionAdapter
local readCachedAdConsentRegion = LinkingProtocol.readCachedAdConsentRegion
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableAdConsentUserSettingsPublish = SharedFlags.FFlagEnableAdConsentUserSettingsPublish
local FFlagAdConsentForwardCachedRegion = SharedFlags.FFlagAdConsentForwardCachedRegion

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

return function(p, _, p2, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.UpdateUserSettings, message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")

	local settings = actionParams.settings

	if typeof(settings) ~= "table" or next(settings) == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.UpdateUserSettings, message = `Invalid settings {settings}` },
			p2.appPage
		)
		return
	end

	local auditData = actionParams.auditData

	if auditData ~= nil and typeof(auditData) ~= "string" then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.UpdateUserSettings,
				message = `Invalid auditData {auditData}`
			},
			p2.appPage
		)
		return
	end

	local success, result = pcall(function()
		local v = updateUserSettings(settings, auditData)

		if FFlagEnableAdConsentUserSettingsPublish then
			v = v:andThen(function()
				local allowSellShareData = settings.allowSellShareData

				if allowSellShareData ~= nil then
					local v2

					if FFlagAdConsentForwardCachedRegion then
						v2 = readCachedAdConsentRegion()
					end

					AdConsentAttributionAdapter.resolveAndPublish(linkingProtocol.default, "ConsentChanged", function()
						return allowSellShareData
					end, v2)
				end
			end)
		end

		v:catch(function(p3)
			p2.dependencies.logger.reportError(
				SduiErrorType.FailedToExecuteAction,
				{ name = SduiActionType.UpdateUserSettings, message = tostring(p3) },
				p2.appPage
			)
		end)
	end)

	if success then
		return
	end

	p2.dependencies.logger.reportError(
		SduiErrorType.FailedToExecuteAction,
		{ name = SduiActionType.UpdateUserSettings, message = tostring(result) },
		p2.appPage
	)
end
