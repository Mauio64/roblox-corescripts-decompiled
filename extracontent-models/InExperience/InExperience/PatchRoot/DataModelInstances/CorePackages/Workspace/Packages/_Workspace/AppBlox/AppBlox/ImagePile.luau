local parent = script:FindFirstAncestor("AppBlox").Parent

local Cryo = require(parent.Cryo)
local Loggers = require(parent.Loggers)
local Logger = Loggers.Logger
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)

local Core = UIBlox.Core
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = Core.Style.useStyle

local v = Logger:new(script.Name)

local function ImagePile(p)
	local tokens = useStyle().Tokens

	local v2 = React.useMemo(function()
		return {
			imageBorderColor = tokens.Color.Extended.White.White_100.Color3,
			imageBorderThickness = tokens.Size.Size_50
		}
	end, { tokens })
	local union = Cryo.Dictionary.union(v2, p)

	local v3 = React.useMemo(function()
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

	local v4 = React.useCallback(function(p2: number, p3: number)
		return v3[math.min(p2, 2)]["Attribute" .. p3]
	end, { v3 })

	local v5 = React.useMemo(function()
		local children = {}

		for k, image in union.images do
			if k > 2 then
				v:warning("More than 2 images provided but only the first 2 will be shown.")
				return children
			end

			local v5 = v4(#union.images, k)
			image.AnchorPoint = v5.AnchorPoint
			image.Position = v5.Position
			image.Size = v5.Size
			image.ZIndex = v5.ZIndex

			children[tostring(k)] = React.createElement(ImageSetLabel, image, {
				UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
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
		v:warning("Cannot have empty list of images")
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
		v5
	)
end

return ImagePile
