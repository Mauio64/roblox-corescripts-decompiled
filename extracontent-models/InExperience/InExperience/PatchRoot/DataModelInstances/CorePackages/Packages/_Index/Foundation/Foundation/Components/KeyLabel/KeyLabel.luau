local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local UserInputService = require(Foundation.Utility.Wrappers).Services.UserInputService
local React = require(FoundationParent.React)
local ReactOtter = require(FoundationParent.ReactOtter)
local ReactUtils = require(FoundationParent.ReactUtils)
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
local t1 = {
	holdTime = 1,
	resetTime = 0.5
}
local t2 = {
	testId = "--foundation-key-label"
}
local rect = Rect.new(Vector2.new(10, 9), Vector2.new(25, 25))

local function KeyLabel(p1, p2) -- line: 53
	-- upvalues: withDefaults (copy), t2 (copy), t1 (copy), useTokens (copy), React (copy), ReactOtter (copy), getVisualForKey (copy), View (copy), withCommonProps (copy), Image (copy), rect (copy), Text (copy), CircularProgressBar (copy), EventConnection (copy), UserInputService (copy)
	local v22 = withDefaults(p1, t2)
	local v23 = if not v22.holdBehavior then nil else withDefaults(v22.holdBehavior, t1)
	local v24 = useTokens()
	local v25, v26 = React.useState(nil)
	local u27 = nil
	local v28, v29 = ReactOtter.useAnimatedBinding(0, function(n1: number) -- line: 61
		-- upvalues: v23 (copy), v25 (copy), u27 (ref), ReactOtter (copy), v26 (copy)
		if v23 and (n1 == 1 and v25) then
			u27(ReactOtter.ease(0, {
				duration = v23.resetTime,
				easingStyle = Enum.EasingStyle.Linear
			}))
			v26(nil)
			v23.onEndHold(true)
		end
	end)
	local u30 = v28

	u27 = v29

	local v31 = getVisualForKey(v22.keyCode)
	local v32 = v31.keyVisualType == "Image"

	return React.createElement(View, withCommonProps(v22, {
		Size = v22.Size,
		ref = p2
	}), {
		Image = React.createElement(Image, {
			tag = "position-center-center anchor-center-center",
			Image = not v32 and "icons/controls/keys/key_single" or v31.key,
			Size = v31.size,
			ScaleType = if v32 then nil else Enum.ScaleType.Slice,
			imageStyle = if not v25 then v24.Color.Content.Muted else v24.Color.Content.Emphasis,
			slice = if v32 then nil else {
				center = rect
			}
		}, {
			CustomPadding = if v32 then nil else React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 3)
			}),
			Text = if v32 then nil else React.createElement(Text, {
				tag = "size-full-full auto-xy text-body-medium text-align-x-center",
				Text = v31.key,
				textStyle = if not v25 then v24.Color.Content.Muted else v24.Color.Content.Emphasis
			})
		}),
		Indicator = if not v23 or not (v23.holdTime > 0) then nil else React.createElement(CircularProgressBar, {
			tag = "size-full-full",
			progress = u30,
			testId = `{ v22.testId }--indicator`
		}, {}),
		InputBeganConnection = if not v23 then nil else React.createElement(EventConnection, {
			event = UserInputService.InputBegan,
			callback = function(p3) -- line: 121
				-- upvalues: v25 (copy), v22 (copy), v23 (copy), v26 (copy), u27 (ref), ReactOtter (copy), u30 (ref)
				if v25 then
					return
				end

				if p3.KeyCode == v22.keyCode then
					if v23.onBeginHold then
						v23.onBeginHold()
					end

					if v23.holdTime == 0 then
						v23.onEndHold(true)

						return
					end

					v26(p3)
					u27(ReactOtter.ease(1, {
						duration = (1 - u30:getValue()) * v23.holdTime,
						easingStyle = Enum.EasingStyle.Linear
					}))
				end
			end
		}),
		InputEndedConnection = if not v23 then nil else React.createElement(EventConnection, {
			event = UserInputService.InputEnded,
			callback = function(p4) -- line: 147
				-- upvalues: v25 (copy), v23 (copy), v26 (copy), u27 (ref), ReactOtter (copy), u30 (ref)
				if p4 == v25 then
					if v23.onEndHold then
						v23.onEndHold(false)
					end

					v26(nil)
					u27(ReactOtter.ease(0, {
						duration = u30:getValue() * v23.resetTime,
						easingStyle = Enum.EasingStyle.Linear
					}))
				end
			end
		})
	})
end

return React.memo(React.forwardRef(KeyLabel))
