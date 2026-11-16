local CorePackages = game:GetService("CorePackages")
game:GetService("LogService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local gameSettings = UserSettings().GameSettings

local Roact = require(CorePackages.Packages.Roact)

local Components = script.Parent.Parent.Parent.Components
local UtilAndTab = require(Components.UtilAndTab)
local ServerProfilerInterface = require(script.Parent.ServerProfilerInterface)
local MicroProfilerView = require(script.Parent.MicroProfilerView)

local Constants = require(script.Parent.Parent.Parent.Constants)
local MainRowPadding = Constants.GeneralFormatting.MainRowPadding
local ButtonWidth = Constants.MicroProfilerFormatting.ButtonWidth
local ButtonTextSize = Constants.MicroProfilerFormatting.ButtonTextSize
local MainWindow = Constants.Font.MainWindow
local MainWindowHeader = Constants.Font.MainWindowHeader
local UnselectedGray = Constants.Color.UnselectedGray
local SelectedBlue = Constants.Color.SelectedBlue

local unselectedGray = Constants.Color.UnselectedGray

local FFlagDevConsoleMicroProfilerImproveWording = require(script.Parent.Flags.FFlagDevConsoleMicroProfilerImproveWording)
local defineFastFlag = game:DefineFastFlag("DevConsoleMicroProfilerNewLayout", false)

local extended = Roact.Component:extend("MainViewProfiler")

function extended:init()
	function self.onUtilTabHeightChanged(utilTabHeight)
		self:setState({ utilTabHeight = utilTabHeight })
	end

	function self.changeProfilerState(onScreenProfilerEnabled)
		return function()
			gameSettings.OnScreenProfilerEnabled = onScreenProfilerEnabled
			self:setState({ clientProfilerEnabled = onScreenProfilerEnabled })

			RbxAnalyticsService:ReportCounter("MicroprofilerDevConsolePressed")
		end
	end

	self.microProfilerChangedConnection = gameSettings:GetPropertyChangedSignal("OnScreenProfilerEnabled"):Connect(function()
		self:setState({ clientProfilerEnabled = gameSettings.OnScreenProfilerEnabled })
	end)

	self.utilRef = Roact.createRef()

	self.state = { utilTabHeight = 0 }
end

function extended.didMount(object)
	object:setState({ utilTabHeight = object.utilRef.current.Size.Y.Offset })
end

function extended:willUnmount()
	if self.microProfilerChangedConnection then
		self.microProfilerChangedConnection:Disconnect()
		self.microProfilerChangedConnection = nil
	end
end

function extended.didUpdate(object)
	local size = object.utilRef.current.Size

	if size.Y.Offset ~= object.state.utilTabHeight then
		object:setState({ utilTabHeight = size.Y.Offset })
	end
end

function extended:renderNewLayout()
	local size = self.props.size
	local formFactor = self.props.formFactor
	local tabList = self.props.tabList
	local utilTabHeight = self.state.utilTabHeight

	return Roact.createElement(
		"Frame",
		{
			Size = size,
			BackgroundColor3 = Constants.Color.BaseGray,
			BackgroundTransparency = 1,
			LayoutOrder = 3
		},
		{
			UIListLayout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, MainRowPadding),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			UtilAndTab = Roact.createElement(UtilAndTab, {
				windowWidth = size.X.Offset,
				formFactor = formFactor,
				tabList = tabList,
				layoutOrder = 1,
				refForParent = self.utilRef,
				onHeightChanged = self.onUtilTabHeightChanged
			}),
			MicroProfilerView = Roact.createElement(MicroProfilerView, {
				Size = UDim2.new(1, 0, 1, -utilTabHeight),
				BackgroundTransparency = 1,
				LayoutOrder = 2
			})
		}
	)
end

function extended:render()
	if defineFastFlag then
		return self:renderNewLayout()
	end

	local size = self.props.size
	local formFactor = self.props.formFactor
	local tabList = self.props.tabList

	local utilTabHeight = self.state.utilTabHeight

	local _frameRate = self.state.frameRate
	local _timeFrame = self.state.timeFrame
	local _waitingForData = self.state.waitingForData
	local clientProfilerEnabled = self.state.clientProfilerEnabled
	local _outputPath = self.state.outputPath

	UDim2.new(0.8, -ButtonWidth, 0, 30)
	UDim2.new(0.6, ButtonWidth, 0, 0)

	return Roact.createElement(
		"Frame",
		{
			Size = size,
			BackgroundColor3 = Constants.Color.BaseGray,
			BackgroundTransparency = 1,
			LayoutOrder = 3
		},
		{
			UIListLayout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, MainRowPadding),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			UtilAndTab = Roact.createElement(UtilAndTab, {
				windowWidth = size.X.Offset,
				formFactor = formFactor,
				tabList = tabList,
				layoutOrder = 1,
				refForParent = self.utilRef,
				onHeightChanged = self.onUtilTabHeightChanged
			}),
			MainFrame = Roact.createElement("ScrollingFrame", {
				Size = UDim2.new(1, 0, 1, -utilTabHeight),
				CanvasSize = UDim2.new(1, 0, 1, -utilTabHeight),
				BackgroundTransparency = 1,
				LayoutOrder = 2
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					Padding = UDim.new(0, MainRowPadding * 2),
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				MicroProfilerRow = Roact.createElement(
					"Frame",
					{ Size = UDim2.new(1, 0, 0, 90), BackgroundTransparency = 1, LayoutOrder = 2 },
					{
						Label = Roact.createElement("TextLabel", {
							Size = UDim2.new(0, ButtonWidth, 0, 30),
							Position = UDim2.new(0.1, 0, 0, 0),
							Text = FFlagDevConsoleMicroProfilerImproveWording and "Client MicroProfiler" or "MicroProfiler",
							Font = MainWindowHeader,
							TextSize = ButtonTextSize,
							TextColor3 = Constants.Color.Text,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Center,
							BackgroundColor3 = unselectedGray,
							BackgroundTransparency = 1
						}),
						HorizontalLine = Roact.createElement("Frame", {
							Size = UDim2.new(1, 0, 0, 1),
							Position = UDim2.new(0, 0, 0, 30)
						}),
						ToggleButton = Roact.createElement("TextLabel", {
							Size = UDim2.new(0.8, -ButtonWidth, 0, 30),
							Position = UDim2.new(0.09999999999999998, ButtonWidth, 0, 37.5),
							BackgroundTransparency = 1
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
								[Roact.Event.Activated] = self.changeProfilerState(false)
							}),
							ClientButton = Roact.createElement("TextButton", {
								Size = UDim2.new(0.5, 0, 1, 0),
								Position = UDim2.new(0.5, 0, 0, 0),
								Text = FFlagDevConsoleMicroProfilerImproveWording and "On" or "Client",
								Font = MainWindowHeader,
								TextSize = ButtonTextSize,
								TextColor3 = Constants.Color.Text,
								TextXAlignment = Enum.TextXAlignment.Center,
								TextYAlignment = Enum.TextYAlignment.Center,
								BackgroundColor3 = clientProfilerEnabled and SelectedBlue or UnselectedGray,
								[Roact.Event.Activated] = self.changeProfilerState(true)
							})
						})
					}
				),
				HorizontalLine = Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, MainRowPadding),
					BackgroundTransparency = 1,
					LayoutOrder = 3
				}),
				ServerProfiler = Roact.createElement(ServerProfilerInterface, {
					Size = UDim2.new(1, 0, 0, 135),
					BackgroundTransparency = 1,
					LayoutOrder = 4
				})
			})
		}
	)
end

return extended
