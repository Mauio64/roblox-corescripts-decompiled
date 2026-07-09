local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local UIBlox = require(ProfilePlatformParent.UIBlox)
local ExperienceTileV3 = UIBlox.App.Tile.ExperienceTileV3
local useStyle = UIBlox.Core.Style.useStyle
local UserLib = require(ProfilePlatformParent.UserLib)
local Constants = UserLib.Utils.Constants
local GameStats = require(ProfilePlatformParent.GameTile).GameStats
local useSelector = require(ProfilePlatformParent.RoactUtils).Hooks.RoactRodux.useSelector
local FFlagProfilePlatformEnableExperiencesFooter = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableExperiencesFooter)
local getDeepValue = require(ProfilePlatformParent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Dictionary.getDeepValue

require(ProfilePlatform.Common.Types)

local useSetupImpressionsTileTagging = require(ProfilePlatform.Hooks.useSetupImpressionsTileTagging)
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local t1 = {}

local function ExperienceTile(t2: {[any]: any}) -- line: 41
	-- upvalues: useStyle (copy), React (copy), useSetupImpressionsTileTagging (copy), Constants (copy), getRbxthumbWithTypeSizeAndOptions (copy), FFlagProfilePlatformEnableExperiencesFooter (copy), useSelector (copy), getDeepValue (copy), t1 (copy), ExperienceTileV3 (copy), GameStats (copy)
	local v18 = useStyle()
	local v19 = React.useRef(nil)

	useSetupImpressionsTileTagging(v19, t2.impressionsTag, t2.index)

	local GameIcon = Constants.RbxthumbTypes.GameIcon
	local v21 = getRbxthumbWithTypeSizeAndOptions(t2.item.experienceId, GameIcon, 150)
	local v22 = nil
	local v23 = t2.showFooter and FFlagProfilePlatformEnableExperiencesFooter

	if v23 then
		v22 = useSelector(function(p1) -- line: 53
			-- upvalues: getDeepValue (copy), t1 (copy)
			return getDeepValue(p1, "GameVotes") or t1
		end)[t2.item.experienceId]
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t2.index,
		Size = UDim2.new(1, 0, 1, 0),
		ref = v19
	}, {
		Tile = React.createElement(ExperienceTileV3, {
			contextTextLineCount = 1,
			hasBackground = false,
			isHoverEnabled = false,
			hasOutline = false,
			experienceName = t2.item.name,
			thumbnail = v21,
			onActivated = t2.onActivated,
			styleProps = {
				bottomContentPadding = {
					Left = 0,
					Right = 0,
					Top = v18.Tokens.Padding.Small,
					Bottom = v18.Tokens.Padding.Small
				}
			},
			footer = if not v23 then nil else React.createElement(GameStats, {
				isGridTile = true,
				stats = {
					totalUpVotes = v22 and v22.upVotes or 0,
					totalDownVotes = v22 and v22.downVotes or 0,
					playerCount = t2.item.playing
				}
			}),
			footerHeight = if not v23 then nil else 32
		})
	})
end

return ExperienceTile
