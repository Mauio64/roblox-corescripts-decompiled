local ChromeShared = script:FindFirstAncestor("ChromeShared")
local ChromeUtils = require(ChromeShared.Service.ChromeUtils)
local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local LocalizationService = game:GetService("LocalizationService")
local v7 = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization.new(LocalizationService.RobloxLocaleId)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)

require(CorePackages.Workspace.Packages.Chrome)

local Signal = AppCommonLib.Signal
local AvailabilitySignal = ChromeUtils.AvailabilitySignal
local AvailabilitySignalState = ChromeUtils.AvailabilitySignalState
local FFlagGamepadIconSupportCheck = require(CorePackages.Workspace.Packages.SharedFlags).FFlagGamepadIconSupportCheck
local t1 = {}

t1.__index = t1

local function _handleShortcutEvent(t2: {[any]: any}) -- line: 79
	return function(s1: string, p1, _) -- line: 80
		-- upvalues: t2 (copy)
		if p1 ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end

		for v69, v70 in t2._shortcuts do
			if v70.actionName and s1 == v70.actionName then
				return t2:activateShortcut(v69) or Enum.ContextActionResult.Sink
			end
		end

		return Enum.ContextActionResult.Pass
	end
end

function t1.new() -- line: 94
	-- upvalues: Signal (copy), t1 (copy)
	return (setmetatable({
		_shortcuts = {},
		_shortcutBarList = {},
		_shortcutBarHiddenOverrides = {},
		onShortcutBarChanged = Signal.new(),
		_boundShortcuts = {}
	}, t1))
end
function t1.registerShortcut(p3, p4) -- line: 108
	-- upvalues: v7 (copy), AvailabilitySignal (copy), AvailabilitySignalState (copy), UserInputService (copy)
	if p3._shortcuts[p4.id] then
		warn(string.format("shortcut " .. p4.id .. " already registered", debug.traceback()))
	end

	if p4.label then
		p4.label = v7:Format(p4.label)
	end

	p4.displayPriority = p4.displayPriority or 0

	if p4.availability == nil then
		p4.availability = AvailabilitySignal.new(AvailabilitySignalState.Available)
	end

	p4.availability:connect(function() -- line: 122
		-- upvalues: p3 (copy), p4 (copy)
		p3:shortcutChanged(p4)
	end)
	p4.icon = UserInputService:GetImageForKeyCode(p4.keyCode)
	p3._shortcuts[p4.id] = p4
end
function t1.activateShortcut(p5, p6) -- line: 131
	if p5._shortcuts[p6] then
		local v20 = p5._shortcuts[p6]

		if v20.activated then
			return v20.activated()
		end
	end

	return nil
end
function t1.shortcutChanged(p7, _) -- line: 142
	p7:updateShortcutBar(p7:getCurrentShortcutBar())
end
function t1.updateShortcutBar(p9, p10) -- line: 146
	p9:_unbindAllShortcuts()
	p9._currentShortcutBar = p10

	if p9._shortcutBarHidden then
		p9.onShortcutBarChanged:fire(nil)

		return
	end

	p9.onShortcutBarChanged:fire(p10)

	if p10 and p9._shortcutBarList[p10] then
		p9:_bindShortcutBar(p10)
	end
end
function t1.configureShortcutBar(p11, p12, p13) -- line: 161
	p11._shortcutBarList[p12] = p13
end
function t1.setShortcutBar(p14, p15) -- line: 165
	if p15 ~= p14._currentShortcutBar then
		p14:updateShortcutBar(p15)
	end
end
function t1.setHideShortcutBar(t3: {[any]: any}, p16, b1: boolean?) -- line: 171
	if b1 ~= t3._shortcutBarHiddenOverrides[p16] then
		if b1 then
			t3._shortcutBarHiddenOverrides[p16] = b1
		else
			t3._shortcutBarHiddenOverrides[p16] = nil
		end

		local v33 = false

		for _, v in pairs(t3._shortcutBarHiddenOverrides) do
			if v then
				v33 = true

				break
			end
		end

		t3._shortcutBarHidden = v33
		t3:updateShortcutBar(t3._currentShortcutBar)
	end
end
function t1.getHideShortcutBar(p17) -- line: 192
	return p17._shortcutBarHidden
end
function t1.getShortcut(p18, p19) -- line: 196
	return p18._shortcuts[p19]
end
function t1.getShortcutsFromBar(p20, p21, _) -- line: 200
	-- upvalues: AvailabilitySignalState (copy), FFlagGamepadIconSupportCheck (copy), UserInputService (copy)
	if not p21 then
		return {}
	end

	local t4 = {}

	for _, v44 in p20._shortcutBarList[p21] do
		if not p20._shortcuts[v44] then
			warn(string.format("shortcut " .. v44 .. " not found", debug.traceback()))
		else
			local v45 = p20._shortcuts[v44]

			if v45.availability:get() ~= AvailabilitySignalState.Unavailable and (not FFlagGamepadIconSupportCheck or UserInputService:GamepadSupports(UserInputService:GetLastInputType(), v45.keyCode)) then
				table.insert(t4, v45)
			end
		end
	end

	return t4
end
function t1.getCurrentShortcutBar(p23) -- line: 229
	return p23._currentShortcutBar
end
function t1._bindShortcutBar(p24, p25) -- line: 233
	-- upvalues: AvailabilitySignalState (copy)
	for _, v50 in p24._shortcutBarList[p25] do
		local v51 = p24._shortcuts[v50]

		if v51 and v51.actionName then
			p24:_unbindShortcut(v50)

			if v51.availability:get() ~= AvailabilitySignalState.Unavailable then
				p24:_bindShortcut(v50)
			end
		end
	end
end
function t1._unbindShortcutBar(p26, p27) -- line: 247
	if p27 then
		for _, v55 in p26._shortcutBarList[p27] do
			local v56 = p26._shortcuts[v55]

			if v56 and v56.actionName then
				p26:_unbindShortcut(v55)
			end
		end
	end
end
function t1._bindShortcut(p28, p29) -- line: 258
	-- upvalues: ContextActionService (copy)
	local v59 = p28._shortcuts[p29]

	if v59 and v59.actionName then
		ContextActionService:BindCoreAction(v59.actionName, function(s2: string, p30, _) -- line: 80
			-- upvalues: p28 (copy)
			if p30 ~= Enum.UserInputState.Begin then
				return Enum.ContextActionResult.Pass
			end

			for v74, v75 in p28._shortcuts do
				if v75.actionName and s2 == v75.actionName then
					return p28:activateShortcut(v74) or Enum.ContextActionResult.Sink
				end
			end

			return Enum.ContextActionResult.Pass
		end, false, v59.keyCode)
		p28._boundShortcuts[v59.actionName] = true
	end
end
function t1._unbindShortcut(p32, p33) -- line: 266
	-- upvalues: ContextActionService (copy)
	local v62 = p32._shortcuts[p33]

	if v62 and v62.actionName then
		ContextActionService:UnbindCoreAction(v62.actionName)
		p32._boundShortcuts[v62.actionName] = false
	end
end
function t1._unbindAllShortcuts(p34) -- line: 274
	-- upvalues: ContextActionService (copy)
	for v64, v65 in p34._boundShortcuts do
		if v65 then
			ContextActionService:UnbindCoreAction(v64)
			p34._boundShortcuts[v64] = false
		end
	end
end

return t1
