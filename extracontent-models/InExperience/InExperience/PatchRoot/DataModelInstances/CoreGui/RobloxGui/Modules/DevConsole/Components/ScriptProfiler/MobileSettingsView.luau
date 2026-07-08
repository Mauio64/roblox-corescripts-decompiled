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
local v10 = Constants.GeneralFormatting.MainRowPadding * 2
local SmallFrameHeight = Constants.UtilityBarFormatting.SmallFrameHeight
local MainWindowHeader = Constants.Font.MainWindowHeader
local MainWindow = Constants.Font.MainWindow
local ButtonTextSize = Constants.MicroProfilerFormatting.ButtonTextSize
local ColorText = Constants.Color.Text
local _ = Constants.Color.UnselectedGray
local UnselectedGray = Constants.Color.UnselectedGray
local SelectedBlue = Constants.Color.SelectedBlue
local UnselectedGray2 = Constants.Color.UnselectedGray
local ButtonWidth = Constants.MicroProfilerFormatting.ButtonWidth
local DropDownArrowHeight = Constants.GeneralFormatting.DropDownArrowHeight
local v22 = DropDownArrowHeight / 2
local DownArrow = Constants.Image.DownArrow
local v24 = game:DefineFastFlag("ScriptProfilerShowPlugins2", false)

local function makeFormattedStringTable(t1: {[any]: any}, p1: ((...any) -> ...any)) -- line: 43
	local t2 = table.create(#t1)

	for _, v51 in t1 do
		table.insert(t2, p1(v51))
	end

	return t2
end
local function formatTimeSelection(p2) -- line: 53
	-- upvalues: ProfilerUtil (copy)
	if p2 == 0 then
		return "Off"
	end

	return ProfilerUtil.formatTimer(p2)
end

local t3 = {
	"Callgraph",
	"Functions"
}
local t4 = {
	0,
	1,
	60,
	300,
	600
}
local t5 = table.create(#t4)

for _, v31 in t4 do
	table.insert(t5, formatTimeSelection(v31))
end

local v32 = t5
local t6 = {
	1000,
	10000
}
local formatFrequency = ProfilerUtil.formatFrequency
local t7 = table.create(#t6)

for _, v37 in t6 do
	table.insert(t7, formatFrequency(v37))
end

local v38 = t7
local t8 = {
	0,
	60,
	300,
	600
}
local t9 = table.create(#t8)

for _, v42 in t8 do
	table.insert(t9, formatTimeSelection(v42))
end

local v43 = t9
local v44 = Roact.PureComponent:extend("MobileSettingsView")

function v44.init(_) -- line: 74
end
function v44.didMount(_) -- line: 76
end
function v44.didUpdate(_) -- line: 78
end
function v44.GetState(p6, p7) -- line: 80
	return ((if not p6.props.isClientView then p6.props.server else p6.props.client))[p7]
end
function v44.UpdateState(p8, p9, p10) -- line: 86
	local v61 = if not p8.props.isClientView then p8.props.server else p8.props.client
	local v62 = table.clone(v61)

	v62[p9] = p10
	p8.props.dispatchSetScriptProfilerState(p8.props.isClientView, v62)
end
function v44.renderToggle(_, p12, p13, p14) -- line: 95
	-- upvalues: Roact (copy), SmallFrameHeight (copy), ButtonWidth (copy), MainWindowHeader (copy), ButtonTextSize (copy), Constants (copy), UnselectedGray2 (copy), UnselectedGray (copy), SelectedBlue (copy)
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, SmallFrameHeight)
	}, {
		Label = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, ButtonWidth, 0, SmallFrameHeight),
			Position = UDim2.new(0.1, 0, 0, 0),
			Text = p12,
			Font = MainWindowHeader,
			TextSize = ButtonTextSize,
			TextColor3 = Constants.Color.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundColor3 = UnselectedGray2
		}),
		ToggleButton = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, ButtonWidth * 2, 0, SmallFrameHeight),
			Position = UDim2.new(0.9, -ButtonWidth * 2, 0, 0)
		}, {
			OffButton = Roact.createElement("TextButton", {
				Size = UDim2.new(0.5, 0, 1, 0),
				Text = "Off",
				Font = MainWindowHeader,
				TextSize = ButtonTextSize,
				TextColor3 = Constants.Color.Text,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				BackgroundColor3 = p13 and UnselectedGray or SelectedBlue,
				[Roact.Event.Activated] = function() -- line: 129
					-- upvalues: p14 (copy)
					p14(false)
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
				BackgroundColor3 = p13 and SelectedBlue or UnselectedGray,
				[Roact.Event.Activated] = function() -- line: 145
					-- upvalues: p14 (copy)
					p14(true)
				end
			})
		})
	})
end
function v44.renderStateToggle(p15, p16, p17, _) -- line: 153
	return p15:renderToggle(p16, p15:GetState(p17), function(p19) -- line: 156
		-- upvalues: p15 (copy), p17 (copy)
		p15:UpdateState(p17, p19)
	end)
