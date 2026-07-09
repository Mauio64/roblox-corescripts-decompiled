local v1 = if not game:GetService("RunService"):IsStudio() then nil else game:GetService("Selection")
local Parent = script:FindFirstAncestor("AppDebug").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local DebugPanel = require(Parent.DebugPanel)
local ScrollView = Foundation.ScrollView
local SearchInput = Foundation.SearchInput
local SegmentedControl = Foundation.SegmentedControl
local FoundationText = Foundation.Text
local View = Foundation.View
local InputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens
local Parent2 = require(script.Parent)
local TagAnnotationPortal = require(script.Parent.TagAnnotationPortal)
local DebugPanelSection = require(Parent.DebugPanel).DebugPanelSection
local t1 = {
	{
		id = "hidden",
		text = "Hidden"
	},
	{
		id = "overlay",
		text = "Overlay"
	},
	{
		id = "list",
		text = "List"
	}
}

local function shortPath(s1: string, n1: number) -- line: 48
	local t2 = {}

	for match in string.gmatch(s1, "[^/]+") do
		table.insert(t2, match)
	end

	if n1 >= #t2 then
		return s1
	end

	local t3 = {}

	for i = #t2 - n1 + 1, #t2 do
		table.insert(t3, t2[i])
	end

	return "…/" .. table.concat(t3, "/")
end
local function groupAndFilter(t4: {[any]: any}, s2: string?) -- line: 65
	local v32 = if not s2 or s2 == "" then nil else string.lower(s2)
	local t5 = {}
	local t6 = {}

	for _, v36 in t4 do
		if string.sub(v36.testId, 1, 5) ~= "type=" and (not v32 or string.find(string.lower(v36.testId), v32, 1, true)) then
			if not t5[v36.testId] then
				t5[v36.testId] = {}
				table.insert(t6, v36.testId)
			end

			table.insert(t5[v36.testId], v36)
		end
	end

	table.sort(t6)

	return t5, t6
end
local function tagRowLabel(s3: string, s4: string, color3: Color3) -- line: 87
	return `{ s3 } <font color="#{ color3:ToHex() }">({ s4 })</font>`
end
local function TagRow(t7: {[any]: any}) -- line: 93
	-- upvalues: useTokens (copy), React (copy), v1 (copy), View (copy), FoundationText (copy)
	local v41 = useTokens()
	local tagInfo = t7.tagInfo
	local v43 = React.useCallback(function() -- line: 97
		-- upvalues: v1 (copy), tagInfo (copy)
		if v1 and tagInfo.instance then
			v1:Set({ tagInfo.instance })
		end

		print("[TagAnnotation] " .. tagInfo.testId)
		print("  Class: " .. tagInfo.className)
		print("  Path:  " .. tagInfo.path)
	end, { tagInfo })
	local createElement = React.createElement
	local v45 = View
	local t8 = {
		tag = "col size-full-0 auto-y padding-x-xsmall padding-y-xxsmall radius-small bg-surface-100",
		LayoutOrder = t7.layoutOrder,
		onActivated = v43,
		stateLayer = {}
	}
	local t9 = {}
	local createElement2 = React.createElement
	local v49 = FoundationText
	local t10 = {
		tag = "size-full-0 auto-y padding-xsmall text-label-small text-align-x-left content-emphasis",
		RichText = true
	}
	local label = t7.label
	local className = tagInfo.className

	t10.Text = `{ label } <font color="#{ v41.Color.Content.Muted.Color3:ToHex() }">({ className })</font>`
	t9.Label = createElement2(v49, t10)

	return createElement(v45, t8, t9)
end
local function TagAnnotationListPanel(t11: {[any]: any}) -- line: 121
	-- upvalues: useTokens (copy), Parent2 (copy), React (copy), groupAndFilter (copy), TagRow (copy), shortPath (copy), DebugPanelSection (copy), View (copy), SearchInput (copy), InputSize (copy), ScrollView (copy)
	local v54 = useTokens()
	local v55 = Parent2.useContext()
	local v56, v57 = React.useState(v55.config.filterPattern or "")
	local v58 = React.useCallback(function(s5: string) -- line: 126
		-- upvalues: v57 (copy), v55 (copy)
		v57(s5)
		v55.setFilterPattern(if s5 ~= "" then s5 else nil)
	end, { v55.setFilterPattern })
	local v59, v60 = groupAndFilter(t11.tags, v56)
	local t12 = {}

	for v62, v63 in v60 do
		local v64 = v59[v63]

		if #v64 == 1 then
			t12["s-" .. v63] = React.createElement(TagRow, {
				tagInfo = v64[1],
				label = v64[1].testId,
				layoutOrder = v62
			})
		else
			local t13 = {}

			for v66, v67 in v64 do
				t13["i-" .. v66] = React.createElement(TagRow, {
					tagInfo = v67,
					label = shortPath(v67.path, 3),
					layoutOrder = v66
				})
			end

			t12["g-" .. v63] = React.createElement(DebugPanelSection, {
				depth = 1,
				defaultCollapsed = true,
				title = v63 .. " (" .. #v64 .. ")",
				layoutOrder = v62
			}, t13)
		end
	end

	local v68 = #t11.tags
	local v69 = #v60

	return React.createElement(View, {
		tag = "col gap-small size-full-0 auto-y"
	}, {
		SearchBox = React.createElement(SearchInput, {
			LayoutOrder = 0,
			text = v56,
			placeholder = `filter… ({ v69 }/{ v68 })`,
			onChanged = v58,
			size = InputSize.Small,
			width = UDim.new(1, 0)
		}),
		Rows = React.createElement(ScrollView, {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 300),
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, v54.Gap.XXSmall)
			},
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromScale(0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y
			}
		}, t12)
	})
end
local function TagAnnotationContent() -- line: 191
	-- upvalues: Parent2 (copy), React (copy), View (copy), SegmentedControl (copy), t1 (copy), InputSize (copy), TagAnnotationListPanel (copy)
	local v70 = Parent2.useContext()
	local displayMode = v70.config.displayMode
	local v72 = Parent2.useTagScanner()
	local v73 = React.useCallback(function(p1) -- line: 196
		-- upvalues: v70 (copy)
		v70.setDisplayMode(p1)
	end, { v70.setDisplayMode })

	return React.createElement(View, {
		tag = "col gap-small size-full-0 auto-y"
	}, {
		Controls = React.createElement(SegmentedControl, {
			LayoutOrder = 0,
			segments = t1,
			value = displayMode,
			onActivated = v73,
			size = InputSize.XSmall
		}),
		List = if displayMode ~= "list" then nil else React.createElement(TagAnnotationListPanel, {
			LayoutOrder = 1,
			tags = v72.tags
		})
	})
end
local function TagAnnotationSectionRoot() -- line: 219
	-- upvalues: React (copy), Parent2 (copy), TagAnnotationPortal (copy), TagAnnotationContent (copy)
	return React.createElement(Parent2.Provider, nil, {
		Portal = React.createElement(TagAnnotationPortal),
		Inner = React.createElement(TagAnnotationContent)
	})
end

return DebugPanel.registerSection({
	id = "app-debug.tagAnnotation",
	order = 0,
	path = { "Tag Annotations" },
	component = TagAnnotationSectionRoot
})
