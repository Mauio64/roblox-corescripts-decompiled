local parent = script.Parent.Parent
local Roact = require(parent.Roact)
local Cryo = require(parent.Cryo)
local t = require(parent.t)

local FocusContext = require(script.Parent.FocusContext)
local FocusNode = require(script.Parent.FocusNode)
local getEngineInterface = require(script.Parent.getEngineInterface)

local FocusControllerInternalApi = require(script.Parent.FocusControllerInternalApi)

local v = {
	parentFocusNode = Cryo.None,
	parentNeighbors = Cryo.None,
	focusController = Cryo.None,
	onFocusGained = Cryo.None,
	onFocusLost = Cryo.None,
	onFocusChanged = Cryo.None,
	inputBindings = Cryo.None,
	innerRef = Cryo.None,
	restorePreviousChildFocus = Cryo.None,
	defaultChild = Cryo.None
}

local v2 = {}

local function checkFocusManager(p)
	if p.focusController == nil or p.parentFocusNode == nil then
		return true
	end

	return false, "Cannot attach a new focusController beneath an existing one"
end

local intersection = t.intersection(t.interface({
	parentFocusNode = t.optional(t.table),
	focusController = t.optional(t.table),
	innerRef = t.optional(t.table),
	restorePreviousChildFocus = t.boolean,
	inputBindings = t.table,
	defaultChild = t.optional(t.table),
	onFocusGained = t.optional(t.callback),
	onFocusLost = t.optional(t.callback),
	onFocusChanged = t.optional(t.callback)
}), checkFocusManager)

local defaultProps = { restorePreviousChildFocus = false, inputBindings = {} }

