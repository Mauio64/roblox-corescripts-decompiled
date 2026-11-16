local ChromeShared = script:FindFirstAncestor("ChromeShared")
local ChromeUtils = require(ChromeShared.Service.ChromeUtils)

local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local LocalizationService = game:GetService("LocalizationService")
local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local localization = InExperienceLocales.Localization.new(LocalizationService.RobloxLocaleId)

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)

require(CorePackages.Workspace.Packages.Chrome)

local Signal = AppCommonLib.Signal
local AvailabilitySignal = ChromeUtils.AvailabilitySignal
local AvailabilitySignalState = ChromeUtils.AvailabilitySignalState

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagGamepadIconSupportCheck = SharedFlags.FFlagGamepadIconSupportCheck

local ShortcutService = {}
ShortcutService.__index = ShortcutService

local function _handleShortcutEvent(object) -- 1 equivalent call inferred from this helper
	return function(p: string, p2, _)
		if p2 ~= Enum.UserInputState.Begin then
			return Enum.ContextActionResult.Pass
		end

		for k, shortcut in object._shortcuts do
			if shortcut.actionName and shortcut.actionName == p then
				return object:activateShortcut(k) or Enum.ContextActionResult.Sink
			end
		end

		return Enum.ContextActionResult.Pass
	end
end

function ShortcutService.new()
	return (setmetatable({
		_shortcuts = {},
		_shortcutBarList = {},
		_shortcutBarHiddenOverrides = {},
		["onShortcutBarChanged"] = Signal.new(),
		_boundShortcuts = {}
	}, ShortcutService))
end

function ShortcutService:registerShortcut(state)
	if self._shortcuts[state.id] then
		warn(string.format("shortcut " .. state.id .. " already registered", debug.traceback()))
	end

	if state.label then
		state.label = localization:Format(state.label)
	end

	state.displayPriority = state.displayPriority or 0

	if state.availability == nil then
		state.availability = AvailabilitySignal.new(AvailabilitySignalState.Available)
	end

	state.availability:connect(function()
		self:shortcutChanged(state)
	end)

	state.icon = UserInputService:GetImageForKeyCode(state.keyCode)

	self._shortcuts[state.id] = state
end

function ShortcutService:activateShortcut(p)
	if self._shortcuts[p] then
		local shortcut = self._shortcuts[p]

		if shortcut.activated then
			return shortcut.activated()
		end
	end

	return nil
end

function ShortcutService:shortcutChanged(_)
	self:updateShortcutBar(self:getCurrentShortcutBar())
end

function ShortcutService:updateShortcutBar(currentShortcutBar)
	self:_unbindAllShortcuts()
	self._currentShortcutBar = currentShortcutBar

	if self._shortcutBarHidden then
		self.onShortcutBarChanged:fire(nil)
		return
	end

	self.onShortcutBarChanged:fire(currentShortcutBar)

	if currentShortcutBar and self._shortcutBarList[currentShortcutBar] then
		self:_bindShortcutBar(currentShortcutBar)
	end
end

function ShortcutService:configureShortcutBar(p, p2)
	self._shortcutBarList[p] = p2
end

function ShortcutService:setShortcutBar(p)
	if self._currentShortcutBar ~= p then
		self:updateShortcutBar(p)
	end
end

function ShortcutService:setHideShortcutBar(p, flag: boolean?)
	if self._shortcutBarHiddenOverrides[p] ~= flag then
		if flag then
			self._shortcutBarHiddenOverrides[p] = flag
		else
			self._shortcutBarHiddenOverrides[p] = nil
		end

		local shortcutBarHidden = false

		for _, shortcutBarHiddenOverride in pairs(self._shortcutBarHiddenOverrides) do
			if shortcutBarHiddenOverride then
				shortcutBarHidden = true
				break
			end
		end

		self._shortcutBarHidden = shortcutBarHidden
		self:updateShortcutBar(self._currentShortcutBar)
	end
end

function ShortcutService:getHideShortcutBar()
	return self._shortcutBarHidden
end

function ShortcutService:getShortcut(p)
	return self._shortcuts[p]
end

function ShortcutService:getShortcutsFromBar(p, _)
	if not p then
		return {}
	end

	local shortcuts = {}

	for _, v in self._shortcutBarList[p] do
		if self._shortcuts[v] then
			local shortcut = self._shortcuts[v]

			if
				shortcut.availability:get() ~= AvailabilitySignalState.Unavailable
				and (not FFlagGamepadIconSupportCheck or UserInputService:GamepadSupports(
					UserInputService:GetLastInputType(),
					shortcut.keyCode
				))
			then
				table.insert(shortcuts, shortcut)
			end
		else
			warn(string.format("shortcut " .. v .. " not found", debug.traceback()))
		end
	end

	return shortcuts
end

function ShortcutService:getCurrentShortcutBar()
	return self._currentShortcutBar
end

function ShortcutService:_bindShortcutBar(p)
	for _, v in self._shortcutBarList[p] do
		local shortcut = self._shortcuts[v]

		if not (shortcut and shortcut.actionName) then
			continue
		end

		self:_unbindShortcut(v)

		if shortcut.availability:get() ~= AvailabilitySignalState.Unavailable then
			self:_bindShortcut(v)
		end
	end
end

function ShortcutService:_unbindShortcutBar(p)
	if p then
		for _, v in self._shortcutBarList[p] do
			local shortcut = self._shortcuts[v]

			if shortcut and shortcut.actionName then
				self:_unbindShortcut(v)
			end
		end
	end
end

function ShortcutService:_bindShortcut(p)
	local shortcut = self._shortcuts[p]

	if shortcut and shortcut.actionName then
		ContextActionService:BindCoreAction(shortcut.actionName, _handleShortcutEvent(self), false, shortcut.keyCode) -- inferred equivalent call
		self._boundShortcuts[shortcut.actionName] = true
	end
end

function ShortcutService:_unbindShortcut(p)
	local shortcut = self._shortcuts[p]

	if shortcut and shortcut.actionName then
		ContextActionService:UnbindCoreAction(shortcut.actionName)
		self._boundShortcuts[shortcut.actionName] = false
	end
end

function ShortcutService:_unbindAllShortcuts()
	for k, boundShortcut in self._boundShortcuts do
		if not boundShortcut then
			continue
		end

		ContextActionService:UnbindCoreAction(k)
		self._boundShortcuts[k] = false
	end
end

return ShortcutService
