local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local Otter = require(CorePackages.Packages.Otter)

local Connection = script.Parent.Parent.Connection
local LayoutValues = require(Connection.LayoutValues)
local WithLayoutValues = LayoutValues.WithLayoutValues

local DropDownButton = require(script.Parent.DropDownButton)

local v = { dampingRatio = 1, frequency = 4 }

local v2 = { dampingRatio = 1, frequency = 4 }

local extended = Roact.PureComponent:extend("DropDownAnimator")

extended.validateProps = t.strictInterface({
	text = t.string,
	icon = t.union(t.string, t.table),
	lastButton = t.boolean,
	layoutOrder = t.integer,
	onActivated = t.callback,
	forceShowOptions = t.boolean,
	selectedPlayer = t.optional(t.instanceIsA("Player")),
	onDecline = t.optional(t.callback),
	onDismiss = t.optional(t.callback)
})

function extended:init()
	self.state = {
		lastButtonProps = nil,
		onDeclineCalled = nil,
		onActivatedCalled = nil,
		overlayPercentage = 0
	}

	local binding, updateCurrentButtonPosition = Roact.createBinding(UDim2.new(0, 0, 0, 0))
	self.currentButtonPosition = binding
	self.updateCurrentButtonPosition = updateCurrentButtonPosition
	local binding2, updateLastButtonPosition = Roact.createBinding(UDim2.new(0, 0, 0, 0))
	self.lastButtonPosition = binding2
	self.updateLastButtonPosition = updateLastButtonPosition

	self.positionMotor = Otter.createSingleMotor(0)
	self.positionMotor:onStep(function(p)
		self.updateCurrentButtonPosition(UDim2.new(p, 0, 0, 0))

		if self.animatingRight then
			self.updateLastButtonPosition(UDim2.new(p + 1, 0, 0, 0))
		else
			self.updateLastButtonPosition(UDim2.new(p - 1, 0, 0, 0))
		end
	end)
	self.positionMotor:onComplete(function(p)
		if p == 0 then
			self:setState({
				lastButtonProps = Roact.None,
				onDeclineCalled = Roact.None,
				onActivatedCalled = Roact.None
			})
		end
	end)

	self.overlayMotor = Otter.createSingleMotor(0)
	self.overlayMotor:onStep(function(overlayPercentage)
		self:setState({ overlayPercentage = overlayPercentage })
	end)
	self.overlayMotor:onComplete(function(p)
		if p == 1 then
			self.positionMotor:setGoal(Otter.spring(0, v))
		end
	end)
end

function extended:getButtonProps(data, p)
	local buttonProps = {}
	buttonProps.text = data.text
	buttonProps.icon = data.icon
	buttonProps.lastButton = data.lastButton
	buttonProps.forceShowOptions = data.forceShowOptions
	buttonProps.onDismiss = data.onDismiss

	if self.state.lastButtonProps ~= nil then
		if p then
			buttonProps.animatingAccept = self.state.onActivatedCalled
			buttonProps.animatingDecline = self.state.onDeclineCalled
			buttonProps.animatingPercentage = self.state.overlayPercentage
			return buttonProps
		end
	else
		if data.onActivated and (data.onDecline or self.props.forceShowOptions) then
			function buttonProps.onActivated()
				self:setState({ onActivatedCalled = true, onDeclineCalled = false })

				data.onActivated()
			end
		elseif data.onActivated then
			buttonProps.onActivated = data.onActivated
		end

		if data.onDecline then
			function buttonProps.onDecline()
				self:setState({ onActivatedCalled = false, onDeclineCalled = true })

				data.onDecline()
			end
		end
	end

	return buttonProps
end

function extended:render()
	return WithLayoutValues(function(p)
		local v3 = {}

		v3.CurrentButtonContainer = Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 1, 0),
				Position = self.currentButtonPosition,
				BackgroundTransparency = 1
			},
			{
				DropDownButton = Roact.createElement(DropDownButton, self:getButtonProps(self.props))
			}
		)

		if self.state.lastButtonProps then
			v3.LastButtonContainer = Roact.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 1, 0),
					Position = self.lastButtonPosition,
					BackgroundTransparency = 1
				},
				{
					DropDownButton = Roact.createElement(
						DropDownButton,
						self:getButtonProps(self.state.lastButtonProps, true)
					)
				}
			)
		end

		return Roact.createElement(
			"Frame",
			{
				ZIndex = 2,
				Size = UDim2.new(1, 0, 0, p.DropDownButtonSizeY),
				BackgroundTransparency = 1,
				LayoutOrder = self.props.layoutOrder
			},
			v3
		)
	end)
end

function extended:didUpdate(lastButtonProps, _)
	local v3 = self.props.text ~= lastButtonProps.text
	local v4 = lastButtonProps.onDecline ~= nil or self.props.forceShowOptions
	local onDeclineCalled = self.state.onDeclineCalled or self.state.onActivatedCalled

	if v3 and v4 and onDeclineCalled then
		if self.state.onActivatedCalled and not self.props.forceShowOptions then
			self.animatingRight = true
			self.positionMotor:setGoal(Otter.instant(-1))
		else
			self.animatingRight = false
			self.positionMotor:setGoal(Otter.instant(1))
		end

		self.overlayMotor:setGoal(Otter.instant(0))
		self.positionMotor:step(0)
		self.overlayMotor:step(0)

		self:setState({ lastButtonProps = lastButtonProps })

		self.overlayMotor:setGoal(Otter.spring(1, v2))
	end

	if self.props.selectedPlayer ~= lastButtonProps.selectedPlayer then
		self.positionMotor:setGoal(Otter.instant(0))
		self.overlayMotor:setGoal(Otter.instant(0))
		self.positionMotor:step(0)
		self.overlayMotor:step(0)

		self:setState({ lastButtonProps = Roact.None })
	end
end

function extended:willUnmount()
	self.positionMotor:destroy()
	self.positionMotor = nil
	self.overlayMotor:destroy()
	self.overlayMotor = nil
end

return extended
