local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local TelemetryService = game:GetService("TelemetryService")

local gameSettings = UserSettings().GameSettings

local BoxButton = require(script.Parent.Parent.BoxButton)
local Constants = require(script.Parent.Parent.Parent.Constants)
local Checkbox = require(script.Parent.Parent.Checkbox)
local MicroProfilerPanel = require(script.Parent.MicroProfilerPanel)
local Roact = require(CorePackages.Packages.Roact)

local extended = Roact.Component:extend("LocalActionsView")

local defineFastFlag = game:DefineFastFlag("DevConsoleMpEnableOpenDumpsFolderButton", false)

local v = {
	eventName = "DevConsoleMpToggleOnScreenMpCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 2025, 11, 17 },
	description = "\t\tCounter to track toggling the on-screen MicroProfiler on or off via the Developer Console.\n\t"
}

function extended:init()
	self:setState({ OnScreenMicroProfilerVisible = gameSettings.OnScreenProfilerEnabled })

	self.onScreenMpToggledConn = gameSettings:GetPropertyChangedSignal("OnScreenProfilerEnabled"):Connect(function()
		self:setState({ OnScreenMicroProfilerVisible = gameSettings.OnScreenProfilerEnabled })
	end)
end

function extended:willUnmount()
	if self.onScreenMpToggledConn then
		if self.onScreenMpToggledConn.Connected then
			self.onScreenMpToggledConn:Disconnect()
		end

		self.onScreenMpToggledConn = nil
	end
end

function extended:toggleOnScreenMicroProfiler(onScreenProfilerEnabled: boolean)
	gameSettings.OnScreenProfilerEnabled = onScreenProfilerEnabled

	TelemetryService:LogCounter(v, {
		customFields = { visible = `{onScreenProfilerEnabled}` }
	}, 1)
end

function extended:render()
	return Roact.createElement(MicroProfilerPanel, {
		Title = "Local actions",
		LayoutOrder = self.props.LayoutOrder,
		Sections = {
			{
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
							Size = UDim2.fromScale(0, 1),
							Position = UDim2.new(0, 8, 0, 0),
							BackgroundTransparency = 1,
							Text = "On-screen MicroProfiler visible",
							TextXAlignment = Enum.TextXAlignment.Left,
							Font = Constants.Font.MainWindow,
							TextSize = Constants.MicroProfilerFormatting.OptionTextSize,
							TextColor3 = Color3.new(1, 1, 1),
							LayoutOrder = 1
						}, { Roact.createElement("UIFlexItem", {
								FlexMode = Enum.UIFlexMode.Grow
							}) }),
						CheckboxFrame = Roact.createElement(
							"Frame",
							{
								Size = UDim2.fromOffset(
									Constants.MicroProfilerFormatting.OptionRowHeight,
									Constants.MicroProfilerFormatting.OptionRowHeight
								),
								BackgroundTransparency = 1,
								LayoutOrder = 2
							},
							{
								OnScreenMicroProfilerVisibleCheckbox = Roact.createElement(Checkbox, {
									Name = "OnScreenMicroProfilerVisibleCheckbox",
									IsSelected = self.state.OnScreenMicroProfilerVisible,
									Size = UDim2.fromOffset(
										Constants.MicroProfilerFormatting.OptionCheckboxSize,
										Constants.MicroProfilerFormatting.OptionCheckboxSize
									),
									Position = UDim2.fromOffset(
										(Constants.MicroProfilerFormatting.OptionRowHeight - Constants.MicroProfilerFormatting.OptionCheckboxSize) / 2,
										(Constants.MicroProfilerFormatting.OptionRowHeight - Constants.MicroProfilerFormatting.OptionCheckboxSize) / 2
									),
									OnSelectedStateChanged = function(_, flag: boolean)
										self:toggleOnScreenMicroProfiler(flag)
									end
								})
							}
						)
					},
					defineFastFlag and game:GetEngineFeature("OpenLogsFolderApi") and not RunService:IsStudio() and {
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
							onClicked = function()
								game:OpenLogsFolder()
							end
						})
					} or nil
				}
			}
		}
	})
end

return extended
