local ChromeShared = script:FindFirstAncestor("ChromeShared")

local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local engineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

local Cryo = require(CorePackages.Packages.Cryo)

local Service = require(ChromeShared.Service)
local Constants = require(ChromeShared.Unibar.Constants)
require(CorePackages.Workspace.Packages.Chrome)

local isSideSheetEnabled = require(CorePackages.Workspace.Packages.InExperienceSideSheetUtils.isSideSheetEnabled)
local FFlagIntegrationsChromeShortcutTelemetry = require(ChromeShared.Parent.Flags.FFlagIntegrationsChromeShortcutTelemetry)

local Tracker = require(ChromeShared.Analytics.Tracker)

local _ = { INACTIVE = 0, ACTIVE = 1 }

local _ = { NONE = 0, STARTED = 1, DRAGGED = 2 }

local ChromeAnalytics = {}
ChromeAnalytics.__index = ChromeAnalytics

local function getDynamicEventProps()
	return {
		screen_orientation = not playerGui and "Unknown" or Constants.ANALYTICS.SCREEN_ORIENTATION_MAP[playerGui.CurrentScreenOrientation] or tostring(playerGui.CurrentScreenOrientation),
		last_input_device = Constants.ANALYTICS.INPUT_TYPE_MAP[UserInputService:GetLastInputType()] or tostring(UserInputService:GetLastInputType())
	}
end

local function getTrackerName(p: string, p2) -- 25 equivalent calls inferred from this helper
	return p .. p2
end

local function getIntegration(p) -- 9 equivalent calls inferred from this helper
	return Service:integrations()[p]
end

local function getInteractionSource(p) -- 3 equivalent calls inferred from this helper
	if isSideSheetEnabled and Service:withinOpenSideSheet(p) then
		return "sidesheet"
	end

	if Service:withinCurrentSubmenu(p) then
		return (Service:currentSubMenu():get())
	end

	if Service:withinCurrentTopLevelMenu(p) then
		return "unibar"
	end

	return "unknown"
end

function ChromeAnalytics.new()
	local object = setmetatable({
		_target = "client",
		_context = "chrome",
		_defaultProps = {
			screen_width = 0,
			screen_height = 0,
			universeid = tostring(game.GameId),
			placeid = tostring(game.PlaceId),
			sessionid = RbxAnalyticsService:GetSessionId(),
			is_game_menu_opened = false
		},
		_tracker = Tracker.new()
	}, ChromeAnalytics)

	if engineFeature then
		object._defaultProps.playsessionid = RbxAnalyticsService:GetPlaySessionId()
	end

	function object._observeIntegration(p)
		local integration = getIntegration(p) -- inferred equivalent call

		if integration and integration.windowSize then
			object._tracker:set(getTrackerName("window_size_", p), integration.windowSize:get()) -- inferred equivalent call

			integration.windowSize:connect(function(p2)
				if typeof(p2) ~= "UDim2" then
					return
				end

				local v = integration.windowSize:get()
				local v2 = object._tracker:get(getTrackerName("window_status_", p)) -- inferred equivalent call
				local trackerName = getTrackerName("window_size_", p) -- inferred equivalent call

				if v2 == 1 then
					if object._tracker:get(trackerName) then
						object:onWindowResize(p, v)
					end

					object._tracker:set(trackerName, v)
				end
			end)
		end
	end

	function object._resetWindowTrackers(p)
		object._tracker:reset(getTrackerName("window_dposition_", p)) -- inferred equivalent call
		object._tracker:reset(getTrackerName("window_position_", p)) -- inferred equivalent call
		object._tracker:reset(getTrackerName("window_size_", p)) -- inferred equivalent call
		object._tracker:reset(getTrackerName("window_drag_", p)) -- inferred equivalent call
		object._tracker:reset(getTrackerName("window_status_", p)) -- inferred equivalent call
	end

	function object._defaultWindowTrackers(p)
		object._resetWindowTrackers(p)
		object._tracker:startTime(getTrackerName("window_time_", p)) -- inferred equivalent call
		object._tracker:set(getTrackerName("window_status_", p), 1) -- inferred equivalent call
	end

	function object._sendEvent(p: string, options)
		local joined = Cryo.Dictionary.join(getDynamicEventProps(), object._defaultProps, options or {})
		RbxAnalyticsService:SendEventDeferred(object._target, object._context, p, joined)
	end

	function object._calculateWindowAbsolutePosition(udim: UDim2, udim2: UDim2)
		local screen_width = object._defaultProps.screen_width
		local screen_height = object._defaultProps.screen_height
		return Vector2.new(
			udim.X.Scale * screen_width + udim.X.Offset - udim2.Width.Offset / 2,
			udim.Y.Scale * screen_height + udim.Y.Offset - udim2.Height.Offset / 2
		)
	end

	function object._setWindowLastPosition(p, vector2: Vector2)
		object._tracker:set(getTrackerName("window_position_", p), vector2) -- inferred equivalent call
	end

	GuiService.MenuOpened:Connect(function()
		object._defaultProps.is_game_menu_opened = not object._defaultProps.is_game_menu_opened
	end)

	for _, v in Service:integrations() do
		object._observeIntegration(v.id)
	end

	Service:onIntegrationRegistered():connect(function(p)
		object._observeIntegration(p)
	end)

	Service:onIntegrationActivated():connect(function(p, p2)
		if FFlagIntegrationsChromeShortcutTelemetry then
			object:onIconActivated(p, p2)
		else
			object:onIconActivated(p)
		end
	end)

	Service:onIntegrationStatusChanged():connect(function(p, p2: number)
		local integration = getIntegration(p) -- inferred equivalent call

		if integration and integration.components.Window then
			if p2 == Service.IntegrationStatus.Window then
				object:onWindowOpened(p)
			else
				object:onWindowClosed(p)
			end
		end
	end)

	return object
