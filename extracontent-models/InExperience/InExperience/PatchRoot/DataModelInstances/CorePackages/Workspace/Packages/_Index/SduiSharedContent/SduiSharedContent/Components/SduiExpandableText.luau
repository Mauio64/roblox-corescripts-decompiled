local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local AppBlox = require(Parent.AppBlox)
local Foundation = require(Parent.Foundation)
local reportUnifiedLoggingAction = require(Parent.SduiCoreSystem).reportUnifiedLoggingAction
local ExpandableText = AppBlox.ExpandableText
local View = Foundation.View
local FFlagSduiExperienceDetailsSupport = require(Parent.SharedFlags).FFlagSduiExperienceDetailsSupport

local function SduiExpandableText(p1) -- line: 26
	-- upvalues: React (copy), reportUnifiedLoggingAction (copy), FFlagSduiExperienceDetailsSupport (copy), View (copy), ExpandableText (copy)
	local layoutOrder = p1.layoutOrder
	local v12 = React.useCallback(function(b1: boolean) -- line: 29
		-- upvalues: p1 (copy), reportUnifiedLoggingAction (copy)
		if p1.onExpandChanged then
			p1.onExpandChanged(b1)
		end

		local t1 = {
			actionType = "ExpandableTextToggle",
			actionParams = {
				isExpanded = b1
			}
		}

		reportUnifiedLoggingAction(p1.sduiContext, t1, p1.analyticsContext)
	end, {
		p1.onExpandChanged,
		p1.analyticsContext,
		p1.sduiContext
	})
	local t2 = {
		text = p1.text,
		LayoutOrder = if not FFlagSduiExperienceDetailsSupport or (not p1.headerComponent or (not p1.text or p1.text == "")) then layoutOrder else 2,
		compactNumberOfLines = p1.compactNumberOfLines,
		fontStyle = p1.fontStyle,
		textStyle = p1.textStyle,
		pressedTextStyle = p1.pressedTextStyle,
		expandedInitially = p1.expandedInitially,
		avoidBlankLineClip = p1.avoidBlankLineClip,
		onExpandChanged = v12,
		selectable = if not FFlagSduiExperienceDetailsSupport then nil else p1.selectable
	}

	if FFlagSduiExperienceDetailsSupport and (p1.headerComponent and p1.text and p1.text ~= "") then
		return React.createElement(View, {
			tag = "size-full-0 auto-y col gap-large",
			LayoutOrder = layoutOrder
		}, {
			Header = React.cloneElement(p1.headerComponent, {
				layoutOrder = 1
			}),
			Content = React.createElement(ExpandableText, t2)
		})
	end

	return React.createElement(ExpandableText, t2)
end

return React.memo(SduiExpandableText)
