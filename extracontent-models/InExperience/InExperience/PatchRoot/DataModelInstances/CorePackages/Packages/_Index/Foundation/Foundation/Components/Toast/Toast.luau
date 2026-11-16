local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Dash = require(parent.Dash)
local React = require(parent.React)

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

local v = { testId = "--foundation-toast" }

local function Toast(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local selectionImageObject = useCursor({
		radius = UDim.new(0, v3.Radius.Medium),
		offset = v3.Size.Size_200,
		borderWidth = v3.Stroke.Thicker
	})

	local actions = v2.actions
	local v4 = React.useMemo(function()
		local children = {}

		if not actions then
			return children
		end

		for k, action in actions do
			if k > 2 then
				Logger:warning(`Toast only supports up to {2} actions`)
				return children
			end

			local v4 = {
				LayoutOrder = #actions - k,
				size = InputSize.Medium,
				fillBehavior = FillBehavior.Fill
			}

			local union = Dash.union(action, v4)
			children["ToastButton" .. k] = React.createElement(Button, union)
		end

		return children
	end, { actions })

	local v5 = v2.icon and v2.icon ~= ""
	local v6 = v2.title and v2.title ~= ""
	local v7 = v2.text and v2.text ~= ""

	local width = v2.width or UDim.new(0, useScaledValue(400))

	local createElement = React.createElement

	local v8 = withCommonProps(v2, {
		Size = UDim2.new(width, UDim.new()),
		Position = UDim2.fromScale(0.5, 0.1),
		selection = { Selectable = false, SelectionImageObject = selectionImageObject },
		tag = "row gap-small auto-y padding-medium radius-medium bg-over-media-0",
		ref = ref
	})
	local media

	if v5 then
		media = React.createElement(Image, {
			LayoutOrder = 1,
			Image = v2.icon,
			tag = "size-1200-1200",
			testId = `{v2.testId}--media`
		})
	end

	local createElement2 = React.createElement
	local v9 = {
		LayoutOrder = 2,
		tag = {
			["fill self-center auto-y"] = true,
			["col gap-xxsmall"] = v6 or v7
		},
		testId = `{v2.testId}--content`
	}
	local header

	if v6 then
		header = React.createElement(Text, {
			LayoutOrder = 1,
			Text = v2.title,
			tag = "size-full-0 auto-y text-title-small text-align-x-left text-truncate-end content-emphasis",
			testId = `{v2.testId}--header`
		})
	end

	local body

	if v7 then
		body = React.createElement(Text, {
			LayoutOrder = 2,
			Text = v2.text,
			tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-default",
			testId = `{v2.testId}--body`
		})
	end

	local actions2

	if actions and #actions > 0 then
		actions2 = React.createElement(View, {
			LayoutOrder = 3,
			tag = {
				["row gap-small size-full-0 auto-y"] = true,
				["padding-top-small"] = v6 or v7
			},
			testId = `{v2.testId}--actions`
		}, v4)
	end

	return createElement(View, v8, {
		Media = media,
		Content = createElement2(View, v9, { Header = header, Body = body, Actions = actions2 })
	})
end

return React.memo(React.forwardRef(Toast))
