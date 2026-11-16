local parent = script.Parent.Parent

local createSignal = require(parent.Misc.createSignal)
local strict = require(parent.strict)

local function makeImageData(p, sliceCenter)
	return {
		Path = "rbxasset://textures/" .. p,
		SliceCenter = sliceCenter
	}
end

local LayoutValues = {
	["__tostring"] = nil,
	["__tostring"] = nil,
	__tostring = function(): string
		return "Service(LayoutValues)"
	end
}

function LayoutValues.new(p)
	local class = {}
	setmetatable(class, { __index = LayoutValues })

	class.signal = createSignal()
	class.layout = class:generate(p)

	return class
end

function LayoutValues:update(p)
	self.layout = self:generate(p)
	self.signal:fire(self.layout)
end

function LayoutValues:generate(p)
	local v = p and 3 or 1
	local buttonHeight = 44 * v
	local v2 = 30 * v

	local v3 = 6 * v

	local v4 = 16 * v

	local productDescriptionPaddingTop = 18 * v
	local v5 = 210 * v
	local v6 = 106 * v

	local v7 = 96 * v
	local v8 = 20 * v

	local horizontalPadding = 25 * v
	local v9 = 2 * v
	local v10 = 64 * v
	local v11 = 64 * v

	local buttonIconPadding = 3 * v

	local buttonIconYOffset = 2 * v

	local v12 = v10 + 2 * v9
	local v13 = v11 + 2 * v9

	local v14 = v12 + 2 * horizontalPadding
	local v15 = v13 + 2 * horizontalPadding

	local v16 = {
		AdditionalDetailsLabel = UDim2.new(1, 0, 0, v2),
		ItemPreview = UDim2.new(0, v10, 0, v11),
		ItemPreviewWhiteFrame = UDim2.new(0, v12, 0, v13),
		ItemPreviewContainerFrame = UDim2.new(0, v14, 0, v15),
		HorizontalPadding = horizontalPadding,
		ProductDescription = UDim2.new(0, v5, 0, v6),
		ProductDescriptionPaddingTop = productDescriptionPaddingTop,
		RobuxIconContainerFrame = UDim2.new(0, v4 + v3, 0, v4 + 2 * v3),
		RobuxIcon = UDim2.new(0, v4, 0, v4),
		PriceTextLabel = UDim2.new(0, v5 - (v4 + v3), 0, v4),
		PurchasingAnimation = UDim2.new(0, v7, 0, v8),
		ButtonIconPadding = buttonIconPadding,
		ButtonIconYOffset = buttonIconYOffset,
		ButtonHeight = buttonHeight,
		Dialog = UDim2.new(0, v14 + v5, 0, math.max(v15, v6) + v2 + buttonHeight)
	}

	local v17 = {
		Default = 18 * v,
		ProductDescription = 18 * v,
		Button = 24 * v,
		AdditionalDetails = 14 * v,
		Purchasing = 36 * v
	}

	local v18 = { PriceLabel = Color3.new(1, 1, 1) }
	local v19 = {
		["PromptBackground"] = p and {
			Path = "rbxasset://textures/ui/PurchasePrompt/PurchasePromptBG@2x.png",
			SliceCenter = Rect.new(17, 17, 19, 19)
		} or {
			Path = "rbxasset://textures/ui/PurchasePrompt/PurchasePromptBG.png",
			SliceCenter = Rect.new(8, 9, 10, 10)
		},
		InProgressBackground = p and {
			Path = "rbxasset://textures/ui/PurchasePrompt/LoadingBG@2x.png",
			SliceCenter = Rect.new(17, 17, 19, 19)
		} or {
			Path = "rbxasset://textures/ui/PurchasePrompt/LoadingBG.png",
			SliceCenter = Rect.new(9, 9, 11, 11)
		},
		ButtonUpLeft = p and {
			Path = "rbxasset://textures/ui/PurchasePrompt/LeftButton@2x.png",
			SliceCenter = Rect.new(18, 5, 20, 7)
		} or {
			Path = "rbxasset://textures/ui/PurchasePrompt/LeftButton.png",
			SliceCenter = Rect.new(8, 3, 10, 4)
		},
		ButtonDownLeft = p and {
			Path = "rbxasset://textures/ui/PurchasePrompt/LeftButtonDown@2x.png",
			SliceCenter = Rect.new(18, 5, 20, 7)
		} or {
			Path = "rbxasset://textures/ui/PurchasePrompt/LeftButtonDown.png",
			SliceCenter = Rect.new(8, 3, 10, 4)
		},
		ButtonUpRight = p and {
			Path = "rbxasset://textures/ui/PurchasePrompt/RightButton@2x.png",
			SliceCenter = Rect.new(3, 5, 5, 7)
		} or {
			Path = "rbxasset://textures/ui/PurchasePrompt/RightButton.png",
			SliceCenter = Rect.new(2, 3, 3, 4)
		},
		ButtonDownRight = p and {
			Path = "rbxasset://textures/ui/PurchasePrompt/RightButtonDown@2x.png",
			SliceCenter = Rect.new(3, 5, 5, 7)
		} or {
			Path = "rbxasset://textures/ui/PurchasePrompt/RightButtonDown.png",
			SliceCenter = Rect.new(2, 3, 3, 4)
		},
		ButtonUp = p and {
			Path = "rbxasset://textures/ui/PurchasePrompt/SingleButton@2x.png",
			SliceCenter = Rect.new(18, 5, 20, 7)
		} or {
			Path = "rbxasset://textures/ui/PurchasePrompt/SingleButton.png",
			SliceCenter = Rect.new(8, 3, 10, 4)
		},
		ButtonDown = p and {
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
		RobuxIcon = p and {
			Path = "rbxasset://textures/ui/common/robux_small@2x.png",
			SliceCenter = nil
		} or { Path = "rbxasset://textures/ui/common/robux_small.png", SliceCenter = nil },
		ErrorIcon = p and { Path = "rbxasset://textures/ui/ErrorIcon.png", SliceCenter = nil } or {
			Path = "rbxasset://textures/ui/ErrorIcon.png",
			SliceCenter = nil
		},
		ButtonA = p and {
			Path = "rbxasset://textures/ui/Settings/Help/AButtonDark@2x.png",
			SliceCenter = nil
		} or { Path = "rbxasset://textures/ui/Settings/Help/AButtonDark.png", SliceCenter = nil },
		ButtonB = p and {
			Path = "rbxasset://textures/ui/Settings/Help/BButtonDark@2x.png",
			SliceCenter = nil
		} or { Path = "rbxasset://textures/ui/Settings/Help/BButtonDark.png", SliceCenter = nil }
	}

	return (strict(
		{
			Size = strict(v16, "LayoutValues.Size"),
			TextSize = strict(v17, "LayoutValues.TextSize"),
			TextColor = strict(v18, "LayoutValues.TextColor"),
			Image = strict(v19, "LayoutValues.Image")
		},
		"LayoutValues"
	))
end

return LayoutValues
