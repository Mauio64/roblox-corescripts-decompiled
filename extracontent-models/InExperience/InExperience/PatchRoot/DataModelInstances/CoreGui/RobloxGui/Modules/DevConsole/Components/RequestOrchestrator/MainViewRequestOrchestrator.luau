local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")

local Roact = require(CorePackages.Packages.Roact)

local parent = script.Parent.Parent
local UtilAndTab = require(parent.UtilAndTab)
local DropDown = require(parent.DropDown)

local OrchestratorRow = require(script.Parent.OrchestratorRow)
local RequestOrchestratorData = require(script.Parent.RequestOrchestratorData)

local Constants = require(script.Parent.Parent.Parent.Constants)
local MainRowPadding = Constants.GeneralFormatting.MainRowPadding
local Mono = Constants.Font.Mono

local color = Color3.fromRGB(220, 220, 220)

local v = {
	BatchCreated = { RequestOrchestratorData.registerBatch, RequestOrchestratorData.trackQueueOnCreated },
	BatchSent = { RequestOrchestratorData.openSendAttempt, RequestOrchestratorData.drainQueueOnSent },
	BatchResponseReceived = { RequestOrchestratorData.settleBatch },
	BatchRetrying = { RequestOrchestratorData.reclassifyOnRetry, RequestOrchestratorData.requeueRetryOps },
	BatchExhausted = { RequestOrchestratorData.markExhausted, RequestOrchestratorData.clearQueueOnExhausted },
	OperationEnqueued = { RequestOrchestratorData.enqueueOperation },
	CacheItemAdded = { RequestOrchestratorData.recordCacheItemAdded },
	CacheHit = { RequestOrchestratorData.recordCacheHit }
}

local function makeLabel(text, layoutOrder)
	return Roact.createElement("TextLabel", {
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 0, 22),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = color,
		TextSize = 11,
		Font = Mono,
		TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = layoutOrder
	})
end

local function cloneSet(selectedTypes) -- 3 equivalent calls inferred from this helper
	local set = {}

	for k, item in pairs(selectedTypes) do
		set[k] = item
	end

	return set
end

local extended = Roact.Component:extend("MainViewRequestOrchestrator")

function extended:init()
	self.model = RequestOrchestratorData.new()
	self.connections = {}
	self.utilRef = Roact.createRef()

	function self.onUtilTabHeightChanged(utilTabHeight)
		self:setState({ utilTabHeight = utilTabHeight })
	end

	function self.onTypeToggle(p)
		local set = cloneSet(self.state.selectedTypes) -- inferred equivalent call
		set[p] = not set[p] or nil
		self:setState({ selectedTypes = set })
	end

	self.state = { utilTabHeight = 0, selectedTypes = {} }
end

function extended.observeType(object, p)
	local v2 = RequestOrchestratorData.observeType(object.model, p)

	if v2 then
		local set = cloneSet(object.state.selectedTypes) -- inferred equivalent call
		set[v2] = true
		object:setState({ selectedTypes = set })
	end
end

function extended:didMount()
	self:setState({ utilTabHeight = self.utilRef.current.Size.Y.Offset })

	local RequestOrchestratorService = game:GetService("RequestOrchestratorService")

	local success, result = pcall(function()
		return RequestOrchestratorService:GetRegisteredOrchestrators()
	end)

	if success and result then
		local v2 = RequestOrchestratorData.observeTypes(self.model, result)

		if #v2 > 0 then
			local set = cloneSet(self.state.selectedTypes) -- inferred equivalent call

			for _, v3 in ipairs(v2) do
				set[v3] = true
			end

			self:setState({ selectedTypes = set })
		end
	end

	for k, list in pairs(v) do
		self.connections[k] = RequestOrchestratorService[k]:Connect(function(p)
			local orchestratorType = p.orchestratorType or "Unknown"
			self:observeType(orchestratorType)

			for _, item in ipairs(list) do
				item(self.model, orchestratorType, p)
			end

			self:setState({})
		end)
	end

	self.connections.heartbeat = RunService.Heartbeat:Connect(function()
		RequestOrchestratorData.advanceTime(self.model)
		self:setState({})
	end)
end

function extended:willUnmount()
	for _, connection in pairs(self.connections) do
		connection:Disconnect()
	end

	self.connections = {}
end

function extended.didUpdate(object)
	local offset = object.utilRef.current.Size.Y.Offset

	if offset ~= object.state.utilTabHeight then
		object:setState({ utilTabHeight = offset })
	end
end

function extended.render(props)
	local size = props.props.size
	local formFactor = props.props.formFactor
	local tabList = props.props.tabList
	local utilTabHeight = props.state.utilTabHeight
	local selectedTypes = props.state.selectedTypes
	local allTypes = props.model.allTypes

	local children = {}

	children.UIListLayout = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, MainRowPadding)
	})

	children.UtilAndTab = Roact.createElement(UtilAndTab, {
		windowWidth = size.X.Offset,
		formFactor = formFactor,
		tabList = tabList,
		layoutOrder = 1,
		refForParent = props.utilRef,
		onHeightChanged = props.onUtilTabHeightChanged
	})

	if utilTabHeight > 0 then
		local count = 0
		local summaryText = nil

		for i, allType in ipairs(allTypes) do
			if not selectedTypes[i] then
				continue
			end

			count += 1
			summaryText = allType
		end

		if #allTypes == 0 then
			summaryText = "(waiting for traffic)"
		elseif count == 0 then
			summaryText = "(none)"
		elseif count ~= 1 then
			if count == #allTypes then
				summaryText = string.format("All (%d)", count)
			else
				summaryText = string.format("%d selected", count)
			end
		end

		children.Controls = Roact.createElement(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, LayoutOrder = 2 },
			{
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 4),
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				ShowLabel = makeLabel("Show", 1),
				TypeDropDown = Roact.createElement(DropDown, {
					buttonSize = UDim2.new(0, 220, 0, 22),
					dropDownList = allTypes,
					selectedSet = selectedTypes,
					onToggle = props.onTypeToggle,
					summaryText = summaryText,
					layoutOrder = 2
				})
			}
		)

		for i, allType in ipairs(allTypes) do
			if selectedTypes[i] then
				children["Row_" .. allType] = Roact.createElement(OrchestratorRow, {
					orchestratorType = allType,
					batches = props.model.batchesByType[allType] or {},
					queue = props.model.queues[allType],
					cache = props.model.cacheByType[allType],
					observedMaxBatchSize = props.model.observedMaxByType[allType],
					panelWidth = size.X.Offset,
					now = props.model.now,
					size = UDim2.new(1, 0, 0, 52),
					layoutOrder = 2 + i
				})
			end
		end
	end

	return Roact.createElement(
		"Frame",
		{
			Size = size,
			BackgroundColor3 = Constants.Color.BaseGray,
			BackgroundTransparency = 1,
			LayoutOrder = 4
		},
		children
	)
end

return extended
