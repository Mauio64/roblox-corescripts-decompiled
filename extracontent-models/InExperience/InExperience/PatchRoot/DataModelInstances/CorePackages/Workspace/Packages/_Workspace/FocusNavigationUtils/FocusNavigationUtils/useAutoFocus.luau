local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local Parent = script:FindFirstAncestor("FocusNavigationUtils").Parent
local React = require(Parent.React)
local FocusNavigationContext = require(Parent.ReactFocusNavigation).FocusNavigationContext
local FFlagLuaAppsDefaultSelection = require(Parent.SharedFlags).FFlagLuaAppsDefaultSelection

local function v7(n1: number, t1: {[any]: any}, p1) -- line: 19
	-- upvalues: FFlagLuaAppsDefaultSelection (copy), GuiService (copy), CoreGui (copy)
	local u11 = #t1 == 0
	local t2 = {}
	local t3 = {}

	local function disconnect() -- line: 24
		-- upvalues: u11 (ref), t2 (copy)
		if not u11 then
			u11 = true

			for _, v24 in t2 do
				v24:Disconnect()
			end
		end
	end
	local function onFocusChange(_, _, p4) -- line: 33
		-- upvalues: u11 (ref), t2 (copy)
		if p4 and not u11 then
			u11 = true

			for _, v29 in t2 do
				v29:Disconnect()
			end
		end
	end
	local function focus(n2: number) -- line: 39
		-- upvalues: n1 (copy), u11 (ref), FFlagLuaAppsDefaultSelection (copy), GuiService (copy), t1 (copy), t2 (copy), CoreGui (copy), p1 (copy), focus (copy), t3 (copy)
		local thread = task.delay(n1, function() -- line: 40
			-- upvalues: u11 (ref), FFlagLuaAppsDefaultSelection (copy), GuiService (copy), t1 (copy), t2 (copy), n2 (copy), CoreGui (copy), p1 (copy), focus (copy)
			if not u11 then
				if FFlagLuaAppsDefaultSelection then
					local SelectedCoreObject = GuiService.SelectedCoreObject

					if SelectedCoreObject then
						for _, v45 in t1 do
							if SelectedCoreObject == v45 or SelectedCoreObject:IsDescendantOf(v45) then
								if not u11 then
									u11 = true

									for _, v47 in t2 do
										v47:Disconnect()
									end
								end

								return
							end
						end
					end
				end

				local v48 = t1[n2]

				if v48 and v48:IsDescendantOf(CoreGui) then
					p1:focusGuiObject(v48, false)
				end

				local v49 = if not (n2 > #t1) then n2 % #t1 + 1 else 1

				focus(v49)
			end
		end)

		table.insert(t3, thread)
	end

	for _, v18 in t1 do
		table.insert(t2, v18.SelectionChanged:Connect(onFocusChange))
	end

	local n3 = 1

	table.insert(t3, (task.delay(n1, function() -- line: 40
		-- upvalues: u11 (ref), FFlagLuaAppsDefaultSelection (copy), GuiService (copy), t1 (copy), t2 (copy), n3 (copy), CoreGui (copy), p1 (copy), focus (copy)
		if not u11 then
			if FFlagLuaAppsDefaultSelection then
				local SelectedCoreObject = GuiService.SelectedCoreObject

				if SelectedCoreObject then
					for _, v34 in t1 do
						if SelectedCoreObject == v34 or SelectedCoreObject:IsDescendantOf(v34) then
							if not u11 then
								u11 = true

								for _, v36 in t2 do
									v36:Disconnect()
								end
							end

							return
						end
					end
				end
			end

			local v37 = t1[n3]

			if v37 and v37:IsDescendantOf(CoreGui) then
				p1:focusGuiObject(v37, false)
			end

			local v38 = if not (n3 > #t1) then n3 % #t1 + 1 else 1

			focus(v38)
		end
	end)))

	return {
		cancel = function() -- line: 71
			-- upvalues: t3 (copy), u11 (ref), t2 (copy)
			for _, v40 in t3 do
				task.cancel(v40)
			end

			table.clear(t3)

			if not u11 then
				u11 = true

				for _, v42 in t2 do
					v42:Disconnect()
				end
			end
		end
	}
end

return function(t4: {[any]: any}, n4: number) -- line: 99
	-- upvalues: React (copy), FocusNavigationContext (copy), v7 (copy)
	local v22 = React.useContext(FocusNavigationContext)

	return React.useCallback(function() -- line: 102
		-- upvalues: v22 (copy), v7 (copy), n4 (copy), t4 (copy)
		if v22 then
			return (v7(n4, t4, v22))
		end

		return nil
	end, {
		v22,
		t4,
		n4
	})
end
