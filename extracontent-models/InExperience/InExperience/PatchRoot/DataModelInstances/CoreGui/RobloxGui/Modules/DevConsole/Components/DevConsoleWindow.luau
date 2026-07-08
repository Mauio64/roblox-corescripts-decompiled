local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui").RobloxGui
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local setMouseVisibility = require(script.Parent.Parent.Util.setMouseVisibility)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)
local FrameHeight = Constants.TopBarFormatting.FrameHeight
local WindowPadding = Constants.Padding.WindowPadding
local MinSize = Constants.MainWindowInit.MinSize
local Components = ParentParent.Components
local DevConsoleTopBar = require(Components.DevConsoleTopBar)
local Actions = script.Parent.Parent.Actions
local ChangeDevConsoleSize = require(Actions.ChangeDevConsoleSize)
local SetDevConsoleVisibility = require(Actions.SetDevConsoleVisibility)
local SetDevConsoleMinimized = require(Actions.SetDevConsoleMinimized)
local v19 = Roact.PureComponent:extend("DevConsoleWindow")

function v19.onMinimizeClicked(p1) -- line: 30
	p1.props.dispatchSetDevConsoleMinimized(true)
end
function v19.onMaximizeClicked(p2) -- line: 34
	p2.props.dispatchSetDevConsoleMinimized(false)
end
function v19.onCloseClicked(p3) -- line: 38
	p3.props.onCloseCallback(false)
	p3.props.dispatchSetDevConsolVisibility(false)
end
function v19.init(p4) -- line: 43
	-- upvalues: MinSize (copy), UserInputService (copy), Roact (copy)
	function p4.setDevConsoleSize(p5, p6, p7) -- line: 44
		-- upvalues: MinSize (copy)
		local v55 = p7.X - p6.X
		local v56 = p7.Y - p6.Y
		local v57 = v55 < MinSize.X and MinSize.X or v55
		local v58 = v56 < MinSize.Y and MinSize.Y or v56

		p5.props.dispatchChangeDevConsoleSize(UDim2.new(0, v57, 0, v58))
	end
	function p4.resizeInputBegan(_, p9) -- line: 54
		-- upvalues: p4 (copy), UserInputService (copy)
		if p9.UserInputType == Enum.UserInputType.MouseButton1 then
			local connection = nil
			local connection2 = nil

			local function onInputChanged(p10) -- line: 58
				-- upvalues: p4 (copy)
				local AbsolutePosition = p4.ref.current.AbsolutePosition
				local p10Position = p10.Position

				p4:setDevConsoleSize(AbsolutePosition, p10Position)
			end
			local function onInputEnded(p11) -- line: 64
				-- upvalues: connection (ref), connection2 (ref)
				if p11.UserInputType == Enum.UserInputType.MouseButton1 then
					connection:Disconnect()
					connection2:Disconnect()
				end
			end

			connection = UserInputService.InputChanged:Connect(onInputChanged)
			connection2 = UserInputService.InputEnded:Connect(onInputEnded)
		end
	end
	function p4.doGamepadMenuButton(p12) -- line: 76
		-- upvalues: p4 (copy)
		if p4.props.isVisible and (p12.KeyCode == Enum.KeyCode.ButtonStart or p12.KeyCode == Enum.KeyCode.Escape) then
			p4.props.dispatchSetDevConsolVisibility(false)
		end
	end

	p4.ref = Roact.createRef()
	p4.state = {
		resizing = false
	}
end
function v19.didMount(p13) -- line: 92
	-- upvalues: setMouseVisibility (copy), UserInputService (copy)
	delay(0, function() -- line: 96
		-- upvalues: p13 (copy)
		if p13.ref.current then
			local AbsolutePosition = p13.ref.current.AbsolutePosition
			local AbsolutePosition2 = p13.ref.current.ResizeButton.AbsolutePosition

			p13:setDevConsoleSize(AbsolutePosition, AbsolutePosition2)
		end
	end)
	setMouseVisibility(p13.props.isVisible)
	p13.gamepadMenuListener = UserInputService.InputBegan:Connect(p13.doGamepadMenuButton)
end
function v19.willUnmount(p14) -- line: 108
	-- upvalues: GuiService (copy)
	if GuiService.SelectedCoreObject == p14.ref.current then
		GuiService.SelectedCoreObject = nil
	end

	p14.gamepadMenuListener:Disconnect()
end
function v19.didUpdate(p15, p16, _) -- line: 116
	-- upvalues: setMouseVisibility (copy), GuiService (copy), UserInputService (copy)
	setMouseVisibility(p15.props.isVisible)

	if p15.props.isMinimized and GuiService.SelectedCoreObject == p15.ref.current then
		GuiService.SelectedCoreObject = nil

		return
	end

	if p15.props.isVisible ~= p16.isVisible or p15.props.currTabIndex ~= p16.currTabIndex then
		if UserInputService:GetLastInputType() == Enum.UserInputType.Gamepad1 and p15.props.isVisible then
			GuiService.SelectedCoreObject = p15.ref.current

			return
		end

		GuiService.SelectedCoreObject = nil
	end
