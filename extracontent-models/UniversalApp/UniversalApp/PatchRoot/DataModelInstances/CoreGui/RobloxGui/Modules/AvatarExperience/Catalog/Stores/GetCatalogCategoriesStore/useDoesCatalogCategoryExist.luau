local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)

require(script.Parent.createCatalogCategoriesStore)

local function useDoesCatalogCategoryExist(p1, s1: string?, s2: string?) -- line: 17
	-- upvalues: React (copy), Signals (copy), SignalsReact (copy)
	local v9 = React.useMemo(function() -- line: 24
		-- upvalues: Signals (copy), p1 (copy), s1 (copy), s2 (copy)
		return Signals.createComputed(function(p2) -- line: 25
			-- upvalues: p1 (copy), s1 (copy), s2 (copy)
			local v11 = p1.getCategoriesMap(p2)

			if not s1 then
				return false
			end

			local v12 = v11[s1]

			if not v12 then
				return false
			end

			if s2 then
				return v12.SubcategoriesMap ~= nil and v12.SubcategoriesMap[s2] ~= nil
			end

			return true
		end)
	end, {
		s1,
		s2
	})

	return SignalsReact.useSignalState(v9)
end

return useDoesCatalogCategoryExist
