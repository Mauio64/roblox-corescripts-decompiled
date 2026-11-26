local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialLuaAnalytics")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatConversationTelemetryLayer")
local Telemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Telemetry")
local ModalTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ModalTelemetry")
local DefaultTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/DefaultTelemetryEvents")

local v5 = {}

local function eventIngestWithFormatFunction(p2)
	return {
		type = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends.EventIngest,
		standardizedFields = DefaultTelemetryEvents.STANDARDIZED_FIELDS,
		format = p2,
		overrideName = nil,
		throttlingThousandths = nil
	}
end

v5.Constants = {
	EventStreamCtx = SocialLuaAnalytics.Analytics.Enums.Contexts.Party,
	FaeModalShownField = "fae",
	ConfirmFaeBtn = "confirmFae",
	CancelFaeBtn = "cancelFae"
}
v5.Events = {
	FaeModalShown = Telemetry.new({
		name = "authModalShown",
		description = "",
		lastUpdated = { 2026, 1, 27 },
		backendsList = {
			DefaultTelemetryEvents.namedCounterConfigurationNoEmittedInfo("AppChat.ChatLandingModal.FaeModal.Shown"),
			{
				type = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends.EventIngest,
				standardizedFields = DefaultTelemetryEvents.STANDARDIZED_FIELDS,
				format = function(p2, p3)
					return {
						field = v5.Constants.FaeModalShownField,
						os_time = os.time(),
						os_clock = os.clock()
					}
				end,
				overrideName = nil,
				throttlingThousandths = nil
			}
		},
		eventStreamCtx = v5.Constants.EventStreamCtx
	}),
	TelemetryFaeButtonClick = Telemetry.new({
		name = "authButtonClick",
		description = "",
		lastUpdated = { 2026, 1, 27 },
		backendsList = {
			DefaultTelemetryEvents.namedCounterConfigurationAndFormat(
				"AppChat.ChatLandingModal.FaeButton.Click",
				function(p2)
					return { btn = p2.btn }
				end
			),
			{
				type = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends.EventIngest,
				standardizedFields = DefaultTelemetryEvents.STANDARDIZED_FIELDS,
				format = function(p2, p3)
					return {
						state = p2.state,
						btn = p2.btn,
						os_time = os.time(),
						os_clock = os.clock()
					}
				end,
				overrideName = nil,
				throttlingThousandths = nil
			}
		},
		eventStreamCtx = v5.Constants.EventStreamCtx
	}),
	ModalRendered = ModalTelemetry.Events.modalRenderedWithSequence({
		modalSequence = ModalTelemetry.Enums.ModalSequence.ChatLandingModal,
		counterFormat = function(p2, p3)
			return { modalVariant = p2.modalVariant }
		end
	}),
	ModalAction = ModalTelemetry.Events.modalActionWithSequence({
		modalSequence = ModalTelemetry.Enums.ModalSequence.ChatLandingModal,
		counterFormat = function(p2, p3)
			return { modalVariant = p2.modalVariant, action = p2.action }
		end
	}),
	ModalActionResult = ModalTelemetry.Events.modalActionResultWithSequence({
		modalSequence = ModalTelemetry.Enums.ModalSequence.ChatLandingModal,
		counterFormat = function(data, p2)
			return {
				modalVariant = data.modalVariant,
				action = data.action,
				actionResult = data.actionResult
			}
		end
	})
}

return v5