end

function ChromeAnalytics:setScreenSize(vector2: Vector2): nil
	self._defaultProps.screen_width = vector2.X
	self._defaultProps.screen_height = vector2.Y
	return nil
end

function ChromeAnalytics:onIconActivated(integration_id, p): nil
	local integration = getIntegration(integration_id) -- inferred equivalent call

	if not integration then
		return nil
	end

	local v = integration.notification:get()

	local notification_count = v.type == "count" and tonumber(v.value) or 0
	local is_toggle_on

	if integration.isActivated then
		is_toggle_on = not integration.isActivated:get()
	end

	local sendEvent = self._sendEvent
	local ICON_ACTIVATED = Constants.ANALYTICS.ICON_ACTIVATED
	local v2 = {
		integration_id = integration_id,
		source = getInteractionSource(integration_id), -- inferred equivalent call
		notification_count = notification_count,
		is_toggle_on = is_toggle_on,
		used_shortcut = 0
	}
	local used_shortcut

	if FFlagIntegrationsChromeShortcutTelemetry and p then
		used_shortcut = p.fromShortcut or false
	end

	v2.used_shortcut = used_shortcut
	sendEvent(ICON_ACTIVATED, v2)

	return nil
end

function ChromeAnalytics:onIconTouchBegan(p): nil
	self._tracker:set(getTrackerName("icon_drag_", p), 1) -- inferred equivalent call
	return nil
end

function ChromeAnalytics:onIconDrag(integration_id): nil
	local trackerName = getTrackerName("icon_drag_", integration_id) -- inferred equivalent call

	if self._tracker:get(trackerName) ~= 1 then
		return nil
	end

	self._tracker:set(trackerName, 2)
	self._sendEvent(Constants.ANALYTICS.ICON_DRAG_START, {
		integration_id = integration_id,
		source = getInteractionSource(integration_id) -- inferred equivalent call
	})

	return nil
end

function ChromeAnalytics:onIconTouchEnded(integration_id, vector2: Vector2, will_reposition: boolean): nil
	local trackerName = getTrackerName("icon_drag_", integration_id) -- inferred equivalent call
	local v = self._tracker:get(trackerName)
	local integration = getIntegration(integration_id) -- inferred equivalent call

	if not integration or not integration.windowSize or v ~= 2 then
		return nil
	end

	self._tracker:reset(trackerName)
	self._setWindowLastPosition(integration_id, vector2)
	local v2 = integration.windowSize:get()

	self._sendEvent(Constants.ANALYTICS.ICON_DRAG_END, {
		integration_id = integration_id,
		source = getInteractionSource(integration_id), -- inferred equivalent call
		window_position_x = vector2.X,
		window_position_y = vector2.Y,
		window_width = v2.Width.Offset,
		window_height = v2.Height.Offset,
		will_reposition = will_reposition
	})

	return nil
end

function ChromeAnalytics:onWindowOpened(integration_id): nil
	local integration = getIntegration(integration_id) -- inferred equivalent call
	local v = self._tracker:get(getTrackerName("window_status_", integration_id)) -- inferred equivalent call

	if not integration or v == 1 then
		return nil
	end

	self._defaultWindowTrackers(integration_id)
	local trackerName = getTrackerName("window_dposition_", integration_id) -- inferred equivalent call

	local v2 = (not self._tracker:get(trackerName) and integration.windowSize and true or false)
		and integration.windowSize:get()

	if v2 then
		local v3 = Service:windowPosition(integration.id)
			or integration.startingWindowPosition
			or UDim2.fromOffset(0, 0)
		self:setWindowDefaultPosition(integration_id, (self._calculateWindowAbsolutePosition(v3, v2)))
	end

	self._sendEvent(Constants.ANALYTICS.WINDOW_OPENED, { integration_id = integration_id })

	return nil
end

function ChromeAnalytics:onWindowClosed(integration_id): nil
	if self._tracker:get(getTrackerName("window_status_", integration_id)) == 1 then -- inferred equivalent call
		self._sendEvent(Constants.ANALYTICS.WINDOW_CLOSED, {
			integration_id = integration_id,
			total_open_time = self._tracker:finishTime(getTrackerName("window_time_", integration_id)) -- inferred equivalent call
		})

		self._resetWindowTrackers(integration_id)
	end

	return nil
