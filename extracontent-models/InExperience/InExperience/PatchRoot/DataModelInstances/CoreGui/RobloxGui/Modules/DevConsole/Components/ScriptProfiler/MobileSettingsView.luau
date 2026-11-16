local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

game:GetService("ScriptContext")

local ProfilerUtil = require(script.Parent.ProfilerUtil)

local Components = script.Parent.Parent.Parent.Components
local DropDown = require(Components.DropDown)

local Actions = script.Parent.Parent.Parent.Actions
local SetScriptProfilerState = require(Actions.SetScriptProfilerState)

local Constants = require(script.Parent.Parent.Parent.Constants)
local v = Constants.GeneralFormatting.MainRowPadding * 2
local SmallFrameHeight = Constants.UtilityBarFormatting.SmallFrameHeight

local MainWindowHeader = Constants.Font.MainWindowHeader
local MainWindow = Constants.Font.MainWindow
local ButtonTextSize = Constants.MicroProfilerFormatting.ButtonTextSize
local Text = Constants.Color.Text

local UnselectedGray = Constants.Color.UnselectedGray
local unselectedGray = Constants.Color.UnselectedGray
local SelectedBlue = Constants.Color.SelectedBlue

local unselectedGray2 = Constants.Color.UnselectedGray

local ButtonWidth = Constants.MicroProfilerFormatting.ButtonWidth

local DropDownArrowHeight = Constants.GeneralFormatting.DropDownArrowHeight
local halfDropDownArrowHeight = DropDownArrowHeight / 2
local DownArrow = Constants.Image.DownArrow

local defineFastFlag = game:DefineFastFlag("ScriptProfilerShowPlugins2", false)

local function makeFormattedStringTable(list, callback) -- 3 equivalent calls inferred from this helper
	local formattedStringTable = table.create(#list)

	for _, item in list do
		table.insert(formattedStringTable, callback(item))
	end

	return formattedStringTable
end

local function formatTimeSelection(p)
	if p == 0 then
		return "Off"
	end

	return ProfilerUtil.formatTimer(p)
end

local v2 = { 0, 1, 60, 300, 600 }
local v3 = { "Callgraph", "Functions" }
local formattedStringTable = makeFormattedStringTable(v2, formatTimeSelection) -- inferred equivalent call
local v4 = { 1000, 10000 }
local formattedStringTable2 = makeFormattedStringTable(v4, ProfilerUtil.formatFrequency) -- inferred equivalent call

local v5 = { 0, 60, 300, 600 }
local formattedStringTable3 = makeFormattedStringTable(v5, formatTimeSelection) -- inferred equivalent call
local extended = Roact.PureComponent:extend("MobileSettingsView")

function extended.init(_) end

function extended.didMount(_) end

function extended.didUpdate(_) end

function extended:GetState(p)
	local v6

	if self.props.isClientView then
		v6 = self.props.client
	else
		v6 = self.props.server
	end

	return v6[p]
end

function extended:UpdateState(p, p2)
	local v6

	if self.props.isClientView then
		v6 = self.props.client
	else
		v6 = self.props.server
	end

	local clone = table.clone(v6)
	clone[p] = p2

	self.props.dispatchSetScriptProfilerState(self.props.isClientView, clone)
end

function extended:renderToggle(text, p, callback)
	return Roact.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, SmallFrameHeight),
			BackgroundTransparency = 1,
			LayoutOrder = 2
		},
		{
			Label = Roact.createElement("TextLabel", {
				Size = UDim2.new(0, ButtonWidth, 0, SmallFrameHeight),
				Position = UDim2.new(0.1, 0, 0, 0),
				Text = text,
				Font = MainWindowHeader,
				TextSize = ButtonTextSize,
				TextColor3 = Constants.Color.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				BackgroundColor3 = unselectedGray2,
				BackgroundTransparency = 1
			}),
			ToggleButton = Roact.createElement("TextLabel", {
				Size = UDim2.new(0, ButtonWidth * 2, 0, SmallFrameHeight),
				Position = UDim2.new(0.9, -ButtonWidth * 2, 0, 0),
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
					BackgroundColor3 = p and unselectedGray or SelectedBlue,
					[Roact.Event.Activated] = function()
						callback(false)
					end
				}),
				OnButton = Roact.createElement("TextButton", {
					Size = UDim2.new(0.5, 0, 1, 0),
					Position = UDim2.new(0.5, 0, 0, 0),
					Text = "On",
					Font = MainWindowHeader,
					TextSize = ButtonTextSize,
					TextColor3 = Constants.Color.Text,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center,
					BackgroundColor3 = p and SelectedBlue or unselectedGray,
					[Roact.Event.Activated] = function()
						callback(true)
					end
				})
			})
		}
	)
end

function extended:renderStateToggle(p, p2, _)
	return self:renderToggle(p, self:GetState(p2), function(p3)
		self:UpdateState(p2, p3)
	end)
end

