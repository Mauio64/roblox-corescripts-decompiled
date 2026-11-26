require("@luauforge/deferred/gzP")

require("@luauforge/deferred/gzW")

local module = require("@luauforge/deferred/gzS")
local module2 = require("@luauforge/deferred/gzT")
local text = module2.Text
local view = module2.View
local useMemo = module.useMemo

local module3 = require("@luauforge/deferred/gAi")
local useNotApprovedPageContext = require("@luauforge/deferred/gAo").useNotApprovedPageContext

local function WhatHappened(p2)
	local v5 = useNotApprovedPageContext()
	local translations = v5.translations
	local violationReasons = v5.violationReasons
	local isKidsTreatment = v5.isKidsTreatment
	local moderatorNote = v5.moderatorNote

	local v6 = useMemo(function()
		local joined = table.concat(violationReasons.translatedReasons, ", ")

		if joined == "" then
			return translations.otherAbuseType
		end

		return joined
	end, { violationReasons.translatedReasons, translations.otherAbuseType })

	local createElement = module.createElement
	local v8 = {
		tag = "col gap-medium size-full-0 auto-y",
		LayoutOrder = p2.layoutOrder
	}

	local createElement2 = module.createElement

	local v11 = if isKidsTreatment then translations.whatHappenedLabelKids else translations.whatHappenedLabel
	local children = {
		Heading = createElement2(text, {
			tag = "auto-xy text-title-large text-wrap text-align-x-left content-emphasis",
			Text = v11,
			LayoutOrder = 1
		}),
		Content = 0
	}

	local createElement3 = module.createElement

	local v15 = if isKidsTreatment then module.createElement(module3, {
		fieldLabel = v6,
		fieldValue = moderatorNote,
		layoutOrder = 1,
		showColon = false
	}) else module.createElement(module3, {
		fieldLabel = translations.reasonLabel,
		fieldValue = v6,
		layoutOrder = 1
	})
	children.Content = createElement3(
		view,
		{
			tag = "col gap-small size-full-0 auto-y padding-large radius-medium bg-shift-100",
			LayoutOrder = 2
		},
		{
			Reason = v15,
			ModeratorNote = not isKidsTreatment and module.createElement(module3, {
				fieldLabel = translations.moderatorNoteLabel,
				fieldValue = moderatorNote,
				layoutOrder = 2
			})
		}
	)
	return createElement(view, v8, children)
end

return {
	getIsVisible = function(): boolean
		return true
	end,
	renderComponent = module.memo(WhatHappened)
}
