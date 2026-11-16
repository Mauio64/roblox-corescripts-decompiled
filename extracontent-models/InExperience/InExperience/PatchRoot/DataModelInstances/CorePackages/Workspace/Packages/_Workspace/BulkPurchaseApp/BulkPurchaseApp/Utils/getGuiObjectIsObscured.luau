local CoreGui = game:GetService("CoreGui")
local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local FIntAXGuiObjectIsObscuredPadding = require(BulkPurchaseApp.Flags.FIntAXGuiObjectIsObscuredPadding)
local SharedFlags = require(parent.SharedFlags)
local FFlagFixBulkPurchaseTopBarObfuscation = SharedFlags.FFlagFixBulkPurchaseTopBarObfuscation

local function isTransparentImageLabel(image)
	return FFlagFixBulkPurchaseTopBarObfuscation and image:IsA("ImageLabel") and image.ImageTransparency == 1
end

local function hasDefaultTransparency(guiObject) -- 1 equivalent call inferred from this helper
	local fFlagFixBulkPurchaseTopBarObfuscation = FFlagFixBulkPurchaseTopBarObfuscation

	if fFlagFixBulkPurchaseTopBarObfuscation then
		if guiObject.BackgroundTransparency == 0 then
			return guiObject:HasTag("gui-object-defaults") and not guiObject:HasTag("x-default-transparency")
		end

		return false
	end

	return fFlagFixBulkPurchaseTopBarObfuscation
end

local function getGuiObjectIsObscuredAtPosition(ancestor, p: number, p2: number): boolean
	local guiObjectsAtPosition = CoreGui:GetGuiObjectsAtPosition(p, p2)

	for _, guiObject in guiObjectsAtPosition do
		if
			(guiObject:IsA("Frame") or FFlagFixBulkPurchaseTopBarObfuscation and guiObject:IsA("ImageLabel") and guiObject.ImageTransparency == 1)
			and guiObject.Active == false
		then
			if guiObject.BackgroundTransparency == 1 or hasDefaultTransparency(guiObject) then -- inferred equivalent call
				continue
			end
		end

		if not guiObject:IsDescendantOf(ancestor) then
			return guiObject ~= ancestor
		end
	end

	return false
end

local function getGuiObjectIsObscured(p)
	local absolutePosition = p.AbsolutePosition
	local absoluteSize = p.AbsoluteSize
	local v = absolutePosition + absoluteSize * 0.5

	local v2 = absolutePosition + absoluteSize
	local v3 = absolutePosition + Vector2.new(absoluteSize.X, 0)
	local v4 = absolutePosition + Vector2.new(0, absoluteSize.Y)
	local v5 = absolutePosition + absoluteSize * Vector2.new(math.random(1, 9) / 10, math.random(1, 9) / 10)
	return getGuiObjectIsObscuredAtPosition(p, v.X, v.Y)
		or getGuiObjectIsObscuredAtPosition(
			p,
			absolutePosition.X + FIntAXGuiObjectIsObscuredPadding,
			absolutePosition.Y + FIntAXGuiObjectIsObscuredPadding
		)
		or getGuiObjectIsObscuredAtPosition(
			p,
			v4.X + FIntAXGuiObjectIsObscuredPadding,
			v4.Y - FIntAXGuiObjectIsObscuredPadding
		)
		or getGuiObjectIsObscuredAtPosition(
			p,
			v3.X - FIntAXGuiObjectIsObscuredPadding,
			v3.Y + FIntAXGuiObjectIsObscuredPadding
		)
		or getGuiObjectIsObscuredAtPosition(
			p,
			v2.X - FIntAXGuiObjectIsObscuredPadding,
			v2.Y - FIntAXGuiObjectIsObscuredPadding
		)
		or getGuiObjectIsObscuredAtPosition(p, math.floor(v5.X), math.floor(v5.Y))
end

return getGuiObjectIsObscured
