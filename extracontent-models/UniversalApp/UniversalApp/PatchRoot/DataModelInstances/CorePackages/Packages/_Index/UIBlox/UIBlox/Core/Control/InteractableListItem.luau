local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local Cryo = require(parent2.Cryo)

local Interactable = require(parent.Core.Control.Interactable)

local SelectionMode = require(script.Parent.Enum.SelectionMode)

local extended = Roact.PureComponent:extend("InteractableListItem")

function extended:init()
	function self.onStateChanged(_, p)
		self.props.setInteractableState(self.props.id, p)
	end
	function self.onActivated()
		local selection = self.props.selection
		local ids = { self.props.id }

		if self.props.selectionMode == SelectionMode.Multiple then
			ids = Cryo.List.filter(selection, function(p): boolean
				return p ~= self.props.id
			end)

			if #ids == #selection then
				table.insert(ids, self.props.id)
			end
		end

		if self.props.onSelectionChanged then
			self.props.onSelectionChanged(ids, selection)
		end

		if self.props.selectionMode ~= SelectionMode.None then
			self.props.setSelection(ids)
		end
	end
end

function extended.render(props)
	local v = Cryo.List.find(props.props.selection, props.props.id) ~= nil

	local item, v2 = props.props.renderItem(props.props.item, props.props.interactableState, v, props.props.id)

	return Roact.createElement(
		Interactable,
		Cryo.Dictionary.join(
			{ Size = props.props.itemSize, BackgroundTransparency = 1, BorderSizePixel = 0 },
			v2 or {},
			{ onStateChanged = props.onStateChanged, [Roact.Event.Activated] = props.onActivated }
		),
		item
	)
end

return extended
