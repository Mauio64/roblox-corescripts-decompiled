local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local EvidenceField = require(NotApprovedPage.Components.EvidenceField)
local platformEvidence = require(NotApprovedPage.Utils.platformEvidence)
local parseDateFromString = require(NotApprovedPage.Utils.parseDateFromString)

require(NotApprovedPage.Common.Types)

local useNotApprovedPageContext = require(NotApprovedPage.Contexts.NotApprovedPageContext).useNotApprovedPageContext

require(NotApprovedPage.Components.pageItemConfigs.PageItemConfigUtils)

local NotApprovedPageParent = NotApprovedPage.Parent
local React = require(NotApprovedPageParent.React)
local useState = React.useState
local useCallback = React.useCallback
local useMemo = React.useMemo
local Foundation = require(NotApprovedPageParent.Foundation)
local FoundationText = Foundation.Text
local View = Foundation.View
local Divider = Foundation.Divider
local LinkButton = require(NotApprovedPageParent.UIBlox).App.Button.LinkButton

local function BadUtterancesContent(t1: {[any]: any}) -- line: 44
	-- upvalues: useNotApprovedPageContext (copy), useState (copy), useCallback (copy), useMemo (copy), React (copy), FoundationText (copy), View (copy), LinkButton (copy)
	local translations = useNotApprovedPageContext().translations
	local v20, v21 = useState(false)
	local badUtterances = t1.badUtterances
	local v23 = useCallback(function() -- line: 50
		-- upvalues: v21 (copy)
		v21(function(p1) -- line: 51
			return not p1
		end)
	end, { v20 })
	local v24 = useMemo(function() -- line: 56
		-- upvalues: v20 (copy), badUtterances (copy)
		if v20 or #badUtterances <= 4 then
			return badUtterances
		end

		return { unpack(badUtterances, 1, 4) }
	end, {
		badUtterances,
		v20
	})
	local v25 = useMemo(function() -- line: 62
		-- upvalues: v24 (copy), React (copy), FoundationText (copy)
		local t2 = {}

		for v34, v35 in v24 do
			table.insert(t2, React.createElement(FoundationText, {
				tag = "auto-xy text-body-medium text-align-x-left text-wrap",
				RichText = true,
				Text = v35.utteranceText,
				LayoutOrder = v34
			}))
		end

		return t2
	end, { v24 })

	return React.createElement(View, {
		tag = "auto-xy col gap-small",
		LayoutOrder = t1.LayoutOrder
	}, {
		BadUtteranceItems = React.createElement(View, {
			tag = "auto-xy col gap-xxsmall",
			LayoutOrder = 1
		}, {
			OffensiveItemLabel = React.createElement(FoundationText, {
				tag = "auto-xy text-body-medium text-align-x-left text-wrap content-emphasis",
				RichText = true,
				LayoutOrder = 1,
				Text = `<b>{ translations.offensiveItemLabel }:</b>`
			}),
			ListOfItems = React.createElement(View, {
				tag = "auto-xy col",
				LayoutOrder = 2
			}, unpack(v25))
		}),
		ToggleButton = #badUtterances > 4 and React.createElement(LinkButton, {
			fontStyle = "CaptionHeader",
			minPaddingX = 0,
			minPaddingY = 0,
			layoutOrder = 2,
			text = if not v20 then translations.viewMoreButton else translations.viewLessButton,
			onActivated = v23
		}) or nil
	})
end
local function BadUtterances(p2) -- line: 117
	-- upvalues: useNotApprovedPageContext (copy), React (copy), View (copy), BadUtterancesContent (copy), Divider (copy), EvidenceField (copy), parseDateFromString (copy)
	local translations = useNotApprovedPageContext().translations
	local badUtterances = p2.moderationDetail.badUtterances
	local beginDate = p2.moderationDetail.beginDate

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-small",
		LayoutOrder = 1
	}, {
		BadUtterancesContent = React.createElement(BadUtterancesContent, {
			LayoutOrder = 1,
			badUtterances = badUtterances
		}),
		Divider = React.createElement(View, {
			tag = "auto-xy padding-y-small",
			LayoutOrder = 2
		}, {
			Divider = React.createElement(Divider, nil)
		}),
		ReviewDate = React.createElement(EvidenceField, {
			layoutOrder = 4,
			fieldLabel = translations.dateReviewedLabel,
			fieldValue = parseDateFromString(beginDate, translations)
		})
	})
end

return {
	getIsVisible = function(p3) -- line: 148
		-- upvalues: platformEvidence (copy)
		local violation = p3.violation
		local badUtterances = p3.badUtterances

		return not platformEvidence.isVisibleInView(violation) and (badUtterances and #badUtterances ~= 0)
	end,
	renderComponent = React.memo(BadUtterances)
}
