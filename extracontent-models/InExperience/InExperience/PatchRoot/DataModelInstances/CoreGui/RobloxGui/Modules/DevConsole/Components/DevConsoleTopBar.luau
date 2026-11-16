local CorePackages = game:GetService("CorePackages")
local v = game:GetService("CoreGui")
v = v.RobloxGui
local TextService = game:GetService("TextService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local Constants = require(script.Parent.Parent.Constants)
local FrameHeight = Constants.TopBarFormatting.FrameHeight
local v2 = 0.5 * FrameHeight
local v3 = (FrameHeight - v2) / 2

local UserInputService = game:GetService("UserInputService")

local textSize = TextService:GetTextSize(
	"Developer Console",
	Constants.DefaultFontSize.TopBar,
	Constants.Font.TopBar,
	Vector2.new(0, 0)
)

local LiveUpdateElement = require(script.Parent.Parent.Components.LiveUpdateElement)
local SetDevConsolePosition = require(script.Parent.Parent.Actions.SetDevConsolePosition)

local extended = Roact.Component:extend("DevConsoleTopBar")

function extended:init()
	self.inputChangedConnection = nil

	self.inputChangedDisconnectRetries = 0

	function self.inputBegan(_, p)
		if self.props.isMinimized then
			return
		end

		if p.UserInputType == Enum.UserInputType.MouseButton1 then
			local absolutePosition = self.ref.current.AbsolutePosition
			local vector3 = Vector3.new(absolutePosition.X, absolutePosition.Y, 0)

			if self.inputChangedConnection then
				self.inputChangedConnection:Disconnect()
				self.inputChangedConnection = nil
			end

			self.inputChangedConnection = UserInputService.InputChanged:Connect(function(input)
				self.inputChanged(nil, input)
			end)

			self:setState({ startPos = vector3, startOffset = p.Position, moving = true })

			self.inputChangedDisconnectRetries = 1
		end
	end
	function self.inputChanged(_, p)
		if self.state.moving then
			if p.UserInputType == Enum.UserInputType.MouseMovement then
				local v4 = self.state.startPos - self.state.startOffset + p.Position
				local udim = UDim2.new(0, v4.X, 0, v4.Y)
				self.props.dispatchSetDevConsolePosition(udim)
			end
		elseif self.inputChangedConnection then
			if self.inputChangedDisconnectRetries > 0 then
				self.inputChangedDisconnectRetries -= 1
			else
				self.inputChangedConnection:Disconnect()
				self.inputChangedConnection = nil
			end
		end
	end
	function self.inputEnded(_, p)
		if p.UserInputType == Enum.UserInputType.MouseButton1 and p.UserInputState == Enum.UserInputState.End then
			if self.inputChangedConnection then
				self.inputChangedConnection:Disconnect()
				self.inputChangedConnection = nil
			end

			self:setState({ moving = false })
		end
	end

	self.ref = Roact.createRef()
end

function extended.render(props)
	local isMinimized = props.props.isMinimized
	local formFactor = props.props.formFactor

	local onMinimizeClicked = props.props.onMinimizeClicked
	local onMaximizeClicked = props.props.onMaximizeClicked
	local onCloseClicked = props.props.onCloseClicked

	local _moving = props.state.moving

	local children = {}

	children.WindowTitle = Roact.createElement("TextLabel", {
		Text = "Developer Console",
		TextSize = Constants.DefaultFontSize.TopBar,
		TextColor3 = Color3.new(1, 1, 1),
		Font = Constants.Font.TopBar,
		Size = UDim2.new(0, textSize.X, 0, FrameHeight),
		Position = UDim2.new(0, 4, 0, 0),
		BackgroundColor3 = Constants.Color.BaseGray,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local v4 = textSize.X + 8
	local udim = UDim2.new(0, v4, 0, 0)
	local udim2 = UDim2.new(1, -2 * v4, 0, FrameHeight)

	if isMinimized then
		udim = UDim2.new(0, 0, 1, 0)
		udim2 = UDim2.new(1, 0, 1, 0)
	elseif props.ref.current then
		udim2 = UDim2.new(0, props.ref.current.AbsoluteSize.X - 2 * textSize.X, 0, FrameHeight)
	end

	local topBarLiveUpdate = props.props.topBarLiveUpdate

	children.LiveStatsModule = Roact.createElement(LiveUpdateElement, {
		topBarLiveUpdate = topBarLiveUpdate,
		size = udim2,
		position = udim
	})

	if formFactor == Constants.FormFactor.Large then
		if isMinimized then
			children.MaxButton = Roact.createElement("ImageButton", {
				Size = UDim2.new(0, v2, 0, v2),
				Position = UDim2.new(1, -2 * FrameHeight + v3, 0, v3),
				BorderColor3 = Color3.new(0, 0, 1),
				BackgroundColor3 = Constants.Color.BaseGray,
				BackgroundTransparency = 1,
				Image = Constants.Image.Maximize,
				[Roact.Event.Activated] = onMaximizeClicked
			})
		else
			children.MinButton = Roact.createElement("ImageButton", {
				Size = UDim2.new(0, v2, 0, v2),
				Position = UDim2.new(1, -2 * FrameHeight + v3, 0, v3),
				BorderColor3 = Color3.new(1, 0, 0),
				BackgroundColor3 = Constants.Color.BaseGray,
				BackgroundTransparency = 1,
				Image = Constants.Image.Minimize,
				[Roact.Event.Activated] = onMinimizeClicked
			})
		end
	end

	children.CloseButton = Roact.createElement("ImageButton", {
		Size = UDim2.new(0, v2, 0, v2),
		Position = UDim2.new(1, -FrameHeight + v3, 0, v3),
		BorderColor3 = Color3.new(0, 1, 0),
		BackgroundColor3 = Constants.Color.BaseGray,
		BackgroundTransparency = 1,
		ZIndex = 2,
		Image = Constants.Image.Close,
		[Roact.Event.Activated] = onCloseClicked
	})

	return Roact.createElement("ImageButton", {
		Size = UDim2.new(1, 0, 0, FrameHeight),
		BackgroundColor3 = Constants.Color.Black,
		BackgroundTransparency = 0.5,
		AutoButtonColor = false,
		LayoutOrder = 1,
		[Roact.Ref] = props.ref,
		[Roact.Event.InputBegan] = props.inputBegan,
		[Roact.Event.InputEnded] = props.inputEnded
	}, children)
end

local function mapDispatchToProps(callback)
	return {
		dispatchSetDevConsolePosition = function(p)
			callback(SetDevConsolePosition(p))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(nil, mapDispatchToProps)(extended)
