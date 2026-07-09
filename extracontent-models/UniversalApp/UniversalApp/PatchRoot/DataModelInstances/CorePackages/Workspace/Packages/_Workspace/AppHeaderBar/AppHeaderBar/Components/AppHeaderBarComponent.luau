local TextService = game:GetService("TextService")
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local UIBlox = require(ParentParentParent.UIBlox)
local Cryo = require(ParentParentParent.Cryo)
local useStyle = UIBlox.Core.Style.useStyle
local HeaderBar = UIBlox.App.Bar.HeaderBar
local UtilityActionIcon = UIBlox.App.Button.UtilityActionIcon
local SharedFlags = require(ParentParentParent.SharedFlags)
local FFlagEnableConsoleRobloxLogo = SharedFlags.FFlagEnableConsoleRobloxLogo
local FFlagLuaAppCompositionTopBarFullBleed = SharedFlags.FFlagLuaAppCompositionTopBarFullBleed
local v13 = game:DefineFastFlag("AppHeaderBarUseSizeFull", false)

require(ParentParent.Types)

local t1 = {
	automaticHeight = false,
	hasDivider = false,
	onMedia = false,
	isTitleCentered = false,
	utilitiesGap = UDim.new(0, 0)
}

local function BarTitle(t2: {[any]: any}) -- line: 39
	-- upvalues: useStyle (copy), React (copy), TextService (copy), Cryo (copy)
	local Tokens = useStyle().Tokens
	local layoutOrder = t2.layoutOrder
	local title = t2.title
	local v25 = t2.titleFont or Tokens.Typography.HeadingLarge
	local v26 = if not t2.onMedia then Tokens.Color.Content.Emphasis else Tokens.Color.Extended.White.White_100
	local v27 = React.useMemo(function() -- line: 49
		-- upvalues: TextService (copy), title (copy), v25 (copy), Tokens (copy)
		local TextSize = TextService:GetTextSize(title, v25.FontSize, v25.Font, Vector2.new(1e999, 1e999))

		return UDim2.fromOffset(TextSize.X + 2, TextSize.Y + Tokens.Size.Size_50 * 2)
	end, {
		title,
		v25.FontSize,
		v25.Font,
		Tokens
	})

	return React.createElement("TextLabel", {
		BackgroundTransparency = 1,
		TextWrapped = true,
		LayoutOrder = layoutOrder,
		Size = v27,
		Text = title,
		Font = v25.Font,
		TextSize = v25.FontSize,
		LineHeight = v25.LineHeight,
		TextColor3 = v26.Color3,
		TextTransparency = v26.Transparency,
		TextXAlignment = Enum.TextXAlignment.Left
	}, Cryo.Dictionary.join(t2.children or {}, {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, Tokens.Size.Size_50),
			PaddingBottom = UDim.new(0, Tokens.Size.Size_50)
		})
	}))
end
local function useRenderLeft(p1) -- line: 79
	-- upvalues: React (copy), BarTitle (copy)
	local renderNavigation = p1.renderNavigation
	local title = p1.title
	local onMedia = p1.onMedia
	local titleFontStyle = p1.titleFontStyle
	local isTitleCentered = p1.isTitleCentered
	local groupTransparencyLeft = p1.groupTransparencyLeft

	return React.useCallback(function(p2) -- line: 87
		-- upvalues: React (copy), groupTransparencyLeft (copy), renderNavigation (copy), title (copy), isTitleCentered (copy), BarTitle (copy), titleFontStyle (copy), onMedia (copy)
		return React.createElement(not groupTransparencyLeft and "Frame" or "CanvasGroup", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			GroupTransparency = if not groupTransparencyLeft then nil else groupTransparencyLeft.transparency,
			ref = if not groupTransparencyLeft then nil else groupTransparencyLeft.guiObjectRef,
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			Navigation = if not renderNavigation then nil else renderNavigation({
				layoutOrder = 1
			}),
			Title = if not title or isTitleCentered then nil else React.createElement(BarTitle, {
				layoutOrder = 2,
				title = title,
				titleFont = titleFontStyle,
				onMedia = onMedia
			}, if not p2 then nil else p2.children)
		})
	end, {
		renderNavigation,
		title,
		titleFontStyle,
		groupTransparencyLeft,
		onMedia,
		isTitleCentered
	})
end
local function useRenderCenter(p3) -- line: 118
	-- upvalues: FFlagEnableConsoleRobloxLogo (copy), React (copy), v13 (copy), BarTitle (copy)
	local renderCenter = p3.renderCenter
	local title = p3.title
	local onMedia = p3.onMedia
	local titleFontStyle = p3.titleFontStyle
	local isTitleCentered = p3.isTitleCentered
	local v41 = if not FFlagEnableConsoleRobloxLogo then nil else p3.groupTransparencyCenter

	return React.useCallback(function() -- line: 126
		-- upvalues: renderCenter (copy), FFlagEnableConsoleRobloxLogo (copy), React (copy), v41 (copy), v13 (copy), title (copy), isTitleCentered (copy), BarTitle (copy), titleFontStyle (copy), onMedia (copy)
		if renderCenter then
			if FFlagEnableConsoleRobloxLogo then
				return React.createElement(not v41 and "Frame" or "CanvasGroup", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					GroupTransparency = if not v41 then nil else v41.transparency,
					ref = if not v41 then nil else v41.guiObjectRef,
					Size = if not v13 then nil else UDim2.fromScale(1, 1),
					AutomaticSize = if not v13 then Enum.AutomaticSize.XY else nil
				}, {
					CenterContent = renderCenter()
				})
			end

			return renderCenter()
		end

		if title and isTitleCentered then
			return React.createElement(BarTitle, {
				title = title,
				titleFont = titleFontStyle,
				onMedia = onMedia
			})
		end

		return nil
	end, {
		renderCenter,
		title,
		titleFontStyle,
		isTitleCentered,
		onMedia,
		v41
	})
