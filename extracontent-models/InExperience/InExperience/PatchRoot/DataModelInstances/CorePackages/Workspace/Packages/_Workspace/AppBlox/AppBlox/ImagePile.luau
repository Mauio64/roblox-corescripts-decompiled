local Parent = script:FindFirstAncestor("AppBlox").Parent
local Cryo = require(Parent.Cryo)
local Logger = require(Parent.Loggers).Logger
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local Core = UIBlox.Core
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = Core.Style.useStyle
local v9 = Logger:new(script.Name)

local function ImagePile(t1: {[any]: any}) -- line: 22
	-- upvalues: useStyle (copy), React (copy), Cryo (copy), v9 (copy), ImageSetLabel (copy)
	local Tokens = useStyle().Tokens
	local v13 = React.useMemo(function() -- line: 26
		-- upvalues: Tokens (copy)
		return {
			imageBorderColor = Tokens.Color.Extended.White.White_100.Color3,
			imageBorderThickness = Tokens.Size.Size_50
		}
	end, { Tokens })
	local v14 = Cryo.Dictionary.union(v13, t1)
	local v15 = React.useMemo(function() -- line: 35
		-- upvalues: Tokens (copy)
		return {
			[1] = {
				Attribute1 = {
					ZIndex = 1,
					AnchorPoint = Vector2.new(0, 0),
					Position = UDim2.fromScale(0, 0),
					Size = UDim2.fromOffset(Tokens.Size.Size_1000, Tokens.Size.Size_1000)
				}
			},
			[2] = {
				Attribute1 = {
					ZIndex = 2,
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.fromScale(0, 1),
					Size = UDim2.fromOffset(Tokens.Size.Size_700, Tokens.Size.Size_700)
				},
				Attribute2 = {
					ZIndex = 1,
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.fromScale(1, 0),
					Size = UDim2.fromOffset(Tokens.Size.Size_700, Tokens.Size.Size_700)
				}
			}
		}
	end, { Tokens })
	local v16 = React.useCallback(function(n1: number, n2: number) -- line: 62
		-- upvalues: v15 (copy)
		return v15[math.min(n1, 2)]["Attribute" .. n2]
	end, { v15 })
	local v17 = React.useMemo(function() -- line: 67
		-- upvalues: v14 (copy), v9 (copy), v16 (copy), React (copy), ImageSetLabel (copy)
		local t2 = {}

		for v21, v22 in v14.images do
			if v21 > 2 then
				v9:warning("More than 2 images provided but only the first 2 will be shown.")

				return t2
			end

			local v23 = v16(#v14.images, v21)

			v22.AnchorPoint = v23.AnchorPoint
			v22.Position = v23.Position
			v22.Size = v23.Size
			v22.ZIndex = v23.ZIndex
			t2[tostring(v21)] = React.createElement(ImageSetLabel, v22, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				}),
				UIStroke = React.createElement("UIStroke", {
					Transparency = 0,
					Color = v14.imageBorderColor,
					Thickness = v14.imageBorderThickness
				})
			})
		end

		return t2
	end, { v14.images })

	if #v14.images == 0 then
		v9:warning("Cannot have empty list of images")

		return nil
	end

	return React.createElement("Frame", {
		[React.Tag] = "data-testid=ImagePile",
		BackgroundTransparency = 1,
		Name = "ImagePile",
		Size = UDim2.fromOffset(Tokens.Size.Size_1000, Tokens.Size.Size_1000)
	}, v17)
end

return ImagePile
