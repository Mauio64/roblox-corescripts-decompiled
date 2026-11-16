local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")

require(ViewRecyclerReact.Parent.ViewRecycler)
local ViewRecyclerRoblox = require(ViewRecyclerReact.Parent.ViewRecyclerRoblox)
require(ViewRecyclerReact.Parent.Signals)
local HostPresentationPhase = ViewRecyclerRoblox.HostPresentationPhase
local ReparentableHost = ViewRecyclerRoblox.ReparentableHost

local frozen = table.freeze({ List = "list", Composition = "composition", Rect = "rect" })

local function resetReparented(_, p, _)
	ReparentableHost.detach(p)
	p.AnchorPoint = Vector2.zero
	p.Position = UDim2.new()
	p.Size = UDim2.new()
	p.AutomaticSize = Enum.AutomaticSize.None

	p.ZIndex = 1
end

local function attachNowhere(_, _) end

local function readValue(p, _)
	return p
end

local frozen2 = table.freeze({
	[frozen.List] = table.freeze({
		sameOwner = function(p, p2): boolean
			return p.sink == p2.sink
		end,
		attach = attachNowhere,
		present = function(p, host, p2, phase)
			p2.sink.apply(p, { host = host, phase = phase, state = p2.state })
		end,
		detach = function(p, _, p2)
			p2.sink.apply(p, nil)
		end,
		readItem = readValue
	}),
	[frozen.Composition] = table.freeze({
		sameOwner = function(p, p2): boolean
			return p.placementId == p2.placementId
		end,
		attach = attachNowhere,
		present = function(_, state, p, p2)
			if state.Parent ~= p.placeholder or state.AutomaticSize ~= p.automaticSize then
				ReparentableHost.place(state, p)
			end

			state.Visible = p2 ~= HostPresentationPhase.Hidden
		end,
		detach = resetReparented,
		readItem = function(callback, p)
			return callback(p)
		end
	}),
	[frozen.Rect] = table.freeze({
		sameOwner = function(p, p2): boolean
			return p.rectPlacement == p2.rectPlacement
		end,
		attach = function(p, p2)
			if p.Parent ~= p2.container then
				p.AutomaticSize = Enum.AutomaticSize.None
				p.Parent = p2.container
			end
		end,
		present = function(_, p, _, p2)
			p.Visible = p2 ~= HostPresentationPhase.Hidden
		end,
		detach = resetReparented,
		readItem = readValue
	})
})

return table.freeze({ Kind = frozen, behaviors = frozen2 })
