local ChromeShared = script:FindFirstAncestor("ChromeShared")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local EngineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
local Cryo = require(CorePackages.Packages.Cryo)
local Service = require(ChromeShared.Service)
local Constants = require(ChromeShared.Unibar.Constants)

require(CorePackages.Workspace.Packages.Chrome)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableSideSheet = SharedFlags.FFlagEnableSideSheet
local FFlagChromeActivatedMappedSignal = SharedFlags.FFlagChromeActivatedMappedSignal
local FFlagIntegrationsChromeShortcutTelemetry = require(ChromeShared.Parent.Flags.FFlagIntegrationsChromeShortcutTelemetry)
local Tracker = require(ChromeShared.Analytics.Tracker)
local _ = {
	INACTIVE = 0,
	ACTIVE = 1
}
local _ = {
	NONE = 0,
	STARTED = 1,
	DRAGGED = 2
}
local t1 = {}

t1.__index = t1

local function getDynamicEventProps() -- line: 96
	-- upvalues: PlayerGui (copy), Constants (copy), UserInputService (copy)
	local s1 = "Unknown"

	if PlayerGui then
		s1 = Constants.ANALYTICS.SCREEN_ORIENTATION_MAP[PlayerGui.CurrentScreenOrientation] or tostring(PlayerGui.CurrentScreenOrientation)
	end

	local v25 = Constants.ANALYTICS.INPUT_TYPE_MAP[UserInputService:GetLastInputType()] or tostring(UserInputService:GetLastInputType())

	return {
		screen_orientation = s1,
		last_input_device = v25
	}
end
local function getTrackerName(s2: string, p1) -- line: 113
	return s2 .. p1
end
local function getIntegration(p2) -- line: 117
	-- upvalues: Service (copy)
	return Service:integrations()[p2]
end
local function getInteractionSource(p3) -- line: 121
	-- upvalues: FFlagEnableSideSheet (copy), Service (copy)
	if FFlagEnableSideSheet and Service:withinOpenSideSheet(p3) then
		return "sidesheet"
	end

	if Service:withinCurrentSubmenu(p3) then
		return (Service:currentSubMenu():get())
	end

	if Service:withinCurrentTopLevelMenu(p3) then
		return "unibar"
	end

	return "unknown"
end

