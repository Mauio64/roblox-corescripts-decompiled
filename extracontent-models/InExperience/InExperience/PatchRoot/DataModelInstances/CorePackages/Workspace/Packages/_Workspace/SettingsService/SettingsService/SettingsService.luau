local parent = script.Parent
local parent2 = parent.Parent

local LocalizationService = game:GetService("LocalizationService")

local Signals = require(parent2.Signals)

require(parent.Types)
local SettingEnum = require(parent.SettingEnum)
local ValueChangedSignal = require(parent.ValueChangedSignal)
local InExperienceLocales = require(parent2.InExperienceLocales)
local Localization = InExperienceLocales.Localization

local SettingsService = {}
SettingsService.__index = SettingsService

function SettingsService.new()
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local v = {
		["_localization"] = Localization.new(robloxLocaleId),
		_settings = {},
		_signals = {},
		_disposables = {}
	}
	return (setmetatable(v, SettingsService))
end

function SettingsService:registerSetting(state)
	self._disposables[state.id] = {}

	if state.alreadyLocalized == nil then
		state.alreadyLocalized = true
	end

	local signal, setAvailability = Signals.createSignal(true)

	if state.onAvailabilityChanged then
		table.insert(self._disposables[state.id], Signals.createEffect(function(p)
			local v = signal(p)
			state.onAvailabilityChanged(v)
		end))
	end

	if state.initialAvailability ~= nil then
		setAvailability(state.initialAvailability)
	end

	local signal2, setVisibility = Signals.createSignal(true)

	if state.onVisibilityChanged then
		table.insert(self._disposables[state.id], Signals.createEffect(function(p)
			local v = signal2(p)
			state.onVisibilityChanged(v)
		end))
	end

	if state.initialVisibility ~= nil then
		setVisibility(state.initialVisibility)
	end

	self._signals[state.id] = {
		availability = signal,
		setAvailability = setAvailability,
		visibility = signal2,
		setVisibility = setVisibility
	}

	state.subscribeAvailable = signal
	state.subscribeVisible = signal2

	if not state.alreadyLocalized then
		state.label = self:_updateLocalization(state.label)
		state.description = self:_updateLocalization(state.description)
	end

	local setting

	if state.field_type == SettingEnum.Selector then
		setting = self:_registerSelector(state)
	elseif state.field_type == SettingEnum.Slider then
		setting = self:_registerSlider(state)
	elseif state.field_type == SettingEnum.Dropdown then
		setting = self:_registerDropdown(state)
	elseif state.field_type == SettingEnum.TextButton then
		setting = self:_registerTextButton(state)
	elseif state.field_type == SettingEnum.Toggle then
		setting = self:_registerToggle(state)
	else
		error(tostring(state.field_type) .. " is not a valid field_type")
		setting = state
	end

	self._settings[setting.id] = setting
	return setting
end

function SettingsService:setting(p)
	if not self._settings[p] then
		error("No setting registered with id: " .. p)
	end

	return self._settings[p]
end

function SettingsService:updateSetting(p, p2)
	assert(typeof(self:setting(p)) == "table", "No setting registered with id: " .. p)

	if p2.available ~= nil then
		self._signals[p].setAvailability(p2.available)
	end

	if p2.visible ~= nil then
		self._signals[p].setVisibility(p2.visible)
	end
end

function SettingsService:disconnect()
	for _, disposable in self._disposables do
		for _, v in disposable do
			v()
		end
	end

	self._disposables = {}
	self._signals = {}
	self._settings = {}
end

function SettingsService:_updateLocalization(value)
	if value == nil then
		return nil
	end

	local localization = self._localization

	if typeof(value) == "string" then
		return localization:Format(value)
	end

	return localization:Format(value.key, value.args)
end

function SettingsService:_registerToggle(p)
	return p
end

function SettingsService:_registerOptions(flag: boolean, list)
	for _, item in ipairs(list) do
		if not flag then
			item.text = self:_updateLocalization(item.text)
		end

		local v = item.initialAvailability == nil or item.initialAvailability

		if item.onAvailabilityChanged then
			item.onAvailabilityChanged(v)
		end
	end

	return list
end

function SettingsService:_registerSlider(state)
	if not state.alreadyLocalized then
		state.sliderLeftLabel = self:_updateLocalization(state.sliderLeftLabel)
		state.sliderRightLabel = self:_updateLocalization(state.sliderRightLabel)
	end

	return state
end

function SettingsService:_registerTextButton(state)
	if not state.alreadyLocalized then
		state.text = self:_updateLocalization(state.text)
	end

	return state
end

function SettingsService:_registerDropdown(state)
	if not state.alreadyLocalized then
		state.placeholder = self:_updateLocalization(state.placeholder)
	end

	state.onMenuOpenChange = state.onMenuOpenChange or ValueChangedSignal.new(nil)
	state.options = self:_registerOptions(state.alreadyLocalized, state.options)
	return state
end

function SettingsService:_registerSelector(state)
	if not state.alreadyLocalized then
		state.placeholder = self:_updateLocalization(state.placeholder)
	end

	state.options = self:_registerOptions(state.alreadyLocalized, state.options)
	return state
end

return SettingsService
