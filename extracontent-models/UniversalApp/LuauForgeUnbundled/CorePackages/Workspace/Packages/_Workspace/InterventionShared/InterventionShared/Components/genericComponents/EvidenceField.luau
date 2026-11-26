local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/Foundation")
local view = Foundation.View
local text = Foundation.Text

local function EvidenceField(props)
	local v5 = (props.hasColon == nil or props.hasColon) and ":" or ""

	return React.createElement(view, {
		tag = "size-full-0 auto-y col",
		LayoutOrder = props.layoutOrder
	}, {
		Label = React.createElement(text, {
			tag = "auto-xy text-title-medium text-align-x-left text-wrap content-emphasis",
			Text = `{props.fieldLabel}{v5}`,
			LayoutOrder = 1
		}),
		Value = React.createElement(text, {
			tag = "auto-xy text-body-medium text-align-x-left text-wrap",
			Text = props.fieldValue,
			LayoutOrder = 2
		})
	})
end

return React.memo(EvidenceField)
