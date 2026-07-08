local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Components = script.Parent.Parent.Parent.Components
local ClientLog = require(Components.Log.ClientLog)
local ServerLog = require(Components.Log.ServerLog)
local UtilAndTab = require(Components.UtilAndTab)
local DataConsumer = require(Components.DataConsumer)
local Actions = script.Parent.Parent.Parent.Actions
local SetActiveTab = require(Actions.SetActiveTab)
local Constants = require(script.Parent.Parent.Parent.Constants)
local MainRowPadding = Constants.GeneralFormatting.MainRowPadding
local MsgTypeNamesOrdered = Constants.MsgTypeNamesOrdered
local v14 = Roact.PureComponent:extend("MainViewLog")

function v14.init(p1) -- line: 21
	-- upvalues: Roact (copy)
	function p1.onUtilTabHeightChanged(p2) -- line: 22
		-- upvalues: p1 (copy)
		p1:setState({
			utilTabHeight = p2
		})
	end
	function p1.onClientButton() -- line: 28
		-- upvalues: p1 (copy)
		p1.props.dispatchSetActiveTab("Log", true)
	end
	function p1.onServerButton() -- line: 32
		-- upvalues: p1 (copy)
		p1.props.dispatchSetActiveTab("Log", false)
	end
	function p1.onCheckboxChanged(p3, p4) -- line: 36
		-- upvalues: p1 (copy)
		if p1.props.isClientView then
			p1.props.ClientLogData:setFilter(p3, p4)

			return
		end

		p1.props.ServerLogData:setFilter(p3, p4)
	end
	function p1.filterUpdated() -- line: 44
		-- upvalues: p1 (copy)
		if p1.forceUpdate then
			p1:forceUpdate()

			return
		end

		p1:setState({})
	end
	function p1.onSearchTermChanged(p5) -- line: 52
		-- upvalues: p1 (copy)
		if p1.props.isClientView then
			p1.props.ClientLogData:setSearchTerm(p5)

			return
		end

		p1.props.ServerLogData:setSearchTerm(p5)
	end

	p1.clientFilterConnection = p1.props.ClientLogData:filterUpdatedSignal():Connect(p1.filterUpdated)
	p1.serverFilterConnection = p1.props.ServerLogData:filterUpdatedSignal():Connect(p1.filterUpdated)
	p1.utilRef = Roact.createRef()
	p1.state = {
		utilTabHeight = 0
	}
end
function v14.didMount(p6) -- line: 73
	p6:setState({
		utilTabHeight = p6.utilRef.current.Size.Y.Offset
	})
end
function v14.didUpdate(p7) -- line: 80
	local currentSize = p7.utilRef.current.Size

	if currentSize.Y.Offset ~= p7.state.utilTabHeight then
		p7:setState({
			utilTabHeight = currentSize.Y.Offset
		})
	end
end
function v14.willUnmount(p8) -- line: 89
	if p8.clientFilterConnection then
		p8.clientFilterConnection:Disconnect()
		p8.clientFilterConnection = nil
	end

	if p8.serverFilterConnection then
		p8.serverFilterConnection:Disconnect()
		p8.serverFilterConnection = nil
	end
end
function v14.render(p9) -- line: 100
	-- upvalues: Roact (copy), MainRowPadding (copy), MsgTypeNamesOrdered (copy), UtilAndTab (copy), ClientLog (copy), ServerLog (copy), Constants (copy)
	local size = p9.props.size
	local formFactor = p9.props.formFactor
	local isDeveloperView = p9.props.isDeveloperView
	local tabList = p9.props.tabList
	local isClientView = p9.props.isClientView
	local utilTabHeight = p9.state.utilTabHeight
	local v29 = if not isClientView then p9.props.ServerLogData:getSearchTerm() else p9.props.ClientLogData:getSearchTerm()
	local t1 = {
		UIListLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, MainRowPadding)
		})
	}
	local v31 = if not isClientView then p9.props.ServerLogData:getFilters() else p9.props.ClientLogData:getFilters()
	local t2 = {}

	for i, v in ipairs(MsgTypeNamesOrdered) do
		t2[i] = {
			name = v,
			state = v31[v]
		}
	end

	t1.UtilAndTab = Roact.createElement(UtilAndTab, {
		layoutOrder = 1,
		windowWidth = size.X.Offset,
		formFactor = formFactor,
		tabList = tabList,
		orderedCheckboxState = t2,
		isClientView = isClientView,
		searchTerm = v29,
		refForParent = p9.utilRef,
		onClientButton = isDeveloperView and p9.onClientButton,
		onServerButton = isDeveloperView and p9.onServerButton,
		onCheckboxChanged = p9.onCheckboxChanged,
		onSearchTermChanged = p9.onSearchTermChanged
	})

	if utilTabHeight > 0 then
		if isClientView then
			t1.ClientLog = Roact.createElement(ClientLog, {
				layoutOrder = 2,
				size = UDim2.new(1, 0, 1, -utilTabHeight)
			})
		else
			t1.ServerLog = Roact.createElement(ServerLog, {
				layoutOrder = 2,
				size = UDim2.new(1, 0, 1, -utilTabHeight)
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

local function mapStateToProps(p10, _) -- line: 177
	return {
		isClientView = p10.MainView.isClientView
	}
end
local function mapDispatchToProps(p12) -- line: 183
	-- upvalues: SetActiveTab (copy)
	return {
		dispatchSetActiveTab = function(p13, p14) -- line: 185
			-- upvalues: p12 (copy), SetActiveTab (copy)
			p12(SetActiveTab(p13, p14))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(DataConsumer(v14, "ClientLogData", "ServerLogData"))
