local CorePackages = game:GetService("CorePackages")
local GameSettings = UserSettings().GameSettings
local FFlagDevConsoleMicroProfilerImproveWording = require(script.Parent.Flags.FFlagDevConsoleMicroProfilerImproveWording)
local v4 = game:DefineFastFlag("DevConsoleMicroProfilerFixAutoTextClear", false)
local getClientReplicator = require(script.Parent.Parent.Parent.Util.getClientReplicator)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local _ = script.Parent.Parent.Parent.Components
local Actions = script.Parent.Parent.Parent.Actions
local SetRCCProfilerState = require(Actions.SetRCCProfilerState)
local Constants = require(script.Parent.Parent.Parent.Constants)
local _ = Constants.GeneralFormatting.MainRowPadding
local ButtonWidth = Constants.MicroProfilerFormatting.ButtonWidth
local ButtonTextSize = Constants.MicroProfilerFormatting.ButtonTextSize
local MainWindow = Constants.Font.MainWindow
local MainWindowHeader = Constants.Font.MainWindowHeader
local UnselectedGray = Constants.Color.UnselectedGray
local SelectedBlue = Constants.Color.SelectedBlue
local UnselectedGray2 = Constants.Color.UnselectedGray
local v20 = Roact.Component:extend("ServerProfilerInteraface")

function v20.init(p1) -- line: 35
	-- upvalues: GameSettings (copy), getClientReplicator (copy)
	function p1.onUtilTabHeightChanged(p2) -- line: 36
		-- upvalues: p1 (copy)
		p1:setState({
			utilTabHeight = p2
		})
	end
	function p1.onFocusLostFrameRate(p3, _, _) -- line: 42
		-- upvalues: GameSettings (copy)
		GameSettings.RCCProfilerRecordFrameRate = p3.Text
		p3.Text = GameSettings.RCCProfilerRecordFrameRate
	end
	function p1.onFocusLostTimeFrame(p6, _, _) -- line: 50
		-- upvalues: GameSettings (copy)
		GameSettings.RCCProfilerRecordTimeFrame = p6.Text
		p6.Text = GameSettings.RCCProfilerRecordTimeFrame
	end
	function p1.requestRCCProfilerData(_) -- line: 58
		-- upvalues: getClientReplicator (copy), GameSettings (copy), p1 (copy)
		local v47 = getClientReplicator()

		if v47 then
			v47:RequestRCCProfilerData(GameSettings.RCCProfilerRecordFrameRate, GameSettings.RCCProfilerRecordTimeFrame)
			p1.props.dispatchSetRCCProfilerState(true)
		end
	end
	function p1.changeProfilerState(p10) -- line: 71
		-- upvalues: GameSettings (copy), p1 (copy)
		return function() -- line: 72
			-- upvalues: GameSettings (copy), p10 (copy), p1 (copy)
			GameSettings.OnScreenProfilerEnabled = p10
			p1:setState({
				clientProfilerEnabled = p10
			})
		end
	end

	p1.state = {
		frameRate = GameSettings.RCCProfilerRecordFrameRate,
		timeFrame = GameSettings.RCCProfilerRecordTimeFrame
	}
