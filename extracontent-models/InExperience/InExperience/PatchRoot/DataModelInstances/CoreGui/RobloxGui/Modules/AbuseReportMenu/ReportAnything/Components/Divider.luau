local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local withStyle = UIBlox.Core.Style.withStyle

local function Divider(t1: {[any]: any}) -- line: 17
	-- upvalues: withStyle (copy), React (copy), Cryo (copy)
	return withStyle(function(p1) -- line: 18
		-- upvalues: React (copy), Cryo (copy), t1 (copy)
		return React.createElement("Frame", Cryo.Dictionary.join({
			Size = UDim2.new(1, 0, 0, 1)
		}, t1, {
			BorderSizePixel = 0,
			BackgroundColor3 = p1.Theme.Divider.Color,
			BackgroundTransparency = p1.Theme.Divider.Transparency
		}))
	end)
end

return Divider
