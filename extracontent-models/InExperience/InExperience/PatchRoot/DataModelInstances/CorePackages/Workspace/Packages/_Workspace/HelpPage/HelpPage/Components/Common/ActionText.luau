local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local Text = Foundation.Text
local escapeRichText = require(parent.Utils.escapeRichText)
local useLocalizedLabels = require(parent.Hooks.useLocalizedLabels)

return (React.memo(function(props)
	local actionLabels = props.actionLabels
	local labels = {}

	for i, actionLabel in ipairs(actionLabels) do
		labels[tostring(i)] = actionLabel.label
	end

	local v = useLocalizedLabels(labels)
	local v2 = {}

	for i, actionLabel in ipairs(actionLabels) do
		local v3 = escapeRichText(v[tostring(i)])

		if actionLabel.disabled then
			v3 = "<font transparency=\"0.5\">" .. v3 .. "</font>"
		end

		table.insert(v2, v3)
	end

	local tag = {
		["size-full-0 auto-y text-wrap"] = true,
		["text-label-small"] = props.textVariant == "label-small",
		["text-title-large"] = props.textVariant ~= "label-small"
	}

	return React.createElement(Text, {
		tag = tag,
		Text = table.concat(v2, " / "),
		RichText = true,
		TextXAlignment = props.textXAlignment or Enum.TextXAlignment.Center,
		LayoutOrder = props.LayoutOrder,
		testId = props.testId
	})
end))
