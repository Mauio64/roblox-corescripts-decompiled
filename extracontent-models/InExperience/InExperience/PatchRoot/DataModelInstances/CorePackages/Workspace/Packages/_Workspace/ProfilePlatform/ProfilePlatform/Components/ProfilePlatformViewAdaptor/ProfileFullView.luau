local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local UserInputService = game:GetService("UserInputService")

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)

local AppBlox = require(parent.AppBlox)
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea

local Enums = require(ProfilePlatform.Common.Enums)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useIsMeTab = require(ProfilePlatform.Hooks.useIsMeTab)
local Constants = require(ProfilePlatform.Common.Constants)
local AppNavBar = require(parent.AppNavBar)
local VisibilityControl = AppNavBar.VisibilityControl
local SharedFlags = require(parent.SharedFlags)
local FFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab
local FFlagProfilePlatformMeTabScrollAway = require(ProfilePlatform.Flags.FFlagProfilePlatformMeTabScrollAway)

local View = Foundation.View
local IconButton = Foundation.IconButton
local IconSize = Foundation.Enums.IconSize
local useStyle = UIBlox.Core.Style.useStyle

local function ProfileFullView(p)
	local theme = useStyle().Theme

	local v = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	local v2

	if FFlagAXEnableProfileTab then
		v2 = useProfileWrapperContext()
	end

	local v3

	if FFlagAXEnableProfileTab then
		v3 = v2.forceFullView == true
	end

	local v4

	if FFlagAXEnableProfileTab then
		v4 = useIsMeTab()
	end

	local v5 = v and 36 or 16
	local v6 = v and 24 or 16
	local v7 = v and not (FFlagAXEnableProfileTab and v4) and 1018 or 1e999
	local v8 = useProfileJsonComponent(Enums.Components.CoverPhoto) or {}

	local v9 = v3 and 0 or v8.coverPhotoId == nil and 56 or -Constants.PAGE_PADDING

	local state, setState = React.useState(0)
	local v10 = state > 50
	local v11

	if FFlagProfilePlatformMeTabScrollAway then
		v11 = v3
	else
		v11 = nil
	end

	local ref

	if FFlagProfilePlatformMeTabScrollAway then
		ref = React.useRef(false)
	else
		ref = nil
	end

	local ref2

	if FFlagProfilePlatformMeTabScrollAway then
		ref2 = React.useRef(0)
	else
		ref2 = nil
	end

	local useCallback = React.useCallback
	local function fn(p2)
		local canvasPosition = p2.CanvasPosition
		setState((math.abs(canvasPosition.Y)))

		if v11 then
			if ref.current then
				local v12 = canvasPosition.Y - ref2.current

				if v12 ~= 0 then
					VisibilityControl.onTouchMoved(-v12)
				end
			end

			ref2.current = canvasPosition.Y
		end
	end

	local v12

	if FFlagProfilePlatformMeTabScrollAway then
		v12 = v11
	end

	local v13 = useCallback(fn, { v12 })

	if FFlagProfilePlatformMeTabScrollAway then
		React.useEffect(function()
			if not v11 then
				return function() end
			end

			local touchStartedConnection = UserInputService.TouchStarted:Connect(function()
				ref.current = true
			end)
			local touchEndedConnection = UserInputService.TouchEnded:Connect(function()
				ref.current = false
				VisibilityControl.onTouchEnded()
			end)
			return function()
				touchStartedConnection:Disconnect()
				touchEndedConnection:Disconnect()
				VisibilityControl.show()
			end
		end, { v11 })
	end

	local element = React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 56),
		Position = UDim2.fromOffset(0, 0),
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BackgroundTransparency = v10 and 0.1 or 1,
		BorderSizePixel = 0,
		ZIndex = 1000
	}, {
		DropShadow = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 2),
			Position = UDim2.new(0, 0, 1, 0),
			BackgroundColor3 = theme.DropShadow.Color,
			BackgroundTransparency = not v10 and 1 or theme.DropShadow.Transparency,
			BorderSizePixel = 0
		}),
		HeaderContent = React.createElement(View, {
			Size = UDim2.fromScale(1, 1),
			tag = "padding-medium"
		}, {
			CloseButton = React.createElement(IconButton, {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 0, 0.5, 0),
				iconSize = IconSize.Medium,
				icon = "icons/navigation/close",
				onActivated = p.navigateBack,
				backgroundTransparency = 1
			})
		})
	})

	local createElement = React.createElement
	local v14 = {
		Size = UDim2.fromScale(1, v and 0 or 1),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, v9)
	}
	local uiListLayout

	if v then
		uiListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 0)
		})
	end

	local createElement2 = React.createElement
	local v15 = {
		Size = UDim2.fromScale(1, v and 0 or 1),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = v and 1 or nil
	}
	local uiSizeConstraint

	if v then
		uiSizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(v7, 1e999)
		})
	end

	local createElement3 = React.createElement
	local paddingLeft

	if not (FFlagAXEnableProfileTab and v4 or not v) then
		paddingLeft = UDim.new(0, v5)
	end

	local paddingRight

	if not (FFlagAXEnableProfileTab and v4 or not v) then
		paddingRight = UDim.new(0, v5)
	end

	local udim

	if FFlagAXEnableProfileTab and v4 then
		udim = UDim.new(0, 24)
	elseif v then
		udim = UDim.new(0, v6)
	end

	local element2 = createElement("Frame", v14, {
		UIListLayout = uiListLayout,
		ConstrainedContent = createElement2("Frame", v15, {
			UISizeConstraint = uiSizeConstraint,
			UIPadding = createElement3("UIPadding", {
				PaddingLeft = paddingLeft,
				PaddingRight = paddingRight,
				PaddingTop = udim,
				PaddingBottom = UDim.new(0, v6)
			}),
			Content = p.renderContent()
		})
	})

	local createElement4 = React.createElement
	local v16 = {
		includeStatusBar = not FFlagAXEnableProfileTab or not v3,
		useFullScalePage = nil,
		BackgroundColor3 = 0,
		BackgroundTransparency = 0
	}
	local useFullScalePage

	if FFlagAXEnableProfileTab then
		useFullScalePage = v3 or nil
	end

	v16.useFullScalePage = useFullScalePage
	v16.BackgroundColor3 = theme.BackgroundDefault.Color
	v16.BackgroundTransparency = theme.BackgroundDefault.Transparency
	local v17 = {
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
					[React.Change.CanvasPosition] = v13
				}, { ContentFrame = element2 })
			}
		),
		StickyHeader = 0
	}

	if FFlagAXEnableProfileTab and v3 then
		element = nil
	end

	v17.StickyHeader = element
	return createElement4(FullscreenPageWithSafeArea, v16, v17)
end

return ProfileFullView
