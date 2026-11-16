local parent = script:FindFirstAncestor("InterventionShared").Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text

local function EvidenceField(props)
	local v = (props.hasColon == nil or props.hasColon) and ":" or ""

	return React.createElement(View, {
		tag = "size-full-0 auto-y col",
		LayoutOrder = props.layoutOrder
	}, {
		Label = React.createElement(Text, {
			tag = "auto-xy text-title-medium text-align-x-left text-wrap content-emphasis",
			Text = `{props.fieldLabel}{v}`,
			LayoutOrder = 1
		}),
		Value = React.createElement(Text, {
			tag = "auto-xy text-body-medium text-align-x-left text-wrap",
			Text = props.fieldValue,
			LayoutOrder = 2
		})
	})
end

return React.memo(EvidenceField)
