local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local Constants = require(Modules.Settings.Pages.ShareGame.Constants)
local Constants2 = require(CorePackages.Workspace.Packages.UserLib).Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = require(CorePackages.Workspace.Packages.UserLib).Utils.getRbxthumbWithTypeSizeAndOptions
local GRAY3 = Constants.Color.GRAY3
local InviteAvatarThumbnailSize = Constants.InviteAvatarThumbnailSize
local t1 = {
	[1] = {{
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		FrameSize = UDim2.new(1, 0, 1, 0),
		FramePosition = UDim2.new(0, 0, 0, 0)
	}},
	[2] = {
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
	[3] = {
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
	[4] = {
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
local v10 = Roact.PureComponent:extend("ConversationThumbnail")

function v10.render(p1) -- line: 113
	-- upvalues: t1 (copy), Constants2 (copy), InviteAvatarThumbnailSize (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), Roact (copy), GRAY3 (copy)
	local size = p1.props.size
	local layoutOrder = p1.props.layoutOrder
	local zIndex = p1.props.zIndex
	local users = p1.props.users
	local v16 = #users
	local t2 = {}

	for i, v in ipairs(users) do
		local v20 = t1[v16][i]
		local v21 = nil

		if v then
			local v22 = Constants2.RbxThumbnailSizeToNumberSize[InviteAvatarThumbnailSize]

			v21 = getRbxthumbWithTypeSizeAndOptions(v.id, Constants.InviteAvatarRbxthumbType, v22)
		end

		if not v21 then
			v21 = "rbxasset://textures/ui/LuaApp/graphic/ph-avatar-portrait.png"
		end

		t2["AvatarHolder-" .. i] = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Size = v20.FrameSize,
			Position = v20.FramePosition,
			ZIndex = zIndex
		}, {
			Avatar = Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Size = v20.Size,
				Position = v20.Position,
				Image = v21,
				ZIndex = zIndex
			})
		})

		if v20.Border then
			t2["Border-" .. i] = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = v20.Border.BorderSize,
				Position = v20.Border.BorderPosition,
				BackgroundColor3 = GRAY3,
				ZIndex = zIndex
			})
		end
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = size,
		LayoutOrder = layoutOrder,
		ZIndex = zIndex
	}, {
		ContentsContainer = Roact.createElement("Frame", {
			BackgroundTransparency = 0,
			BorderSizePixel = 1,
			Size = UDim2.new(1, -1, 1, -1),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundColor3 = Constants.Color.WHITE,
			BorderColor3 = GRAY3,
			ZIndex = zIndex
		}, t2)
	})
end

return v10
