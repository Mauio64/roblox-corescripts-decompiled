local ExperienceLoadingScript = script:FindFirstAncestor("ExperienceLoadingScript")
local ExperienceLoadingScriptParent = ExperienceLoadingScript.Parent
local ExperienceService = game:GetService("ExperienceService")
local GuiService = game:GetService("GuiService")
local DataHydration = require(ExperienceLoadingScriptParent.DataHydration)
local Signals = require(ExperienceLoadingScriptParent.Signals)
local createDataCache = DataHydration.createDataCache
local createDataResolver = DataHydration.createDataResolver
local fetchPlayerLocalizationChoice = require(script.Parent.fetchPlayerLocalizationChoice)
local LoadingScreenTelemetry = require(ExperienceLoadingScript.LoadingScreenTelemetry)
local QueueExperimentation = require(ExperienceLoadingScriptParent.SocialExperiments).QueueExperimentation
local v12 = game:GetEngineFeature("PlaceJoinStateEnabled") and (QueueExperimentation.getIsJoinNewServerButtonEnabled() or QueueExperimentation.getIsAutoJoinNewServerEnabled())

local function createLoadingScreenStore() -- line: 27
	-- upvalues: createDataCache (copy), createDataResolver (copy), LoadingScreenTelemetry (copy), fetchPlayerLocalizationChoice (copy), v12 (copy), Signals (copy), ExperienceService (copy), GuiService (copy)
	local v14 = createDataCache()
	local v15 = createDataResolver({
		supportsMultiGet = false,
		cache = v14,
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
	local v18 = nil
	local u19 = nil
	local v20 = nil
	local u21 = nil

	if v12 then
		local v22

		v18, v22 = Signals.createSignal(ExperienceService:GetPlaceJoinState() or "")
		u19 = v22
		connection2 = ExperienceService.PlaceJoinStateChanged:Connect(function(p5) -- line: 83
			-- upvalues: u19 (ref)
			u19(p5)
		end)

		local v23

		v20, v23 = Signals.createSignal(GuiService:GetUiMessage() or "")
		u21 = v23
		connection = GuiService.UiMessageChanged:Connect(function(p6, p7) -- line: 89
			-- upvalues: u21 (ref)
			if p6 == Enum.UiMessageType.UiMessageInfo then
				u21(p7)
			end
		end)
	end

	return {
		getJoinState = v18,
		getServerStatusText = v20,
		getAndFetchPlayerLocalizationChoice = v15.getAndFetchItem,
		getCachedPlayerLocalizationChoice = v15.getCachedItem,
		clear = function() -- line: 96
			-- upvalues: v14 (copy), v15 (copy)
			v14.clear()
			v15.clear()
		end,
		dispose = function() -- line: 101
			-- upvalues: v15 (copy), v12 (copy), connection2 (ref), connection (ref)
			v15.dispose()

			if v12 then
				connection2:Disconnect()
				connection:Disconnect()
			end
		end
	}
end

return createLoadingScreenStore
