local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local HttpService = game:GetService("HttpService")
local EvidenceField = require(NotApprovedPage.Components.EvidenceField)
local platformEvidence = require(NotApprovedPage.Utils.platformEvidence)
local parseDateFromString = require(NotApprovedPage.Utils.parseDateFromString)
local sendNotApprovedPageEvent = require(NotApprovedPage.Utils.sendNotApprovedPageEvent)
local useNotApprovedPageContext = require(NotApprovedPage.Contexts.NotApprovedPageContext).useNotApprovedPageContext

require(NotApprovedPage.Common.Types)

local NotApprovedPageParent = NotApprovedPage.Parent
local React = require(NotApprovedPageParent.React)
local useMemo = React.useMemo
local View = require(NotApprovedPageParent.Foundation).View

require(NotApprovedPage.Components.pageItemConfigs.PageItemConfigUtils)

local Constants = require(NotApprovedPageParent.NotApprovedPageShared).Constants
local FFlagNapPublicEvidenceTranslationKeys = require(NotApprovedPage.Flags.FFlagNapPublicEvidenceTranslationKeys)
local _ = {
	TEXT = "text",
	IMAGE = "image"
}

local function ViolationEvidence(p1) -- line: 39
	-- upvalues: useNotApprovedPageContext (copy), useMemo (copy), platformEvidence (copy), FFlagNapPublicEvidenceTranslationKeys (copy), sendNotApprovedPageEvent (copy), Constants (copy), HttpService (copy), React (copy), EvidenceField (copy), View (copy), parseDateFromString (copy)
	local translations = useNotApprovedPageContext().translations
	local violation = p1.moderationDetail.violation
	local beginDate = p1.moderationDetail.beginDate

	if not violation then
		return nil
	end

	local v20 = useMemo(function() -- line: 53
		-- upvalues: platformEvidence (copy), violation (copy)
		return platformEvidence.filterForVisibleElements(violation.evidence.elements)
	end, { violation.evidence.elements })
	local v21 = useMemo(function() -- line: 57
		-- upvalues: v20 (copy), FFlagNapPublicEvidenceTranslationKeys (copy), translations (copy), sendNotApprovedPageEvent (copy), Constants (copy), HttpService (copy), React (copy), EvidenceField (copy)
		local t1 = {}

		for v24, v25 in v20 do
			if v25.type == "text" then
				local text = v25.text

				if FFlagNapPublicEvidenceTranslationKeys and v25.textKey then
					text = translations[v25.textKey .. "_" .. v25.labelKey]

					if text and text ~= "" then
					else
						sendNotApprovedPageEvent({
							eventType = Constants.EVENT_TYPES.MissingTranslation,
							additionalInfo = HttpService:JSONEncode({
								key = v25.textKey,
								params = v25.textKeyParameters
							})
						})
						text = v25.textKey
					end
				end

				table.insert(t1, React.createElement(EvidenceField, {
					fieldLabel = translations[v25.labelKey],
					fieldValue = if not FFlagNapPublicEvidenceTranslationKeys then v25.text else text,
					layoutOrder = v24
				}))
			end
		end

		return t1
	end, { v20 })

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-small",
		LayoutOrder = 1
	}, {
		Elements = React.createElement(View, {
			tag = "size-full-0 auto-y col gap-small",
			LayoutOrder = 2
		}, unpack(v21)),
		ReviewDate = React.createElement(EvidenceField, {
			layoutOrder = 3,
			fieldLabel = translations.dateReviewedLabel,
			fieldValue = parseDateFromString(beginDate, translations)
		})
	})
end

return {
	getIsVisible = function(p2) -- line: 119
		-- upvalues: platformEvidence (copy)
		return platformEvidence.isVisibleInView(p2.violation)
	end,
	renderComponent = React.memo(ViolationEvidence)
}
