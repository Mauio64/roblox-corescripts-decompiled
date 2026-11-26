local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/Foundation")
local dialog = Foundation.Dialog
local buttonVariant = Foundation.Enums.ButtonVariant
local dialogSize = Foundation.Enums.DialogSize

require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Types")

local function formatValue(p2)
	if type(p2) ~= "table" then
		return (tostring(p2))
	end

	local success, result = pcall(function()
		return HttpService:JSONEncode(p2)
	end)

	if success then
		return result
	end

	return (tostring(p2))
end

local function formatDetails(details)
	if details == nil then
		return "(no details)"
	end

	local v5 = {}

	for k in details do
		table.insert(v5, k)
	end

	if #v5 == 0 then
		return "(no details)"
	end

	table.sort(v5)

	local v6 = {}

	for k, v7 in v5 do
		local item = details[v7]
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

		table.insert(v6, `{v7}: {result}`)
	end

	return table.concat(v6, "\n")
end

local function sortedOutcomes(items)
	local result = {}

	if items ~= nil then
		for k in items do
			table.insert(result, k)
		end

		table.sort(result)
	end

	return result
end

local function UnknownNodeDebugView(props)
	local report = props.report
	local transitions = props.transitions
	local v5 = {}

	if transitions ~= nil then
		for k in transitions do
			table.insert(v5, k)
		end

		table.sort(v5)
	end

	local v6 = React.useMemo(function()
		local result = {}

		for k, v7 in v5 do
			local v8 = {
				text = `{v7} ({props.transitions[v7].kind})`,
				variant = 0,
				onActivated = 0
			}
			local v9 = if k == 1 then buttonVariant.Emphasis else buttonVariant.Standard
			v8.variant = v9
			function v8.onActivated()
				if report ~= nil then
					report(v7)
				end
			end

			table.insert(result, v8)
		end

		return result
	end, { table.concat(v5, ","), props.transitions, report })

	local createElement = React.createElement
	local root = dialog.Root
	local v7 = { size = dialogSize.Medium }
	local children = {
		Title = React.createElement(dialog.Title, {
			text = `Unrenderable node: {props.nodeType}`
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = dialog.Content
	local v9 = {
		Details = React.createElement(dialog.Text, {
			Text = formatDetails(props.details),
			LayoutOrder = 1
		}),
		NoOutcomes = 0
	}

	local v10 = if #v5 == 0 then React.createElement(dialog.Text, {
		Text = "(no outcomes declared)",
		LayoutOrder = 2
	}) else nil
	v9.NoOutcomes = v10
	children.Content = createElement2(content, { LayoutOrder = 2 }, v9)

	children.Actions = React.createElement(dialog.Actions, {
		LayoutOrder = 3,
		actions = v6
	})
	return createElement(root, v7, children)
end

return UnknownNodeDebugView