function t1.new() -- line: 135
	-- upvalues: RbxAnalyticsService (copy), Tracker (copy), t1 (copy), EngineFeature (copy), Service (copy), Cryo (copy), getDynamicEventProps (copy), GuiService (copy), FFlagIntegrationsChromeShortcutTelemetry (copy)
	local v30 = setmetatable({
		_target = "client",
		_context = "chrome",
		_defaultProps = {
			screen_width = 0,
			screen_height = 0,
			is_game_menu_opened = false,
			universeid = tostring(game.GameId),
			placeid = tostring(game.PlaceId),
			sessionid = RbxAnalyticsService:GetSessionId()
		},
		_tracker = Tracker.new()
	}, t1)

	if EngineFeature then
		v30._defaultProps.playsessionid = RbxAnalyticsService:GetPlaySessionId()
	end

	function v30._observeIntegration(p4) -- line: 156
		-- upvalues: Service (copy), v30 (copy)
		local v102 = Service:integrations()[p4]

		if v102 and v102.windowSize then
			v30._tracker:set("window_size_" .. p4, v102.windowSize:get())
			v102.windowSize:connect(function(p5) -- line: 165
				-- upvalues: v102 (copy), v30 (copy), p4 (copy)
				if typeof(p5) ~= "UDim2" then
					return
				end

				local v121 = v102.windowSize:get()
				local v122 = v30._tracker:get("window_status_" .. p4)
				local v123 = "window_size_" .. p4

				if v122 == 1 then
					if v30._tracker:get(v123) then
						v30:onWindowResize(p4, v121)
					end

					v30._tracker:set(v123, v121)
				end
			end)
		end
	end
	function v30._resetWindowTrackers(p6) -- line: 188
		-- upvalues: v30 (copy)
		v30._tracker:reset("window_dposition_" .. p6)
		v30._tracker:reset("window_position_" .. p6)
		v30._tracker:reset("window_size_" .. p6)
		v30._tracker:reset("window_drag_" .. p6)
		v30._tracker:reset("window_status_" .. p6)
	end
	function v30._defaultWindowTrackers(p7) -- line: 196
		-- upvalues: v30 (copy)
		v30._resetWindowTrackers(p7)
		v30._tracker:startTime("window_time_" .. p7)
		v30._tracker:set("window_status_" .. p7, 1)
	end
	function v30._sendEvent(s3: string, p8) -- line: 202
		-- upvalues: Cryo (copy), getDynamicEventProps (copy), v30 (copy), RbxAnalyticsService (copy)
		local v107 = Cryo.Dictionary.join(getDynamicEventProps(), v30._defaultProps, p8 or {})

		RbxAnalyticsService:SendEventDeferred(v30._target, v30._context, s3, v107)
	end
	function v30._calculateWindowAbsolutePosition(uDim2: UDim2, uDim2_2: UDim2) -- line: 207
		-- upvalues: v30 (copy)
		local screen_width = v30._defaultProps.screen_width
		local screen_height = v30._defaultProps.screen_height

		return Vector2.new(uDim2.X.Scale * screen_width + uDim2.X.Offset - uDim2_2.Width.Offset / 2, uDim2.Y.Scale * screen_height + uDim2.Y.Offset - uDim2_2.Height.Offset / 2)
	end
	function v30._setWindowLastPosition(p9, vector2: Vector2) -- line: 216
		-- upvalues: v30 (copy)
		v30._tracker:set("window_position_" .. p9, vector2)
	end

	GuiService.MenuOpened:Connect(function() -- line: 220
		-- upvalues: v30 (copy)
		v30._defaultProps.is_game_menu_opened = not v30._defaultProps.is_game_menu_opened
	end)

	for _, v32 in Service:integrations() do
		v30._observeIntegration(v32.id)
	end

	Service:onIntegrationRegistered():connect(function(p10) -- line: 228
		-- upvalues: v30 (copy)
		v30._observeIntegration(p10)
	end)
	Service:onIntegrationActivated():connect(function(p11, p12) -- line: 232
		-- upvalues: FFlagIntegrationsChromeShortcutTelemetry (copy), v30 (copy)
		if FFlagIntegrationsChromeShortcutTelemetry then
			v30:onIconActivated(p11, p12)

			return
		end

		v30:onIconActivated(p11)
	end)
	Service:onIntegrationStatusChanged():connect(function(p13, n1: number) -- line: 240
		-- upvalues: Service (copy), v30 (copy)
		local v119 = Service:integrations()[p13]

		if v119 and v119.components.Window then
			if n1 == Service.IntegrationStatus.Window then
				v30:onWindowOpened(p13)

				return
			end

			v30:onWindowClosed(p13)
		end
	end)

	return v30
end
function t1.setScreenSize(t2: {[any]: any}, vector2: Vector2) -- line: 254
	t2._defaultProps.screen_width = vector2.X
	t2._defaultProps.screen_height = vector2.Y

	return nil
end
function t1.onIconActivated(p14, p15, p16) -- line: 260
	-- upvalues: Service (copy), FFlagChromeActivatedMappedSignal (copy), Constants (copy), FFlagEnableSideSheet (copy), FFlagIntegrationsChromeShortcutTelemetry (copy)
	local v38 = Service:integrations()[p15]

	if v38 then
		local v39 = v38.notification:get()
		local n2 = 0

		if v39.type == "count" then
			n2 = tonumber(v39.value) or 0
		end

		local v41 = nil

		if v38.isActivated then
			v41 = if not FFlagChromeActivatedMappedSignal then not v38.isActivated() else not v38.isActivated:get()
		end

		p14._sendEvent(Constants.ANALYTICS.ICON_ACTIVATED, {
			integration_id = p15,
			source = if not FFlagEnableSideSheet or not Service:withinOpenSideSheet(p15) then if not Service:withinCurrentSubmenu(p15) then not Service:withinCurrentTopLevelMenu(p15) and "unknown" or "unibar" else Service:currentSubMenu():get() else "sidesheet",
			notification_count = n2,
			is_toggle_on = v41,
			used_shortcut = if not FFlagIntegrationsChromeShortcutTelemetry or not p16 then nil else p16.fromShortcut or false
		})
	end

	return nil
