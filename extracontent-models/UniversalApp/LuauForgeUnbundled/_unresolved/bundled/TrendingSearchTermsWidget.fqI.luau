local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/React")
local module2 = require("@luauforge/bundled/fpW")
local useLocalization = require("@luauforge/bundled/fpQ").Hooks.useLocalization

local chipGroup = module2.ChipGroup
local chipGroupVariant = module2.Enums.ChipGroupVariant
local chipSize = module2.Enums.ChipSize
local text = module2.Text
local view = module2.View
local fFlagAXSearchTrendingChipLogging = require("@luauforge/bundled/fpS").FFlagAXSearchTrendingChipLogging

require("@luauforge/bundled/fqJ")

local v5 = { title = "Feature.Catalog.Label.Trending" }

local function TrendingSearchTermsWidget(p2)
	local v6 = useLocalization(v5)

	if p2.chips and #p2.chips ~= 0 then
		return React.createElement(view, {
			LayoutOrder = p2.LayoutOrder,
			tag = {
				["size-full-0 auto-y padding-y-small col gap-medium"] = true,
				clip = fFlagAXSearchTrendingChipLogging
			},
			testId = "TrendingSearchTermsWidget"
		}, {
			Title = React.createElement(text, {
				Text = v6.title,
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-heading-small text-align-x-left text-truncate-end content-emphasis",
				testId = "TrendingSearchTermsWidget--title"
			}),
			ChipGroup = React.createElement(chipGroup, {
				chips = p2.chips,
				size = chipSize.Medium,
				variant = chipGroupVariant.Row,
				LayoutOrder = 2,
				testId = "TrendingSearchTermsWidget--chips"
			})
		})
	end

	return nil
end

return TrendingSearchTermsWidget