local function asFocusable(p)
	local formatted = ("Focusable(%s)"):format((tostring(p)))

	local extended = Roact.Component:extend(formatted)

	extended.validateProps = intersection
	extended.defaultProps = defaultProps

	function extended:init()
		self.focused = false
		self.defaultRef = Roact.createRef()

		local parentNeighbors = self.props.parentNeighbors or v2
		self:setState({
			focusNode = FocusNode.new(self.props, self:getRef()),
			parentNeighbors = parentNeighbors,
			neighbors = {
				NextSelectionLeft = self.props.NextSelectionLeft or parentNeighbors.NextSelectionLeft,
				NextSelectionRight = self.props.NextSelectionRight or parentNeighbors.NextSelectionRight,
				NextSelectionUp = self.props.NextSelectionUp or parentNeighbors.NextSelectionUp,
				NextSelectionDown = self.props.NextSelectionDown or parentNeighbors.NextSelectionDown
			},
			needsDescendantAddedRefocusCounter = 0,
			needsDescendantRemovedRefocusCounter = 0
		})

		function self.updateFocusedState(p2)
			if self.focused or not p2 then
				if self.focused and not p2 then
					self:loseFocus()
				end
			else
				self:gainFocus()
			end
		end

		if self:isRoot() then
			local v3 = false

			function self.ancestryChanged(instance)
				if not v3 and instance:IsDescendantOf(game) then
					v3 = true
					self:getFocusControllerInternal():initialize(getEngineInterface(instance))
				end
			end

			function self.ancestryChangedListener(p2)
				self.ancestryChanged(p2)

				local v4 = self.props[Roact.Event.AncestryChanged]

				if v4 ~= nil then
					v4(p2)
				end
			end

			function self.refreshFocusOnDescendantAdded(p2)
				if self:getFocusControllerInternal():needsDescendantAddedRefocus() then
					self:setState(function(p3)
						return {
							needsDescendantAddedRefocusCounter = p3.needsDescendantAddedRefocusCounter + 1
						}
					end)
				end

				local v4 = self.props[Roact.Event.DescendantAdded]

				if v4 ~= nil then
					v4(p2)
				end
			end

			function self.refreshFocusOnDescendantRemoved(p2)
				if self:getFocusControllerInternal():needsDescendantRemovedRefocus() then
					self:setState(function(p3)
						return {
							needsDescendantRemovedRefocusCounter = p3.needsDescendantRemovedRefocusCounter + 1
						}
					end)
				end

				local v4 = self.props[Roact.Event.DescendantRemoving]

				if v4 ~= nil then
					v4(p2)
				end
			end
		end
	end

	function extended.getDerivedStateFromProps(data, p2)
		local neighbors = p2.neighbors or v2
		local parentNeighbors = data.parentNeighbors or v2
		local nextSelectionLeft = data.NextSelectionLeft or parentNeighbors.NextSelectionLeft
		local nextSelectionRight = data.NextSelectionRight or parentNeighbors.NextSelectionRight
		local nextSelectionUp = data.NextSelectionUp or parentNeighbors.NextSelectionUp
		local nextSelectionDown = data.NextSelectionDown or parentNeighbors.NextSelectionDown

		if
			nextSelectionLeft == neighbors.NextSelectionLeft
			and nextSelectionRight == neighbors.NextSelectionRight
			and nextSelectionDown == neighbors.NextSelectionDown
			and nextSelectionUp == neighbors.NextSelectionUp
		then
			return nil
		end

		return {
			parentNeighbors = parentNeighbors,
			neighbors = {
				NextSelectionLeft = nextSelectionLeft,
				NextSelectionRight = nextSelectionRight,
				NextSelectionUp = nextSelectionUp,
				NextSelectionDown = nextSelectionDown
			}
		}
	end

	function extended:gainFocus()
		self.focused = true

		if self.props.onFocusGained ~= nil then
			self.props.onFocusGained()
		end

		if self.props.onFocusChanged ~= nil then
			self.props.onFocusChanged(true)
		end
	end

	function extended:loseFocus()
		self.focused = false

		if self.props.onFocusLost ~= nil then
			self.props.onFocusLost()
		end

		if self.props.onFocusChanged ~= nil then
			self.props.onFocusChanged(false)
		end
	end

	function extended:isRoot(): boolean
		return self.props.focusController ~= nil and self.props.parentFocusNode == nil
	end

	function extended:getFocusControllerInternal()
		return self.state.focusNode.focusController[FocusControllerInternalApi]
	end

	function extended:getRef()
		return self.props.innerRef or self.defaultRef
	end

	function extended:render()
		local ref = self:getRef()
		local refsByRef = {
			NextSelectionLeft = ref,
			NextSelectionRight = ref,
			NextSelectionDown = ref,
			NextSelectionUp = ref,
			[Roact.Ref] = ref
		}
		local joined

		if self:isRoot() then
			local v3 = {
				[Roact.Event.AncestryChanged] = self.ancestryChangedListener,
				[Roact.Event.DescendantAdded] = self.refreshFocusOnDescendantAdded,
				[Roact.Event.DescendantRemoving] = self.refreshFocusOnDescendantRemoved
			}

			joined = Cryo.Dictionary.join(refsByRef, self.props, v3, v)
		else
			joined = Cryo.Dictionary.join(refsByRef, self.props.parentNeighbors or v2, self.props, v)
		end

		return Roact.createElement(FocusContext.Provider, { value = self.state }, Roact.createElement(p, joined))
	end

	function extended:didMount()
		self.state.focusNode:attachToTree(self.props.parentFocusNode, self.updateFocusedState)

		if self:isRoot() then
			self.ancestryChanged(self:getRef():getValue())
		end
	end

	function extended:didUpdate(_, p2)
		self.state.focusNode:updateNavProps(self.props)

		local innerRef = self.props.innerRef or self.defaultRef

		if self.state.focusNode.ref ~= innerRef then
			error("Cannot change the ref passed to a Focusable component", 0)
		end

		if self.state.needsDescendantAddedRefocusCounter ~= p2.needsDescendantAddedRefocusCounter then
			self:getFocusControllerInternal():descendantAddedRefocus()
		end

		if self.state.needsDescendantRemovedRefocusCounter ~= p2.needsDescendantRemovedRefocusCounter then
			self:getFocusControllerInternal():descendantRemovedRefocus()
		end
	end

	function extended:willUnmount()
		self.state.focusNode:detachFromTree()

		if self:isRoot() then
			self:getFocusControllerInternal():teardown()
		end
	end

	return Roact.forwardRef(function(p2, innerRef)
		return Roact.createElement(FocusContext.Consumer, {
			render = function(p3)
				if p3 == nil and p2.focusController == nil then
					local v3 = Cryo.Dictionary.join(p2, v, { [Roact.Ref] = innerRef })

					return Roact.createElement(p, v3)
				else
					local join = Cryo.Dictionary.join
					local parentFocusNode

					if p3 then
						parentFocusNode = p3.focusNode or nil
					end

					local v3 = join(p2, {
						parentFocusNode = parentFocusNode,
						parentNeighbors = p3 and p3.neighbors or nil,
						innerRef = innerRef
					})

					return Roact.createElement(extended, v3)
				end
			end
		})
	end)
end

return asFocusable
