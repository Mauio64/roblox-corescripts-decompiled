local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Components = script.Parent.Parent.Parent.Components
local ServerJobsChart = require(Components.ServerJobs.ServerJobsChart)
local UtilAndTab = require(Components.UtilAndTab)
local Actions = script.Parent.Parent.Parent.Actions
local ServerJobsUpdateSearchFilter = require(Actions.ServerJobsUpdateSearchFilter)
local Constants = require(script.Parent.Parent.Parent.Constants)
local MainRowPadding = Constants.GeneralFormatting.MainRowPadding
local v11 = Roact.Component:extend("MainViewServerJobs")

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
		p1.props.dispatchServerJobsUpdateSearchFilter(p3, {})
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
	-- upvalues: Roact (copy), Constants (copy), MainRowPadding (copy), UtilAndTab (copy), ServerJobsChart (copy)
	local size = p6.props.size
	local formFactor = p6.props.formFactor
	local tabList = p6.props.tabList
	local jobsSearchTerm = p6.props.jobsSearchTerm
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
			searchTerm = jobsSearchTerm,
			refForParent = p6.utilRef,
			onHeightChanged = p6.onUtilTabHeightChanged,
			onSearchTermChanged = p6.onSearchTermChanged
		}),
		ServerJobs = utilTabHeight > 0 and Roact.createElement(ServerJobsChart, {
			layoutOrder = 2,
			size = UDim2.new(1, 0, 1, -utilTabHeight),
			searchTerm = jobsSearchTerm
		})
	})
end

local function mapStateToProps(p7, _) -- line: 91
	return {
		jobsSearchTerm = p7.ServerJobsData.jobsSearchTerm
	}
end
local function mapDispatchToProps(p9) -- line: 97
	-- upvalues: ServerJobsUpdateSearchFilter (copy)
	return {
		dispatchServerJobsUpdateSearchFilter = function(p10, p11) -- line: 99
			-- upvalues: p9 (copy), ServerJobsUpdateSearchFilter (copy)
			p9(ServerJobsUpdateSearchFilter(p10, p11))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(v11)
