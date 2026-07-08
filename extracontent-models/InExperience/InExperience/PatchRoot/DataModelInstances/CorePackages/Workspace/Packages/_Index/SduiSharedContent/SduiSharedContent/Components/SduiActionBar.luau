local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local View = Foundation.View
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local FFlagSduiExperienceDetailsSupport = require(Parent.SharedFlags).FFlagSduiExperienceDetailsSupport

local function SduiActionBar(t1: {[any]: any}) -- line: 45
	-- upvalues: getSduiComponentWrapper (copy), React (copy), View (copy), FFlagSduiExperienceDetailsSupport (copy)
	if t1.items == nil or #t1.items == 0 then
		return nil
	end

	local t2 = {}

	for v11, v12 in t1.items do
		local v13 = getSduiComponentWrapper(v12)

		t2["item_" .. tostring(v11)] = React.createElement(v13, {
			componentConfig = v12,
			sduiContext = t1.sduiContext,
			extraLocalProps = {
				layoutOrder = v11
			}
		})
	end

	if t1.footer == nil then
		return React.createElement(View, {
			tag = t1.rowTag or "row size-full-0 auto-y gap-small",
			size = t1.size,
			anchorPoint = t1.anchorPoint,
			position = t1.position,
			LayoutOrder = t1.layoutOrder,
			testId = t1.testId
		}, t2)
	end

	local v14 = React.createElement(View, {
		layoutOrder = 1,
		tag = t1.rowTag or "row size-full-0 auto-y gap-small"
	}, t2)

	return React.createElement(View, {
		tag = t1.wrapperTag or "col size-full-0 auto-y gap-small",
		size = t1.size,
		anchorPoint = t1.anchorPoint,
		position = t1.position,
		LayoutOrder = t1.layoutOrder,
		testId = t1.testId
	}, {
		ItemsRow = v14,
		Footer = if not FFlagSduiExperienceDetailsSupport then React.createElement(View, {
			tag = "size-full-0 auto-y",
			layoutOrder = 2
		}, t1.footer) else t1.footer
	})
end

return React.memo(SduiActionBar)
