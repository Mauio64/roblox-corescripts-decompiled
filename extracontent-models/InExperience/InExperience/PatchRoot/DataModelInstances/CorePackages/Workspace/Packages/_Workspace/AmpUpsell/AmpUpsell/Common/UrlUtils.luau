local parent = script:FindFirstAncestor("AmpUpsell").Parent

local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

return {
	buildAmpWizardUrl = function(p: string, p2: string, p3: string?, p4: string?)
		local ampWizardUrl = UrlBase.new("www") .. "/amp-wizard?feature_name=" .. p .. "&namespace=" .. p2

		if p3 then
			ampWizardUrl ..= "&entry_point=" .. p3
		end

		if p4 then
			ampWizardUrl ..= "&returnpage=" .. p4
		end

		return ampWizardUrl
	end
}
