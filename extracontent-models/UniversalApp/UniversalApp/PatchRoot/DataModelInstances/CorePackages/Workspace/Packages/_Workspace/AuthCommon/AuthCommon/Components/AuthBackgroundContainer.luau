local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local React = require(AuthCommonParent.React)
local Foundation = require(AuthCommonParent.Foundation)
local Background2026 = require(AuthCommon.Common.AuthBackgroundConstants).Background2026

local function renderScrim(n1: number) -- line: 43
	-- upvalues: React (copy)
	return React.createElement("ImageLabel", {
		ZIndex = 2,
		BorderSizePixel = 0,
		Image = "",
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = n1
	})
end
local function renderImage(s1: string) -- line: 56
	-- upvalues: React (copy), Foundation (copy)
	return React.createElement(Foundation.Image, {
		BorderSizePixel = 0,
		Image = s1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		ScaleType = Enum.ScaleType.Crop
	})
end
local function AuthBackgroundContainer(t1: {[any]: any}) -- line: 67
	-- upvalues: Background2026 (copy), React (copy), renderImage (copy), renderScrim (copy)
	local v12 = Background2026.SCRIM_TRANSPARENCY < 1
	local v13 = t1.showImage == nil or t1.showImage

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = not v13 and 0 or 1,
		BackgroundColor3 = t1.fallbackBackgroundColor
	}, {
		Background = if not v13 then nil else renderImage(Background2026.IMAGE),
		Scrim = if not v13 or not v12 then nil else renderScrim(Background2026.SCRIM_TRANSPARENCY)
	})
end

return AuthBackgroundContainer
