local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local gameMediaImageType = require("@luauforge/bundled/cyO").GameMediaImageType

local v5 = { Loading = "Loading", Found = "Found", NotFound = "NotFound" }

local v6 = { status = v5.Loading, url = nil }
local v7 = { status = v5.NotFound, url = nil }

return {
	useFirstMediaCarouselImageUri = function(p2)
		local v8 = useSelector(function(p3)
			if p2 then
				return p3.GameMedia[p2]
			end

			return nil
		end)

		return React.useMemo(function()
			if not v8 then
				return v6
			end

			for k, v9 in v8 do
				if v9.assetTypeId == gameMediaImageType.Image and v9.imageId then
					local v10 = string.format(
						"rbxthumb://type=Asset&id=%s&w=768&h=432",
						(tostring(v9.imageId))
					)
					return { status = v5.Found, url = v10 }
				end
			end

			return v7
		end, { v8 })
	end,
	MediaCarouselImageStatus = v5
}
