local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local React = require(CurrencyTransfersParent.React)
local GetFFlagCurrencyTransferFlowUIImprovementFix = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFlowUIImprovementFix)
local Foundation = require(CurrencyTransfersParent.Foundation)
local FoundationImage = Foundation.Image
local View = Foundation.View
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local UserLib = require(CurrencyTransfersParent.UserLib)
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local Size100x100 = Enum.ThumbnailSize.Size100x100

local function UserProfileThumbnail(t1: {[any]: any}) -- line: 32
	-- upvalues: useTokens (copy), Size100x100 (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), React (copy), View (copy), FoundationImage (copy), GetFFlagCurrencyTransferFlowUIImprovementFix (copy), FoundationText (copy)
	local v16 = useTokens()

	if not t1.thumbnailSize then
		t1.thumbnailSize = Size100x100
	end

	local v17 = if t1.thumbnailSize ~= Enum.ThumbnailSize.Size48x48 then t1.thumbnailSize ~= Enum.ThumbnailSize.Size60x60 and 150 or 60 else 48
	local v18 = getRbxthumbWithTypeSizeAndOptions(t1.userId, Constants.RbxthumbTypes.AvatarHeadShot, v17, true)
	local v19 = t1.size or UDim2.fromOffset(80, 80)

	return React.createElement(View, {
		tag = "col gap-xlarge auto-xy align-x-center align-y-center",
		LayoutOrder = t1.layoutOrder
	}, {
		AvatarContainer = React.createElement(View, {
			tag = "aspect-1-1 position-center-center anchor-center-center",
			Size = v19
		}, {
			AvatarImage = React.createElement(FoundationImage, {
				tag = "size-full aspect-1-1 radius-circle align-x-center align-y-center",
				Image = v18,
				backgroundStyle = v16.Color.Shift.Shift_300
			})
		}),
		NameContainer = if not t1.showUsername or not if not GetFFlagCurrencyTransferFlowUIImprovementFix() then t1.username else t1.username or t1.displayName then nil else React.createElement(View, {
			tag = "col auto-y align-x-center"
		}, {
			Name = React.createElement(FoundationText, {
				tag = "text-title-medium content-emphasis text-align-x-center",
				Text = if not GetFFlagCurrencyTransferFlowUIImprovementFix() then t1.username or "" else t1.displayName or (t1.username or "")
			})
		}),
		HandleContainer = if not GetFFlagCurrencyTransferFlowUIImprovementFix() then if not t1.displayName then nil else React.createElement(View, {
			tag = "col auto-y padding-bottom-medium",
			LayoutOrder = 3
		}, {
			Handle = React.createElement(FoundationText, {
				tag = "text-label-medium content-emphasis",
				Text = "@" .. t1.displayName
			})
		}) else if not t1.displayName or not t1.username then nil else React.createElement(View, {
			tag = "col auto-y padding-bottom-medium",
			LayoutOrder = 3
		}, {
			Handle = React.createElement(FoundationText, {
				tag = "text-label-medium content-emphasis",
				Text = "@" .. t1.username
			})
		})
	})
end

return UserProfileThumbnail
