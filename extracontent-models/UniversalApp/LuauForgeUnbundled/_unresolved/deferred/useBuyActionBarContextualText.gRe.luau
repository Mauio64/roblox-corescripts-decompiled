local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local function useBuyActionBarContextualText(p2, p3)
	local v5 = useLocalization({
		preFaeInfoText = "Feature.MarketplaceFAEUpsell.ActionBar.InfoText.PreFAE",
		postFaeInfoText = "Feature.MarketplaceFAEUpsell.ActionBar.InfoText.PostFAE"
	})

	if p2 then
		return v5.preFaeInfoText
	end

	if p3 then
		return v5.postFaeInfoText
	end

	return nil
end

return useBuyActionBarContextualText
