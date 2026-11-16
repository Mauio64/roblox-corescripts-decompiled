local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/hSG")

local function DeviceInsetBackground(p2)
	local v5 = module(p2)

	if v5 == nil then
		return nil
	end

	return React.createElement("Frame", {
		Position = v5.position,
		Size = v5.size,
		BackgroundColor3 = v5.backgroundColor,
		BackgroundTransparency = v5.backgroundTransparency,
		BorderSizePixel = 0,
		ZIndex = 0
	})
end

return React.memo(DeviceInsetBackground)
