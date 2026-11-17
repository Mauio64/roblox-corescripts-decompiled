local Flags = require(script:FindFirstAncestor("ViewRecyclerReact").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")
require(ViewRecyclerReact.Parent.ViewRecycler)
local Destination = require(script.Parent.Destination)
local Placement = require(script.Parent.Placement)
require(script.Parent.RecyclableView)
require(script.Parent.RecyclableViewRegistry)
local vacantHosts

if FFlagViewRecyclerReact084 then
	local ViewRecyclerRoblox = require(ViewRecyclerReact.Parent.ViewRecyclerRoblox)
	vacantHosts = ViewRecyclerRoblox.Internal.VacantHosts
else
	vacantHosts = nil
end

local v = 1
return {
	new = function(p, callback)
		local v2 = v
		v += 1
		local v3 = Placement.new(p, { name = "RectPlacement", namespace = `rect:{v2}` })

		local rectPlacement = {}
		local frozen = nil
		local v4, evacuate

		if FFlagViewRecyclerReact084 then
			v4 = vacantHosts.forScope(p)

			evacuate = function()
				local v5 = frozen

				if v5 ~= nil then
					v4.evacuate(function(p2): boolean
						return p2 == v5.container
					end)
				end
			end
		else
			evacuate = nil
			v4 = nil
		end

		local v5 = {
			sync = function(list)
				local current = callback().current
				assert(current ~= nil, "RectPlacement: cannot sync without a container")

				if frozen == nil or frozen.container ~= current then
					if frozen ~= nil and v3.hasDestroyedView() then
						v3.releaseAll()
					end

					if FFlagViewRecyclerReact084 then
						evacuate()
					end

					local v5 = {
						kind = Destination.Kind.Rect,
						rectPlacement = rectPlacement,
						container = current,
						vacantHosts = 0
					}
					local vacantHosts2

					if FFlagViewRecyclerReact084 then
						vacantHosts2 = v4
					end

					v5.vacantHosts = vacantHosts2
					frozen = table.freeze(v5)
				end

				local v5 = table.create(#list)

				for k, item in list do
					assert(typeof(item.position) == "Vector2", "RectPlacement: slot position must be a Vector2")
					assert(typeof(item.size) == "Vector2", "RectPlacement: slot size must be a Vector2")
					v5[k] = {
						key = item.key,
						viewType = item.viewType,
						value = item.item,
						destination = frozen,
						geometry = {
							position = item.position,
							size = item.size,
							zIndex = item.zIndex or 1
						}
					}
				end

				v3.sync(v5)
			end,
			releaseAll = 0
		}
		local releaseAll

		if FFlagViewRecyclerReact084 then
			releaseAll = function()
				v3.releaseAll()
				evacuate()
			end
		else
			releaseAll = v3.releaseAll
		end

		v5.releaseAll = releaseAll
		return v5
	end
}
