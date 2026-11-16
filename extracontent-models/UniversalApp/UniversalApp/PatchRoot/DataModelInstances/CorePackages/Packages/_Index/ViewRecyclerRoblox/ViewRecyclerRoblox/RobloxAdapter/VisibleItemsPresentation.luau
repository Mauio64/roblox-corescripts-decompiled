local Flags = require(script:FindFirstAncestor("ViewRecyclerRoblox").Flags)
local FFlagViewRecyclerReact08 = Flags.FFlagViewRecyclerReact08
local ViewRecyclerRoblox = script:FindFirstAncestor("ViewRecyclerRoblox")
require(ViewRecyclerRoblox.Parent.ViewRecycler)

return {
	new = function(callback)
		local v = true
		local v2 = false
		local v3 = nil
		local object = setmetatable({}, { __mode = "k" })

		local function check()
			local v4 = v3

			if not v or v2 or v4 == nil then
				return
			end

			local visibleRange = v4.visibleRange

			if visibleRange.lastIndex < visibleRange.firstIndex then
				return
			end

			local count = 0

			for _, mountedView in v4.mountedViews do
				local index = mountedView.state.index

				if not (index ~= nil and visibleRange.firstIndex <= index and index <= visibleRange.lastIndex) then
					continue
				end

				if object[mountedView.itemView] ~= mountedView.state.assignment then
					return
				end

				count += 1
			end

			if count <= visibleRange.lastIndex - visibleRange.firstIndex then
				return
			end

			v = false
			local v5 = callback()

			if v5 ~= nil then
				v5(table.freeze({ visibleRange = visibleRange }))
			end
		end

		return {
			rearm = function()
				v = true
			end,
			present = function(p, p2, callback2)
				v2 = true

				local success = nil
				local result = nil

				if FFlagViewRecyclerReact08 then
					success, result = pcall(callback2)
				else
					callback2()
				end

				v2 = false
				v3 = p

				if FFlagViewRecyclerReact08 and not success then
					error(result, 0)
				end

				if p2 == 0 then
					v = true
				else
					check()
				end
			end,
			presentationChanged = function(p, p2)
				object[p] = p2
				check()
			end
		}
	end
}
