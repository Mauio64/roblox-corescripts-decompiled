local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local UIBlox = require(CorePackages.Packages.UIBlox)

local useStyle = UIBlox.Core.Style.useStyle
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local scrollBarType = UIBlox.App.Container.Enum.ScrollBarType
local verticalScrollView = UIBlox.App.Container.VerticalScrollView
local useCursor = UIBlox.App.SelectionCursor.useCursor

local module = require("@luauforge/deferred/gDH")

local module2 = require("@luauforge/deferred/gDI")

local function PanelContentWrapper(props)
	local v5 = useStyle()
	local panelRadius = useDesignTokens().LuaApps.ExperienceDetails.PanelRadius
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	React.useEffect(function()
		if ref.current then
			for i, guiObject in ref.current:GetDescendants() do
				if not guiObject:IsA("GuiObject") then
					continue
				end

				if guiObject == ref2.current and props.selectable then
					guiObject.Selectable = true
				else
					guiObject.Selectable = false
				end
			end
		end
	end)
	local createElement = React.createElement
	local v6 = props.useCanvasGroup and "CanvasGroup" or "Frame"
	local v7 = {
		ref = ref,
		Position = UDim2.new(),
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v5.Theme.BackgroundUIContrast.Color,
		BackgroundTransparency = v5.Theme.BackgroundUIContrast.Transparency,
		SelectionGroup = true,
		SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
		SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
		SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
		SelectionBehaviorUp = Enum.SelectionBehavior.Stop
	}
	local v8 = {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, panelRadius)
		}),
		ScrollView = 0
	}

	local createElement2 = React.createElement
	local v10 = {
		ref = ref2,
		canvasSizeY = UDim.new(),
		useAutomaticCanvasSize = true,
		scrollingEnabled = props.scrollingEnabled,
		scrollBarType = 0
	}
	local v11 = if props.scrollingEnabled then scrollBarType.Gamepad else nil
	v10.scrollBarType = v11
	v8.ScrollView = createElement2(verticalScrollView, v10, props.children)
	return createElement(v6, v7, v8)
end

return React.forwardRef(function(props, p2)
	local v5 = useStyle()
	local v6 = useDesignTokens()

	local safeAreaSize = v6.LuaApps.ExperienceDetails.SafeAreaSize or Vector2.zero
	local panelHeaderMargin = v6.LuaApps.ExperienceDetails.PanelHeaderMargin or 0
	local panelRadius = v6.LuaApps.ExperienceDetails.PanelRadius

	local v7 = React.useCallback(function(p3)
		local createElement = React.createElement
		local v10 = {
			text = props.title,
			colorStyle = v5.Theme.TextEmphasis,
			fontStyle = 0
		}

		local v11 = if module2 then v6.Typography.HeadingSmall else v5.Font.Header1
		v10.fontStyle = v11
		return {
			createElement(styledTextLabel, v10),
			React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, panelHeaderMargin)
			})
		}
	end, { props.title, v5 })

	local v8 = React.useCallback(function(p3)
		return React.createElement(
			"Frame",
			{
				Position = UDim2.new(),
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1
			},
			props.children
		)
	end, { props.children })

	local v9 = React.useCallback(function(p3, p4, p5)
		if props.onFocusChanged then
			props.onFocusChanged(p4)
		end

		return React.createElement(PanelContentWrapper, {
			scrollingEnabled = p3,
			selectable = p4,
			useCanvasGroup = props.roundContentCorners or false
		}, p5)
	end, { props.roundContentCorners, props.onFocusChanged })

	local v10 = useCursor(UDim.new(0, panelRadius))

	return React.createElement(module, {
		ref = p2,
		layoutOrder = props.layoutOrder,
		safeAreaSize = UDim2.new(1, -2 * safeAreaSize.X, 1, -2 * safeAreaSize.Y),
		limitInlineHeight = true,
		renderHeader = v7,
		renderContents = v8,
		renderContentWrapper = v9,
		selectionCursor = v10
	})
end)
