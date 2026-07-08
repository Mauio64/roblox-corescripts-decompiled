local ContentProvider = game:GetService("ContentProvider")
local Parent = script:FindFirstAncestor("GameJoinCard").Parent
local DataHydration = require(Parent.DataHydration)
local DataStatus = DataHydration.DataStatus
local getGameMediaStore = DataHydration.Game.getGameMediaStore
local GameMediaImageType = require(Parent.DiscoveryTypes).GameMediaImageType
local Signals = require(Parent.Signals)
local BannerImageConstants = require(script.Parent.BannerImageConstants)

local function preloadFirstImage(t1: {[any]: any}?) -- line: 27
	-- upvalues: GameMediaImageType (copy), BannerImageConstants (copy), ContentProvider (copy)
	if not t1 then
		return
	end

	for _, v14 in t1 do
		if v14.assetTypeId == GameMediaImageType.Image and v14.imageId then
			local v15 = string.format("rbxthumb://type=Asset&id=%s&w=%d&h=%d", tostring(v14.imageId), BannerImageConstants.DEFAULT_BANNER_WIDTH, BannerImageConstants.DEFAULT_BANNER_HEIGHT)

			task.spawn(function() -- line: 39
				-- upvalues: ContentProvider (copy), v15 (copy)
				pcall(function() -- line: 40
					-- upvalues: ContentProvider (copy), v15 (copy)
					ContentProvider:PreloadAsync({ v15 })
				end)
			end)

			return
		end
	end
end
local function prefetchUniverseMedia(s1: string) -- line: 49
	-- upvalues: getGameMediaStore (copy), DataStatus (copy), preloadFirstImage (copy), Signals (copy)
	local v17 = getGameMediaStore(false).getAndFetchGameMedia(s1)
	local v18 = v17.status(false)

	if v18 ~= DataStatus.NotReady then
		if v18 == DataStatus.Ready then
			preloadFirstImage(v17.data(false))
		end

		return
	end

	local u19 = nil

	u19 = Signals.createEffect(function(p1) -- line: 63
		-- upvalues: v17 (copy), DataStatus (copy), u19 (ref), preloadFirstImage (copy)
		local v24 = v17.status(p1)

		if v24 == DataStatus.NotReady then
			return
		end

		if u19 then
			u19()
			u19 = nil
		end

		if v24 == DataStatus.Ready then
			preloadFirstImage(v17.data(false))
		end
	end)
end
local function prefetchGameJoinCardMedia(t2: {[any]: any}?) -- line: 78
	-- upvalues: prefetchUniverseMedia (copy)
	if not t2 then
		return
	end

	for _, v22 in t2 do
		if v22.universeId and v22.universeId ~= "" then
			prefetchUniverseMedia((tostring(v22.universeId)))
		end
	end
end

return prefetchGameJoinCardMedia