end
function v44.renderDropDown(p20, p21, p22, p23, p24, p25, p26) -- line: 161
	-- upvalues: Roact (copy), ButtonWidth (copy), SmallFrameHeight (copy), ButtonTextSize (copy), ColorText (copy), MainWindow (copy), Constants (copy), DownArrow (copy), DropDownArrowHeight (copy), v22 (copy), DropDown (copy), MainWindowHeader (copy), UnselectedGray2 (copy)
	local v78 = if not p26 then Roact.createElement("Frame", {
		Position = UDim2.new(0.9, -ButtonWidth, 0, 0),
		Size = UDim2.new(0, ButtonWidth, 0, SmallFrameHeight)
	}, {
		Selection = Roact.createElement(DropDown, {
			buttonSize = UDim2.new(1, 0, 0, SmallFrameHeight),
			dropDownList = p23,
			selectedIndex = p25,
			onSelection = function(p27) -- line: 193
				-- upvalues: p20 (copy), p22 (copy), p24 (copy)
				local State = p20:GetState(p22)

				if typeof(State) == "boolean" then
					State = p27 == 2
				elseif typeof(State) == "number" then
					State = p24[p27]
				end

				p20:UpdateState(p22, State)
			end
		})
	}) else Roact.createElement("TextButton", {
		AutoButtonColor = true,
		BackgroundTransparency = 0,
		Position = UDim2.new(0.9, -ButtonWidth, 0, 0),
		Size = UDim2.new(0, ButtonWidth, 0, SmallFrameHeight),
		Text = p23[p25],
		TextSize = ButtonTextSize,
		TextColor3 = ColorText,
		Font = MainWindow,
		BackgroundColor3 = Constants.Color.InactiveBox
	}, {
		arrow = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = DownArrow,
			Size = UDim2.new(0, DropDownArrowHeight, 0, DropDownArrowHeight),
			Position = UDim2.new(1, -DropDownArrowHeight - v22, 0.5, -v22)
		})
	})

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, SmallFrameHeight)
	}, {
		Label = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, ButtonWidth, 0, SmallFrameHeight),
			Position = UDim2.new(0.1, 0, 0, 0),
			Text = p21,
			Font = MainWindowHeader,
			TextSize = ButtonTextSize,
			TextColor3 = Constants.Color.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundColor3 = UnselectedGray2
		}),
		DropDown = v78
	})
end
function v44.render(p28) -- line: 229
	-- upvalues: Roact (copy), Constants (copy), v10 (copy), v24 (copy), v32 (copy), t4 (copy), v38 (copy), t6 (copy), ProfilerUtil (copy), v43 (copy), t8 (copy), t3 (copy)
	local State = p28:GetState("isProfiling")

	return Roact.createElement("ScrollingFrame", {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = p28.props.size,
		BackgroundColor3 = Constants.Color.BaseGray,
		AutomaticCanvasSize = Enum.AutomaticSize.Y
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, v10),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Percentages = p28:renderToggle("Percentages", p28.props.usePercentages, function(p29) -- line: 245
			-- upvalues: p28 (copy)
			p28.props.dispatchSetScriptProfilerUsePercentages(p29)
		end),
		LiveToggle = p28:renderStateToggle("Live Update", "liveUpdate"),
		PluginsToggle = if v24 then p28:renderStateToggle("Show Plugins", "showPlugins") else nil,
		GCToggle = p28:renderStateToggle("GC Overhead", "showGc"),
		AverageDropDown = p28:renderDropDown("Average", "average", v32, t4, table.find(t4, p28:GetState("average")) or 1),
		FrequencyDropDown = p28:renderDropDown("Frequency", "frequency", v38, t6, table.find(t6, p28:GetState("frequency")) or 1, State),
		TimerDropDown = p28:renderDropDown("Timer" .. (not State and "" or ": " .. ProfilerUtil.formatTimer(p28:GetState("timedProfilingCountdown"))), "timedProfilingDuration", v43, t8, table.find(t8, p28:GetState("timedProfilingDuration")) or 1, State),
		ViewDropDown = p28:renderDropDown("View", "isFunctionsView", t3, nil, not p28:GetState("isFunctionsView") and 1 or 2)
	})
end

local function mapStateToProps(p30, _) -- line: 296
	return {
		usePercentages = p30.ScriptProfiler.usePercentages,
		isClientView = p30.ScriptProfiler.isClientView,
		client = p30.ScriptProfiler.client,
		server = p30.ScriptProfiler.server
	}
end
local function mapDispatchToProps(p32) -- line: 305
	-- upvalues: SetScriptProfilerState (copy)
	return {
		dispatchSetScriptProfilerState = function(p33, p34) -- line: 307
			-- upvalues: p32 (copy), SetScriptProfilerState (copy)
			if p33 then
				p32(SetScriptProfilerState(p33, nil, p34, nil))

				return
			end

			p32(SetScriptProfilerState(p33, nil, nil, p34))
		end,
		dispatchSetScriptProfilerUsePercentages = function(p35) -- line: 315
			-- upvalues: p32 (copy), SetScriptProfilerState (copy)
			p32(SetScriptProfilerState(nil, p35))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(v44)
