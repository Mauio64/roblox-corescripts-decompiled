local Parent = script:FindFirstAncestor("AppDebug").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

require(script.Parent.useTagScanner)

local useInstanceTracking = require(script.Parent.useInstanceTracking)
local useTagColor = require(script.Parent.useTagColor)
local TagAnnotationTooltip = require(script.Parent.TagAnnotationTooltip)

local function matchesFilter(s1: string, s2: string?) -- line: 36
	if not s2 or s2 == "" then
		return true
	end

	return string.find(string.lower(s1), string.lower(s2), 1, true) ~= nil
end
local function TagHighlight(t1: {[any]: any}) -- line: 47
	-- upvalues: useTokens (copy), useInstanceTracking (copy), useTagColor (copy), React (copy), View (copy)
	local v15 = useTokens()
	local v16 = useInstanceTracking(t1.tagInfo.instance)
	local v17 = useTagColor(t1.tagInfo.testId)

	return React.createElement(View, {
		Position = UDim2.fromOffset(v16.position.X, v16.position.Y),
		Size = UDim2.fromOffset(v16.size.X, v16.size.Y),
		Visible = v16.isVisible,
		cornerRadius = UDim.new(0, v15.Radius.Small),
		stroke = {
			Color = v17.Color3,
			Thickness = v15.Stroke.Standard,
			Transparency = v17.Transparency
		}
	})
end
local function TagAnnotationOverlay(t2: {[any]: any}) -- line: 65
	-- upvalues: React (copy), TagHighlight (copy), TagAnnotationTooltip (copy), View (copy)
	local t3 = {}

	for v20, v21 in (React.useMemo(function() -- line: 66
		-- upvalues: t2 (copy)
		local t4 = {}

		for _, v24 in t2.tags do
			if v24.instance and v24.instance.Parent ~= nil then
				local testId = v24.testId
				local filterPattern = t2.filterPattern

				if not filterPattern or (filterPattern == "" or string.find(string.lower(testId), string.lower(filterPattern), 1, true) ~= nil) then
					table.insert(t4, v24)
				end
			end
		end

		return t4
	end, {
		t2.tags,
		t2.filterPattern
	})) do
		t3[`highlight-{ v20 }-{ v21.testId }`] = React.createElement(TagHighlight, {
			tagInfo = v21
		})
		t3[`tooltip-{ v20 }-{ v21.testId }`] = React.createElement(TagAnnotationTooltip, {
			tagInfo = v21,
			showClassName = t2.showClassName,
			showPosition = t2.showPosition,
			opacity = t2.tooltipOpacity,
			highlightOnHover = t2.highlightOnHover
		})
	end

	return React.createElement(View, {
		tag = "size-full"
	}, t3)
end

return TagAnnotationOverlay
