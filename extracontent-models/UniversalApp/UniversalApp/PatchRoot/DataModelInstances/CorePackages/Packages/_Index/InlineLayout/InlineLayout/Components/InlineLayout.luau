local Parent = script:FindFirstAncestor("Components").Parent
local ParentParent = Parent.Parent
local Foundation = require(ParentParent.Foundation)
local React = require(ParentParent.React)
local useCallback = React.useCallback
local useRef = React.useRef
local useState = React.useState
local useEffect = React.useEffect
local map = require(ParentParent.Dash).map

require(Parent.Components.InlineLayout.InlineLayoutElements.RenderableInlineElement)

local HardBreakElement = require(Parent.Components.InlineLayout.InlineLayoutElements.HardBreakElement)
local HoverContext = require(Parent.Components.InlineLayout.InlineLayoutElements.HoverContext)
local View = Foundation.View
local v13 = game:DefineFastFlag("FFlagDebugInlineLayout", false)

local function layoutElements(t1: {[any]: any}, n1: number) -- line: 34
	-- upvalues: HardBreakElement (copy), v13 (copy), map (copy), React (copy), View (copy)
	if #t1 == 0 then
		return {}
	end

	local t2 = {}
	local t3 = {}
	local u20 = n1
	local v21 = nil
	local n2 = 1
	local n3 = 0

	local function flushRow() -- line: 47
		-- upvalues: t2 (copy), t3 (ref), u20 (ref), n1 (copy)
		table.insert(t2, t3)
		t3 = {}
		u20 = n1
	end

	while (n2 <= #t1 or v21) and n3 < 100 do
		local v25 = v21 or t1[n2]

		if v25 == HardBreakElement then
			n2 += 1
			table.insert(t2, t3)
			t3 = {}
			u20 = n1
		else
			local v26 = v25:getWidth()
			local v27 = #t3

			if v26 <= u20 then
				table.insert(t3, v25:render(n2, v27))
				u20 -= v26
				v21 = nil
				n2 += 1
			else
				local parts

				parts, v21 = v25:split(u20)

				if parts:getWidth() <= u20 then
					table.insert(t3, parts:render(n2, v27))
				elseif #t3 == 0 then
					if v25.canForceSplit then
						parts, v21 = v25:split(u20, true)
					end

					table.insert(t3, parts:render(n2, v27))
				else
					v21 = v25
				end

				table.insert(t2, t3)
				t3 = {}
				u20 = n1
			end

			n3 += 1
		end
	end

	if n3 == 100 and v13 then
		warn("InlineLayout: trying to wrap text across multiple lines and iterations cap is reached. Layout may be imperfect", `Desired width: { n1 }`, debug.traceback())
	end

	if #t3 > 0 then
		table.insert(t2, t3)
	end

	return map(t2, function(p1, p2) -- line: 112
		-- upvalues: React (copy), View (copy)
		return React.createElement(View, {
			tag = "auto-xy row align-x-left",
			key = tostring(p2),
			LayoutOrder = p2
		}, p1)
	end)
end
local function InlineLayout(t4: {[any]: any}) -- line: 121
	-- upvalues: useRef (copy), Foundation (copy), useState (copy), useCallback (copy), layoutElements (copy), useEffect (copy), React (copy), HoverContext (copy), View (copy)
	local v30 = useRef(nil)
	local v31 = Foundation.Hooks.useTokens()
	local v32, v33 = useState({})
	local v34 = useCallback(function() -- line: 126
		-- upvalues: v30 (copy), v33 (copy), layoutElements (copy), t4 (copy)
		if v30.current == nil then
			return
		end

		if v30.current.AbsoluteSize.X == 0 then
			return
		end

		v33(layoutElements(t4.Elements, v30.current.AbsoluteSize.X))
	end, { t4.Elements })

	useEffect(v34, { v34 })

	return React.createElement(HoverContext.Provider, nil, React.createElement(View, {
		tag = "size-full-0 auto-y",
		onAbsoluteSizeChanged = v34,
		ref = v30,
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = t4.HorizontalAlignment or Enum.HorizontalAlignment.Left,
			Padding = t4.VerticalPadding or UDim.new(0, v31.Gap.Small)
		}
	}, v32))
end

return InlineLayout
