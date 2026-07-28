local Parent = script:FindFirstAncestor("ExperienceLoadingScript").Parent
local ExperienceService = game:GetService("ExperienceService")
local GuiService = game:GetService("GuiService")
local DataHydration = require(Parent.DataHydration)
local Signals = require(Parent.Signals)
local createDataCache = DataHydration.createDataCache
local createDataResolver = DataHydration.createDataResolver
local fetchPlayerLocalizationChoice = require(script.Parent.fetchPlayerLocalizationChoice)
local LoadingScreenTelemetry = require(Parent.ProgressLoading.LoadingScreenTelemetry)
local QueueExperimentation = require(Parent.SocialExperiments).QueueExperimentation
local v11 = game:GetEngineFeature("PlaceJoinStateEnabled") and (QueueExperimentation.getIsJoinNewServerButtonEnabled() or QueueExperimentation.getIsAutoJoinNewServerEnabled())

local function createLoadingScreenStore() -- line: 27
	-- upvalues: createDataCache (copy), createDataResolver (copy), LoadingScreenTelemetry (copy), fetchPlayerLocalizationChoice (copy), v11 (copy), Signals (copy), ExperienceService (copy), GuiService (copy)
	local v13 = createDataCache()
	local v14 = createDataResolver({
		supportsMultiGet = false,
		cache = v13,
		logError = function(p1) -- line: 32
			-- upvalues: LoadingScreenTelemetry (copy)
			if type(p1) == "table" then
				LoadingScreenTelemetry.countPlayerLocalizationChoiceFailed({
					responseCode = p1.responseCode,
					errorType = p1.errorType
				})

				return
			end

			LoadingScreenTelemetry.countPlayerLocalizationChoiceFailed({
				errorType = "PlayerLocalizationChoiceFetchError"
			})
		end,
		fetchFn = function(s1: string, _) -- line: 49
			-- upvalues: fetchPlayerLocalizationChoice (copy)
			return fetchPlayerLocalizationChoice(s1):andThen(function(p3) -- line: 51
				-- upvalues: s1 (copy)
				if not p3 or not p3.responseBody then
					error({
						errorType = "PlayerLocalizationChoiceResponseError",
						responseCode = p3 and p3.responseCode,
						errorMessage = not p3 and "No response" or "Missing response body",
						customFields = {
							universeId = s1
						}
					})
				end

				local responseBody = p3.responseBody

				if responseBody.IsPlayerChoiceEnabled == nil then
					error({
						errorType = "PlayerLocalizationChoiceMissingKey",
						errorMessage = "Missing IsPlayerChoiceEnabled in response body",
						responseCode = p3.responseCode,
						customFields = {
							universeId = s1,
							responseBody = responseBody
						}
					})
				end

				return responseBody
			end):catch(function(p4) -- line: 74
				error(p4)
			end)
		end
	})
	local connection = nil
	local connection2 = nil
	local v17 = nil
	local u18 = nil
	local v19 = nil
	local u20 = nil

	if v11 then
		local v21

		v17, v21 = Signals.createSignal(ExperienceService:GetPlaceJoinState() or "")
		u18 = v21
		connection2 = ExperienceService.PlaceJoinStateChanged:Connect(function(p5) -- line: 83
			-- upvalues: u18 (ref)
			u18(p5)
		end)

		local v22

		v19, v22 = Signals.createSignal(GuiService:GetUiMessage() or "")
		u20 = v22
		connection = GuiService.UiMessageChanged:Connect(function(p6, p7) -- line: 89
			-- upvalues: u20 (ref)
			if p6 == Enum.UiMessageType.UiMessageInfo then
				u20(p7)
			end
		end)
	end

	return {
		getJoinState = v17,
		getServerStatusText = v19,
		getAndFetchPlayerLocalizationChoice = v14.getAndFetchItem,
		getCachedPlayerLocalizationChoice = v14.getCachedItem,
		clear = function() -- line: 96
			-- upvalues: v13 (copy), v14 (copy)
			v13.clear()
			v14.clear()
		end,
		dispose = function() -- line: 101
			-- upvalues: v14 (copy), v11 (copy), connection2 (ref), connection (ref)
			v14.dispose()

			if v11 then
				connection2:Disconnect()
				connection:Disconnect()
			end
		end
	}
end

return createLoadingScreenStore
