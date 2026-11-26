local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/UIBlox")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/Foundation")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/Style").GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local useStyle = UIBlox.Core.Style.useStyle
local headerBar = UIBlox.App.Bar.HeaderBar
local utilityActionIcon = UIBlox.App.Button.UtilityActionIcon

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/SharedFlags")

local fFlagEnableConsoleRobloxLogo = SharedFlags.FFlagEnableConsoleRobloxLogo
local defineFastFlag = game:DefineFastFlag("AppHeaderBarUseSizeFull", false)
local fFlagEnableClassicThemeHeaderBackground = SharedFlags.FFlagEnableClassicThemeHeaderBackground

local v5 = if fFlagEnableClassicThemeHeaderBackground then require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/AppHeaderBar/Components/AppHeaderBarClassicThemeBackground") else nil

local v6 = if fFlagEnableClassicThemeHeaderBackground then require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/AppHeaderBar/Hooks/useClassicThemeHeaderBackgroundConfig") else nil

require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/AppHeaderBar/Types")

local v7 = {
	automaticHeight = false,
	hasDivider = false,
	onMedia = false,
	isTitleCentered = false,
	enableHeaderImageBackground = if fFlagEnableClassicThemeHeaderBackground then false else nil,
	utilitiesGap = UDim.new(0, 0)
}

local function BarTitle(props)
	local tokens = useStyle().Tokens

	local layoutOrder = props.layoutOrder
	local title = props.title
	local titleFont = props.titleFont or tokens.Typography.HeadingLarge
	local v9

	if props.onMedia then
		v9 = tokens.Color.Extended.White.White_100
	else
		v9 = tokens.Color.Content.Emphasis
	end

	local v10 = React.useMemo(function()
		local vector2 = Vector2.new(1e999, 1e999)
		local textSize = getTextSize(title, titleFont.FontSize, titleFont.Font, vector2, {
			addTemporaryPadding = false
		})

		return UDim2.fromOffset(textSize.X + 2, textSize.Y + tokens.Size.Size_50 * 2)
	end, { title, titleFont.FontSize, titleFont.Font, tokens })

	return React.createElement("TextLabel", {
		LayoutOrder = layoutOrder,
		Size = v10,
		BackgroundTransparency = 1,
		Text = title,
		FontFace = normalizeFontFace(titleFont.Font),
		TextSize = titleFont.FontSize,
		LineHeight = titleFont.LineHeight,
		TextColor3 = v9.Color3,
		TextTransparency = v9.Transparency,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true
	}, Cryo.Dictionary.join(props.children or {}, {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, tokens.Size.Size_50),
			PaddingBottom = UDim.new(0, tokens.Size.Size_50)
		})
	}))
end

local function useRenderLeft(joined)
	local renderNavigation = joined.renderNavigation
	local title = joined.title
	local onMedia = joined.onMedia
	local titleFontStyle = joined.titleFontStyle
	local isTitleCentered = joined.isTitleCentered
	local groupTransparencyLeft = joined.groupTransparencyLeft

	return React.useCallback(function(p2)
		local createElement = React.createElement

		local v11 = if groupTransparencyLeft then groupTransparencyLeft.transparency else nil
		local v12 = if groupTransparencyLeft then groupTransparencyLeft.guiObjectRef else nil
		local v10 = {
			BackgroundTransparency = 1,
			GroupTransparency = v11,
			ref = v12,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.XY
		}
		local v13 = {
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			Navigation = 0,
			Title = 0
		}

		local v14 = if renderNavigation then renderNavigation({ layoutOrder = 1 }) else nil
		v13.Navigation = v14
		local v15

		if title and not isTitleCentered then
			local createElement2 = React.createElement

			local v18 = if p2 then p2.children else nil
			v15 = createElement2(
				BarTitle,
				{
					layoutOrder = 2,
					title = title,
					titleFont = titleFontStyle,
					onMedia = onMedia
				},
				v18
			)
		end

		v13.Title = v15
		return createElement(groupTransparencyLeft and "CanvasGroup" or "Frame", v10, v13)
	end, {
		renderNavigation,
		title,
		titleFontStyle,
		groupTransparencyLeft,
		onMedia,
		isTitleCentered
	})
end

local function useRenderCenter(joined)
	local renderCenter = joined.renderCenter
	local title = joined.title
	local onMedia = joined.onMedia
	local titleFontStyle = joined.titleFontStyle
	local isTitleCentered = joined.isTitleCentered
	local groupTransparencyCenter = if fFlagEnableConsoleRobloxLogo then joined.groupTransparencyCenter else nil

	return React.useCallback(function()
		if renderCenter then
			if not fFlagEnableConsoleRobloxLogo then
				return renderCenter()
			end

			local createElement = React.createElement

			local v11 = if groupTransparencyCenter then groupTransparencyCenter.transparency else nil
			local v12 = if groupTransparencyCenter then groupTransparencyCenter.guiObjectRef else nil

			local v13 = if defineFastFlag then UDim2.fromScale(1, 1) else nil
			local v14 = if not defineFastFlag then Enum.AutomaticSize.XY else nil
			return createElement(groupTransparencyCenter and "CanvasGroup" or "Frame", {
				BackgroundTransparency = 1,
				GroupTransparency = v11,
				ref = v12,
				BorderSizePixel = 0,
				Size = v13,
				AutomaticSize = v14
			}, { CenterContent = renderCenter() })
		elseif title and isTitleCentered then
			return React.createElement(BarTitle, {
				title = title,
				titleFont = titleFontStyle,
				onMedia = onMedia
			})
		else
			return nil
		end
	end, {
		renderCenter,
		title,
		titleFontStyle,
		isTitleCentered,
		onMedia,
		groupTransparencyCenter
	})
