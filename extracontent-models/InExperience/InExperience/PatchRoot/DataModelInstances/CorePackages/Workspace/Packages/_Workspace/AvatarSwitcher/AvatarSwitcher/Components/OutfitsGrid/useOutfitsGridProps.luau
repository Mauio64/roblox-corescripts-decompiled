local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local parent = AvatarSwitcher.Parent

local SignalsReact = require(parent.SignalsReact)

local getAvatarSwitcherStore = require(AvatarSwitcher.Stores.getAvatarSwitcherStore)
require(AvatarSwitcher.types)

local ExperienceAvatarSupportType = require(AvatarSwitcher.Enums.ExperienceAvatarSupportType)

local defineFastInt = game:DefineFastInt("AvatarSwitcherShimmerTiles", 12)

local function useOutfitsGridProps()
	local v = SignalsReact.useSignalState(getAvatarSwitcherStore)
	local outfits = SignalsReact.useSignalState(v.getOutfits)
	local lastPageReached = SignalsReact.useSignalState(v.getLastPageReached)
	local disabled = SignalsReact.useSignalState(v.getExperienceAvatarSupportType) == ExperienceAvatarSupportType.NoSupport

	if #outfits == 0 and not lastPageReached then
		outfits = {}

		for _ = 1, defineFastInt do
			table.insert(outfits, {})
		end
	end

	return {
		outfits = outfits,
		lastPageReached = lastPageReached,
		fetchNextOutfitsPage = v.fetchNextOutfitsPage,
		disabled = disabled
	}
end

return useOutfitsGridProps
