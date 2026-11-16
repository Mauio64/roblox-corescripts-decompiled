local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils").Hooks.RoactRodux.useDispatch

local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Navigation").useNavigation
local openGameDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GameDetail").OpenGameDetails

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox")
local experienceTileV3 = UIBlox.App.Tile.ExperienceTileV3
local useStyle = UIBlox.Core.Style.useStyle

local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserLib")
local constants = UserLib.Utils.Constants

require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")

local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

local function useRenderSquareExperienceTile(value, callback, p2)
	local v5 = useDispatch()
	local v6 = useNavigation()
	local v7 = useStyle()

	local v8 = value or "ProfileExperienceTile_"

	return (React.useCallback(function(p3, p4, p5, p6)
		local function onActivated()
			if callback then
				callback(p3, p4, p6)
			end

			v5(openGameDetails(p3.experienceId, v6, {
				mountAsFullView = false,
				showBackButton = true
			}))
		end

		local gameIcon = constants.RbxthumbTypes.GameIcon
		local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(
			p3.experienceId,
			gameIcon,
			150
		)

		return
			React.createElement(
				"Frame",
				{
					LayoutOrder = p4,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1
				},
				{
					Tile = React.createElement(experienceTileV3, {
						contextTextLineCount = 1,
						experienceName = p3.name,
						thumbnail = rbxthumbWithTypeSizeAndOptions,
						hasBackground = false,
						isHoverEnabled = false,
						hasOutline = false,
						onActivated = onActivated,
						styleProps = {
							bottomContentPadding = {
								Left = 0,
								Right = 0,
								Top = v7.Tokens.Padding.Small,
								Bottom = v7.Tokens.Padding.Small
							}
						}
					})
				}
			),
			`{v8}{p3.experienceId}_`
	end, { v5, v6, v7.Tokens.Padding.Small, callback, v8 }))
end

return useRenderSquareExperienceTile
