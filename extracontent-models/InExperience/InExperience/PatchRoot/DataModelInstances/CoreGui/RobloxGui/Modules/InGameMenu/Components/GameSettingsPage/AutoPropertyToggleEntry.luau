local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent.Parent
local ExternalEventConnection = require(ParentParent.Utility.ExternalEventConnection)
local ToggleEntry = require(script.Parent.ToggleEntry)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local Constants = require(ParentParent.Resources.Constants)
local v10 = Roact.PureComponent:extend("AutoPropertyToggleEntry")

v10.validateProps = t.strictInterface({
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
v10.defaultProps = {
	onValue = true,
	offValue = false,
	lockedToOff = false,
	subtextEnabled = false,
	subtextKey = ""
}

function v10.init(p1, p2) -- line: 37
	-- upvalues: SendAnalytics (copy), Constants (copy)
	local v13 = p2.instance[p2.valueKey]

	p1.changeEvent = p2.instance:GetPropertyChangedSignal(p2.valueKey)
	p1:setState({
		checked = not p2.lockedToOff and v13 == p2.onValue
	})

	function p1.onExternalChange() -- line: 45
		-- upvalues: p2 (copy), p1 (copy)
		local v16 = p2.instance[p2.valueKey]

		p1:setState({
			checked = v16 == p2.onValue
		})
	end
	function p1.onToggled() -- line: 52
		-- upvalues: p1 (copy), p2 (copy), SendAnalytics (copy), Constants (copy)
		if p1.props.lockedToOff then
			return
		end

		if p2.instance[p2.valueKey] == p2.onValue then
			p2.instance[p2.valueKey] = p2.offValue
		else
			p2.instance[p2.valueKey] = p2.onValue
		end

		SendAnalytics(Constants.AnalyticsSettingsChangeName, nil, {}, true)
	end
end
function v10.render(p3) -- line: 69
	-- upvalues: Roact (copy), ToggleEntry (copy), ExternalEventConnection (copy)
	local props = p3.props

	return Roact.createFragment({
		Toggle = Roact.createElement(ToggleEntry, {
			checked = p3.state.checked,
			lockedToOff = props.lockedToOff,
			labelKey = props.labelKey,
			LayoutOrder = props.LayoutOrder,
			onToggled = p3.onToggled,
			subtextEnabled = props.subtextEnabled,
			subtextKey = props.subtextKey
		}),
		Listener = Roact.createElement(ExternalEventConnection, {
			event = p3.changeEvent,
			callback = p3.onExternalChange
		})
	})
end

return v10
