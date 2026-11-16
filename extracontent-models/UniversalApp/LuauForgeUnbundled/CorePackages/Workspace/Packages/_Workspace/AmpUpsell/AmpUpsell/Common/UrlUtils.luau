local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/UrlBuilder").UrlBase

return {
	buildAmpWizardUrl = function(p2, p3, p4, p5)
		local ampWizardUrl = urlBase.new("www") .. "/amp-wizard?feature_name=" .. p2 .. "&namespace=" .. p3

		if p4 then
			ampWizardUrl ..= "&entry_point=" .. p4
		end

		if p5 then
			ampWizardUrl ..= "&returnpage=" .. p5
		end

		return ampWizardUrl
	end
}
