local parent = script:FindFirstAncestor("PeopleReactView").Parent

local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local AvatarBackground = require(parent.DataHydration.AvatarBackground)

local signal = Signals.createSignal(nil)

local function useAvatarBackgroundImage(p: number)
	local avatarBackgroundStore = AvatarBackground.getAvatarBackgroundStore(false)
	local v

	if p > 0 then
		v = avatarBackgroundStore.getAndFetchAvatarBackground(p).data
	else
		v = signal
	end

	local v2 = SignalsReact.useSignalState(v)
	local assetId = v2 and v2.assetId

	if assetId then
		return (AvatarBackground.getAvatarBackgroundImageUrl(assetId))
	end

	return nil
end

return useAvatarBackgroundImage
