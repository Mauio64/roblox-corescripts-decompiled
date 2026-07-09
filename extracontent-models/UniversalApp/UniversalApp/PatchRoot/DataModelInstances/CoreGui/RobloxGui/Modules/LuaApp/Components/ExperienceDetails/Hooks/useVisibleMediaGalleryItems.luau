local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

require(CorePackages.Workspace.Packages.AppBlox)

local function useVisibleMediaGalleryItems(t1: {[any]: any}, n1: number) -- line: 11
	-- upvalues: React (copy)
	return (React.useMemo(function() -- line: 12
		-- upvalues: n1 (copy), t1 (copy)
		local t2 = {}

		for i = 1, 3 do
			local v8 = n1 + i - 1 - 1

			if not (v8 < 1) and not (v8 > #t1) then
				table.insert(t2, t1[v8])
			end
		end

		return t2
	end, {
		t1,
		n1
	}))
end

return useVisibleMediaGalleryItems
