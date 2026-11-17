local Flags = require(script:FindFirstAncestor("ViewRecyclerRoblox").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
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
	local v9

	if FFlagViewRecyclerReact084 then
		v9 = setmetatable({}, { __mode = "k" })
	else
		v9 = nil
	end

	local v10 = {}
	local v11 = {}
	local v12 = {}
	local set = {}
	local flag2 = false
	local v13 = true
	local v14 = nil

	local function frameFor(p3: number) -- 3 equivalent calls inferred from this helper
		return if p3 < v4 then stackFrame else stackFrame2
	end

	local function contains(p3: number): boolean -- 4 equivalent calls inferred from this helper
		return v2 <= p3 and p3 <= v3
	end

	local function releasePlaceholder(p3: number) -- 2 equivalent calls inferred from this helper
		local v15 = v11[p3]

		if v15 ~= nil then
			v11[p3] = nil
			v15.Parent = nil
			table.insert(v12, v15)
		end
	end

	local function refresh(layoutOrder: number)
		if contains(layoutOrder) and not ((v10[layoutOrder] or 0) > 0) then -- inferred equivalent call
			local v15 = v11[layoutOrder]

			if v15 == nil then
				v15 = table.remove(v12)

				if v15 == nil then
					v15 = transparentFrame("Placeholder")
				end

				v11[layoutOrder] = v15
			end

			local v16 = v6[layoutOrder] or 0
			local v17 = math.round(v16 + (v5[layoutOrder] or 0)) - math.round(v16)
			local udim2

			if v then
				udim2 = UDim2.new(1, 0, 0, v17)
			else
				udim2 = UDim2.new(0, v17, 1, 0)
			end

			if v15.Size ~= udim2 then
				v15.Size = udim2
			end

			if v15.LayoutOrder ~= layoutOrder then
				v15.LayoutOrder = layoutOrder
			end

			local parent3 = frameFor(layoutOrder) -- inferred equivalent call

			if v15.Parent ~= parent3 then
				v15.Parent = parent3
			end
		else
			releasePlaceholder(layoutOrder) -- inferred equivalent call
		end
	end

	local function setOffset(stackFrame3, p3: number) -- 2 equivalent calls inferred from this helper
		local v15 = math.round(p3 + v7)
		local udim2

		if v then
			udim2 = UDim2.fromOffset(0, v15)
		else
			udim2 = UDim2.fromOffset(v15, 0)
		end

		if stackFrame3.Position ~= udim2 then
			stackFrame3.Position = udim2
		end
	end

	local function positionFrames() -- 2 equivalent calls inferred from this helper
		local v15 = v6[v4] or 0
		setOffset(stackFrame, v15 - p2) -- inferred equivalent call
		setOffset(stackFrame2, v15) -- inferred equivalent call
	end

	local function setOccupying(p3: number?, p4: number?) -- 1 equivalent call inferred from this helper
		if p4 == p3 then
			return
		end

		if p4 ~= nil then
			v10[p4] -= 1

			if v10[p4] == 0 then
				v10[p4] = nil
			end

			set[p4] = true
		end

		if p3 ~= nil then
			v10[p3] = (v10[p3] or 0) + 1
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
			local v15 = 1e999
			local maxValue = -1e999
			local v16 = 0

			for _, mountedView in data.mountedViews do
				local state = mountedView.state
				local index = state.index

				if not (index ~= nil and (StackPlacement.isPlacedFromLayoutOffsets(state) or mountedRange.firstIndex <= index and index <= mountedRange.lastIndex)) then
					continue
				end

				lengthsByIndex[index] = state.itemLayout.length

				if index < v15 then
					v16 = state.itemLayout.startOffset + state.contentStartOffset
					v15 = index
				end

				maxValue = math.max(maxValue, index)
			end

			if maxValue < v15 then
				v15 = 1
				maxValue = 0
				v16 = 0
			end

			local scrollAnchor = data.scrollAnchor
			local v17

			if scrollAnchor == nil then
				v17 = v15
			elseif scrollAnchor.alignment == ViewRecycler.ScrollAlignment.End then
				v17 = scrollAnchor.index + 1
			else
				v17 = scrollAnchor.index
			end

			v2 = v15
			v3 = maxValue
			v5 = lengthsByIndex
			v4 = math.clamp(v17, v15, (math.max(v15, maxValue + 1)))
			table.clear(v6)

			for i = v15, maxValue + 1 do
				v6[i] = v16
				v16 += (lengthsByIndex[i] or 0) + p2
			end

			v7 = p3
			flag2 = true
			v13 = true
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
			local v15 = v8[p3]

			if v15 == nil then
				v15 = {
					index = index,
					geometry = {},
					inWindow = false,
					visible = false,
					restoreLayoutOrder = p3.LayoutOrder
				}

				v8[p3] = v15

				if FFlagViewRecyclerReact084 then
					v9[p3] = nil
				end
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
				v15.geometry
			)

			geometry.position = udim
			CanvasItemPlacer.place(p3, frameFor(index), geometry, p4, visible) -- inferred equivalent call
			local v16

			if visible then
				v16 = index
			end

			local v17

			if v15.visible then
				v17 = v15.index
			end

			setOccupying(v16, v17) -- inferred equivalent call
			v15.index = index
			v15.inWindow = contains(index) -- inferred equivalent call
			v15.visible = visible

			if p3.LayoutOrder ~= index then
				p3.LayoutOrder = index
			end

			v13 = true
			return visible
		end,
		remove = function(p3)
			local v15 = v8[p3]

			if v15 == nil then
				return
			end

			v8[p3] = nil

			if FFlagViewRecyclerReact084 then
				v9[p3] = true
			end

			local index

			if v15.visible then
				index = v15.index
			end

			if index ~= nil and index ~= nil then
				v10[index] -= 1

				if v10[index] == 0 then
					v10[index] = nil
				end

				set[index] = true
			end

			p3.LayoutOrder = v15.restoreLayoutOrder
			v13 = true
		end,
		isStacked = function(p3): boolean
			return v8[p3] ~= nil
		end,
		isStackFrame = FFlagViewRecyclerReact084 and function(p3): boolean
			return p3 == stackFrame or p3 == stackFrame2
		end or nil,
		getStaleHosts = function()
			local staleHosts = {}

			for k, v15 in v8 do
				if contains(v15.index) == v15.inWindow and k.Parent == frameFor(v15.index) then -- inferred equivalent call
					continue
				end

				table.insert(staleHosts, k)
			end

			return staleHosts
		end,
		takeChanged = function()
			local v15 = uiListLayout.AbsoluteContentSize + uiListLayout2.AbsoluteContentSize
			local v16 = v13 or v15 ~= v14
			v13 = false
			v14 = v15
			return v16
		end,
		commit = function()
			if flag2 then
				flag2 = false

				for k in v11 do
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
			for k, v15 in v8 do
				k.LayoutOrder = v15.restoreLayoutOrder
			end

			if FFlagViewRecyclerReact084 then
				for k in v9 do
					if k.Parent == stackFrame or k.Parent == stackFrame2 then
						k.Parent = parent
					end
				end

				table.clear(v9)
			end

			table.clear(v8)
			table.clear(v10)
			table.clear(v11)
			table.clear(v12)
			table.clear(set)
			parent2:Destroy()
		end
	}
end

return StackPlacement
