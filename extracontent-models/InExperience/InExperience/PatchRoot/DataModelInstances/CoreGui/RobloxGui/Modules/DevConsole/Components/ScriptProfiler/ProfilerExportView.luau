local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

game:GetService("ScriptContext")
local ScriptProfilerService = game:GetService("ScriptProfilerService")

require(script.Parent.ProfilerDataFormatV2)

local Components = script.Parent.Parent.Parent.Components
local ScrollingTextBox = require(Components.ScrollingTextBox)

local Actions = script.Parent.Parent.Parent.Actions

local Constants = require(script.Parent.Parent.Parent.Constants)
local MainRowPadding = Constants.GeneralFormatting.MainRowPadding

local MainWindowHeader = Constants.Font.MainWindowHeader
local MainWindow = Constants.Font.MainWindow
local ButtonTextSize = Constants.MicroProfilerFormatting.ButtonTextSize
local UnselectedGray = Constants.Color.UnselectedGray

local ButtonWidth = Constants.MicroProfilerFormatting.ButtonWidth

local extended = Roact.PureComponent:extend("ProfilerExportView")

local function generateDefaultExportName(flag: boolean, p, p2: string)
	local sessionStartTime = p and p.SessionStartTime

	return "scriptprofiler-" .. (sessionStartTime and (os.date("%Y%b%d-%H%M%S-", sessionStartTime / 1000) or "") or "") .. (flag and "client" or "server") .. p2
end

function extended.init(_) end

function extended.didMount(object)
	local data = object.props.client.data
	local sessionStartTime = data and data.SessionStartTime

	local v = {
		exportFilenameClient = "scriptprofiler-" .. (sessionStartTime and (os.date("%Y%b%d-%H%M%S-", sessionStartTime / 1000) or "") or "") .. "client.json",
		exportFilenameServer = 0
	}

	local data2 = object.props.server.data
	local sessionStartTime2 = data2 and data2.SessionStartTime

	v.exportFilenameServer = "scriptprofiler-" .. (sessionStartTime2 and (os.date("%Y%b%d-%H%M%S-", sessionStartTime2 / 1000) or "") or "") .. "server.json"
	object:setState(v)
end

function extended.didUpdate(_) end

function extended:renderExportInputAndButton(flag: boolean, text: string, p: string)
	local createElement = Roact.createElement

	local v = {
		Size = UDim2.new(0.9, 0, 0, 30),
		Position = UDim2.new(0.05, 0, 0, 37.5),
		BackgroundTransparency = 0,
		BackgroundColor3 = UnselectedGray,
		Text = p and "" or "Complete a profiling session to export data",
		TextSize = ButtonTextSize,
		Font = MainWindow,
		TextColor3 = Constants.Color.Text
	}
	local v2

	if p then
		v2 = {
			InputField = Roact.createElement(ScrollingTextBox, {
				Text = text,
				TextSize = ButtonTextSize,
				Font = MainWindow,
				Size = UDim2.new(0.8, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				ShowNativeInput = true,
				TextColor3 = Constants.Color.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				ClearTextOnFocus = false,
				PlaceholderText = "Filename for export",
				TextBoxFocusLost = function(p2, _, _)
					if flag then
						self:setState({ exportFilenameClient = p2.text })
					else
						self:setState({ exportFilenameServer = p2.text })
					end
				end
			}),
			ExportButton = 0
		}

		v2.ExportButton = Roact.createElement("TextButton", {
			Size = UDim2.new(0.2, 0, 1, 0),
			Position = UDim2.new(0.8, 0, 0, 0),
			Text = "Export",
			Font = MainWindowHeader,
			TextSize = ButtonTextSize,
			TextColor3 = Constants.Color.Text,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundColor3 = UnselectedGray,
			[Roact.Event.Activated] = function()
				local v3 = ScriptProfilerService:SaveScriptProfilingData(p, text)

				if flag then
					self:setState({ clientSavePath = v3 })
				else
					self:setState({ serverSavePath = v3 })
				end
			end
		})
	else
		v2 = {}
	end

	return createElement("TextLabel", v, v2)
end

function extended:renderExportSection(flag: boolean, text: string)
	local v, serializedData, v2

	if flag then
		v = self.state.exportFilenameClient
		serializedData = self.props.client.serializedData
		v2 = self.state.clientSavePath
	else
		v = self.state.exportFilenameServer
		serializedData = self.props.server.serializedData
		v2 = self.state.serverSavePath
	end

	local createElement = Roact.createElement
	local v3 = { Size = UDim2.new(1, 0, 0, 90), BackgroundTransparency = 1, LayoutOrder = 2 }

	local v4 = {
		Label = Roact.createElement("TextLabel", {
			Size = UDim2.new(0, ButtonWidth, 0, 30),
			Position = UDim2.new(0.1, 0, 0, 0),
			Text = text,
			Font = MainWindowHeader,
			TextSize = ButtonTextSize,
			TextColor3 = Constants.Color.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundColor3 = UnselectedGray,
			BackgroundTransparency = 1
		}),
		HorizontalLine = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 0, 30)
		}),
		Export = self:renderExportInputAndButton(flag, v, serializedData),
		SavedPath = 0
	}
	local savedPath

	if v2 then
		savedPath = Roact.createElement("TextBox", {
			Size = UDim2.new(0.95, 0, 0, 30),
			Position = UDim2.new(0.05, 0, 0, 75),
			Text = "Saved to " .. v2,
			Font = MainWindowHeader,
			TextSize = ButtonTextSize,
			TextColor3 = Constants.Color.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundColor3 = UnselectedGray,
			BackgroundTransparency = 1,
			TextEditable = false,
			ClearTextOnFocus = false
		})
	end

	v4.SavedPath = savedPath
	return createElement("Frame", v3, v4)
end

function extended:render()
	return Roact.createElement(
		"Frame",
		{
			Size = self.props.size,
			BackgroundColor3 = Constants.Color.BaseGray,
			BackgroundTransparency = 1,
			LayoutOrder = 2
		},
		{
			UIListLayout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, MainRowPadding * 2),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Row = self:renderExportSection(true, "Client"),
			HorizontalLine = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, MainRowPadding),
				BackgroundTransparency = 1,
				LayoutOrder = 3
			}),
			Row2 = self:renderExportSection(false, "Server")
		}
	)
end

local function mapStateToProps(p, _)
	return { client = p.ScriptProfiler.client, server = p.ScriptProfiler.server }
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, nil)(extended)
