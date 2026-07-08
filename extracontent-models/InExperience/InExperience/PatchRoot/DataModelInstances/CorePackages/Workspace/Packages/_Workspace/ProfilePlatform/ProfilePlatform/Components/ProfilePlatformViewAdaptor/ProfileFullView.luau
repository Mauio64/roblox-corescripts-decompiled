local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local UserInputService = game:GetService("UserInputService")
local React = require(ProfilePlatformParent.React)
local UIBlox = require(ProfilePlatformParent.UIBlox)
local Foundation = require(ProfilePlatformParent.Foundation)
local FullscreenPageWithSafeArea = require(ProfilePlatformParent.AppBlox).FullscreenPageWithSafeArea
local Enums = require(ProfilePlatform.Common.Enums)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useIsMeTab = require(ProfilePlatform.Hooks.useIsMeTab)
local Constants = require(ProfilePlatform.Common.Constants)
local VisibilityControl = require(ProfilePlatformParent.AppNavBar).VisibilityControl
local FFlagAXEnableProfileTab = require(ProfilePlatformParent.SharedFlags).FFlagAXEnableProfileTab
local FFlagProfilePlatformMeTabScrollAway = require(ProfilePlatform.Flags.FFlagProfilePlatformMeTabScrollAway)
local View = Foundation.View
local IconButton = Foundation.IconButton
local IconSize = Foundation.Enums.IconSize
local useStyle = UIBlox.Core.Style.useStyle

local function ProfileFullView(t1: {[any]: any}) -- line: 48
	-- upvalues: useStyle (copy), useProfileFormFactor (copy), Enums (copy), FFlagAXEnableProfileTab (copy), useProfileWrapperContext (copy), useIsMeTab (copy), useProfileJsonComponent (copy), Constants (copy), React (copy), FFlagProfilePlatformMeTabScrollAway (copy), VisibilityControl (copy), UserInputService (copy), View (copy), IconButton (copy), IconSize (copy), FullscreenPageWithSafeArea (copy)
	local Theme = useStyle().Theme
	local v24 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	local v25 = if not FFlagAXEnableProfileTab then nil else useProfileWrapperContext()
	local v26 = if not FFlagAXEnableProfileTab then nil else v25.forceFullView == true
	local v27 = if not FFlagAXEnableProfileTab then nil else useIsMeTab()
	local v28 = not v24 and 16 or 36
	local v29 = not v24 and 16 or 24
	local v30 = (not v24 or not not FFlagAXEnableProfileTab and v27) and 1e999 or 1018
	local v31 = useProfileJsonComponent(Enums.Components.CoverPhoto) or {}
	local v32 = if not v26 then v31.coverPhotoId == nil and 56 or -Constants.PAGE_PADDING else 0
	local v33, v34 = React.useState(0)
	local v35 = v33 > 50
	local v36 = if not FFlagProfilePlatformMeTabScrollAway then nil else v26
	local v37 = if not FFlagProfilePlatformMeTabScrollAway then nil else React.useRef(false)
	local v38 = if not FFlagProfilePlatformMeTabScrollAway then nil else React.useRef(0)
	local v39 = React.useCallback(function(p1) -- line: 93
		-- upvalues: v34 (copy), v36 (copy), v37 (copy), v38 (copy), VisibilityControl (copy)
		local CanvasPosition = p1.CanvasPosition
		local v44 = math.abs(CanvasPosition.Y)

		v34(v44)

		if v36 then
			if v37.current then
				local v45 = CanvasPosition.Y - v38.current

				if v45 ~= 0 then
					VisibilityControl.onTouchMoved(-v45)
				end
			end

			v38.current = CanvasPosition.Y
		end
	end, { if not FFlagProfilePlatformMeTabScrollAway then nil else v36 })

	if FFlagProfilePlatformMeTabScrollAway then
		React.useEffect(function() -- line: 116
			-- upvalues: v36 (copy), UserInputService (copy), v37 (copy), VisibilityControl (copy)
			if not v36 then
				return function() -- line: 118
				end
			end

			local connection = UserInputService.TouchStarted:Connect(function() -- line: 120
				-- upvalues: v37 (copy)
				v37.current = true
			end)
			local connection2 = UserInputService.TouchEnded:Connect(function() -- line: 123
				-- upvalues: v37 (copy), VisibilityControl (copy)
				v37.current = false
				VisibilityControl.onTouchEnded()
			end)

			return function() -- line: 127
				-- upvalues: connection (copy), connection2 (copy), VisibilityControl (copy)
				connection:Disconnect()
				connection2:Disconnect()
				VisibilityControl.show()
			end
		end, { v36 })
	end

	local v40 = React.createElement("Frame", {
		BorderSizePixel = 0,
		ZIndex = 1000,
		Size = UDim2.new(1, 0, 0, 56),
		Position = UDim2.fromOffset(0, 0),
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		BackgroundTransparency = not v35 and 1 or 0.1
	}, {
		DropShadow = React.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 2),
			Position = UDim2.new(0, 0, 1, 0),
			BackgroundColor3 = Theme.DropShadow.Color,
			BackgroundTransparency = not v35 and 1 or Theme.DropShadow.Transparency
		}),
		HeaderContent = React.createElement(View, {
			tag = "padding-medium",
			Size = UDim2.fromScale(1, 1)
		}, {
			CloseButton = React.createElement(IconButton, {
				icon = "icons/navigation/close",
				backgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 0, 0.5, 0),
				iconSize = IconSize.Medium,
				onActivated = t1.navigateBack
			})
		})
	})
	local v41 = React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, not v24 and 1 or 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.new(0, 0, 0, v32)
	}, {
		UIListLayout = if not v24 then nil else React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 0)
		}),
		ConstrainedContent = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, not v24 and 1 or 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = if not v24 then nil else 1
		}, {
			UISizeConstraint = if not v24 then nil else React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(v30, 1e999)
			}),
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = if not FFlagAXEnableProfileTab or not v27 then if not v24 then nil else UDim.new(0, v28) else nil,
				PaddingRight = if not FFlagAXEnableProfileTab or not v27 then if not v24 then nil else UDim.new(0, v28) else nil,
				PaddingTop = if not FFlagAXEnableProfileTab or not v27 then if not v24 then nil else UDim.new(0, v29) else UDim.new(0, 24),
				PaddingBottom = UDim.new(0, v29)
			}),
			Content = t1.renderContent()
		})
	})

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = not FFlagAXEnableProfileTab or not v26,
		useFullScalePage = if not FFlagAXEnableProfileTab then nil else v26 or nil,
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		BackgroundTransparency = Theme.BackgroundDefault.Transparency
	}, {
		ContentContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromOffset(0, 0)
		}, {
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
				[React.Change.CanvasPosition] = v39
			}, {
				ContentFrame = v41
			})
		}),
		StickyHeader = if not FFlagAXEnableProfileTab or not v26 then v40 else nil
	})
end

return ProfileFullView
