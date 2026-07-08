local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local AvatarSwitcherParent = AvatarSwitcher.Parent
local SignalsReact = require(AvatarSwitcherParent.SignalsReact)
local getAvatarSwitcherStore = require(AvatarSwitcher.Stores.getAvatarSwitcherStore)

require(AvatarSwitcher.types)

local ExperienceAvatarSupportType = require(AvatarSwitcher.Enums.ExperienceAvatarSupportType)
local v6 = game:DefineFastInt("AvatarSwitcherShimmerTiles", 12)

local function useOutfitsGridProps() -- line: 19
	-- upvalues: SignalsReact (copy), getAvatarSwitcherStore (copy), ExperienceAvatarSupportType (copy), v6 (copy)
	local v8 = SignalsReact.useSignalState(getAvatarSwitcherStore)
	local v9 = SignalsReact.useSignalState(v8.getOutfits)
	local v10 = SignalsReact.useSignalState(v8.getLastPageReached)
	local v11 = SignalsReact.useSignalState(v8.getExperienceAvatarSupportType) == ExperienceAvatarSupportType.NoSupport

	if #v9 == 0 and not v10 then
		v9 = {}

		for _ = 1, v6 do
			table.insert(v9, {})
		end
	end

	return {
		outfits = v9,
		lastPageReached = v10,
		fetchNextOutfitsPage = v8.fetchNextOutfitsPage,
		disabled = v11
	}
end

return useOutfitsGridProps
