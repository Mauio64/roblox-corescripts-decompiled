local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Actions = script.Parent.Parent.Parent.Actions

local Components = script.Parent.Parent.Parent.Components
local DataConsumer = require(Components.DataConsumer)

local Constants = require(script.Parent.Parent.Parent.Constants)
local MainRowPadding = Constants.GeneralFormatting.MainRowPadding
local UtilAndTab = require(Components.UtilAndTab)

local extended = Roact.PureComponent:extend("MainViewVoiceChat")

function extended:init()
	function self.onUtilTabHeightChanged(utilTabHeight)
		self:setState({ utilTabHeight = utilTabHeight })
	end

	function self.onStatsUpdated(stats)
		self:setState({ stats = stats })
	end

	self._statsUpdatedConnection = self.props.VoiceChatData:Signal():Connect(self.onStatsUpdated)

	self.utilRef = Roact.createRef()

	self.state = { utilTabHeight = 0, stats = {} }
end

function extended.didMount(object)
	object:setState({ utilTabHeight = object.utilRef.current.Size.Y.Offset })
end

function extended.didUpdate(object)
	local size = object.utilRef.current.Size

	if size.Y.Offset ~= object.state.utilTabHeight then
		object:setState({ utilTabHeight = size.Y.Offset })
	end
end

function extended:willUnmount()
	if self._statsUpdatedConnection then
		self._statsUpdatedConnection:Disconnect()
		self._statsUpdatedConnection = nil
	end
end

function extended.render(props)
	local size = props.props.size
	local formFactor = props.props.formFactor
	local tabList = props.props.tabList

	local v = {
		{ key = "rttMs", format = "Round-trip time: %f", defaultValue = 0 },
		{ key = "incomingPackets", format = "Incoming Packets: %d", defaultValue = 0 },
		{ key = "outgoingPackets", format = "Outgoing Packets: %d", defaultValue = 0 },
		{ key = "incomingPacketsLost", format = "Incoming Packets Lost: %d", defaultValue = 0 },
		{ key = "outgoingPacketsLost", format = "Outgoing Packets Lost: %d", defaultValue = 0 }
	}

	local function renderStatLabels()
		local children = {}

		for i, v2 in ipairs(v) do
			children[i] = Roact.createElement("TextLabel", {
				LayoutOrder = i,
				Size = UDim2.fromOffset(200, 20),
				Text = string.format(v2.format, props.state.stats[v2.key] or v2.defaultValue),
				TextColor3 = Constants.Color.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1
			})
		end

		return Roact.createFragment(children)
	end

	return Roact.createElement("Frame", { Size = size, BackgroundTransparency = 1, LayoutOrder = 3 }, {
		UIListLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, MainRowPadding)
		}),
		FramePadding = Roact.createElement("UIPadding", { PaddingLeft = UDim.new(0, 16) }),
		UtilAndTab = Roact.createElement(UtilAndTab, {
			windowWidth = size.X.Offset,
			formFactor = formFactor,
			tabList = tabList,
			layoutOrder = 1,
			refForParent = props.utilRef
		}),
		StatsContainer = Roact.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Labels = renderStatLabels()
		})
	})
end

return DataConsumer(extended, "VoiceChatData")
