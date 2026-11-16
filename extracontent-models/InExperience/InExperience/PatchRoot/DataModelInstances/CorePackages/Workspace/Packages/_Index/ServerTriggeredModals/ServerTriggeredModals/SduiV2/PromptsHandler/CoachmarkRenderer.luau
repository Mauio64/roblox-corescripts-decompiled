local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local parent = ServerTriggeredModals.Parent

local React = require(parent.React)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SharedFlags = require(parent.SharedFlags)

local SduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint

local Logger = require(ServerTriggeredModals.Logger)
local reportPromptImpression = require(ServerTriggeredModals.reportPromptImpression)
local ServerTriggeredModalImpressions = require(parent.ServerTriggeredModalImpressions)
local sendModalImpressionEvent = ServerTriggeredModalImpressions.sendModalImpressionEvent
local PromptStyle = require(ServerTriggeredModals.SduiV2.PromptStyle)
local usePromptEntries = require(ServerTriggeredModals.SduiV2.usePromptEntries)
local useModalSignalStore = require(ServerTriggeredModals.SignalStores.useModalSignalStore)
local FFlagPromptsActionEventLogging = require(ServerTriggeredModals.Flags.FFlagPromptsActionEventLogging)
local FFlagPromptsCoachmarkImpressionOnShow = SharedFlags.FFlagPromptsCoachmarkImpressionOnShow

local function CoachmarkRenderer(p)
	local surfaceConfig = p.surfaceConfig
	local hasShownKey = p.hasShownKey
	local v = useModalSignalStore()
	local state, setState = React.useState(false)

	React.useEffect(function()
		if not state and v.tryClaimPrimaryHandler(hasShownKey) then
			setState(true)
		end

		return function()
			if state then
				v.releasePrimaryHandler(hasShownKey)
			end
		end
	end, { state, hasShownKey, v })

	local v2 = usePromptEntries(surfaceConfig.configKey, PromptStyle.Coachmark)

	if not FFlagPromptsCoachmarkImpressionOnShow then
		local v3 = React.useMemo(function()
			if not state then
				return ""
			end

			local v3 = {}

			for _, v4 in v2 do
				if v4.identifier and v4.title and v4.config then
					table.insert(v3, `{v4.identifier}:{v4.title}`)
				end
			end

			return table.concat(v3, "|")
		end, { state, v2 })

		React.useEffect(function()
			if v3 == "" then
				return
			end

			for _, v4 in v2 do
				if not (v4.identifier and v4.title and v4.config) then
					continue
				end

				reportPromptImpression(v4.title, v4.identifier):catch(function()
					Logger:warning("Failed to report coachmark prompt impression")
				end)
				sendModalImpressionEvent(v4.identifier, v4.title)
			end
		end, { v3 })
	end

	if not state then
		return nil
	end

	local children = {}

	for _, v3 in v2 do
		if not (v3.config ~= nil and v3.identifier ~= nil and v3.title ~= nil) then
			continue
		end

		local identifier = v3.identifier
		local createElement = React.createElement
		local v4 = {
			configKey = surfaceConfig.configKey,
			identifier = v3.identifier,
			appPage = surfaceConfig.appPage,
			additionalAnalyticsData = 0,
			shouldDisplayLoading = false,
			shouldDisplayError = false,
			extraLocalProps = 0
		}
		local additionalAnalyticsData

		if FFlagPromptsActionEventLogging then
			additionalAnalyticsData = { promptInstanceId = 0 }
			local promptInstanceId

			if v3.identifier then
				promptInstanceId = v3.identifier
			end

			additionalAnalyticsData.promptInstanceId = promptInstanceId
		end

		v4.additionalAnalyticsData = additionalAnalyticsData

		v4.extraLocalProps = FFlagPromptsCoachmarkImpressionOnShow and {
			onShown = function()
				reportPromptImpression(v3.title, v3.identifier):catch(function()
					Logger:warning("Failed to report coachmark prompt impression")
				end)
				sendModalImpressionEvent(v3.identifier, v3.title)
			end
		} or nil
		children[identifier] = createElement(SduiFeatureEntryPoint, v4)
	end

	return React.createElement(React.Fragment, nil, children)
end

return React.memo(CoachmarkRenderer)
