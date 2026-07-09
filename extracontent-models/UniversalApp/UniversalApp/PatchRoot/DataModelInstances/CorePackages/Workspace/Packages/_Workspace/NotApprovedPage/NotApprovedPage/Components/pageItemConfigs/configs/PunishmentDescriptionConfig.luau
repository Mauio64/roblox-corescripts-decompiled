local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local PUNISHMENT_TYPE_TO_INTERVENTION_MAP = require(NotApprovedPageParent.NotApprovedPageShared).Constants.PUNISHMENT_TYPE_TO_INTERVENTION_MAP

require(NotApprovedPage.Common.Types)

local React = require(NotApprovedPageParent.React)
local Foundation = require(NotApprovedPageParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local useMemo = React.useMemo
local useNotApprovedPageContext = require(NotApprovedPage.Contexts.NotApprovedPageContext).useNotApprovedPageContext

require(NotApprovedPage.Components.pageItemConfigs.PageItemConfigUtils)

local determinePunishmentDescription = require(NotApprovedPage.Utils.determinePunishmentDescription)

local function PunishmentDescription(p1) -- line: 28
	-- upvalues: useNotApprovedPageContext (copy), PUNISHMENT_TYPE_TO_INTERVENTION_MAP (copy), useMemo (copy), determinePunishmentDescription (copy), React (copy), View (copy), FoundationText (copy)
	local translations = useNotApprovedPageContext().translations
	local translatedReasons = useNotApprovedPageContext().violationReasons.translatedReasons
	local v15 = PUNISHMENT_TYPE_TO_INTERVENTION_MAP[p1.moderationDetail.punishmentTypeDescription]
	local v16 = useMemo(function() -- line: 36
		-- upvalues: determinePunishmentDescription (copy), translations (copy), v15 (copy), translatedReasons (copy)
		return determinePunishmentDescription(translations.violationType, v15, translatedReasons or {})
	end, {
		translations.violationType,
		v15,
		translatedReasons
	})

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-small",
		testId = "punishment-description",
		LayoutOrder = p1.layoutOrder
	}, {
		Description = React.createElement(FoundationText, {
			tag = "auto-xy text-body-medium text-wrap text-align-x-left content-emphasis",
			LayoutOrder = 1,
			Text = v16
		})
	})
end

return {
	getIsVisible = function() -- line: 54
		return true
	end,
	renderComponent = React.memo(PunishmentDescription)
}
