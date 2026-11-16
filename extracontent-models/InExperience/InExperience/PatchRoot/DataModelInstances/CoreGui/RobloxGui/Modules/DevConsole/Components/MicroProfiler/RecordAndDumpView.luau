local CorePackages = game:GetService("CorePackages")
local MicroProfilerService = game:GetService("MicroProfilerService")
local TelemetryService = game:GetService("TelemetryService")

local BoxButton = require(script.Parent.Parent.BoxButton)
local Constants = require(script.Parent.Parent.Parent.Constants)
local MicroProfilerPanel = require(script.Parent.MicroProfilerPanel)
local NumberInput = require(script.Parent.Parent.NumberInput)

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local gameSettings = UserSettings().GameSettings

local Actions = script.Parent.Parent.Parent.Actions
local AppendRecentDumpPath = require(Actions.AppendRecentDumpPath)
local SetRCCProfilerState = require(Actions.SetRCCProfilerState)

local getClientReplicator = require(script.Parent.Parent.Parent.Util.getClientReplicator)

local extended = Roact.Component:extend("RecordAndDumpView")

local v = {
	eventName = "DevConsoleMpRecordAndDumpCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 2025, 11, 24 },
	description = [[
		Counter to track the action of using the Developer Console to record and save MicroProfiler
		dumps for either the client or server.
	]]
}

function extended:logRecordAndDumpAction(context: string)
	TelemetryService:LogCounter(v, {
		customFields = {
			context = context,
			secondsToDelay = self.state[`{context}SecondsToDelay`],
			framesToRecord = self.state[`{context}FramesToRecord`]
		}
	}, 1)
end

function extended:numericInputRow(props)
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
			Font = Constants.Font.MainWindow,
			Text = props.Text,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = Constants.MicroProfilerFormatting.OptionTextSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Position = UDim2.fromOffset(8, 0),
			Size = UDim2.fromScale(0, 1)
		}, {
			UIFlexItem = Roact.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill })
		}),
		NumberInput = Roact.createElement(NumberInput, {
			Size = UDim2.new(0, 72, 1, 0),
			LayoutOrder = 3,
			OnNumberInputChanged = props.OnNumberInputChanged,
			Range = props.Range,
			DefaultValue = props.DefaultValue,
			IntegerOnly = props.IntegerOnly
		}),
		NumberLimitsHint = Roact.createElement("TextLabel", {
			Font = Constants.Font.Log,
			Text = `({props.Range.Min}-{props.Range.Max})`,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 12,
			TextTransparency = 0.5,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			LayoutOrder = 2,
			Size = UDim2.new(0, 32, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Right
		})
	}
end

function extended:recordAndDumpRows(props)
	local v2 = props.Context == "Client"

	local v3 = {
		Context = props.Context,
		Text = "Number of frames to record",
		DefaultValue = 0,
		Range = 0,
		IntegerOnly = true,
		OnNumberInputChanged = 0
	}
	local defaultValue

	if v2 then
		defaultValue = self.state.ClientFramesToRecord
	else
		defaultValue = self.state.ServerFramesToRecord
	end

	v3.DefaultValue = defaultValue
	v3.Range = NumberRange.new(1, 60)

	function v3.OnNumberInputChanged(rccProfilerRecordFrameRate: number)
		if v2 then
			self:setState({ ClientFramesToRecord = rccProfilerRecordFrameRate })
			return
		end

		gameSettings.RCCProfilerRecordFrameRate = rccProfilerRecordFrameRate
		self:setState({ ServerFramesToRecord = rccProfilerRecordFrameRate })
	end

	local numericInputRow = self:numericInputRow(v3)

	local v4 = {
		Context = props.Context,
		Text = "Seconds to delay",
		DefaultValue = 0,
		Range = 0,
		IntegerOnly = true,
		OnNumberInputChanged = 0
	}
	local defaultValue2

	if v2 then
		defaultValue2 = self.state.ClientSecondsToDelay
	else
		defaultValue2 = self.state.ServerSecondsToDelay
	end

	v4.DefaultValue = defaultValue2
	v4.Range = NumberRange.new(1, 4)

	function v4.OnNumberInputChanged(rccProfilerRecordTimeFrame: number)
		if v2 then
			self:setState({ ClientSecondsToDelay = rccProfilerRecordTimeFrame })
			return
		end

		gameSettings.RCCProfilerRecordTimeFrame = rccProfilerRecordTimeFrame
		self:setState({ ServerSecondsToDelay = rccProfilerRecordTimeFrame })
	end

	local numericInputRow2 = self:numericInputRow(v4)

	local v5 = {
		UIPadding = Roact.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 2),
			PaddingLeft = UDim.new(0, 2),
			PaddingRight = UDim.new(0, 2),
			PaddingTop = UDim.new(0, 2)
		}),
		Button = 0
	}

	local createElement = Roact.createElement
	local text

	if v2 then
		if self.state.IsClientRecording then
			text = props.RecordButtonText.Recording
		else
			text = props.RecordButtonText.Idle
		end
	elseif self.props.IsServerRecording then
		text = props.RecordButtonText.Recording
	else
		text = props.RecordButtonText.Idle
	end

	local v6 = {
		text = text,
		size = UDim2.fromScale(1, 1),
		pos = UDim2.new(0, 0, 0, 0),
		onClicked = props.OnRecordButtonClicked,
		enabled = 0
	}
	local enabled

	if v2 then
		enabled = not self.state.IsClientRecording
	else
		enabled = not self.props.IsServerRecording
	end

	v6.enabled = enabled
	v5.Button = createElement(BoxButton, v6)
	return { numericInputRow, numericInputRow2, v5 }
