local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Components = script.Parent.Parent.Parent.Components
local FilterChip = require(Components.FilterChip)
local InfoBanner = require(Components.InfoBanner)
local MergeObservedNames = require(Components.MergeObservedNames)
local OperationRow = require(Components.OperationRow)
local VirtualList = require(Components.VirtualList)

local CollapsibleSection = require(script.Parent.CollapsibleSection)
local VoiceDebugOperationLabels = require(script.Parent.VoiceDebugOperationLabels)

local function filterOperations(operations, excludedNames, showCullingExclusively: boolean)
	local result = {}

	for _, item in operations do
		if showCullingExclusively then
			if item.operationType == "ClientCullingOperation" then
				result[#result + 1] = item
			end
		elseif item.operationType ~= "ClientCullingOperation" and not excludedNames[item.operationType] then
			result[#result + 1] = item
		end
	end

	return result
end

local function isChipOn(k: string, excludedNames, showCullingExclusively: boolean) -- 1 equivalent call inferred from this helper
	if k == "ClientCullingOperation" then
		return showCullingExclusively
	end

	return not (showCullingExclusively or excludedNames[k])
end

local function nextChipState(p: string, p2)
	if p == "ClientCullingOperation" then
		return {
			excludedNames = p2.excludedNames,
			showCullingExclusively = not p2.showCullingExclusively
		}
	end

	local clone = table.clone(p2.excludedNames)

	if p2.showCullingExclusively then
		clone[p] = nil
	else
		clone[p] = not clone[p] or nil
	end

	return { excludedNames = clone, showCullingExclusively = false }
end

local extended = Roact.Component:extend("ClientOperationQueuePanel")

function extended:init()
	local observedNames = {}
	MergeObservedNames((self.props.remoteOperations or {}).operations or {}, observedNames, "operationType")

	self.state = {
		observedNames = observedNames,
		excludedNames = {},
		showCullingExclusively = false
	}

	function self.onChipActivated(p)
		self:setState(function(p2)
			return nextChipState(p, p2)
		end)
	end
end

function extended.didUpdate(object, p)
	if p.remoteOperations == object.props.remoteOperations then
		return
	end

	local operations = (object.props.remoteOperations or {}).operations or {}
	local clone = table.clone(object.state.observedNames)

	if MergeObservedNames(operations, clone, "operationType") then
		object:setState({ observedNames = clone })
	end
end

function extended.render(props)
	local remoteOperations = props.props.remoteOperations or {}
	local layoutOrder = props.props.layoutOrder
	local excludedNames = props.state.excludedNames
	local showCullingExclusively = props.state.showCullingExclusively

	local items = filterOperations(remoteOperations.operations or {}, excludedNames, showCullingExclusively)
	table.sort(items, function(a, b): boolean
		return a.timestampSeconds > b.timestampSeconds
	end)
	local count = 0
	local children = {}

	for k in props.state.observedNames do
		count += 1
		local v = "chip" .. k
		children[v] = Roact.createElement(FilterChip, {
			name = VoiceDebugOperationLabels.labelForOperationType(k),
			isOn = isChipOn(k, excludedNames, showCullingExclusively), -- inferred equivalent call
			layoutOrder = count,
			onActivated = function()
				props.onChipActivated(k)
			end
		})
	end

	local v = remoteOperations.operations ~= nil
	local opQueueCaptureEnabled = remoteOperations.opQueueCaptureEnabled == true

	local createElement = Roact.createElement
	local captureNotice

	if v and not opQueueCaptureEnabled then
		captureNotice = Roact.createElement(InfoBanner, {
				layoutOrder = 1,
				text = "Operation capture is off (FFlag::VoiceMetricsDataEnabled). Enable it to see executed operations here."
			})
			or nil
	end

	return createElement(CollapsibleSection, {
		title = "Client Activity",
		layoutOrder = layoutOrder
	}, {
		CaptureNotice = captureNotice,
		Filters = Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 2,
				BackgroundTransparency = 1
			},
			{
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					Wraps = true,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 4)
				}),
				Chips = Roact.createFragment(children)
			}
		),
		List = Roact.createElement(VirtualList, {
			items = items,
			rowHeight = 22,
			renderItem = function(props2, layoutOrder2)
				local v2 = props2.name:match("::(.+)$") or props2.name
				local name = VoiceDebugOperationLabels.labelForOperationType(props2.operationType) .. ": " .. VoiceDebugOperationLabels.humanizeName(v2)
				return Roact.createElement(OperationRow, {
					timestampText = props2.timestampText,
					tag = "op",
					name = name,
					layoutOrder = layoutOrder2
				})
			end,
			size = UDim2.new(1, 0, 0, #items > 0 and math.min(#items * 22, 320) or 44),
			layoutOrder = 3,
			emptyText = "No activity observed yet."
		})
	})
end

extended._filterOperations = filterOperations
extended._isChipOn = isChipOn
extended._nextChipState = nextChipState

return extended
