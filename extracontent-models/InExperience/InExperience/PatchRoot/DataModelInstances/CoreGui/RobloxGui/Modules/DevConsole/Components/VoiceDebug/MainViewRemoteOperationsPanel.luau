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

local function mergeChronologically(sent, received)
	local result = table.create(#sent + #received)
	local v = 1
	local v2 = 1

	while v <= #sent or v2 <= #received do
		if v <= #sent and (#received < v2 or sent[v].timestampSeconds <= received[v2].timestampSeconds) then
			local item = sent[v]
			result[#result + 1] = {
				name = item.name,
				timestampSeconds = item.timestampSeconds,
				timestampText = item.timestampText,
				tag = "snt"
			}
			v += 1
		else
			local item = received[v2]
			result[#result + 1] = {
				name = item.name,
				timestampSeconds = item.timestampSeconds,
				timestampText = item.timestampText,
				tag = "srv"
			}
			v2 += 1
		end
	end

	return result
end

local extended = Roact.Component:extend("RemoteOperationsPanel")

function extended:init()
	local observedNames = {}
	local remoteOperations = self.props.remoteOperations or {}
	MergeObservedNames(remoteOperations.sent or {}, observedNames, "name")
	MergeObservedNames(remoteOperations.received or {}, observedNames, "name")

	self.state = { observedNames = observedNames, excludedNames = {} }

	function self.onChipActivated(p)
		self:setState(function(p2)
			local clone = table.clone(p2.excludedNames)
			clone[p] = not clone[p] or nil
			return { excludedNames = clone }
		end)
	end
end

function extended.didUpdate(object, p)
	if p.remoteOperations == object.props.remoteOperations then
		return
	end

	local remoteOperations = object.props.remoteOperations or {}
	local clone = table.clone(object.state.observedNames)
	local mergeObservedNames = MergeObservedNames(remoteOperations.sent or {}, clone, "name")
	local mergeObservedNames2 = MergeObservedNames(remoteOperations.received or {}, clone, "name")

	if mergeObservedNames or mergeObservedNames2 then
		object:setState({ observedNames = clone })
	end
end

function extended.render(props)
	local remoteOperations = props.props.remoteOperations or {}
	local layoutOrder = props.props.layoutOrder
	local excludedNames = props.state.excludedNames

	local v = mergeChronologically(remoteOperations.sent or {}, remoteOperations.received or {})
	local items = {}

	for i = #v, 1, -1 do
		local v2 = v[i]

		if not excludedNames[v2.name] then
			items[#items + 1] = v2
		end
	end

	local count = 0
	local children = {}

	for k in props.state.observedNames do
		count += 1
		children["chip" .. k] = Roact.createElement(FilterChip, {
			name = VoiceDebugOperationLabels.labelForEventName(k),
			isOn = not excludedNames[k],
			layoutOrder = count,
			onActivated = function()
				props.onChipActivated(k)
			end
		})
	end

	local v2 = remoteOperations.sent ~= nil
	local receivedCaptureEnabled = remoteOperations.receivedCaptureEnabled == true
	local sentCaptureEnabled = remoteOperations.sentCaptureEnabled == true

	local createElement = Roact.createElement

	local banner = v2
		and not receivedCaptureEnabled
		and Roact.createElement(InfoBanner, {
			layoutOrder = 1,
			text = "Remote operation capture is off (FFlag::VoiceMetricsDataEnabled). Enable it to see sent/received events here."
		})

	if not banner then
		if v2 then
			banner = not sentCaptureEnabled
				and Roact.createElement(InfoBanner, {
					layoutOrder = 1,
					text = "Sent-event capture is off (FFlag::VoiceChatEventReplicatorWrapperEnabled). Received events are still shown below."
				})
				or nil
		else
			banner = nil
		end
	end

	return createElement(CollapsibleSection, { title = "Message Log", layoutOrder = layoutOrder }, {
		Banner = banner,
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
				return Roact.createElement(OperationRow, {
					timestampText = props2.timestampText,
					tag = props2.tag,
					name = VoiceDebugOperationLabels.labelForEventName(props2.name),
					layoutOrder = layoutOrder2
				})
			end,
			size = UDim2.new(1, 0, 0, #items > 0 and math.min(#items * 22, 280) or 44),
			layoutOrder = 3,
			emptyText = #v > 0 and "No messages match filter." or "No messages observed yet."
		})
	})
end

extended._mergeChronologically = mergeChronologically

return extended
