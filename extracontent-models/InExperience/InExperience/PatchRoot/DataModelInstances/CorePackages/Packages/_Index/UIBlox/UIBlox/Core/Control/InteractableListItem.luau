local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local Cryo = require(ParentParentParent.Cryo)
local Interactable = require(ParentParent.Core.Control.Interactable)
local SelectionMode = require(script.Parent.Enum.SelectionMode)
local v7 = Roact.PureComponent:extend("InteractableListItem")

function v7.init(p1) -- line: 20
	-- upvalues: SelectionMode (copy), Cryo (copy)
	function p1.onStateChanged(_, p3) -- line: 21
		-- upvalues: p1 (copy)
		p1.props.setInteractableState(p1.props.id, p3)
	end
	function p1.onActivated() -- line: 24
		-- upvalues: p1 (copy), SelectionMode (copy), Cryo (copy)
		local selection = p1.props.selection
		local t1 = { p1.props.id }

		if p1.props.selectionMode == SelectionMode.Multiple then
			t1 = Cryo.List.filter(selection, function(p4) -- line: 28
				-- upvalues: p1 (copy)
				return p4 ~= p1.props.id
			end)

			if #t1 == #selection then
				table.insert(t1, p1.props.id)
			end
		end

		if p1.props.onSelectionChanged then
			p1.props.onSelectionChanged(t1, selection)
		end

		if p1.props.selectionMode ~= SelectionMode.None then
			p1.props.setSelection(t1)
		end
	end
end
function v7.render(p5) -- line: 44
	-- upvalues: Cryo (copy), Roact (copy), Interactable (copy)
	local v10 = Cryo.List.find(p5.props.selection, p5.props.id) ~= nil
	local v11, v12 = p5.props.renderItem(p5.props.item, p5.props.interactableState, v10, p5.props.id)

	return Roact.createElement(Interactable, Cryo.Dictionary.join({
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = p5.props.itemSize
	}, v12 or {}, {
		onStateChanged = p5.onStateChanged,
		[Roact.Event.Activated] = p5.onActivated
	}), v11)
end

return v7