end
function v19.render(p18) -- line: 133
	-- upvalues: Constants (copy), RobloxGui (copy), Roact (copy), WindowPadding (copy), DevConsoleTopBar (copy), FrameHeight (copy)
	local isVisible = p18.props.isVisible
	local formFactor = p18.props.formFactor
	local isDeveloperView = p18.props.isDeveloperView
	local currTabIndex = p18.props.currTabIndex
	local tabList = p18.props.tabList
	local isMinimized = p18.props.isMinimized
	local position = p18.props.position
	local size = p18.props.size
	local _ = p18.state.resizing
	local v41 = size
	local uDim2 = UDim2.new()
	local t1 = {}
	local n1 = 16

	if formFactor ~= Constants.FormFactor.Large then
		local AbsoluteSize = RobloxGui.AbsoluteSize

		size = UDim2.new(0, AbsoluteSize.X, 0, AbsoluteSize.Y)
		position = UDim2.new(0, 0, 0, 0)
		uDim2 = UDim2.new(0, 16, 0, 0)
		v41 = size + UDim2.new(0, -32, 0, 0)
		n1 = 0
	end

	t1.UIListLayout = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Padding = UDim.new(0, WindowPadding)
	})

	if isMinimized then
		t1.TopBar = Roact.createElement(DevConsoleTopBar, {
			LayoutOrder = 1,
			isMinimized = true,
			formFactor = formFactor,
			onMinimizeClicked = function() -- line: 176
				-- upvalues: p18 (copy)
				p18:onMinimizeClicked()
			end,
			onMaximizeClicked = function() -- line: 179
				-- upvalues: p18 (copy)
				p18:onMaximizeClicked()
			end,
			onCloseClicked = function() -- line: 182
				-- upvalues: p18 (copy)
				p18:onCloseClicked()
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
			[Roact.Ref] = p18.ref
		}, t1)
	end

	t1.TopBar = Roact.createElement(DevConsoleTopBar, {
		LayoutOrder = 1,
		isMinimized = false,
		formFactor = formFactor,
		onMinimizeClicked = function() -- line: 205
			-- upvalues: p18 (copy)
			p18:onMinimizeClicked()
		end,
		onMaximizeClicked = function() -- line: 208
			-- upvalues: p18 (copy)
			p18:onMaximizeClicked()
		end,
		onCloseClicked = function() -- line: 211
			-- upvalues: p18 (copy)
			p18:onCloseClicked()
		end
	})

	local v46 = FrameHeight + 2 * WindowPadding
	local v47 = v41 - UDim2.new(0, 0, 0, v46)

	if p18.ref.current and isVisible and tabList then
		local v48 = tabList[currTabIndex]

		if v48 then
			t1.MainView = Roact.createElement(v48.tab, {
				size = v47,
				formFactor = formFactor,
				isDeveloperView = isDeveloperView,
				tabList = tabList
			})
		end
	end

	return Roact.createElement("Frame", {
		Position = position,
		Size = size,
		Visible = isVisible,
		BackgroundColor3 = Color3.new(0, 0, 0),
		Transparency = Constants.MainWindowInit.Transparency,
		BorderColor3 = Constants.Color.BaseGray,
		BorderSizePixel = n1,
		Active = true,
		AutoLocalize = false,
		Selectable = false,
		[Roact.Ref] = p18.ref
	}, {
		DevConsoleUI = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = v41,
			Position = uDim2
		}, t1),
		ResizeButton = Roact.createElement("ImageButton", {
			Position = UDim2.new(1, 0, 1, 0),
			Size = UDim2.new(0, n1, 0, n1),
			BackgroundColor3 = Color3.new(0, 0, 0),
			Modal = true,
			[Roact.Event.InputBegan] = p18.resizeInputBegan
		})
	})
end

local function mapStateToProps(p19, _) -- line: 266
	return {
		isVisible = p19.DisplayOptions.isVisible,
		isMinimized = p19.DisplayOptions.isMinimized,
		position = p19.DisplayOptions.position,
		size = p19.DisplayOptions.size,
		isDeveloperView = p19.MainView.isDeveloperView,
		currTabIndex = p19.MainView.currTabIndex,
		tabList = p19.MainView.tabList
	}
end
local function mapDispatchToProps(p21) -- line: 278
	-- upvalues: ChangeDevConsoleSize (copy), SetDevConsoleVisibility (copy), SetDevConsoleMinimized (copy)
	return {
		dispatchChangeDevConsoleSize = function(p22) -- line: 280
			-- upvalues: p21 (copy), ChangeDevConsoleSize (copy)
			p21(ChangeDevConsoleSize(p22))
		end,
		dispatchSetDevConsolVisibility = function(p23) -- line: 283
			-- upvalues: p21 (copy), SetDevConsoleVisibility (copy)
			p21(SetDevConsoleVisibility(p23))
		end,
		dispatchSetDevConsoleMinimized = function(p24) -- line: 286
			-- upvalues: p21 (copy), SetDevConsoleMinimized (copy)
			p21(SetDevConsoleMinimized(p24))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(v19)
