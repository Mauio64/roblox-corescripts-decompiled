local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")

require(NotApprovedPage.Common.Types)
require(NotApprovedPage.Components.pageItemConfigs.PageItemConfigUtils)

local NotApprovedPageParent = NotApprovedPage.Parent
local React = require(NotApprovedPageParent.React)
local Foundation = require(NotApprovedPageParent.Foundation)
local FoundationText = Foundation.Text
local View = Foundation.View
local useMemo = React.useMemo
local EvidenceField = require(NotApprovedPage.Components.EvidenceField)
local useNotApprovedPageContext = require(NotApprovedPage.Contexts.NotApprovedPageContext).useNotApprovedPageContext

local function WhatHappened(p1) -- line: 26
	-- upvalues: useNotApprovedPageContext (copy), useMemo (copy), React (copy), View (copy), FoundationText (copy), EvidenceField (copy)
	local v12 = useNotApprovedPageContext()
	local translations = v12.translations
	local violationReasons = v12.violationReasons
	local messageToUser = p1.moderationDetail.messageToUser
	local fallbackModeratorNote = translations.fallbackModeratorNote
	local v17 = useMemo(function() -- line: 34
		-- upvalues: violationReasons (copy), translations (copy)
		local v18 = table.concat(violationReasons.translatedReasons, ", ")

		if v18 ~= "" then
			return v18
		end

		return translations.otherAbuseType
	end, { violationReasons.translatedReasons })

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-medium",
		LayoutOrder = p1.layoutOrder
	}, {
		Heading = React.createElement(FoundationText, {
			tag = "auto-xy text-title-large text-align-x-left content-emphasis text-wrap",
			LayoutOrder = 1,
			Text = translations.whatHappenedLabel
		}),
		Content = React.createElement(View, {
			tag = "size-full-0 auto-y col gap-small bg-shift-100 radius-medium padding-large",
			LayoutOrder = 2
		}, {
			Reason = React.createElement(EvidenceField, {
				layoutOrder = 1,
				fieldLabel = translations.reasonLabel,
				fieldValue = v17
			}),
			ModeratorNote = React.createElement(EvidenceField, {
				layoutOrder = 2,
				fieldLabel = translations.moderatorNoteLabel,
				fieldValue = if not messageToUser or messageToUser == "" then fallbackModeratorNote else messageToUser
			})
		})
	})
end

return {
	getIsVisible = function() -- line: 69
		return true
	end,
	renderComponent = React.memo(WhatHappened)
}
