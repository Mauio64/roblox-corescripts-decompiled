local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/React")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SduiSharedUtilities")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags")

local sduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint

local Logger = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/Logger")
local reportPromptImpression = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/reportPromptImpression")
local sendModalImpressionEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/ServerTriggeredModalImpressions").sendModalImpressionEvent
local PromptStyle = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptStyle")
local usePromptEntries = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/usePromptEntries")
local useModalSignalStore = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SignalStores/useModalSignalStore")
local FFlagPromptsActionEventLogging = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/Flags/FFlagPromptsActionEventLogging")
local fFlagPromptsCoachmarkImpressionOnShow = SharedFlags.FFlagPromptsCoachmarkImpressionOnShow

local function CoachmarkRenderer(p2)
	local surfaceConfig = p2.surfaceConfig
	local hasShownKey = p2.hasShownKey
	local v5 = useModalSignalStore()
	local state, setState = React.useState(false)

	React.useEffect(function()
		if not state and v5.tryClaimPrimaryHandler(hasShownKey) then
			setState(true)
		end

		return function()
			if state then
				v5.releasePrimaryHandler(hasShownKey)
			end
		end
	end, { state, hasShownKey, v5 })

	local v6 = usePromptEntries(surfaceConfig.configKey, PromptStyle.Coachmark)

	if not fFlagPromptsCoachmarkImpressionOnShow then
		local v7 = React.useMemo(function()
			if not state then
				return ""
			end

			local v8 = {}

			for k, v9 in v6 do
				if v9.identifier and v9.title and v9.config then
					table.insert(v8, `{v9.identifier}:{v9.title}`)
				end
			end

			return table.concat(v8, "|")
		end, { state, v6 })

		React.useEffect(function()
			if v7 == "" then
				return
			end

			for k, v8 in v6 do
				if not (v8.identifier and v8.title and v8.config) then
					continue
				end

				reportPromptImpression(v8.title, v8.identifier):catch(function()
					Logger:warning("Failed to report coachmark prompt impression")
				end)
				sendModalImpressionEvent(v8.identifier, v8.title)
			end
		end, { v7 })
	end

	if not state then
		return nil
	end

	local children = {}

	for k, v7 in v6 do
		if not (v7.config ~= nil and v7.identifier ~= nil and v7.title ~= nil) then
			continue
		end

		local identifier = v7.identifier
		local createElement = React.createElement
		local v9 = {
			configKey = surfaceConfig.configKey,
			identifier = v7.identifier,
			appPage = surfaceConfig.appPage,
			additionalAnalyticsData = 0,
			shouldDisplayLoading = false,
			shouldDisplayError = false,
			extraLocalProps = 0
		}
		local v10

		if FFlagPromptsActionEventLogging then
			v10 = { promptInstanceId = 0 }
			local v11 = if v7.identifier then v7.identifier else nil
			v10.promptInstanceId = v11
		end

		v9.additionalAnalyticsData = v10

		v9.extraLocalProps = fFlagPromptsCoachmarkImpressionOnShow and {
			onShown = function()
				reportPromptImpression(v7.title, v7.identifier):catch(function()
					Logger:warning("Failed to report coachmark prompt impression")
				end)
				sendModalImpressionEvent(v7.identifier, v7.title)
			end
		} or nil
		children[identifier] = createElement(sduiFeatureEntryPoint, v9)
	end

	return React.createElement(React.Fragment, nil, children)
end

return React.memo(CoachmarkRenderer)
