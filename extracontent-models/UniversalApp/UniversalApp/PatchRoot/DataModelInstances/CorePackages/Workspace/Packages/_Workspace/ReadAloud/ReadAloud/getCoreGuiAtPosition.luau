local CoreGui = game:GetService("CoreGui")

return function(vector2: Vector2) -- line: 4
	-- upvalues: CoreGui (copy)
	local GuiObjectsAtPosition = CoreGui:GetGuiObjectsAtPosition(vector2.X, vector2.Y)

	if #GuiObjectsAtPosition == 0 then
		return nil
	end

	local n1 = 1
	local v5 = nil
	local n2 = -1
	local v7 = nil
	local n3 = -1

	while n1 <= #GuiObjectsAtPosition do
		local v9 = GuiObjectsAtPosition[n1]

		if not v9.Visible or not v9:IsA("ScrollingFrame") then
			if v9.Selectable then
				if not v7 then
					v7 = v9
					n3 = n1

					if not v5 or v9:IsAncestorOf(v5) then
						return v7
					end
				end
			elseif v9:IsA("TextLabel") and not v5 then
				v5 = v9
				n2 = n1
			end
		end

		n1 += 1

		if v9.Interactable and v9.Active then
			n1 = #GuiObjectsAtPosition + 1
		end
	end

	if n2 > 0 and n3 > 0 then
		if n2 < n3 then
			return v5
		end

		return v7
	end

	if v5 or v7 then
		return v5 or v7
	end

	return nil
end
