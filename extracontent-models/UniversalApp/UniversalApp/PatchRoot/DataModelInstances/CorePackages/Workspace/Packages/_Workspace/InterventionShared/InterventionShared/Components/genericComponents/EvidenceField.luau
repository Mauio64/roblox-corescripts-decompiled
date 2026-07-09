local Parent = script:FindFirstAncestor("InterventionShared").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text

local function EvidenceField(t1: {[any]: any}) -- line: 26
	-- upvalues: React (copy), View (copy), FoundationText (copy)
	local v8 = t1.hasColon ~= nil and not t1.hasColon and "" or ":"

	return React.createElement(View, {
		tag = "size-full-0 auto-y col",
		LayoutOrder = t1.layoutOrder
	}, {
		Label = React.createElement(FoundationText, {
			tag = "auto-xy text-title-medium text-align-x-left text-wrap content-emphasis",
			LayoutOrder = 1,
			Text = `{ t1.fieldLabel }{ v8 }`
		}),
		Value = React.createElement(FoundationText, {
			tag = "auto-xy text-body-medium text-align-x-left text-wrap",
			LayoutOrder = 2,
			Text = t1.fieldValue
		})
	})
end

return React.memo(EvidenceField)
