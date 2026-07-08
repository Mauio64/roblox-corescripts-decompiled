local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local t1 = {
	UserGameSettings:GetPropertyChangedSignal("GamepadCameraSensitivity"),
	UserGameSettings:GetPropertyChangedSignal("MouseSensitivity"),
	UserGameSettings:GetPropertyChangedSignal("MouseSensitivityFirstPerson"),
	UserGameSettings:GetPropertyChangedSignal("MouseSensitivityThirdPerson")
}
local ParentParent = script.Parent.Parent.Parent
local ExternalEventConnection = require(ParentParent.Utility.ExternalEventConnection)
local SliderEntry = require(script.Parent.SliderEntry)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local Constants = require(ParentParent.Resources.Constants)

local function guiToEngineSensitivity(p1) -- line: 30
	return (math.clamp(if not (p1 <= 5) then 0.6 * p1 - 2 else 0.198 * p1 + 0.01, 0, 10))
end
local function engineToGuiSensitivity(p2) -- line: 41
	return (math.clamp(math.floor(((if not (p2 <= 1) then (p2 + 2) / 0.6 else (p2 - 0.01) / 0.198)) / 0.01 + 0.5) * 0.01, 0, 10))
end

local v14 = Roact.PureComponent:extend("CameraSensitivityEntry")

v14.validateProps = t.strictInterface({
	LayoutOrder = t.integer,
	canCaptureFocus = t.optional(t.boolean),
	isMenuOpen = t.optional(t.boolean)
})

function v14.init(p3) -- line: 62
	-- upvalues: UserGameSettings (copy)
	function p3.onSensitivityChanged() -- line: 63
		-- upvalues: p3 (copy), UserGameSettings (copy)
		p3:setState({
			engineSensitivity = UserGameSettings.MouseSensitivityFirstPerson.X
		})
	end

	p3.onSensitivityChanged()
end
function v14.render(p4) -- line: 73
	-- upvalues: Roact (copy), SliderEntry (copy), UserGameSettings (copy), SendAnalytics (copy), Constants (copy), t1 (copy), ExternalEventConnection (copy)
	local t2 = {}
	local createElement = Roact.createElement
	local v21 = SliderEntry
	local t3 = {
		labelKey = "CoreScripts.InGameMenu.GameSettings.CameraSensitivity",
		min = 0,
		max = 10,
		stepInterval = 1,
		keyboardInputStepInterval = 0.01,
		LayoutOrder = p4.props.LayoutOrder
	}
	local engineSensitivity = p4.state.engineSensitivity

	t3.value = math.clamp(math.floor(((if not (engineSensitivity <= 1) then (engineSensitivity + 2) / 0.6 else (engineSensitivity - 0.01) / 0.198)) / 0.01 + 0.5) * 0.01, 0, 10)

	function t3.valueChanged(p5) -- line: 84
		-- upvalues: UserGameSettings (copy), SendAnalytics (copy), Constants (copy)
		local v27 = math.clamp(if not (p5 <= 5) then 0.6 * p5 - 2 else 0.198 * p5 + 0.01, 0, 10)
		local vector2 = Vector2.new(v27, v27)

		UserGameSettings.MouseSensitivityFirstPerson = vector2
		UserGameSettings.MouseSensitivityThirdPerson = vector2
		SendAnalytics(Constants.AnalyticsSettingsChangeName, nil, {}, true)
	end

	t3.canCaptureFocus = p4.props.canCaptureFocus
	t3.isMenuOpen = p4.props.isMenuOpen
	t2.CameraSensitivityMouseSlider = createElement(v21, t3)

	for _, v in ipairs(t1) do
		t2[tostring(v) .. "CameraSensitivityControlConnection"] = Roact.createElement(ExternalEventConnection, {
			event = v,
			callback = p4.onSensitivityChanged
		})
	end

	return Roact.createFragment(t2)
end

return v14