end
function v20.render(p11) -- line: 86
	-- upvalues: ButtonWidth (copy), Roact (copy), FFlagDevConsoleMicroProfilerImproveWording (copy), MainWindowHeader (copy), ButtonTextSize (copy), Constants (copy), UnselectedGray2 (copy), MainWindow (copy), v4 (copy), UnselectedGray (copy), SelectedBlue (copy)
	local _ = p11.props.size
	local _ = p11.props.formFactor
	local _ = p11.props.tabList
	local waitingForRecording = p11.props.waitingForRecording
	local lastFileOutputLocation = p11.props.lastFileOutputLocation
	local _ = p11.state.utilTabHeight
	local frameRate = p11.state.frameRate
	local timeFrame = p11.state.timeFrame
	local _ = p11.state.clientProfilerEnabled
	local v34 = not waitingForRecording and #lastFileOutputLocation > 0
	local uDim2 = UDim2.new(0.8, -ButtonWidth, 0, 30)

	UDim2.new(0.6, ButtonWidth, 0, 0)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 4,
		Size = UDim2.new(1, 0, 0, 135)
	}, {
		Label = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, ButtonWidth, 0, 30),
			Position = UDim2.new(0.1, 0, 0, 0),
			Text = not FFlagDevConsoleMicroProfilerImproveWording and "ServerProfiler" or "Server MicroProfiler",
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
		LabelFPS = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, ButtonWidth, 0, 30),
			Position = UDim2.new(0.1, 0, 0, 37.5),
			Text = not FFlagDevConsoleMicroProfilerImproveWording and "Frames Per Second" or "Frames to dump",
			Font = MainWindow,
			TextSize = ButtonTextSize,
			TextColor3 = Constants.Color.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundColor3 = UnselectedGray2
		}),
		FPSTextBox = Roact.createElement("TextBox", {
			Size = uDim2,
			Position = UDim2.new(0.09999999999999998, ButtonWidth, 0, 37.5),
			Text = frameRate,
			Font = MainWindow,
			TextSize = ButtonTextSize,
			TextColor3 = Constants.Color.Text,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundColor3 = UnselectedGray2,
			BackgroundTransparency = 0,
			ClearTextOnFocus = not v4,
			[Roact.Event.FocusLost] = p11.onFocusLostFrameRate
		}),
		LabelTimeFrame = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, ButtonWidth, 0, 30),
			Position = UDim2.new(0.1, 0, 0, 67.5),
			Text = not FFlagDevConsoleMicroProfilerImproveWording and "Seconds to Record" or "Seconds to delay",
			Font = MainWindow,
			TextSize = ButtonTextSize,
			TextColor3 = Constants.Color.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center
		}),
		TimeFrameTextBox = Roact.createElement("TextBox", {
			Size = uDim2,
			Position = UDim2.new(0.09999999999999998, ButtonWidth, 0, 67.5),
			Text = timeFrame,
			Font = MainWindow,
			TextSize = ButtonTextSize,
			TextColor3 = Constants.Color.Text,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundColor3 = UnselectedGray2,
			BackgroundTransparency = 0,
			ClearTextOnFocus = not v4,
			[Roact.Event.FocusLost] = p11.onFocusLostTimeFrame
		}, {
			GetDumpButton = Roact.createElement("TextButton", {
				Size = UDim2.new(0, ButtonWidth * 0.7, 0, 30),
				Position = UDim2.new(1, -ButtonWidth * 0.7, 1, 30),
				Text = not waitingForRecording and "Start Recording" or "Recording",
				Font = MainWindow,
				TextSize = ButtonTextSize,
				TextColor3 = Constants.Color.Text,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				BackgroundColor3 = waitingForRecording and UnselectedGray or SelectedBlue,
				BackgroundTransparency = not waitingForRecording and 0 or 0.3,
				AutoButtonColor = not waitingForRecording,
				Active = not waitingForRecording,
				[Roact.Event.Activated] = p11.requestRCCProfilerData
			})
		}),
		OutputPath = v34 and Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 0, 30),
			Position = UDim2.new(0, 0, 0, 97.5),
			Text = lastFileOutputLocation,
			Font = MainWindow,
			TextSize = ButtonTextSize,
			TextColor3 = Constants.Color.Text,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		})
	})
end

local function mapStateToProps(p12, _) -- line: 215
	return {
		waitingForRecording = p12.MicroProfiler.waitingForRecording,
		lastFileOutputLocation = p12.MicroProfiler.lastFileOutputLocation
	}
end
local function mapDispatchToProps(p14) -- line: 222
	-- upvalues: SetRCCProfilerState (copy)
	return {
		dispatchSetRCCProfilerState = function(p15, p16) -- line: 224
			-- upvalues: p14 (copy), SetRCCProfilerState (copy)
			p14(SetRCCProfilerState(p15, p16))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(v20)