end

function ChromeAnalytics:onWindowTouchBegan(p, _: Vector2): nil
	local integration = getIntegration(p) -- inferred equivalent call

	if integration and integration.windowSize then
		self._tracker:set(getTrackerName("window_drag_", p), 1) -- inferred equivalent call
	end

	return nil
end

function ChromeAnalytics:onWindowDrag(integration_id, vector3: Vector3): nil
	local trackerName = getTrackerName("window_drag_", integration_id) -- inferred equivalent call

	local v = self._tracker:get(trackerName)
	local integration = getIntegration(integration_id) -- inferred equivalent call
	local v2 = integration
		and integration.windowSize
		and v == 1
		and self._tracker:get(getTrackerName("window_position_", integration_id)) -- inferred equivalent call

	if not v2 then
		return nil
	end

	local vector2 = Vector2.new(vector3.X - v2.X, vector3.Y - v2.Y)

	if not (vector2.X ~= 0 or vector2.Y ~= 0) then
		return nil
	end

	self._tracker:set(trackerName, 2)
	local v3 = integration.windowSize:get()

	local v4 = self._tracker:get(getTrackerName("window_dposition_", integration_id)) -- inferred equivalent call

	self._sendEvent(Constants.ANALYTICS.WINDOW_DRAG_START, {
		integration_id = integration_id,
		position_x = v2.X,
		position_y = v2.Y,
		width = v3.Width.Offset,
		height = v3.Height.Offset,
		is_starting_position = v4 == v2
	})

	return nil
end

function ChromeAnalytics:onWindowTouchEnded(integration_id, vector2: Vector2, will_autoposition: boolean)
	local v = self._tracker:get(getTrackerName("icon_drag_", integration_id)) -- inferred equivalent call
	local integration = getIntegration(integration_id) -- inferred equivalent call

	if v == 2 then
		return self:onIconTouchEnded(integration_id, vector2, will_autoposition)
	end

	local trackerName = getTrackerName("window_drag_", integration_id) -- inferred equivalent call

	local v2 = self._tracker:get(trackerName)

	if not integration or not integration.windowSize or v2 ~= 2 then
		return nil
	end

	local v3 = integration.windowSize:get()
	self._tracker:reset(trackerName)
	self._setWindowLastPosition(integration_id, vector2)
	self._sendEvent(Constants.ANALYTICS.WINDOW_DRAG_END, {
		integration_id = integration_id,
		position_x = vector2.X,
		position_y = vector2.Y,
		width = v3.Width.Offset,
		height = v3.Height.Offset,
		will_autoposition = will_autoposition
	})

	return nil
end

function ChromeAnalytics:setWindowDefaultPosition(p, vector2: Vector2): nil
	self._tracker:set(getTrackerName("window_dposition_", p), vector2) -- inferred equivalent call
	self._setWindowLastPosition(p, vector2)
	return nil
end

function ChromeAnalytics:onWindowResize(integration_id, udim: UDim2): nil
	local integration = getIntegration(integration_id) -- inferred equivalent call

	if not (integration and integration.windowSize) then
		return nil
	end

	local v = "window_size_" .. integration_id
	local v2 = "window_position_" .. integration_id

	local v3 = self._tracker:get(v)
	local v4 = self._tracker:get(v2)
	local vector2

	if v4 then
		local v5 = (v3.Height.Offset - udim.Height.Offset) / 2
		local v6 = (v3.Width.Offset - udim.Width.Offset) / 2

		vector2 = Vector2.new(v4.X + v6, v4.Y + v5)
	end

	if vector2 then
		self._setWindowLastPosition(integration_id, vector2)
	end

	self._tracker:set(v, udim)

	local sendEvent = self._sendEvent
	local WINDOW_RESIZE = Constants.ANALYTICS.WINDOW_RESIZE
	local previous_position_x

	if v4 then
		previous_position_x = v4.X or nil
	end

	local v5 = {
		integration_id = integration_id,
		previous_position_x = previous_position_x,
		previous_position_y = v4 and v4.Y or nil,
		previous_width = 0,
		previous_height = 0,
		current_position_x = 0,
		current_position_y = 0,
		current_width = 0,
		current_height = 0
	}
	local previous_width

	if v3 then
		previous_width = v3.Width.Offset or nil
	end

	v5.previous_width = previous_width
	v5.previous_height = v3 and v3.Height.Offset or nil
	local current_position_x

	if vector2 then
		current_position_x = vector2.X or nil
	end

	v5.current_position_x = current_position_x
	v5.current_position_y = vector2 and vector2.Y or nil
	v5.current_width = udim.Width.Offset
	v5.current_height = udim.Height.Offset
	sendEvent(WINDOW_RESIZE, v5)

	return nil
end

ChromeAnalytics.default = ChromeAnalytics.new()
return ChromeAnalytics
