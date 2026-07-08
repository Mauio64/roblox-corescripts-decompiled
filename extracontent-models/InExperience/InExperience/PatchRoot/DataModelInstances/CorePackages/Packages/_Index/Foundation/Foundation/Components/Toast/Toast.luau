local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local React = require(FoundationParent.React)
local Logger = require(Foundation.Utility.Logger)
local Button = require(Foundation.Components.Button)
local Image = require(Foundation.Components.Image)
local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useCursor = require(Foundation.Providers.Cursor.useCursor)
local useScaledValue = require(Foundation.Utility.useScaledValue)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

require(Foundation.Enums.ButtonVariant)

local FillBehavior = require(Foundation.Enums.FillBehavior)
local InputSize = require(Foundation.Enums.InputSize)
local t1 = {
	testId = "--foundation-toast"
}

local function Toast(p1, p2) -- line: 44
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), useCursor (copy), React (copy), Logger (copy), InputSize (copy), FillBehavior (copy), Dash (copy), Button (copy), useScaledValue (copy), View (copy), withCommonProps (copy), Image (copy), Text (copy)
	local v21 = withDefaults(p1, t1)
	local v22 = useTokens()
	local v23 = useCursor({
		radius = UDim.new(0, v22.Radius.Medium),
		offset = v22.Size.Size_200,
		borderWidth = v22.Stroke.Thicker
	})
	local actions = v21.actions
	local v25 = React.useMemo(function() -- line: 54
		-- upvalues: actions (copy), Logger (copy), InputSize (copy), FillBehavior (copy), Dash (copy), React (copy), Button (copy)
		local t2 = {}

		if actions then
			for v31, v32 in actions do
				if v31 > 2 then
					Logger:warning(`Toast only supports up to { 2 } actions`)

					return t2
				end

				local t3 = {
					LayoutOrder = #actions - v31,
					size = InputSize.Medium,
					fillBehavior = FillBehavior.Fill
				}
				local v34 = Dash.union(v32, t3)

				t2["ToastButton" .. v31] = React.createElement(Button, v34)
			end
		end

		return t2
	end, { actions })
	local v26 = v21.icon and v21.icon ~= ""
	local v27 = v21.title and v21.title ~= ""
	local v28 = v21.text and v21.text ~= ""
	local v29 = v21.width or UDim.new(0, useScaledValue(400))

	return React.createElement(View, withCommonProps(v21, {
		tag = "row gap-small auto-y padding-medium radius-medium bg-over-media-0",
		Size = UDim2.new(v29, UDim.new()),
		Position = UDim2.fromScale(0.5, 0.1),
		selection = {
			Selectable = false,
			SelectionImageObject = v23
		},
		ref = p2
	}), {
		Media = if not v26 then nil else React.createElement(Image, {
			LayoutOrder = 1,
			tag = "size-1200-1200",
			Image = v21.icon,
			testId = `{ v21.testId }--media`
		}),
		Content = React.createElement(View, {
			LayoutOrder = 2,
			tag = {
				["fill self-center auto-y"] = true,
				["col gap-xxsmall"] = v27 or v28
			},
			testId = `{ v21.testId }--content`
		}, {
			Header = if not v27 then nil else React.createElement(Text, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-title-small text-align-x-left text-truncate-end content-emphasis",
				Text = v21.title,
				testId = `{ v21.testId }--header`
			}),
			Body = if not v28 then nil else React.createElement(Text, {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-default",
				Text = v21.text,
				testId = `{ v21.testId }--body`
			}),
			Actions = if not actions or not (#actions > 0) then nil else React.createElement(View, {
				LayoutOrder = 3,
				tag = {
					["row gap-small size-full-0 auto-y"] = true,
					["padding-top-small"] = v27 or v28
				},
				testId = `{ v21.testId }--actions`
			}, v25)
		})
	})
end

return React.memo(React.forwardRef(Toast))