function extended:renderDropDown(text, p, dropDownList, p2, selectedIndex, p3)
	local dropDown

	if p3 then
		dropDown = Roact.createElement("TextButton", {
			Position = UDim2.new(0.9, -ButtonWidth, 0, 0),
			Size = UDim2.new(0, ButtonWidth, 0, SmallFrameHeight),
			Text = dropDownList[selectedIndex],
			TextSize = ButtonTextSize,
			TextColor3 = Text,
			Font = MainWindow,
			AutoButtonColor = true,
			BackgroundColor3 = Constants.Color.InactiveBox,
			BackgroundTransparency = 0
		}, {
			arrow = Roact.createElement("ImageLabel", {
				Image = DownArrow,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, DropDownArrowHeight, 0, DropDownArrowHeight),
				Position = UDim2.new(1, -DropDownArrowHeight - halfDropDownArrowHeight, 0.5, -halfDropDownArrowHeight)
			})
		})
	else
		dropDown = Roact.createElement("Frame", {
			Position = UDim2.new(0.9, -ButtonWidth, 0, 0),
			Size = UDim2.new(0, ButtonWidth, 0, SmallFrameHeight)
		}, {
			Selection = Roact.createElement(DropDown, {
				buttonSize = UDim2.new(1, 0, 0, SmallFrameHeight),
				dropDownList = dropDownList,
				selectedIndex = selectedIndex,
				onSelection = function(p4)
					local v6 = self:GetState(p)

					if typeof(v6) == "boolean" then
						v6 = p4 == 2
					elseif typeof(v6) == "number" then
						v6 = p2[p4]
					end

					self:UpdateState(p, v6)
				end
			})
		})
	end

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, SmallFrameHeight),
		BackgroundTransparency = 1
	}, {
		Label = Roact.createElement("TextLabel", {
			Size = UDim2.new(0, ButtonWidth, 0, SmallFrameHeight),
			Position = UDim2.new(0.1, 0, 0, 0),
			Text = text,
			Font = MainWindowHeader,
			TextSize = ButtonTextSize,
			TextColor3 = Constants.Color.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundColor3 = unselectedGray2,
			BackgroundTransparency = 1
		}),
		DropDown = dropDown
	})
end

function extended:render()
	local state = self:GetState("isProfiling")

	local createElement = Roact.createElement
	local v6 = {
		Size = self.props.size,
		BackgroundColor3 = Constants.Color.BaseGray,
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		AutomaticCanvasSize = Enum.AutomaticSize.Y
	}
	local v7 = {
		UIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, v),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Percentages = self:renderToggle("Percentages", self.props.usePercentages, function(p)
			self.props.dispatchSetScriptProfilerUsePercentages(p)
		end),
		LiveToggle = self:renderStateToggle("Live Update", "liveUpdate"),
		PluginsToggle = 0,
		GCToggle = 0,
		AverageDropDown = 0,
		FrequencyDropDown = 0,
		TimerDropDown = 0,
		ViewDropDown = 0
	}
	local pluginsToggle

	if defineFastFlag then
		pluginsToggle = self:renderStateToggle("Show Plugins", "showPlugins")
	end

	v7.PluginsToggle = pluginsToggle

	v7.GCToggle = self:renderStateToggle("GC Overhead", "showGc")

	v7.AverageDropDown = self:renderDropDown(
		"Average",
		"average",
		formattedStringTable,
		v2,
		table.find(v2, self:GetState("average")) or 1
	)

	v7.FrequencyDropDown = self:renderDropDown(
		"Frequency",
		"frequency",
		formattedStringTable2,
		v4,
		table.find(v4, self:GetState("frequency")) or 1,
		state
	)

	v7.TimerDropDown = self:renderDropDown(
		"Timer" .. (not state and "" or ": " .. ProfilerUtil.formatTimer(self:GetState("timedProfilingCountdown"))),
		"timedProfilingDuration",
		formattedStringTable3,
		v5,
		table.find(v5, self:GetState("timedProfilingDuration")) or 1,
		state
	)

	v7.ViewDropDown = self:renderDropDown(
		"View",
		"isFunctionsView",
		v3,
		nil,
		self:GetState("isFunctionsView") and 2 or 1
	)
	return createElement("ScrollingFrame", v6, v7)
end

local function mapStateToProps(p, _)
	return {
		usePercentages = p.ScriptProfiler.usePercentages,
		isClientView = p.ScriptProfiler.isClientView,
		client = p.ScriptProfiler.client,
		server = p.ScriptProfiler.server
	}
end

local function mapDispatchToProps(callback)
	return {
		dispatchSetScriptProfilerState = function(p, p2)
			if p then
				callback(SetScriptProfilerState(p, nil, p2, nil))
			else
				callback(SetScriptProfilerState(p, nil, nil, p2))
			end
		end,
		dispatchSetScriptProfilerUsePercentages = function(p)
			callback(SetScriptProfilerState(nil, p))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(extended)
