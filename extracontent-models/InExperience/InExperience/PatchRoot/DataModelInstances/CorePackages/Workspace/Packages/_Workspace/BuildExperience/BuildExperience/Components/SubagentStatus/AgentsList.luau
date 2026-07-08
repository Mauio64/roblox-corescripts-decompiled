local Parent = script:FindFirstAncestor("BuildExperience").Parent

require(Parent.DataHydration.CreatorAgentChat)

local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local LoadingIndicator = require(script.Parent.LoadingIndicator)
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local t1 = {
	Art = IconName.PaintBrush,
	Audio = IconName.FiveVerticalLinesWave,
	Gameplay = IconName.Controller,
	Marketing = IconName.Wallet
}

local function getStatusText(p1) -- line: 37
	if #p1.tasks == 0 then
		return "Not started"
	end

	if p1.isComplete then
		return `{ #p1.tasks } completed tasks`
	end

	return "Building..."
end
local function AgentsList(t2: {[any]: any}) -- line: 47
	-- upvalues: t1 (copy), React (copy), View (copy), FoundationText (copy), LoadingIndicator (copy), Icon (copy), IconSize (copy)
	local v15 = t2.testId or "build-agent-list"
	local t3 = {}

	for v17, v18 in t2.groups do
		local v19 = t1[v18.name]
		local t4 = {}

		for i = 1, math.min(3, #v18.tasks) do
			local v22 = v18.tasks[i]

			t4[`Task{ i }`] = React.createElement(View, {
				tag = "row align-y-center gap-small size-full-0 auto-y",
				LayoutOrder = i
			}, {
				Label = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "fill auto-y text-body-small text-align-x-left text-truncate-end content-emphasis",
					Text = v22.text
				}),
				Status = React.createElement(LoadingIndicator, {
					layoutOrder = 2,
					status = v22.status,
					testId = `{ v15 }-card-{ v17 }-task-{ i }`
				})
			})
		end

		t3[`Card{ v17 }`] = React.createElement(View, {
			tag = "col gap-small size-full-0 auto-y padding-large stroke-standard stroke-emphasis radius-large",
			LayoutOrder = v17,
			onActivated = function() -- line: 75
				-- upvalues: t2 (copy), v18 (copy)
				t2.onAgentActivated(v18)
			end,
			testId = `{ v15 }-card-{ v17 }`
		}, {
			Header = React.createElement(View, {
				LayoutOrder = 1,
				tag = "row align-y-center gap-small size-full-0 auto-y"
			}, {
				Icon = if v19 == nil then nil else React.createElement(Icon, {
					LayoutOrder = 1,
					tag = "auto-xy content-emphasis",
					name = v19,
					size = IconSize.Small,
					testId = `{ v15 }-card-{ v17 }-category-icon`
				}),
				Title = React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "fill auto-y text-title-medium text-wrap text-align-x-left content-emphasis",
					Text = v18.name
				})
			}),
			Status = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis",
				Text = if #v18.tasks ~= 0 then not v18.isComplete and "Building..." or `{ #v18.tasks } completed tasks` else "Not started"
			}),
			Tasks = React.createElement(View, {
				LayoutOrder = 3,
				tag = "col gap-small size-full-0 auto-y padding-top-small"
			}, t4)
		})
	end

	return React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y padding-y-medium",
		LayoutOrder = t2.LayoutOrder,
		testId = v15
	}, t3)
end

return React.memo(AgentsList)
