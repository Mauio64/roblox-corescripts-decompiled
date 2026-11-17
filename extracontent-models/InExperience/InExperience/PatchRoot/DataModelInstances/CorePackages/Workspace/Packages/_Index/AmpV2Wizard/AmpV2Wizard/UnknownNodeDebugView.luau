local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local HttpService = game:GetService("HttpService")

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Dialog = Foundation.Dialog
local ButtonVariant = Foundation.Enums.ButtonVariant
local DialogSize = Foundation.Enums.DialogSize

require(AmpV2Wizard.Types)

local function formatValue(p)
	if type(p) ~= "table" then
		return (tostring(p))
	end

	local success, result = pcall(function()
		return HttpService:JSONEncode(p)
	end)

	if success then
		return result
	end

	return (tostring(p))
end

local function formatDetails(details)
	if details == nil then
		return "(no details)"
	end

	local v = {}

	for k in details do
		table.insert(v, k)
	end

	if #v == 0 then
		return "(no details)"
	end

	table.sort(v)

	local v2 = {}

	for _, v3 in v do
		local item = details[v3]
		local result

		if type(item) == "table" then
			local success
			success, result = pcall(function()
				return HttpService:JSONEncode(item)
			end)

			if not success then
				result = tostring(item)
			end
		else
			result = tostring(item)
		end

		table.insert(v2, `{v3}: {result}`)
	end

	return table.concat(v2, "\n")
end

local function sortedOutcomes(transitions) -- 1 equivalent call inferred from this helper
	local result = {}

	if transitions ~= nil then
		for k in transitions do
			table.insert(result, k)
		end

		table.sort(result)
	end

	return result
end

local function UnknownNodeDebugView(props)
	local report = props.report
	local result2 = sortedOutcomes(props.transitions) -- inferred equivalent call

	local actions = React.useMemo(function()
		local result = {}

		for k, v in result2 do
			local v2 = {
				text = `{v} ({props.transitions[v].kind})`,
				variant = 0,
				onActivated = 0
			}
			local variant

			if k == 1 then
				variant = ButtonVariant.Emphasis
			else
				variant = ButtonVariant.Standard
			end

			v2.variant = variant
			function v2.onActivated()
				if report ~= nil then
					report(v)
				end
			end

			table.insert(result, v2)
		end

		return result
	end, { table.concat(result2, ","), props.transitions, report })

	local createElement = React.createElement
	local root = Dialog.Root
	local v = { size = DialogSize.Medium }
	local children = {
		Title = React.createElement(Dialog.Title, {
			text = `Unrenderable node: {props.nodeType}`
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = Dialog.Content
	local v2 = {
		Details = React.createElement(Dialog.Text, {
			Text = formatDetails(props.details),
			LayoutOrder = 1
		}),
		NoOutcomes = 0
	}
	local noOutcomes

	if #result2 == 0 then
		noOutcomes = React.createElement(Dialog.Text, {
			Text = "(no outcomes declared)",
			LayoutOrder = 2
		})
	end

	v2.NoOutcomes = noOutcomes
	children.Content = createElement2(content, { LayoutOrder = 2 }, v2)

	children.Actions = React.createElement(Dialog.Actions, { LayoutOrder = 3, actions = actions })
	return createElement(root, v, children)
end

return UnknownNodeDebugView
