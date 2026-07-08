local EditProfileBackground = script:FindFirstAncestor("EditProfileBackground")
local EditProfileBackgroundParent = EditProfileBackground.Parent
local React = require(EditProfileBackgroundParent.React)
local Image = require(EditProfileBackgroundParent.Foundation).Image
local useSelectedTheme = require(EditProfileBackgroundParent.RoactUtils).Hooks.useSelectedTheme
local Constants = require(EditProfileBackground.Common.Constants)
local v7 = Constants.BACKGROUND_ASSET_IDS[1]
local color3 = Color3.fromRGB(255, 255, 255)
local color3_2 = Color3.fromRGB(0, 0, 0)
local color3_3 = Color3.fromRGB(80, 80, 80)
local color3_4 = Color3.fromRGB(30, 38, 58)
local color3_5 = Color3.fromRGB(156, 178, 196)
local t1 = {
	[Constants.BACKGROUND_ASSET_IDS[2]] = Color3.fromRGB(255, 242, 216),
	[Constants.BACKGROUND_ASSET_IDS[3]] = Color3.fromRGB(254, 244, 194),
	[Constants.BACKGROUND_ASSET_IDS[4]] = Color3.fromRGB(238, 246, 216),
	[Constants.BACKGROUND_ASSET_IDS[5]] = Color3.fromRGB(214, 254, 202),
	[Constants.BACKGROUND_ASSET_IDS[6]] = Color3.fromRGB(192, 255, 226),
	[Constants.BACKGROUND_ASSET_IDS[7]] = Color3.fromRGB(208, 252, 255),
	[Constants.BACKGROUND_ASSET_IDS[8]] = Color3.fromRGB(238, 244, 255)
}

local function getButtonColor(n1: number, s1: string) -- line: 38
	-- upvalues: v7 (copy), color3_4 (copy), color3_5 (copy), t1 (copy)
	if n1 == v7 then
		if s1 == "dark" then
			return color3_4
		end

		return color3_5
	end

	return t1[n1]
end
local function ProfileBackgroundButton(t2: {[any]: any}) -- line: 53
	-- upvalues: useSelectedTheme (copy), React (copy), v7 (copy), color3_4 (copy), color3_5 (copy), t1 (copy), color3 (copy), color3_2 (copy), color3_3 (copy), Image (copy)
	local buttonSize = t2.buttonSize
	local v20 = useSelectedTheme()
	local v21 = React.useCallback(function() -- line: 57
		-- upvalues: t2 (copy)
		if t2.selected then
			return
		end

		if t2.onActivated then
			t2.onActivated(t2.profileBackgroundId)
		end
	end, {
		t2.onActivated,
		t2.selected,
		t2.profileBackgroundId
	})
	local v22 = math.floor(buttonSize * 0.4)
	local profileBackgroundId = t2.profileBackgroundId
	local v24 = if profileBackgroundId ~= v7 then t1[profileBackgroundId] else if v20 ~= "dark" then color3_5 else color3_4

	return React.createElement("ImageButton", {
		Size = UDim2.new(0, buttonSize, 0, buttonSize),
		BackgroundTransparency = 0,
		BackgroundColor3 = v24,
		BorderSizePixel = not t2.selected and 0 or 3,
		BorderColor3 = if not t2.selected then color3_2 else color3,
		LayoutOrder = t2.LayoutOrder,
		[React.Event.Activated] = v21
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0.5, 0)
		}),
		Overlay = t2.selected and React.createElement("Frame", {
			BackgroundTransparency = 0.5,
			ZIndex = 2,
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = color3_3,
			Size = UDim2.fromScale(0.8, 0.8)
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.5, 0)
			})
		}) or nil,
		Checkmark = t2.selected and React.createElement(Image, {
			tag = "position-center-center anchor-center-center",
			Image = "rbxassetid://6031094667",
			ZIndex = 3,
			Size = UDim2.fromOffset(v22, v22)
		}) or nil
	})
end

return ProfileBackgroundButton
