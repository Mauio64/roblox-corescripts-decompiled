local parent = script:FindFirstAncestor("Components").Parent
local parent2 = parent.Parent
local Foundation = require(parent2.Foundation)

local React = require(parent2.React)

local useCallback = React.useCallback
local useRef = React.useRef
local useState = React.useState
local useEffect = React.useEffect

local Dash = require(parent2.Dash)
local map = Dash.map

require(parent.Components.InlineLayout.InlineLayoutElements.RenderableInlineElement)
local HardBreakElement = require(parent.Components.InlineLayout.InlineLayoutElements.HardBreakElement)
local HoverContext = require(parent.Components.InlineLayout.InlineLayoutElements.HoverContext)
local renderInMeasuredFrame = require(parent.Utils.renderInMeasuredFrame)
local MarkdownCore = require(parent2.MarkdownCore)
local View = Foundation.View

local Flags = MarkdownCore.Flags

local defineFastFlag = game:DefineFastFlag("FFlagDebugInlineLayout", false)

local function layoutElements(elements, x: number)
	if #elements == 0 then
		return {}
	end

	local v = not Flags.FFlagMarkdownAssistantParity and 100 or #elements * 4 + 100

	local v2 = {}
	local v3 = {}
	local v4 = x

	local function flushRow() -- 2 equivalent calls inferred from this helper
		table.insert(v2, v3)
		v3 = {}
		v4 = x
	end

	local v5 = 1
	local count = 0
	local v6 = nil
	local v7 = false

	while (v5 <= #elements or v6) and count < v do
		local v8 = v6 or elements[v5]

		if v8 == HardBreakElement then
			v5 += 1
			flushRow() -- inferred equivalent call
			v7 = false
		else
			if #v3 == 0 and v7 and v8.trimStart then
				v8 = v8:trimStart()

				if v8 == nil then
					v5 += 1
					count += 1
					v6 = nil
					continue
				end
			end

			local width = v8:getWidth()

			local count2 = #v3

			if width <= v4 then
				local v9 = v3
				table.insert(v9, renderInMeasuredFrame(v8:render(v5, count2), width, count2))

				v4 -= width

				v5 += 1
				v6 = nil
			else
				local v9
				v9, v6 = v8:split(v4)

				if v9:getWidth() <= v4 then
					local v10 = v3
					table.insert(v10, renderInMeasuredFrame(v9:render(v5, count2), v9:getWidth(), count2))
				elseif #v3 == 0 then
					if v8.canForceSplit then
						v9, v6 = v8:split(v4, true)
					end

					local v10 = v3
					table.insert(v10, renderInMeasuredFrame(v9:render(v5, count2), v9:getWidth(), count2))
				else
					v6 = v8
				end

				if Flags.FFlagMarkdownAssistantParity and v6 == nil then
					v5 += 1
				end

				flushRow() -- inferred equivalent call
				v7 = true
			end

			count += 1
		end
	end

	if count == v and defineFastFlag then
		warn(
			"InlineLayout: trying to wrap text across multiple lines and iterations cap is reached. Layout may be imperfect",
			`Desired width: {x}, elements: {#elements}`,
			debug.traceback()
		)
	end

	if #v3 > 0 then
		table.insert(v2, v3)
	end

	return map(v2, function(p, layoutOrder)
		return React.createElement(
			View,
			{
				tag = "auto-xy row align-x-left",
				key = tostring(layoutOrder),
				LayoutOrder = layoutOrder
			},
			p
		)
	end)
end

local function InlineLayout(props)
	local ref = useRef(nil)
	local v = Foundation.Hooks.useTokens()
	local state, setState = useState({})

	local onAbsoluteSizeChanged = useCallback(function()
		if not (ref.current ~= nil and ref.current.AbsoluteSize.X ~= 0) then
			return
		end

		setState(layoutElements(props.Elements, ref.current.AbsoluteSize.X))
	end, { props.Elements })

	useEffect(onAbsoluteSizeChanged, { onAbsoluteSizeChanged })

	return React.createElement(HoverContext.Provider, nil, React.createElement(View, {
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		ref = ref,
		tag = "size-full-0 auto-y",
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = props.HorizontalAlignment or Enum.HorizontalAlignment.Left,
			Padding = props.VerticalPadding or UDim.new(0, v.Gap.Small)
		}
	}, state))
end

return InlineLayout
