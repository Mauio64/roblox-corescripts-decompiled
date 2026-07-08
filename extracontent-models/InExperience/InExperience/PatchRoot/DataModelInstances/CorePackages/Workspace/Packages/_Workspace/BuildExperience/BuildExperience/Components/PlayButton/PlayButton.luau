local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local IconButton = Foundation.IconButton
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local DisabledPlaytestTooltip = require(script.Parent.DisabledPlaytestTooltip)

local function PlayButton(t1: {[any]: any}) -- line: 28
	-- upvalues: React (copy), ButtonVariant (copy), InputSize (copy), IconButton (copy), DisabledPlaytestTooltip (copy), View (copy)
	local v11 = if not t1.isActive then t1.inActiveIcon else t1.activeIcon
	local v12 = t1.isDisabled == true
	local v13, v14 = React.useState(false)
	local v15 = React.useCallback(function() -- line: 33
		-- upvalues: v12 (copy), v14 (copy), t1 (copy)
		if v12 then
			v14(function(b1: boolean) -- line: 35
				return not b1
			end)

			return
		end

		t1.onActivated()
	end, {
		v12,
		t1.onActivated
	})
	local t2 = {
		isCircular = true,
		icon = v11,
		variant = t1.variant or ButtonVariant.OverMedia,
		size = InputSize.Medium,
		isDisabled = v12,
		onActivated = v15,
		LayoutOrder = if not v12 then t1.LayoutOrder else nil,
		testId = not v12 and "build-header-play-button" or nil
	}
	local v17 = React.createElement(IconButton, t2)

	if not v12 then
		return v17
	end

	return React.createElement(DisabledPlaytestTooltip, {
		LayoutOrder = t1.LayoutOrder,
		isOpen = v13
	}, {
		PlayButtonAnchor = React.createElement(View, {
			tag = "auto-xy",
			testId = "build-header-play-button",
			onActivated = v15,
			selection = {
				Selectable = true
			}
		}, {
			Button = v17
		})
	})
end

return PlayButton
