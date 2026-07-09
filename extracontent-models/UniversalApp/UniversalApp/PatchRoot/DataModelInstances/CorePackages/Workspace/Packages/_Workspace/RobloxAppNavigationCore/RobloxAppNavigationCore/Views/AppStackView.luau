local Parent = script:FindFirstAncestor("RobloxAppNavigationCore").Parent
local React = require(Parent.React)
local Navigation = require(Parent.Navigation)
local useStackScreens = Navigation.useStackScreens
local ViewState = Navigation.ViewState
local AppStackCard = require(script.Parent.AppStackCard)
local Display = require(Parent.Display)
local useSignalState = require(Parent.SignalsReact).useSignalState
local FFlagEnableLeftNavOnConsole = require(Parent.SharedFlags).FFlagEnableLeftNavOnConsole
local t1 = {
	overlayTransparency = 0.7,
	overlayColor3 = Color3.new(0, 0, 0)
}

local function AppStackView(t2: {[any]: any}) -- line: 33
	-- upvalues: useStackScreens (copy), React (copy), FFlagEnableLeftNavOnConsole (copy), useSignalState (copy), Display (copy), t1 (copy), AppStackCard (copy), ViewState (copy)
	local v13 = useStackScreens({
		navigation = t2.navigation,
		descriptors = t2.descriptors
	})
	local v14 = React.useMemo(function() -- line: 39
		-- upvalues: v13 (copy)
		for i = #v13, 1, -1 do
			local descriptor = v13[i].descriptor

			if not descriptor.options.transparent and not descriptor.options.overlayEnabled then
				return i
			end
		end

		return 0
	end, { v13 })
	local t3 = {}
	local v16 = if not FFlagEnableLeftNavOnConsole then nil else useSignalState(Display.GetDisplayStore().getDeviceSafePadding)
	local v17 = v13[#v13]

	if v17 then
		local options = v17.descriptor.options

		if options.absorbInput == nil or options.absorbInput then
			t3.AbsorbInput = React.createElement("TextButton", {
				Active = true,
				AutoButtonColor = false,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = "",
				Selectable = options.absorbInputSelectable or false,
				Position = if not FFlagEnableLeftNavOnConsole then nil else UDim2.fromOffset(0, -v16.top),
				Size = if not FFlagEnableLeftNavOnConsole then UDim2.fromScale(1, 1) else UDim2.new(1, v16.right, 1, v16.top + v16.bottom),
				ZIndex = #v13 * 2 - 1
			})
		end

		if options.overlayEnabled then
			t3.Overlay = React.createElement("Frame", {
				ClipsDescendants = true,
				BorderSizePixel = 0,
				Position = if not FFlagEnableLeftNavOnConsole then nil else UDim2.fromOffset(0, -v16.top),
				Size = if not FFlagEnableLeftNavOnConsole then UDim2.fromScale(1, 1) else UDim2.new(1, v16.right, 1, v16.top + v16.bottom),
				BackgroundTransparency = options.overlayTransparency or t1.overlayTransparency,
				BackgroundColor3 = t1.overlayColor3,
				ZIndex = #v13 * 2 - 1
			})
		end
	end

	for v19, v20 in v13 do
		t3[v20.descriptor.key] = React.createElement(AppStackCard, {
			isActive = v19 == #v13,
			descriptor = v20.descriptor,
			screenProps = t2.screenProps,
			isVisible = v14 <= v19,
			ZIndex = v19 * 2,
			onAnimationComplete = function() -- line: 98
				-- upvalues: v20 (copy), ViewState (copy)
				if v20.viewState == ViewState.Opening or v20.viewState == ViewState.Opened then
					v20.setOpened()

					return
				end

				if v20.viewState == ViewState.Closing then
					v20.setClosed()
				end
			end
		})
	end

	return React.createElement(React.Fragment, nil, t3)
end

return AppStackView
