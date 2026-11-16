local CorePackages = game:GetService("CorePackages")
local gameSettings = UserSettings().GameSettings

local FFlagDevConsoleMicroProfilerImproveWording = require(script.Parent.Flags.FFlagDevConsoleMicroProfilerImproveWording)
local defineFastFlag = game:DefineFastFlag("DevConsoleMicroProfilerFixAutoTextClear", false)

local getClientReplicator = require(script.Parent.Parent.Parent.Util.getClientReplicator)

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local Components = script.Parent.Parent.Parent.Components

local Actions = script.Parent.Parent.Parent.Actions
local SetRCCProfilerState = require(Actions.SetRCCProfilerState)

local Constants = require(script.Parent.Parent.Parent.Constants)
local MainRowPadding = Constants.GeneralFormatting.MainRowPadding
local ButtonWidth = Constants.MicroProfilerFormatting.ButtonWidth
local ButtonTextSize = Constants.MicroProfilerFormatting.ButtonTextSize
local MainWindow = Constants.Font.MainWindow
local MainWindowHeader = Constants.Font.MainWindowHeader
local UnselectedGray = Constants.Color.UnselectedGray
local SelectedBlue = Constants.Color.SelectedBlue

local unselectedGray = Constants.Color.UnselectedGray

local extended = Roact.Component:extend("ServerProfilerInteraface")

function extended:init()
	function self.onUtilTabHeightChanged(utilTabHeight)
		self:setState({ utilTabHeight = utilTabHeight })
	end

	function self:onFocusLostFrameRate(_, _)
		gameSettings.RCCProfilerRecordFrameRate = self.Text

		self.Text = gameSettings.RCCProfilerRecordFrameRate
	end

	function self:onFocusLostTimeFrame(_, _)
		gameSettings.RCCProfilerRecordTimeFrame = self.Text

		self.Text = gameSettings.RCCProfilerRecordTimeFrame
	end

	function self.requestRCCProfilerData(_)
		local clientReplicator = getClientReplicator()

		if clientReplicator then
			clientReplicator:RequestRCCProfilerData(
				gameSettings.RCCProfilerRecordFrameRate,
				gameSettings.RCCProfilerRecordTimeFrame
			)

			self.props.dispatchSetRCCProfilerState(true)
		end
	end

	function self.changeProfilerState(onScreenProfilerEnabled)
		return function()
			gameSettings.OnScreenProfilerEnabled = onScreenProfilerEnabled
			self:setState({ clientProfilerEnabled = onScreenProfilerEnabled })
		end
	end

	self.state = {
		frameRate = gameSettings.RCCProfilerRecordFrameRate,
		timeFrame = gameSettings.RCCProfilerRecordTimeFrame
	}
end

function extended.render(props)
	local _size = props.props.size
	local _formFactor = props.props.formFactor
	local _tabList = props.props.tabList
	local waitingForRecording = props.props.waitingForRecording
	local lastFileOutputLocation = props.props.lastFileOutputLocation

	local _utilTabHeight = props.state.utilTabHeight

	local frameRate = props.state.frameRate
	local timeFrame = props.state.timeFrame
	local _clientProfilerEnabled = props.state.clientProfilerEnabled

	local v = not waitingForRecording and #lastFileOutputLocation > 0

	local udim = UDim2.new(0.8, -ButtonWidth, 0, 30)
	UDim2.new(0.6, ButtonWidth, 0, 0)

	return Roact.createElement(
		"Frame",
		{ Size = UDim2.new(1, 0, 0, 135), BackgroundTransparency = 1, LayoutOrder = 4 },
		{
			Label = Roact.createElement("TextLabel", {
				Size = UDim2.new(0, ButtonWidth, 0, 30),
				Position = UDim2.new(0.1, 0, 0, 0),
				Text = FFlagDevConsoleMicroProfilerImproveWording and "Server MicroProfiler" or "ServerProfiler",
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
			LabelFPS = Roact.createElement("TextLabel", {
				Size = UDim2.new(0, ButtonWidth, 0, 30),
				Position = UDim2.new(0.1, 0, 0, 37.5),
				Text = FFlagDevConsoleMicroProfilerImproveWording and "Frames to dump" or "Frames Per Second",
				Font = MainWindow,
				TextSize = ButtonTextSize,
				TextColor3 = Constants.Color.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				BackgroundColor3 = unselectedGray,
				BackgroundTransparency = 1
			}),
			FPSTextBox = Roact.createElement("TextBox", {
				Size = udim,
				Position = UDim2.new(0.09999999999999998, ButtonWidth, 0, 37.5),
				Text = frameRate,
				Font = MainWindow,
				TextSize = ButtonTextSize,
				TextColor3 = Constants.Color.Text,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				BackgroundColor3 = unselectedGray,
				BackgroundTransparency = 0,
				ClearTextOnFocus = not defineFastFlag,
				[Roact.Event.FocusLost] = props.onFocusLostFrameRate
			}),
			LabelTimeFrame = Roact.createElement("TextLabel", {
				Size = UDim2.new(0, ButtonWidth, 0, 30),
				Position = UDim2.new(0.1, 0, 0, 67.5),
				Text = FFlagDevConsoleMicroProfilerImproveWording and "Seconds to delay" or "Seconds to Record",
				Font = MainWindow,
				TextSize = ButtonTextSize,
				TextColor3 = Constants.Color.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				BackgroundTransparency = 1
			}),
			TimeFrameTextBox = Roact.createElement("TextBox", {
				Size = udim,
				Position = UDim2.new(0.09999999999999998, ButtonWidth, 0, 67.5),
				Text = timeFrame,
				Font = MainWindow,
				TextSize = ButtonTextSize,
				TextColor3 = Constants.Color.Text,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				BackgroundColor3 = unselectedGray,
				BackgroundTransparency = 0,
				ClearTextOnFocus = not defineFastFlag,
				[Roact.Event.FocusLost] = props.onFocusLostTimeFrame
			}, {
				GetDumpButton = Roact.createElement("TextButton", {
					Size = UDim2.new(0, ButtonWidth * 0.7, 0, 30),
					Position = UDim2.new(1, -ButtonWidth * 0.7, 1, 30),
					Text = waitingForRecording and "Recording" or "Start Recording",
					Font = MainWindow,
					TextSize = ButtonTextSize,
					TextColor3 = Constants.Color.Text,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center,
					BackgroundColor3 = waitingForRecording and UnselectedGray or SelectedBlue,
					BackgroundTransparency = waitingForRecording and 0.3 or 0,
					AutoButtonColor = not waitingForRecording,
					Active = not waitingForRecording,
					[Roact.Event.Activated] = props.requestRCCProfilerData
				})
			}),
			OutputPath = v and Roact.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, 30),
				Position = UDim2.new(0, 0, 0, 97.5),
				Text = lastFileOutputLocation,
				Font = MainWindow,
				TextSize = ButtonTextSize,
				TextColor3 = Constants.Color.Text,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center
			})
		}
	)
end

local function mapStateToProps(p, _)
	return {
		waitingForRecording = p.MicroProfiler.waitingForRecording,
		lastFileOutputLocation = p.MicroProfiler.lastFileOutputLocation
	}
end

local function mapDispatchToProps(callback)
	return {
		dispatchSetRCCProfilerState = function(p, p2)
			callback(SetRCCProfilerState(p, p2))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(extended)
