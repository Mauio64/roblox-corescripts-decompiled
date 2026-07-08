local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local Cryo = require(ParentParentParent.Cryo)
local t = require(ParentParentParent.t)
local ControlState = require(scriptParent.Enum.ControlState)
local StateTable = require(ParentParent.StateTable.StateTable)
local v9 = Roact.PureComponent:extend("Controllable")

function v9.init(p1) -- line: 23
	-- upvalues: ControlState (copy), StateTable (copy)
	p1.isMounted = false

	local Initialize = ControlState.Initialize

	p1.state = {
		currentState = Initialize
	}

	local v12 = string.format("Controllable(%s)", (tostring(p1)))

	function p1.setDisabled(p2) -- line: 31
		-- upvalues: p1 (copy)
		if p2 then
			p1.stateTable.events.Disable()

			return
		end

		p1.stateTable.events.Enable()
	end

	p1.stateTable = StateTable.new(v12, Initialize, {}, {
		[ControlState.Initialize] = {
			Enable = {
				nextState = ControlState.Default
			},
			Disable = {
				nextState = ControlState.Disabled
			}
		},
		[ControlState.Default] = {
			OnPressed = {
				nextState = ControlState.Pressed
			},
			StartHover = {
				nextState = ControlState.Hover
			},
			OnSelectionGained = {
				nextState = ControlState.Selected
			},
			Disable = {
				nextState = ControlState.Disabled
			}
		},
		[ControlState.Hover] = {
			OnSelectionGained = {
				nextState = ControlState.Selected
			},
			OnPressed = {
				nextState = ControlState.Pressed
			},
			EndHover = {
				nextState = ControlState.Default
			},
			Disable = {
				nextState = ControlState.Disabled
			}
		},
		[ControlState.Pressed] = {
			OnSelectionGained = {
				nextState = ControlState.SelectedPressed
			},
			OnReleased = {
				nextState = ControlState.Default
			},
			OnReleasedHover = {
				nextState = ControlState.Hover
			},
			Disable = {
				nextState = ControlState.Disabled
			}
		},
		[ControlState.Selected] = {
			OnSelectionLost = {
				nextState = ControlState.Default
			},
			OnPressed = {
				nextState = ControlState.SelectedPressed
			},
			Disable = {
				nextState = ControlState.Disabled
			}
		},
		[ControlState.SelectedPressed] = {
			OnSelectionLost = {
				nextState = ControlState.Default
			},
			OnReleased = {
				nextState = ControlState.Selected
			},
			Disable = {
				nextState = ControlState.Disabled
			}
		},
		[ControlState.Disabled] = {
			Enable = {
				nextState = ControlState.Default
			}
		}
	})
	p1.stateTable:onStateChange(function(p3, p4) -- line: 77
		-- upvalues: p1 (copy)
		p1:setState({
			currentState = p4
		})

		if p1.props.onStateChanged then
			p1.props.onStateChanged(p3, p4)
		end
	end)
end

v9.validateProps = t.strictInterface({
	controlComponent = t.strictInterface({
		component = t.union(t.callback, t.string, t.table),
		props = t.optional(t.table),
		children = t.optional(t.table)
	}),
	onStateChanged = t.callback,
	isDisabled = t.optional(t.boolean),
	userInteractionEnabled = t.optional(t.boolean)
})
v9.defaultProps = {
	userInteractionEnabled = true,
	isDisabled = false
}

