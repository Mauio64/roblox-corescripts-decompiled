local createSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Misc/createSignal")
local strict = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/strict")

local function makeImageData(p2, p3)
	return {
		Path = "rbxasset://textures/" .. p2,
		SliceCenter = p3
	}
end

local v5 = {}
function v5.__tostring(): string
	return "Service(LayoutValues)"
end

function v5.new(p2)
	local class = {}
	setmetatable(class, { __index = v5 })

	class.signal = createSignal()
	class.layout = class:generate(p2)

	return class
end

function v5:update(p2)
	self.layout = self:generate(p2)
	self.signal:fire(self.layout)
end

function v5.generate(p2, p3)
	local v6 = p3 and 3 or 1
	local v7 = 44 * v6
	local v8 = 30 * v6

	local v9 = 6 * v6

	local v10 = 16 * v6

	local v11 = 18 * v6
	local v12 = 210 * v6
	local v13 = 106 * v6

	local v14 = 96 * v6
	local v15 = 20 * v6

	local v16 = 25 * v6
	local v17 = 2 * v6
	local v18 = 64 * v6
	local v19 = 64 * v6

	local v20 = 3 * v6

	local v21 = 2 * v6

	local v22 = v18 + 2 * v17
	local v23 = v19 + 2 * v17

	local v24 = v22 + 2 * v16
	local v25 = v23 + 2 * v16

	local v26 = {
		AdditionalDetailsLabel = UDim2.new(1, 0, 0, v8),
		ItemPreview = UDim2.new(0, v18, 0, v19),
		ItemPreviewWhiteFrame = UDim2.new(0, v22, 0, v23),
		ItemPreviewContainerFrame = UDim2.new(0, v24, 0, v25),
		HorizontalPadding = v16,
		ProductDescription = UDim2.new(0, v12, 0, v13),
		ProductDescriptionPaddingTop = v11,
		RobuxIconContainerFrame = UDim2.new(0, v10 + v9, 0, v10 + 2 * v9),
		RobuxIcon = UDim2.new(0, v10, 0, v10),
		PriceTextLabel = UDim2.new(0, v12 - (v10 + v9), 0, v10),
		PurchasingAnimation = UDim2.new(0, v14, 0, v15),
		ButtonIconPadding = v20,
		ButtonIconYOffset = v21,
		ButtonHeight = v7,
		Dialog = UDim2.new(0, v24 + v12, 0, math.max(v25, v13) + v8 + v7)
	}

	local v27 = {
		Default = 18 * v6,
		ProductDescription = 18 * v6,
		Button = 24 * v6,
		AdditionalDetails = 14 * v6,
		Purchasing = 36 * v6
	}

	local v28 = { PriceLabel = Color3.new(1, 1, 1) }
	local v29 = {
		["PromptBackground"] = p3 and {
			Path = "rbxasset://textures/ui/PurchasePrompt/PurchasePromptBG@2x.png",
			SliceCenter = Rect.new(17, 17, 19, 19)
		} or {
			Path = "rbxasset://textures/ui/PurchasePrompt/PurchasePromptBG.png",
			SliceCenter = Rect.new(8, 9, 10, 10)
		},
		InProgressBackground = p3 and {
			Path = "rbxasset://textures/ui/PurchasePrompt/LoadingBG@2x.png",
			SliceCenter = Rect.new(17, 17, 19, 19)
		} or {
			Path = "rbxasset://textures/ui/PurchasePrompt/LoadingBG.png",
			SliceCenter = Rect.new(9, 9, 11, 11)
		},
		ButtonUpLeft = p3 and {
			Path = "rbxasset://textures/ui/PurchasePrompt/LeftButton@2x.png",
			SliceCenter = Rect.new(18, 5, 20, 7)
		} or {
			Path = "rbxasset://textures/ui/PurchasePrompt/LeftButton.png",
			SliceCenter = Rect.new(8, 3, 10, 4)
		},
		ButtonDownLeft = p3 and {
			Path = "rbxasset://textures/ui/PurchasePrompt/LeftButtonDown@2x.png",
			SliceCenter = Rect.new(18, 5, 20, 7)
		} or {
			Path = "rbxasset://textures/ui/PurchasePrompt/LeftButtonDown.png",
			SliceCenter = Rect.new(8, 3, 10, 4)
		},
		ButtonUpRight = p3 and {
			Path = "rbxasset://textures/ui/PurchasePrompt/RightButton@2x.png",
			SliceCenter = Rect.new(3, 5, 5, 7)
		} or {
			Path = "rbxasset://textures/ui/PurchasePrompt/RightButton.png",
			SliceCenter = Rect.new(2, 3, 3, 4)
		},
		ButtonDownRight = p3 and {
			Path = "rbxasset://textures/ui/PurchasePrompt/RightButtonDown@2x.png",
			SliceCenter = Rect.new(3, 5, 5, 7)
		} or {
			Path = "rbxasset://textures/ui/PurchasePrompt/RightButtonDown.png",
			SliceCenter = Rect.new(2, 3, 3, 4)
		},
		ButtonUp = p3 and {
			Path = "rbxasset://textures/ui/PurchasePrompt/SingleButton@2x.png",
			SliceCenter = Rect.new(18, 5, 20, 7)
		} or {
			Path = "rbxasset://textures/ui/PurchasePrompt/SingleButton.png",
			SliceCenter = Rect.new(8, 3, 10, 4)
		},
		ButtonDown = p3 and {
			Path = "rbxasset://textures/ui/PurchasePrompt/SingleButtonDown@2x.png",
			SliceCenter = Rect.new(18, 5, 20, 7)
		} or {
			Path = "rbxasset://textures/ui/PurchasePrompt/SingleButtonDown.png",
			SliceCenter = Rect.new(8, 3, 10, 4)
		},
		PremiumIcon = {
			Path = "rbxasset://textures/ui/PurchasePrompt/Premium.png",
			SliceCenter = nil
		},
		RobuxIcon = p3 and {
			Path = "rbxasset://textures/ui/common/robux_small@2x.png",
			SliceCenter = nil
		} or {
			Path = "rbxasset://textures/ui/common/robux_small.png",
			SliceCenter = nil
		},
		ErrorIcon = p3 and {
			Path = "rbxasset://textures/ui/ErrorIcon.png",
			SliceCenter = nil
		} or { Path = "rbxasset://textures/ui/ErrorIcon.png", SliceCenter = nil },
		ButtonA = p3 and {
			Path = "rbxasset://textures/ui/Settings/Help/AButtonDark@2x.png",
			SliceCenter = nil
		} or {
			Path = "rbxasset://textures/ui/Settings/Help/AButtonDark.png",
			SliceCenter = nil
		},
		ButtonB = p3 and {
			Path = "rbxasset://textures/ui/Settings/Help/BButtonDark@2x.png",
			SliceCenter = nil
		} or {
			Path = "rbxasset://textures/ui/Settings/Help/BButtonDark.png",
			SliceCenter = nil
		}
	}

	return (strict(
		{
			Size = strict(v26, "LayoutValues.Size"),
			TextSize = strict(v27, "LayoutValues.TextSize"),
			TextColor = strict(v28, "LayoutValues.TextColor"),
			Image = strict(v29, "LayoutValues.Image")
		},
		"LayoutValues"
	))
end

return v5
