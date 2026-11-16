local ViewRecyclerRoblox = script:FindFirstAncestor("ViewRecyclerRoblox")
local ViewRecycler = require(ViewRecyclerRoblox.Parent.ViewRecycler)

local CanvasItemPlacer = require(ViewRecyclerRoblox.RobloxAdapter.CanvasItemPlacer)
local HostPresentationPhase = require(ViewRecyclerRoblox.RobloxAdapter.HostPresentationPhase)
local transparentFrame = require(ViewRecyclerRoblox.RobloxAdapter.transparentFrame)

local Axis = ViewRecycler.Axis

local StackPlacement = {}

function StackPlacement.isPlacedFromLayoutOffsets(p): boolean
	return p.index ~= nil and p.canvasPlacement.mainAxisOffset == nil
end

local udim = UDim2.new()

local function createStackFrame(p: string, flag: boolean, p2: number, parent)
	local stackFrame = transparentFrame(p)
	local size

	if flag then
		size = UDim2.fromScale(1, 0)
	else
		size = UDim2.fromScale(0, 1)
	end

	stackFrame.Size = size
	local automaticSize

	if flag then
		automaticSize = Enum.AutomaticSize.Y
	else
		automaticSize = Enum.AutomaticSize.X
	end

	stackFrame.AutomaticSize = automaticSize
	local uiListLayout = Instance.new("UIListLayout")
	local fillDirection

	if flag then
		fillDirection = Enum.FillDirection.Vertical
	else
		fillDirection = Enum.FillDirection.Horizontal
	end

	uiListLayout.FillDirection = fillDirection
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	uiListLayout.Padding = UDim.new(0, p2)
	uiListLayout.Parent = stackFrame
	stackFrame.Parent = parent
	return stackFrame
end

