local module = require("@luauforge/deferred/gzS")

local module2 = require("@luauforge/deferred/gzT")
local view = module2.View
local text = module2.Text

local function EvidenceField(props)
	local createElement = module.createElement
	local v6 = {
		tag = "col size-full-0 auto-y gap-xxsmall",
		LayoutOrder = props.layoutOrder
	}

	local createElement2 = module.createElement

	local v9 = if props.showColon == false then props.fieldLabel else `{props.fieldLabel}:`
	return createElement(view, v6, {
		Label = createElement2(text, {
			tag = "auto-xy text-title-medium text-wrap text-align-x-left content-default",
			Text = v9,
			LayoutOrder = 1
		}),
		Value = module.createElement(text, {
			tag = "auto-xy text-body-medium text-wrap text-align-x-left",
			Text = props.fieldValue,
			LayoutOrder = 2
		})
	})
end

return module.memo(EvidenceField)
