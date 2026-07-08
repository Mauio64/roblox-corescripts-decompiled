local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local TelemetryService = game:GetService("TelemetryService")
local GameSettings = UserSettings().GameSettings
local BoxButton = require(script.Parent.Parent.BoxButton)
local Constants = require(script.Parent.Parent.Parent.Constants)
local Checkbox = require(script.Parent.Parent.Checkbox)
local MicroProfilerPanel = require(script.Parent.MicroProfilerPanel)
local Roact = require(CorePackages.Packages.Roact)
local v10 = Roact.Component:extend("LocalActionsView")
local v11 = game:DefineFastFlag("DevConsoleMpEnableOpenDumpsFolderButton", false)
local t1 = {
	eventName = "DevConsoleMpToggleOnScreenMpCounter",
	description = "\t\tCounter to track toggling the on-screen MicroProfiler on or off via the Developer Console.\n\t",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		2025,
		11,
		17
	}
}

function v10.init(p1) -- line: 28
	-- upvalues: GameSettings (copy)
	p1:setState({
		OnScreenMicroProfilerVisible = GameSettings.OnScreenProfilerEnabled
	})
	p1.onScreenMpToggledConn = GameSettings:GetPropertyChangedSignal("OnScreenProfilerEnabled"):Connect(function() -- line: 33
		-- upvalues: p1 (copy), GameSettings (copy)
		p1:setState({
			OnScreenMicroProfilerVisible = GameSettings.OnScreenProfilerEnabled
		})
	end)
end
function v10.willUnmount(p2) -- line: 40
	if p2.onScreenMpToggledConn then
		if p2.onScreenMpToggledConn.Connected then
			p2.onScreenMpToggledConn:Disconnect()
		end

		p2.onScreenMpToggledConn = nil
	end
end
function v10.toggleOnScreenMicroProfiler(_: {[any]: any}, b1: boolean) -- line: 49
	-- upvalues: GameSettings (copy), TelemetryService (copy), t1 (copy)
	GameSettings.OnScreenProfilerEnabled = b1
	TelemetryService:LogCounter(t1, {
		customFields = {
			visible = `{ b1 }`
		}
	}, 1)
end
function v10.render(p3) -- line: 59
	-- upvalues: Roact (copy), MicroProfilerPanel (copy), Constants (copy), Checkbox (copy), v11 (copy), RunService (copy), BoxButton (copy)
	return Roact.createElement(MicroProfilerPanel, {
		Title = "Local actions",
		LayoutOrder = p3.props.LayoutOrder,
		Sections = {{
			Name = "LocalActions",
			Rows = {
				{
					UIListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					UIPadding = Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, Constants.MicroProfilerFormatting.OptionTextPadding)
					}),
					OptionLabel = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						Text = "On-screen MicroProfiler visible",
						LayoutOrder = 1,
						Size = UDim2.fromScale(0, 1),
						Position = UDim2.new(0, 8, 0, 0),
						TextXAlignment = Enum.TextXAlignment.Left,
						Font = Constants.Font.MainWindow,
						TextSize = Constants.MicroProfilerFormatting.OptionTextSize,
						TextColor3 = Color3.new(1, 1, 1)
					}, { Roact.createElement("UIFlexItem", {
						FlexMode = Enum.UIFlexMode.Grow
					}) }),
					CheckboxFrame = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						Size = UDim2.fromOffset(Constants.MicroProfilerFormatting.OptionRowHeight, Constants.MicroProfilerFormatting.OptionRowHeight)
					}, {
						OnScreenMicroProfilerVisibleCheckbox = Roact.createElement(Checkbox, {
							Name = "OnScreenMicroProfilerVisibleCheckbox",
							IsSelected = p3.state.OnScreenMicroProfilerVisible,
							Size = UDim2.fromOffset(Constants.MicroProfilerFormatting.OptionCheckboxSize, Constants.MicroProfilerFormatting.OptionCheckboxSize),
							Position = UDim2.fromOffset((Constants.MicroProfilerFormatting.OptionRowHeight - Constants.MicroProfilerFormatting.OptionCheckboxSize) / 2, (Constants.MicroProfilerFormatting.OptionRowHeight - Constants.MicroProfilerFormatting.OptionCheckboxSize) / 2),
							OnSelectedStateChanged = function(_, b2: boolean) -- line: 115
								-- upvalues: p3 (copy)
								p3:toggleOnScreenMicroProfiler(b2)
							end
						})
					})
				},
				if not v11 or (not game:GetEngineFeature("OpenLogsFolderApi") or RunService:IsStudio()) then nil else {
					UIPadding = Roact.createElement("UIPadding", {
						PaddingBottom = UDim.new(0, 2),
						PaddingLeft = UDim.new(0, 2),
						PaddingRight = UDim.new(0, 2),
						PaddingTop = UDim.new(0, 2)
					}),
					Button = Roact.createElement(BoxButton, {
						text = "Open dump folder",
						size = UDim2.fromScale(1, 1),
						pos = UDim2.new(0, 0, 0, 0),
						onClicked = function() -- line: 135
							game:OpenLogsFolder()
						end
					})
				}
			}
		}}
	})
end

return v10
