local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local Components = script.Parent.Parent.Parent.Components
local ServerStatsChart = require(Components.ServerStats.ServerStatsChart)
local UtilAndTab = require(Components.UtilAndTab)

local Actions = script.Parent.Parent.Parent.Actions
local ServerStatsUpdateSearchFilter = require(Actions.ServerStatsUpdateSearchFilter)

local Constants = require(script.Parent.Parent.Parent.Constants)
local MainRowPadding = Constants.GeneralFormatting.MainRowPadding

local extended = Roact.Component:extend("MainViewServerStats")

function extended:init()
	function self.onUtilTabHeightChanged(utilTabHeight)
		self:setState({ utilTabHeight = utilTabHeight })
	end

	function self.onSearchTermChanged(p)
		self.props.dispatchServerStatsUpdateSearchFilter(p, {})
	end

	self.utilRef = Roact.createRef()

	self.state = { utilTabHeight = 0 }
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

function extended.render(props)
	local size = props.props.size
	local formFactor = props.props.formFactor
	local tabList = props.props.tabList
	local statsSearchTerm = props.props.statsSearchTerm

	local utilTabHeight = props.state.utilTabHeight

	return Roact.createElement(
		"Frame",
		{
			Size = size,
			BackgroundColor3 = Constants.Color.BaseGray,
			BackgroundTransparency = 1,
			LayoutOrder = 3
		},
		{
			UIListLayout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, MainRowPadding),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			UtilAndTab = Roact.createElement(UtilAndTab, {
				windowWidth = size.X.Offset,
				formFactor = formFactor,
				tabList = tabList,
				searchTerm = statsSearchTerm,
				layoutOrder = 1,
				refForParent = props.utilRef,
				onHeightChanged = props.onUtilTabHeightChanged,
				onSearchTermChanged = props.onSearchTermChanged
			}),
			ServerStats = utilTabHeight > 0 and Roact.createElement(ServerStatsChart, {
				size = UDim2.new(1, 0, 1, -utilTabHeight),
				searchTerm = statsSearchTerm,
				layoutOrder = 2
			})
		}
	)
end

local function mapStateToProps(p, _)
	return { statsSearchTerm = p.ServerStatsData.statsSearchTerm }
end

local function mapDispatchToProps(callback)
	return {
		dispatchServerStatsUpdateSearchFilter = function(p, p2)
			callback(ServerStatsUpdateSearchFilter(p, p2))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(extended)
