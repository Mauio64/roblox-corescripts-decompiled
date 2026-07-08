local TelemetryService = game:GetService("TelemetryService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local GamepadMenu = script.Parent.Parent.Components.Presentation.GamepadMenu

require(GamepadMenu.EnumGamepadMenuOptions)

local EngineFeature = game:GetEngineFeature("TelemetryServicePlaySessionInfoEnabled")
local v5 = game:DefineFastInt("GamepadMenuActionThrottleHundrethsPercent", 0)

local function mapProp(p1, p2: ((...any) -> ...any)) -- line: 26
	if p1 ~= nil then
		return (p2(p1))
	end

	return nil
end

local t1 = {}

t1.__index = t1

function t1.new() -- line: 34
	-- upvalues: t1 (copy)
	return (setmetatable({}, t1))
end
function t1.onOptionSelected(t2: {[any]: any}) -- line: 39
	-- upvalues: v5 (copy), EngineFeature (copy), RbxAnalyticsService (copy), TelemetryService (copy)
	local t3 = {
		eventName = "coreui_gamepad_menu_action",
		description = "Event fired from the client every time GamepadMenu Options are Selected",
		links = "https://github.rbx.com/Roblox/proto-schemas/pull/5803",
		backends = { "EventIngest" },
		throttlingPercentage = v5,
		lastUpdated = {
			25,
			4,
			30
		}
	}
	local t4 = {
		"addPlaceId",
		"addUniverseId",
		"addSessionInfo"
	}
	local t5 = {
		menu_option_name = t2.menuOptionName
	}
	local usedShortcut = t2.usedShortcut
	local _tostring = tostring

	t5.used_shortcut = if usedShortcut == nil then nil else _tostring(usedShortcut)

	local isToggleOpen = t2.isToggleOpen
	local _tostring2 = tostring

	t5.is_toggle_open = if isToggleOpen == nil then nil else _tostring2(isToggleOpen)

	if EngineFeature then
		table.insert(t4, "addPlaySessionId")
	else
		t4 = {
			"addPlaceId",
			"addUniverseId",
			"addSessionInfo"
		}
		t5.playsessionid = RbxAnalyticsService:GetPlaySessionId()
	end

	TelemetryService:LogEvent(t3, {
		standardizedFields = t4,
		customFields = t5
	})
end

t1.default = t1.new()

return t1
