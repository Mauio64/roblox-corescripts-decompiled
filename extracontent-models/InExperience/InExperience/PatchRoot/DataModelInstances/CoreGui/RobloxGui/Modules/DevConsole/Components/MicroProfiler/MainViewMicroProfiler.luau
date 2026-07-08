local CorePackages = game:GetService("CorePackages")

game:GetService("LogService")

local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local GameSettings = UserSettings().GameSettings
local Roact = require(CorePackages.Packages.Roact)
local Components = script.Parent.Parent.Parent.Components
local UtilAndTab = require(Components.UtilAndTab)
local ServerProfilerInterface = require(script.Parent.ServerProfilerInterface)
local MicroProfilerView = require(script.Parent.MicroProfilerView)
local Constants = require(script.Parent.Parent.Parent.Constants)
local MainRowPadding = Constants.GeneralFormatting.MainRowPadding
local ButtonWidth = Constants.MicroProfilerFormatting.ButtonWidth
local ButtonTextSize = Constants.MicroProfilerFormatting.ButtonTextSize
local _ = Constants.Font.MainWindow
local MainWindowHeader = Constants.Font.MainWindowHeader
local UnselectedGray = Constants.Color.UnselectedGray
local SelectedBlue = Constants.Color.SelectedBlue
local UnselectedGray2 = Constants.Color.UnselectedGray
local FFlagDevConsoleMicroProfilerImproveWording = require(script.Parent.Flags.FFlagDevConsoleMicroProfilerImproveWording)
local v19 = game:DefineFastFlag("DevConsoleMicroProfilerNewLayout", false)
local v20 = Roact.Component:extend("MainViewProfiler")

function v20.init(p1) -- line: 35
	-- upvalues: GameSettings (copy), RbxAnalyticsService (copy), Roact (copy)
	function p1.onUtilTabHeightChanged(p2) -- line: 36
		-- upvalues: p1 (copy)
		p1:setState({
			utilTabHeight = p2
		})
	end
	function p1.changeProfilerState(p3) -- line: 42
		-- upvalues: GameSettings (copy), p1 (copy), RbxAnalyticsService (copy)
		return function() -- line: 43
			-- upvalues: GameSettings (copy), p3 (copy), p1 (copy), RbxAnalyticsService (copy)
			GameSettings.OnScreenProfilerEnabled = p3
			p1:setState({
				clientProfilerEnabled = p3
			})
			RbxAnalyticsService:ReportCounter("MicroprofilerDevConsolePressed")
		end
	end

	p1.microProfilerChangedConnection = GameSettings:GetPropertyChangedSignal("OnScreenProfilerEnabled"):Connect(function() -- line: 54
		-- upvalues: p1 (copy), GameSettings (copy)
		p1:setState({
			clientProfilerEnabled = GameSettings.OnScreenProfilerEnabled
		})
	end)
	p1.utilRef = Roact.createRef()
	p1.state = {
		utilTabHeight = 0
	}
end
function v20.didMount(p4) -- line: 67
	p4:setState({
		utilTabHeight = p4.utilRef.current.Size.Y.Offset
	})
end
function v20.willUnmount(p5) -- line: 75
	if p5.microProfilerChangedConnection then
		p5.microProfilerChangedConnection:Disconnect()
		p5.microProfilerChangedConnection = nil
	end
end
function v20.didUpdate(p6) -- line: 82
	local currentSize = p6.utilRef.current.Size

	if currentSize.Y.Offset ~= p6.state.utilTabHeight then
		p6:setState({
			utilTabHeight = currentSize.Y.Offset
		})
	end
end
function v20.renderNewLayout(p7) -- line: 91
	-- upvalues: Roact (copy), Constants (copy), MainRowPadding (copy), UtilAndTab (copy), MicroProfilerView (copy)
	local size = p7.props.size
	local formFactor = p7.props.formFactor
	local tabList = p7.props.tabList
	local utilTabHeight = p7.state.utilTabHeight

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 3,
		Size = size,
		BackgroundColor3 = Constants.Color.BaseGray
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, MainRowPadding),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		UtilAndTab = Roact.createElement(UtilAndTab, {
			layoutOrder = 1,
			windowWidth = size.X.Offset,
			formFactor = formFactor,
			tabList = tabList,
			refForParent = p7.utilRef,
			onHeightChanged = p7.onUtilTabHeightChanged
		}),
		MicroProfilerView = Roact.createElement(MicroProfilerView, {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 1, -utilTabHeight)
		})
	})
