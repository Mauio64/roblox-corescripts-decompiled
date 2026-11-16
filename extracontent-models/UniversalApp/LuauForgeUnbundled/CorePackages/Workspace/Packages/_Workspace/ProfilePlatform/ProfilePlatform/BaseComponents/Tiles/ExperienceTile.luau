local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox")
local experienceTileV3 = UIBlox.App.Tile.ExperienceTileV3
local useStyle = UIBlox.Core.Style.useStyle

local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserLib")
local constants = UserLib.Utils.Constants
local gameStats = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GameTile").GameStats
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils").Hooks.RoactRodux.useSelector

local FFlagProfilePlatformEnableExperiencesFooter = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableExperiencesFooter")

local getDeepValue = require("@luauforge/bundled/eUd").SocialLibraries.config({}).Dictionary.getDeepValue

require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")

local useSetupImpressionsTileTagging = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useSetupImpressionsTileTagging")

local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

local v5 = {}

local function ExperienceTile(props)
	local v6 = useStyle()

	local ref = React.useRef(nil)
	useSetupImpressionsTileTagging(ref, props.impressionsTag, props.index)

	local gameIcon = constants.RbxthumbTypes.GameIcon
	local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(
		props.item.experienceId,
		gameIcon,
		150
	)

	local v7 = props.showFooter and FFlagProfilePlatformEnableExperiencesFooter
	local v8

	if v7 then
		v8 = useSelector(function(p2)
			return getDeepValue(p2, "GameVotes") or v5
		end)[props.item.experienceId]
	end

	local createElement = React.createElement
	local v10 = {
		LayoutOrder = props.index,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ref = ref
	}

	local createElement2 = React.createElement
	local v13 = {
		contextTextLineCount = 1,
		experienceName = props.item.name,
		thumbnail = rbxthumbWithTypeSizeAndOptions,
		hasBackground = false,
		isHoverEnabled = false,
		hasOutline = false,
		onActivated = props.onActivated,
		styleProps = {
			bottomContentPadding = {
				Left = 0,
				Right = 0,
				Top = v6.Tokens.Padding.Small,
				Bottom = v6.Tokens.Padding.Small
			}
		},
		footer = 0,
		footerHeight = 0
	}

	local v14 = if v7 then React.createElement(gameStats, {
		isGridTile = true,
		stats = {
			totalUpVotes = v8 and v8.upVotes or 0,
			totalDownVotes = v8 and v8.downVotes or 0,
			playerCount = props.item.playing
		}
	}) else nil
	v13.footer = v14

	v13.footerHeight = v7 and 32 or nil
	return createElement("Frame", v10, {
		Tile = createElement2(experienceTileV3, v13)
	})
end

return ExperienceTile
