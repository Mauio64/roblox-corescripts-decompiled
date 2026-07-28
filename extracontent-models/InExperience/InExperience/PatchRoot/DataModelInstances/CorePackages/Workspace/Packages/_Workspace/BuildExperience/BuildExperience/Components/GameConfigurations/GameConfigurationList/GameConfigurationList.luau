local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Icon = Foundation.Icon
local List = Foundation.List
local FoundationText = Foundation.Text
local View = Foundation.View
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize

local function GameConfigurationListItem(t1: {[any]: any}) -- line: 41
	-- upvalues: React (copy), Icon (copy), IconSize (copy), List (copy)
	local row = t1.row
	local v14 = row.isDisabled == true
	local onActivated = row.onActivated
	local v16 = React.useCallback(function() -- line: 45
		-- upvalues: onActivated (copy)
		if onActivated ~= nil then
			onActivated()
		end
	end, { onActivated })
	local v17 = if not row.trailingIcon then nil else React.createElement(Icon, {
		tag = "auto-xy content-default",
		name = row.trailingIcon,
		size = IconSize.Large,
		testId = `{ t1.testId }-trailing-icon`
	})
	local v18 = React.createElement(List.Item, {
		LayoutOrder = t1.LayoutOrder,
		title = row.title,
		description = row.description,
		trailing = v17,
		onActivated = if onActivated == nil or v14 then nil else v16,
		testId = t1.testId
	})

	if v14 then
		return React.createElement("CanvasGroup", {
			BackgroundTransparency = 1,
			GroupTransparency = 0.5,
			LayoutOrder = t1.LayoutOrder,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Item = v18
		})
	end

	return v18
end
local function GameConfigurationList(t2: {[any]: any}) -- line: 86
	-- upvalues: React (copy), GameConfigurationListItem (copy), View (copy), FoundationText (copy), List (copy), InputSize (copy)
	local v20 = t2.testId or "game-configuration-list"
	local v21 = React.useMemo(function() -- line: 88
		-- upvalues: t2 (copy), React (copy), GameConfigurationListItem (copy), v20 (copy)
		local t3 = {}

		for v23, v24 in t2.rows do
			t3[v24.id] = React.createElement(GameConfigurationListItem, {
				LayoutOrder = v23,
				row = v24,
				testId = `{ v20 }-row-{ v24.id }`
			})
		end

		return t3
	end, {
		t2.rows,
		v20
	})

	return React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y",
		LayoutOrder = t2.layoutOrder,
		testId = v20
	}, {
		Header = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col gap-xsmall size-full-0 auto-y"
		}, {
			Title = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-title-large text-align-x-left content-default",
				Text = t2.title,
				testId = `{ v20 }-title`
			}),
			Body = if not t2.body then nil else React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-default",
				Text = t2.body,
				testId = `{ v20 }-body`
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
		}, v21)
	})
end

return GameConfigurationList