end
local function useRenderRight(p4) -- line: 154
	-- upvalues: React (copy), UtilityActionIcon (copy)
	local renderUserInfo = p4.renderUserInfo
	local avatarActionIcon = p4.avatarActionIcon
	local searchActionIcon = p4.searchActionIcon
	local renderUtilities = p4.renderUtilities
	local utilitiesGap = p4.utilitiesGap
	local groupTransparencyRight = p4.groupTransparencyRight

	return React.useCallback(function() -- line: 163
		-- upvalues: React (copy), groupTransparencyRight (copy), utilitiesGap (copy), renderUserInfo (copy), avatarActionIcon (copy), UtilityActionIcon (copy), searchActionIcon (copy), renderUtilities (copy)
		return React.createElement(not groupTransparencyRight and "Frame" or "CanvasGroup", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(0, 1),
			GroupTransparency = if not groupTransparencyRight then nil else groupTransparencyRight.transparency,
			ref = if not groupTransparencyRight then nil else groupTransparencyRight.guiObjectRef,
			AutomaticSize = Enum.AutomaticSize.X
		}, {
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = utilitiesGap
			}),
			UserInfo = if not renderUserInfo then nil else renderUserInfo({
				layoutOrder = 1,
				itemsGap = utilitiesGap
			}),
			Avatar = if not avatarActionIcon then nil else React.createElement(UtilityActionIcon, {
				layoutOrder = 2,
				icon = avatarActionIcon.icon,
				iconColor = {},
				onActivated = avatarActionIcon.onActivated
			}),
			SearchIcon = if not searchActionIcon then nil else React.createElement(UtilityActionIcon, {
				layoutOrder = 3,
				icon = searchActionIcon.icon,
				onActivated = searchActionIcon.onActivated
			}),
			Utilities = if not renderUtilities then nil else renderUtilities({
				layoutOrder = 4,
				itemsGap = utilitiesGap
			})
		})
	end, {
		renderUserInfo,
		avatarActionIcon,
		searchActionIcon,
		renderUtilities,
		utilitiesGap,
		groupTransparencyRight
	})
end
local function shouldRenderRight(p5) -- line: 211
	local renderUserInfo = p5.renderUserInfo
	local avatarActionIcon = p5.avatarActionIcon
	local searchActionIcon = p5.searchActionIcon
	local renderUtilities = p5.renderUtilities

	if renderUserInfo or (avatarActionIcon or searchActionIcon or renderUtilities) then
		return true
	end

	return false
end
local function AppHeaderBarComponent(p6) -- line: 223
	-- upvalues: Cryo (copy), t1 (copy), useRenderLeft (copy), useRenderCenter (copy), useRenderRight (copy), React (copy), FFlagLuaAppCompositionTopBarFullBleed (copy), HeaderBar (copy)
	local v55 = Cryo.Dictionary.join(t1, p6)
	local barHeight = v55.barHeight
	local zIndex = v55.zIndex
	local automaticHeight = v55.automaticHeight
	local groupTransparency = v55.groupTransparency
	local backgroundStyle = v55.backgroundStyle
	local hasDivider = v55.hasDivider
	local onMedia = v55.onMedia
	local onHeaderActivated = v55.onHeaderActivated
	local paddingLeft = v55.paddingLeft
	local paddingTop = v55.paddingTop
	local paddingRight = v55.paddingRight
	local paddingBottom = v55.paddingBottom
	local tag = v55.tag
	local v69 = useRenderLeft(v55)
	local v70 = useRenderCenter(v55)
	local v71 = useRenderRight(v55)
	local renderUserInfo = v55.renderUserInfo
	local avatarActionIcon = v55.avatarActionIcon
	local searchActionIcon = v55.searchActionIcon
	local renderUtilities = v55.renderUtilities
	local v76 = (renderUserInfo or (avatarActionIcon or searchActionIcon)) and true or not not renderUtilities

	return React.createElement(not groupTransparency and "Frame" or "CanvasGroup", {
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		GroupTransparency = if not groupTransparency then nil else groupTransparency.transparency,
		ref = if not groupTransparency then nil else groupTransparency.guiObjectRef,
		AutomaticSize = Enum.AutomaticSize.Y,
		[React.Tag] = if not FFlagLuaAppCompositionTopBarFullBleed then nil else tag
	}, {
		Bar = React.createElement(HeaderBar, {
			barHeight = barHeight,
			renderLeft = v69,
			renderCenter = v70,
			renderRight = if not v76 then nil else v71,
			onHeaderActivated = onHeaderActivated,
			backgroundStyle = backgroundStyle,
			isOnMedia = onMedia,
			automaticHeight = automaticHeight,
			paddingLeft = paddingLeft,
			paddingTop = paddingTop,
			paddingRight = paddingRight,
			paddingBottom = paddingBottom,
			zIndex = zIndex,
			hasDivider = hasDivider
		})
	})
end

return AppHeaderBarComponent
