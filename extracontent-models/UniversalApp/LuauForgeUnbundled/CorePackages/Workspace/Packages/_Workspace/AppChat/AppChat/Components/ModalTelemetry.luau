require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialLuaAnalytics")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local Telemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Telemetry")
local DefaultTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/DefaultTelemetryEvents")
local namedCounterConfigurationAndFormat = DefaultTelemetryEvents.namedCounterConfigurationAndFormat
local eventIngestWithFormatFunction = DefaultTelemetryEvents.eventIngestWithFormatFunction
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")

local function eventIngestWithModalFormatFunction(eventStreamFormat, modalSequence)
	return eventIngestWithFormatFunction(function(p2, p3)
		local v6 = eventStreamFormat(p2, p3)
		return Cryo.Dictionary.join({ modalSequence = modalSequence }, v6)
	end)
end

return {
	Events = {
		modalRenderedWithSequence = function(data)
			local v6 = {}
			local counterFormat = data.counterFormat
			local eventStreamFormat = data.eventStreamFormat

			if counterFormat then
				table.insert(
					v6,
					namedCounterConfigurationAndFormat(
						`AppChat.Modal.{data.modalSequence}.Rendered`,
						counterFormat
					)
				)
			end

			if eventStreamFormat then
				table.insert(v6, eventIngestWithModalFormatFunction(eventStreamFormat, data.modalSequence))
			end

			return Telemetry.new({
				name = "appChatModalRendered",
				description = "",
				lastUpdated = { 2025, 9, 8 },
				backendsList = v6
			})
		end,
		modalActionWithSequence = function(data)
			local v6 = {}
			local counterFormat = data.counterFormat
			local eventStreamFormat = data.eventStreamFormat

			if counterFormat then
				table.insert(
					v6,
					namedCounterConfigurationAndFormat(
						`AppChat.Modal.{data.modalSequence}.Action`,
						counterFormat
					)
				)
			end

			if eventStreamFormat then
				table.insert(v6, eventIngestWithModalFormatFunction(eventStreamFormat, data.modalSequence))
			end

			return Telemetry.new({
				name = "appChatModalAction",
				description = "",
				lastUpdated = { 2025, 9, 8 },
				backendsList = v6
			})
		end,
		modalActionResultWithSequence = function(data)
			local v6 = {}
			local counterFormat = data.counterFormat
			local eventStreamFormat = data.eventStreamFormat

			if counterFormat then
				table.insert(
					v6,
					namedCounterConfigurationAndFormat(
						`AppChat.Modal.{data.modalSequence}.ActionResult`,
						counterFormat
					)
				)
			end

			if eventStreamFormat then
				table.insert(v6, eventIngestWithModalFormatFunction(eventStreamFormat, data.modalSequence))
			end

			return Telemetry.new({
				name = "appChatModalActionResult",
				description = "",
				lastUpdated = { 2025, 9, 8 },
				backendsList = v6
			})
		end
	},
	Enums = {
		ModalActions = {
			PrimaryCta = "primaryCta",
			SecondaryCta = "secondaryCta",
			Dismiss = "dismiss",
			InlineCta = "inlineCta"
		},
		ModalActionResults = { Success = "success", Failure = "failure" },
		ModalSequence = {
			ChatLandingModal = "ChatLandingModal",
			ConversationOverlay = "ConversationOverlay",
			ConversationTopModal = "ConversationTopModal",
			ConversationListOverlay = "ConversationListOverlay"
		}
	}
}
