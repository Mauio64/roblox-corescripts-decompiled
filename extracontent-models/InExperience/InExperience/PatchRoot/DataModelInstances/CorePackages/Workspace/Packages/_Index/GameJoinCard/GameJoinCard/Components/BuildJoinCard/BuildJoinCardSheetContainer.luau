local GameJoinCard = script:FindFirstAncestor("GameJoinCard")
local parent = GameJoinCard.Parent

local React = require(parent.React)
local Navigation = require(parent.Navigation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local MobileGameJoinCard = require(GameJoinCard.Components.MobileGameJoinCard.MobileGameJoinCard)
local BuildJoinCardMedia = require(script.Parent.BuildJoinCardMedia)
local useBuildJoinCardViewModel = require(script.Parent.useBuildJoinCardViewModel)
local usePlayerName = require(GameJoinCard.Hooks.usePlayerName)

local function noop(_) end

local function BuildJoinCardSheetContainer()
	local v = Navigation.useNavigation()
	local param = v.getParam("userId")
	local v2 = type(param) == "string" and param ~= ""
	assert(v2, "BuildJoinCard route needs a userId param")
	local v3 = usePlayerName(param)
	local isNavigationFocused = Navigation.useNavigationFocus()
	local onClose = React.useCallback(function()
		v.goBack()
	end, { v })

	local v4 = useBuildJoinCardViewModel({
		userId = param,
		onClose = onClose,
		keepsOpenOnNavigation = true
	})

	local v5 = useLocalization({ subtitle = "Feature.Profile.Label.IsMakingGameInBuild" })

	local content = {
		media = React.createElement(BuildJoinCardMedia, { userId = param, slot = "Banner" }),
		title = v3,
		subtitle = v5.subtitle
	}

	return React.createElement(MobileGameJoinCard, {
		isNavigationFocused = isNavigationFocused,
		onClose = onClose,
		onJoin = noop,
		onViewExperienceDetails = noop,
		onChat = noop,
		canUsePlatformChat = false,
		userId = param,
		universeId = "",
		playerName = v3,
		experienceName = "",
		isLoading = false,
		isInExperience = false,
		actions = v4.actions,
		content = content
	})
end

return BuildJoinCardSheetContainer
