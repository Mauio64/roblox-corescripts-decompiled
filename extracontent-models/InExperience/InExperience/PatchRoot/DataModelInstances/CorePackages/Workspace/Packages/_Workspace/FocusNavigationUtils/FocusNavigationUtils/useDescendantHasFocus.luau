local GuiService = game:GetService("GuiService")
local Parent = script:FindFirstAncestor("FocusNavigationUtils").Parent
local React = require(Parent.React)

local function hasFocus(p1) -- line: 6
	-- upvalues: GuiService (copy)
	local SelectedCoreObject = GuiService.SelectedCoreObject

	if p1 and SelectedCoreObject then
		return (SelectedCoreObject == p1 or SelectedCoreObject:IsDescendantOf(p1)) and SelectedCoreObject:FindFirstAncestorOfClass("CoreGui") ~= nil
	end

	return false
end
local function useDescendantHasFocus(p2) -- line: 18
	-- upvalues: GuiService (copy), React (copy)
	local SelectedCoreObject = GuiService.SelectedCoreObject
	local v10 = not not (p2 and SelectedCoreObject) and ((SelectedCoreObject == p2 or SelectedCoreObject:IsDescendantOf(p2)) and SelectedCoreObject:FindFirstAncestorOfClass("CoreGui") ~= nil)
	local v11, v12 = React.useState(v10)

	React.useEffect(function() -- line: 22
		-- upvalues: p2 (copy), v12 (copy), GuiService (copy)
		local connection = nil
		local connection2 = nil

		if p2 then
			local v15 = v12
			local v16 = p2
			local SelectedCoreObject2 = GuiService.SelectedCoreObject

			v15(not not (v16 and SelectedCoreObject2) and ((SelectedCoreObject2 == v16 or SelectedCoreObject2:IsDescendantOf(v16)) and SelectedCoreObject2:FindFirstAncestorOfClass("CoreGui") ~= nil))
			connection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 28
				-- upvalues: connection2 (ref), p2 (copy), GuiService (copy), v12 (copy)
				if connection2 then
					connection2:Disconnect()
				end

				local v18 = p2
				local SelectedCoreObject3 = GuiService.SelectedCoreObject
				local v20 = not not (v18 and SelectedCoreObject3) and ((SelectedCoreObject3 == v18 or SelectedCoreObject3:IsDescendantOf(v18)) and SelectedCoreObject3:FindFirstAncestorOfClass("CoreGui") ~= nil)
				local SelectedCoreObject4 = GuiService.SelectedCoreObject

				if v20 and SelectedCoreObject4 then
					connection2 = SelectedCoreObject4.AncestryChanged:Connect(function() -- line: 36
						-- upvalues: SelectedCoreObject4 (copy), connection2 (ref), v12 (copy), p2 (copy), GuiService (copy)
						if SelectedCoreObject4:FindFirstAncestorOfClass("CoreGui") == nil then
							connection2:Disconnect()

							local v22 = v12
							local v23 = p2
							local SelectedCoreObject5 = GuiService.SelectedCoreObject

							v22(not not (v23 and SelectedCoreObject5) and ((SelectedCoreObject5 == v23 or SelectedCoreObject5:IsDescendantOf(v23)) and SelectedCoreObject5:FindFirstAncestorOfClass("CoreGui") ~= nil))
						end
					end)
				end

				v12(v20)
			end)
		else
			v12(false)
		end

		return function() -- line: 50
			-- upvalues: connection (ref), connection2 (ref)
			if connection then
				connection:Disconnect()
			end

			if connection2 then
				connection2:Disconnect()
			end
		end
	end, { p2 })

	return v11
end

return useDescendantHasFocus