end

function extended:init()
	self.state = {
		IsClientRecording = false,
		ClientFramesToRecord = 32,
		ClientSecondsToDelay = 1,
		ServerFramesToRecord = gameSettings.RCCProfilerRecordFrameRate,
		ServerSecondsToDelay = gameSettings.RCCProfilerRecordTimeFrame
	}

	self.RecordingTasks = { Client = nil }
end

function extended.willUnmount(p)
	if p.RecordingTasks.Client and coroutine.status(p.RecordingTasks.Client) ~= "dead" then
		task.cancel(p.RecordingTasks.Client)
	end
end

function extended:render()
	return Roact.createElement(MicroProfilerPanel, {
		Title = "Record and dump",
		LayoutOrder = self.props.LayoutOrder,
		Sections = {
			{
				Name = "Client",
				Rows = self:recordAndDumpRows({
					Context = "Client",
					RecordButtonText = {
						Idle = "Begin client recording",
						Recording = "Recording client..."
					},
					OnRecordButtonClicked = function()
						if self.state.IsClientRecording then
							return
						end

						self:logRecordAndDumpAction("Client")
						self:setState({ IsClientRecording = true })

						self.RecordingTasks.Client = task.spawn(function()
							local v2 = MicroProfilerService:DumpToFileAsync(
								self.state.ClientSecondsToDelay,
								self.state.ClientFramesToRecord
							)

							self.props.dispatchAppendRecentDumpPath(v2)

							self:setState(function(_)
								return { IsClientRecording = false }
							end)

							self.RecordingTasks.Client = nil
						end)
					end
				})
			},
			{
				Name = "Server",
				Rows = self:recordAndDumpRows({
					Context = "Server",
					RecordButtonText = {
						Idle = "Begin server recording",
						Recording = "Recording server..."
					},
					OnRecordButtonClicked = function()
						if self.props.IsServerRecording then
							return
						end

						local clientReplicator = getClientReplicator()

						if not clientReplicator then
							return
						end

						self:logRecordAndDumpAction("Server")

						clientReplicator:RequestRCCProfilerData(
							self.state.ServerFramesToRecord,
							self.state.ServerSecondsToDelay
						)

						self.props.dispatchSetRCCProfilerState(true)
					end
				})
			}
		}
	})
end

local function mapStateToProps(p, _)
	return { IsServerRecording = p.MicroProfiler.waitingForRecording }
end

local function mapDispatchToProps(callback)
	return {
		dispatchAppendRecentDumpPath = function(p: string)
			callback(AppendRecentDumpPath(p))
		end,
		dispatchSetRCCProfilerState = function(flag: boolean, p: string?)
			callback(SetRCCProfilerState(flag, p))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)
