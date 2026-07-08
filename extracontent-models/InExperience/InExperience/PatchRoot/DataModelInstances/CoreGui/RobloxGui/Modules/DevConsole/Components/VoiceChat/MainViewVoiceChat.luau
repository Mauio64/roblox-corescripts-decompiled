local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local _ = script.Parent.Parent.Parent.Actions
local Components = script.Parent.Parent.Parent.Components
local DataConsumer = require(Components.DataConsumer)
local Constants = require(script.Parent.Parent.Parent.Constants)
local MainRowPadding = Constants.GeneralFormatting.MainRowPadding
local UtilAndTab = require(Components.UtilAndTab)
local v9 = Roact.PureComponent:extend("MainViewVoiceChat")

function v9.init(p1) -- line: 14
	-- upvalues: Roact (copy)
	function p1.onUtilTabHeightChanged(p2) -- line: 15
		-- upvalues: p1 (copy)
		p1:setState({
			utilTabHeight = p2
		})
	end
	function p1.onStatsUpdated(p3) -- line: 21
		-- upvalues: p1 (copy)
		p1:setState({
			stats = p3
		})
	end

	p1._statsUpdatedConnection = p1.props.VoiceChatData:Signal():Connect(p1.onStatsUpdated)
	p1.utilRef = Roact.createRef()
	p1.state = {
		utilTabHeight = 0,
		stats = {}
	}
end
function v9.didMount(p4) -- line: 38
	p4:setState({
		utilTabHeight = p4.utilRef.current.Size.Y.Offset
	})
end
function v9.didUpdate(p5) -- line: 45
	local currentSize = p5.utilRef.current.Size

	if currentSize.Y.Offset ~= p5.state.utilTabHeight then
		p5:setState({
			utilTabHeight = currentSize.Y.Offset
		})
	end
end
function v9.willUnmount(p6) -- line: 54
	if p6._statsUpdatedConnection then
		p6._statsUpdatedConnection:Disconnect()
		p6._statsUpdatedConnection = nil
	end
end
function v9.render(p7) -- line: 61
	-- upvalues: Roact (copy), Constants (copy), MainRowPadding (copy), UtilAndTab (copy)
	local size = p7.props.size
	local formFactor = p7.props.formFactor
	local tabList = p7.props.tabList
	local t1 = {
		{
			key = "rttMs",
			format = "Round-trip time: %f",
			defaultValue = 0
		},
		{
			key = "incomingPackets",
			format = "Incoming Packets: %d",
			defaultValue = 0
		},
		{
			key = "outgoingPackets",
			format = "Outgoing Packets: %d",
			defaultValue = 0
		},
		{
			key = "incomingPacketsLost",
			format = "Incoming Packets Lost: %d",
			defaultValue = 0
		},
		{
			key = "outgoingPacketsLost",
			format = "Outgoing Packets Lost: %d",
			defaultValue = 0
		}
	}

	local function renderStatLabels() -- line: 74
		-- upvalues: t1 (copy), Roact (copy), p7 (copy), Constants (copy)
		local t2 = {}

		for i, v in ipairs(t1) do
			t2[i] = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = i,
				Size = UDim2.fromOffset(200, 20),
				Text = string.format(v.format, p7.state.stats[v.key] or v.defaultValue),
				TextColor3 = Constants.Color.Text,
				TextXAlignment = Enum.TextXAlignment.Left
			})
		end

		return Roact.createFragment(t2)
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 3,
		Size = size
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, MainRowPadding)
		}),
		FramePadding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 16)
		}),
		UtilAndTab = Roact.createElement(UtilAndTab, {
			layoutOrder = 1,
			windowWidth = size.X.Offset,
			formFactor = formFactor,
			tabList = tabList,
			refForParent = p7.utilRef
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

return DataConsumer(v9, "VoiceChatData")
