local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent

require(scriptParentParent.SettingsService)

local FieldRow = require(scriptParent.FieldRow)
local React = require(scriptParentParent.React)
local View = require(scriptParentParent.Foundation).View

local function _createPageView(t1: {[any]: any}) -- line: 17
	-- upvalues: React (copy), FieldRow (copy), View (copy)
	local function getFields() -- line: 18
		-- upvalues: t1 (copy), React (copy), FieldRow (copy)
		local t2 = {}

		for _, v11 in t1.settings do
			t2[v11.id] = React.createElement(FieldRow, v11)
		end

		return t2
	end

	return React.createElement(View, {
		tag = "padding-x-medium align-x-center align-y-top padding-small col size-full auto-y gui-object-defaults",
		Visible = t1.visible
	}, { (getFields()) })
end

return _createPageView
