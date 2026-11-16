local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Cryo")
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Loggers").Logger
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox")

local core = UIBlox.Core
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = core.Style.useStyle

local v5 = logger:new("ImagePile")

local function ImagePile(p2)
	local tokens = useStyle().Tokens

	local v6 = React.useMemo(function()
		return {
			imageBorderColor = tokens.Color.Extended.White.White_100.Color3,
			imageBorderThickness = tokens.Size.Size_50
		}
	end, { tokens })
	local union = Cryo.Dictionary.union(v6, p2)

	local v7 = React.useMemo(function()
		return {
			{
				Attribute1 = {
					AnchorPoint = Vector2.new(0, 0),
					Position = UDim2.fromScale(0, 0),
					Size = UDim2.fromOffset(tokens.Size.Size_1000, tokens.Size.Size_1000),
					ZIndex = 1
				}
			},
			{
				Attribute1 = {
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.fromScale(0, 1),
					Size = UDim2.fromOffset(tokens.Size.Size_700, tokens.Size.Size_700),
					ZIndex = 2
				},
				Attribute2 = {
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.fromScale(1, 0),
					Size = UDim2.fromOffset(tokens.Size.Size_700, tokens.Size.Size_700),
					ZIndex = 1
				}
			}
		}
	end, { tokens })

	local v8 = React.useCallback(function(p3, p4)
		return v7[math.min(p3, 2)]["Attribute" .. p4]
	end, { v7 })

	local v9 = React.useMemo(function()
		local children = {}

		for k, image in union.images do
			if k > 2 then
				v5:warning("More than 2 images provided but only the first 2 will be shown.")
				return children
			end

			local v10 = v8(#union.images, k)
			image.AnchorPoint = v10.AnchorPoint
			image.Position = v10.Position
			image.Size = v10.Size
			image.ZIndex = v10.ZIndex

			children[tostring(k)] = React.createElement(imageSetLabel, image, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				}),
				UIStroke = React.createElement("UIStroke", {
					Color = union.imageBorderColor,
					Thickness = union.imageBorderThickness,
					Transparency = 0
				})
			})
		end

		return children
	end, { union.images })

	if #union.images == 0 then
		v5:warning("Cannot have empty list of images")
		return nil
	end

	return React.createElement(
		"Frame",
		{
			[React.Tag] = "data-testid=ImagePile",
			BackgroundTransparency = 1,
			Name = "ImagePile",
			Size = UDim2.fromOffset(tokens.Size.Size_1000, tokens.Size.Size_1000)
		},
		v9
	)
end

return ImagePile
