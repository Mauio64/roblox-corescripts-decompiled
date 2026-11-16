local HttpService = game:GetService("HttpService")

local module = require("@luauforge/deferred/fVk")
local module2 = require("@luauforge/deferred/fVl")
local module3 = require("@luauforge/deferred/fVo")
local module4 = require("@luauforge/deferred/fUZ")
local useNotApprovedPageContext = require("@luauforge/deferred/fVq").useNotApprovedPageContext

require("@luauforge/deferred/fUR")

local module5 = require("@luauforge/deferred/fUU")
local useMemo = module5.useMemo

local view = require("@luauforge/deferred/fUV").View

require("@luauforge/deferred/fUY")

local constants = require("@luauforge/deferred/fUP").Constants

local module6 = require("@luauforge/deferred/fVn")

local v5 = { TEXT = "text", IMAGE = "image" }

local function ViolationEvidence(p2)
	local translations = useNotApprovedPageContext().translations

	local violation = p2.moderationDetail.violation
	local beginDate = p2.moderationDetail.beginDate

	if not violation then
		return nil
	end

	local v6 = useMemo(function()
		return module2.filterForVisibleElements(violation.evidence.elements)
	end, { violation.evidence.elements })

	local v7 = useMemo(function()
		local children = {}

		for k, v8 in v6 do
			if v8.type ~= "text" then
				continue
			end

			local v9 = v8.text

			if module6 and v8.textKey then
				v9 = translations[v8.textKey .. "_" .. v8.labelKey]

				if not v9 or v9 == "" then
					module4({
						eventType = constants.EVENT_TYPES.MissingTranslation,
						additionalInfo = HttpService:JSONEncode({
							key = v8.textKey,
							params = v8.textKeyParameters
						})
					})

					v9 = v8.textKey
				end
			end

			local createElement = module5.createElement
			local v11 = {
				fieldLabel = translations[v8.labelKey],
				fieldValue = 0,
				layoutOrder = 0
			}

			if not module6 then
				v9 = v8.text
			end

			v11.fieldValue = v9
			v11.layoutOrder = k
			table.insert(children, createElement(module, v11))
		end

		return children
	end, { v6 })

	return module5.createElement(view, {
		tag = "size-full-0 auto-y col gap-small",
		LayoutOrder = 1
	}, {
		Elements = module5.createElement(
			view,
			{ tag = "size-full-0 auto-y col gap-small", LayoutOrder = 2 },
			unpack(v7)
		),
		ReviewDate = module5.createElement(module, {
			fieldLabel = translations.dateReviewedLabel,
			fieldValue = module3(beginDate, translations),
			layoutOrder = 3
		})
	})
end

return {
	getIsVisible = function(p2)
		return module2.isVisibleInView(p2.violation)
	end,
	renderComponent = module5.memo(ViolationEvidence)
}
