local AppChat = script:FindFirstAncestor("AppChat")

require(AppChat.types)

local AppChatParent = AppChat.Parent

require(AppChatParent.SocialLuaAnalytics)
require(AppChatParent.AppChatNetworking)

local Telemetry = require(AppChat.Telemetry.Telemetry)
local DefaultTelemetryEvents = require(AppChat.Telemetry.DefaultTelemetryEvents)
local namedCounterConfigurationAndFormat = DefaultTelemetryEvents.namedCounterConfigurationAndFormat
local eventIngestWithFormatFunction = DefaultTelemetryEvents.eventIngestWithFormatFunction
local Cryo = require(AppChatParent.Cryo)
local t1 = {}

local function eventIngestWithModalFormatFunction(p1, s1: string) -- line: 37
	-- upvalues: Cryo (copy), eventIngestWithFormatFunction (copy)
	return eventIngestWithFormatFunction(function(t2: {[any]: any}, p2) -- line: 38
		-- upvalues: p1 (copy), Cryo (copy), s1 (copy)
		local v26 = p1(t2, p2)

		return Cryo.Dictionary.join({
			modalSequence = s1
		}, v26)
	end)
end

t1.Events = {
	modalRenderedWithSequence = function(p3) -- line: 48
		-- upvalues: namedCounterConfigurationAndFormat (copy), eventIngestWithModalFormatFunction (copy), Telemetry (copy)
		local t3 = {}
		local counterFormat = p3.counterFormat
		local eventStreamFormat = p3.eventStreamFormat

		if counterFormat then
			table.insert(t3, namedCounterConfigurationAndFormat(`AppChat.Modal.{ p3.modalSequence }.Rendered`, counterFormat))
		end

		if eventStreamFormat then
			table.insert(t3, eventIngestWithModalFormatFunction(eventStreamFormat, p3.modalSequence))
		end

		return (Telemetry.new({
			name = "appChatModalRendered",
			description = "",
			lastUpdated = {
				2025,
				9,
				8
			},
			backendsList = t3
		}))
	end,
	modalActionWithSequence = function(p4) -- line: 79
		-- upvalues: namedCounterConfigurationAndFormat (copy), eventIngestWithModalFormatFunction (copy), Telemetry (copy)
		local t4 = {}
		local counterFormat = p4.counterFormat
		local eventStreamFormat = p4.eventStreamFormat

		if counterFormat then
			table.insert(t4, namedCounterConfigurationAndFormat(`AppChat.Modal.{ p4.modalSequence }.Action`, counterFormat))
		end

		if eventStreamFormat then
			table.insert(t4, eventIngestWithModalFormatFunction(eventStreamFormat, p4.modalSequence))
		end

		return (Telemetry.new({
			name = "appChatModalAction",
			description = "",
			lastUpdated = {
				2025,
				9,
				8
			},
			backendsList = t4
		}))
	end,
	modalActionResultWithSequence = function(p5) -- line: 113
		-- upvalues: namedCounterConfigurationAndFormat (copy), eventIngestWithModalFormatFunction (copy), Telemetry (copy)
		local t5 = {}
		local counterFormat = p5.counterFormat
		local eventStreamFormat = p5.eventStreamFormat

		if counterFormat then
			table.insert(t5, namedCounterConfigurationAndFormat(`AppChat.Modal.{ p5.modalSequence }.ActionResult`, counterFormat))
		end

		if eventStreamFormat then
			table.insert(t5, eventIngestWithModalFormatFunction(eventStreamFormat, p5.modalSequence))
		end

		return (Telemetry.new({
			name = "appChatModalActionResult",
			description = "",
			lastUpdated = {
				2025,
				9,
				8
			},
			backendsList = t5
		}))
	end
}
t1.Enums = {
	ModalActions = {
		PrimaryCta = "primaryCta",
		SecondaryCta = "secondaryCta",
		Dismiss = "dismiss",
		InlineCta = "inlineCta"
	},
	ModalActionResults = {
		Success = "success",
		Failure = "failure"
	},
	ModalSequence = {
		ChatLandingModal = "ChatLandingModal",
		ConversationOverlay = "ConversationOverlay",
		ConversationTopModal = "ConversationTopModal",
		ConversationListOverlay = "ConversationListOverlay"
	}
}

return t1
