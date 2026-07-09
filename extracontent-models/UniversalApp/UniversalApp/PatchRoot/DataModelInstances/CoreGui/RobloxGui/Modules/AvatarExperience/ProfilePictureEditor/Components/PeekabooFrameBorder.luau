local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local Constants = require(Modules.AvatarExperience.ProfilePictureEditor.Constants)
local v7 = Roact.PureComponent:extend("PeekabooFrameBorder")

v7.validateProps = t.strictInterface({})

function v7.render(_) -- line: 22
	-- upvalues: withStyle (copy), Roact (copy), Constants (copy)
	return withStyle(function(p2) -- line: 23
		-- upvalues: Roact (copy), Constants (copy)
		local Theme = p2.Theme

		return Roact.createFragment({
			TopBorder = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 2,
				BackgroundColor3 = Theme.Divider.Color,
				Size = UDim2.new(1, 0, 0, Constants.PeekabooBorderWidthPix),
				Position = UDim2.fromOffset(0, 0)
			}),
			LeftBorder = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 2,
				BackgroundColor3 = Theme.Divider.Color,
				Size = UDim2.new(0, Constants.PeekabooBorderWidthPix, 1, 0),
				Position = UDim2.fromOffset(0, 0)
			}),
			RightBorder = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 2,
				BackgroundColor3 = Theme.Divider.Color,
				AnchorPoint = Vector2.new(1, 0),
				Size = UDim2.new(0, Constants.PeekabooBorderWidthPix, 1, 0),
				Position = UDim2.fromScale(1, 0)
			}),
			BottomBorder = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 2,
				BackgroundColor3 = Theme.Divider.Color,
				AnchorPoint = Vector2.new(0, 1),
				Size = UDim2.new(1, 0, 0, Constants.PeekabooBorderWidthPix),
				Position = UDim2.fromScale(0, 1)
			})
		})
	end)
end

return v7