end

local function useRenderRight(joined)
	local renderUserInfo = joined.renderUserInfo
	local avatarActionIcon = joined.avatarActionIcon
	local searchActionIcon = joined.searchActionIcon
	local renderUtilities = joined.renderUtilities
	local utilitiesGap = joined.utilitiesGap
	local groupTransparencyRight = joined.groupTransparencyRight

	return React.useCallback(function()
		local createElement = React.createElement
		local v10 = {
			Size = UDim2.fromScale(0, 1),
			BackgroundTransparency = 1,
			GroupTransparency = 0,
			ref = 0,
			BorderSizePixel = 0,
			AutomaticSize = 0
		}

		local v11 = if groupTransparencyRight then groupTransparencyRight.transparency else nil
		v10.GroupTransparency = v11
		local v12 = if groupTransparencyRight then groupTransparencyRight.guiObjectRef else nil
		v10.ref = v12

		v10.AutomaticSize = Enum.AutomaticSize.X
		local v13 = {
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = utilitiesGap
			}),
			UserInfo = 0,
			Avatar = 0,
			SearchIcon = 0,
			Utilities = 0
		}

		local v14 = if renderUserInfo then renderUserInfo({
			layoutOrder = 1,
			itemsGap = utilitiesGap
		}) else nil
		v13.UserInfo = v14

		local v15 = if avatarActionIcon then React.createElement(utilityActionIcon, {
			layoutOrder = 2,
			icon = avatarActionIcon.icon,
			iconColor = {},
			onActivated = avatarActionIcon.onActivated
		}) else nil
		v13.Avatar = v15

		local v16 = if searchActionIcon then React.createElement(utilityActionIcon, {
			layoutOrder = 3,
			icon = searchActionIcon.icon,
			onActivated = searchActionIcon.onActivated
		}) else nil
		v13.SearchIcon = v16

		local v17 = if renderUtilities then renderUtilities({
			layoutOrder = 4,
			itemsGap = utilitiesGap
		}) else nil
		v13.Utilities = v17
		return createElement(groupTransparencyRight and "CanvasGroup" or "Frame", v10, v13)
	end, {
		renderUserInfo,
		avatarActionIcon,
		searchActionIcon,
		renderUtilities,
		utilitiesGap,
		groupTransparencyRight
	})
end

local function shouldRenderRight(data): boolean
	local renderUserInfo = data.renderUserInfo
	local avatarActionIcon = data.avatarActionIcon
	local searchActionIcon = data.searchActionIcon
	local renderUtilities = data.renderUtilities

	if renderUserInfo or avatarActionIcon or searchActionIcon or renderUtilities then
		return true
	end

	return false
end

local function AppHeaderBarComponent(p2)
	local joined = Cryo.Dictionary.join(v7, p2)

	local barHeight = joined.barHeight
	local zIndex = joined.zIndex
	local automaticHeight = joined.automaticHeight
	local groupTransparency = joined.groupTransparency
	local backgroundStyle = joined.backgroundStyle
	local hasDivider = joined.hasDivider
	local onMedia = joined.onMedia
	local onHeaderActivated = joined.onHeaderActivated

	local paddingLeft = joined.paddingLeft
	local paddingTop = joined.paddingTop
	local paddingRight = joined.paddingRight
	local paddingBottom = joined.paddingBottom
	local tag = joined.tag

	local v9 = useRenderLeft(joined)
	local v10 = useRenderCenter(joined)
	local v11 = useRenderRight(joined)
	local renderUserInfo = joined.renderUserInfo
	local avatarActionIcon = joined.avatarActionIcon
	local searchActionIcon = joined.searchActionIcon
	local renderUtilities = joined.renderUtilities

	local v13 = if fFlagEnableClassicThemeHeaderBackground then v6() else nil

	local v14 = fFlagEnableClassicThemeHeaderBackground
		and joined.enableHeaderImageBackground
		and v13 ~= nil
	local ref, v15

	if fFlagEnableClassicThemeHeaderBackground then
		ref = React.useRef(nil)
		local guiObjectRef = if groupTransparency then groupTransparency.guiObjectRef else nil

		v15 = React.useCallback(function(current)
			ref.current = current

			if type(guiObjectRef) == "function" then
				guiObjectRef(current)
			elseif guiObjectRef then
				guiObjectRef.current = current
			end
		end, { guiObjectRef })
	else
		ref = nil
	end

	local createElement = React.createElement
	local tagsByTag = {}
	tagsByTag.Size = UDim2.fromScale(1, 0)
	tagsByTag.BackgroundTransparency = 1
	tagsByTag.BorderSizePixel = 0
	local v17 = if groupTransparency then groupTransparency.transparency else nil
	tagsByTag.GroupTransparency = v17

	if not fFlagEnableClassicThemeHeaderBackground then
		v15 = if groupTransparency then groupTransparency.guiObjectRef else nil
	end

	tagsByTag.ref = v15

	tagsByTag.AutomaticSize = Enum.AutomaticSize.Y
	tagsByTag[React.Tag] = tag

	local v19 = if v14 then React.createElement(v5, {
		config = v13,
		containerRef = ref
	}) else nil

	local createElement2 = React.createElement

	if not (renderUserInfo or avatarActionIcon or searchActionIcon or renderUtilities) then
		v11 = nil
	end

	return createElement(groupTransparency and "CanvasGroup" or "Frame", tagsByTag, {
		HeaderImageBackground = v19,
		Bar = createElement2(headerBar, {
			barHeight = barHeight,
			renderLeft = v9,
			renderCenter = v10,
			renderRight = v11,
			onHeaderActivated = onHeaderActivated,
			backgroundStyle = backgroundStyle,
			backgroundTransparency = v14 and 1 or nil,
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
