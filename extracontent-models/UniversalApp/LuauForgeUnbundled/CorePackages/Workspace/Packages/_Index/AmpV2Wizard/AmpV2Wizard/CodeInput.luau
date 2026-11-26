local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/Foundation")
local view = Foundation.View
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local FFlagAmpV2WizardCodeInputAspectRatio = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/FFlagAmpV2WizardCodeInputAspectRatio")

local function noop(p2) end

local function CodeInput(props)
	local value = props.value
	local onChanged = props.onChanged
	local onComplete = props.onComplete or noop
	local isMasked = props.isMasked
	local length = props.length or 6
	local v5 = useTokens()

	local state, setState = React.useState(false)
	local ref = React.useRef(nil)
	local ref2 = React.useRef("")
	local v6, v7

	if FFlagAmpV2WizardCodeInputAspectRatio then
		local v8
		v6, v8 = React.useBinding(64)
		v7 = React.useCallback(function(p2)
			v8((math.round(p2.AbsoluteSize.X * (4 / 3))))
		end, {})
	end

	local v8 = React.useCallback(function()
		local current = ref.current

		if
			current == nil
			or UserInputService.OnScreenKeyboardVisible and UserInputService:GetFocusedTextBox() == current
		then
			return
		end

		current:ReleaseFocus()
		task.defer(function()
			local current2 = ref.current

			if current2 ~= nil then
				current2:CaptureFocus()
			end
		end)
	end, {})

	local v9 = React.useCallback(function()
		local current = ref.current

		if current ~= nil then
			current:ReleaseFocus()
		end
	end, {})

	React.useImperativeHandle(props.controlRef, function()
		return { focus = v8, releaseFocus = v9 }
	end, { v8, v9 })

	React.useEffect(function()
		v8()
	end, { v8 })

	local v10 = React.useCallback(function(object)
		local v11 = object.Text:gsub("%D", "")

		if length < #v11 then
			v11 = v11:sub(1, length)
		end

		if object.Text ~= v11 then
			object.Text = v11
		end

		if v11 == ref2.current then
			return
		end

		ref2.current = v11

		onChanged(v11)

		if #v11 == length then
			object:ReleaseFocus()
			onComplete(v11)
		end
	end, { onChanged, onComplete, length })

	local children = {}

	for i = 1, length do
		local v11 = value:sub(i, i)
		local v12 = v11 ~= ""
		local v13 = state and i == #value + 1

		local formatted = `Box_{i}`
		local createElement = React.createElement
		local v15 = {
			tag = "col align-x-center align-y-center gap-small size-0-full padding-small radius-medium bg-shift-200",
			flexItem = { FlexMode = Enum.UIFlexMode.Fill },
			onAbsoluteSizeChanged = 0,
			LayoutOrder = 0,
			onActivated = 0,
			stroke = 0,
			testId = "code-input-box"
		}
		local v16 = if FFlagAmpV2WizardCodeInputAspectRatio and i == 1 then v7 else nil
		v15.onAbsoluteSizeChanged = v16

		v15.LayoutOrder = i
		v15.onActivated = v8
		v15.stroke = v13
			and {
				Color = v5.Color.System.Emphasis.Color3,
				Transparency = v5.Color.System.Emphasis.Transparency,
				Thickness = v5.Stroke.Thick
			}
			or nil

		local v18 = if v12 and not isMasked then React.createElement(text, {
			Text = v11,
			tag = "auto-xy text-title-large content-emphasis"
		}) else nil

		local v19 = if v12 and isMasked then React.createElement(view, {
			tag = "radius-circle",
			Size = UDim2.fromOffset(8, 8),
			backgroundStyle = v5.Color.Content.Emphasis
		}) else nil
		children[formatted] = createElement(view, v15, { Digit = v18, Dot = v19 })
	end

	local createElement = React.createElement
	local v13

	if FFlagAmpV2WizardCodeInputAspectRatio and v6 ~= nil then
		v13 = v6:map(function(p2)
			return UDim2.new(1, 0, 0, p2)
		end)
	else
		v13 = UDim2.new(1, 0, 0, 64)
	end

	return createElement(view, {
		tag = "size-full-0",
		Size = v13,
		LayoutOrder = props.LayoutOrder
	}, {
		Boxes = React.createElement(view, { tag = "row gap-medium size-full" }, children),
		HiddenInput = React.createElement("TextBox", {
			Size = UDim2.fromOffset(1, 1),
			BackgroundTransparency = 1,
			TextTransparency = 1,
			TextSize = 1,
			Text = value,
			ClearTextOnFocus = false,
			ManualFocusRelease = true,
			OverlayNativeInput = true,
			TextInputType = Enum.TextInputType.Number,
			ref = ref,
			[React.Change.Text] = v10,
			[React.Event.Focused] = function()
				setState(true)
			end,
			[React.Event.FocusLost] = function()
				setState(false)
			end
		})
	})
end

return CodeInput
