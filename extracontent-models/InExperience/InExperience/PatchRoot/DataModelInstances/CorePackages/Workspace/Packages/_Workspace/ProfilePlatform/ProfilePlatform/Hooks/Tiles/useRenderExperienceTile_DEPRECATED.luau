local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local useDispatch = require(ProfilePlatformParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigation = require(ProfilePlatformParent.Navigation).useNavigation
local OpenGameDetails = require(ProfilePlatformParent.GameDetail).OpenGameDetails
local UIBlox = require(ProfilePlatformParent.UIBlox)
local ExperienceTileV3 = UIBlox.App.Tile.ExperienceTileV3
local useStyle = UIBlox.Core.Style.useStyle
local UserLib = require(ProfilePlatformParent.UserLib)
local Constants = UserLib.Utils.Constants

require(ProfilePlatform.Common.Types)

local FFlagRenameDeprecatedUIBloxTokens = require(ProfilePlatformParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

local function useRenderSquareExperienceTile(s1: string?, p1: ((...any) -> ...any)?, _: {[any]: any}?) -- line: 29
	-- upvalues: useDispatch (copy), useNavigation (copy), useStyle (copy), React (copy), OpenGameDetails (copy), Constants (copy), getRbxthumbWithTypeSizeAndOptions (copy), ExperienceTileV3 (copy), FFlagRenameDeprecatedUIBloxTokens (copy)
	local v18 = useDispatch()
	local v19 = useNavigation()
	local v20 = useStyle()
	local u21 = s1 or "ProfileExperienceTile_"

	return (React.useCallback(function(p2, n1: number, _, n2: number?) -- line: 46
		-- upvalues: p1 (copy), v18 (copy), OpenGameDetails (copy), v19 (copy), Constants (copy), getRbxthumbWithTypeSizeAndOptions (copy), React (copy), ExperienceTileV3 (copy), v20 (copy), u21 (ref)
		local GameIcon = Constants.RbxthumbTypes.GameIcon
		local v27 = getRbxthumbWithTypeSizeAndOptions(p2.experienceId, GameIcon, 150)

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = n1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			Tile = React.createElement(ExperienceTileV3, {
				contextTextLineCount = 1,
				hasBackground = false,
				isHoverEnabled = false,
				hasOutline = false,
				experienceName = p2.name,
				thumbnail = v27,
				onActivated = function() -- line: 47
					-- upvalues: p1 (copy), p2 (copy), n1 (copy), n2 (copy), v18 (copy), OpenGameDetails (copy), v19 (copy)
					if p1 then
						p1(p2, n1, n2)
					end

					v18(OpenGameDetails(p2.experienceId, v19, {
						mountAsFullView = false,
						showBackButton = true
					}))
				end,
				styleProps = {
					bottomContentPadding = {
						Left = 0,
						Right = 0,
						Top = v20.Tokens.Padding.Small,
						Bottom = v20.Tokens.Padding.Small
					}
				}
			})
		}), `{ u21 }{ p2.experienceId }_`
	end, {
		v18,
		v19,
		if not FFlagRenameDeprecatedUIBloxTokens then v20.Tokens.Component.VerticalTile.Base.ContentBottom.Spacing else v20.Tokens.Padding.Small,
		p1,
		u21
	}))
end

return useRenderSquareExperienceTile
