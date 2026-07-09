local ParentParent = script.Parent.Parent
local createSignal = require(ParentParent.Misc.createSignal)
local strict = require(ParentParent.strict)

local function makeImageData(p1, p2) -- line: 7
	return {
		Path = "rbxasset://textures/" .. p1,
		SliceCenter = p2
	}
end

local t1 = {
	__tostring = function() -- line: 15
		return "Service(LayoutValues)"
	end
}

function t1.new(p3) -- line: 19
	-- upvalues: t1 (copy), createSignal (copy)
	local t2 = {}

	setmetatable(t2, {
		__index = t1
	})
	t2.signal = createSignal()
	t2.layout = t2:generate(p3)

	return t2
end
function t1.update(p4, p5) -- line: 31
	p4.layout = p4:generate(p5)
	p4.signal:fire(p4.layout)
end
function t1.generate(_, p7) -- line: 36
	-- upvalues: strict (copy)
	local v14 = not p7 and 1 or 3
	local v15 = 44 * v14
	local v16 = 30 * v14
	local v17 = 6 * v14
	local v18 = 16 * v14
	local v19 = 18 * v14
	local v20 = 210 * v14
	local v21 = 106 * v14
	local v22 = 96 * v14
	local v23 = 20 * v14
	local v24 = 25 * v14
	local v25 = 2 * v14
	local v26 = 64 * v14
	local v27 = 64 * v14
	local v28 = 3 * v14
	local v29 = 2 * v14
	local v30 = v26 + 2 * v25
	local v31 = v27 + 2 * v25
	local v32 = v30 + 2 * v24
	local v33 = v31 + 2 * v24
	local t3 = {
		AdditionalDetailsLabel = UDim2.new(1, 0, 0, v16),
		ItemPreview = UDim2.new(0, v26, 0, v27),
		ItemPreviewWhiteFrame = UDim2.new(0, v30, 0, v31),
		ItemPreviewContainerFrame = UDim2.new(0, v32, 0, v33),
		HorizontalPadding = v24,
		ProductDescription = UDim2.new(0, v20, 0, v21),
		ProductDescriptionPaddingTop = v19,
		RobuxIconContainerFrame = UDim2.new(0, v18 + v17, 0, v18 + 2 * v17),
		RobuxIcon = UDim2.new(0, v18, 0, v18),
		PriceTextLabel = UDim2.new(0, v20 - (v18 + v17), 0, v18),
		PurchasingAnimation = UDim2.new(0, v22, 0, v23),
		ButtonIconPadding = v28,
		ButtonIconYOffset = v29,
		ButtonHeight = v15,
		Dialog = UDim2.new(0, v32 + v20, 0, math.max(v33, v21) + v16 + v15)
	}
	local t4 = {
		Default = 18 * v14,
		ProductDescription = 18 * v14,
		Button = 24 * v14,
		AdditionalDetails = 14 * v14,
		Purchasing = 36 * v14
	}
	local t5 = {
		PriceLabel = Color3.new(1, 1, 1)
	}
	local t6 = {}
	local g40 = nil
	local t7 = nil
	local g44 = nil
	local t8 = nil
	local g48 = nil
	local t9 = nil
	local g52 = nil
	local t10 = nil
	local g56 = nil
	local t11 = nil
	local g60 = nil
	local t12 = nil
	local g64 = nil
	local t13 = nil
	local g68 = nil
	local t14 = nil

	if p7 then
		local rect = Rect.new(17, 17, 19, 19)

		t7 = {
			Path = "rbxasset://textures/ui/PurchasePrompt/PurchasePromptBG@2x.png",
			SliceCenter = rect
		}

		if t7 then
			g40 = true
		end
	end

	if not g40 then
		local rect = Rect.new(8, 9, 10, 10)

		t7 = {
			Path = "rbxasset://textures/ui/PurchasePrompt/PurchasePromptBG.png",
			SliceCenter = rect
		}
	end

	g40 = false
	t6.PromptBackground = t7

	if p7 then
		local rect = Rect.new(17, 17, 19, 19)

		t8 = {
			Path = "rbxasset://textures/ui/PurchasePrompt/LoadingBG@2x.png",
			SliceCenter = rect
		}

		if t8 then
			g44 = true
		end
	end

	if not g44 then
		local rect = Rect.new(9, 9, 11, 11)

		t8 = {
			Path = "rbxasset://textures/ui/PurchasePrompt/LoadingBG.png",
			SliceCenter = rect
		}
	end

	g44 = false
	t6.InProgressBackground = t8

	if p7 then
		local rect = Rect.new(18, 5, 20, 7)

		t9 = {
			Path = "rbxasset://textures/ui/PurchasePrompt/LeftButton@2x.png",
			SliceCenter = rect
		}

		if t9 then
			g48 = true
		end
	end

	if not g48 then
		local rect = Rect.new(8, 3, 10, 4)

		t9 = {
			Path = "rbxasset://textures/ui/PurchasePrompt/LeftButton.png",
			SliceCenter = rect
		}
	end

	g48 = false
	t6.ButtonUpLeft = t9

	if p7 then
		local rect = Rect.new(18, 5, 20, 7)

		t10 = {
			Path = "rbxasset://textures/ui/PurchasePrompt/LeftButtonDown@2x.png",
			SliceCenter = rect
		}

		if t10 then
			g52 = true
		end
	end

	if not g52 then
		local rect = Rect.new(8, 3, 10, 4)

		t10 = {
			Path = "rbxasset://textures/ui/PurchasePrompt/LeftButtonDown.png",
			SliceCenter = rect
		}
	end

	g52 = false
	t6.ButtonDownLeft = t10

	if p7 then
		local rect = Rect.new(3, 5, 5, 7)

		t11 = {
			Path = "rbxasset://textures/ui/PurchasePrompt/RightButton@2x.png",
			SliceCenter = rect
		}

		if t11 then
			g56 = true
		end
	end

	if not g56 then
		local rect = Rect.new(2, 3, 3, 4)

		t11 = {
			Path = "rbxasset://textures/ui/PurchasePrompt/RightButton.png",
			SliceCenter = rect
		}
	end

	g56 = false
	t6.ButtonUpRight = t11

	if p7 then
		local rect = Rect.new(3, 5, 5, 7)

		t12 = {
			Path = "rbxasset://textures/ui/PurchasePrompt/RightButtonDown@2x.png",
			SliceCenter = rect
		}

		if t12 then
			g60 = true
		end
	end

	if not g60 then
		local rect = Rect.new(2, 3, 3, 4)

		t12 = {
			Path = "rbxasset://textures/ui/PurchasePrompt/RightButtonDown.png",
			SliceCenter = rect
		}
	end

	g60 = false
	t6.ButtonDownRight = t12

	if p7 then
		local rect = Rect.new(18, 5, 20, 7)

		t13 = {
			Path = "rbxasset://textures/ui/PurchasePrompt/SingleButton@2x.png",
			SliceCenter = rect
		}

		if t13 then
			g64 = true
		end
	end

	if not g64 then
		local rect = Rect.new(8, 3, 10, 4)

		t13 = {
			Path = "rbxasset://textures/ui/PurchasePrompt/SingleButton.png",
			SliceCenter = rect
		}
	end

	g64 = false
	t6.ButtonUp = t13

	if p7 then
		local rect = Rect.new(18, 5, 20, 7)

		t14 = {
			Path = "rbxasset://textures/ui/PurchasePrompt/SingleButtonDown@2x.png",
			SliceCenter = rect
		}

		if t14 then
			g68 = true
		end
	end

	if not g68 then
		local rect = Rect.new(8, 3, 10, 4)

		t14 = {
			Path = "rbxasset://textures/ui/PurchasePrompt/SingleButtonDown.png",
			SliceCenter = rect
		}
	end

	g68 = false
	t6.ButtonDown = t14
	t6.PremiumIcon = {
		Path = "rbxasset://textures/ui/PurchasePrompt/Premium.png",
		SliceCenter = nil
	}
	t6.RobuxIcon = p7 and {
		Path = "rbxasset://textures/ui/common/robux_small@2x.png",
		SliceCenter = nil
	} or {
		Path = "rbxasset://textures/ui/common/robux_small.png",
		SliceCenter = nil
	}
	t6.ErrorIcon = p7 and {
		Path = "rbxasset://textures/ui/ErrorIcon.png",
		SliceCenter = nil
	} or {
		Path = "rbxasset://textures/ui/ErrorIcon.png",
		SliceCenter = nil
	}
	t6.ButtonA = p7 and {
		Path = "rbxasset://textures/ui/Settings/Help/AButtonDark@2x.png",
		SliceCenter = nil
	} or {
		Path = "rbxasset://textures/ui/Settings/Help/AButtonDark.png",
		SliceCenter = nil
	}
	t6.ButtonB = p7 and {
		Path = "rbxasset://textures/ui/Settings/Help/BButtonDark@2x.png",
		SliceCenter = nil
	} or {
		Path = "rbxasset://textures/ui/Settings/Help/BButtonDark.png",
		SliceCenter = nil
	}

	return (strict({
		Size = strict(t3, "LayoutValues.Size"),
		TextSize = strict(t4, "LayoutValues.TextSize"),
		TextColor = strict(t5, "LayoutValues.TextColor"),
		Image = strict(t6, "LayoutValues.Image")
	}, "LayoutValues"))
end

return t1
