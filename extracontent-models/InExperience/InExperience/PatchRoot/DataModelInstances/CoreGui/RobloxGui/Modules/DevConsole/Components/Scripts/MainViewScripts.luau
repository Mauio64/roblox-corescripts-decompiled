local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local Components = script.Parent.Parent.Parent.Components
local ServerScripts = require(Components.Scripts.ServerScripts)
local UtilAndTab = require(Components.UtilAndTab)

local Actions = script.Parent.Parent.Parent.Actions
local ServerScriptsUpdateSearchFilter = require(Actions.ServerScriptsUpdateSearchFilter)

local Constants = require(script.Parent.Parent.Parent.Constants)
local MainRowPadding = Constants.GeneralFormatting.MainRowPadding

local v = { "Active", "Inactive" }

local extended = Roact.PureComponent:extend("MainViewScripts")

function extended:init()
	function self.onUtilTabHeightChanged(utilTabHeight)
		self:setState({ utilTabHeight = utilTabHeight })
	end

	function self.onCheckboxChanged(p, p2)
		local v2 = { [p] = p2 }

		self.props.dispatchServerScriptsUpdateSearchFilter(nil, v2)
	end

	function self.onSearchTermChanged(p)
		self.props.dispatchServerScriptsUpdateSearchFilter(p, {})
	end

	self.utilRef = Roact.createRef()

	self.state = { utilTabHeight = 0, isClientView = true }
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
	local serverTypeFilters = props.props.serverTypeFilters

	local utilTabHeight = props.state.utilTabHeight

	local serverSearchTerm = props.props.serverSearchTerm

	local orderedCheckboxState = {}

	for i, name in ipairs(v) do
		local serverTypeFilter = serverTypeFilters[name]
		orderedCheckboxState[i] = {
			name = name,
			state = serverTypeFilter == nil or serverTypeFilter
		}
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
				searchTerm = serverSearchTerm,
				layoutOrder = 1,
				refForParent = props.utilRef,
				onHeightChanged = props.onUtilTabHeightChanged,
				onCheckboxChanged = props.onCheckboxChanged,
				onSearchTermChanged = props.onSearchTermChanged
			}),
			ServerScripts = utilTabHeight > 0 and Roact.createElement(ServerScripts, {
				size = UDim2.new(1, 0, 1, -utilTabHeight),
				searchTerm = serverSearchTerm,
				scriptFilters = serverTypeFilters,
				layoutOrder = 2
			})
		}
	)
end

local function mapStateToProps(p, _)
	return {
		serverSearchTerm = p.ScriptsData.serverSearchTerm,
		serverTypeFilters = p.ScriptsData.serverTypeFilters
	}
end

local function mapDispatchToProps(callback)
	return {
		dispatchServerScriptsUpdateSearchFilter = function(p, p2)
			callback(ServerScriptsUpdateSearchFilter(p, p2))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(extended)
