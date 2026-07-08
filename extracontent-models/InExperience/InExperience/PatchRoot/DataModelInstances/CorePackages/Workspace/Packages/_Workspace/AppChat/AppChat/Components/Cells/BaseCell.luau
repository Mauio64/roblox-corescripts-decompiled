local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local Foundation = require(AppChatParent.Foundation)
local useCursor = Foundation.Hooks.useCursor
local React = require(AppChatParent.React)
local useState = React.useState
local memo = React.memo
local useMemo = React.useMemo
local UIBlox = require(AppChatParent.UIBlox)
local ControlState = UIBlox.Core.Control.Enum.ControlState
local v12 = memo(UIBlox.Core.Control.Interactable)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)

require(AppChat.types)

local t1 = {
	BackgroundTransparency = 0,
	onPressedBackgroundTransparency = 1,
	LayoutOrder = 0,
	isDisabled = false,
	showDivider = true,
	dividerTransparency = 0,
	avatarCircleCellWidth = 60,
	Size = UDim2.new(1, 0, 0, 48),
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	onPressedBackgroundColor3 = Color3.fromRGB(242, 242, 242),
	onActivated = function() -- line: 51
		print("BaseCell onActivated")
	end,
	dividerColor3 = Color3.fromRGB(227, 227, 227)
}

local function BaseCell(t2: {[any]: any}) -- line: 61
	-- upvalues: Cryo (copy), t1 (copy), useState (copy), ControlState (copy), React (copy), useMemo (copy), useCursor (copy), Foundation (copy), v12 (copy), FFlagDebugAppChatEnableDomLocators (copy)
	local v17 = Cryo.Dictionary.join(t1, t2)
	local v18, v19 = useState(ControlState.Initialize)
	local v20 = React.useCallback(function(_, p2) -- line: 65
		-- upvalues: v17 (copy), v19 (copy)
		if not v17.isDisabled then
			v19(p2)
		end
	end, { v17.isDisabled })
	local v21 = React.useCallback(function() -- line: 71
		-- upvalues: v17 (copy)
		if not v17.isDisabled then
			v17.onActivated()
		end
	end, {
		v17.isDisabled,
		v17.onActivated
	})
	local v22 = useMemo(function() -- line: 77
		-- upvalues: v18 (copy), ControlState (copy), React (copy), v17 (copy)
		if v18 == ControlState.Pressed then
			return (React.createElement("ImageLabel", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = v17.onPressedBackgroundTransparency,
				BackgroundColor3 = v17.onPressedBackground3
			}))
		end

		return nil
	end, {
		v18,
		v17.onPressedBackground3,
		v17.onPressedBackgroundTransparency
	})
	local v23 = useMemo(function() -- line: 87
		-- upvalues: v17 (copy), React (copy)
		if v17.showDivider then
			return (React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				layout = React.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
					HorizontalAlignment = Enum.HorizontalAlignment.Right
				}),
				divider = React.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundTransparency = v17.dividerTransparency,
					BackgroundColor3 = v17.dividerColor3,
					Size = UDim2.new(1, -v17.avatarCircleCellWidth, 0, 1)
				})
			}))
		end

		return nil
	end, {
		v17.showDivider,
		v17.dividerTransparency,
		v17.dividerColor3,
		v17.avatarCircleCellWidth
	})
	local v24 = useMemo(function() -- line: 113
		-- upvalues: Cryo (copy), v17 (copy), v22 (copy), v23 (copy)
		return Cryo.Dictionary.join(v17.children or {}, {
			overlay = v22,
			divider = v23
		})
	end, {
		v17.children,
		v22,
		v23
	})
	local v25 = useCursor(Foundation.Enums.CursorType.RoundedSlot)

	return React.createElement(v12, {
		onStateChanged = v20,
		[React.Event.Activated] = v21,
		[React.Tag] = if not FFlagDebugAppChatEnableDomLocators or v17.testId == nil then nil else `data-testid={ v17.testId }`,
		AutoButtonColor = false,
		Selectable = v17.Selectable,
		SelectionImageObject = v25,
		Size = v17.Size,
		AutomaticSize = v17.AutomaticSize,
		BackgroundColor3 = v17.BackgroundColor3,
		BackgroundTransparency = v17.BackgroundTransparency,
		LayoutOrder = v17.LayoutOrder,
		BorderSizePixel = 0
	}, v24)
end

return memo(BaseCell)
