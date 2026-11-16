local TelemetryService = game:GetService("TelemetryService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local GamepadMenu = script.Parent.Parent.Components.Presentation.GamepadMenu
require(GamepadMenu.EnumGamepadMenuOptions)
local engineFeature = game:GetEngineFeature("TelemetryServicePlaySessionInfoEnabled")
local defineFastInt = game:DefineFastInt("GamepadMenuActionThrottleHundrethsPercent", 0)

local function mapProp(p, callback)
	if p == nil then
		return nil
	end

	return (callback(p))
end

local GamepadMenuTelemetry = {}
GamepadMenuTelemetry.__index = GamepadMenuTelemetry

function GamepadMenuTelemetry.new()
	return (setmetatable({}, GamepadMenuTelemetry))
end

function GamepadMenuTelemetry.onOptionSelected(data)
	local standardizedFields = { "addPlaceId", "addUniverseId", "addSessionInfo" }
	local customFields = {
		menu_option_name = data.menuOptionName,
		used_shortcut = 0,
		is_toggle_open = 0
	}
	local usedShortcut = data.usedShortcut
	local tostring2 = tostring
	local used_shortcut

	if usedShortcut ~= nil then
		used_shortcut = tostring2(usedShortcut)
	end

	customFields.used_shortcut = used_shortcut
	local isToggleOpen = data.isToggleOpen
	local tostring = tostring
	local is_toggle_open

	if isToggleOpen ~= nil then
		is_toggle_open = tostring(isToggleOpen)
	end

	customFields.is_toggle_open = is_toggle_open

	if engineFeature then
		table.insert(standardizedFields, "addPlaySessionId")
	else
		customFields.playsessionid = RbxAnalyticsService:GetPlaySessionId()
		standardizedFields = { "addPlaceId", "addUniverseId", "addSessionInfo" }
	end

	TelemetryService:LogEvent({
		eventName = "coreui_gamepad_menu_action",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 25, 4, 30 },
		description = "Event fired from the client every time GamepadMenu Options are Selected",
		links = "https://github.rbx.com/Roblox/proto-schemas/pull/5803"
	}, { standardizedFields = standardizedFields, customFields = customFields })
end

GamepadMenuTelemetry.default = GamepadMenuTelemetry.new()

return GamepadMenuTelemetry
