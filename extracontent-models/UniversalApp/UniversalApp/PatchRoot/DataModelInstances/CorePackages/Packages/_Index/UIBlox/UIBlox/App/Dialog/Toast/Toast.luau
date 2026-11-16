local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent

local Roact = require(parent4.Roact)
local t = require(parent4.t)

local SlidingDirection = require(parent3.Core.Animation.Enum.SlidingDirection)
local SlidingContainer = require(parent3.Core.Animation.SlidingContainer)
local validateColorInfo = require(parent3.Core.Style.Validator.validateColorInfo)
local StateTable = require(parent3.StateTable.StateTable)
local ButtonType = require(parent2.Button.Enum.ButtonType)

local AnimationState = require(parent.Enum.AnimationState)
local InformativeToast = require(parent.InformativeToast)
local InteractiveToast = require(parent.InteractiveToast)
local ToastContainer = require(parent.ToastContainer)

local extended = Roact.PureComponent:extend("Toast")

extended.validateProps = t.strictInterface({
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

extended.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0),
	position = UDim2.new(0.5, 0, 0, 20),
	show = true
}

local function toastContentEqual(toastContent, toastContent2): boolean
	return toastContent.iconColorStyle == toastContent2.iconColorStyle
		and toastContent.iconImage == toastContent2.iconImage
		and toastContent.iconSize == toastContent2.iconSize
		and toastContent.iconChildren == toastContent2.iconChildren
		and toastContent.onActivated == toastContent2.onActivated
		and toastContent.onDismissed == toastContent2.onDismissed
		and toastContent.sequenceNumber == toastContent2.sequenceNumber
		and toastContent.swipeUpDismiss == toastContent2.swipeUpDismiss
		and toastContent.toastSubtitle == toastContent2.toastSubtitle
		and toastContent.toastTitle == toastContent2.toastTitle
end

function extended:init()
	self.isMounted = false

	self.currentToastContent = self.props.toastContent

	function self.onActivated()
		self.stateTable.events.Activated({ activated = true })
	end

	function self.onAppeared()
		if self.currentToastContent.onAppeared then
			self.currentToastContent.onAppeared()
		end

		local duration = self.props.duration

		if duration and duration > 0 then
			local currentToastContent = self.currentToastContent
			delay(duration, function()
				if currentToastContent == self.currentToastContent then
					self.stateTable.events.AutoDismiss()
				end
			end)
		end
	end

	function self.onComplete()
		local duration = self.props.duration

		if self.state.currentState == AnimationState.Appearing and duration and duration <= 0 then
			self.stateTable.events.AutoDismiss()
		else
			self.stateTable.events.AnimationComplete()
		end
	end

	function self.onDisappeared()
		if self.state.context.activated then
			if self.currentToastContent.onActivated then
				self.currentToastContent.onActivated()
			end
		elseif self.currentToastContent.onDismissed then
			self.currentToastContent.onDismissed()
		end
	end

	function self.onTouchSwipe(_, p)
		if p == Enum.SwipeDirection.Up then
			self.stateTable.events.ForceDismiss()

			if self.currentToastContent.onTouchSwipeUp then
				self.currentToastContent.onTouchSwipeUp()
			end
		end
	end

	function self.renderInteractiveToast(p)
		return Roact.createElement(InteractiveToast, p)
	end

	function self.renderInformativeToast(p)
		return Roact.createElement(InformativeToast, p)
	end

	function self.setContext(_, _, p)
		return p
	end

	function self.updateToastContent()
		if self.currentToastContent ~= self.props.toastContent then
			self.currentToastContent = self.props.toastContent

			if self.props.show then
				self.stateTable.events.ForceAppear({ activated = false })
			end
		end
	end

	local disappeared = AnimationState.Disappeared
	self.state = {
		currentState = disappeared,
		context = { activated = false }
	}

	local v = string.format("Animated(%s)", (tostring(self)))
	self.stateTable = StateTable.new(v, disappeared, {}, {
		[AnimationState.Appearing] = {
			AnimationComplete = { nextState = AnimationState.Appeared, action = self.onAppeared },
			AutoDismiss = { nextState = AnimationState.Disappearing, action = self.onAppeared },
			ContentChanged = { nextState = AnimationState.Disappearing },
			ForceDismiss = { nextState = AnimationState.Disappearing }
		},
		[AnimationState.Appeared] = {
			Activated = { nextState = AnimationState.Disappearing, action = self.setContext },
			AutoDismiss = { nextState = AnimationState.Disappearing },
			ContentChanged = { nextState = AnimationState.Disappearing },
			ForceDismiss = { nextState = AnimationState.Disappearing }
		},
		[AnimationState.Disappearing] = {
			AnimationComplete = {
				nextState = AnimationState.Disappeared,
				action = self.onDisappeared
			}
		},
		[AnimationState.Disappeared] = {
			ContentChanged = {
				nextState = AnimationState.Appearing,
				action = self.updateToastContent
			},
			ForceAppear = { nextState = AnimationState.Appearing, action = self.setContext }
		}
	})

	self.stateTable:onStateChange(function(p, currentState, context)
		if self.isMounted and p ~= currentState then
			self:setState({ currentState = currentState, context = context })
		end
	end)
end

function extended:isShowing(): boolean
	return self.state.currentState == AnimationState.Appearing or self.state.currentState == AnimationState.Appeared
end

function extended:render()
	local onActivated = self.currentToastContent.onActivated
	local swipeUpDismiss = self.currentToastContent.swipeUpDismiss
	local v = swipeUpDismiss == nil or swipeUpDismiss

	return Roact.createElement(SlidingContainer, {
		show = self:isShowing(),
		layoutOrder = self.props.layoutOrder,
		onComplete = self.onComplete,
		slidingDirection = SlidingDirection.Down,
		springOptions = self.props.springOptions
	}, {
		ToastContainer = Roact.createElement(ToastContainer, {
			anchorPoint = self.props.anchorPoint,
			buttonText = self.currentToastContent.buttonText,
			position = self.props.position,
			size = self.props.size,
			iconColorStyle = self.currentToastContent.iconColorStyle,
			iconImage = self.currentToastContent.iconImage,
			iconSize = self.currentToastContent.iconSize,
			iconChildren = self.currentToastContent.iconChildren,
			onActivated = onActivated and self.onActivated,
			onTouchSwipe = v and self.onTouchSwipe,
			renderToast = onActivated and self.renderInteractiveToast or self.renderInformativeToast,
			toastSubtitle = self.currentToastContent.toastSubtitle,
			toastTitle = self.currentToastContent.toastTitle,
			buttonType = self.currentToastContent.buttonType
		})
	})
end

function extended:didMount()
	self.isMounted = true

	if self.props.show then
		self.stateTable.events.ForceAppear({ activated = false })
	end
end

function extended:willUnmount()
	self.isMounted = false
end

function extended.didUpdate(data, p, p2)
	if p.show ~= data.props.show then
		if data.props.show then
			data.stateTable.events.ForceAppear({ activated = false })
		else
			data.stateTable.events.ForceDismiss()
		end
	end

	if not toastContentEqual(p.toastContent, data.props.toastContent) then
		data.stateTable.events.ContentChanged({ activated = false })
	end

	if p2.currentState ~= data.state.currentState and data.state.currentState == AnimationState.Disappeared then
		data.updateToastContent()
	end
end

return extended
