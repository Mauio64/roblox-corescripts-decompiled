local parent = script.Parent
local parent2 = parent.Parent

require(parent2.SettingsService)
local FieldRow = require(parent.FieldRow)
local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local View = Foundation.View

local function _createPageView(p)
	local function getFields()
		local children = {}

		for _, setting in p.settings do
			children[setting.id] = React.createElement(FieldRow, setting)
		end

		return children
	end

	return React.createElement(
		View,
		{
			tag = "padding-x-medium align-x-center align-y-top padding-small col size-full auto-y gui-object-defaults",
			Visible = p.visible
		},
		{ getFields() }
	)
end

return _createPageView
