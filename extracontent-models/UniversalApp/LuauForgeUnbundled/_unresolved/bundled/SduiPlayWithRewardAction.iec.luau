local AdService = game:GetService("AdService")

local module = require("@luauforge/bundled/ied")
local module2 = require("@luauforge/bundled/idW")
local module3 = require("@luauforge/bundled/iee")
local module4 = require("@luauforge/bundled/ief")

local playWithRewardBlackoutCurtain = module.PlayWithRewardBlackoutCurtain
local playWithRewardTelemetry = module.PlayWithRewardTelemetry
local handleUpdate = module4.HandleUpdate
local appUpdateServiceWrapper = module4.AppUpdateServiceWrapper

local sduiActionParams = module2.SduiActionParams
local sduiActionType = module2.SduiActionType
local sduiErrorType = module2.SduiErrors.SduiErrorType
local getSduiActionHandlerRegistry = module2.getSduiActionHandlerRegistry
local getSduiClientPageScope = module2.getSduiClientPageScope
local getStringParam = sduiActionParams.getStringParam

local fIntPlayWithRewardFallbackBannerProductImageAssetId = require("@luauforge/bundled/idX").FIntPlayWithRewardFallbackBannerProductImageAssetId

local defineFastFlag = game:DefineFastFlag("LuaAppPwrExperienceJoinDataFromPageScope", false)

local playWithRewardAd = sduiActionType.PlayWithRewardAd

local engineFeature = game:GetEngineFeature("CanPerformBinaryUpdateEnabled")

local function generateFlowId()
	local success, result = pcall(function()
		local HttpService = game:GetService("HttpService")
		return HttpService:GenerateGUID(false)
	end)

	if success and typeof(result) == "string" and result ~= "" then
		return result
	end

	return ""
end

local function coalesceNonEmptyString(p2, value, p3)
	if p2 ~= nil and p2 ~= "" then
		return p2
	end

	if typeof(value) == "string" and value ~= "" then
		return value
	end

	return p3
end

local function SduiPlayWithRewardAction(p2, p3, data, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = playWithRewardAd, message = "Missing actionParams" },
			data.appPage
		)
		return
	end

	local stringParam = getStringParam(actionParams, "universeId")

	if stringParam == nil or stringParam == "" then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = playWithRewardAd,
				message = "Missing universeId",
				propName = "universeId"
			},
			data.appPage
		)
		return
	end

	local stringParam2 = getStringParam(actionParams, "placeId")

	if stringParam2 == nil or stringParam2 == "" then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = playWithRewardAd,
				message = "Missing placeId",
				propName = "placeId"
			},
			data.appPage
		)
		return
	end

	local v5 = if data.configKey then getSduiClientPageScope(data.configKey) else nil

	local stringParam3 = getStringParam(actionParams, "flowId")
	local v6 = if v5 then v5.get(module3.PlayWithRewardFlowId) else nil
	local success, result = pcall(function()
		local HttpService = game:GetService("HttpService")
		return HttpService:GenerateGUID(false)
	end)

	local v7 = (not success or typeof(result) ~= "string" or result == "") and "" or result

	if stringParam3 == nil or stringParam3 == "" then
		if typeof(v6) == "string" and v6 ~= "" then
			v7 = v6
		end
	else
		v7 = stringParam3
	end

	local stringParam4 = getStringParam(actionParams, "productId", "")
	local stringParam5 = getStringParam(actionParams, "productName", "")
	local stringParam6 = getStringParam(actionParams, "productImageAssetId", "")
	local v8 = getStringParam(actionParams, "placeIdOverride") or stringParam2
	local v9 = getStringParam(actionParams, "launchSource") or "PlayWithRewardButton"

	local experienceJoinData = if defineFastFlag and v5 then v5.get("experienceJoinData") else nil

	if defineFastFlag then
		if typeof(experienceJoinData) ~= "table" then
			experienceJoinData = nil
		end
	elseif typeof(actionParams.experienceJoinData) == "table" then
		experienceJoinData = actionParams.experienceJoinData
	else
		experienceJoinData = nil
	end

	local function showAdThenLaunch()
		playWithRewardTelemetry.logPlayWithRewardBlackoutCurtainAction(
			v7,
			stringParam,
			"shown",
			stringParam4
		)
		playWithRewardBlackoutCurtain.show()
		playWithRewardTelemetry.logPlayWithRewardButtonClicked(v7, stringParam, stringParam4)

		if v5 then
			v5.set(module3.FilterPlayWithReward, true)
		end

		playWithRewardTelemetry.logPlayWithRewardAdPlaybackAttempted(v7, stringParam, stringParam4)

		local success2, result2 = pcall(function()
			return AdService:ShowRewardedVideoAdAtClientAsync(stringParam)
		end)

		pcall(function()
			playWithRewardTelemetry.logPlayWithRewardAdPlaybackStopped(
				v7,
				stringParam,
				tostring(result2),
				stringParam4
			)
			local v10 = stringParam6 == ""
			local v12 = tonumber(stringParam) or 0
			local v13 = success2 and result2 ~= nil
			local v14 = result2 == Enum.ShowAdResult.ShowCompleted

			local v16 = if v10 then fIntPlayWithRewardFallbackBannerProductImageAssetId else tonumber(stringParam6) or fIntPlayWithRewardFallbackBannerProductImageAssetId
			AdService:SubmitAdNotification(v12, v13, v14, stringParam5, v16)
		end)

		playWithRewardTelemetry.logPlayWithRewardBlackoutCurtainAction(
			v7,
			stringParam,
			"hidden",
			stringParam4
		)
		playWithRewardBlackoutCurtain.hide()

		local actionHandlerConfig = getSduiActionHandlerRegistry().getActionHandlerConfig(sduiActionType.LaunchExperience)

		if actionHandlerConfig == nil or actionHandlerConfig.handler == nil then
			data.dependencies.logger.reportError(
				sduiErrorType.InvalidActionParams,
				{
					name = playWithRewardAd,
					message = "LaunchExperience handler is not registered"
				},
				data.appPage
			)
			return
		end

		playWithRewardTelemetry.logPlayWithRewardGameJoinInitiated(v7, stringParam, stringParam4)
		actionHandlerConfig.handler({
			actionType = sduiActionType.LaunchExperience,
			actionParams = {
				placeId = v8,
				universeId = stringParam,
				launchSource = v9,
				experienceJoinData = experienceJoinData
			}
		}, p3, data, p4)
	end

	local v10 = appUpdateServiceWrapper.new(game:GetService("AppUpdateService"))
	handleUpdate(
		data.dependencies.dispatch,
		v10,
		engineFeature,
		data.dependencies.appAnalytics,
		"PlayWithRewardGameDetails",
		showAdThenLaunch
	)
end

return SduiPlayWithRewardAction
