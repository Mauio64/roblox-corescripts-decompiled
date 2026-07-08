local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local UserInputService = require(Foundation.Utility.Wrappers).Services.UserInputService
local Logger = require(Foundation.Utility.Logger)
local PopoverAlign = require(Foundation.Enums.PopoverAlign)
local PopoverContext = require(Foundation.Components.Popover.PopoverContext)
local PopoverSide = require(Foundation.Enums.PopoverSide)
local Radius = require(Foundation.Enums.Radius)
local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useScaledValue = require(Foundation.Utility.useScaledValue)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local Popover = require(Foundation.Components.Popover)
local t1 = {
	testId = "--foundation-tooltip",
	align = PopoverAlign.Start,
	side = PopoverSide.Right
}

local function AnchorWrapper(p1) -- line: 45
	-- upvalues: React (copy), PopoverContext (copy), Logger (copy), Popover (copy), withCommonProps (copy)
	local v21 = React.useContext(PopoverContext)
	local v22 = React.useRef(nil)

	React.useEffect(function() -- line: 49
		-- upvalues: v21 (copy), Logger (copy), v22 (copy), p1 (copy)
		if v21.anchor ~= nil then
			if typeof(v21.anchor) ~= "Instance" then
				Logger:warning("MeasurableRef cannot be an anchor for the tooltip")

				return
			end

			v22.current = v21.anchor:GetPropertyChangedSignal("GuiState"):Connect(function() -- line: 55
				-- upvalues: p1 (copy), v21 (copy)
				p1.onHover(v21.anchor.GuiState == Enum.GuiState.Hover)
			end)
		end

		return function() -- line: 60
			-- upvalues: v22 (copy)
			if v22.current ~= nil then
				v22.current:Disconnect()
			end
		end
	end, {
		v21.anchor,
		p1.onHover
	})

	return React.createElement(Popover.Anchor, withCommonProps(p1, {}), p1.children)
end
local function Tooltip(p2) -- line: 70
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), useTokens (copy), useScaledValue (copy), UserInputService (copy), Popover (copy), AnchorWrapper (copy), withCommonProps (copy), Radius (copy), View (copy), Text (copy)
	local v24 = withDefaults(p2, t1)
	local v25, v26 = React.useState(false)
	local v27 = useTokens()
	local v28 = useScaledValue(320)
	local v29 = React.useMemo(function() -- line: 76
		-- upvalues: v24 (copy), UserInputService (copy)
		if v24.shortcut == nil then
			return nil
		end

		local s1 = ""

		for v31, v32 in v24.shortcut do
			local StringForKeyCode = UserInputService:GetStringForKeyCode(v32)

			if StringForKeyCode == nil or StringForKeyCode == "" then
				StringForKeyCode = v32.Name
			end

			if v31 > 1 then
				s1 ..= " + "
			end

			s1 ..= StringForKeyCode
		end

		return s1
	end, { v24.shortcut })

	return React.createElement(Popover.Root, {
		isOpen = v25,
		testId = v24.testId
	}, {
		Anchor = React.createElement(AnchorWrapper, withCommonProps(v24, {
			onHover = v26
		}), v24.children),
		Content = React.createElement(Popover.Content, {
			hasArrow = false,
			selectionGroup = false,
			align = v24.align,
			side = {
				position = v24.side,
				offset = v27.Size.Size_200
			},
			radius = Radius.Small,
			backgroundStyle = v27.Inverse.Surface.Surface_0
		}, React.createElement(View, {
			tag = {
				["col gap-xsmall auto-xy"] = true,
				["padding-x-medium padding-y-small"] = v24.text ~= nil,
				["padding-x-small padding-y-xsmall"] = v24.text == nil
			},
			sizeConstraint = {
				MaxSize = Vector2.new(v28, 1e999)
			}
		}, {
			Header = if v24.title == "" and not v24.shortcut then nil else React.createElement(View, {
				LayoutOrder = 1,
				tag = "row flex-between gap-small size-full-0 auto-y"
			}, {
				Title = if v24.title == "" then nil else React.createElement(Text, {
					LayoutOrder = 1,
					tag = "shrink auto-xy text-title-small text-truncate-end content-inverse-emphasis",
					Text = v24.title,
					testId = `{ v24.testId }--title`
				}),
				Shortcut = if not v24.shortcut then nil else React.createElement(Text, {
					LayoutOrder = 2,
					tag = "auto-xy text-body-small content-inverse-muted",
					Text = v29,
					testId = `{ v24.testId }--shortcut`
				})
			}),
			Text = if not v24.text or v24.text == "" then nil else React.createElement(Text, {
				LayoutOrder = 2,
				tag = "auto-xy text-body-small text-wrap text-align-x-left content-inverse-default",
				Text = v24.text,
				testId = `{ v24.testId }--text`
			})
		}))
	})
end

return React.memo(Tooltip)
