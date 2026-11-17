local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local parent = script:FindFirstAncestor("FocusNavigationUtils").Parent
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationContext = ReactFocusNavigation.FocusNavigationContext

local function fn(duration: number, list, object)
	local v = #list == 0
	local connections = {}
	local threads = {}

	local function disconnect() -- 4 equivalent calls inferred from this helper
		if not v then
			v = true

			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end

	local function onFocusChange(_, _, p)
		if p then
			disconnect() -- inferred equivalent call
		end
	end

	local function focus(p: number)
		local thread = task.delay(duration, function()
			if not v then
				local selectedCoreObject = GuiService.SelectedCoreObject

				if selectedCoreObject then
					for _, ancestor in list do
						if selectedCoreObject == ancestor or selectedCoreObject:IsDescendantOf(ancestor) then
							disconnect() -- inferred equivalent call
							return
						end
					end
				end

				local item = list[p]

				if item and item:IsDescendantOf(CoreGui) then
					object:focusGuiObject(item, false)
				end

				focus(p > #list and 1 or p % #list + 1)
			end
		end)

		table.insert(threads, thread)
	end

	for _, item in list do
		table.insert(connections, item.SelectionChanged:Connect(onFocusChange))
	end

	local v2 = 1
	table.insert(threads, (task.delay(duration, function()
		if not v then
			local selectedCoreObject = GuiService.SelectedCoreObject

			if selectedCoreObject then
				for _, ancestor in list do
					if selectedCoreObject == ancestor or selectedCoreObject:IsDescendantOf(ancestor) then
						disconnect() -- inferred equivalent call
						return
					end
				end
			end

			local item = list[v2]

			if item and item:IsDescendantOf(CoreGui) then
				object:focusGuiObject(item, false)
			end

			focus(v2 > #list and 1 or v2 % #list + 1)
		end
	end)))

	return {
		cancel = function()
			for _, v3 in threads do
				task.cancel(v3)
			end

			table.clear(threads)
			disconnect() -- inferred equivalent call
		end
	}
end

return function(p, p2: number)
	local v = React.useContext(FocusNavigationContext)
	return React.useCallback(function()
		if v then
			return fn(p2, p, v)
		end

		return nil
	end, { v, p, p2 })
end
