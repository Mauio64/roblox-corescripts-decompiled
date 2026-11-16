local ExperienceService = game:GetService("ExperienceService")
local GuiService = game:GetService("GuiService")

local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/DataHydration")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Signals")

local createDataCache = DataHydration.createDataCache
local createDataResolver = DataHydration.createDataResolver

local fetchPlayerLocalizationChoice = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Stores/fetchPlayerLocalizationChoice")
local LoadingScreenTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenTelemetry")

local queueExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SocialExperiments").QueueExperimentation

local v5 = game:GetEngineFeature("PlaceJoinStateEnabled")
	and (queueExperimentation.getIsJoinNewServerButtonEnabled() or queueExperimentation.getIsAutoJoinNewServerEnabled())

local function createLoadingScreenStore()
	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		logError = function(p2)
			if type(p2) == "table" then
				LoadingScreenTelemetry.countPlayerLocalizationChoiceFailed({
					responseCode = p2.responseCode,
					errorType = p2.errorType
				})
			else
				LoadingScreenTelemetry.countPlayerLocalizationChoiceFailed({
					errorType = "PlayerLocalizationChoiceFetchError"
				})
			end
		end,
		fetchFn = function(p2, p3)
			return fetchPlayerLocalizationChoice(p2):andThen(function(p4)
				if not (p4 and p4.responseBody) then
					error({
						responseCode = p4 and p4.responseCode,
						errorType = "PlayerLocalizationChoiceResponseError",
						errorMessage = p4 and "Missing response body" or "No response",
						customFields = { universeId = p2 }
					})
				end

				local responseBody = p4.responseBody

				if responseBody.IsPlayerChoiceEnabled == nil then
					error({
						responseCode = p4.responseCode,
						errorType = "PlayerLocalizationChoiceMissingKey",
						errorMessage = "Missing IsPlayerChoiceEnabled in response body",
						customFields = { universeId = p2, responseBody = responseBody }
					})
				end

				return responseBody
			end):catch(function(message)
				error(message)
			end)
		end
	})

	local uiMessageChangedConnection = nil
	local placeJoinStateChangedConnection = nil
	local v6 = nil
	local v7 = nil
	local v8 = nil
	local v9 = nil

	if v5 then
		local v10
		v6, v10 = Signals.createSignal(ExperienceService:GetPlaceJoinState() or "")
		v7 = v10
		placeJoinStateChangedConnection = ExperienceService.PlaceJoinStateChanged:Connect(function(p2)
			v7(p2)
		end)
		local v11
		v8, v11 = Signals.createSignal(GuiService:GetUiMessage() or "")
		v9 = v11

		uiMessageChangedConnection = GuiService.UiMessageChanged:Connect(function(p2, p3)
			if p2 == Enum.UiMessageType.UiMessageInfo then
				v9(p3)
			end
		end)
	end

	return {
		getJoinState = v6,
		getServerStatusText = v8,
		getAndFetchPlayerLocalizationChoice = dataResolver.getAndFetchItem,
		getCachedPlayerLocalizationChoice = dataResolver.getCachedItem,
		clear = function()
			dataCache.clear()
			dataResolver.clear()
		end,
		dispose = function()
			dataResolver.dispose()

			if v5 then
				placeJoinStateChangedConnection:Disconnect()
				uiMessageChangedConnection:Disconnect()
			end
		end
	}
end

return createLoadingScreenStore
