local CoreGui = game:GetService("CoreGui")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useChatIsVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useChatIsVisible")
local setTimeout = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LuauPolyfill").setTimeout
local getGuiObjectBackgroundTransparency = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getGuiObjectBackgroundTransparency")
local FFlagAppChatGuiVisibleUsesStyledTransparency = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatGuiVisibleUsesStyledTransparency")

local defineFastInt = game:DefineFastInt("AppChat.GuiVisibleBatchUpdateIntervalMs", 1000)

local function getGuiObjectIsObscuredAtPosition(ancestor, p2, p3): boolean
	local guiObjectsAtPosition = CoreGui:GetGuiObjectsAtPosition(p2, p3)

	for k, guiObject in guiObjectsAtPosition do
		if not guiObject:IsA("GuiObject") then
			continue
		end

		local v5 = if FFlagAppChatGuiVisibleUsesStyledTransparency then getGuiObjectBackgroundTransparency(guiObject) else guiObject.BackgroundTransparency

		if guiObject == ancestor then
			return false
		end

		if guiObject.Visible ~= false and not (v5 > 0.95) and not guiObject:IsDescendantOf(ancestor) then
			return true
		end
	end

	return false
end

local function getGuiObjectIsObscured(current)
	local absolutePosition = current.AbsolutePosition
	local absoluteSize = current.AbsoluteSize
	local v5 = absolutePosition + absoluteSize * 0.5

	local v6 = absolutePosition + absoluteSize
	local v7 = absolutePosition + Vector2.new(absoluteSize.X, 0)
	local v8 = absolutePosition + Vector2.new(0, absoluteSize.Y)
	local v9 = 1

	local uiCorner = current:FindFirstChildOfClass("UICorner")

	if uiCorner and uiCorner:IsA("UICorner") then
		local offset = uiCorner.CornerRadius.Offset

		if offset > 0 then
			v9 = math.ceil(offset * 0.3) + 1
		end
	end

	local guiObjectIsObscuredAtPosition = getGuiObjectIsObscuredAtPosition(current, v5.X, v5.Y)

	local guiObjectIsObscuredAtPosition2 = getGuiObjectIsObscuredAtPosition(
		current,
		absolutePosition.X + v9,
		absolutePosition.Y + v9
	)

	local guiObjectIsObscuredAtPosition3 = getGuiObjectIsObscuredAtPosition(current, v8.X + v9, v8.Y - v9)

	local guiObjectIsObscuredAtPosition4 = getGuiObjectIsObscuredAtPosition(current, v7.X - v9, v7.Y + v9)

	local guiObjectIsObscuredAtPosition5 = getGuiObjectIsObscuredAtPosition(current, v6.X - v9, v6.Y - v9)

	return guiObjectIsObscuredAtPosition
		or guiObjectIsObscuredAtPosition2
		or guiObjectIsObscuredAtPosition3
		or guiObjectIsObscuredAtPosition4
		or guiObjectIsObscuredAtPosition5
end

local function useIsGuiInChatVisible(p2, p3)
	local v5 = useChatIsVisible()
	local state, setState = React.useState(false)
	local ref = React.useRef(nil)

	React.useEffect(function()
		local function updateIsGuiVisible()
			if not (p2.current and p2.current:IsA("GuiObject")) then
				setState(false)

				return
			end

			local isNotOccluded = p2.current.IsNotOccluded
			local guiObjectIsObscured = getGuiObjectIsObscured(p2.current)

			setState(isNotOccluded and not guiObjectIsObscured)
		end
		local function queueUpdateIsGuiVisible()
			if ref.current then
				return
			end

			ref.current = setTimeout(function()
				ref.current = nil

				if not (p2.current and p2.current:IsA("GuiObject")) then
					setState(false)

					return
				end

				local isNotOccluded = p2.current.IsNotOccluded
				local guiObjectIsObscured = getGuiObjectIsObscured(p2.current)

				setState(isNotOccluded and not guiObjectIsObscured)
			end, defineFastInt)
		end
		local function onDescendantEvent(guiObject)
			if not guiObject:IsA("GuiObject") or ref.current then
				return
			end

			ref.current = setTimeout(function()
				ref.current = nil

				if not (p2.current and p2.current:IsA("GuiObject")) then
					setState(false)

					return
				end

				local isNotOccluded = p2.current.IsNotOccluded
				local guiObjectIsObscured = getGuiObjectIsObscured(p2.current)

				setState(isNotOccluded and not guiObjectIsObscured)
			end, defineFastInt)
		end

		if not ref.current then
			ref.current = setTimeout(function()
				ref.current = nil

				if not (p2.current and p2.current:IsA("GuiObject")) then
					setState(false)

					return
				end

				local isNotOccluded = p2.current.IsNotOccluded
				local guiObjectIsObscured = getGuiObjectIsObscured(p2.current)

				setState(isNotOccluded and not guiObjectIsObscured)
			end, defineFastInt)
		end

		local connections = {}

		if p2.current and p2.current:IsA("GuiObject") and v5 then
			table.insert(
				connections,
				p2.current:GetPropertyChangedSignal("IsNotOccluded"):Connect(queueUpdateIsGuiVisible)
			)

			local layerCollector = p2.current:FindFirstAncestorWhichIsA("LayerCollector")

			if layerCollector then
				table.insert(connections, layerCollector.DescendantAdded:Connect(onDescendantEvent))
				table.insert(connections, layerCollector.DescendantRemoving:Connect(onDescendantEvent))
			end
		end

		return function()
			for k, connection in connections do
				connection:Disconnect()
			end
		end
	end, Cryo.List.join(p3, { v5 }))

	return v5 and state
end

return useIsGuiInChatVisible
