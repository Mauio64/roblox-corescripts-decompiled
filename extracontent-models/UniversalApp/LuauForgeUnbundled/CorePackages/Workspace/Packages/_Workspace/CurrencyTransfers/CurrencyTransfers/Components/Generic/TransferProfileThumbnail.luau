local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")

local GetFFlagCurrencyTransferFlowUIImprovementFix = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagCurrencyTransferFlowUIImprovementFix")

local FFlagCurrencyTransferUseProfileFrameThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/FFlagCurrencyTransferUseProfileFrameThumbnail")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Foundation")
local image = Foundation.Image
local view = Foundation.View
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/UserLib")
local constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

local size100x100 = Enum.ThumbnailSize.Size100x100

local function UserProfileThumbnail(state)
	local v5 = useTokens()

	if not state.thumbnailSize then
		state.thumbnailSize = size100x100
	end

	local v6 = state.thumbnailSize == Enum.ThumbnailSize.Size48x48 and 48
		or state.thumbnailSize == Enum.ThumbnailSize.Size60x60 and 60
		or 150

	local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(
		state.userId,
		constants.RbxthumbTypes.AvatarHeadShot,
		v6,
		true,
		nil,
		FFlagCurrencyTransferUseProfileFrameThumbnail
	)

	local size = state.size or UDim2.fromOffset(80, 80)

	local createElement = React.createElement
	local v8 = {
		tag = "col gap-xlarge auto-xy align-x-center align-y-center",
		LayoutOrder = state.layoutOrder
	}
	local v9 = {
		AvatarContainer = React.createElement(
			view,
			{
				tag = "aspect-1-1 position-center-center anchor-center-center",
				Size = size
			},
			{
				AvatarImage = React.createElement(image, {
					Image = rbxthumbWithTypeSizeAndOptions,
					backgroundStyle = v5.Color.Shift.Shift_300,
					tag = "size-full aspect-1-1 radius-circle align-x-center align-y-center"
				})
			}
		),
		NameContainer = 0,
		HandleContainer = 0
	}
	local v10

	if state.showUsername then
		local v11 = if GetFFlagCurrencyTransferFlowUIImprovementFix() then state.username or state.displayName else state.username

		if v11 then
			local createElement2 = React.createElement

			local createElement3 = React.createElement

			local v17 = if GetFFlagCurrencyTransferFlowUIImprovementFix() then state.displayName or state.username or "" else state.username or ""
			v10 = createElement2(view, { tag = "col auto-y align-x-center" }, {
				Name = createElement3(text, {
					Text = v17,
					tag = "text-title-medium content-emphasis text-align-x-center"
				})
			})
		end
	end

	v9.NameContainer = v10
	local v11

	if GetFFlagCurrencyTransferFlowUIImprovementFix() then
		if state.displayName and state.username then
			v11 = React.createElement(
				view,
				{ tag = "col auto-y padding-bottom-medium", LayoutOrder = 3 },
				{
					Handle = React.createElement(text, {
						Text = "@" .. state.username,
						tag = "text-label-medium content-emphasis"
					})
				}
			)
		end
	elseif state.displayName then
		v11 = React.createElement(view, {
			tag = "col auto-y padding-bottom-medium",
			LayoutOrder = 3
		}, {
			Handle = React.createElement(text, {
				Text = "@" .. state.displayName,
				tag = "text-label-medium content-emphasis"
			})
		})
	end

	v9.HandleContainer = v11
	return createElement(view, v8, v9)
end

return UserProfileThumbnail
