local UserInputService = game:GetService("UserInputService")

local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local FFlagAmpV2WizardCodeInputAspectRatio = require(AmpV2Wizard.FFlagAmpV2WizardCodeInputAspectRatio)

local function noop(_: string) end

local function CodeInput(props)
	local text = props.value
	local onChanged = props.onChanged
	local onComplete = props.onComplete or noop
	local isMasked = props.isMasked
	local length = props.length or 6
	local v = useTokens()

	local state, setState = React.useState(false)
	local ref = React.useRef(nil)
	local ref2 = React.useRef("")
	local v2, v3

	if FFlagAmpV2WizardCodeInputAspectRatio then
		local v4
		v2, v4 = React.useBinding(64)
		v3 = React.useCallback(function(p)
			v4((math.round(p.AbsoluteSize.X * (4 / 3))))
		end, {})
	end

	local v4 = React.useCallback(function()
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

	local releaseFocus = React.useCallback(function()
		local current = ref.current

		if current ~= nil then
			current:ReleaseFocus()
		end
	end, {})

	React.useImperativeHandle(props.controlRef, function()
		return { focus = v4, releaseFocus = releaseFocus }
	end, { v4, releaseFocus })

	React.useEffect(function()
		v4()
	end, { v4 })

	local v5 = React.useCallback(function(object)
		local v5 = object.Text:gsub("%D", "")

		if length < #v5 then
			v5 = v5:sub(1, length)
		end

		if object.Text ~= v5 then
			object.Text = v5
		end

		if v5 == ref2.current then
			return
		end

		ref2.current = v5

		onChanged(v5)

		if #v5 == length then
			object:ReleaseFocus()
			onComplete(v5)
		end
	end, { onChanged, onComplete, length })

	local children = {}

	for i = 1, length do
		local text2 = text:sub(i, i)
		local v6 = text2 ~= ""
		local v7 = state and i == #text + 1

		local formatted = `Box_{i}`
		local createElement = React.createElement
		local v8 = {
			tag = "col align-x-center align-y-center gap-small size-0-full padding-small radius-medium bg-shift-200",
			flexItem = { FlexMode = Enum.UIFlexMode.Fill },
			onAbsoluteSizeChanged = 0,
			LayoutOrder = 0,
			onActivated = 0,
			stroke = 0,
			testId = "code-input-box"
		}
		local onAbsoluteSizeChanged

		if FFlagAmpV2WizardCodeInputAspectRatio and i == 1 then
			onAbsoluteSizeChanged = v3
		end

		v8.onAbsoluteSizeChanged = onAbsoluteSizeChanged

		v8.LayoutOrder = i
		v8.onActivated = v4
		v8.stroke = v7
			and {
				Color = v.Color.System.Emphasis.Color3,
				Transparency = v.Color.System.Emphasis.Transparency,
				Thickness = v.Stroke.Thick
			}
			or nil
		local digit

		if v6 and not isMasked then
			digit = React.createElement(Text, {
				Text = text2,
				tag = "auto-xy text-title-large content-emphasis"
			})
		end

		local dot

		if v6 and isMasked then
			dot = React.createElement(View, {
				tag = "radius-circle",
				Size = UDim2.fromOffset(8, 8),
				backgroundStyle = v.Color.Content.Emphasis
			})
		end

		children[formatted] = createElement(View, v8, { Digit = digit, Dot = dot })
	end

	local createElement = React.createElement
	local size

	if FFlagAmpV2WizardCodeInputAspectRatio and v2 ~= nil then
		size = v2:map(function(p: number)
			return UDim2.new(1, 0, 0, p)
		end)
	else
		size = UDim2.new(1, 0, 0, 64)
	end

	return createElement(View, { tag = "size-full-0", Size = size, LayoutOrder = props.LayoutOrder }, {
		Boxes = React.createElement(View, { tag = "row gap-medium size-full" }, children),
		HiddenInput = React.createElement("TextBox", {
			Size = UDim2.fromOffset(1, 1),
			BackgroundTransparency = 1,
			TextTransparency = 1,
			TextSize = 1,
			Text = text,
			ClearTextOnFocus = false,
			ManualFocusRelease = true,
			OverlayNativeInput = true,
			TextInputType = Enum.TextInputType.Number,
			ref = ref,
			[React.Change.Text] = v5,
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
