local CoreGui = game:GetService("CoreGui")
local Parent = script:FindFirstAncestor("AppChat").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local useChatIsVisible = require(script.Parent.useChatIsVisible)
local setTimeout = require(Parent.LuauPolyfill).setTimeout
local v7 = game:DefineFastInt("AppChat.GuiVisibleBatchUpdateIntervalMs", 1000)

local function getGuiObjectIsObscuredAtPosition(p1, n1: number, n2: number) -- line: 24
	-- upvalues: CoreGui (copy)
	for _, v15 in (CoreGui:GetGuiObjectsAtPosition(n1, n2)) do
		if not v15:IsA("GuiObject") then
			continue
		end

		if v15 == p1 then
			return false
		end

		if v15.Visible ~= false and not (v15.BackgroundTransparency > 0.95) and not v15:IsDescendantOf(p1) then
			return true
		end
	end

	return false
end
local function getGuiObjectIsObscured(p2) -- line: 42
	-- upvalues: getGuiObjectIsObscuredAtPosition (copy)
	local AbsolutePosition = p2.AbsolutePosition
	local AbsoluteSize = p2.AbsoluteSize
	local v19 = AbsolutePosition + AbsoluteSize * 0.5
	local v20 = AbsolutePosition + AbsoluteSize
	local v21 = AbsolutePosition + Vector2.new(AbsoluteSize.X, 0)
	local v22 = AbsolutePosition + Vector2.new(0, AbsoluteSize.Y)
	local n3 = 1
	local UICorner = p2:FindFirstChildOfClass("UICorner")

	if UICorner and UICorner:IsA("UICorner") then
		local CornerRadiusOffset = UICorner.CornerRadius.Offset

		if CornerRadiusOffset > 0 then
			n3 = math.ceil(CornerRadiusOffset * 0.3) + 1
		end
	end

	local v26 = getGuiObjectIsObscuredAtPosition(p2, v19.X, v19.Y)
	local v27 = getGuiObjectIsObscuredAtPosition(p2, AbsolutePosition.X + n3, AbsolutePosition.Y + n3)
	local v28 = getGuiObjectIsObscuredAtPosition(p2, v22.X + n3, v22.Y - n3)
	local v29 = getGuiObjectIsObscuredAtPosition(p2, v21.X - n3, v21.Y + n3)
	local v30 = getGuiObjectIsObscuredAtPosition(p2, v20.X - n3, v20.Y - n3)

	return v26 or (v27 or (v28 or (v29 or v30)))
end
local function useIsGuiInChatVisible(t1: {[any]: any}, t2: {[any]: any}) -- line: 82
	-- upvalues: useChatIsVisible (copy), React (copy), getGuiObjectIsObscured (copy), setTimeout (copy), v7 (copy), Cryo (copy)
	local v33 = useChatIsVisible()
	local v34, v35 = React.useState(false)
	local v36 = React.useRef(nil)

	React.useEffect(function() -- line: 92
		-- upvalues: t1 (copy), getGuiObjectIsObscured (copy), v35 (copy), v36 (copy), setTimeout (copy), v7 (copy), v33 (copy)
		local function updateIsGuiVisible() -- line: 93
			-- upvalues: t1 (copy), getGuiObjectIsObscured (copy), v35 (copy)
			if t1.current and t1.current:IsA("GuiObject") then
				local IsNotOccluded = t1.current.IsNotOccluded
				local v43 = getGuiObjectIsObscured(t1.current)
				local v44 = IsNotOccluded and not v43

				v35(v44)

				return
			end

			v35(false)
		end
		local function queueUpdateIsGuiVisible() -- line: 103
			-- upvalues: v36 (copy), setTimeout (copy), t1 (copy), getGuiObjectIsObscured (copy), v35 (copy), v7 (copy)
			if v36.current then
				return
			end

			v36.current = setTimeout(function() -- line: 107
				-- upvalues: v36 (copy), t1 (copy), getGuiObjectIsObscured (copy), v35 (copy)
				v36.current = nil

				if t1.current and t1.current:IsA("GuiObject") then
					local IsNotOccluded = t1.current.IsNotOccluded
					local v52 = getGuiObjectIsObscured(t1.current)
					local v53 = IsNotOccluded and not v52

					v35(v53)

					return
				end

				v35(false)
			end, v7)
		end
		local function onDescendantEvent(p3) -- line: 112
			-- upvalues: v36 (copy), setTimeout (copy), t1 (copy), getGuiObjectIsObscured (copy), v35 (copy), v7 (copy)
			if not p3:IsA("GuiObject") then
				return
			end

			if v36.current then
				return
			end

			v36.current = setTimeout(function() -- line: 107
				-- upvalues: v36 (copy), t1 (copy), getGuiObjectIsObscured (copy), v35 (copy)
				v36.current = nil

				if t1.current and t1.current:IsA("GuiObject") then
					local IsNotOccluded = t1.current.IsNotOccluded
					local v55 = getGuiObjectIsObscured(t1.current)
					local v56 = IsNotOccluded and not v55

					v35(v56)

					return
				end

				v35(false)
			end, v7)
		end

		if not v36.current then
			v36.current = setTimeout(function() -- line: 107
				-- upvalues: v36 (copy), t1 (copy), getGuiObjectIsObscured (copy), v35 (copy)
				v36.current = nil

				if t1.current and t1.current:IsA("GuiObject") then
					local IsNotOccluded = t1.current.IsNotOccluded
					local v47 = getGuiObjectIsObscured(t1.current)
					local v48 = IsNotOccluded and not v47

					v35(v48)

					return
				end

				v35(false)
			end, v7)
		end

		local t3 = {}

		if t1.current and t1.current:IsA("GuiObject") and v33 then
			table.insert(t3, t1.current:GetPropertyChangedSignal("IsNotOccluded"):Connect(queueUpdateIsGuiVisible))

			local LayerCollector = t1.current:FindFirstAncestorWhichIsA("LayerCollector")

			if LayerCollector then
				table.insert(t3, LayerCollector.DescendantAdded:Connect(onDescendantEvent))
				table.insert(t3, LayerCollector.DescendantRemoving:Connect(onDescendantEvent))
			end
		end

		return function() -- line: 133
			-- upvalues: t3 (copy)
			for _, v50 in t3 do
				v50:Disconnect()
			end
		end
	end, Cryo.List.join(t2, { v33 }))

	return v33 and v34
end

return useIsGuiInChatVisible
