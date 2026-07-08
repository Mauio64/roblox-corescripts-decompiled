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

local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

local function useRenderSquareExperienceTile(s1: string?, p1: ((...any) -> ...any)?, _: {[any]: any}?) -- line: 27
	-- upvalues: useDispatch (copy), useNavigation (copy), useStyle (copy), React (copy), OpenGameDetails (copy), Constants (copy), getRbxthumbWithTypeSizeAndOptions (copy), ExperienceTileV3 (copy)
	local v17 = useDispatch()
	local v18 = useNavigation()
	local v19 = useStyle()
	local u20 = s1 or "ProfileExperienceTile_"

	return (React.useCallback(function(p2, n1: number, _, n2: number?) -- line: 44
		-- upvalues: p1 (copy), v17 (copy), OpenGameDetails (copy), v18 (copy), Constants (copy), getRbxthumbWithTypeSizeAndOptions (copy), React (copy), ExperienceTileV3 (copy), v19 (copy), u20 (ref)
		local GameIcon = Constants.RbxthumbTypes.GameIcon
		local v26 = getRbxthumbWithTypeSizeAndOptions(p2.experienceId, GameIcon, 150)

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
				thumbnail = v26,
				onActivated = function() -- line: 45
					-- upvalues: p1 (copy), p2 (copy), n1 (copy), n2 (copy), v17 (copy), OpenGameDetails (copy), v18 (copy)
					if p1 then
						p1(p2, n1, n2)
					end

					v17(OpenGameDetails(p2.experienceId, v18, {
						mountAsFullView = false,
						showBackButton = true
					}))
				end,
				styleProps = {
					bottomContentPadding = {
						Left = 0,
						Right = 0,
						Top = v19.Tokens.Padding.Small,
						Bottom = v19.Tokens.Padding.Small
					}
				}
			})
		}), `{ u20 }{ p2.experienceId }_`
	end, {
		v17,
		v18,
		v19.Tokens.Component.VerticalTile.Base.ContentBottom.Spacing,
		p1,
		u20
	}))
end

return useRenderSquareExperienceTile
