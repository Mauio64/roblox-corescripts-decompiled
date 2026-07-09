local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local ScrollBarType = UIBlox.App.Container.Enum.ScrollBarType
local VerticalScrollView = UIBlox.App.Container.VerticalScrollView
local useCursor = UIBlox.App.SelectionCursor.useCursor
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local FocusFrame = require(Modules.LuaApp.Components.FocusFrame)
local FFlagExperienceDetailsTextUseTokens = require(script.Parent.Flags.FFlagExperienceDetailsTextUseTokens)

local function PanelContentWrapper(t1: {[any]: any}) -- line: 35
	-- upvalues: useStyle (copy), useDesignTokens (copy), React (copy), VerticalScrollView (copy), ScrollBarType (copy)
	local v16 = useStyle()
	local PanelRadius = useDesignTokens().LuaApps.ExperienceDetails.PanelRadius
	local v18 = React.useRef(nil)
	local v19 = React.useRef(nil)

	React.useEffect(function() -- line: 41
		-- upvalues: v18 (copy), v19 (copy), t1 (copy)
		if v18.current then
			for _, descendant in v18.current:GetDescendants() do
				if descendant:IsA("GuiObject") then
					if descendant == v19.current and t1.selectable then
						descendant.Selectable = true
					else
						descendant.Selectable = false
					end
				end
			end
		end
	end)

	return React.createElement(not t1.useCanvasGroup and "Frame" or "CanvasGroup", {
		SelectionGroup = true,
		ref = v18,
		Position = UDim2.new(),
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v16.Theme.BackgroundUIContrast.Color,
		BackgroundTransparency = v16.Theme.BackgroundUIContrast.Transparency,
		SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
		SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
		SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
		SelectionBehaviorUp = Enum.SelectionBehavior.Stop
	}, {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, PanelRadius)
		}),
		ScrollView = React.createElement(VerticalScrollView, {
			useAutomaticCanvasSize = true,
			ref = v19,
			canvasSizeY = UDim.new(),
			scrollingEnabled = t1.scrollingEnabled,
			scrollBarType = if not t1.scrollingEnabled then nil else ScrollBarType.Gamepad
		}, t1.children)
	})
end

return React.forwardRef(function(t2: {[any]: any}, p1) -- line: 79
	-- upvalues: useStyle (copy), useDesignTokens (copy), React (copy), StyledTextLabel (copy), FFlagExperienceDetailsTextUseTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), PanelContentWrapper (copy), useCursor (copy), FocusFrame (copy)
	local v22 = useStyle()
	local v23 = useDesignTokens()
	local v24 = v23.LuaApps.ExperienceDetails.SafeAreaSize or Vector2.zero
	local v25 = v23.LuaApps.ExperienceDetails.PanelHeaderMargin or 0
	local PanelRadius = v23.LuaApps.ExperienceDetails.PanelRadius
	local v27 = React.useCallback(function(_) -- line: 87
		-- upvalues: React (copy), StyledTextLabel (copy), t2 (copy), v22 (copy), FFlagExperienceDetailsTextUseTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), v23 (copy), v25 (copy)
		return {
			React.createElement(StyledTextLabel, {
				text = t2.title,
				colorStyle = v22.Theme.TextEmphasis,
				fontStyle = if not FFlagExperienceDetailsTextUseTokens then v22.Font.Header1 else if not FFlagRenameDeprecatedUIBloxTokens then v23.Semantic.Typography.Header else v23.Typography.HeadingSmall
			}),
			React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, v25)
			})
		}
	end, {
		t2.title,
		v22
	})
	local v28 = React.useCallback(function(_) -- line: 104
		-- upvalues: React (copy), t2 (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.new(),
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, t2.children)
	end, { t2.children })
	local v29 = React.useCallback(function(p4, p5, p6) -- line: 113
		-- upvalues: t2 (copy), React (copy), PanelContentWrapper (copy)
		if t2.onFocusChanged then
			t2.onFocusChanged(p5)
		end

		return React.createElement(PanelContentWrapper, {
			scrollingEnabled = p4,
			selectable = p5,
			useCanvasGroup = t2.roundContentCorners or false
		}, p6)
	end, {
		t2.roundContentCorners,
		t2.onFocusChanged
	})
	local v30 = useCursor(UDim.new(0, PanelRadius))

	return React.createElement(FocusFrame, {
		limitInlineHeight = true,
		ref = p1,
		layoutOrder = t2.layoutOrder,
		safeAreaSize = UDim2.new(1, -2 * v24.X, 1, -2 * v24.Y),
		renderHeader = v27,
		renderContents = v28,
		renderContentWrapper = v29,
		selectionCursor = v30
	})
end)
