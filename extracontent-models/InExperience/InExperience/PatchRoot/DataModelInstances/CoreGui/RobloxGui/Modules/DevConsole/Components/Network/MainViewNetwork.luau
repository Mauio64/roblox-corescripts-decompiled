local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Components = script.Parent.Parent.Parent.Components
local ClientNetwork = require(Components.Network.ClientNetwork)
local ServerNetwork = require(Components.Network.ServerNetwork)
local UtilAndTab = require(Components.UtilAndTab)
local Actions = script.Parent.Parent.Parent.Actions
local ClientNetworkUpdateSearchFilter = require(Actions.ClientNetworkUpdateSearchFilter)
local ServerNetworkUpdateSearchFilter = require(Actions.ServerNetworkUpdateSearchFilter)
local SetActiveTab = require(Actions.SetActiveTab)
local Constants = require(script.Parent.Parent.Parent.Constants)
local MainRowPadding = Constants.GeneralFormatting.MainRowPadding
local v14 = Roact.Component:extend("MainViewNetwork")

function v14.init(p1) -- line: 20
	-- upvalues: Roact (copy)
	function p1.onUtilTabHeightChanged(p2) -- line: 21
		-- upvalues: p1 (copy)
		p1:setState({
			utilTabHeight = p2
		})
	end
	function p1.onClientButton() -- line: 27
		-- upvalues: p1 (copy)
		p1.props.dispatchSetActiveTab("Network", true)
	end
	function p1.onServerButton() -- line: 31
		-- upvalues: p1 (copy)
		p1.props.dispatchSetActiveTab("Network", false)
	end
	function p1.onSearchTermChanged(p3) -- line: 35
		-- upvalues: p1 (copy)
		if p1.props.isClientView then
			p1.props.dispatchClientNetworkUpdateSearchFilter(p3, {})

			return
		end

		p1.props.dispatchServerNetworkUpdateSearchFilter(p3, {})
	end

	p1.utilRef = Roact.createRef()
	p1.state = {
		utilTabHeight = 0
	}
end
function v14.didMount(p4) -- line: 50
	p4:setState({
		utilTabHeight = p4.utilRef.current.Size.Y.Offset
	})
end
function v14.didUpdate(p5) -- line: 57
	local currentSize = p5.utilRef.current.Size

	if currentSize.Y.Offset ~= p5.state.utilTabHeight then
		p5:setState({
			utilTabHeight = currentSize.Y.Offset
		})
	end
end
function v14.render(p6) -- line: 66
	-- upvalues: Roact (copy), MainRowPadding (copy), UtilAndTab (copy), ClientNetwork (copy), ServerNetwork (copy), Constants (copy)
	local t1 = {}
	local size = p6.props.size
	local formFactor = p6.props.formFactor
	local tabList = p6.props.tabList
	local isClientView = p6.props.isClientView
	local utilTabHeight = p6.state.utilTabHeight
	local v28 = isClientView and p6.props.clientSearchTerm or p6.props.serverSearchTerm

	t1.UIListLayout = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, MainRowPadding)
	})
	t1.UtilAndTab = Roact.createElement(UtilAndTab, {
		layoutOrder = 1,
		windowWidth = size.X.Offset,
		formFactor = formFactor,
		tabList = tabList,
		isClientView = isClientView,
		searchTerm = v28,
		refForParent = p6.utilRef,
		onHeightChanged = p6.onUtilTabHeightChanged,
		onClientButton = p6.onClientButton,
		onServerButton = p6.onServerButton,
		onSearchTermChanged = p6.onSearchTermChanged
	})

	if utilTabHeight > 0 then
		if isClientView then
			t1.ClientNetwork = Roact.createElement(ClientNetwork, {
				layoutOrder = 2,
				size = UDim2.new(1, 0, 1, -utilTabHeight),
				searchTerm = v28
			})
		else
			t1.ServerNetwork = Roact.createElement(ServerNetwork, {
				layoutOrder = 2,
				size = UDim2.new(1, 0, 1, -utilTabHeight),
				searchTerm = v28
			})
		end
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 3,
		Size = size,
		BackgroundColor3 = Constants.Color.BaseGray
	}, t1)
end

local function mapStateToProps(p7, _) -- line: 121
	return {
		isClientView = p7.MainView.isClientView,
		clientSearchTerm = p7.NetworkData.clientSearchTerm,
		serverSearchTerm = p7.NetworkData.serverSearchTerm
	}
end
local function mapDispatchToProps(p9) -- line: 129
	-- upvalues: ClientNetworkUpdateSearchFilter (copy), ServerNetworkUpdateSearchFilter (copy), SetActiveTab (copy)
	return {
		dispatchClientNetworkUpdateSearchFilter = function(p10, p11) -- line: 131
			-- upvalues: p9 (copy), ClientNetworkUpdateSearchFilter (copy)
			p9(ClientNetworkUpdateSearchFilter(p10, p11))
		end,
		dispatchServerNetworkUpdateSearchFilter = function(p12, p13) -- line: 135
			-- upvalues: p9 (copy), ServerNetworkUpdateSearchFilter (copy)
			p9(ServerNetworkUpdateSearchFilter(p12, p13))
		end,
		dispatchSetActiveTab = function(p14, p15) -- line: 138
			-- upvalues: p9 (copy), SetActiveTab (copy)
			p9(SetActiveTab(p14, p15))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(v14)
