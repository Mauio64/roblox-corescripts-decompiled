local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local Constants = require(Modules.Settings.Pages.ShareGame.Constants)
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local constants = UserLib.Utils.Constants

local UserLib2 = require(CorePackages.Workspace.Packages.UserLib)
local getRbxthumbWithTypeSizeAndOptions = UserLib2.Utils.getRbxthumbWithTypeSizeAndOptions

local GRAY3 = Constants.Color.GRAY3

local InviteAvatarThumbnailSize = Constants.InviteAvatarThumbnailSize

local v = {
	{
		{
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			FrameSize = UDim2.new(1, 0, 1, 0),
			FramePosition = UDim2.new(0, 0, 0, 0)
		}
	},
	{
		{
			Size = UDim2.new(2, 0, 1, 0),
			Position = UDim2.new(-0.5, 0, 0, 0),
			FrameSize = UDim2.new(0.5, -1, 1, 0),
			FramePosition = UDim2.new(0, 0, 0, 0),
			Border = {
				BorderPosition = UDim2.new(0.5, -1, 0, 0),
				BorderSize = UDim2.new(0, 1, 1, 0)
			}
		},
		{
			Size = UDim2.new(2, 0, 1, 0),
			Position = UDim2.new(-0.5, 0, 0, 0),
			FrameSize = UDim2.new(0.5, -1, 1, 0),
			FramePosition = UDim2.new(0.5, 1, 0, 0)
		}
	},
	{
		{
			Size = UDim2.new(2, 0, 1, 0),
			Position = UDim2.new(-0.5, 0, 0, 0),
			FrameSize = UDim2.new(0.5, -1, 1, 0),
			FramePosition = UDim2.new(0, 0, 0, 0),
			Border = {
				BorderPosition = UDim2.new(0.5, -1, 0, 0),
				BorderSize = UDim2.new(0, 1, 1, 0)
			}
		},
		{
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			FrameSize = UDim2.new(0.5, -1, 0.5, -1),
			FramePosition = UDim2.new(0.5, 1, 0, 0),
			Border = {
				BorderPosition = UDim2.new(0.5, 0, 0.5, -1),
				BorderSize = UDim2.new(0.5, 0, 0, 1)
			}
		},
		{
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			FrameSize = UDim2.new(0.5, -1, 0.5, -1),
			FramePosition = UDim2.new(0.5, 1, 0.5, 1)
		}
	},
	{
		{
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			FrameSize = UDim2.new(0.5, -1, 0.5, -1),
			FramePosition = UDim2.new(0, 0, 0, 0),
			Border = {
				BorderPosition = UDim2.new(0, 0, 0.5, -1),
				BorderSize = UDim2.new(1, 0, 0, 1)
			}
		},
		{
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			FrameSize = UDim2.new(0.5, -1, 0.5, -1),
			FramePosition = UDim2.new(0.5, 1, 0, 0)
		},
		{
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			FrameSize = UDim2.new(0.5, -1, 0.5, -1),
			FramePosition = UDim2.new(0, 0, 0.5, 1),
			Border = {
				BorderPosition = UDim2.new(0.5, -1, 0, 0),
				BorderSize = UDim2.new(0, 1, 1, 0)
			}
		},
		{
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			FrameSize = UDim2.new(0.5, -1, 0.5, -1),
			FramePosition = UDim2.new(0.5, 1, 0.5, 1)
		}
	}
}

local extended = Roact.PureComponent:extend("ConversationThumbnail")

function extended.render(p)
	local size = p.props.size
	local layoutOrder = p.props.layoutOrder
	local zIndex = p.props.zIndex
	local users = p.props.users
	local v2 = #users

	local children = {}

	for i, user in ipairs(users) do
		local v3 = v[v2][i]
		local v4

		if user then
			local v5 = constants.RbxThumbnailSizeToNumberSize[InviteAvatarThumbnailSize]
			v4 = getRbxthumbWithTypeSizeAndOptions(user.id, Constants.InviteAvatarRbxthumbType, v5)
		end

		children["AvatarHolder-" .. i] = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Size = v3.FrameSize,
			Position = v3.FramePosition,
			ZIndex = zIndex
		}, {
			Avatar = Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Size = v3.Size,
				Position = v3.Position,
				Image = v4 or "rbxasset://textures/ui/LuaApp/graphic/ph-avatar-portrait.png",
				ZIndex = zIndex
			})
		})

		if v3.Border then
			children["Border-" .. i] = Roact.createElement("Frame", {
				Size = v3.Border.BorderSize,
				Position = v3.Border.BorderPosition,
				BorderSizePixel = 0,
				BackgroundColor3 = GRAY3,
				ZIndex = zIndex
			})
		end
	end

	return Roact.createElement(
		"Frame",
		{ BackgroundTransparency = 1, Size = size, LayoutOrder = layoutOrder, ZIndex = zIndex },
		{
			ContentsContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 0,
				Size = UDim2.new(1, -1, 1, -1),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				BackgroundColor3 = Constants.Color.WHITE,
				BorderColor3 = GRAY3,
				BorderSizePixel = 1,
				ZIndex = zIndex
			}, children)
		}
	)
end

return extended
