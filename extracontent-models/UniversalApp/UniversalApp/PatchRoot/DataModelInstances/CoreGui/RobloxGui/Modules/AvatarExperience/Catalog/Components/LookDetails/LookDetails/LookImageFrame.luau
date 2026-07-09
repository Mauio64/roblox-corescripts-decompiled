local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local AvatarExperience = Modules.AvatarExperience
local Common = AvatarExperience.Common
local LookViewport = require(Modules.AvatarExperience.Common.Components.Looks.LookViewport)

require(Common.Types)

local LoadableImage = UIBlox.App.Loading.LoadableImage
local useStyle = UIBlox.Core.Style.useStyle
local ModerationStatusPill = require(AvatarExperience.Catalog.Components.LookDetails.LookDetails.ModerationStatusPill)
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local GetFFlagLooksAvatarPDPImageDimensions = require(Modules.AvatarExperience.Flags.GetFFlagLooksAvatarPDPImageDimensions)
local v16 = game:DefineFastFlag("AXLookDetailsThumbnailStretched", false)

local function LookImageFrame(t1: {[any]: any}) -- line: 45
	-- upvalues: useStyle (copy), FFlagRenameDeprecatedUIBloxTokens (copy), GetFFlagLooksAvatarPDPImageDimensions (copy), getRbxthumbWithTypeSizeAndOptions (copy), React (copy), Roact (copy), LookViewport (copy), LoadableImage (copy), v16 (copy), ModerationStatusPill (copy)
	local v19 = useStyle()
	local Theme = v19.Theme
	local v21 = if not FFlagRenameDeprecatedUIBloxTokens then v19.Tokens.Global.Space_300 else v19.Tokens.Size.Size_600
	local v22 = if not GetFFlagLooksAvatarPDPImageDimensions() then t1.width * 9 / 16 else nil
	local lookId = t1.lookId
	local v24 = getRbxthumbWithTypeSizeAndOptions(lookId, "Look", 420)
	local v25 = t1.lookDetails and t1.lookDetails.displayProperties
	local v26 = if not t1.lookDetails then nil else t1.lookDetails.moderationStatus
	local v27 = if not v25 or (v25.backgroundType ~= "Hex" or not v25.backgroundValue) then Theme.PlaceHolder.Color else Color3.fromHex(v25.backgroundValue)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		ZIndex = 0,
		Size = if not GetFFlagLooksAvatarPDPImageDimensions() then UDim2.new(1, 0, 0, v22) else UDim2.new(1, 0, 1, 0),
		SizeConstraint = if not GetFFlagLooksAvatarPDPImageDimensions() then nil else Enum.SizeConstraint.RelativeXY
	}, {
		AspectRatio = if not GetFFlagLooksAvatarPDPImageDimensions() then nil else React.createElement("UIAspectRatioConstraint", {
			AspectRatio = 1.5
		}),
		ItemBackground = Roact.createElement("Frame", {
			ZIndex = 0,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.new(1, if not GetFFlagLooksAvatarPDPImageDimensions() then v21 * 2 else 0, 1, 0),
			BackgroundColor3 = v27,
			BackgroundTransparency = Theme.PlaceHolder.Transparency
		}),
		LookViewport = t1.renderViewport and React.createElement(LookViewport, {
			lookDetails = t1.lookDetails
		}),
		Image = if GetFFlagLooksAvatarPDPImageDimensions() or t1.renderViewport then nil else Roact.createElement(LoadableImage, {
			BackgroundTransparency = 1,
			useShimmerAnimationWhileLoading = true,
			Image = v24,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.fromOffset(v22, v22),
			ScaleType = if not v16 then nil else Enum.ScaleType.Fit
		}),
		ImageFrame = if not GetFFlagLooksAvatarPDPImageDimensions() or t1.renderViewport then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0)
		}, {
			AspectRatio = React.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1
			}),
			Image = Roact.createElement(LoadableImage, {
				BackgroundTransparency = 1,
				useShimmerAnimationWhileLoading = true,
				Image = v24,
				Size = UDim2.new(1, 0, 1, 0),
				ScaleType = if not v16 then nil else Enum.ScaleType.Fit
			})
		}),
		ModerationStatus = Roact.createElement(ModerationStatusPill, {
			moderationStatus = v26
		})
	})
end

return LookImageFrame
