local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)
local Telemetry = require(AppChat.Telemetry.Telemetry)
local ModalTelemetry = require(AppChat.Components.ModalTelemetry)
local DefaultTelemetryEvents = require(AppChat.Telemetry.DefaultTelemetryEvents)

local ChatLandingModalTelemetry = {}

local function eventIngestWithFormatFunction(format)
	return {
		type = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends.EventIngest,
		standardizedFields = DefaultTelemetryEvents.STANDARDIZED_FIELDS,
		format = format,
		overrideName = nil,
		throttlingThousandths = nil
	}
end

ChatLandingModalTelemetry.Constants = {
	EventStreamCtx = SocialLuaAnalytics.Analytics.Enums.Contexts.Party,
	FaeModalShownField = "fae",
	ConfirmFaeBtn = "confirmFae",
	CancelFaeBtn = "cancelFae"
}
ChatLandingModalTelemetry.Events = {
	FaeModalShown = Telemetry.new({
		name = "authModalShown",
		description = "",
		lastUpdated = { 2026, 1, 27 },
		backendsList = {
			DefaultTelemetryEvents.namedCounterConfigurationNoEmittedInfo("AppChat.ChatLandingModal.FaeModal.Shown"),
			{
				type = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends.EventIngest,
				standardizedFields = DefaultTelemetryEvents.STANDARDIZED_FIELDS,
				format = function(_, _)
					return {
						field = ChatLandingModalTelemetry.Constants.FaeModalShownField,
						os_time = os.time(),
						os_clock = os.clock()
					}
				end,
				overrideName = nil,
				throttlingThousandths = nil
			}
		},
		eventStreamCtx = ChatLandingModalTelemetry.Constants.EventStreamCtx
	}),
	TelemetryFaeButtonClick = Telemetry.new({
		name = "authButtonClick",
		description = "",
		lastUpdated = { 2026, 1, 27 },
		backendsList = {
			DefaultTelemetryEvents.namedCounterConfigurationAndFormat(
				"AppChat.ChatLandingModal.FaeButton.Click",
				function(p)
					return { btn = p.btn }
				end
			),
			{
				type = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends.EventIngest,
				standardizedFields = DefaultTelemetryEvents.STANDARDIZED_FIELDS,
				format = function(p, _)
					return {
						state = p.state,
						btn = p.btn,
						os_time = os.time(),
						os_clock = os.clock()
					}
				end,
				overrideName = nil,
				throttlingThousandths = nil
			}
		},
		eventStreamCtx = ChatLandingModalTelemetry.Constants.EventStreamCtx
	}),
	ModalRendered = ModalTelemetry.Events.modalRenderedWithSequence({
		modalSequence = ModalTelemetry.Enums.ModalSequence.ChatLandingModal,
		counterFormat = function(p, _)
			return { modalVariant = p.modalVariant }
		end
	}),
	ModalAction = ModalTelemetry.Events.modalActionWithSequence({
		modalSequence = ModalTelemetry.Enums.ModalSequence.ChatLandingModal,
		counterFormat = function(p, _)
			return { modalVariant = p.modalVariant, action = p.action }
		end
	}),
	ModalActionResult = ModalTelemetry.Events.modalActionResultWithSequence({
		modalSequence = ModalTelemetry.Enums.ModalSequence.ChatLandingModal,
		counterFormat = function(data, _)
			return {
				modalVariant = data.modalVariant,
				action = data.action,
				actionResult = data.actionResult
			}
		end
	})
}

return ChatLandingModalTelemetry
