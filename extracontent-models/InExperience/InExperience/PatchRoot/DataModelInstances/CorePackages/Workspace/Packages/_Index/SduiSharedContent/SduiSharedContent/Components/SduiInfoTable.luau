local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local AppBlox = require(Parent.AppBlox)
local Foundation = require(Parent.Foundation)
local InfoTable = AppBlox.InfoTable
local View = Foundation.View
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local FFlagSduiExperienceDetailsSupport = require(Parent.SharedFlags).FFlagSduiExperienceDetailsSupport

local function SduiInfoTable(t1: {[any]: any}) -- line: 33
	-- upvalues: FFlagSduiExperienceDetailsSupport (copy), getSduiComponentWrapper (copy), React (copy), View (copy), InfoTable (copy)
	local layoutOrder = t1.layoutOrder
	local t2 = {}
	local v14 = (not t1.numColumns or not (t1.numColumns > 0)) and 1 or t1.numColumns
	local v15 = #t1.items
	local v16 = if not FFlagSduiExperienceDetailsSupport then nil else math.ceil(v15 / v14)

	for v17, v18 in t1.items do
		local v19 = getSduiComponentWrapper(v18)
		local v20 = nil

		if FFlagSduiExperienceDetailsSupport then
			local v21 = math.floor((v17 - 1) / v16) + 1

			v20 = ((v17 - 1) % v16 + 1 - 1) * v14 + v21
		end

		t2[v17] = React.createElement(v19, {
			componentConfig = v18,
			sduiContext = t1.sduiContext,
			parentAnalyticsContext = t1.analyticsContext,
			extraLocalProps = {
				numColumns = t1.numColumns,
				isLastInSingleColumn = if v14 ~= 1 then nil else v17 == v15,
				selectionOrder = v20
			}
		})
	end

	if FFlagSduiExperienceDetailsSupport then
		return React.createElement(View, {
			tag = if not t1.tag then {
				["col size-full-0 auto-y"] = true
			} else {
				[t1.tag] = true,
				["col size-full-0 auto-y"] = true
			},
			LayoutOrder = layoutOrder
		}, {
			Header = if not t1.headerComponent then nil else React.cloneElement(t1.headerComponent, {
				layoutOrder = 1
			}),
			Content = React.createElement(InfoTable, {
				LayoutOrder = 2,
				numColumns = t1.numColumns,
				gridTag = t1.gridTag,
				items = t2
			})
		})
	end

	return React.createElement(InfoTable, {
		LayoutOrder = layoutOrder,
		numColumns = t1.numColumns,
		gridTag = t1.gridTag,
		items = t2
	})
end

return React.memo(SduiInfoTable)
