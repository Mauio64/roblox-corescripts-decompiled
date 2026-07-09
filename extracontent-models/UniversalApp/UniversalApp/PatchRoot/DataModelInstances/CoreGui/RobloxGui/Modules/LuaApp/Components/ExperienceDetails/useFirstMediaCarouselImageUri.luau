local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local GameMediaImageType = require(CorePackages.Workspace.Packages.DiscoveryTypes).GameMediaImageType
local t1 = {
	Loading = "Loading",
	Found = "Found",
	NotFound = "NotFound"
}
local t2 = {
	url = nil,
	status = t1.Loading
}
local t3 = {
	url = nil,
	status = t1.NotFound
}

return {
	useFirstMediaCarouselImageUri = function(s1: string?) -- line: 24
		-- upvalues: useSelector (copy), React (copy), t2 (copy), GameMediaImageType (copy), t1 (copy), t3 (copy)
		local v9 = useSelector(function(p1) -- line: 25
			-- upvalues: s1 (copy)
			if s1 then
				return p1.GameMedia[s1]
			end

			return nil
		end)

		return React.useMemo(function() -- line: 32
			-- upvalues: v9 (copy), t2 (copy), GameMediaImageType (copy), t1 (copy), t3 (copy)
			if not v9 then
				return t2
			end

			for _, v12 in v9 do
				if v12.assetTypeId == GameMediaImageType.Image and v12.imageId then
					local v13 = string.format("rbxthumb://type=Asset&id=%s&w=768&h=432", (tostring(v12.imageId)))

					return {
						status = t1.Found,
						url = v13
					}
				end
			end

			return t3
		end, { v9 })
	end,
	MediaCarouselImageStatus = t1
}
