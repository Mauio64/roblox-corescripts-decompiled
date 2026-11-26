local CoreGui = game:GetService("CoreGui")

return function(p2)
	local guiObjectsAtPosition = CoreGui:GetGuiObjectsAtPosition(p2.X, p2.Y)

	if #guiObjectsAtPosition == 0 then
		return nil
	end

	local v5 = 1
	local v6 = nil
	local v7 = nil
	local v8 = -1
	local v9 = -1

	while v5 <= #guiObjectsAtPosition do
		local guiObject = guiObjectsAtPosition[v5]

		if not (guiObject.Visible and guiObject:IsA("ScrollingFrame")) then
			if guiObject.Selectable then
				if not v6 then
					if v7 and not guiObject:IsAncestorOf(v7) then
						v9 = v5
						v6 = guiObject
					else
						return guiObject
					end
				end
			elseif guiObject:IsA("TextLabel") and not v7 then
				v8 = v5
				v7 = guiObject
			end
		end

		v5 += 1

		if guiObject.Interactable and guiObject.Active then
			v5 = #guiObjectsAtPosition + 1
		end
	end

	if v8 > 0 and v9 > 0 then
		if v8 < v9 then
			return v7
		end

		return v6
	elseif v7 or v6 then
		return v7 or v6
	else
		return nil
	end
end
