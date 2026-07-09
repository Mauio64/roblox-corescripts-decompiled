local ParentParent = script.Parent.Parent
local Promise = require(ParentParent.Promise)

local function getPremiumUpsellPrecheck(p1) -- line: 4
	-- upvalues: Promise (copy)
	return p1.getPremiumUpsellPrecheck():andThen(function(_) -- line: 7
		-- upvalues: Promise (copy)
		return Promise.resolve(true)
	end):catch(function(_) -- line: 10
		-- upvalues: Promise (copy)
		return Promise.resolve(false)
	end)
end

return getPremiumUpsellPrecheck
