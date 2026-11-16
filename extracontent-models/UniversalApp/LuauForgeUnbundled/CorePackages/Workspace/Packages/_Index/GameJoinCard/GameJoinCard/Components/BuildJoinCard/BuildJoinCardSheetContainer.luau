local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Navigation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Localization").Hooks.useLocalization

local MobileGameJoinCard = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/MobileGameJoinCard/MobileGameJoinCard")
local BuildJoinCardMedia = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/BuildJoinCard/BuildJoinCardMedia")
local useBuildJoinCardViewModel = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/BuildJoinCard/useBuildJoinCardViewModel")
local usePlayerName = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Hooks/usePlayerName")

local function noop(p2) end

local function BuildJoinCardSheetContainer()
	local v5 = Navigation.useNavigation()
	local param = v5.getParam("userId")
	local v6 = type(param) == "string" and param ~= ""
	assert(v6, "BuildJoinCard route needs a userId param")
	local v7 = usePlayerName(param)
	local v8 = Navigation.useNavigationFocus()
	local v9 = React.useCallback(function()
		v5.goBack()
	end, { v5 })

	local v10 = useBuildJoinCardViewModel({ userId = param, onClose = v9, keepsOpenOnNavigation = true })

	local v11 = useLocalization({
		subtitle = "Feature.Profile.Label.IsMakingGameInBuild"
	})

	local v12 = {
		media = React.createElement(BuildJoinCardMedia, { userId = param, slot = "Banner" }),
		title = v7,
		subtitle = v11.subtitle
	}

	return React.createElement(MobileGameJoinCard, {
		isNavigationFocused = v8,
		onClose = v9,
		onJoin = noop,
		onViewExperienceDetails = noop,
		onChat = noop,
		canUsePlatformChat = false,
		userId = param,
		universeId = "",
		playerName = v7,
		experienceName = "",
		isLoading = false,
		isInExperience = false,
		actions = v10.actions,
		content = v12
	})
end

return BuildJoinCardSheetContainer
