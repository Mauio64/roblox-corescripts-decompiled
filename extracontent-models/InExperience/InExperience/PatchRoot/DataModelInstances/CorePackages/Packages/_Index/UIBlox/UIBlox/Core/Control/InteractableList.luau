local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local t = require(parent2.t)
local Cryo = require(parent2.Cryo)

local bindingValidator = require(parent.Core.Utility.bindingValidator)
local ControlState = require(parent.Core.Control.Enum.ControlState)

local InteractableListItem = require(script.Parent.InteractableListItem)
local SelectionMode = require(script.Parent.Enum.SelectionMode)

local extended = Roact.PureComponent:extend("InteractableList")

extended.validateProps = t.strictInterface({
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

extended.defaultProps = {
	renderList = function(items, callback, props)
		local v = { Roact.createElement("UIListLayout", {
				Padding = props.padding,
				FillDirection = props.fillDirection,
				HorizontalAlignment = props.horizontalAlignment,
				VerticalAlignment = props.verticalAlignment,
				SortOrder = props.sortOrder,
				key = "$layout"
			}) }

		for k in pairs(items) do
			table.insert(v, callback(k))
		end

		return Roact.createElement("Frame", {
			Size = props.size,
			Position = props.position,
			BackgroundTransparency = 1,
			AutomaticSize = props.automaticSize,
			BorderSizePixel = 0
		}, v)
	end,
	size = UDim2.fromScale(1, 1),
	itemSize = UDim2.fromScale(1, 1),
	selectionMode = SelectionMode.Single
}

function extended:init()
	local v = { interactable = {}, selection = {} }

	if self.props.selectionMode == SelectionMode.Single then
		local v2 = next(self.props.itemList)

		if v2 ~= nil then
			v.selection = { v2 }
		end
	end

	self:setState(v)

	function self.setInteractableState(p, p2)
		self:setState(function(p3)
			return {
				interactable = Cryo.Dictionary.join(p3.interactable, { [p] = p2 })
			}
		end)
	end
	function self.setSelection(selection)
		self:setState({ selection = selection })
	end
end

function extended:getSelection()
	if self.props.selection then
		return self.props.selection
	end

	if self.props.selectionMode == SelectionMode.None then
		return {}
	end

	local filtered = Cryo.List.filter(self.state.selection, function(p): boolean
		return self.props.itemList[p] ~= nil
	end)

	if self.props.selectionMode ~= SelectionMode.Single then
		return filtered
	end

	local v = filtered[#filtered]

	if v == nil then
		v = next(self.props.itemList)
	end

	if v == nil then
		return {}
	end

	return { v }
end

function extended:didMount()
	if self.props.selection == nil and self.props.onSelectionChanged then
		self.props.onSelectionChanged(self:getSelection())
	end
end

function extended:render()
	return self.props.renderList(self.props.itemList, function(id)
		local interactableState = self.state.interactable[id] or ControlState.Default
		local selection = self:getSelection()

		return Roact.createElement(InteractableListItem, {
			id = id,
			item = self.props.itemList[id],
			interactableState = interactableState,
			selection = selection,
			renderItem = self.props.renderItem,
			itemSize = self.props.itemList[id] and self.props.itemList[id].itemSize or self.props.itemSize,
			selectionMode = self.props.selectionMode,
			onSelectionChanged = self.props.onSelectionChanged,
			setInteractableState = self.setInteractableState,
			setSelection = self.setSelection,
			key = tostring(id)
		})
	end, self.props)
end

return extended