end
function t1.onIconTouchBegan(p17, p18) -- line: 292
	p17._tracker:set("icon_drag_" .. p18, 1)

	return nil
end
function t1.onIconDrag(p19, p20) -- line: 297
	-- upvalues: Constants (copy), FFlagEnableSideSheet (copy), Service (copy)
	local v46 = "icon_drag_" .. p20

	if p19._tracker:get(v46) == 1 then
		p19._tracker:set(v46, 2)
		p19._sendEvent(Constants.ANALYTICS.ICON_DRAG_START, {
			integration_id = p20,
			source = if not FFlagEnableSideSheet or not Service:withinOpenSideSheet(p20) then if not Service:withinCurrentSubmenu(p20) then not Service:withinCurrentTopLevelMenu(p20) and "unknown" or "unibar" else Service:currentSubMenu():get() else "sidesheet"
		})
	end

	return nil
end
function t1.onIconTouchEnded(t3: {[any]: any}, p21, vector2: Vector2, b1: boolean) -- line: 310
	-- upvalues: Service (copy), Constants (copy), FFlagEnableSideSheet (copy)
	local v51 = "icon_drag_" .. p21
	local v52 = t3._tracker:get(v51)
	local v53 = Service:integrations()[p21]

	if v53 and (v53.windowSize and v52 == 2) then
		t3._tracker:reset(v51)
		t3._setWindowLastPosition(p21, vector2)

		local v54 = v53.windowSize:get()

		t3._sendEvent(Constants.ANALYTICS.ICON_DRAG_END, {
			integration_id = p21,
			source = if not FFlagEnableSideSheet or not Service:withinOpenSideSheet(p21) then if not Service:withinCurrentSubmenu(p21) then not Service:withinCurrentTopLevelMenu(p21) and "unknown" or "unibar" else Service:currentSubMenu():get() else "sidesheet",
			window_position_x = vector2.X,
			window_position_y = vector2.Y,
			window_width = v54.Width.Offset,
			window_height = v54.Height.Offset,
			will_reposition = b1
		})
	end

	return nil
end
function t1.onWindowOpened(p22, p23) -- line: 337
	-- upvalues: Service (copy), Constants (copy)
	local v57 = Service:integrations()[p23]
	local v58 = p22._tracker:get("window_status_" .. p23)

	if v57 and v58 ~= 1 then
		p22._defaultWindowTrackers(p23)

		local v59 = "window_dposition_" .. p23

		if not p22._tracker:get(v59) and v57.windowSize then
			local v60 = v57.windowSize:get()

			if v60 then
				local v61 = Service:windowPosition(v57.id) or (v57.startingWindowPosition or UDim2.fromOffset(0, 0))

				p22:setWindowDefaultPosition(p23, (p22._calculateWindowAbsolutePosition(v61, v60)))
			end
		end

		p22._sendEvent(Constants.ANALYTICS.WINDOW_OPENED, {
			integration_id = p23
		})
	end

	return nil
end
function t1.onWindowClosed(p24, p25) -- line: 363
	-- upvalues: Constants (copy)
	if p24._tracker:get("window_status_" .. p25) == 1 then
		p24._sendEvent(Constants.ANALYTICS.WINDOW_CLOSED, {
			integration_id = p25,
			total_open_time = p24._tracker:finishTime("window_time_" .. p25)
		})
		p24._resetWindowTrackers(p25)
	end

	return nil