function StackPlacement.new(parent, p, p2: number, flag: boolean)
	local v = p == Axis.Y
	local parent2 = transparentFrame("ViewRecyclerStack")
	parent2.Size = UDim2.fromScale(1, 1)
	local stackFrame = createStackFrame("Leading", v, p2, parent2)
	local anchorPoint = if v then Vector2.yAxis else Vector2.xAxis
	stackFrame.AnchorPoint = anchorPoint
	local stackFrame2 = createStackFrame("Trailing", v, p2, parent2)
	parent2.Parent = parent
	local uiListLayout = stackFrame:FindFirstChildOfClass("UIListLayout")
	local uiListLayout2 = stackFrame2:FindFirstChildOfClass("UIListLayout")

	local v2 = 1
	local v3 = 0
	local v4 = 1
	local v5 = {}

	local v6 = {}
	local v7 = 0
	local v8 = {}
	local v9 = {}
	local v10 = {}
	local v11 = {}
	local set = {}
	local flag2 = false
	local v12 = true
	local v13 = nil

	local function frameFor(p3: number) -- 3 equivalent calls inferred from this helper
		return if p3 < v4 then stackFrame else stackFrame2
	end

	local function contains(p3: number): boolean -- 4 equivalent calls inferred from this helper
		return v2 <= p3 and p3 <= v3
	end

	local function releasePlaceholder(p3: number) -- 2 equivalent calls inferred from this helper
		local v14 = v10[p3]

		if v14 ~= nil then
			v10[p3] = nil
			v14.Parent = nil
			table.insert(v11, v14)
		end
	end

	local function refresh(layoutOrder: number)
		if contains(layoutOrder) and not ((v9[layoutOrder] or 0) > 0) then -- inferred equivalent call
			local v14 = v10[layoutOrder]

			if v14 == nil then
				v14 = table.remove(v11)

				if v14 == nil then
					v14 = transparentFrame("Placeholder")
				end

				v10[layoutOrder] = v14
			end

			local v15 = v6[layoutOrder] or 0
			local v16 = math.round(v15 + (v5[layoutOrder] or 0)) - math.round(v15)
			local udim2

			if v then
				udim2 = UDim2.new(1, 0, 0, v16)
			else
				udim2 = UDim2.new(0, v16, 1, 0)
			end

			if v14.Size ~= udim2 then
				v14.Size = udim2
			end

			if v14.LayoutOrder ~= layoutOrder then
				v14.LayoutOrder = layoutOrder
			end

			local parent3 = frameFor(layoutOrder) -- inferred equivalent call

			if v14.Parent ~= parent3 then
				v14.Parent = parent3
			end
		else
			releasePlaceholder(layoutOrder) -- inferred equivalent call
		end
	end

	local function setOffset(stackFrame3, p3: number) -- 2 equivalent calls inferred from this helper
		local v14 = math.round(p3 + v7)
		local udim2

		if v then
			udim2 = UDim2.fromOffset(0, v14)
		else
			udim2 = UDim2.fromOffset(v14, 0)
		end

		if stackFrame3.Position ~= udim2 then
			stackFrame3.Position = udim2
		end
	end

	local function positionFrames() -- 2 equivalent calls inferred from this helper
		local v14 = v6[v4] or 0
		setOffset(stackFrame, v14 - p2) -- inferred equivalent call
		setOffset(stackFrame2, v14) -- inferred equivalent call
	end

	local function setOccupying(p3: number?, p4: number?) -- 1 equivalent call inferred from this helper
		if p4 == p3 then
			return
		end

		if p4 ~= nil then
			v9[p4] -= 1

			if v9[p4] == 0 then
				v9[p4] = nil
			end

			set[p4] = true
		end

		if p3 ~= nil then
			v9[p3] = (v9[p3] or 0) + 1
			set[p3] = true
		end
	end

	return {
		matches = function(p3, p4, p5, p6): boolean
			return parent2.Parent == p3 and p4 == p and p5 == p2 and p6 == flag
		end,
		setWindow = function(data, p3)
			local mountedRange = data.mountedRange
			local lengthsByIndex = {}
			local v14 = 1e999
			local maxValue = -1e999
			local v15 = 0

			for _, mountedView in data.mountedViews do
				local state = mountedView.state
				local index = state.index

				if not (index ~= nil and (StackPlacement.isPlacedFromLayoutOffsets(state) or mountedRange.firstIndex <= index and index <= mountedRange.lastIndex)) then
					continue
				end

				lengthsByIndex[index] = state.itemLayout.length

				if index < v14 then
					v15 = state.itemLayout.startOffset + state.contentStartOffset
					v14 = index
				end

				maxValue = math.max(maxValue, index)
			end

			if maxValue < v14 then
				v14 = 1
				maxValue = 0
				v15 = 0
			end

			local scrollAnchor = data.scrollAnchor
			local v16

			if scrollAnchor == nil then
				v16 = v14
			elseif scrollAnchor.alignment == ViewRecycler.ScrollAlignment.End then
				v16 = scrollAnchor.index + 1
			else
				v16 = scrollAnchor.index
			end

			v2 = v14
			v3 = maxValue
			v5 = lengthsByIndex
			v4 = math.clamp(v16, v14, (math.max(v14, maxValue + 1)))
			table.clear(v6)

			for i = v14, maxValue + 1 do
				v6[i] = v15
				v15 += (lengthsByIndex[i] or 0) + p2
			end

			v7 = p3
			flag2 = true
			v12 = true
			positionFrames() -- inferred equivalent call
		end,
		setOriginOffset = function(p3)
			if p3 ~= v7 then
				v7 = p3
				positionFrames() -- inferred equivalent call
			end
		end,
		place = function(p3, p4, data, p5)
			local index = data.index
			local v14 = v8[p3]

			if v14 == nil then
				v14 = {
					index = index,
					geometry = {},
					inWindow = false,
					visible = false,
					restoreLayoutOrder = p3.LayoutOrder
				}

				v8[p3] = v14
			end

			local visible

			if p5 == HostPresentationPhase.Presented and v2 <= index then
				visible = index <= v3
			else
				visible = false
			end

			local geometry = CanvasItemPlacer.getGeometry(
				data.itemLayout,
				data.canvasPlacement,
				p,
				flag,
				0,
				v14.geometry
			)

			geometry.position = udim
			CanvasItemPlacer.place(p3, frameFor(index), geometry, p4, visible) -- inferred equivalent call
			local v15

			if visible then
				v15 = index
			end

			local v16

			if v14.visible then
				v16 = v14.index
			end

			setOccupying(v15, v16) -- inferred equivalent call
			v14.index = index
			v14.inWindow = contains(index) -- inferred equivalent call
			v14.visible = visible

			if p3.LayoutOrder ~= index then
				p3.LayoutOrder = index
			end

			v12 = true
			return visible
		end,
		remove = function(p3)
			local v14 = v8[p3]

			if v14 == nil then
				return
			end

			v8[p3] = nil
			local index

			if v14.visible then
				index = v14.index
			end

			if index ~= nil and index ~= nil then
				v9[index] -= 1

				if v9[index] == 0 then
					v9[index] = nil
				end

				set[index] = true
			end

			p3.LayoutOrder = v14.restoreLayoutOrder
			v12 = true
		end,
		isStacked = function(p3): boolean
			return v8[p3] ~= nil
		end,
		getStaleHosts = function()
			local staleHosts = {}

			for k, v14 in v8 do
				if contains(v14.index) == v14.inWindow and k.Parent == frameFor(v14.index) then -- inferred equivalent call
					continue
				end

				table.insert(staleHosts, k)
			end

			return staleHosts
		end,
		takeChanged = function()
			local v14 = uiListLayout.AbsoluteContentSize + uiListLayout2.AbsoluteContentSize
			local v15 = v12 or v14 ~= v13
			v12 = false
			v13 = v14
			return v15
		end,
		commit = function()
			if flag2 then
				flag2 = false

				for k in v10 do
					if not contains(k) then -- inferred equivalent call
						releasePlaceholder(k) -- inferred equivalent call
					end
				end

				for i = v2, v3 do
					refresh(i)
				end
			else
				for k in set do
					refresh(k)
				end
			end

			table.clear(set)
		end,
		destroy = function()
			for k, v14 in v8 do
				k.LayoutOrder = v14.restoreLayoutOrder
			end

			table.clear(v8)
			table.clear(v9)
			table.clear(v10)
			table.clear(v11)
			table.clear(set)
			parent2:Destroy()
		end
	}
end

return StackPlacement
