local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Wrappers = require(Foundation.Utility.Wrappers)
local UserInputService = Wrappers.Services.UserInputService

local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local ReactUtils = require(parent.ReactUtils)

local getVisualForKey = require(script.Parent.getVisualForKey)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local CircularProgressBar = require(Foundation.Components.CircularProgressBar)
local Image = require(Foundation.Components.Image)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)

local EventConnection = ReactUtils.EventConnection

local v = { holdTime = 1, resetTime = 0.5 }

local v2 = { testId = "--foundation-key-label" }

local rect = Rect.new(Vector2.new(10, 9), Vector2.new(25, 25))

local function KeyLabel(p, ref)
	local v3 = withDefaults(p, v2)
	local v4

	if v3.holdBehavior then
		v4 = withDefaults(v3.holdBehavior, v)
	else
		v4 = nil
	end

	local v5 = useTokens()

	local state, setState = React.useState(nil)
	local v6 = nil
	local progress, v7 = ReactOtter.useAnimatedBinding(0, function(p2: number)
		if v4 and p2 == 1 and state then
			v6(ReactOtter.ease(0, { duration = v4.resetTime, easingStyle = Enum.EasingStyle.Linear }))

			setState(nil)
			v4.onEndHold(true)
		end
	end)
	v6 = v7

	local visualForKey = getVisualForKey(v3.keyCode)

	local v8 = visualForKey.keyVisualType == "Image"
	local createElement = React.createElement

	local v9 = withCommonProps(v3, { Size = v3.Size, ref = ref })

	local createElement2 = React.createElement
	local v10 = {
		Image = not v8 and "icons/controls/keys/key_single" or visualForKey.key,
		Size = visualForKey.size,
		ScaleType = 0,
		imageStyle = 0,
		slice = 0,
		tag = "position-center-center anchor-center-center"
	}
	local scaleType

	if not v8 then
		scaleType = Enum.ScaleType.Slice
	end

	v10.ScaleType = scaleType
	local imageStyle

	if state then
		imageStyle = v5.Color.Content.Emphasis
	else
		imageStyle = v5.Color.Content.Muted
	end

	v10.imageStyle = imageStyle
	v10.slice = not v8 and { center = rect } or nil
	local customPadding

	if not v8 then
		customPadding = React.createElement("UIPadding", { PaddingBottom = UDim.new(0, 3) })
	end

	local text

	if not v8 then
		local createElement3 = React.createElement
		local v11 = {
			Text = visualForKey.key,
			textStyle = 0,
			tag = "size-full-full auto-xy text-body-medium text-align-x-center"
		}
		local textStyle

		if state then
			textStyle = v5.Color.Content.Emphasis
		else
			textStyle = v5.Color.Content.Muted
		end

		v11.textStyle = textStyle
		text = createElement3(Text, v11)
	end

	local v11 = {
		Image = createElement2(Image, v10, { CustomPadding = customPadding, Text = text }),
		Indicator = 0,
		InputBeganConnection = 0,
		InputEndedConnection = 0
	}
	local indicator

	if v4 and v4.holdTime > 0 then
		indicator = React.createElement(
			CircularProgressBar,
			{ progress = progress, tag = "size-full-full", testId = `{v3.testId}--indicator` },
			{}
		)
	end

	v11.Indicator = indicator
	local inputBeganConnection

	if v4 then
		inputBeganConnection = React.createElement(EventConnection, {
			event = UserInputService.InputBegan,
			callback = function(p2)
				if state then
					return
				end

				if p2.KeyCode == v3.keyCode then
					if v4.onBeginHold then
						v4.onBeginHold()
					end

					if v4.holdTime == 0 then
						v4.onEndHold(true)
					else
						setState(p2)
						v6(ReactOtter.ease(1, {
							duration = (1 - progress:getValue()) * v4.holdTime,
							easingStyle = Enum.EasingStyle.Linear
						}))
					end
				end
			end
		})
	end

	v11.InputBeganConnection = inputBeganConnection
	local inputEndedConnection

	if v4 then
		inputEndedConnection = React.createElement(EventConnection, {
			event = UserInputService.InputEnded,
			callback = function(p2)
				if p2 == state then
					if v4.onEndHold then
						v4.onEndHold(false)
					end

					setState(nil)
					v6(ReactOtter.ease(0, {
						duration = progress:getValue() * v4.resetTime,
						easingStyle = Enum.EasingStyle.Linear
					}))
				end
			end
		})
	end

	v11.InputEndedConnection = inputEndedConnection
	return createElement(View, v9, v11)
end

return React.memo(React.forwardRef(KeyLabel))
