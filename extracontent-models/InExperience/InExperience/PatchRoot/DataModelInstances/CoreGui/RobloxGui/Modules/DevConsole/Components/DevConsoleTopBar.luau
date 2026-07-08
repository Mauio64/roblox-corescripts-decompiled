local CorePackages = game:GetService("CorePackages")
local _ = game:GetService("CoreGui").RobloxGui
local TextService = game:GetService("TextService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Constants = require(script.Parent.Parent.Constants)
local FrameHeight = Constants.TopBarFormatting.FrameHeight
local v8 = 0.5 * FrameHeight
local v9 = (FrameHeight - v8) / 2
local UserInputService = game:GetService("UserInputService")
local TextSize = TextService:GetTextSize("Developer Console", Constants.DefaultFontSize.TopBar, Constants.Font.TopBar, Vector2.new(0, 0))
local LiveUpdateElement = require(script.Parent.Parent.Components.LiveUpdateElement)
local SetDevConsolePosition = require(script.Parent.Parent.Actions.SetDevConsolePosition)
local v14 = Roact.Component:extend("DevConsoleTopBar")

function v14.init(p1) -- line: 24
	-- upvalues: UserInputService (copy), Roact (copy)
	p1.inputChangedConnection = nil
	p1.inputChangedDisconnectRetries = 0

	function p1.inputBegan(_, p3) -- line: 29
		-- upvalues: p1 (copy), UserInputService (copy)
		if p1.props.isMinimized then
			return
		end

		if p3.UserInputType == Enum.UserInputType.MouseButton1 then
			local AbsolutePosition = p1.ref.current.AbsolutePosition
			local vector3 = Vector3.new(AbsolutePosition.X, AbsolutePosition.Y, 0)

			if p1.inputChangedConnection then
				p1.inputChangedConnection:Disconnect()
				p1.inputChangedConnection = nil
			end

			p1.inputChangedConnection = UserInputService.InputChanged:Connect(function(input) -- line: 44
				-- upvalues: p1 (copy)
				p1.inputChanged(nil, input)
			end)
			p1:setState({
				moving = true,
				startPos = vector3,
				startOffset = p3.Position
			})
			p1.inputChangedDisconnectRetries = 1
		end
	end
	function p1.inputChanged(_, p5) -- line: 58
		-- upvalues: p1 (copy)
		if p1.state.moving then
			if p5.UserInputType == Enum.UserInputType.MouseMovement then
				local v36 = p1.state.startPos - p1.state.startOffset + p5.Position
				local uDim2 = UDim2.new(0, v36.X, 0, v36.Y)

				p1.props.dispatchSetDevConsolePosition(uDim2)

				return
			end
		elseif p1.inputChangedConnection then
			if p1.inputChangedDisconnectRetries > 0 then
				p1.inputChangedDisconnectRetries = p1.inputChangedDisconnectRetries - 1

				return
			end

			p1.inputChangedConnection:Disconnect()
			p1.inputChangedConnection = nil
		end
	end
	function p1.inputEnded(_, p7) -- line: 75
		-- upvalues: p1 (copy)
		if p7.UserInputType == Enum.UserInputType.MouseButton1 and p7.UserInputState == Enum.UserInputState.End then
			if p1.inputChangedConnection then
				p1.inputChangedConnection:Disconnect()
				p1.inputChangedConnection = nil
			end

			p1:setState({
				moving = false
			})
		end
	end

	p1.ref = Roact.createRef()
end
function v14.render(p8) -- line: 95
	-- upvalues: Roact (copy), Constants (copy), TextSize (copy), FrameHeight (copy), LiveUpdateElement (copy), v8 (copy), v9 (copy)
	local isMinimized = p8.props.isMinimized
	local formFactor = p8.props.formFactor
	local onMinimizeClicked = p8.props.onMinimizeClicked
	local onMaximizeClicked = p8.props.onMaximizeClicked
	local onCloseClicked = p8.props.onCloseClicked
	local _ = p8.state.moving
	local t1 = {
		WindowTitle = Roact.createElement("TextLabel", {
			Text = "Developer Console",
			BackgroundTransparency = 1,
			TextSize = Constants.DefaultFontSize.TopBar,
			TextColor3 = Color3.new(1, 1, 1),
			Font = Constants.Font.TopBar,
			Size = UDim2.new(0, TextSize.X, 0, FrameHeight),
			Position = UDim2.new(0, 4, 0, 0),
			BackgroundColor3 = Constants.Color.BaseGray,
			TextXAlignment = Enum.TextXAlignment.Left
		})
	}
	local v25 = TextSize.X + 8
	local uDim2 = UDim2.new(0, v25, 0, 0)
	local uDim2_2 = UDim2.new(1, -2 * v25, 0, FrameHeight)

	if isMinimized then
		uDim2 = UDim2.new(0, 0, 1, 0)
		uDim2_2 = UDim2.new(1, 0, 1, 0)
	elseif p8.ref.current then
		uDim2_2 = UDim2.new(0, p8.ref.current.AbsoluteSize.X - 2 * TextSize.X, 0, FrameHeight)
	end

	local topBarLiveUpdate = p8.props.topBarLiveUpdate

	t1.LiveStatsModule = Roact.createElement(LiveUpdateElement, {
		topBarLiveUpdate = topBarLiveUpdate,
		size = uDim2_2,
		position = uDim2
	})

	if formFactor == Constants.FormFactor.Large then
		if not isMinimized then
			t1.MinButton = Roact.createElement("ImageButton", {
				Size = UDim2.new(0, v8, 0, v8),
				Position = UDim2.new(1, -2 * FrameHeight + v9, 0, v9),
				BorderColor3 = Color3.new(1, 0, 0),
				BackgroundColor3 = Constants.Color.BaseGray,
				BackgroundTransparency = 1,
				Image = Constants.Image.Minimize,
				[Roact.Event.Activated] = onMinimizeClicked
			})
		else
			t1.MaxButton = Roact.createElement("ImageButton", {
				Size = UDim2.new(0, v8, 0, v8),
				Position = UDim2.new(1, -2 * FrameHeight + v9, 0, v9),
				BorderColor3 = Color3.new(0, 0, 1),
				BackgroundColor3 = Constants.Color.BaseGray,
				BackgroundTransparency = 1,
				Image = Constants.Image.Maximize,
				[Roact.Event.Activated] = onMaximizeClicked
			})
		end
	end

	t1.CloseButton = Roact.createElement("ImageButton", {
		Size = UDim2.new(0, v8, 0, v8),
		Position = UDim2.new(1, -FrameHeight + v9, 0, v9),
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
		[Roact.Ref] = p8.ref,
		[Roact.Event.InputBegan] = p8.inputBegan,
		[Roact.Event.InputEnded] = p8.inputEnded
	}, t1)
end

local function mapDispatchToProps(p9) -- line: 191
	-- upvalues: SetDevConsolePosition (copy)
	return {
		dispatchSetDevConsolePosition = function(p10) -- line: 193
			-- upvalues: p9 (copy), SetDevConsolePosition (copy)
			p9(SetDevConsolePosition(p10))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(nil, mapDispatchToProps)(v14)
