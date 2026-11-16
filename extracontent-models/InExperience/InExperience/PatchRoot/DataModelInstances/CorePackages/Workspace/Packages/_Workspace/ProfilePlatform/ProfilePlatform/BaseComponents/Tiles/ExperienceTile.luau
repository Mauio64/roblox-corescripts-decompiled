local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local UIBlox = require(parent.UIBlox)
local ExperienceTileV3 = UIBlox.App.Tile.ExperienceTileV3
local useStyle = UIBlox.Core.Style.useStyle

local UserLib = require(parent.UserLib)
local Constants = UserLib.Utils.Constants
local GameTile = require(parent.GameTile)
local GameStats = GameTile.GameStats
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local FFlagProfilePlatformEnableExperiencesFooter = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableExperiencesFooter)

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue

require(ProfilePlatform.Common.Types)

local useSetupImpressionsTileTagging = require(ProfilePlatform.Hooks.useSetupImpressionsTileTagging)

local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

local v = {}

local function ExperienceTile(props)
	local v2 = useStyle()

	local ref = React.useRef(nil)
	useSetupImpressionsTileTagging(ref, props.impressionsTag, props.index)

	local gameIcon = Constants.RbxthumbTypes.GameIcon
	local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(props.item.experienceId, gameIcon, 150)

	local v3 = props.showFooter and FFlagProfilePlatformEnableExperiencesFooter
	local v4

	if v3 then
		v4 = useSelector(function(p)
			return getDeepValue(p, "GameVotes") or v
		end)[props.item.experienceId]
	end

	local createElement = React.createElement
	local v5 = {
		LayoutOrder = props.index,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ref = ref
	}

	local createElement2 = React.createElement
	local v6 = {
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
				Top = v2.Tokens.Padding.Small,
				Bottom = v2.Tokens.Padding.Small
			}
		},
		footer = 0,
		footerHeight = 0
	}
	local footer

	if v3 then
		footer = React.createElement(GameStats, {
			isGridTile = true,
			stats = {
				totalUpVotes = v4 and v4.upVotes or 0,
				totalDownVotes = v4 and v4.downVotes or 0,
				playerCount = props.item.playing
			}
		})
	end

	v6.footer = footer

	v6.footerHeight = v3 and 32 or nil
	return createElement("Frame", v5, {
		Tile = createElement2(ExperienceTileV3, v6)
	})
end

return ExperienceTile
