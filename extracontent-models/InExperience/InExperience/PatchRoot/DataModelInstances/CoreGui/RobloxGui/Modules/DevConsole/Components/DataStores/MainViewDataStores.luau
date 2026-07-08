local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Components = script.Parent.Parent.Parent.Components
local DataStoresChart = require(Components.DataStores.DataStoresChart)
local UtilAndTab = require(Components.UtilAndTab)
local Actions = script.Parent.Parent.Parent.Actions
local DataStoresUpdateSearchFilter = require(Actions.DataStoresUpdateSearchFilter)
local Constants = require(script.Parent.Parent.Parent.Constants)
local MainRowPadding = Constants.GeneralFormatting.MainRowPadding
local v11 = Roact.PureComponent:extend("MainViewDataStores")

function v11.init(p1) -- line: 17
	-- upvalues: Roact (copy)
	function p1.onUtilTabHeightChanged(p2) -- line: 18
		-- upvalues: p1 (copy)
		p1:setState({
			utilTabHeight = p2
		})
	end
	function p1.onSearchTermChanged(p3) -- line: 24
		-- upvalues: p1 (copy)
		p1.props.dispatchDataStoresUpdateSearchFilter(p3, {})
	end

	p1.utilRef = Roact.createRef()
	p1.state = {
		utilTabHeight = 0
	}
end
function v11.didMount(p4) -- line: 35
	p4:setState({
		utilTabHeight = p4.utilRef.current.Size.Y.Offset
	})
end
function v11.didUpdate(p5) -- line: 42
	local currentSize = p5.utilRef.current.Size

	if currentSize.Y.Offset ~= p5.state.utilTabHeight then
		p5:setState({
			utilTabHeight = currentSize.Y.Offset
		})
	end
end
function v11.render(p6) -- line: 51
	-- upvalues: Roact (copy), Constants (copy), MainRowPadding (copy), UtilAndTab (copy), DataStoresChart (copy)
	local size = p6.props.size
	local formFactor = p6.props.formFactor
	local tabList = p6.props.tabList
	local storesSearchTerm = p6.props.storesSearchTerm
	local utilTabHeight = p6.state.utilTabHeight

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
			searchTerm = storesSearchTerm,
			refForParent = p6.utilRef,
			onHeightChanged = p6.onUtilTabHeightChanged,
			onSearchTermChanged = p6.onSearchTermChanged
		}),
		DataStores = utilTabHeight > 0 and Roact.createElement(DataStoresChart, {
			layoutOrder = 2,
			size = UDim2.new(1, 0, 1, -utilTabHeight),
			searchTerm = storesSearchTerm
		})
	})
end

local function mapStateToProps(p7, _) -- line: 91
	return {
		storesSearchTerm = p7.DataStoresData.storesSearchTerm
	}
end
local function mapDispatchToProps(p9) -- line: 97
	-- upvalues: DataStoresUpdateSearchFilter (copy)
	return {
		dispatchDataStoresUpdateSearchFilter = function(p10, p11) -- line: 99
			-- upvalues: p9 (copy), DataStoresUpdateSearchFilter (copy)
			p9(DataStoresUpdateSearchFilter(p10, p11))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(v11)
