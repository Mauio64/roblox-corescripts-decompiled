local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local Cryo = require(parent3.Cryo)
local t = require(parent3.t)

local ControlState = require(parent.Enum.ControlState)
local StateTable = require(parent2.StateTable.StateTable)

local extended = Roact.PureComponent:extend("Controllable")

function extended:init()
	self.isMounted = false
	local initialize = ControlState.Initialize
	self.state = { currentState = initialize }

	local v = string.format("Controllable(%s)", (tostring(self)))

	function self.setDisabled(p)
		if p then
			self.stateTable.events.Disable()
		else
			self.stateTable.events.Enable()
		end
	end

	self.stateTable = StateTable.new(v, initialize, {}, {
		[ControlState.Initialize] = {
			Enable = { nextState = ControlState.Default },
			Disable = { nextState = ControlState.Disabled }
		},
		[ControlState.Default] = {
			OnPressed = { nextState = ControlState.Pressed },
			StartHover = { nextState = ControlState.Hover },
			OnSelectionGained = { nextState = ControlState.Selected },
			Disable = { nextState = ControlState.Disabled }
		},
		[ControlState.Hover] = {
			OnSelectionGained = { nextState = ControlState.Selected },
			OnPressed = { nextState = ControlState.Pressed },
			EndHover = { nextState = ControlState.Default },
			Disable = { nextState = ControlState.Disabled }
		},
		[ControlState.Pressed] = {
			OnSelectionGained = { nextState = ControlState.SelectedPressed },
			OnReleased = { nextState = ControlState.Default },
			OnReleasedHover = { nextState = ControlState.Hover },
			Disable = { nextState = ControlState.Disabled }
		},
		[ControlState.Selected] = {
			OnSelectionLost = { nextState = ControlState.Default },
			OnPressed = { nextState = ControlState.SelectedPressed },
			Disable = { nextState = ControlState.Disabled }
		},
		[ControlState.SelectedPressed] = {
			OnSelectionLost = { nextState = ControlState.Default },
			OnReleased = { nextState = ControlState.Selected },
			Disable = { nextState = ControlState.Disabled }
		},
		[ControlState.Disabled] = {
			Enable = { nextState = ControlState.Default }
		}
	})

	self.stateTable:onStateChange(function(p, currentState)
		self:setState({ currentState = currentState })

		if self.props.onStateChanged then
			self.props.onStateChanged(p, currentState)
		end
	end)
end

extended.validateProps = t.strictInterface({
	controlComponent = t.strictInterface({
		component = t.union(t.callback, t.string, t.table),
		props = t.optional(t.table),
		children = t.optional(t.table)
	}),
	onStateChanged = t.callback,
	isDisabled = t.optional(t.boolean),
	userInteractionEnabled = t.optional(t.boolean)
})

extended.defaultProps = { userInteractionEnabled = true, isDisabled = false }

function extended.render(props)
	local controlComponent = props.props.controlComponent
	local userInteractionEnabled = props.props.userInteractionEnabled

	if props.state.currentState == ControlState.Initialize then
		return nil
	end

	local selectable = controlComponent.props and controlComponent.props.Selectable
	local selectable2 = selectable == nil or selectable

	local join = Cryo.Dictionary.join
	local props2 = props.props
	local props3 = controlComponent.props or {}
	local v = join(props2, props3, {
		Selectable = selectable2,
		Active = not props.props.isDisabled,
		[Roact.Event.MouseEnter] = function(...)
			if not userInteractionEnabled then
				return nil
			end

			props.stateTable.events.StartHover()

			if controlComponent.props[Roact.Event.MouseEnter] == nil then
				return nil
			end

			return controlComponent.props[Roact.Event.MouseEnter](...)
		end,
		[Roact.Event.MouseLeave] = function(...)
			if not userInteractionEnabled then
				return nil
			end

			props.stateTable.events.EndHover()

			if controlComponent.props[Roact.Event.MouseLeave] == nil then
				return nil
			end

			return controlComponent.props[Roact.Event.MouseLeave](...)
		end,
		[Roact.Event.InputBegan] = function(...)
			if not userInteractionEnabled then
				return nil
			end

			local v = select(2, ...)

			if
				v.UserInputType == Enum.UserInputType.MouseButton1
				or v.UserInputType == Enum.UserInputType.Touch
				or v.KeyCode == Enum.KeyCode.ButtonA
			then
				props.stateTable.events.OnPressed()
			end

			if controlComponent.props[Roact.Event.InputBegan] == nil then
				return nil
			end

			return controlComponent.props[Roact.Event.InputBegan](...)
		end,
		[Roact.Event.InputEnded] = function(...)
			if not userInteractionEnabled then
				return nil
			end

			local v = select(2, ...)

			if v.UserInputType == Enum.UserInputType.MouseButton1 then
				props.stateTable.events.OnReleasedHover()
			elseif
				v.UserInputType == Enum.UserInputType.Touch
				or v.KeyCode == Enum.KeyCode.ButtonA
				or v.UserInputType == Enum.UserInputType.MouseMovement
			then
				props.stateTable.events.OnReleased()
			end

			if controlComponent.props[Roact.Event.InputEnded] == nil then
				return nil
			end

			return controlComponent.props[Roact.Event.InputEnded](...)
		end,
		[Roact.Event.SelectionGained] = function(...)
			if not userInteractionEnabled then
				return nil
			end

			props.stateTable.events.OnSelectionGained()

			if controlComponent.props[Roact.Event.SelectionGained] == nil then
				return nil
			end

			return controlComponent.props[Roact.Event.SelectionGained](...)
		end,
		[Roact.Event.SelectionLost] = function(...)
			if not userInteractionEnabled then
				return nil
			end

			props.stateTable.events.OnSelectionLost()

			if controlComponent.props[Roact.Event.SelectionLost] == nil then
				return nil
			end

			return controlComponent.props[Roact.Event.SelectionLost](...)
		end,
		[Roact.Event.Activated] = function(...)
			if not userInteractionEnabled then
				return nil
			end

			if
				controlComponent.props[Roact.Event.Activated]
				and props.state.currentState ~= ControlState.Disabled
				and props.isMounted
			then
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

	return Roact.createElement(controlComponent.component, v, controlComponent.children)
end

function extended:didMount()
	self.isMounted = true
	self.setDisabled(self.props.isDisabled)
end

function extended.didUpdate(p, p2)
	if p.props.isDisabled ~= p2.isDisabled then
		p.setDisabled(p.props.isDisabled)
	end
end

function extended:willUnmount()
	self.isMounted = false
end

return extended
