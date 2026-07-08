local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local SocialLuaAnalytics = require(AppChatParent.SocialLuaAnalytics)

require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)

local Telemetry = require(AppChat.Telemetry.Telemetry)
local ModalTelemetry = require(AppChat.Components.ModalTelemetry)
local DefaultTelemetryEvents = require(AppChat.Telemetry.DefaultTelemetryEvents)
local t1 = {}

local function eventIngestWithFormatFunction(p1: ((...any) -> ...any)) -- line: 14
	-- upvalues: SocialLuaAnalytics (copy), DefaultTelemetryEvents (copy)
	return {
		overrideName = nil,
		throttlingThousandths = nil,
		type = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends.EventIngest,
		standardizedFields = DefaultTelemetryEvents.STANDARDIZED_FIELDS,
		format = p1
	}
end

t1.Constants = {
	FaeModalShownField = "fae",
	ConfirmFaeBtn = "confirmFae",
	CancelFaeBtn = "cancelFae",
	EventStreamCtx = SocialLuaAnalytics.Analytics.Enums.Contexts.Party
}
t1.Events = {
	FaeModalShown = Telemetry.new({
		name = "authModalShown",
		description = "",
		lastUpdated = {
			2026,
			1,
			27
		},
		backendsList = {
			DefaultTelemetryEvents.namedCounterConfigurationNoEmittedInfo("AppChat.ChatLandingModal.FaeModal.Shown"),
			{
				overrideName = nil,
				throttlingThousandths = nil,
				type = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends.EventIngest,
				standardizedFields = DefaultTelemetryEvents.STANDARDIZED_FIELDS,
				format = function(_: {[any]: any}, _) -- line: 38
					-- upvalues: t1 (copy)
					return {
						field = t1.Constants.FaeModalShownField,
						os_time = os.time(),
						os_clock = os.clock()
					}
				end
			}
		},
		eventStreamCtx = t1.Constants.EventStreamCtx
	}),
	TelemetryFaeButtonClick = Telemetry.new({
		name = "authButtonClick",
		description = "",
		lastUpdated = {
			2026,
			1,
			27
		},
		backendsList = {
			DefaultTelemetryEvents.namedCounterConfigurationAndFormat("AppChat.ChatLandingModal.FaeButton.Click", function(t3: {[any]: any}) -- line: 55
				return {
					btn = t3.btn
				}
			end),
			{
				overrideName = nil,
				throttlingThousandths = nil,
				type = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends.EventIngest,
				standardizedFields = DefaultTelemetryEvents.STANDARDIZED_FIELDS,
				format = function(t4: {[any]: any}, _) -- line: 65
					return {
						state = t4.state,
						btn = t4.btn,
						os_time = os.time(),
						os_clock = os.clock()
					}
				end
			}
		},
		eventStreamCtx = t1.Constants.EventStreamCtx
	}),
	ModalRendered = ModalTelemetry.Events.modalRenderedWithSequence({
		modalSequence = ModalTelemetry.Enums.ModalSequence.ChatLandingModal,
		counterFormat = function(p4, _) -- line: 82
			return {
				modalVariant = p4.modalVariant
			}
		end
	}),
	ModalAction = ModalTelemetry.Events.modalActionWithSequence({
		modalSequence = ModalTelemetry.Enums.ModalSequence.ChatLandingModal,
		counterFormat = function(p6, _) -- line: 90
			return {
				modalVariant = p6.modalVariant,
				action = p6.action
			}
		end
	}),
	ModalActionResult = ModalTelemetry.Events.modalActionResultWithSequence({
		modalSequence = ModalTelemetry.Enums.ModalSequence.ChatLandingModal,
		counterFormat = function(p8, _) -- line: 102
			return {
				modalVariant = p8.modalVariant,
				action = p8.action,
				actionResult = p8.actionResult
			}
		end
	})
}

return t1
