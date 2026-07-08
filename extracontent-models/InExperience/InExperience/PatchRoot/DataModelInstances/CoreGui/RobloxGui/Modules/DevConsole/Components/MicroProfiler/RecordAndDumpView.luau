local CorePackages = game:GetService("CorePackages")
local MicroProfilerService = game:GetService("MicroProfilerService")
local TelemetryService = game:GetService("TelemetryService")
local BoxButton = require(script.Parent.Parent.BoxButton)
local Constants = require(script.Parent.Parent.Parent.Constants)
local MicroProfilerPanel = require(script.Parent.MicroProfilerPanel)
local NumberInput = require(script.Parent.Parent.NumberInput)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local GameSettings = UserSettings().GameSettings
local Actions = script.Parent.Parent.Parent.Actions
local AppendRecentDumpPath = require(Actions.AppendRecentDumpPath)
local SetRCCProfilerState = require(Actions.SetRCCProfilerState)
local getClientReplicator = require(script.Parent.Parent.Parent.Util.getClientReplicator)
local v15 = Roact.Component:extend("RecordAndDumpView")
local t1 = {
	eventName = "DevConsoleMpRecordAndDumpCounter",
	description = "\t\tCounter to track the action of using the Developer Console to record and save MicroProfiler\n\t\tdumps for either the client or server.\n\t",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		2025,
		11,
		24
	}
}

function v15.logRecordAndDumpAction(t2: {[any]: any}, s1: string) -- line: 41
	-- upvalues: TelemetryService (copy), t1 (copy)
	TelemetryService:LogCounter(t1, {
		customFields = {
			context = s1,
			secondsToDelay = t2.state[`{ s1 }SecondsToDelay`],
			framesToRecord = t2.state[`{ s1 }FramesToRecord`]
		}
	}, 1)
end
function v15.numericInputRow(_, p2) -- line: 51
	-- upvalues: Roact (copy), Constants (copy), NumberInput (copy)
	return {
		UIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, 8),
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		UIPadding = Roact.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 4),
			PaddingLeft = UDim.new(0, Constants.MicroProfilerFormatting.OptionTextPadding),
			PaddingRight = UDim.new(0, 4),
			PaddingTop = UDim.new(0, 4)
		}),
		OptionLabel = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Font = Constants.Font.MainWindow,
			Text = p2.Text,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = Constants.MicroProfilerFormatting.OptionTextSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			Position = UDim2.fromOffset(8, 0),
			Size = UDim2.fromScale(0, 1)
		}, {
			UIFlexItem = Roact.createElement("UIFlexItem", {
				FlexMode = Enum.UIFlexMode.Fill
			})
		}),
		NumberInput = Roact.createElement(NumberInput, {
			LayoutOrder = 3,
			Size = UDim2.new(0, 72, 1, 0),
			OnNumberInputChanged = p2.OnNumberInputChanged,
			Range = p2.Range,
			DefaultValue = p2.DefaultValue,
			IntegerOnly = p2.IntegerOnly
		}),
		NumberLimitsHint = Roact.createElement("TextLabel", {
			TextSize = 12,
			TextTransparency = 0.5,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			Font = Constants.Font.Log,
			Text = `({ p2.Range.Min }-{ p2.Range.Max })`,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 32, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Right
		})
	}
end
function v15.recordAndDumpRows(p3, p4) -- line: 104
	-- upvalues: GameSettings (copy), Roact (copy), BoxButton (copy)
	local v25 = p4.Context == "Client"

	return {
		p3:numericInputRow({
			Text = "Number of frames to record",
			IntegerOnly = true,
			Context = p4.Context,
			DefaultValue = if not v25 then p3.state.ServerFramesToRecord else p3.state.ClientFramesToRecord,
			Range = NumberRange.new(1, 60),
			OnNumberInputChanged = function(n1: number) -- line: 114
				-- upvalues: v25 (copy), p3 (copy), GameSettings (copy)
				if v25 then
					p3:setState({
						ClientFramesToRecord = n1
					})

					return
				end

				GameSettings.RCCProfilerRecordFrameRate = n1
				p3:setState({
					ServerFramesToRecord = n1
				})
			end
		}),
		p3:numericInputRow({
			Text = "Seconds to delay",
			IntegerOnly = true,
			Context = p4.Context,
			DefaultValue = if not v25 then p3.state.ServerSecondsToDelay else p3.state.ClientSecondsToDelay,
			Range = NumberRange.new(1, 4),
			OnNumberInputChanged = function(n2: number) -- line: 133
				-- upvalues: v25 (copy), p3 (copy), GameSettings (copy)
				if v25 then
					p3:setState({
						ClientSecondsToDelay = n2
					})

					return
				end

				GameSettings.RCCProfilerRecordTimeFrame = n2
				p3:setState({
					ServerSecondsToDelay = n2
				})
			end
		}),
		{
			UIPadding = Roact.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 2),
				PaddingLeft = UDim.new(0, 2),
				PaddingRight = UDim.new(0, 2),
				PaddingTop = UDim.new(0, 2)
			}),
			Button = Roact.createElement(BoxButton, {
				text = if not v25 then if not p3.props.IsServerRecording then p4.RecordButtonText.Idle else p4.RecordButtonText.Recording else if not p3.state.IsClientRecording then p4.RecordButtonText.Idle else p4.RecordButtonText.Recording,
				size = UDim2.fromScale(1, 1),
				pos = UDim2.new(0, 0, 0, 0),
				onClicked = p4.OnRecordButtonClicked,
				enabled = if not v25 then not p3.props.IsServerRecording else not p3.state.IsClientRecording
			})
		}
	}
