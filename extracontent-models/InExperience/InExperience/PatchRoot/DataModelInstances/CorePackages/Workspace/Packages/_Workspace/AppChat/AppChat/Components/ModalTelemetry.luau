local AppChat = script:FindFirstAncestor("AppChat")
require(AppChat.types)
local parent = AppChat.Parent
require(parent.SocialLuaAnalytics)
require(parent.AppChatNetworking)
local Telemetry = require(AppChat.Telemetry.Telemetry)
local DefaultTelemetryEvents = require(AppChat.Telemetry.DefaultTelemetryEvents)
local namedCounterConfigurationAndFormat = DefaultTelemetryEvents.namedCounterConfigurationAndFormat
local eventIngestWithFormatFunction = DefaultTelemetryEvents.eventIngestWithFormatFunction
local Cryo = require(parent.Cryo)

local function eventIngestWithModalFormatFunction(eventStreamFormat, modalSequence: string)
	return eventIngestWithFormatFunction(function(p, p2)
		local v = eventStreamFormat(p, p2)
		return Cryo.Dictionary.join({ modalSequence = modalSequence }, v)
	end)
end

return {
	Events = {
		modalRenderedWithSequence = function(data)
			local backendsList = {}
			local counterFormat = data.counterFormat
			local eventStreamFormat = data.eventStreamFormat

			if counterFormat then
				table.insert(
					backendsList,
					namedCounterConfigurationAndFormat(`AppChat.Modal.{data.modalSequence}.Rendered`, counterFormat)
				)
			end

			if eventStreamFormat then
				table.insert(backendsList, eventIngestWithModalFormatFunction(eventStreamFormat, data.modalSequence))
			end

			return (Telemetry.new({
				name = "appChatModalRendered",
				description = "",
				lastUpdated = { 2025, 9, 8 },
				backendsList = backendsList
			}))
		end,
		modalActionWithSequence = function(data)
			local backendsList = {}
			local counterFormat = data.counterFormat
			local eventStreamFormat = data.eventStreamFormat

			if counterFormat then
				table.insert(
					backendsList,
					namedCounterConfigurationAndFormat(`AppChat.Modal.{data.modalSequence}.Action`, counterFormat)
				)
			end

			if eventStreamFormat then
				table.insert(backendsList, eventIngestWithModalFormatFunction(eventStreamFormat, data.modalSequence))
			end

			return (Telemetry.new({
				name = "appChatModalAction",
				description = "",
				lastUpdated = { 2025, 9, 8 },
				backendsList = backendsList
			}))
		end,
		modalActionResultWithSequence = function(data)
			local backendsList = {}
			local counterFormat = data.counterFormat
			local eventStreamFormat = data.eventStreamFormat

			if counterFormat then
				table.insert(
					backendsList,
					namedCounterConfigurationAndFormat(`AppChat.Modal.{data.modalSequence}.ActionResult`, counterFormat)
				)
			end

			if eventStreamFormat then
				table.insert(backendsList, eventIngestWithModalFormatFunction(eventStreamFormat, data.modalSequence))
			end

			return (Telemetry.new({
				name = "appChatModalActionResult",
				description = "",
				lastUpdated = { 2025, 9, 8 },
				backendsList = backendsList
			}))
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
