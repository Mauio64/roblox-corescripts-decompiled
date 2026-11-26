local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

require("@game/CorePackages/Workspace/Packages/AppBlox")

local function useVisibleMediaGalleryItems(list, p2)
	return (React.useMemo(function()
		local result = {}

		for i = 1, 3 do
			local v5 = p2 + i - 1 - 1

			if not (v5 < 1 or #list < v5) then
				table.insert(result, list[v5])
			end
		end

		return result
	end, { list, p2 }))
end

return useVisibleMediaGalleryItems
