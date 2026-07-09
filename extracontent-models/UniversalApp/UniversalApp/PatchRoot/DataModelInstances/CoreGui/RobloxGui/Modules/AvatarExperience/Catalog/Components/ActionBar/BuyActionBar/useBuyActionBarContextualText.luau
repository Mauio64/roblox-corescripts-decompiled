local CorePackages = game:GetService("CorePackages")
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization

local function useBuyActionBarContextualText(b1: boolean?, b2: boolean?) -- line: 5
	-- upvalues: useLocalization (copy)
	local v6 = useLocalization({
		preFaeInfoText = "Feature.MarketplaceFAEUpsell.ActionBar.InfoText.PreFAE",
		postFaeInfoText = "Feature.MarketplaceFAEUpsell.ActionBar.InfoText.PostFAE"
	})

	if b1 then
		return v6.preFaeInfoText
	end

	if b2 then
		return v6.postFaeInfoText
	end

	return nil
end

return useBuyActionBarContextualText
