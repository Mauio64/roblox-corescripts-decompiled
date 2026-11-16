local ProgressLoading = script:FindFirstAncestor("ProgressLoading")
local parent = ProgressLoading.Parent

local ExperienceService = game:GetService("ExperienceService")
local GuiService = game:GetService("GuiService")

local DataHydration = require(parent.DataHydration)
local Signals = require(parent.Signals)

local createDataCache = DataHydration.createDataCache
local createDataResolver = DataHydration.createDataResolver

local fetchPlayerLocalizationChoice = require(script.Parent.fetchPlayerLocalizationChoice)
local LoadingScreenTelemetry = require(ProgressLoading.LoadingScreenTelemetry)

local SocialExperiments = require(parent.SocialExperiments)
local QueueExperimentation = SocialExperiments.QueueExperimentation

local v = game:GetEngineFeature("PlaceJoinStateEnabled")
	and (QueueExperimentation.getIsJoinNewServerButtonEnabled() or QueueExperimentation.getIsAutoJoinNewServerEnabled())

local function createLoadingScreenStore()
	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		logError = function(p)
			if type(p) == "table" then
				LoadingScreenTelemetry.countPlayerLocalizationChoiceFailed({
					responseCode = p.responseCode,
					errorType = p.errorType
				})
			else
				LoadingScreenTelemetry.countPlayerLocalizationChoiceFailed({
					errorType = "PlayerLocalizationChoiceFetchError"
				})
			end
		end,
		fetchFn = function(universeId: string, _)
			return fetchPlayerLocalizationChoice(universeId):andThen(function(p)
				if not (p and p.responseBody) then
					error({
						responseCode = p and p.responseCode,
						errorType = "PlayerLocalizationChoiceResponseError",
						errorMessage = p and "Missing response body" or "No response",
						customFields = { universeId = universeId }
					})
				end

				local responseBody = p.responseBody

				if responseBody.IsPlayerChoiceEnabled == nil then
					error({
						responseCode = p.responseCode,
						errorType = "PlayerLocalizationChoiceMissingKey",
						errorMessage = "Missing IsPlayerChoiceEnabled in response body",
						customFields = { universeId = universeId, responseBody = responseBody }
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
	local getJoinState = nil
	local v2 = nil
	local getServerStatusText = nil
	local v3 = nil

	if v then
		local v4
		getJoinState, v4 = Signals.createSignal(ExperienceService:GetPlaceJoinState() or "")
		v2 = v4
		placeJoinStateChangedConnection = ExperienceService.PlaceJoinStateChanged:Connect(function(p)
			v2(p)
		end)
		local v5
		getServerStatusText, v5 = Signals.createSignal(GuiService:GetUiMessage() or "")
		v3 = v5

		uiMessageChangedConnection = GuiService.UiMessageChanged:Connect(function(p, p2)
			if p == Enum.UiMessageType.UiMessageInfo then
				v3(p2)
			end
		end)
	end

	return {
		getJoinState = getJoinState,
		getServerStatusText = getServerStatusText,
		getAndFetchPlayerLocalizationChoice = dataResolver.getAndFetchItem,
		getCachedPlayerLocalizationChoice = dataResolver.getCachedItem,
		clear = function()
			dataCache.clear()
			dataResolver.clear()
		end,
		dispose = function()
			dataResolver.dispose()

			if v then
				placeJoinStateChangedConnection:Disconnect()
				uiMessageChangedConnection:Disconnect()
			end
		end
	}
end

return createLoadingScreenStore
