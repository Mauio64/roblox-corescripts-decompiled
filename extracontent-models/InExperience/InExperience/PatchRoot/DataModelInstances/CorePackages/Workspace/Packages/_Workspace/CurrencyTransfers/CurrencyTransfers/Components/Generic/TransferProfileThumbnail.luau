local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local React = require(parent.React)

local GetFFlagCurrencyTransferFlowUIImprovementFix = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFlowUIImprovementFix)

local FFlagCurrencyTransferUseProfileFrameThumbnail = require(CurrencyTransfers.Flags.FFlagCurrencyTransferUseProfileFrameThumbnail)

local Foundation = require(parent.Foundation)
local Image = Foundation.Image
local View = Foundation.View
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local UserLib = require(parent.UserLib)
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

local Size100x100 = Enum.ThumbnailSize.Size100x100

local function UserProfileThumbnail(state)
	local v = useTokens()

	if not state.thumbnailSize then
		state.thumbnailSize = Size100x100
	end

	local v2 = state.thumbnailSize == Enum.ThumbnailSize.Size48x48 and 48
		or state.thumbnailSize == Enum.ThumbnailSize.Size60x60 and 60
		or 150

	local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(
		state.userId,
		Constants.RbxthumbTypes.AvatarHeadShot,
		v2,
		true,
		nil,
		FFlagCurrencyTransferUseProfileFrameThumbnail
	)

	local size = state.size or UDim2.fromOffset(80, 80)

	local createElement = React.createElement
	local v3 = {
		tag = "col gap-xlarge auto-xy align-x-center align-y-center",
		LayoutOrder = state.layoutOrder
	}
	local v4 = {
		AvatarContainer = React.createElement(
			View,
			{ tag = "aspect-1-1 position-center-center anchor-center-center", Size = size },
			{
				AvatarImage = React.createElement(Image, {
					Image = rbxthumbWithTypeSizeAndOptions,
					backgroundStyle = v.Color.Shift.Shift_300,
					tag = "size-full aspect-1-1 radius-circle align-x-center align-y-center"
				})
			}
		),
		NameContainer = 0,
		HandleContainer = 0
	}
	local nameContainer

	if state.showUsername then
		local v5

		if GetFFlagCurrencyTransferFlowUIImprovementFix() then
			v5 = state.username or state.displayName
		else
			v5 = state.username
		end

		if v5 then
			local createElement2 = React.createElement

			local createElement3 = React.createElement
			local text

			if GetFFlagCurrencyTransferFlowUIImprovementFix() then
				text = state.displayName or state.username or ""
			else
				text = state.username or ""
			end

			nameContainer = createElement2(View, { tag = "col auto-y align-x-center" }, {
				Name = createElement3(Text, {
					Text = text,
					tag = "text-title-medium content-emphasis text-align-x-center"
				})
			})
		end
	end

	v4.NameContainer = nameContainer
	local handleContainer

	if GetFFlagCurrencyTransferFlowUIImprovementFix() then
		if state.displayName and state.username then
			handleContainer = React.createElement(View, {
				tag = "col auto-y padding-bottom-medium",
				LayoutOrder = 3
			}, {
				Handle = React.createElement(Text, {
					Text = "@" .. state.username,
					tag = "text-label-medium content-emphasis"
				})
			})
		end
	elseif state.displayName then
		handleContainer = React.createElement(View, {
			tag = "col auto-y padding-bottom-medium",
			LayoutOrder = 3
		}, {
			Handle = React.createElement(Text, {
				Text = "@" .. state.displayName,
				tag = "text-label-medium content-emphasis"
			})
		})
	end

	v4.HandleContainer = handleContainer
	return createElement(View, v3, v4)
end

return UserProfileThumbnail
