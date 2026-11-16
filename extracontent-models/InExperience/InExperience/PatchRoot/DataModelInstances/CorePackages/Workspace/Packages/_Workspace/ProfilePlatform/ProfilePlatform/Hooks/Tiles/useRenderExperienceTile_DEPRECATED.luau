local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local GameDetail = require(parent.GameDetail)
local OpenGameDetails = GameDetail.OpenGameDetails

local UIBlox = require(parent.UIBlox)
local ExperienceTileV3 = UIBlox.App.Tile.ExperienceTileV3
local useStyle = UIBlox.Core.Style.useStyle

local UserLib = require(parent.UserLib)
local Constants = UserLib.Utils.Constants

require(ProfilePlatform.Common.Types)

local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

local function useRenderSquareExperienceTile(value: string?, callback, _)
	local v = useDispatch()
	local v2 = useNavigation()
	local v3 = useStyle()

	local v4 = value or "ProfileExperienceTile_"

	return (React.useCallback(function(p, layoutOrder: number, _, p2: number?)
		local function onActivated()
			if callback then
				callback(p, layoutOrder, p2)
			end

			v(OpenGameDetails(p.experienceId, v2, { mountAsFullView = false, showBackButton = true }))
		end

		local gameIcon = Constants.RbxthumbTypes.GameIcon
		local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(p.experienceId, gameIcon, 150)

		return
			React.createElement(
				"Frame",
				{
					LayoutOrder = layoutOrder,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1
				},
				{
					Tile = React.createElement(ExperienceTileV3, {
						contextTextLineCount = 1,
						experienceName = p.name,
						thumbnail = rbxthumbWithTypeSizeAndOptions,
						hasBackground = false,
						isHoverEnabled = false,
						hasOutline = false,
						onActivated = onActivated,
						styleProps = {
							bottomContentPadding = {
								Left = 0,
								Right = 0,
								Top = v3.Tokens.Padding.Small,
								Bottom = v3.Tokens.Padding.Small
							}
						}
					})
				}
			),
			`{v4}{p.experienceId}_`
	end, { v, v2, v3.Tokens.Padding.Small, callback, v4 }))
end

return useRenderSquareExperienceTile
