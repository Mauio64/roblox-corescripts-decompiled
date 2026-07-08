local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local SduiSharedUtilitiesParent = SduiSharedUtilities.Parent
local React = require(SduiSharedUtilitiesParent.React)
local Foundation = require(SduiSharedUtilitiesParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local IconButton = Foundation.IconButton
local BuilderIcons = require(SduiSharedUtilitiesParent.BuilderIcons)
local Responsive = require(SduiSharedUtilitiesParent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local SignalsReact = require(SduiSharedUtilitiesParent.SignalsReact)
local GetDisplayStore = require(SduiSharedUtilitiesParent.Display).GetDisplayStore
local AppHeaderBar = require(SduiSharedUtilitiesParent.AppHeaderBar)
local NavButtonType = require(SduiSharedUtilities.SduiIntegrationTypes).NavButtonType
local useScrollAwayHeaderPosition = require(SduiSharedUtilities.useScrollAwayHeaderPosition)
local FFlagLuaAppSduiPageEntryScrollAway = require(SduiSharedUtilitiesParent.SharedFlags).FFlagLuaAppSduiPageEntryScrollAway

local function calculateSize(p1) -- line: 40
	-- upvalues: GetDisplayStore (copy)
	local v19 = GetDisplayStore(p1)
	local v20 = v19.getGuiInset(p1)

	return UDim2.new(1, 0, 0, v19.getTopBarHeight(p1) - v20.top or 0)
end
local function SduiPageNavigationHeader(t1: {[any]: any}) -- line: 48
	-- upvalues: useTokens (copy), usePreferredInput (copy), Responsive (copy), SignalsReact (copy), calculateSize (copy), React (copy), NavButtonType (copy), IconButton (copy), Foundation (copy), BuilderIcons (copy), AppHeaderBar (copy), FFlagLuaAppSduiPageEntryScrollAway (copy), useScrollAwayHeaderPosition (copy)
	local closeCallback = t1.closeCallback
	local v23 = useTokens()
	local v24 = usePreferredInput() == Responsive.Input.Directional
	local v25 = SignalsReact.useSignalBinding(calculateSize)
	local v26 = React.useMemo(function() -- line: 56
		-- upvalues: v24 (copy), closeCallback (copy), t1 (copy), NavButtonType (copy), React (copy), v23 (copy), IconButton (copy), Foundation (copy), BuilderIcons (copy)
		if not v24 and closeCallback and (t1.navButtonType == NavButtonType.back or t1.navButtonType == NavButtonType.close) then
			return function() -- line: 61
				-- upvalues: React (copy), v23 (copy), IconButton (copy), closeCallback (copy), Foundation (copy), t1 (copy), NavButtonType (copy), BuilderIcons (copy)
				return React.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(0, v23.Size.Size_1400, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					UIPadding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, -v23.Size.Size_250)
					}),
					IconButton = React.createElement(IconButton, {
						SelectionOrder = 10,
						isCircular = true,
						onActivated = closeCallback,
						size = Foundation.Enums.InputSize.Large,
						icon = {
							name = if t1.navButtonType ~= NavButtonType.close then BuilderIcons.Icon.ChevronLargeLeft else BuilderIcons.Icon.X,
							variant = Foundation.Enums.IconVariant.Regular
						}
					})
				})
			end
		end

		return nil
	end, {
		v24,
		t1.navButtonType,
		closeCallback
	})
	local t2 = {
		AppHeaderBarLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Bottom
		}),
		AppHeaderBar = React.createElement(AppHeaderBar.AppHeaderBar, {
			automaticHeight = true,
			shouldRenderTitle = true,
			onMedia = false,
			renderNavigation = v26,
			title = t1.title,
			renderUtilities = t1.renderUtilities,
			paddingLeft = UDim.new(0, 0),
			paddingRight = UDim.new(0, 0),
			isTitleCentered = t1.navButtonType ~= NavButtonType.back
		})
	}

	if FFlagLuaAppSduiPageEntryScrollAway then
		local v28 = useScrollAwayHeaderPosition({
			sizeBinding = v25,
			enabled = t1.scrollAwayHeader
		})

		return React.createElement("Frame", {
			[React.Tag] = t1.contentTag,
			Size = v25,
			LayoutOrder = t1.layoutOrder or -1,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = if not v26 then nil else Enum.AutomaticSize.Y,
			ZIndex = 2,
			ClipsDescendants = false
		}, {
			Content = React.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundColor3 = v23.Color.Surface.Surface_0.Color3,
				Size = v25,
				Position = v28,
				AutomaticSize = if not v26 then nil else Enum.AutomaticSize.Y
			}, t2)
		})
	end

	return React.createElement("Frame", {
		[React.Tag] = t1.contentTag,
		BackgroundColor3 = v23.Color.Surface.Surface_0.Color3,
		Size = v25,
		BorderSizePixel = 0,
		LayoutOrder = t1.layoutOrder or -1,
		AutomaticSize = if not v26 then nil else Enum.AutomaticSize.Y
	}, t2)
end

return React.memo(SduiPageNavigationHeader)
