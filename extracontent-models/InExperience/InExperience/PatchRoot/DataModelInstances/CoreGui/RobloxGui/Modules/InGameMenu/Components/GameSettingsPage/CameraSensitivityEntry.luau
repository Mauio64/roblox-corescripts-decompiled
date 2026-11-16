local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t

local v = {
	UserGameSettings:GetPropertyChangedSignal("GamepadCameraSensitivity"),
	UserGameSettings:GetPropertyChangedSignal("MouseSensitivity"),
	UserGameSettings:GetPropertyChangedSignal("MouseSensitivityFirstPerson"),
	UserGameSettings:GetPropertyChangedSignal("MouseSensitivityThirdPerson")
}

local parent = script.Parent.Parent.Parent

local ExternalEventConnection = require(parent.Utility.ExternalEventConnection)
local SliderEntry = require(script.Parent.SliderEntry)

local SendAnalytics = require(parent.Utility.SendAnalytics)
local Constants = require(parent.Resources.Constants)

local function guiToEngineSensitivity(p) -- 1 equivalent call inferred from this helper
	local v2

	if p <= 5 then
		v2 = 0.198 * p + 0.01
	else
		v2 = 0.6 * p - 2
	end

	return (math.clamp(v2, 0, 10))
end

local function engineToGuiSensitivity(engineSensitivity) -- 1 equivalent call inferred from this helper
	local v2

	if engineSensitivity <= 1 then
		v2 = (engineSensitivity - 0.01) / 0.198
	else
		v2 = (engineSensitivity + 2) / 0.6
	end

	return (math.clamp(math.floor(v2 / 0.01 + 0.5) * 0.01, 0, 10))
end

local extended = Roact.PureComponent:extend("CameraSensitivityEntry")
extended.validateProps = t.strictInterface({
	LayoutOrder = t.integer,
	canCaptureFocus = t.optional(t.boolean),
	isMenuOpen = t.optional(t.boolean)
})

function extended:init()
	function self.onSensitivityChanged()
		self:setState({ engineSensitivity = UserGameSettings.MouseSensitivityFirstPerson.X })
	end

	self.onSensitivityChanged()
end

function extended.render(props)
	local children = {
		CameraSensitivityMouseSlider = Roact.createElement(SliderEntry, {
			LayoutOrder = props.props.LayoutOrder,
			labelKey = "CoreScripts.InGameMenu.GameSettings.CameraSensitivity",
			value = engineToGuiSensitivity(props.state.engineSensitivity), -- inferred equivalent call
			min = 0,
			max = 10,
			stepInterval = 1,
			keyboardInputStepInterval = 0.01,
			valueChanged = function(p)
				local v2 = guiToEngineSensitivity(p) -- inferred equivalent call
				local vector2 = Vector2.new(v2, v2)
				UserGameSettings.MouseSensitivityFirstPerson = vector2
				UserGameSettings.MouseSensitivityThirdPerson = vector2
				SendAnalytics(Constants.AnalyticsSettingsChangeName, nil, {}, true)
			end,
			canCaptureFocus = props.props.canCaptureFocus,
			isMenuOpen = props.props.isMenuOpen
		})
	}

	for _, event in ipairs(v) do
		children[tostring(event) .. "CameraSensitivityControlConnection"] = Roact.createElement(ExternalEventConnection, {
			event = event,
			callback = props.onSensitivityChanged
		})
	end

	return Roact.createFragment(children)
end

return extended
