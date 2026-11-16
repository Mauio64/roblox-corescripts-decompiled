local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui.RobloxGui
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local setMouseVisibility = require(script.Parent.Parent.Util.setMouseVisibility)

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local parent = script.Parent.Parent

local Constants = require(parent.Constants)
local FrameHeight = Constants.TopBarFormatting.FrameHeight
local WindowPadding = Constants.Padding.WindowPadding
local MinSize = Constants.MainWindowInit.MinSize

local components = parent.Components
local DevConsoleTopBar = require(components.DevConsoleTopBar)

local Actions = script.Parent.Parent.Actions
local ChangeDevConsoleSize = require(Actions.ChangeDevConsoleSize)
local SetDevConsoleVisibility = require(Actions.SetDevConsoleVisibility)
local SetDevConsoleMinimized = require(Actions.SetDevConsoleMinimized)

local extended = Roact.PureComponent:extend("DevConsoleWindow")

function extended:onMinimizeClicked()
	self.props.dispatchSetDevConsoleMinimized(true)
end

function extended:onMaximizeClicked()
	self.props.dispatchSetDevConsoleMinimized(false)
end

function extended:onCloseClicked()
	self.props.onCloseCallback(false)
	self.props.dispatchSetDevConsolVisibility(false)
end

function extended:init()
	function self:setDevConsoleSize(p, p2)
		local v = p2.X - p.X
		local v2 = p2.Y - p.Y

		v = v < MinSize.X and MinSize.X or v
		v2 = v2 < MinSize.Y and MinSize.Y or v2

		self.props.dispatchChangeDevConsoleSize(UDim2.new(0, v, 0, v2))
	end

	function self.resizeInputBegan(_, p)
		if p.UserInputType == Enum.UserInputType.MouseButton1 then
			local inputChangedConnection = nil
			local inputEndedConnection = nil

			local function onInputChanged(p2)
				self:setDevConsoleSize(self.ref.current.AbsolutePosition, p2.Position)
			end

			local function onInputEnded(p2)
				if p2.UserInputType == Enum.UserInputType.MouseButton1 then
					inputChangedConnection:Disconnect()
					inputEndedConnection:Disconnect()
				end
			end

			inputChangedConnection = UserInputService.InputChanged:Connect(onInputChanged)
			inputEndedConnection = UserInputService.InputEnded:Connect(onInputEnded)
		end
	end

	function self.doGamepadMenuButton(p)
		if self.props.isVisible and (p.KeyCode == Enum.KeyCode.ButtonStart or p.KeyCode == Enum.KeyCode.Escape) then
			self.props.dispatchSetDevConsolVisibility(false)
		end
	end

	self.ref = Roact.createRef()

	self.state = { resizing = false }
end

function extended:didMount()
	delay(0, function()
		if self.ref.current then
			self:setDevConsoleSize(self.ref.current.AbsolutePosition, self.ref.current.ResizeButton.AbsolutePosition)
		end
	end)
	setMouseVisibility(self.props.isVisible)

	self.gamepadMenuListener = UserInputService.InputBegan:Connect(self.doGamepadMenuButton)
end

function extended.willUnmount(p)
	if GuiService.SelectedCoreObject == p.ref.current then
		GuiService.SelectedCoreObject = nil
	end

	p.gamepadMenuListener:Disconnect()
end

function extended.didUpdate(p, p2, _)
	setMouseVisibility(p.props.isVisible)

	if p.props.isMinimized and GuiService.SelectedCoreObject == p.ref.current then
		GuiService.SelectedCoreObject = nil
	elseif p.props.isVisible ~= p2.isVisible or p.props.currTabIndex ~= p2.currTabIndex then
		local lastInputType = UserInputService:GetLastInputType()

		if Enum.UserInputType.Gamepad1 == lastInputType and p.props.isVisible then
			GuiService.SelectedCoreObject = p.ref.current
		else
			GuiService.SelectedCoreObject = nil
		end
	end
end

