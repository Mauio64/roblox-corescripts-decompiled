local CorePackages = game:GetService("CorePackages")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t

local parent = script.Parent.Parent.Parent

local ExternalEventConnection = require(parent.Utility.ExternalEventConnection)

local ToggleEntry = require(script.Parent.ToggleEntry)

local SendAnalytics = require(parent.Utility.SendAnalytics)
local Constants = require(parent.Resources.Constants)

local propertyChangedSignal = UserGameSettings:GetPropertyChangedSignal("VRComfortSetting")

local extended = Roact.PureComponent:extend("VRComfortAutoToggleEntry")
extended.validateProps = t.strictInterface({
	customValueKey = t.string,
	derivedValueKey = t.string,
	labelKey = t.string,
	LayoutOrder = t.integer,
	checkedValue = t.optional(t.any)
})

extended.defaultProps = { checkedValue = true }

function extended:init(data)
	self.derivedValueChangeEvent = UserGameSettings:GetPropertyChangedSignal(data.derivedValueKey)

	self:setState({
		checked = UserGameSettings[data.derivedValueKey] == data.checkedValue,
		vrComfortSetting = UserGameSettings.VRComfortSetting
	})

	function self.onExternalChange()
		self:setState({
			checked = UserGameSettings[data.derivedValueKey] == data.checkedValue
		})
	end

	function self.onToggled()
		if self.state.vrComfortSetting == Enum.VRComfortSetting.Custom then
			if UserGameSettings[data.customValueKey] == data.checkedValue then
				UserGameSettings[data.customValueKey] = not data.checkedValue
			else
				UserGameSettings[data.customValueKey] = data.checkedValue
			end

			SendAnalytics(Constants.AnalyticsSettingsChangeName, nil, {}, true)
		end
	end
end

function extended.render(props)
	local props2 = props.props

	return Roact.createFragment({
		Toggle = Roact.createElement(ToggleEntry, {
			checked = props.state.checked,
			labelKey = props2.labelKey,
			LayoutOrder = props2.LayoutOrder,
			onToggled = props.onToggled,
			isDisabled = props.state.vrComfortSetting ~= Enum.VRComfortSetting.Custom
		}),
		DerivedValueListener = Roact.createElement(ExternalEventConnection, {
			event = props.derivedValueChangeEvent,
			callback = props.onExternalChange
		}),
		VRComfortSettingListener = Roact.createElement(ExternalEventConnection, {
			event = propertyChangedSignal,
			callback = function()
				props:setState({ vrComfortSetting = UserGameSettings.VRComfortSetting })
			end
		})
	})
end

return extended