end
function t1.onWindowTouchBegan(t4: {[any]: any}, p26, _: Vector2) -- line: 376
	-- upvalues: Service (copy)
	local v67 = Service:integrations()[p26]

	if v67 and v67.windowSize then
		t4._tracker:set("window_drag_" .. p26, 1)
	end

	return nil
end
function t1.onWindowDrag(t5: {[any]: any}, p27, vector3: Vector3) -- line: 384
	-- upvalues: Service (copy), Constants (copy)
	local v71 = "window_drag_" .. p27
	local v72 = t5._tracker:get(v71)
	local v73 = Service:integrations()[p27]

	if v73 and (v73.windowSize and v72 == 1) then
		local v74 = t5._tracker:get("window_position_" .. p27)

		if v74 then
			local vector2 = Vector2.new(vector3.X - v74.X, vector3.Y - v74.Y)

			if vector2.X ~= 0 or vector2.Y ~= 0 then
				t5._tracker:set(v71, 2)

				local v76 = v73.windowSize:get()
				local v77 = t5._tracker:get("window_dposition_" .. p27)

				t5._sendEvent(Constants.ANALYTICS.WINDOW_DRAG_START, {
					integration_id = p27,
					position_x = v74.X,
					position_y = v74.Y,
					width = v76.Width.Offset,
					height = v76.Height.Offset,
					is_starting_position = v77 == v74
				})
			end
		end
	end

	return nil
end
function t1.onWindowTouchEnded(t6: {[any]: any}, p28, vector2: Vector2, b2: boolean) -- line: 417
	-- upvalues: Service (copy), Constants (copy)
	local v82 = t6._tracker:get("icon_drag_" .. p28)
	local v83 = Service:integrations()[p28]

	if v82 == 2 then
		return t6:onIconTouchEnded(p28, vector2, b2)
	end

	local v84 = "window_drag_" .. p28
	local v85 = t6._tracker:get(v84)

	if v83 and v83.windowSize and v85 == 2 then
		local v86 = v83.windowSize:get()

		t6._tracker:reset(v84)
		t6._setWindowLastPosition(p28, vector2)
		t6._sendEvent(Constants.ANALYTICS.WINDOW_DRAG_END, {
			integration_id = p28,
			position_x = vector2.X,
			position_y = vector2.Y,
			width = v86.Width.Offset,
			height = v86.Height.Offset,
			will_autoposition = b2
		})
	end

	return nil
end
function t1.setWindowDefaultPosition(t7: {[any]: any}, p29, vector2: Vector2) -- line: 449
	t7._tracker:set("window_dposition_" .. p29, vector2)
	t7._setWindowLastPosition(p29, vector2)

	return nil
end
function t1.onWindowResize(t8: {[any]: any}, p30, uDim2: UDim2) -- line: 455
	-- upvalues: Service (copy), Constants (copy)
	local v93 = Service:integrations()[p30]

	if v93 and v93.windowSize then
		local v94 = "window_size_" .. p30
		local v95 = "window_position_" .. p30
		local v96 = t8._tracker:get(v94)
		local v97 = t8._tracker:get(v95)
		local vector2 = nil

		if v97 then
			local v99 = (v96.Height.Offset - uDim2.Height.Offset) / 2
			local v100 = (v96.Width.Offset - uDim2.Width.Offset) / 2

			vector2 = Vector2.new(v97.X + v100, v97.Y + v99)
		end

		if vector2 then
			t8._setWindowLastPosition(p30, vector2)
		end

		t8._tracker:set(v94, uDim2)
		t8._sendEvent(Constants.ANALYTICS.WINDOW_RESIZE, {
			integration_id = p30,
			previous_position_x = v97 and v97.X or nil,
			previous_position_y = v97 and v97.Y or nil,
			previous_width = v96 and v96.Width.Offset or nil,
			previous_height = v96 and v96.Height.Offset or nil,
			current_position_x = vector2 and vector2.X or nil,
			current_position_y = vector2 and vector2.Y or nil,
			current_width = uDim2.Width.Offset,
			current_height = uDim2.Height.Offset
		})
	end

	return nil
end

t1.default = t1.new()

return t1