function extended:render()
	local isVisible = self.props.isVisible
	local formFactor = self.props.formFactor
	local isDeveloperView = self.props.isDeveloperView
	local currTabIndex = self.props.currTabIndex
	local tabList = self.props.tabList

	local isMinimized = self.props.isMinimized
	local position = self.props.position
	local size = self.props.size

	local _resizing = self.state.resizing

	local udim = UDim2.new()

	local children = {}
	local size2, borderSizePixel

	if formFactor == Constants.FormFactor.Large then
		size2 = size
		borderSizePixel = 16
	else
		local absoluteSize = RobloxGui.AbsoluteSize
		size = UDim2.new(0, absoluteSize.X, 0, absoluteSize.Y)
		position = UDim2.new(0, 0, 0, 0)

		udim = UDim2.new(0, 16, 0, 0)
		size2 = size + UDim2.new(0, -32, 0, 0)
		borderSizePixel = 0
	end

	children.UIListLayout = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Padding = UDim.new(0, WindowPadding)
	})

	if isMinimized then
		children.TopBar = Roact.createElement(DevConsoleTopBar, {
			LayoutOrder = 1,
			formFactor = formFactor,
			isMinimized = true,
			onMinimizeClicked = function()
				self:onMinimizeClicked()
			end,
			onMaximizeClicked = function()
				self:onMaximizeClicked()
			end,
			onCloseClicked = function()
				self:onCloseClicked()
			end
		})

		return Roact.createElement("Frame", {
			Position = UDim2.new(1, -500, 1, -2 * FrameHeight),
			Size = UDim2.new(0, 500, 0, 2 * FrameHeight),
			BackgroundColor3 = Color3.new(0, 0, 0),
			Transparency = Constants.MainWindowInit.Transparency,
			Active = true,
			AutoLocalize = false,
			Visible = isVisible,
			Selectable = true,
			BorderColor3 = Constants.Color.BaseGray,
			[Roact.Ref] = self.ref
		}, children)
	else
		children.TopBar = Roact.createElement(DevConsoleTopBar, {
			LayoutOrder = 1,
			formFactor = formFactor,
			isMinimized = false,
			onMinimizeClicked = function()
				self:onMinimizeClicked()
			end,
			onMaximizeClicked = function()
				self:onMaximizeClicked()
			end,
			onCloseClicked = function()
				self:onCloseClicked()
			end
		})

		local v = FrameHeight + 2 * WindowPadding
		local size3 = size2 - UDim2.new(0, 0, 0, v)

		local v2 = self.ref.current and isVisible and tabList and tabList[currTabIndex]

		if v2 then
			children.MainView = Roact.createElement(v2.tab, {
				size = size3,
				formFactor = formFactor,
				isDeveloperView = isDeveloperView,
				tabList = tabList
			})
		end

		return Roact.createElement("Frame", {
			Position = position,
			Size = size,
			Visible = isVisible,
			BackgroundColor3 = Color3.new(0, 0, 0),
			Transparency = Constants.MainWindowInit.Transparency,
			BorderColor3 = Constants.Color.BaseGray,
			BorderSizePixel = borderSizePixel,
			Active = true,
			AutoLocalize = false,
			Selectable = false,
			[Roact.Ref] = self.ref
		}, {
			DevConsoleUI = Roact.createElement(
				"Frame",
				{ Size = size2, Position = udim, BackgroundTransparency = 1 },
				children
			),
			ResizeButton = Roact.createElement("ImageButton", {
				Position = UDim2.new(1, 0, 1, 0),
				Size = UDim2.new(0, borderSizePixel, 0, borderSizePixel),
				BackgroundColor3 = Color3.new(0, 0, 0),
				Modal = true,
				[Roact.Event.InputBegan] = self.resizeInputBegan
			})
		})
	end
end

local function mapStateToProps(p, _)
	return {
		isVisible = p.DisplayOptions.isVisible,
		isMinimized = p.DisplayOptions.isMinimized,
		position = p.DisplayOptions.position,
		size = p.DisplayOptions.size,
		isDeveloperView = p.MainView.isDeveloperView,
		currTabIndex = p.MainView.currTabIndex,
		tabList = p.MainView.tabList
	}
end

local function mapDispatchToProps(callback)
	return {
		dispatchChangeDevConsoleSize = function(p)
			callback(ChangeDevConsoleSize(p))
		end,
		dispatchSetDevConsolVisibility = function(p)
			callback(SetDevConsoleVisibility(p))
		end,
		dispatchSetDevConsoleMinimized = function(p)
			callback(SetDevConsoleMinimized(p))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(extended)
