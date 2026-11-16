local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")

local fullscreenPageWithSafeArea = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AppBlox").FullscreenPageWithSafeArea

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local useProfileFormFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileFormFactor")
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useIsMeTab = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useIsMeTab")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")
local visibilityControl = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AppNavBar").VisibilityControl
local fFlagAXEnableProfileTab = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAXEnableProfileTab
local FFlagProfilePlatformMeTabScrollAway = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformMeTabScrollAway")

local view = Foundation.View
local iconButton = Foundation.IconButton
local iconSize = Foundation.Enums.IconSize
local useStyle = UIBlox.Core.Style.useStyle

local function ProfileFullView(p2)
	local theme = useStyle().Theme

	local v5 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide

	local v6 = if fFlagAXEnableProfileTab then useProfileWrapperContext() else nil
	local v7 = if fFlagAXEnableProfileTab then v6.forceFullView == true else nil
	local v8 = if fFlagAXEnableProfileTab then useIsMeTab() else nil
	local v9 = v5 and 36 or 16
	local v10 = v5 and 24 or 16
	local v11 = v5 and not (fFlagAXEnableProfileTab and v8) and 1018 or 1e999
	local v12 = useProfileJsonComponent(Enums.Components.CoverPhoto) or {}

	local v13 = v7 and 0 or v12.coverPhotoId == nil and 56 or -Constants.PAGE_PADDING

	local state, setState = React.useState(0)
	local v14 = state > 50
	local v15 = if FFlagProfilePlatformMeTabScrollAway then v7 else nil
	local ref = if FFlagProfilePlatformMeTabScrollAway then React.useRef(false) else nil
	local ref2 = if FFlagProfilePlatformMeTabScrollAway then React.useRef(0) else nil

	local function fn(p3)
		local canvasPosition = p3.CanvasPosition
		setState((math.abs(canvasPosition.Y)))

		if v15 then
			if ref.current then
				local v16 = canvasPosition.Y - ref2.current

				if v16 ~= 0 then
					visibilityControl.onTouchMoved(-v16)
				end
			end

			ref2.current = canvasPosition.Y
		end
	end

	local v18 = React.useCallback(fn, { if FFlagProfilePlatformMeTabScrollAway then v15 else nil })

	if FFlagProfilePlatformMeTabScrollAway then
		React.useEffect(function()
			if not v15 then
				return function() end
			end

			local touchStartedConnection = UserInputService.TouchStarted:Connect(function()
				ref.current = true
			end)
			local touchEndedConnection = UserInputService.TouchEnded:Connect(function()
				ref.current = false
				visibilityControl.onTouchEnded()
			end)
			return function()
				touchStartedConnection:Disconnect()
				touchEndedConnection:Disconnect()
				visibilityControl.show()
			end
		end, { v15 })
	end

	local element = React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 56),
		Position = UDim2.fromOffset(0, 0),
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BackgroundTransparency = v14 and 0.1 or 1,
		BorderSizePixel = 0,
		ZIndex = 1000
	}, {
		DropShadow = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 2),
			Position = UDim2.new(0, 0, 1, 0),
			BackgroundColor3 = theme.DropShadow.Color,
			BackgroundTransparency = not v14 and 1 or theme.DropShadow.Transparency,
			BorderSizePixel = 0
		}),
		HeaderContent = React.createElement(
			view,
			{ Size = UDim2.fromScale(1, 1), tag = "padding-medium" },
			{
				CloseButton = React.createElement(iconButton, {
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 0, 0.5, 0),
					iconSize = iconSize.Medium,
					icon = "icons/navigation/close",
					onActivated = p2.navigateBack,
					backgroundTransparency = 1
				})
			}
		)
	})

	local createElement = React.createElement
	local v20 = {
		Size = UDim2.fromScale(1, v5 and 0 or 1),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, v13)
	}

	local v22 = if v5 then React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 0)
	}) else nil

	local createElement2 = React.createElement
	local v24 = {
		Size = UDim2.fromScale(1, v5 and 0 or 1),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = v5 and 1 or nil
	}

	local v26 = if v5 then React.createElement("UISizeConstraint", {
		MaxSize = Vector2.new(v11, 1e999)
	}) else nil

	local createElement3 = React.createElement

	local v29 = if not (fFlagAXEnableProfileTab and v8 or not v5) then UDim.new(0, v9) else nil

	local v30 = if not (fFlagAXEnableProfileTab and v8 or not v5) then UDim.new(0, v9) else nil
	local udim

	if fFlagAXEnableProfileTab and v8 then
		udim = UDim.new(0, 24)
	elseif v5 then
		udim = UDim.new(0, v10)
	end

	local element2 = createElement("Frame", v20, {
		UIListLayout = v22,
		ConstrainedContent = createElement2("Frame", v24, {
			UISizeConstraint = v26,
			UIPadding = createElement3("UIPadding", {
				PaddingLeft = v29,
				PaddingRight = v30,
				PaddingTop = udim,
				PaddingBottom = UDim.new(0, v10)
			}),
			Content = p2.renderContent()
		})
	})

	local createElement4 = React.createElement
	local v32 = {
		includeStatusBar = not fFlagAXEnableProfileTab or not v7,
		useFullScalePage = nil,
		BackgroundColor3 = 0,
		BackgroundTransparency = 0
	}
	local v33 = if fFlagAXEnableProfileTab then v7 or nil else nil
	v32.useFullScalePage = v33
	v32.BackgroundColor3 = theme.BackgroundDefault.Color
	v32.BackgroundTransparency = theme.BackgroundDefault.Transparency
	local v34 = {
		ContentContainer = React.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromOffset(0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			},
			{
				ScrollingFrame = React.createElement("ScrollingFrame", {
					Size = UDim2.fromScale(1, 1),
					Position = UDim2.fromOffset(0, 0),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ScrollBarThickness = 0,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					CanvasSize = UDim2.new(1, 0, 0, 0),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					Selectable = false,
					ElasticBehavior = Enum.ElasticBehavior.Never,
					[React.Change.CanvasPosition] = v18
				}, { ContentFrame = element2 })
			}
		),
		StickyHeader = 0
	}

	if fFlagAXEnableProfileTab and v7 then
		element = nil
	end

	v34.StickyHeader = element
	return createElement4(fullscreenPageWithSafeArea, v32, v34)
end

return ProfileFullView
