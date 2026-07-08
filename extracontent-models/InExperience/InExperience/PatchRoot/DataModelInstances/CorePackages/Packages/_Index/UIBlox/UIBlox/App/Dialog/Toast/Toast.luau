local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local t = require(ParentParentParentParent.t)
local SlidingDirection = require(ParentParentParent.Core.Animation.Enum.SlidingDirection)
local SlidingContainer = require(ParentParentParent.Core.Animation.SlidingContainer)
local validateColorInfo = require(ParentParentParent.Core.Style.Validator.validateColorInfo)
local StateTable = require(ParentParentParent.StateTable.StateTable)
local ButtonType = require(ParentParent.Button.Enum.ButtonType)
local AnimationState = require(scriptParent.Enum.AnimationState)
local InformativeToast = require(scriptParent.InformativeToast)
local InteractiveToast = require(scriptParent.InteractiveToast)
local ToastContainer = require(scriptParent.ToastContainer)
local v16 = Roact.PureComponent:extend("Toast")

v16.validateProps = t.strictInterface({
	anchorPoint = t.optional(t.Vector2),
	duration = t.optional(t.number),
	layoutOrder = t.optional(t.integer),
	position = t.optional(t.UDim2),
	show = t.optional(t.boolean),
	size = t.optional(t.UDim2),
	springOptions = t.optional(t.table),
	toastContent = t.strictInterface({
		buttonText = t.optional(t.string),
		iconColorStyle = t.optional(validateColorInfo),
		iconImage = t.optional(t.union(t.table, t.string, t.callback)),
		iconSize = t.optional(t.Vector2),
		iconChildren = t.optional(t.table),
		onActivated = t.optional(t.callback),
		onAppeared = t.optional(t.callback),
		onDismissed = t.optional(t.callback),
		swipeUpDismiss = t.optional(t.boolean),
		toastSubtitle = t.optional(t.string),
		sequenceNumber = t.optional(t.integer),
		toastTitle = t.string,
		buttonType = t.optional(ButtonType.isEnumValue),
		onTouchSwipeUp = t.optional(t.callback)
	})
})
v16.defaultProps = {
	show = true,
	anchorPoint = Vector2.new(0.5, 0),
	position = UDim2.new(0.5, 0, 0, 20)
}

local function toastContentEqual(p1, p2) -- line: 90
	if p1.iconColorStyle ~= p2.iconColorStyle or (p1.iconImage ~= p2.iconImage or p1.iconSize ~= p2.iconSize or p1.iconChildren ~= p2.iconChildren or p1.onActivated ~= p2.onActivated or p1.onDismissed ~= p2.onDismissed or p1.sequenceNumber ~= p2.sequenceNumber or p1.swipeUpDismiss ~= p2.swipeUpDismiss or p1.toastSubtitle ~= p2.toastSubtitle or p1.toastTitle ~= p2.toastTitle) then
		return false
	end

	return true
end

