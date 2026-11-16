local parent = script:FindFirstAncestor("MomentsCreation").Parent

local React = require(parent.React)

local udim = UDim.new(0, 0)

local function ensureUIPadding(parent2)
	local uiPadding = parent2:FindFirstChildOfClass("UIPadding")

	if uiPadding then
		return uiPadding
	end

	local uiPadding2 = Instance.new("UIPadding")
	uiPadding2.Parent = parent2
	return uiPadding2
end

local function isZeroed(uiPadding): boolean -- 1 equivalent call inferred from this helper
	return uiPadding.PaddingTop == udim
		and uiPadding.PaddingBottom == udim
		and uiPadding.PaddingLeft == udim
		and uiPadding.PaddingRight == udim
end

local function relocateBoxPadding(instance)
	local uiPadding = instance:FindFirstChildOfClass("UIPadding")

	if uiPadding == nil or isZeroed(uiPadding) then -- inferred equivalent call
		return
	end

	local parent2 = instance.Parent

	if parent2 == nil or not parent2:IsA("GuiObject") then
		return
	end

	local v = parent2:FindFirstChildOfClass("UIPadding")

	if not v then
		v = Instance.new("UIPadding")
		v.Parent = parent2
	end

	v.PaddingTop = uiPadding.PaddingTop
	v.PaddingBottom = uiPadding.PaddingBottom
	v.PaddingLeft = uiPadding.PaddingLeft
	v.PaddingRight = uiPadding.PaddingRight

	uiPadding.PaddingTop = udim
	uiPadding.PaddingBottom = udim
	uiPadding.PaddingLeft = udim
	uiPadding.PaddingRight = udim
end

local function tryRelocate(descendant)
	local v = nil

	if descendant:IsA("TextBox") then
		v = descendant
	elseif descendant:IsA("UIPadding") then
		local parent2 = descendant.Parent

		if parent2 and parent2:IsA("TextBox") then
			v = parent2
		end
	end

	if v ~= nil and (v.Name == "TextBox" or v.Name == "MobileTextBox") then
		relocateBoxPadding(v)
	end
end

local function useComposerParentTextPadding(flag: boolean)
	local ref = React.useRef(nil)

	return React.useCallback(function(folder)
		if ref.current ~= nil then
			ref.current:Disconnect()
			ref.current = nil
		end

		if folder == nil or not flag then
			return
		end

		for _, descendant in folder:GetDescendants() do
			tryRelocate(descendant)
		end

		ref.current = folder.DescendantAdded:Connect(tryRelocate)
	end, { flag })
end

return useComposerParentTextPadding
