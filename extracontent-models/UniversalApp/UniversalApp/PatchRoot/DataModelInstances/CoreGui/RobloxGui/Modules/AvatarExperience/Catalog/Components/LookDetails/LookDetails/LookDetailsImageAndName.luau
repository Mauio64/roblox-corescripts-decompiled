local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local AvatarExperience = Modules.AvatarExperience
local Common = AvatarExperience.Common

require(Common.Types)

local LookImageFrame = require(AvatarExperience.Catalog.Components.LookDetails.LookDetails.LookImageFrame)
local FitFrameVertical = AvatarExperienceDeps.RoactFitComponents.FitFrameVertical
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local Skeleton = Foundation.Skeleton
local useStyle = UIBlox.Core.Style.useStyle
local GetFFlagLooksAvatarPDPImageDimensions = require(Modules.AvatarExperience.Flags.GetFFlagLooksAvatarPDPImageDimensions)

local function LookDetailsImageAndName(t1: {[any]: any}) -- line: 42
	-- upvalues: useStyle (copy), FFlagRenameDeprecatedUIBloxTokens (copy), React (copy), FitFrameVertical (copy), LookImageFrame (copy), GetFFlagLooksAvatarPDPImageDimensions (copy), Skeleton (copy)
	local v17 = useStyle()
	local Theme = v17.Theme
	local Font = v17.Font
	local v20 = if not FFlagRenameDeprecatedUIBloxTokens then v17.Tokens.Global.Space_150 else v17.Tokens.Size.Size_300
	local Header2Font = Font.Header2.Font
	local v22 = Font.BaseSize * Font.Header2.RelativeSize
	local name = t1.name
	local isLoading = t1.isLoading

	return React.createElement(FitFrameVertical, {
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		width = UDim.new(1, 0),
		contentPadding = UDim.new(0, v20),
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center
	}, {
		LookImageFrame = React.createElement(LookImageFrame, {
			width = if not GetFFlagLooksAvatarPDPImageDimensions() then t1.width else nil,
			lookId = t1.lookId,
			lookDetails = t1.lookDetails,
			renderViewport = t1.renderViewport
		}),
		LookNameContainer = if not GetFFlagLooksAvatarPDPImageDimensions() or not isLoading and not name then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, t1.innerPadding),
				PaddingRight = UDim.new(0, t1.innerPadding)
			}),
			LookName = if not isLoading then React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				Size = UDim2.new(0, 0, 0, 0),
				Text = name,
				TextTruncate = Enum.TextTruncate.AtEnd,
				AutomaticSize = Enum.AutomaticSize.XY,
				Font = Header2Font,
				TextSize = v22,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = Theme.TextEmphasis.Color
			}) else React.createElement(Skeleton, {
				Size = UDim2.new(1, 0, 0, v22)
			})
		}),
		LookName = if not GetFFlagLooksAvatarPDPImageDimensions() then if not isLoading then if not name then nil else React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = true,
			LayoutOrder = 2,
			Size = UDim2.new(0, 0, 0, 0),
			Text = name,
			TextTruncate = Enum.TextTruncate.AtEnd,
			AutomaticSize = Enum.AutomaticSize.XY,
			Font = Header2Font,
			TextSize = v22,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = Theme.TextEmphasis.Color
		}) or React.createElement(Skeleton, {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v22)
		}) else React.createElement(Skeleton, {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v22)
		}) else nil
	})
end

return LookDetailsImageAndName