function v16.init(p3) -- line: 108
	-- upvalues: AnimationState (copy), Roact (copy), InteractiveToast (copy), InformativeToast (copy), StateTable (copy)
	p3.isMounted = false
	p3.currentToastContent = p3.props.toastContent

	function p3.onActivated() -- line: 113
		-- upvalues: p3 (copy)
		p3.stateTable.events.Activated({
			activated = true
		})
	end
	function p3.onAppeared() -- line: 119
		-- upvalues: p3 (copy)
		if p3.currentToastContent.onAppeared then
			p3.currentToastContent.onAppeared()
		end

		local duration = p3.props.duration

		if duration and duration > 0 then
			local currentToastContent = p3.currentToastContent

			delay(duration, function() -- line: 126
				-- upvalues: currentToastContent (copy), p3 (copy)
				if currentToastContent == p3.currentToastContent then
					p3.stateTable.events.AutoDismiss()
				end
			end)
		end
	end
	function p3.onComplete() -- line: 134
		-- upvalues: p3 (copy), AnimationState (copy)
		local duration = p3.props.duration

		if p3.state.currentState == AnimationState.Appearing and (duration and duration <= 0) then
			p3.stateTable.events.AutoDismiss()

			return
		end

		p3.stateTable.events.AnimationComplete()
	end
	function p3.onDisappeared() -- line: 144
		-- upvalues: p3 (copy)
		if p3.state.context.activated then
			if p3.currentToastContent.onActivated then
				p3.currentToastContent.onActivated()

				return
			end
		elseif p3.currentToastContent.onDismissed then
			p3.currentToastContent.onDismissed()
		end
	end
	function p3.onTouchSwipe(_, p5) -- line: 156
		-- upvalues: p3 (copy)
		if p5 == Enum.SwipeDirection.Up then
			p3.stateTable.events.ForceDismiss()

			if p3.currentToastContent.onTouchSwipeUp then
				p3.currentToastContent.onTouchSwipeUp()
			end
		end
	end
	function p3.renderInteractiveToast(p6) -- line: 165
		-- upvalues: Roact (copy), InteractiveToast (copy)
		return Roact.createElement(InteractiveToast, p6)
	end
	function p3.renderInformativeToast(p7) -- line: 169
		-- upvalues: Roact (copy), InformativeToast (copy)
		return Roact.createElement(InformativeToast, p7)
	end
	function p3.setContext(_, _, p10) -- line: 173
		return p10
	end
	function p3.updateToastContent() -- line: 177
		-- upvalues: p3 (copy)
		if p3.currentToastContent ~= p3.props.toastContent then
			p3.currentToastContent = p3.props.toastContent

			if p3.props.show then
				p3.stateTable.events.ForceAppear({
					activated = false
				})
			end
		end
	end

	local Disappeared = AnimationState.Disappeared

	p3.state = {
		currentState = Disappeared,
		context = {
			activated = false
		}
	}

	local v22 = string.format("Animated(%s)", (tostring(p3)))

	p3.stateTable = StateTable.new(v22, Disappeared, {}, {
		[AnimationState.Appearing] = {
			AnimationComplete = {
				nextState = AnimationState.Appeared,
				action = p3.onAppeared
			},
			AutoDismiss = {
				nextState = AnimationState.Disappearing,
				action = p3.onAppeared
			},
			ContentChanged = {
				nextState = AnimationState.Disappearing
			},
			ForceDismiss = {
				nextState = AnimationState.Disappearing
			}
		},
		[AnimationState.Appeared] = {
			Activated = {
				nextState = AnimationState.Disappearing,
				action = p3.setContext
			},
			AutoDismiss = {
				nextState = AnimationState.Disappearing
			},
			ContentChanged = {
				nextState = AnimationState.Disappearing
			},
			ForceDismiss = {
				nextState = AnimationState.Disappearing
			}
		},
		[AnimationState.Disappearing] = {
			AnimationComplete = {
				nextState = AnimationState.Disappeared,
				action = p3.onDisappeared
			}
		},
		[AnimationState.Disappeared] = {
			ContentChanged = {
				nextState = AnimationState.Appearing,
				action = p3.updateToastContent
			},
			ForceAppear = {
				nextState = AnimationState.Appearing,
				action = p3.setContext
			}
		}
	})
	p3.stateTable:onStateChange(function(p11, p12, p13) -- line: 220
		-- upvalues: p3 (copy)
		if p3.isMounted and p11 ~= p12 then
			p3:setState({
				currentState = p12,
				context = p13
			})
		end
	end)
end
function v16.isShowing(p14) -- line: 230
	-- upvalues: AnimationState (copy)
	return p14.state.currentState == AnimationState.Appearing or p14.state.currentState == AnimationState.Appeared
end
function v16.render(p15) -- line: 234
	-- upvalues: Roact (copy), SlidingContainer (copy), SlidingDirection (copy), ToastContainer (copy)
	local onActivated = p15.currentToastContent.onActivated
	local swipeUpDismiss = p15.currentToastContent.swipeUpDismiss

	if swipeUpDismiss == nil then
		swipeUpDismiss = true
	end

	return Roact.createElement(SlidingContainer, {
		show = p15:isShowing(),
		layoutOrder = p15.props.layoutOrder,
		onComplete = p15.onComplete,
		slidingDirection = SlidingDirection.Down,
		springOptions = p15.props.springOptions
	}, {
		ToastContainer = Roact.createElement(ToastContainer, {
			anchorPoint = p15.props.anchorPoint,
			buttonText = p15.currentToastContent.buttonText,
			position = p15.props.position,
			size = p15.props.size,
			iconColorStyle = p15.currentToastContent.iconColorStyle,
			iconImage = p15.currentToastContent.iconImage,
			iconSize = p15.currentToastContent.iconSize,
			iconChildren = p15.currentToastContent.iconChildren,
			onActivated = onActivated and p15.onActivated,
			onTouchSwipe = swipeUpDismiss and p15.onTouchSwipe,
			renderToast = onActivated and p15.renderInteractiveToast or p15.renderInformativeToast,
			toastSubtitle = p15.currentToastContent.toastSubtitle,
			toastTitle = p15.currentToastContent.toastTitle,
			buttonType = p15.currentToastContent.buttonType
		})
	})
end
function v16.didMount(p16) -- line: 267
	p16.isMounted = true

	if p16.props.show then
		p16.stateTable.events.ForceAppear({
			activated = false
		})
	end
end
function v16.willUnmount(p17) -- line: 276
	p17.isMounted = false
end
function v16.didUpdate(p18, p19, p20) -- line: 280
	-- upvalues: toastContentEqual (copy), AnimationState (copy)
	if p19.show ~= p18.props.show then
		if p18.props.show then
			p18.stateTable.events.ForceAppear({
				activated = false
			})
		else
			p18.stateTable.events.ForceDismiss()
		end
	end

	if not toastContentEqual(p19.toastContent, p18.props.toastContent) then
		p18.stateTable.events.ContentChanged({
			activated = false
		})
	end

	if p20.currentState ~= p18.state.currentState and p18.state.currentState == AnimationState.Disappeared then
		p18.updateToastContent()
	end
end

return v16
