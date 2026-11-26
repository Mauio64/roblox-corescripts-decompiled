local module = require("@luauforge/deferred/fEI")

local module2 = require("@luauforge/deferred/fEY")

local function CloudClientStreamScreenView(props)
	if not props.isActive then
		return nil
	end

	local createElement = module.createElement
	local v6 = {
		[module.Tag] = "data-testid=CloudClientStreamScreenView",
		DisplayOrder = props.displayOrder,
		IgnoreGuiInset = true,
		ScreenInsets = Enum.ScreenInsets.None,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}

	local createElement2 = module.createElement
	local v9 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ref = props.rootRef
	}
	local v10 = {
		InputBlocker = module.createElement("ImageButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 3,
			AutoButtonColor = false,
			Modal = props.isInputBlockerModal,
			ref = props.inputBlockerRef
		}),
		LoadingSpinner = 0,
		BugReport = 0
	}

	local v11 = if props.isLoading then module.createElement("ImageLabel", {
		Image = "rbxasset://textures/ui/LoadingScreen/LoadingSpinner.png",
		Size = UDim2.fromOffset(48, 48),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 4,
		Rotation = props.spinnerRotation
	}) else nil
	v10.LoadingSpinner = v11

	local v12 = if props.showBugReport then module.createElement(module2) else nil
	v10.BugReport = v12
	return createElement("ScreenGui", v6, {
		CloudClientStreamScreenView = createElement2("Frame", v9, v10)
	})
end

return CloudClientStreamScreenView
