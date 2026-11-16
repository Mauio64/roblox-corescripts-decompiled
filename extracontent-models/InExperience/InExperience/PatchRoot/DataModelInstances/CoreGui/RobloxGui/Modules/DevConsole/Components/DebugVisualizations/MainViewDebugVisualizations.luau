local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local Components = script.Parent.Parent.Parent.Components
local DebugVisualizationsChart = require(Components.DebugVisualizations.DebugVisualizationsChart)
local UtilAndTab = require(Components.UtilAndTab)

local Actions = script.Parent.Parent.Parent.Actions
local DebugVisualizationsUpdateSearchFilter = require(Actions.DebugVisualizationsUpdateSearchFilter)

local Constants = require(script.Parent.Parent.Parent.Constants)
local MainRowPadding = Constants.GeneralFormatting.MainRowPadding

local v = { "Performance", "Behavior", "Constraints", "Forces", "Networking", "Collision" }

local extended = Roact.Component:extend("MainViewDebugVisualizations")

function extended:init()
	function self.onUtilTabHeightChanged(utilTabHeight)
		self:setState({ utilTabHeight = utilTabHeight })
	end

	function self.onCheckboxChanged(p, p2)
		local v2 = {}
		v2[p] = p2
		self.props.dispatchDebugVisualizationsUpdateSearchFilter(nil, v2)
	end

	function self.onSearchTermChanged(p)
		self.props.dispatchDebugVisualizationsUpdateSearchFilter(p, {})
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
	local debugVisualizationsSearchTerm = props.props.debugVisualizationsSearchTerm
	local debugVisualizationsTypeFilters = props.props.debugVisualizationsTypeFilters

	local utilTabHeight = props.state.utilTabHeight

	local orderedCheckboxState = {}

	for i, name in ipairs(v) do
		local state = debugVisualizationsTypeFilters[name]

		if state == nil then
			state = false
		end

		orderedCheckboxState[i] = { name = name, state = state }
	end

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
				orderedCheckboxState = orderedCheckboxState,
				searchTerm = debugVisualizationsSearchTerm,
				layoutOrder = 1,
				refForParent = props.utilRef,
				onHeightChanged = props.onUtilTabHeightChanged,
				onCheckboxChanged = props.onCheckboxChanged,
				onSearchTermChanged = props.onSearchTermChanged
			}),
			DebugVisualizations = utilTabHeight > 0 and Roact.createElement(DebugVisualizationsChart, {
				size = UDim2.new(1, 0, 1, -utilTabHeight),
				searchTerm = debugVisualizationsSearchTerm,
				typeFilters = debugVisualizationsTypeFilters,
				layoutOrder = 2
			})
		}
	)
end

local function mapStateToProps(p, _)
	return {
		debugVisualizationsSearchTerm = p.DebugVisualizationsData.debugVisualizationsSearchTerm,
		debugVisualizationsTypeFilters = p.DebugVisualizationsData.debugVisualizationsTypeFilters
	}
end

local function mapDispatchToProps(callback)
	return {
		dispatchDebugVisualizationsUpdateSearchFilter = function(p, p2)
			callback(DebugVisualizationsUpdateSearchFilter(p, p2))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(extended)
