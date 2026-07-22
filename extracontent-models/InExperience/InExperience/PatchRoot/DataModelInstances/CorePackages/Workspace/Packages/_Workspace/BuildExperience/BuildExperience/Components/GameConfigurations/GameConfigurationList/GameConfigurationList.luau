local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Icon = Foundation.Icon
local List = Foundation.List
local FoundationText = Foundation.Text
local View = Foundation.View
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize

local function GameConfigurationListItem(t1: {[any]: any}) -- line: 37
	-- upvalues: React (copy), Icon (copy), IconSize (copy), List (copy)
	local row = t1.row
	local v14 = React.useCallback(function() -- line: 39
		-- upvalues: row (copy)
		row.onActivated()
	end, { row.onActivated })
	local v15 = if not row.trailingIcon then nil else React.createElement(Icon, {
		tag = "auto-xy content-default",
		name = row.trailingIcon,
		size = IconSize.Large,
		testId = `{ t1.testId }-trailing-icon`
	})

	return React.createElement(List.Item, {
		LayoutOrder = t1.LayoutOrder,
		title = row.title,
		description = row.description,
		trailing = v15,
		onActivated = v14,
		testId = t1.testId
	})
end
local function GameConfigurationList(t2: {[any]: any}) -- line: 61
	-- upvalues: React (copy), GameConfigurationListItem (copy), View (copy), FoundationText (copy), List (copy), InputSize (copy)
	local v17 = t2.testId or "game-configuration-list"
	local v18 = React.useMemo(function() -- line: 63
		-- upvalues: t2 (copy), React (copy), GameConfigurationListItem (copy), v17 (copy)
		local t3 = {}

		for v20, v21 in t2.rows do
			t3[v21.id] = React.createElement(GameConfigurationListItem, {
				LayoutOrder = v20,
				row = v21,
				testId = `{ v17 }-row-{ v21.id }`
			})
		end

		return t3
	end, {
		t2.rows,
		v17
	})

	return React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y",
		LayoutOrder = t2.layoutOrder,
		testId = v17
	}, {
		Header = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col gap-xsmall size-full-0 auto-y"
		}, {
			Title = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-title-large text-align-x-left content-default",
				Text = t2.title
			}),
			Body = if not t2.body then nil else React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-default",
				Text = t2.body
			})
		}),
		Rows = React.createElement(List.Root, {
			LayoutOrder = 2,
			isContained = true,
			hasDivider = {
				hasDivider = true,
				isInset = false
			},
			size = InputSize.Medium
		}, v18)
	})
end

return GameConfigurationList
