local Parent = script:FindFirstAncestor("AmpUpsell").Parent
local UrlBase = require(Parent.UrlBuilder).UrlBase

return {
	buildAmpWizardUrl = function(s1: string, s2: string, s3: string?, s4: string?) -- line: 17
		-- upvalues: UrlBase (copy)
		local v7 = UrlBase.new("www") .. "/amp-wizard?feature_name=" .. s1 .. "&namespace=" .. s2

		if s3 then
			v7 ..= "&entry_point=" .. s3
		end

		if s4 then
			v7 ..= "&returnpage=" .. s4
		end

		return v7
	end
}
