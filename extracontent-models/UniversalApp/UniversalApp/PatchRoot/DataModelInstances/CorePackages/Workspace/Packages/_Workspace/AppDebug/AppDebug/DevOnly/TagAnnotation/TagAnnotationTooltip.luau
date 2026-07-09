local Parent = script:FindFirstAncestor("AppDebug").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local v7 = if not game:GetService("RunService"):IsStudio() then nil else game:GetService("Selection")

require(script.Parent.useTagScanner)

local useInstanceTracking = require(script.Parent.useInstanceTracking)
local useTagColor = require(script.Parent.useTagColor)

local function TagAnnotationTooltip(t1: {[any]: any}) -- line: 41
	-- upvalues: useTokens (copy), useInstanceTracking (copy), React (copy), v7 (copy), useTagColor (copy), View (copy), FoundationText (copy)
	local v12 = useTokens()
	local tagInfo = t1.tagInfo
	local v14 = useInstanceTracking(tagInfo.instance)
	local v15 = React.useCallback(function() -- line: 47
		-- upvalues: v7 (copy), tagInfo (copy)
		if v7 and tagInfo.instance then
			v7:Set({ tagInfo.instance })
		end

		print(`[TagAnnotation] Selected: { tagInfo.testId }`)
		print(`  Class: { tagInfo.className }`)
		print(`  Path: { tagInfo.path }`)

		if tagInfo.instance then
			print(`  Instance: { tagInfo.instance:GetFullName() }`)
		end
	end, { tagInfo })
	local v16 = useTagColor(tagInfo.testId)
	local Emphasis = v12.LightMode.Content.Emphasis
	local t2 = { tagInfo.testId }

	if t1.showClassName then
		table.insert(t2, `[{ tagInfo.className }]`)
	end

	if t1.showPosition then
		table.insert(t2, `({ math.floor(v14.position.X) },{ math.floor(v14.position.Y) })`)
	end

	return React.createElement(View, {
		tag = "size-0-0 auto-xy padding-x-xsmall padding-y-xxsmall radius-small",
		ZIndex = 9999,
		Position = UDim2.fromOffset(v14.position.X, v14.position.Y - 20),
		Visible = v14.isVisible,
		backgroundStyle = {
			Color3 = v16.Color3,
			Transparency = 1 - t1.opacity
		},
		onActivated = v15,
		stateLayer = {}
	}, {
		Label = React.createElement(FoundationText, {
			tag = "size-0-0 auto-xy",
			Text = table.concat(t2, " "),
			textStyle = Emphasis,
			fontStyle = {
				FontSize = 11,
				Font = Enum.Font.RobotoMono
			}
		})
	})
end

return TagAnnotationTooltip
