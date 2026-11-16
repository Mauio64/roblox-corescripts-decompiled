local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t

local parent = script.Parent.Parent.Parent

local ExternalEventConnection = require(parent.Utility.ExternalEventConnection)

local ToggleEntry = require(script.Parent.ToggleEntry)

local SendAnalytics = require(parent.Utility.SendAnalytics)
local Constants = require(parent.Resources.Constants)

local extended = Roact.PureComponent:extend("AutoPropertyToggleEntry")
extended.validateProps = t.strictInterface({
	instance = t.Instance,
	valueKey = t.string,
	lockedToOff = t.optional(t.boolean),
	onValue = t.optional(t.any),
	offValue = t.optional(t.any),
	labelKey = t.string,
	LayoutOrder = t.integer,
	subtextEnabled = t.optional(t.boolean),
	subtextKey = t.optional(t.string)
})

extended.defaultProps = {
	onValue = true,
	offValue = false,
	lockedToOff = false,
	subtextEnabled = false,
	subtextKey = ""
}

function extended:init(data)
	local v = data.instance[data.valueKey]
	self.changeEvent = data.instance:GetPropertyChangedSignal(data.valueKey)

	self:setState({
		checked = not data.lockedToOff and v == data.onValue
	})

	function self.onExternalChange()
		self:setState({
			checked = data.instance[data.valueKey] == data.onValue
		})
	end

	function self.onToggled()
		if self.props.lockedToOff then
			return
		end

		if data.instance[data.valueKey] == data.onValue then
			data.instance[data.valueKey] = data.offValue
		else
			data.instance[data.valueKey] = data.onValue
		end

		SendAnalytics(Constants.AnalyticsSettingsChangeName, nil, {}, true)
	end
end

function extended.render(props)
	local props2 = props.props

	return Roact.createFragment({
		Toggle = Roact.createElement(ToggleEntry, {
			checked = props.state.checked,
			lockedToOff = props2.lockedToOff,
			labelKey = props2.labelKey,
			LayoutOrder = props2.LayoutOrder,
			onToggled = props.onToggled,
			subtextEnabled = props2.subtextEnabled,
			subtextKey = props2.subtextKey
		}),
		Listener = Roact.createElement(ExternalEventConnection, {
			event = props.changeEvent,
			callback = props.onExternalChange
		})
	})
end

return extended
