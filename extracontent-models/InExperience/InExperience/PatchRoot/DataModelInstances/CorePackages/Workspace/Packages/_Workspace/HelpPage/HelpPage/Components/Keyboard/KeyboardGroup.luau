local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)

require(ParentParent.Configs.ConfigTypes)

local Localization = require(ParentParentParent.Localization)
local KeyboardAction = require(script.Parent.KeyboardAction)
local View = Foundation.View
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local useLocalization = Localization.Hooks.useLocalization
local v11 = React.memo(function(t1: {[any]: any}) -- line: 24
	-- upvalues: useTokens (copy), useLocalization (copy), React (copy), View (copy), FoundationText (copy)
	local v13 = useTokens()
	local v14 = useLocalization({
		title = t1.title
	})

	return React.createElement(View, {
		tag = "col align-y-center align-x-left size-full-0 auto-y padding-x-small padding-y-small",
		LayoutOrder = t1.LayoutOrder
	}, { React.createElement(FoundationText, {
		tag = "text-title-medium text-align-x-left auto-xy text-wrap",
		key = "title-text",
		textStyle = v13.Color.Extended.White.White_100,
		Text = v14.title
	}) })
end)

return React.memo(function(t2: {[any]: any}) -- line: 48
	-- upvalues: React (copy), v11 (copy), KeyboardAction (copy), View (copy)
	local v16 = React.useMemo(function() -- line: 49
		-- upvalues: React (copy), v11 (copy), t2 (copy), KeyboardAction (copy)
		local t3 = {}

		table.insert(t3, React.createElement(v11, {
			LayoutOrder = 0,
			title = t2.group.label,
			key = "groupTitle-" .. t2.group.id
		}))

		for _, v19 in t2.controls do
			if v19.keyboardInput ~= nil then
				table.insert(t3, (React.createElement(KeyboardAction, {
					control = v19,
					LayoutOrder = v19.keyboardInput.layoutOrder,
					key = v19.label .. v19.keyboardInput.layoutOrder
				})))
			end
		end

		return t3
	end, {
		t2.controls,
		t2.group
	})

	return React.createElement(View, {
		tag = "col align-y-top align-x-center size-full gap-xxsmall",
		testId = "KeyboardGroup",
		LayoutOrder = t2.group.layoutOrder
	}, v16)
end)
