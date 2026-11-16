local CoreGui = game:GetService("CoreGui")
local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local useChatIsVisible = require(script.Parent.useChatIsVisible)
local LuauPolyfill = require(parent.LuauPolyfill)
local setTimeout = LuauPolyfill.setTimeout
local getGuiObjectBackgroundTransparency = require(AppChat.Utils.getGuiObjectBackgroundTransparency)
local FFlagAppChatGuiVisibleUsesStyledTransparency = require(AppChat.Flags.FFlagAppChatGuiVisibleUsesStyledTransparency)

local defineFastInt = game:DefineFastInt("AppChat.GuiVisibleBatchUpdateIntervalMs", 1000)

local function getGuiObjectIsObscuredAtPosition(ancestor, p: number, p2: number): boolean
	local guiObjectsAtPosition = CoreGui:GetGuiObjectsAtPosition(p, p2)

	for _, guiObject in guiObjectsAtPosition do
		if not guiObject:IsA("GuiObject") then
			continue
		end

		local v

		if FFlagAppChatGuiVisibleUsesStyledTransparency then
			v = getGuiObjectBackgroundTransparency(guiObject)
		else
			v = guiObject.BackgroundTransparency
		end

		if guiObject == ancestor then
			return false
		end

		if guiObject.Visible ~= false and not (v > 0.95) and not guiObject:IsDescendantOf(ancestor) then
			return true
		end
	end

	return false
end

local function getGuiObjectIsObscured(current)
	local absolutePosition = current.AbsolutePosition
	local absoluteSize = current.AbsoluteSize
	local v = absolutePosition + absoluteSize * 0.5

	local v2 = absolutePosition + absoluteSize
	local v3 = absolutePosition + Vector2.new(absoluteSize.X, 0)
	local v4 = absolutePosition + Vector2.new(0, absoluteSize.Y)
	local v5 = 1

	local uiCorner = current:FindFirstChildOfClass("UICorner")

	if uiCorner and uiCorner:IsA("UICorner") then
		local offset = uiCorner.CornerRadius.Offset

		if offset > 0 then
			v5 = math.ceil(offset * 0.3) + 1
		end
	end

	local guiObjectIsObscuredAtPosition = getGuiObjectIsObscuredAtPosition(current, v.X, v.Y)

	local guiObjectIsObscuredAtPosition2 = getGuiObjectIsObscuredAtPosition(
		current,
		absolutePosition.X + v5,
		absolutePosition.Y + v5
	)

	local guiObjectIsObscuredAtPosition3 = getGuiObjectIsObscuredAtPosition(current, v4.X + v5, v4.Y - v5)

	local guiObjectIsObscuredAtPosition4 = getGuiObjectIsObscuredAtPosition(current, v3.X - v5, v3.Y + v5)

	local guiObjectIsObscuredAtPosition5 = getGuiObjectIsObscuredAtPosition(current, v2.X - v5, v2.Y - v5)

	return guiObjectIsObscuredAtPosition
		or guiObjectIsObscuredAtPosition2
		or guiObjectIsObscuredAtPosition3
		or guiObjectIsObscuredAtPosition4
		or guiObjectIsObscuredAtPosition5
end

local function useIsGuiInChatVisible(p, p2)
	local v = useChatIsVisible()
	local state, setState = React.useState(false)
	local ref = React.useRef(nil)

	React.useEffect(function()
		local function updateIsGuiVisible() -- 1 equivalent call inferred from this helper
			if not (p.current and p.current:IsA("GuiObject")) then
				setState(false)

				return
			end

			local isNotOccluded = p.current.IsNotOccluded
			local guiObjectIsObscured = getGuiObjectIsObscured(p.current)

			setState(isNotOccluded and not guiObjectIsObscured)
		end
		local function queueUpdateIsGuiVisible() -- 2 equivalent calls inferred from this helper
			if ref.current then
				return
			end

			ref.current = setTimeout(function()
				ref.current = nil
				updateIsGuiVisible() -- inferred equivalent call
			end, defineFastInt)
		end
		local function onDescendantEvent(guiObject)
			if not guiObject:IsA("GuiObject") then
				return
			end

			queueUpdateIsGuiVisible() -- inferred equivalent call
		end

		queueUpdateIsGuiVisible() -- inferred equivalent call
		local connections = {}

		if p.current and p.current:IsA("GuiObject") and v then
			table.insert(
				connections,
				p.current:GetPropertyChangedSignal("IsNotOccluded"):Connect(queueUpdateIsGuiVisible)
			)

			local layerCollector = p.current:FindFirstAncestorWhichIsA("LayerCollector")

			if layerCollector then
				table.insert(connections, layerCollector.DescendantAdded:Connect(onDescendantEvent))
				table.insert(connections, layerCollector.DescendantRemoving:Connect(onDescendantEvent))
			end
		end

		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, Cryo.List.join(p2, { v }))

	return v and state
end

return useIsGuiInChatVisible
