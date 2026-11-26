local module = require("@luauforge/bundled/dTq")
local sduiActionType = module.SduiActionType
local sduiErrorType = module.SduiErrors.SduiErrorType
local sduiParseHelpers = module.SduiParseHelpers
local getSduiClientPageScope = module.getSduiClientPageScope

local getMarketplaceAssetStore = require("@luauforge/bundled/dTx").MarketplaceAsset.getMarketplaceAssetStore

local module2 = require("@luauforge/bundled/dUF")

local v5 = {}

local function reportError(p2, p3, p4, p5)
	p2.dependencies.logger.reportError(
		p3,
		{ name = sduiActionType.ClaimEventItem, message = p4, propName = p5 },
		p2.appPage
	)
end

local function runCallback(data, callback, p2)
	if callback == nil or typeof(callback) ~= "function" then
		return
	end

	local success, result = pcall(function()
		callback()
	end)

	if not success then
		local failedToExecuteAction = sduiErrorType.FailedToExecuteAction
		local formatted = `{p2} failed: {tostring(result)}`
		data.dependencies.logger.reportError(
			failedToExecuteAction,
			{
				name = sduiActionType.ClaimEventItem,
				message = formatted,
				propName = nil
			},
			data.appPage
		)
	end
end

local function setLoading(p2, p3, p4)
	local configKey = p2.configKey

	if p3 == nil or typeof(configKey) ~= "string" or configKey == "" then
		return
	end

	getSduiClientPageScope(configKey).set(p3, p4)
end

local function SduiClaimEventItemAction(p2, p3, data, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		local invalidActionParams = sduiErrorType.InvalidActionParams
		data.dependencies.logger.reportError(
			invalidActionParams,
			{
				name = sduiActionType.ClaimEventItem,
				message = "Missing actionParams",
				propName = nil
			},
			data.appPage
		)
	else
		assert(actionParams, "actionParams must exist")

		local actionParams2 = {}

		for k, v6 in {
			"eventType",
			"subscriptionProductType",
			"subscriptionProductId",
			"assetId"
		} do
			local actionParam = actionParams[v6]

			if typeof(actionParam) == "string" and actionParam ~= "" then
				actionParams2[v6] = actionParam
			else
				local invalidActionParams = sduiErrorType.InvalidActionParams
				local formatted = `Invalid or missing {v6}: {sduiParseHelpers.stringifyValue(actionParam)}`
				data.dependencies.logger.reportError(
					invalidActionParams,
					{
						name = sduiActionType.ClaimEventItem,
						message = formatted,
						propName = v6
					},
					data.appPage
				)

				return
			end
		end

		local assetId = actionParams2.assetId

		if string.match(assetId, "^[1-9]%d*$") == nil then
			local invalidActionParams = sduiErrorType.InvalidActionParams
			local formatted = `Invalid assetId: {assetId}`
			data.dependencies.logger.reportError(
				invalidActionParams,
				{
					name = sduiActionType.ClaimEventItem,
					message = formatted,
					propName = "assetId"
				},
				data.appPage
			)
		else
			if v5[assetId] then
				return
			end

			local v6 = {}
			v5[assetId] = v6

			local onClaimed = actionParams.onClaimed
			local onNotSubscribed = actionParams.onNotSubscribed
			local onFailure = actionParams.onFailure
			local loadingPageScopeField = actionParams.loadingPageScopeField

			if typeof(loadingPageScopeField) ~= "string" or loadingPageScopeField == "" then
				loadingPageScopeField = nil
			end

			local function settle(): boolean
				if v5[assetId] ~= v6 then
					return false
				end

				v5[assetId] = nil
				return true
			end

			local function fail(p5)
				local v7

				if v5[assetId] == v6 then
					v5[assetId] = nil
					v7 = true
				else
					v7 = false
				end

				if not v7 then
					return
				end

				local v8 = loadingPageScopeField
				local configKey = data.configKey

				if v8 ~= nil and typeof(configKey) == "string" and configKey ~= "" then
					getSduiClientPageScope(configKey).set(v8, false)
				end

				local v9 = data
				local actionNetworkRequestFailed = sduiErrorType.ActionNetworkRequestFailed
				local formatted = `Claim request failed: {sduiParseHelpers.stringifyValue(p5)}`
				v9.dependencies.logger.reportError(
					actionNetworkRequestFailed,
					{
						name = sduiActionType.ClaimEventItem,
						message = formatted,
						propName = nil
					},
					v9.appPage
				)

				runCallback(data, onFailure, "onFailure")
			end

			local success, result = pcall(function()
				local v7 = loadingPageScopeField
				local configKey = data.configKey

				if v7 ~= nil and typeof(configKey) == "string" and configKey ~= "" then
					getSduiClientPageScope(configKey).set(v7, true)
				end

				return module2(data.dependencies.networking, {
					eventType = actionParams2.eventType,
					subscriptionProductType = actionParams2.subscriptionProductType,
					subscriptionProductId = actionParams2.subscriptionProductId,
					assetId = assetId
				})
			end)

			if not success then
				fail(result)
				return
			end

			task.delay(30, function()
				fail(`timed out after {30} seconds`)
			end)

			result:andThen(function(p5)
				local responseBody = p5 and p5.responseBody
				local status = if typeof(responseBody) == "table" then responseBody.status else nil

				if status == "Claimed" then
					getMarketplaceAssetStore(false).updateMarketplaceAssetInfo(assetId, {
						owned = true
					})
					local flag

					if v5[assetId] == v6 then
						v5[assetId] = nil
						flag = true
					else
						flag = false
					end

					if flag then
						local v7 = loadingPageScopeField
						local configKey = data.configKey

						if v7 ~= nil and typeof(configKey) == "string" and configKey ~= "" then
							getSduiClientPageScope(configKey).set(v7, false)
						end

						runCallback(data, onClaimed, "onClaimed")
					end
				else
					local v7

					if v5[assetId] == v6 then
						v5[assetId] = nil
						v7 = true
					else
						v7 = false
					end

					if not v7 then
						return
					end

					local v8 = loadingPageScopeField
					local configKey = data.configKey

					if v8 ~= nil and typeof(configKey) == "string" and configKey ~= "" then
						getSduiClientPageScope(configKey).set(v8, false)
					end

					if status == "NotSubscribed" then
						runCallback(data, onNotSubscribed, "onNotSubscribed")
						return
					elseif status == "Unavailable" then
						runCallback(data, onFailure, "onFailure")
						return
					end

					local v9 = data
					local failedToExecuteAction = sduiErrorType.FailedToExecuteAction
					local formatted = `Claim not granted: {sduiParseHelpers.stringifyValue(status)}`
					v9.dependencies.logger.reportError(
						failedToExecuteAction,
						{
							name = sduiActionType.ClaimEventItem,
							message = formatted,
							propName = nil
						},
						v9.appPage
					)

					runCallback(data, onFailure, "onFailure")
				end
			end):catch(fail)
		end
	end
end

return SduiClaimEventItemAction
