local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)
local Cryo = require(ParentParent.Cryo)
local t = require(ParentParent.t)
local FocusContext = require(script.Parent.FocusContext)
local FocusNode = require(script.Parent.FocusNode)
local getEngineInterface = require(script.Parent.getEngineInterface)
local FocusControllerInternalApi = require(script.Parent.FocusControllerInternalApi)
local t1 = {
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
local t2 = {}

local function checkFocusManager(p1) -- line: 34
	if p1.focusController ~= nil and p1.parentFocusNode ~= nil then
		return false, "Cannot attach a new focusController beneath an existing one"
	end

	return true
end

local v12 = t.intersection(t.interface({
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
local t3 = {
	restorePreviousChildFocus = false,
	inputBindings = {}
}

local function asFocusable(p2) -- line: 69
	-- upvalues: Roact (copy), v12 (copy), t3 (copy), t2 (copy), FocusNode (copy), getEngineInterface (copy), FocusControllerInternalApi (copy), Cryo (copy), t1 (copy), FocusContext (copy)
	local v17 = ("Focusable(%s)"):format((tostring(p2)))
	local v18 = Roact.Component:extend(v17)

	v18.validateProps = v12
	v18.defaultProps = t3

	function v18.init(p3) -- line: 79
		-- upvalues: Roact (copy), t2 (copy), FocusNode (copy), getEngineInterface (copy)
		p3.focused = false
		p3.defaultRef = Roact.createRef()

		local v20 = p3.props.parentNeighbors or t2

		p3:setState({
			needsDescendantAddedRefocusCounter = 0,
			needsDescendantRemovedRefocusCounter = 0,
			focusNode = FocusNode.new(p3.props, p3:getRef()),
			parentNeighbors = v20,
			neighbors = {
				NextSelectionLeft = p3.props.NextSelectionLeft or v20.NextSelectionLeft,
				NextSelectionRight = p3.props.NextSelectionRight or v20.NextSelectionRight,
				NextSelectionUp = p3.props.NextSelectionUp or v20.NextSelectionUp,
				NextSelectionDown = p3.props.NextSelectionDown or v20.NextSelectionDown
			}
		})

		function p3.updateFocusedState(p4) -- line: 97
			-- upvalues: p3 (copy)
			if not p3.focused and p4 then
				p3:gainFocus()

				return
			end

			if p3.focused and not p4 then
				p3:loseFocus()
			end
		end

		if p3:isRoot() then
			local u21 = false

			function p3.ancestryChanged(p5) -- line: 111
				-- upvalues: u21 (ref), p3 (copy), getEngineInterface (copy)
				if not u21 and p5:IsDescendantOf(game) then
					u21 = true
					p3:getFocusControllerInternal():initialize(getEngineInterface(p5))
				end
			end
			function p3.ancestryChangedListener(p6) -- line: 121
				-- upvalues: p3 (copy), Roact (copy)
				p3.ancestryChanged(p6)

				local v50 = p3.props[Roact.Event.AncestryChanged]

				if v50 ~= nil then
					v50(p6)
				end
			end
			function p3.refreshFocusOnDescendantAdded(p7) -- line: 130
				-- upvalues: p3 (copy), Roact (copy)
				if p3:getFocusControllerInternal():needsDescendantAddedRefocus() then
					p3:setState(function(p8) -- line: 132
						return {
							needsDescendantAddedRefocusCounter = p8.needsDescendantAddedRefocusCounter + 1
						}
					end)
				end

				local v52 = p3.props[Roact.Event.DescendantAdded]

				if v52 ~= nil then
					v52(p7)
				end
			end
			function p3.refreshFocusOnDescendantRemoved(p9) -- line: 145
				-- upvalues: p3 (copy), Roact (copy)
				if p3:getFocusControllerInternal():needsDescendantRemovedRefocus() then
					p3:setState(function(p10) -- line: 147
						return {
							needsDescendantRemovedRefocusCounter = p10.needsDescendantRemovedRefocusCounter + 1
						}
					end)
				end

				local v54 = p3.props[Roact.Event.DescendantRemoving]

				if v54 ~= nil then
					v54(p9)
				end
			end
		end
	end
	function v18.getDerivedStateFromProps(p11, p12) -- line: 162
		-- upvalues: t2 (copy)
		local v24 = p12.neighbors or t2
		local v25 = p11.parentNeighbors or t2
		local v26 = p11.NextSelectionLeft or v25.NextSelectionLeft
		local v27 = p11.NextSelectionRight or v25.NextSelectionRight
		local v28 = p11.NextSelectionUp or v25.NextSelectionUp
		local v29 = p11.NextSelectionDown or v25.NextSelectionDown

		if v26 ~= v24.NextSelectionLeft or (v27 ~= v24.NextSelectionRight or v29 ~= v24.NextSelectionDown or v28 ~= v24.NextSelectionUp) then
			return {
				parentNeighbors = v25,
				neighbors = {
					NextSelectionLeft = v26,
					NextSelectionRight = v27,
					NextSelectionUp = v28,
					NextSelectionDown = v29
				}
			}
		end

		return nil
	end
	function v18.gainFocus(p13) -- line: 195
		p13.focused = true

		if p13.props.onFocusGained ~= nil then
			p13.props.onFocusGained()
		end

		if p13.props.onFocusChanged ~= nil then
			p13.props.onFocusChanged(true)
		end
	end
	function v18.loseFocus(p14) -- line: 207
		p14.focused = false

		if p14.props.onFocusLost ~= nil then
			p14.props.onFocusLost()
		end

		if p14.props.onFocusChanged ~= nil then
			p14.props.onFocusChanged(false)
		end
	end
	function v18.isRoot(p15) -- line: 222
		return p15.props.focusController ~= nil and p15.props.parentFocusNode == nil
	end
	function v18.getFocusControllerInternal(p16) -- line: 226
		-- upvalues: FocusControllerInternalApi (copy)
		return p16.state.focusNode.focusController[FocusControllerInternalApi]
	end
	function v18.getRef(p17) -- line: 230
		return p17.props.innerRef or p17.defaultRef
	end
	function v18.render(p18) -- line: 234
		-- upvalues: Roact (copy), Cryo (copy), t1 (copy), t2 (copy), FocusContext (copy), p2 (copy)
		local v36 = p18:getRef()
		local t4 = {
			NextSelectionLeft = v36,
			NextSelectionRight = v36,
			NextSelectionDown = v36,
			NextSelectionUp = v36,
			[Roact.Ref] = v36
		}
		local v39

		if p18:isRoot() then
			local t5 = {
				[Roact.Event.AncestryChanged] = p18.ancestryChangedListener,
				[Roact.Event.DescendantAdded] = p18.refreshFocusOnDescendantAdded,
				[Roact.Event.DescendantRemoving] = p18.refreshFocusOnDescendantRemoved
			}

			v39 = Cryo.Dictionary.join(t4, p18.props, t5, t1)
		else
			v39 = Cryo.Dictionary.join(t4, p18.props.parentNeighbors or t2, p18.props, t1)
		end

		return Roact.createElement(FocusContext.Provider, {
			value = p18.state
		}, Roact.createElement(p2, v39))
	end
	function v18.didMount(p19) -- line: 272
		p19.state.focusNode:attachToTree(p19.props.parentFocusNode, p19.updateFocusedState)

		if p19:isRoot() then
			p19.ancestryChanged(p19:getRef():getValue())
		end
	end
	function v18.didUpdate(p20, _, p22) -- line: 283
		p20.state.focusNode:updateNavProps(p20.props)

		if (p20.props.innerRef or p20.defaultRef) ~= p20.state.focusNode.ref then
			error("Cannot change the ref passed to a Focusable component", 0)
		end

		if p20.state.needsDescendantAddedRefocusCounter ~= p22.needsDescendantAddedRefocusCounter then
			p20:getFocusControllerInternal():descendantAddedRefocus()
		end

		if p20.state.needsDescendantRemovedRefocusCounter ~= p22.needsDescendantRemovedRefocusCounter then
			p20:getFocusControllerInternal():descendantRemovedRefocus()
		end
	end
	function v18.willUnmount(p23) -- line: 305
		p23.state.focusNode:detachFromTree()

		if p23:isRoot() then
			p23:getFocusControllerInternal():teardown()
		end
	end

	return Roact.forwardRef(function(p24, p25) -- line: 313
		-- upvalues: Roact (copy), FocusContext (copy), Cryo (copy), t1 (copy), p2 (copy), v18 (copy)
		return Roact.createElement(FocusContext.Consumer, {
			render = function(p26) -- line: 315
				-- upvalues: p24 (copy), Cryo (copy), t1 (copy), Roact (copy), p25 (copy), p2 (copy), v18 (copy)
				if p26 == nil and p24.focusController == nil then
					local v56 = Cryo.Dictionary.join(p24, t1, {
						[Roact.Ref] = p25
					})

					return Roact.createElement(p2, v56)
				end

				local v57 = Cryo.Dictionary.join(p24, {
					parentFocusNode = p26 and p26.focusNode or nil,
					parentNeighbors = p26 and p26.neighbors or nil,
					innerRef = p25
				})

				return Roact.createElement(v18, v57)
			end
		})
	end)
end

return asFocusable
