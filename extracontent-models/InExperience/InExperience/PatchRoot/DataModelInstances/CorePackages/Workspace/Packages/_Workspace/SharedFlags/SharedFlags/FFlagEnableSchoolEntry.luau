local v = game:DefineFastFlag("EnableSchoolEntry", false)

if v then
	local FFlagAddFriendsBannersNewUI_IXP = require(script.Parent.FFlagAddFriendsBannersNewUI_IXP)
	return FFlagAddFriendsBannersNewUI_IXP
		and require(script.Parent.FFlagConnectionChannelsTileSize)
		and game:GetEngineFeature("SchoolEntryTooltipSeenStorageKey")
		and game:GetEngineFeature("SchoolEntryLiveTooltipSeenStorageKey")
end

return v
