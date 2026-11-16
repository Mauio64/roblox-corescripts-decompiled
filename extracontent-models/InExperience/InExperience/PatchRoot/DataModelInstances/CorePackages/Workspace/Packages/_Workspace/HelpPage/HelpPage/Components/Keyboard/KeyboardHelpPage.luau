local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local useKeybinds = require(parent.Hooks.useKeybinds)
local KeyboardGroup = require(script.Parent.KeyboardGroup)
require(parent.Configs.ConfigTypes)
local FFlagHelpPageCCL = require(parent.Flags.FFlagHelpPageCCL)
local View = Foundation.View

local function KeyboardHelpPage()
	local v = useKeybinds()
	local controls = v.controls
	local groups = v.groups

	local v2 = React.useMemo(function()
		if controls == nil or groups == nil then
			return nil
		end

		local v2 = {}

		for _, group in groups do
			v2[group.id] = { controls = {}, group = group }
		end

		for k, control in controls do
			if control.keyboardInput == nil then
				continue
			end

			local group = control.keyboardInput.group

			if v2[group.id] ~= nil then
				v2[group.id].controls[k] = control
			end
		end

		local children = {}

		for _, v3 in v2 do
			if next(v3.controls) ~= nil then
				table.insert(children, React.createElement(View, {
					tag = "auto-y padding-xxsmall",
					LayoutOrder = v3.group.layoutOrder,
					Size = UDim2.new(1 / 3, -1, 0, 0),
					key = v3.group.id
				}, React.createElement(KeyboardGroup, v3)))
			end
		end

		return children
	end, { controls, groups })

	if v2 == nil then
		return nil
	end

	return React.createElement(View, {
		tag = {
			["col wrap align-x-left align-y-top size-full-0 auto-y"] = FFlagHelpPageCCL,
			["row wrap align-x-left align-y-top size-full-0 auto-y"] = not FFlagHelpPageCCL
		}
	}, v2)
end

return React.memo(KeyboardHelpPage)
