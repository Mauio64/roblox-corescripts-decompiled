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

local extended = Roact.Component:extend("MainViewServerJobs")

function extended:init()
	function self.onUtilTabHeightChanged(utilTabHeight)
		self:setState({ utilTabHeight = utilTabHeight })
	end

	function self.onSearchTermChanged(p)
		self.props.dispatchServerJobsUpdateSearchFilter(p, {})
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
	local jobsSearchTerm = props.props.jobsSearchTerm

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
				searchTerm = jobsSearchTerm,
				layoutOrder = 1,
				refForParent = props.utilRef,
				onHeightChanged = props.onUtilTabHeightChanged,
				onSearchTermChanged = props.onSearchTermChanged
			}),
			ServerJobs = utilTabHeight > 0 and Roact.createElement(ServerJobsChart, {
				size = UDim2.new(1, 0, 1, -utilTabHeight),
				searchTerm = jobsSearchTerm,
				layoutOrder = 2
			})
		}
	)
end

local function mapStateToProps(p, _)
	return { jobsSearchTerm = p.ServerJobsData.jobsSearchTerm }
end

local function mapDispatchToProps(callback)
	return {
		dispatchServerJobsUpdateSearchFilter = function(p, p2)
			callback(ServerJobsUpdateSearchFilter(p, p2))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(extended)
