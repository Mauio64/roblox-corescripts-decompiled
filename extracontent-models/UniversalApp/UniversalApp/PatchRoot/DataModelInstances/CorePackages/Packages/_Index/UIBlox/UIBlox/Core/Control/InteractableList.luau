local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local Cryo = require(ParentParentParent.Cryo)
local bindingValidator = require(ParentParent.Core.Utility.bindingValidator)
local ControlState = require(ParentParent.Core.Control.Enum.ControlState)
local InteractableListItem = require(script.Parent.InteractableListItem)
local SelectionMode = require(script.Parent.Enum.SelectionMode)
local v10 = Roact.PureComponent:extend("InteractableList")

v10.validateProps = t.strictInterface({
	itemList = t.table,
	renderItem = t.callback,
	renderList = t.optional(t.callback),
	selection = t.optional(t.table),
	selectionMode = t.optional(SelectionMode.isEnumValue),
	onSelectionChanged = t.optional(t.callback),
	size = t.optional(t.UDim2),
	position = t.optional(t.UDim2),
	layoutOrder = t.optional(t.integer),
	padding = t.optional(t.UDim),
	fillDirection = t.optional(t.enum(Enum.FillDirection)),
	horizontalAlignment = t.optional(t.enum(Enum.HorizontalAlignment)),
	verticalAlignment = t.optional(t.enum(Enum.VerticalAlignment)),
	sortOrder = t.optional(t.enum(Enum.SortOrder)),
	automaticSize = t.optional(t.enum(Enum.AutomaticSize)),
	itemSize = t.optional(t.union(t.UDim2, bindingValidator(t.UDim2)))
})
v10.defaultProps = {
	renderList = function(p1, p2, p3) -- line: 60
		-- upvalues: Roact (copy)
		local t1 = { Roact.createElement("UIListLayout", {
			key = "$layout",
			Padding = p3.padding,
			FillDirection = p3.fillDirection,
			HorizontalAlignment = p3.horizontalAlignment,
			VerticalAlignment = p3.verticalAlignment,
			SortOrder = p3.sortOrder
		}) }

		for k in pairs(p1) do
			table.insert(t1, p2(k))
		end

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = p3.size,
			Position = p3.position,
			AutomaticSize = p3.automaticSize
		}, t1)
	end,
	size = UDim2.fromScale(1, 1),
	itemSize = UDim2.fromScale(1, 1),
	selectionMode = SelectionMode.Single
}

function v10.init(p4) -- line: 88
	-- upvalues: SelectionMode (copy), Cryo (copy)
	local t2 = {
		interactable = {},
		selection = {}
	}

	if p4.props.selectionMode == SelectionMode.Single then
		local v18 = next(p4.props.itemList)

		if v18 ~= nil then
			t2.selection = { v18 }
		end
	end

	p4:setState(t2)

	function p4.setInteractableState(p5, p6) -- line: 101
		-- upvalues: p4 (copy), Cryo (copy)
		p4:setState(function(p7) -- line: 102
			-- upvalues: Cryo (copy), p5 (copy), p6 (copy)
			return {
				interactable = Cryo.Dictionary.join(p7.interactable, {
					[p5] = p6
				})
			}
		end)
	end
	function p4.setSelection(p8) -- line: 110
		-- upvalues: p4 (copy)
		p4:setState({
			selection = p8
		})
	end
end
function v10.getSelection(p9) -- line: 117
	-- upvalues: SelectionMode (copy), Cryo (copy)
	if p9.props.selection then
		return p9.props.selection
	end

	if p9.props.selectionMode == SelectionMode.None then
		return {}
	end

	local v20 = Cryo.List.filter(p9.state.selection, function(p10) -- line: 124
		-- upvalues: p9 (copy)
		return p9.props.itemList[p10] ~= nil
	end)

	if p9.props.selectionMode == SelectionMode.Single then
		local v21 = v20[#v20]

		if v21 == nil then
			v21 = next(p9.props.itemList)
		end

		if v21 ~= nil then
			return { v21 }
		end

		return {}
	end

	return v20
end
function v10.didMount(p11) -- line: 142
	if p11.props.selection == nil and p11.props.onSelectionChanged then
		p11.props.onSelectionChanged(p11:getSelection())
	end
end
function v10.render(p12) -- line: 148
	-- upvalues: ControlState (copy), Roact (copy), InteractableListItem (copy)
	return p12.props.renderList(p12.props.itemList, function(p13) -- line: 149
		-- upvalues: p12 (copy), ControlState (copy), Roact (copy), InteractableListItem (copy)
		local v29 = p12.state.interactable[p13] or ControlState.Default
		local v30 = p12:getSelection()

		return Roact.createElement(InteractableListItem, {
			id = p13,
			item = p12.props.itemList[p13],
			interactableState = v29,
			selection = v30,
			renderItem = p12.props.renderItem,
			itemSize = p12.props.itemList[p13] and p12.props.itemList[p13].itemSize or p12.props.itemSize,
			selectionMode = p12.props.selectionMode,
			onSelectionChanged = p12.props.onSelectionChanged,
			setInteractableState = p12.setInteractableState,
			setSelection = p12.setSelection,
			key = tostring(p13)
		})
	end, p12.props)
end

return v10
