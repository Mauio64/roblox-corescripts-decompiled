local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local Common = Modules.AvatarExperience.Common

require(Common.Types)

local LoadableImage = UIBlox.App.Loading.LoadableImage
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

local function CommunityAvatarLookImageFrame(t1: {[any]: any}) -- line: 30
	-- upvalues: getRbxthumbWithTypeSizeAndOptions (copy), React (copy), Roact (copy), LoadableImage (copy)
	local lookId = t1.lookId
	local size = t1.size
	local layoutOrder = t1.layoutOrder
	local v15 = getRbxthumbWithTypeSizeAndOptions(lookId, "Look", 420)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 0,
		Size = UDim2.new(1, 0, 0, size),
		SizeConstraint = Enum.SizeConstraint.RelativeXY,
		LayoutOrder = layoutOrder
	}, {
		CommunityAvatarImage = Roact.createElement(LoadableImage, {
			BackgroundTransparency = 1,
			useShimmerAnimationWhileLoading = true,
			Image = v15,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.fromOffset(size, size)
		})
	})
end

return CommunityAvatarLookImageFrame
