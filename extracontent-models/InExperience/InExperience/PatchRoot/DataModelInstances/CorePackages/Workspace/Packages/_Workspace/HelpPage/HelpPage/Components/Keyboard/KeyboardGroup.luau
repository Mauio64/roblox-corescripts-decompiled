local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
require(parent.Configs.ConfigTypes)
local Localization = require(parent2.Localization)
local KeyboardAction = require(script.Parent.KeyboardAction)
local FFlagHelpPageCCL = require(parent.Flags.FFlagHelpPageCCL)

local View = Foundation.View
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local useLocalization = Localization.Hooks.useLocalization

local memo = React.memo(function(p)
	local v = useTokens()
	local v2 = useLocalization({ title = p.title })

	return React.createElement(
		View,
		{
			tag = "col align-y-center align-x-left size-full-0 auto-y padding-x-small padding-y-small",
			LayoutOrder = p.LayoutOrder
		},
		{ React.createElement(Text, {
				tag = {
					["auto-xy text-title-small text-wrap text-align-x-left"] = FFlagHelpPageCCL,
					["auto-xy text-title-medium text-wrap text-align-x-left"] = not FFlagHelpPageCCL
				},
				textStyle = v.Color.Extended.White.White_100,
				Text = v2.title,
				key = "title-text"
			}) }
	)
end)

return React.memo(function(p)
	local v = React.useMemo(function()
		local children = {}

		table.insert(children, React.createElement(memo, {
			title = p.group.label,
			LayoutOrder = 0,
			key = "groupTitle-" .. p.group.id
		}))

		for _, control in p.controls do
			if control.keyboardInput ~= nil then
				table.insert(children, (React.createElement(KeyboardAction, {
					control = control,
					LayoutOrder = control.keyboardInput.layoutOrder,
					key = control.label .. control.keyboardInput.layoutOrder
				})))
			end
		end

		return children
	end, { p.controls, p.group })

	return React.createElement(
		View,
		{
			tag = "col align-y-top align-x-center size-full gap-xxsmall",
			LayoutOrder = p.group.layoutOrder,
			testId = "KeyboardGroup"
		},
		v
	)
end)
