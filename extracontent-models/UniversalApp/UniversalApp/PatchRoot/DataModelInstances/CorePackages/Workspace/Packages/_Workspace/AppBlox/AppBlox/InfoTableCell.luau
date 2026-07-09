local Parent = script:FindFirstAncestor("AppBlox").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local Divider = Foundation.Divider
local Icon = Foundation.Icon
local Enums = Foundation.Enums
local FFlagSduiExperienceDetailsSupport = require(Parent.SharedFlags).FFlagSduiExperienceDetailsSupport

local function v9() -- line: 14
end

local t1 = {
	affordance = Enums.StateLayerAffordance.None
}

local function InfoTableCell(t2: {[any]: any}) -- line: 36
	-- upvalues: FFlagSduiExperienceDetailsSupport (copy), React (copy), View (copy), v9 (copy), t1 (copy), Divider (copy), Icon (copy), Enums (copy)
	local v13 = (t2.numColumns or 1) == 1
	local u14 = nil
	local v15 = nil

	if FFlagSduiExperienceDetailsSupport then
		u14 = t2.selectable ~= false
		v15 = React.useMemo(function() -- line: 44
			-- upvalues: u14 (ref), t2 (copy)
			if not u14 then
				return nil
			end

			return {
				Selectable = true,
				SelectionOrder = t2.selectionOrder
			}
		end, {
			u14,
			t2.selectionOrder
		})
	end

	return React.createElement(View, {
		tag = "col size-full-0 auto-y",
		onActivated = if not FFlagSduiExperienceDetailsSupport then t2.onActivated else t2.onActivated or if not u14 then nil else v9,
		selection = if not FFlagSduiExperienceDetailsSupport then nil else v15,
		stateLayer = if not FFlagSduiExperienceDetailsSupport or (not u14 or t2.onActivated) then nil else t1,
		testId = t2.testId
	}, {
		TopDivider = if v13 then nil else React.createElement(Divider, {
			LayoutOrder = 1
		}),
		LabelValueContainer = React.createElement(View, {
			LayoutOrder = 2,
			tag = {
				["row size-full-0 auto-y flex-x-between gap-medium padding-y-large"] = v13,
				["col size-full-0 auto-y padding-y-medium"] = not v13
			}
		}, {
			Label = t2.labelComponent,
			ValueContainer = React.createElement(View, {
				LayoutOrder = 2,
				tag = {
					["row size-0-full auto-xy fill align-x-right"] = v13,
					["row size-full-0 auto-y"] = not v13
				}
			}, {
				Value = t2.valueComponent,
				ChevronIcon = if not t2.onActivated then nil else React.createElement(Icon, {
					name = Enums.IconName.ChevronSmallRight
				})
			})
		}),
		BottomDivider = if t2.isLastInSingleColumn or not v13 then nil else React.createElement(Divider, {
			LayoutOrder = 3
		})
	})
end

return React.memo(InfoTableCell)
