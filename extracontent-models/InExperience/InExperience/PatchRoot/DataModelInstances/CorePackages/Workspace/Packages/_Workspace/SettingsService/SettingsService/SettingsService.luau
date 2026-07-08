local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local LocalizationService = game:GetService("LocalizationService")
local Signals = require(scriptParentParent.Signals)

require(scriptParent.Types)

local SettingEnum = require(scriptParent.SettingEnum)
local ValueChangedSignal = require(scriptParent.ValueChangedSignal)
local Localization = require(scriptParentParent.InExperienceLocales).Localization
local t1 = {}

t1.__index = t1

function t1.new() -- line: 72
	-- upvalues: LocalizationService (copy), Localization (copy), t1 (copy)
	local t2 = {}
	local RobloxLocaleId = LocalizationService.RobloxLocaleId

	t2._localization = Localization.new(RobloxLocaleId)
	t2._settings = {}
	t2._signals = {}
	t2._disposables = {}

	return (setmetatable(t2, t1))
end
function t1.registerSetting(p1, p2) -- line: 82
	-- upvalues: Signals (copy), SettingEnum (copy)
	p1._disposables[p2.id] = {}

	if p2.alreadyLocalized == nil then
		p2.alreadyLocalized = true
	end

	local v13, v14 = Signals.createSignal(true)

	if p2.onAvailabilityChanged then
		table.insert(p1._disposables[p2.id], Signals.createEffect(function(p3) -- line: 93
			-- upvalues: v13 (copy), p2 (copy)
			local v48 = v13(p3)

			p2.onAvailabilityChanged(v48)
		end))
	end

	if p2.initialAvailability ~= nil then
		v14(p2.initialAvailability)
	end

	local v15, v16 = Signals.createSignal(true)

	if p2.onVisibilityChanged then
		table.insert(p1._disposables[p2.id], Signals.createEffect(function(p4) -- line: 106
			-- upvalues: v15 (copy), p2 (copy)
			local v50 = v15(p4)

			p2.onVisibilityChanged(v50)
		end))
	end

	if p2.initialVisibility ~= nil then
		v16(p2.initialVisibility)
	end

	p1._signals[p2.id] = {
		availability = v13,
		setAvailability = v14,
		visibility = v15,
		setVisibility = v16
	}
	p2.subscribeAvailable = v13
	p2.subscribeVisible = v15

	if not p2.alreadyLocalized then
		p2.label = p1:_updateLocalization(p2.label)
		p2.description = p1:_updateLocalization(p2.description)
	end

	local v17 = p2

	if v17.field_type == SettingEnum.Selector then
		v17 = p1:_registerSelector(v17)
	elseif v17.field_type == SettingEnum.Slider then
		v17 = p1:_registerSlider(v17)
	elseif v17.field_type == SettingEnum.Dropdown then
		v17 = p1:_registerDropdown(v17)
	elseif v17.field_type == SettingEnum.TextButton then
		v17 = p1:_registerTextButton(v17)
	elseif v17.field_type == SettingEnum.Toggle then
		v17 = p1:_registerToggle(v17)
	else
		error(tostring(v17.field_type) .. " is not a valid field_type")
	end

	p1._settings[v17.id] = v17

	return v17
end
function t1.setting(p5, p6) -- line: 147
	if not p5._settings[p6] then
		error("No setting registered with id: " .. p6)
	end

	return p5._settings[p6]
end
function t1.updateSetting(t3: {[any]: any}, p7, t4: {[any]: any}) -- line: 154
	assert(typeof(t3:setting(p7)) == "table", "No setting registered with id: " .. p7)

	if t4.available ~= nil then
		t3._signals[p7].setAvailability(t4.available)
	end

	if t4.visible ~= nil then
		t3._signals[p7].setVisibility(t4.visible)
	end
end
function t1.disconnect(p8) -- line: 164
	for _, v25 in p8._disposables do
		for _, v27 in v25 do
			v27()
		end
	end

	p8._disposables = {}
	p8._signals = {}
	p8._settings = {}
end
function t1._updateLocalization(p9, p10) -- line: 176
	if p10 == nil then
		return nil
	end

	local _localization = p9._localization

	if typeof(p10) == "string" then
		return _localization:Format(p10)
	end

	return _localization:Format(p10.key, p10.args)
end
function t1._registerToggle(_, p12) -- line: 188
	return p12
end
function t1._registerOptions(t5: {[any]: any}, b1: boolean, t6: {[any]: any}) -- line: 193
	for _, v in ipairs(t6) do
		if not b1 then
			v.text = t5:_updateLocalization(v.text)
		end

		local v38 = v.initialAvailability == nil or v.initialAvailability

		if v.onAvailabilityChanged then
			v.onAvailabilityChanged(v38)
		end
	end

	return t6
end
function t1._registerSlider(p13, p14) -- line: 212
	if not p14.alreadyLocalized then
		p14.sliderLeftLabel = p13:_updateLocalization(p14.sliderLeftLabel)
		p14.sliderRightLabel = p13:_updateLocalization(p14.sliderRightLabel)
	end

	return p14
end
function t1._registerTextButton(p15, p16) -- line: 221
	if not p16.alreadyLocalized then
		p16.text = p15:_updateLocalization(p16.text)
	end

	return p16
end
function t1._registerDropdown(p17, p18) -- line: 233
	-- upvalues: ValueChangedSignal (copy)
	if not p18.alreadyLocalized then
		p18.placeholder = p17:_updateLocalization(p18.placeholder)
	end

	p18.onMenuOpenChange = p18.onMenuOpenChange or ValueChangedSignal.new(nil)
	p18.options = p17:_registerOptions(p18.alreadyLocalized, p18.options)

	return p18
end
function t1._registerSelector(p19, p20) -- line: 243
	if not p20.alreadyLocalized then
		p20.placeholder = p19:_updateLocalization(p20.placeholder)
	end

	p20.options = p19:_registerOptions(p20.alreadyLocalized, p20.options)

	return p20
end

return t1