end
function v20.render(p8) -- line: 123
	-- upvalues: v19 (copy), ButtonWidth (copy), Roact (copy), Constants (copy), MainRowPadding (copy), UtilAndTab (copy), FFlagDevConsoleMicroProfilerImproveWording (copy), MainWindowHeader (copy), ButtonTextSize (copy), UnselectedGray2 (copy), UnselectedGray (copy), SelectedBlue (copy), ServerProfilerInterface (copy)
	if v19 then
		return p8:renderNewLayout()
	end

	local size = p8.props.size
	local formFactor = p8.props.formFactor
	local tabList = p8.props.tabList
	local utilTabHeight = p8.state.utilTabHeight
	local _ = p8.state.frameRate
	local _ = p8.state.timeFrame
	local _ = p8.state.waitingForData
	local clientProfilerEnabled = p8.state.clientProfilerEnabled
	local _ = p8.state.outputPath

	UDim2.new(0.8, -ButtonWidth, 0, 30)
	UDim2.new(0.6, ButtonWidth, 0, 0)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 3,
		Size = size,
		BackgroundColor3 = Constants.Color.BaseGray
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, MainRowPadding),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		UtilAndTab = Roact.createElement(UtilAndTab, {
			layoutOrder = 1,
			windowWidth = size.X.Offset,
			formFactor = formFactor,
			tabList = tabList,
			refForParent = p8.utilRef,
			onHeightChanged = p8.onUtilTabHeightChanged
		}),
		MainFrame = Roact.createElement("ScrollingFrame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 1, -utilTabHeight),
			CanvasSize = UDim2.new(1, 0, 1, -utilTabHeight)
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, MainRowPadding * 2),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			MicroProfilerRow = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 90)
			}, {
				Label = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, ButtonWidth, 0, 30),
					Position = UDim2.new(0.1, 0, 0, 0),
					Text = not FFlagDevConsoleMicroProfilerImproveWording and "MicroProfiler" or "Client MicroProfiler",
					Font = MainWindowHeader,
					TextSize = ButtonTextSize,
					TextColor3 = Constants.Color.Text,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					BackgroundColor3 = UnselectedGray2
				}),
				HorizontalLine = Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 0, 30)
				}),
				ToggleButton = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.new(0.8, -ButtonWidth, 0, 30),
					Position = UDim2.new(0.09999999999999998, ButtonWidth, 0, 37.5)
				}, {
					OffButton = Roact.createElement("TextButton", {
						Size = UDim2.new(0.5, 0, 1, 0),
						Text = "Off",
						Font = MainWindowHeader,
						TextSize = ButtonTextSize,
						TextColor3 = Constants.Color.Text,
						TextXAlignment = Enum.TextXAlignment.Center,
						TextYAlignment = Enum.TextYAlignment.Center,
						BackgroundColor3 = clientProfilerEnabled and UnselectedGray or SelectedBlue,
						[Roact.Event.Activated] = p8.changeProfilerState(false)
					}),
					ClientButton = Roact.createElement("TextButton", {
						Size = UDim2.new(0.5, 0, 1, 0),
						Position = UDim2.new(0.5, 0, 0, 0),
						Text = not FFlagDevConsoleMicroProfilerImproveWording and "Client" or "On",
						Font = MainWindowHeader,
						TextSize = ButtonTextSize,
						TextColor3 = Constants.Color.Text,
						TextXAlignment = Enum.TextXAlignment.Center,
						TextYAlignment = Enum.TextYAlignment.Center,
						BackgroundColor3 = clientProfilerEnabled and SelectedBlue or UnselectedGray,
						[Roact.Event.Activated] = p8.changeProfilerState(true)
					})
				})
			}),
			HorizontalLine = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, MainRowPadding)
			}),
			ServerProfiler = Roact.createElement(ServerProfilerInterface, {
				BackgroundTransparency = 1,
				LayoutOrder = 4,
				Size = UDim2.new(1, 0, 0, 135)
			})
		})
	})
end

return v20
