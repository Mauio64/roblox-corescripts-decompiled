local CorePackages = game:GetService("CorePackages")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent.Parent
local ExternalEventConnection = require(ParentParent.Utility.ExternalEventConnection)
local ToggleEntry = require(script.Parent.ToggleEntry)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local Constants = require(ParentParent.Resources.Constants)
local PropertyChangedSignal = UserGameSettings:GetPropertyChangedSignal("VRComfortSetting")
local v12 = Roact.PureComponent:extend("VRComfortAutoToggleEntry")

v12.validateProps = t.strictInterface({
	customValueKey = t.string,
	derivedValueKey = t.string,
	labelKey = t.string,
	LayoutOrder = t.integer,
	checkedValue = t.optional(t.any)
})
v12.defaultProps = {
	checkedValue = true
}

function v12.init(p1, p2) -- line: 45
	-- upvalues: UserGameSettings (copy), SendAnalytics (copy), Constants (copy)
	p1.derivedValueChangeEvent = UserGameSettings:GetPropertyChangedSignal(p2.derivedValueKey)
	p1:setState({
		checked = UserGameSettings[p2.derivedValueKey] == p2.checkedValue,
		vrComfortSetting = UserGameSettings.VRComfortSetting
	})

	function p1.onExternalChange() -- line: 53
		-- upvalues: UserGameSettings (copy), p2 (copy), p1 (copy)
		local v17 = UserGameSettings[p2.derivedValueKey]

		p1:setState({
			checked = v17 == p2.checkedValue
		})
	end
	function p1.onToggled() -- line: 60
		-- upvalues: p1 (copy), UserGameSettings (copy), p2 (copy), SendAnalytics (copy), Constants (copy)
		if p1.state.vrComfortSetting == Enum.VRComfortSetting.Custom then
			if UserGameSettings[p2.customValueKey] == p2.checkedValue then
				UserGameSettings[p2.customValueKey] = not p2.checkedValue
			else
				UserGameSettings[p2.customValueKey] = p2.checkedValue
			end

			SendAnalytics(Constants.AnalyticsSettingsChangeName, nil, {}, true)
		end
	end
end
function v12.render(p3) -- line: 73
	-- upvalues: Roact (copy), ToggleEntry (copy), ExternalEventConnection (copy), PropertyChangedSignal (copy), UserGameSettings (copy)
	local props = p3.props

	return Roact.createFragment({
		Toggle = Roact.createElement(ToggleEntry, {
			checked = p3.state.checked,
			labelKey = props.labelKey,
			LayoutOrder = props.LayoutOrder,
			onToggled = p3.onToggled,
			isDisabled = p3.state.vrComfortSetting ~= Enum.VRComfortSetting.Custom
		}),
		DerivedValueListener = Roact.createElement(ExternalEventConnection, {
			event = p3.derivedValueChangeEvent,
			callback = p3.onExternalChange
		}),
		VRComfortSettingListener = Roact.createElement(ExternalEventConnection, {
			event = PropertyChangedSignal,
			callback = function() -- line: 91
				-- upvalues: p3 (copy), UserGameSettings (copy)
				p3:setState({
					vrComfortSetting = UserGameSettings.VRComfortSetting
				})
			end
		})
	})
end

return v12