end
function v15.init(p5) -- line: 170
	-- upvalues: GameSettings (copy)
	p5.state = {
		IsClientRecording = false,
		ClientFramesToRecord = 32,
		ClientSecondsToDelay = 1,
		ServerFramesToRecord = GameSettings.RCCProfilerRecordFrameRate,
		ServerSecondsToDelay = GameSettings.RCCProfilerRecordTimeFrame
	}
	p5.RecordingTasks = {
		Client = nil
	}
end
function v15.willUnmount(p6) -- line: 187
	if p6.RecordingTasks.Client and coroutine.status(p6.RecordingTasks.Client) ~= "dead" then
		task.cancel(p6.RecordingTasks.Client)
	end
end
function v15.render(p7) -- line: 193
	-- upvalues: Roact (copy), MicroProfilerPanel (copy), MicroProfilerService (copy), getClientReplicator (copy)
	return Roact.createElement(MicroProfilerPanel, {
		Title = "Record and dump",
		LayoutOrder = p7.props.LayoutOrder,
		Sections = {
			{
				Name = "Client",
				Rows = p7:recordAndDumpRows({
					Context = "Client",
					RecordButtonText = {
						Idle = "Begin client recording",
						Recording = "Recording client..."
					},
					OnRecordButtonClicked = function() -- line: 203
						-- upvalues: p7 (copy), MicroProfilerService (copy)
						if p7.state.IsClientRecording then
							return
						end

						p7:logRecordAndDumpAction("Client")
						p7:setState({
							IsClientRecording = true
						})
						p7.RecordingTasks.Client = task.spawn(function() -- line: 211
							-- upvalues: MicroProfilerService (copy), p7 (copy)
							local v38 = MicroProfilerService:DumpToFileAsync(p7.state.ClientSecondsToDelay, p7.state.ClientFramesToRecord)

							p7.props.dispatchAppendRecentDumpPath(v38)
							p7:setState(function(_) -- line: 219
								return {
									IsClientRecording = false
								}
							end)
							p7.RecordingTasks.Client = nil
						end)
					end
				})
			},
			{
				Name = "Server",
				Rows = p7:recordAndDumpRows({
					Context = "Server",
					RecordButtonText = {
						Idle = "Begin server recording",
						Recording = "Recording server..."
					},
					OnRecordButtonClicked = function() -- line: 235
						-- upvalues: p7 (copy), getClientReplicator (copy)
						if p7.props.IsServerRecording then
							return
						end

						local v34 = getClientReplicator()

						if not v34 then
							return
						end

						p7:logRecordAndDumpAction("Server")
						v34:RequestRCCProfilerData(p7.state.ServerFramesToRecord, p7.state.ServerSecondsToDelay)
						p7.props.dispatchSetRCCProfilerState(true)
					end
				})
			}
		}
	})
end

local function mapStateToProps(p9, _) -- line: 260
	return {
		IsServerRecording = p9.MicroProfiler.waitingForRecording
	}
end
local function mapDispatchToProps(p11) -- line: 266
	-- upvalues: AppendRecentDumpPath (copy), SetRCCProfilerState (copy)
	return {
		dispatchAppendRecentDumpPath = function(s2: string) -- line: 268
			-- upvalues: p11 (copy), AppendRecentDumpPath (copy)
			p11(AppendRecentDumpPath(s2))
		end,
		dispatchSetRCCProfilerState = function(b1: boolean, s3: string?) -- line: 271
			-- upvalues: p11 (copy), SetRCCProfilerState (copy)
			p11(SetRCCProfilerState(b1, s3))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v15)
