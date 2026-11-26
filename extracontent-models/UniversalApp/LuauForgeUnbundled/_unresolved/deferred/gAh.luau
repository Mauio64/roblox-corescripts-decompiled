local module = require("@luauforge/deferred/gAi")
local module2 = require("@luauforge/deferred/gAj")
local module3 = require("@luauforge/deferred/gAm")

require("@luauforge/deferred/gzP")

local useNotApprovedPageContext = require("@luauforge/deferred/gAo").useNotApprovedPageContext

require("@luauforge/deferred/gzW")

local module4 = require("@luauforge/deferred/gzS")
local useState = module4.useState
local useCallback = module4.useCallback
local useMemo = module4.useMemo

local module5 = require("@luauforge/deferred/gzT")
local text = module5.Text
local view = module5.View
local divider = module5.Divider

local linkButton = require("@luauforge/deferred/gAr").App.Button.LinkButton

local function BadUtterancesContent(p2)
	local translations = useNotApprovedPageContext().translations

	local state, setState = useState(false)
	local badUtterances = p2.badUtterances

	local v5 = useCallback(function()
		setState(function(p3): boolean
			return not p3
		end)
	end, { state })

	local v6 = useMemo(function()
		if state or #badUtterances <= 4 then
			return badUtterances
		end

		return { unpack(badUtterances, 1, 4) }
	end, { badUtterances, state })

	local v7 = useMemo(function()
		local children = {}

		for k, v8 in v6 do
			table.insert(
				children,
				module4.createElement(text, {
					tag = "auto-xy text-body-medium text-align-x-left text-wrap",
					Text = v8.utteranceText,
					RichText = true,
					LayoutOrder = k
				})
			)
		end

		return children
	end, { v6 })

	local createElement = module4.createElement
	local v9 = { tag = "auto-xy col gap-small", LayoutOrder = p2.LayoutOrder }
	local v10 = {
		BadUtteranceItems = module4.createElement(
			view,
			{ tag = "auto-xy col gap-xxsmall", LayoutOrder = 1 },
			{
				OffensiveItemLabel = module4.createElement(text, {
					tag = "auto-xy text-title-medium text-align-x-left text-wrap content-default",
					Text = `{translations.offensiveItemLabel}:`,
					RichText = true,
					LayoutOrder = 1
				}),
				ListOfItems = module4.createElement(
					view,
					{ tag = "auto-xy col", LayoutOrder = 2 },
					unpack(v7)
				)
			}
		),
		ToggleButton = 0
	}
	local v11

	if #badUtterances > 4 then
		local createElement2 = module4.createElement
		local v14 = if state then translations.viewLessButton else translations.viewMoreButton
		v11 = createElement2(linkButton, {
			text = v14,
			onActivated = v5,
			fontStyle = "CaptionHeader",
			minPaddingX = 0,
			minPaddingY = 0,
			layoutOrder = 2
		}) or nil
	end

	v10.ToggleButton = v11
	return createElement(view, v9, v10)
end

local function BadUtterances(p2)
	local translations = useNotApprovedPageContext().translations

	local badUtterances = p2.moderationDetail.badUtterances
	local beginDate = p2.moderationDetail.beginDate

	return module4.createElement(view, {
		tag = "size-full-0 auto-y col gap-small",
		LayoutOrder = 1
	}, {
		BadUtterancesContent = module4.createElement(BadUtterancesContent, {
			badUtterances = badUtterances,
			LayoutOrder = 1
		}),
		Divider = module4.createElement(view, {
			tag = "auto-xy padding-y-small",
			LayoutOrder = 2
		}, {
			Divider = module4.createElement(divider, nil)
		}),
		ReviewDate = module4.createElement(module, {
			fieldLabel = translations.dateReviewedLabel,
			fieldValue = module3(beginDate, translations),
			layoutOrder = 4
		})
	})
end

return {
	getIsVisible = function(p2)
		local violation = p2.violation
		local badUtterances = p2.badUtterances
		return not module2.isVisibleInView(violation) and badUtterances and #badUtterances ~= 0
	end,
	renderComponent = module4.memo(BadUtterances)
}
