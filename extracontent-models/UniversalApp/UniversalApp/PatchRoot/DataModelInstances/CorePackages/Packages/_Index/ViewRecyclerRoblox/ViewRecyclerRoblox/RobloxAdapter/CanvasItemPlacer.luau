local Flags = require(script:FindFirstAncestor("ViewRecyclerRoblox").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local ViewRecyclerRoblox = script:FindFirstAncestor("ViewRecyclerRoblox")
require(ViewRecyclerRoblox.Parent.ViewRecycler)

local SlotGeometry = require(ViewRecyclerRoblox.RobloxAdapter.SlotGeometry)

local CanvasItemPlacer = {}

function CanvasItemPlacer.createState()
	return {
		unpinnedZIndex = nil,
		parent = nil,
		anchorPointInitialized = false,
		position = nil,
		size = nil,
		automaticSize = nil,
		visible = nil,
		zIndex = nil
	}
end

local function resetAppliedState(p) -- 3 equivalent calls inferred from this helper
	p.anchorPointInitialized = false
	p.position = nil
	p.size = nil
	p.automaticSize = nil
	p.visible = nil
	p.zIndex = nil
end

function CanvasItemPlacer.getGeometry(p, data, p2, flag: boolean, p3: number, options)
	if data.mainAxisOffset ~= nil then
		p = {
			startOffset = data.mainAxisOffset,
			length = data.mainAxisLength or p.length
		}
		p3 = 0
	end

	local position, size = SlotGeometry.get(p, p2, flag, p3)
	local geometry = options or {}
	geometry.position = position
	geometry.size = size
	geometry.automaticSize = SlotGeometry.getAutomaticSize(p2, flag)
	geometry.zIndexOffset = data.zIndex
	return geometry
end

function CanvasItemPlacer:place(parent, data, state, visible: boolean)
	local count = 0

	if self.Parent ~= parent or state.parent ~= parent then
		if self.Parent ~= parent then
			self.Parent = parent
			count += 1
		end

		state.parent = parent
		resetAppliedState(state) -- inferred equivalent call
	end

	if not state.anchorPointInitialized then
		self.AnchorPoint = Vector2.zero
		state.anchorPointInitialized = true
		count += 1
	end

	if state.position ~= data.position then
		self.Position = data.position
		state.position = data.position
		count += 1
	end

	if state.size ~= data.size then
		self.Size = data.size
		state.size = data.size
		count += 1
	end

	if state.automaticSize ~= data.automaticSize then
		self.AutomaticSize = data.automaticSize
		state.automaticSize = data.automaticSize
		count += 1
	end

	if state.visible ~= visible then
		self.Visible = visible
		state.visible = visible
		count += 1
	end

	local zIndex = nil
	local zIndexOffset = data.zIndexOffset

	if zIndexOffset == nil then
		if state.unpinnedZIndex ~= nil then
			zIndex = state.unpinnedZIndex
			state.unpinnedZIndex = nil
		end
	else
		if state.unpinnedZIndex == nil then
			state.unpinnedZIndex = self.ZIndex
		end

		zIndex = state.unpinnedZIndex + zIndexOffset
	end

	if zIndex == nil or state.zIndex == zIndex then
		if zIndex == nil then
			state.zIndex = self.ZIndex
		end

		return count
	end

	self.ZIndex = zIndex
	state.zIndex = zIndex
	return count + 1
end

function CanvasItemPlacer:updatePosition(p, p2): boolean
	if p2.position == p.position then
		return false
	end

	self.Position = p.position
	p2.position = p.position
	return true
end

function CanvasItemPlacer:hide(p)
	if p.visible ~= false then
		self.Visible = false
		p.visible = false
	end
end

if FFlagViewRecyclerReact084 then
	function CanvasItemPlacer:release(p)
		local count = 0

		if p.unpinnedZIndex ~= nil then
			if self.ZIndex ~= p.unpinnedZIndex then
				self.ZIndex = p.unpinnedZIndex
				count += 1
			end

			p.unpinnedZIndex = nil
		end

		if self.Visible then
			self.Visible = false
			count += 1
		end

		p.parent = nil
		resetAppliedState(p) -- inferred equivalent call
		return count
	end
end

function CanvasItemPlacer:detach(p)
	local v

	if FFlagViewRecyclerReact084 then
		v = CanvasItemPlacer.release(self, p)
	else
		v = 0

		if p.unpinnedZIndex ~= nil then
			if self.ZIndex ~= p.unpinnedZIndex then
				self.ZIndex = p.unpinnedZIndex
				v += 1
			end

			p.unpinnedZIndex = nil
		end

		if self.Visible then
			self.Visible = false
			v += 1
		end
	end

	if self.Parent ~= nil then
		self.Parent = nil
		v += 1
	end

	if not FFlagViewRecyclerReact084 then
		p.parent = nil
		resetAppliedState(p) -- inferred equivalent call
	end

	return v
end

if not FFlagViewRecyclerReact084 then
	function CanvasItemPlacer:detachForTransfer(p)
		local v = CanvasItemPlacer.detach(self, p)

		if self.Position ~= UDim2.new() then
			self.Position = UDim2.new()
			v += 1
		end

		if self.Size ~= UDim2.new() then
			self.Size = UDim2.new()
			v += 1
		end

		if self.AutomaticSize ~= Enum.AutomaticSize.None then
			self.AutomaticSize = Enum.AutomaticSize.None
			return v + 1
		end

		return v
	end
end

return CanvasItemPlacer
