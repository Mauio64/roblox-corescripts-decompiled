local ViewRecyclerRoblox = script:FindFirstAncestor("ViewRecyclerRoblox")

local ReparentableHost = require(ViewRecyclerRoblox.RobloxAdapter.ReparentableHost)
local transparentFrame = require(ViewRecyclerRoblox.RobloxAdapter.transparentFrame)

local object = setmetatable({}, { __mode = "k" })
local VacantHosts = {}

function VacantHosts.register(p, p2)
	object[p] = p2
end

function VacantHosts.forScope(p)
	local v = object[p]
	assert(
		v ~= nil,
		"ViewRecycler: the Recycling scope has no place for Vacant Hosts; create it with RobloxAdapter.createRecyclingScope"
	)

	return v
end

local function scaleOf(instance)
	local v = 1

	while instance ~= nil do
		local uiScale = instance:FindFirstChildOfClass("UIScale")

		if uiScale ~= nil then
			v *= uiScale.Scale
		end

		instance = instance.Parent
	end

	return v
end

local function hide(p) -- 2 equivalent calls inferred from this helper
	ReparentableHost.clearSelection(p)

	if p.Visible then
		p.Visible = false
	end
end

function VacantHosts.new()
	local parent2 = transparentFrame("ViewRecyclerVacantHosts")
	parent2.Size = UDim2.fromScale(1, 1)
	parent2.Visible = false

	local v = {}
	local object2 = setmetatable({}, { __mode = "k" })

	local function frameFor(scale: number)
		if math.abs(scale - 1) < 1e-6 then
			return parent2
		end

		local v2 = string.format("%.6f", scale)
		local parent = v[v2]

		if parent ~= nil then
			return parent
		end

		parent = transparentFrame("Scaled")
		parent.Size = UDim2.fromScale(1, 1)
		local uiScale = Instance.new("UIScale")
		uiScale.Scale = scale
		uiScale.Parent = parent
		parent.Parent = parent2
		v[v2] = parent

		return parent
	end

	local function hold(list)
		local v2 = parent2:FindFirstAncestorWhichIsA("LayerCollector") ~= nil
		local v3 = scaleOf(parent2)

		local v4 = table.create(#list)
		local v5 = table.create(#list)

		for k, item in list do
			object2[item] = nil
			hide(item) -- inferred equivalent call

			if item:FindFirstAncestorWhichIsA("LayerCollector") == nil then
				v4[k] = false
			elseif v2 then
				v4[k] = item.AbsoluteSize / scaleOf(item)
				v5[k] = scaleOf(item.Parent) / v3
			end
		end

		for k, item in list do
			local v6 = v4[k]

			if v6 == false then
				item.Position = UDim2.new()
				item.Parent = parent2
			elseif v6 ~= nil then
				item.Position = UDim2.new()
				item.Size = UDim2.fromOffset(v6.X, v6.Y)
				item.Parent = frameFor(v5[k])
			end
		end
	end

	return {
		setParent = function(parent)
			if parent2.Parent ~= parent then
				parent2.Parent = parent
			end
		end,
		leave = function(p)
			hide(p) -- inferred equivalent call
			object2[p] = true
		end,
		reclaim = function(p)
			object2[p] = nil
		end,
		evacuate = function(callback)
			local v2 = {}

			for k in object2 do
				local parent = k.Parent

				if parent ~= nil and callback(parent) then
					table.insert(v2, k)
				end
			end

			if #v2 > 0 then
				hold(v2)
			end
		end,
		hold = hold,
		destroy = function()
			parent2:Destroy()
			table.clear(v)
			table.clear(object2)
		end
	}
end

return VacantHosts
