local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

game:GetService("ScriptContext")

local ScriptProfilerService = game:GetService("ScriptProfilerService")

require(script.Parent.ProfilerDataFormatV2)

local Components = script.Parent.Parent.Parent.Components
local ScrollingTextBox = require(Components.ScrollingTextBox)
local _ = script.Parent.Parent.Parent.Actions
local Constants = require(script.Parent.Parent.Parent.Constants)
local MainRowPadding = Constants.GeneralFormatting.MainRowPadding
local MainWindowHeader = Constants.Font.MainWindowHeader
local MainWindow = Constants.Font.MainWindow
local ButtonTextSize = Constants.MicroProfilerFormatting.ButtonTextSize
local UnselectedGray = Constants.Color.UnselectedGray
local ButtonWidth = Constants.MicroProfilerFormatting.ButtonWidth
local v15 = Roact.PureComponent:extend("ProfilerExportView")

local function generateDefaultExportName(b1: boolean, p1, s1: string) -- line: 31
	local s2 = ""
	local v22 = not b1 and "server" or "client"
	local v23 = p1 and p1.SessionStartTime

	if v23 then
		s2 = os.date("%Y%b%d-%H%M%S-", v23 / 1000) or ""
	end

	return "scriptprofiler-" .. s2 .. v22 .. s1
end

function v15.init(_) -- line: 45
end
function v15.didMount(p3) -- line: 47
	local t1 = {}
	local data = p3.props.client.data
	local s3 = ""
	local v29 = data and data.SessionStartTime

	if v29 then
		s3 = os.date("%Y%b%d-%H%M%S-", v29 / 1000) or ""
	end

	t1.exportFilenameClient = "scriptprofiler-" .. s3 .. "client" .. ".json"

	local data2 = p3.props.server.data
	local s4 = ""
	local v32 = data2 and data2.SessionStartTime

	if v32 then
		s4 = os.date("%Y%b%d-%H%M%S-", v32 / 1000) or ""
	end

	t1.exportFilenameServer = "scriptprofiler-" .. s4 .. "server" .. ".json"
	p3:setState(t1)
end
function v15.didUpdate(_) -- line: 54
end
function v15.renderExportInputAndButton(t2: {[any]: any}, b2: boolean, s5: string, s6: string) -- line: 56
	-- upvalues: Roact (copy), UnselectedGray (copy), ButtonTextSize (copy), MainWindow (copy), Constants (copy), ScrollingTextBox (copy), MainWindowHeader (copy), ScriptProfilerService (copy)
	return Roact.createElement("TextLabel", {
		BackgroundTransparency = 0,
		Size = UDim2.new(0.9, 0, 0, 30),
		Position = UDim2.new(0.05, 0, 0, 37.5),
		BackgroundColor3 = UnselectedGray,
		Text = not s6 and "Complete a profiling session to export data" or "",
		TextSize = ButtonTextSize,
		Font = MainWindow,
		TextColor3 = Constants.Color.Text
	}, if not s6 then {} else {
		InputField = Roact.createElement(ScrollingTextBox, {
			ShowNativeInput = true,
			ClearTextOnFocus = false,
			PlaceholderText = "Filename for export",
			Text = s5,
			TextSize = ButtonTextSize,
			Font = MainWindow,
			Size = UDim2.new(0.8, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			TextColor3 = Constants.Color.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextBoxFocusLost = function(p5, _, _) -- line: 86
				-- upvalues: b2 (copy), t2 (copy)
				if b2 then
					t2:setState({
						exportFilenameClient = p5.text
					})

					return
				end

				t2:setState({
					exportFilenameServer = p5.text
				})
			end
		}),
		ExportButton = Roact.createElement("TextButton", {
			Size = UDim2.new(0.2, 0, 1, 0),
			Position = UDim2.new(0.8, 0, 0, 0),
			Text = "Export",
			Font = MainWindowHeader,
			TextSize = ButtonTextSize,
			TextColor3 = Constants.Color.Text,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundColor3 = UnselectedGray,
			[Roact.Event.Activated] = function() -- line: 110
				-- upvalues: ScriptProfilerService (copy), s6 (copy), s5 (copy), b2 (copy), t2 (copy)
				local v50 = ScriptProfilerService:SaveScriptProfilingData(s6, s5)

				if b2 then
					t2:setState({
						clientSavePath = v50
					})

					return
				end

				t2:setState({
					serverSavePath = v50
				})
			end
		})
	})
end
function v15.renderExportSection(t3: {[any]: any}, b3: boolean, s7: string) -- line: 129
	-- upvalues: Roact (copy), ButtonWidth (copy), MainWindowHeader (copy), ButtonTextSize (copy), Constants (copy), UnselectedGray (copy)
	local exportFilenameClient, serializedData, clientSavePath

	if b3 then
		exportFilenameClient = t3.state.exportFilenameClient
		serializedData = t3.props.client.serializedData
		clientSavePath = t3.state.clientSavePath
	else
		exportFilenameClient = t3.state.exportFilenameServer
		serializedData = t3.props.server.serializedData
		clientSavePath = t3.state.serverSavePath
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 90)
	}, {
		Label = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, ButtonWidth, 0, 30),
			Position = UDim2.new(0.1, 0, 0, 0),
			Text = s7,
			Font = MainWindowHeader,
			TextSize = ButtonTextSize,
			TextColor3 = Constants.Color.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundColor3 = UnselectedGray
		}),
		HorizontalLine = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 0, 30)
		}),
		Export = t3:renderExportInputAndButton(b3, exportFilenameClient, serializedData),
		SavedPath = if clientSavePath then Roact.createElement("TextBox", {
			BackgroundTransparency = 1,
			TextEditable = false,
			ClearTextOnFocus = false,
			Size = UDim2.new(0.95, 0, 0, 30),
			Position = UDim2.new(0.05, 0, 0, 75),
			Text = "Saved to " .. clientSavePath,
			Font = MainWindowHeader,
			TextSize = ButtonTextSize,
			TextColor3 = Constants.Color.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundColor3 = UnselectedGray
		}) else nil
	})
end
function v15.render(p8) -- line: 188
	-- upvalues: Roact (copy), Constants (copy), MainRowPadding (copy)
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = p8.props.size,
		BackgroundColor3 = Constants.Color.BaseGray
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, MainRowPadding * 2),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Row = p8:renderExportSection(true, "Client"),
		HorizontalLine = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, MainRowPadding)
		}),
		Row2 = p8:renderExportSection(false, "Server")
	})
end

local function mapStateToProps(p9, _) -- line: 212
	return {
		client = p9.ScriptProfiler.client,
		server = p9.ScriptProfiler.server
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, nil)(v15)
