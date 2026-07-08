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
local t1 = {
	"Performance",
	"Behavior",
	"Constraints",
	"Forces",
	"Networking",
	"Collision"
}
local v12 = Roact.Component:extend("MainViewDebugVisualizations")

function v12.init(p1) -- line: 26
	-- upvalues: Roact (copy)
	function p1.onUtilTabHeightChanged(p2) -- line: 27
		-- upvalues: p1 (copy)
		p1:setState({
			utilTabHeight = p2
		})
	end
	function p1.onCheckboxChanged(p3, p4) -- line: 33
		-- upvalues: p1 (copy)
		local t2 = {
			[p3] = p4
		}

		p1.props.dispatchDebugVisualizationsUpdateSearchFilter(nil, t2)
	end
	function p1.onSearchTermChanged(p5) -- line: 39
		-- upvalues: p1 (copy)
		p1.props.dispatchDebugVisualizationsUpdateSearchFilter(p5, {})
	end

	p1.utilRef = Roact.createRef()
	p1.state = {
		utilTabHeight = 0
	}
end
function v12.didMount(p6) -- line: 50
	p6:setState({
		utilTabHeight = p6.utilRef.current.Size.Y.Offset
	})
end
function v12.didUpdate(p7) -- line: 57
	local currentSize = p7.utilRef.current.Size

	if currentSize.Y.Offset ~= p7.state.utilTabHeight then
		p7:setState({
			utilTabHeight = currentSize.Y.Offset
		})
	end
end
function v12.render(p8) -- line: 66
	-- upvalues: t1 (copy), Roact (copy), Constants (copy), MainRowPadding (copy), UtilAndTab (copy), DebugVisualizationsChart (copy)
	local size = p8.props.size
	local formFactor = p8.props.formFactor
	local tabList = p8.props.tabList
	local debugVisualizationsSearchTerm = p8.props.debugVisualizationsSearchTerm
	local debugVisualizationsTypeFilters = p8.props.debugVisualizationsTypeFilters
	local utilTabHeight = p8.state.utilTabHeight
	local t3 = {}

	for i, v in ipairs(t1) do
		local v29 = debugVisualizationsTypeFilters[v]

		if v29 == nil then
			v29 = false
		end

		t3[i] = {
			name = v,
			state = v29
		}
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 3,
		Size = size,
		BackgroundColor3 = Constants.Color.BaseGray
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, MainRowPadding),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		UtilAndTab = Roact.createElement(UtilAndTab, {
			layoutOrder = 1,
			windowWidth = size.X.Offset,
			formFactor = formFactor,
			tabList = tabList,
			orderedCheckboxState = t3,
			searchTerm = debugVisualizationsSearchTerm,
			refForParent = p8.utilRef,
			onHeightChanged = p8.onUtilTabHeightChanged,
			onCheckboxChanged = p8.onCheckboxChanged,
			onSearchTermChanged = p8.onSearchTermChanged
		}),
		DebugVisualizations = utilTabHeight > 0 and Roact.createElement(DebugVisualizationsChart, {
			layoutOrder = 2,
			size = UDim2.new(1, 0, 1, -utilTabHeight),
			searchTerm = debugVisualizationsSearchTerm,
			typeFilters = debugVisualizationsTypeFilters
		})
	})
end

local function mapStateToProps(p9, _) -- line: 121
	return {
		debugVisualizationsSearchTerm = p9.DebugVisualizationsData.debugVisualizationsSearchTerm,
		debugVisualizationsTypeFilters = p9.DebugVisualizationsData.debugVisualizationsTypeFilters
	}
end
local function mapDispatchToProps(p11) -- line: 128
	-- upvalues: DebugVisualizationsUpdateSearchFilter (copy)
	return {
		dispatchDebugVisualizationsUpdateSearchFilter = function(p12, p13) -- line: 130
			-- upvalues: p11 (copy), DebugVisualizationsUpdateSearchFilter (copy)
			p11(DebugVisualizationsUpdateSearchFilter(p12, p13))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(v12)
