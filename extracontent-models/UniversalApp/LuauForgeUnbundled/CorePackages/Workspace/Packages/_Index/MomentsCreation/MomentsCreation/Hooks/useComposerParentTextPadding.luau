local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local udim = UDim.new(0, 0)

local function ensureUIPadding(parent)
	local uiPadding = parent:FindFirstChildOfClass("UIPadding")

	if uiPadding then
		return uiPadding
	end

	local uiPadding2 = Instance.new("UIPadding")
	uiPadding2.Parent = parent
	return uiPadding2
end

local function isZeroed(data): boolean
	return data.PaddingTop == udim
		and data.PaddingBottom == udim
		and data.PaddingLeft == udim
		and data.PaddingRight == udim
end

local function relocateBoxPadding(instance)
	local uiPadding = instance:FindFirstChildOfClass("UIPadding")

	if uiPadding == nil then
		return
	end

	local v5

	if
		uiPadding.PaddingTop == udim
		and uiPadding.PaddingBottom == udim
		and uiPadding.PaddingLeft == udim
	then
		v5 = uiPadding.PaddingRight == udim
	else
		v5 = false
	end

	if v5 then
		return
	end

	local parent = instance.Parent

	if parent == nil or not parent:IsA("GuiObject") then
		return
	end

	local v6 = parent:FindFirstChildOfClass("UIPadding")

	if not v6 then
		v6 = Instance.new("UIPadding")
		v6.Parent = parent
	end

	v6.PaddingTop = uiPadding.PaddingTop
	v6.PaddingBottom = uiPadding.PaddingBottom
	v6.PaddingLeft = uiPadding.PaddingLeft
	v6.PaddingRight = uiPadding.PaddingRight

	uiPadding.PaddingTop = udim
	uiPadding.PaddingBottom = udim
	uiPadding.PaddingLeft = udim
	uiPadding.PaddingRight = udim
end

local function tryRelocate(descendant)
	local v5 = nil

	if descendant:IsA("TextBox") then
		v5 = descendant
	elseif descendant:IsA("UIPadding") then
		local parent = descendant.Parent

		if parent and parent:IsA("TextBox") then
			v5 = parent
		end
	end

	if v5 ~= nil and (v5.Name == "TextBox" or v5.Name == "MobileTextBox") then
		relocateBoxPadding(v5)
	end
end

local function useComposerParentTextPadding(p2)
	local ref = React.useRef(nil)

	return React.useCallback(function(folder)
		if ref.current ~= nil then
			ref.current:Disconnect()
			ref.current = nil
		end

		if folder == nil or not p2 then
			return
		end

		for i, descendant in folder:GetDescendants() do
			tryRelocate(descendant)
		end

		ref.current = folder.DescendantAdded:Connect(tryRelocate)
	end, { p2 })
end

return useComposerParentTextPadding
