local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/Responsive")

require("@game/CorePackages/Workspace/Packages/_Index/AppPageShell/AppPageShell/PageTypes")
local computeStickyOffset = require("@game/CorePackages/Workspace/Packages/_Index/AppPageShell/AppPageShell/computeStickyOffset")

local view = Foundation.View
local useDeviceInsets = Responsive.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens

local fFlagSduiFeedScrollBarFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppPageShell/SharedFlags").FFlagSduiFeedScrollBarFixes

local function PageStickyHeader(props)
	local topPadding = props.topPadding
	local backgroundStyle = props.backgroundStyle
	local slots = props.slots
	local chromeHeight = props.chromeHeight or 0
	local liveChromeHeightBinding = props.liveChromeHeightBinding

	local v5 = useTokens()
	local v6, v7 = React.useBinding(0)
	local v8

	if not fFlagSduiFeedScrollBarFixes then
		local top = useDeviceInsets().top

		v8 = React.useMemo(function()
			if liveChromeHeightBinding == nil or chromeHeight <= 0 then
				return UDim2.fromOffset(0, 0)
			end

			return liveChromeHeightBinding:map(function(p2)
				return UDim2.fromOffset(0, computeStickyOffset(p2, chromeHeight, top))
			end)
		end, { liveChromeHeightBinding, chromeHeight, top })
	end

	local v9 = React.useMemo(function()
		return v6:map(function(p2)
			return UDim2.new(1, 0, 0, p2 + chromeHeight)
		end)
	end, { v6, chromeHeight })

	local v10 = React.useMemo(function()
		if slots == nil or next(slots) == nil then
			return nil
		end

		local slots2 = {}

		for k, slot in slots do
			slots2[`Sticky{k}`] = slot
		end

		return slots2
	end, { slots })

	local v11 = React.useMemo(function()
		return v6:map(function(p2)
			return UDim2.new(1, 0, 0, p2)
		end)
	end, { v6 })

	local v12 = React.useCallback(function(p2)
		v7(p2.AbsoluteSize.Y)
	end, {})

	if v10 == nil then
		return nil
	end

	local createElement = React.createElement

	local createElement2 = React.createElement

	if fFlagSduiFeedScrollBarFixes then
		v8 = nil
	end

	local v17 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = v8,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ClipsDescendants = false,
		[React.Change.AbsoluteSize] = v12
	}

	local createElement3 = React.createElement
	local v19 = {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Size = v9,
		BackgroundColor3 = 0,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ZIndex = 0
	}

	local v20 = if backgroundStyle then backgroundStyle.Color3 else v5.Color.Surface.Surface_0.Color3
	v19.BackgroundColor3 = v20

	v19.BackgroundTransparency = (not backgroundStyle or backgroundStyle.Transparency == nil) and 0
		or backgroundStyle.Transparency
	local children = { Background = createElement3("Frame", v19), Content = 0 }

	local createElement4 = React.createElement
	local v22 = {
		tag = `col size-full-0 auto-y {props.tag or ""}`
	}

	local v24 = if topPadding and topPadding > 0 then React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, topPadding),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 1
	}) else nil
	children.Content = createElement4(view, v22, {
		TopSpacer = v24,
		Body = React.createElement(view, {
			tag = "col size-full-0 auto-y",
			LayoutOrder = 2
		}, v10)
	})
	return createElement(view, {
		Size = v11,
		LayoutOrder = 1,
		ZIndex = 2,
		ClipsDescendants = false
	}, {
		Translation = createElement2("Frame", v17, children)
	})
end

return React.memo(PageStickyHeader)
