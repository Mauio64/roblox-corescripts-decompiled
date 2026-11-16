local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/React")
local focusNavigationContext = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/ReactFocusNavigation").FocusNavigationContext

local function fn(duration, list, object)
	local v5 = #list == 0
	local connections = {}
	local threads = {}

	local function disconnect()
		if not v5 then
			v5 = true

			for k, connection in connections do
				connection:Disconnect()
			end
		end
	end

	local function onFocusChange(p2, p3, p4)
		if p4 and not v5 then
			v5 = true

			for k, connection in connections do
				connection:Disconnect()
			end
		end
	end

	local function focus(p2)
		local thread = task.delay(duration, function()
			if not v5 then
				local selectedCoreObject = GuiService.SelectedCoreObject

				if selectedCoreObject then
					for k, ancestor in list do
						if
							selectedCoreObject == ancestor
							or selectedCoreObject:IsDescendantOf(ancestor)
						then
							if not v5 then
								v5 = true

								for k2, connection in connections do
									connection:Disconnect()
								end
							end

							return
						end
					end
				end

				local item = list[p2]

				if item and item:IsDescendantOf(CoreGui) then
					object:focusGuiObject(item, false)
				end

				focus(p2 > #list and 1 or p2 % #list + 1)
			end
		end)

		table.insert(threads, thread)
	end

	for k, item in list do
		table.insert(connections, item.SelectionChanged:Connect(onFocusChange))
	end

	local v6 = 1
	table.insert(threads, (task.delay(duration, function()
		if not v5 then
			local selectedCoreObject = GuiService.SelectedCoreObject

			if selectedCoreObject then
				for k, ancestor in list do
					if selectedCoreObject == ancestor or selectedCoreObject:IsDescendantOf(ancestor) then
						if not v5 then
							v5 = true

							for k2, connection in connections do
								connection:Disconnect()
							end
						end

						return
					end
				end
			end

			local item = list[v6]

			if item and item:IsDescendantOf(CoreGui) then
				object:focusGuiObject(item, false)
			end

			focus(v6 > #list and 1 or v6 % #list + 1)
		end
	end)))

	return {
		cancel = function()
			for k, v7 in threads do
				task.cancel(v7)
			end

			table.clear(threads)

			if not v5 then
				v5 = true

				for k, connection in connections do
					connection:Disconnect()
				end
			end
		end
	}
end

return function(p2, p3)
	local v5 = React.useContext(focusNavigationContext)
	return React.useCallback(function()
		if v5 then
			return fn(p3, p2, v5)
		end

		return nil
	end, { v5, p2, p3 })
end
