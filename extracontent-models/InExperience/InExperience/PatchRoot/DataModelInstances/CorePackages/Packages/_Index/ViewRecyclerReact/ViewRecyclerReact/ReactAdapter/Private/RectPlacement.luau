local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")
require(ViewRecyclerReact.Parent.ViewRecycler)
local Destination = require(script.Parent.Destination)
local Placement = require(script.Parent.Placement)
require(script.Parent.RecyclableView)
require(script.Parent.RecyclableViewRegistry)

local v = 1
return {
	new = function(p, callback)
		local v2 = v
		v += 1
		local v3 = Placement.new(p, { name = "RectPlacement", namespace = `rect:{v2}` })

		local rectPlacement = {}
		local frozen = nil

		return {
			sync = function(list)
				local current = callback().current
				assert(current ~= nil, "RectPlacement: cannot sync without a container")

				if frozen == nil or frozen.container ~= current then
					if frozen ~= nil and v3.hasDestroyedView() then
						v3.releaseAll()
					end

					frozen = table.freeze({
						kind = Destination.Kind.Rect,
						rectPlacement = rectPlacement,
						container = current
					})
				end

				local v4 = table.create(#list)

				for k, item in list do
					assert(typeof(item.position) == "Vector2", "RectPlacement: slot position must be a Vector2")
					assert(typeof(item.size) == "Vector2", "RectPlacement: slot size must be a Vector2")
					v4[k] = {
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

				v3.sync(v4)
			end,
			releaseAll = v3.releaseAll
		}
	end
}