function v9.render(p5) -- line: 115
	-- upvalues: ControlState (copy), Cryo (copy), Roact (copy)
	local controlComponent = p5.props.controlComponent
	local userInteractionEnabled = p5.props.userInteractionEnabled

	if p5.state.currentState == ControlState.Initialize then
		return nil
	end

	local v16 = controlComponent.props and controlComponent.props.Selectable

	if v16 == nil then
		v16 = true
	end

	local v17 = Cryo.Dictionary.join(p5.props, controlComponent.props or {}, {
		Selectable = v16,
		Active = not p5.props.isDisabled,
		[Roact.Event.MouseEnter] = function(...) -- line: 131
			-- upvalues: userInteractionEnabled (copy), p5 (copy), controlComponent (copy), Roact (copy)
			if not userInteractionEnabled then
				return nil
			end

			p5.stateTable.events.StartHover()

			if controlComponent.props[Roact.Event.MouseEnter] ~= nil then
				return controlComponent.props[Roact.Event.MouseEnter](...)
			end

			return nil
		end,
		[Roact.Event.MouseLeave] = function(...) -- line: 141
			-- upvalues: userInteractionEnabled (copy), p5 (copy), controlComponent (copy), Roact (copy)
			if not userInteractionEnabled then
				return nil
			end

			p5.stateTable.events.EndHover()

			if controlComponent.props[Roact.Event.MouseLeave] ~= nil then
				return controlComponent.props[Roact.Event.MouseLeave](...)
			end

			return nil
		end,
		[Roact.Event.InputBegan] = function(...) -- line: 151
			-- upvalues: userInteractionEnabled (copy), p5 (copy), controlComponent (copy), Roact (copy)
			if not userInteractionEnabled then
				return nil
			end

			local v25 = select(2, ...)

			if v25.UserInputType == Enum.UserInputType.MouseButton1 or v25.UserInputType == Enum.UserInputType.Touch or v25.KeyCode == Enum.KeyCode.ButtonA then
				p5.stateTable.events.OnPressed()
			end

			if controlComponent.props[Roact.Event.InputBegan] ~= nil then
				return controlComponent.props[Roact.Event.InputBegan](...)
			end

			return nil
		end,
		[Roact.Event.InputEnded] = function(...) -- line: 168
			-- upvalues: userInteractionEnabled (copy), p5 (copy), controlComponent (copy), Roact (copy)
			if not userInteractionEnabled then
				return nil
			end

			local v26 = select(2, ...)

			if v26.UserInputType == Enum.UserInputType.MouseButton1 then
				p5.stateTable.events.OnReleasedHover()
			elseif v26.UserInputType == Enum.UserInputType.Touch or v26.KeyCode == Enum.KeyCode.ButtonA or v26.UserInputType == Enum.UserInputType.MouseMovement then
				p5.stateTable.events.OnReleased()
			end

			if controlComponent.props[Roact.Event.InputEnded] ~= nil then
				return controlComponent.props[Roact.Event.InputEnded](...)
			end

			return nil
		end,
		[Roact.Event.SelectionGained] = function(...) -- line: 187
			-- upvalues: userInteractionEnabled (copy), p5 (copy), controlComponent (copy), Roact (copy)
			if not userInteractionEnabled then
				return nil
			end

			p5.stateTable.events.OnSelectionGained()

			if controlComponent.props[Roact.Event.SelectionGained] ~= nil then
				return controlComponent.props[Roact.Event.SelectionGained](...)
			end

			return nil
		end,
		[Roact.Event.SelectionLost] = function(...) -- line: 197
			-- upvalues: userInteractionEnabled (copy), p5 (copy), controlComponent (copy), Roact (copy)
			if not userInteractionEnabled then
				return nil
			end

			p5.stateTable.events.OnSelectionLost()

			if controlComponent.props[Roact.Event.SelectionLost] ~= nil then
				return controlComponent.props[Roact.Event.SelectionLost](...)
			end

			return nil
		end,
		[Roact.Event.Activated] = function(...) -- line: 207
			-- upvalues: userInteractionEnabled (copy), controlComponent (copy), Roact (copy), p5 (copy), ControlState (copy)
			if not userInteractionEnabled then
				return nil
			end

			if controlComponent.props[Roact.Event.Activated] and p5.state.currentState ~= ControlState.Disabled and p5.isMounted then
				return controlComponent.props[Roact.Event.Activated](...)
			end

			return nil
		end,
		[Roact.Ref] = controlComponent.props.forwardedRef,
		forwardedRef = Cryo.None,
		userInteractionEnabled = Cryo.None,
		isDisabled = Cryo.None,
		onStateChanged = Cryo.None,
		[Roact.Children] = Cryo.None,
		controlComponent = Cryo.None
	})

	return Roact.createElement(controlComponent.component, v17, controlComponent.children)
end
function v9.didMount(p6) -- line: 233
	p6.isMounted = true
	p6.setDisabled(p6.props.isDisabled)
end
function v9.didUpdate(p7, p8) -- line: 238
	if p7.props.isDisabled ~= p8.isDisabled then
		p7.setDisabled(p7.props.isDisabled)
	end
end
function v9.willUnmount(p9) -- line: 244
	p9.isMounted = false
end

return v9
