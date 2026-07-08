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
local t1 = {
	"Active",
	"Inactive"
}
local v12 = Roact.PureComponent:extend("MainViewScripts")

function v12.init(p1) -- line: 22
	-- upvalues: Roact (copy)
	function p1.onUtilTabHeightChanged(p2) -- line: 23
		-- upvalues: p1 (copy)
		p1:setState({
			utilTabHeight = p2
		})
	end
	function p1.onCheckboxChanged(p3, p4) -- line: 29
		-- upvalues: p1 (copy)
		local t2 = {
			[p3] = p4
		}

		p1.props.dispatchServerScriptsUpdateSearchFilter(nil, t2)
	end
	function p1.onSearchTermChanged(p5) -- line: 36
		-- upvalues: p1 (copy)
		p1.props.dispatchServerScriptsUpdateSearchFilter(p5, {})
	end

	p1.utilRef = Roact.createRef()
	p1.state = {
		utilTabHeight = 0,
		isClientView = true
	}
end
function v12.didMount(p6) -- line: 48
	p6:setState({
		utilTabHeight = p6.utilRef.current.Size.Y.Offset
	})
end
function v12.didUpdate(p7) -- line: 55
	local currentSize = p7.utilRef.current.Size

	if currentSize.Y.Offset ~= p7.state.utilTabHeight then
		p7:setState({
			utilTabHeight = currentSize.Y.Offset
		})
	end
end
function v12.render(p8) -- line: 64
	-- upvalues: t1 (copy), Roact (copy), Constants (copy), MainRowPadding (copy), UtilAndTab (copy), ServerScripts (copy)
	local size = p8.props.size
	local formFactor = p8.props.formFactor
	local tabList = p8.props.tabList
	local serverTypeFilters = p8.props.serverTypeFilters
	local utilTabHeight = p8.state.utilTabHeight
	local serverSearchTerm = p8.props.serverSearchTerm
	local t3 = {}

	for i, v in ipairs(t1) do
		local v29 = serverTypeFilters[v]

		if v29 == nil then
			v29 = true
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
			searchTerm = serverSearchTerm,
			refForParent = p8.utilRef,
			onHeightChanged = p8.onUtilTabHeightChanged,
			onCheckboxChanged = p8.onCheckboxChanged,
			onSearchTermChanged = p8.onSearchTermChanged
		}),
		ServerScripts = utilTabHeight > 0 and Roact.createElement(ServerScripts, {
			layoutOrder = 2,
			size = UDim2.new(1, 0, 1, -utilTabHeight),
			searchTerm = serverSearchTerm,
			scriptFilters = serverTypeFilters
		})
	})
end

local function mapStateToProps(p9, _) -- line: 121
	return {
		serverSearchTerm = p9.ScriptsData.serverSearchTerm,
		serverTypeFilters = p9.ScriptsData.serverTypeFilters
	}
end
local function mapDispatchToProps(p11) -- line: 128
	-- upvalues: ServerScriptsUpdateSearchFilter (copy)
	return {
		dispatchServerScriptsUpdateSearchFilter = function(p12, p13) -- line: 130
			-- upvalues: p11 (copy), ServerScriptsUpdateSearchFilter (copy)
			p11(ServerScriptsUpdateSearchFilter(p12, p13))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(v12)
