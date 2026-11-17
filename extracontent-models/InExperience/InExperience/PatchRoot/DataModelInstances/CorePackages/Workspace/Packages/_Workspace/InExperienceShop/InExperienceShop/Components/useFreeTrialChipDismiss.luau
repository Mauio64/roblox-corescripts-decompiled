local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local ControlState = Foundation.Enums.ControlState

local submitFreeTrialTopBarChip = require(InExperienceShop.submitFreeTrialTopBarChip)
local getChipDismissInput = require(script.Parent.getChipDismissInput)
local isDismissSwipe = require(script.Parent.isDismissSwipe)

local function useFreeTrialChipDismiss(data)
	local isVisible = data.isVisible
	local isSettled = data.isSettled
	local revealLayer = data.revealLayer
	local chipRef = data.chipRef
	local state, setState = React.useState(false)
	local ref = React.useRef(false)
	local ref2 = React.useRef(nil)
	local chipDismissInput, v = getChipDismissInput()

	local function cancelHoverHide() -- 3 equivalent calls inferred from this helper
		local current = ref2.current

		if current ~= nil then
			task.cancel(current)
			ref2.current = nil
		end
	end

	local function showCloseButton() -- 3 equivalent calls inferred from this helper
		cancelHoverHide() -- inferred equivalent call
		setState(true)
	end

	local function scheduleHideCloseButton() -- 2 equivalent calls inferred from this helper
		cancelHoverHide() -- inferred equivalent call
		ref2.current = task.delay(0.15, function()
			ref2.current = nil
			setState(false)
		end)
	end

	local ref3 = React.useRef(function(_) end)
	local ref4 = React.useRef(function(_) end)

	React.useLayoutEffect(function()
		local current = chipRef.current

		if current == nil or not isVisible then
			return
		end

		local connections = {}

		if chipDismissInput then
			table.insert(connections, current.MouseEnter:Connect(function()
				showCloseButton() -- inferred equivalent call
			end))

			table.insert(connections, current.MouseLeave:Connect(function()
				scheduleHideCloseButton() -- inferred equivalent call
			end))
		end

		if v then
			local position = nil
			local function onTouchBegan(p)
				if p.UserInputType == Enum.UserInputType.Touch then
					position = p.Position
				end
			end
			local function onTouchEnded(p)
				if p.UserInputType ~= Enum.UserInputType.Touch or position == nil then
					return
				end

				local v2 = p.Position - position
				position = nil

				if isDismissSwipe(v2.X, v2.Y) then
					ref.current = true
					submitFreeTrialTopBarChip.dismiss()
				end
			end
			ref3.current = onTouchBegan
			ref4.current = onTouchEnded
			table.insert(connections, current.InputBegan:Connect(onTouchBegan))
			table.insert(connections, current.InputEnded:Connect(onTouchEnded))
		end

		return function()
			function ref3.current(_) end
			function ref4.current(_) end

			for _, connection in connections do
				connection:Disconnect()
			end

			cancelHoverHide() -- inferred equivalent call
		end
	end, { isVisible, isSettled, revealLayer, chipDismissInput, v })
	return {
		hovered = state,
		pointerDismiss = chipDismissInput,
		onChipStateChanged = function(p)
			if p == ControlState.Hover or p == ControlState.Selected then
				showCloseButton() -- inferred equivalent call
			elseif p == ControlState.Default or p == ControlState.Initialize then
				scheduleHideCloseButton() -- inferred equivalent call
			end
		end,
		onCloseActivated = function()
			submitFreeTrialTopBarChip.dismiss()
		end,
		onCloseStateChanged = function(p)
			if p == ControlState.Hover or p == ControlState.Pressed then
				showCloseButton() -- inferred equivalent call
			end
		end,
		onTouchBegan = function(p)
			ref3.current(p)
		end,
		onTouchEnded = function(p)
			ref4.current(p)
		end,
		consumeSuppressedActivation = function(): boolean
			if not ref.current then
				return false
			end

			ref.current = false
			return true
		end
	}
end

return useFreeTrialChipDismiss
