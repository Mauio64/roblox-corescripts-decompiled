local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local UIBlox = require(parent2.UIBlox)
local Cryo = require(parent2.Cryo)
local Foundation = require(parent2.Foundation)
local Style = require(parent2.Style)
local GetTextSize = Style.GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local useStyle = UIBlox.Core.Style.useStyle
local HeaderBar = UIBlox.App.Bar.HeaderBar
local UtilityActionIcon = UIBlox.App.Button.UtilityActionIcon

local SharedFlags = require(parent2.SharedFlags)

local FFlagEnableConsoleRobloxLogo = SharedFlags.FFlagEnableConsoleRobloxLogo
local defineFastFlag = game:DefineFastFlag("AppHeaderBarUseSizeFull", false)
local FFlagEnableClassicThemeHeaderBackground = SharedFlags.FFlagEnableClassicThemeHeaderBackground
local AppHeaderBarClassicThemeBackground

if FFlagEnableClassicThemeHeaderBackground then
	AppHeaderBarClassicThemeBackground = require(script.Parent.AppHeaderBarClassicThemeBackground)
else
	AppHeaderBarClassicThemeBackground = nil
end

local useClassicThemeHeaderBackgroundConfig

if FFlagEnableClassicThemeHeaderBackground then
	useClassicThemeHeaderBackgroundConfig = require(script.Parent.Parent.Hooks.useClassicThemeHeaderBackgroundConfig)
else
	useClassicThemeHeaderBackgroundConfig = nil
end

require(parent.Types)

local v = {
	automaticHeight = false,
	hasDivider = false,
	onMedia = false,
	isTitleCentered = false,
	enableHeaderImageBackground = not FFlagEnableClassicThemeHeaderBackground and nil,
	utilitiesGap = UDim.new(0, 0)
}

local function BarTitle(props)
	local tokens = useStyle().Tokens

	local layoutOrder = props.layoutOrder
	local title = props.title
	local titleFont = props.titleFont or tokens.Typography.HeadingLarge
	local v2

	if props.onMedia then
		v2 = tokens.Color.Extended.White.White_100
	else
		v2 = tokens.Color.Content.Emphasis
	end

	local size = React.useMemo(function()
		local vector2 = Vector2.new(1e999, 1e999)
		local textSize = GetTextSize(title, titleFont.FontSize, titleFont.Font, vector2, {
			addTemporaryPadding = false
		})

		return UDim2.fromOffset(textSize.X + 2, textSize.Y + tokens.Size.Size_50 * 2)
	end, { title, titleFont.FontSize, titleFont.Font, tokens })

	return React.createElement("TextLabel", {
		LayoutOrder = layoutOrder,
		Size = size,
		BackgroundTransparency = 1,
		Text = title,
		FontFace = normalizeFontFace(titleFont.Font),
		TextSize = titleFont.FontSize,
		LineHeight = titleFont.LineHeight,
		TextColor3 = v2.Color3,
		TextTransparency = v2.Transparency,
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

	return React.useCallback(function(p)
		local createElement = React.createElement
		local groupTransparency

		if groupTransparencyLeft then
			groupTransparency = groupTransparencyLeft.transparency
		end

		local ref

		if groupTransparencyLeft then
			ref = groupTransparencyLeft.guiObjectRef
		end

		local v2 = {
			BackgroundTransparency = 1,
			GroupTransparency = groupTransparency,
			ref = ref,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.XY
		}
		local v3 = {
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			Navigation = 0,
			Title = 0
		}
		local navigation

		if renderNavigation then
			navigation = renderNavigation({ layoutOrder = 1 })
		end

		v3.Navigation = navigation
		local title2

		if title and not isTitleCentered then
			local createElement2 = React.createElement
			local v4

			if p then
				v4 = p.children
			end

			title2 = createElement2(
				BarTitle,
				{ layoutOrder = 2, title = title, titleFont = titleFontStyle, onMedia = onMedia },
				v4
			)
		end

		v3.Title = title2
		return createElement(groupTransparencyLeft and "CanvasGroup" or "Frame", v2, v3)
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
	local groupTransparencyCenter

	if FFlagEnableConsoleRobloxLogo then
		groupTransparencyCenter = joined.groupTransparencyCenter
	else
		groupTransparencyCenter = nil
	end

	return React.useCallback(function()
		if renderCenter then
			if not FFlagEnableConsoleRobloxLogo then
				return renderCenter()
			end

			local createElement = React.createElement
			local groupTransparency

			if groupTransparencyCenter then
				groupTransparency = groupTransparencyCenter.transparency
			end

			local ref

			if groupTransparencyCenter then
				ref = groupTransparencyCenter.guiObjectRef
			end

			local size

			if defineFastFlag then
				size = UDim2.fromScale(1, 1)
			end

			local automaticSize

			if not defineFastFlag then
				automaticSize = Enum.AutomaticSize.XY
			end

			return createElement(groupTransparencyCenter and "CanvasGroup" or "Frame", {
				BackgroundTransparency = 1,
				GroupTransparency = groupTransparency,
				ref = ref,
				BorderSizePixel = 0,
				Size = size,
				AutomaticSize = automaticSize
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
	end, { renderCenter, title, titleFontStyle, isTitleCentered, onMedia, groupTransparencyCenter })
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
		local v2 = {
			Size = UDim2.fromScale(0, 1),
			BackgroundTransparency = 1,
			GroupTransparency = 0,
			ref = 0,
			BorderSizePixel = 0,
			AutomaticSize = 0
		}
		local groupTransparency

		if groupTransparencyRight then
			groupTransparency = groupTransparencyRight.transparency
		end

		v2.GroupTransparency = groupTransparency
		local ref

		if groupTransparencyRight then
			ref = groupTransparencyRight.guiObjectRef
		end

		v2.ref = ref

		v2.AutomaticSize = Enum.AutomaticSize.X
		local v3 = {
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
		local userInfo

		if renderUserInfo then
			userInfo = renderUserInfo({ layoutOrder = 1, itemsGap = utilitiesGap })
		end

		v3.UserInfo = userInfo
		local avatar

		if avatarActionIcon then
			avatar = React.createElement(UtilityActionIcon, {
				layoutOrder = 2,
				icon = avatarActionIcon.icon,
				iconColor = {},
				onActivated = avatarActionIcon.onActivated
			})
		end

		v3.Avatar = avatar
		local searchIcon

		if searchActionIcon then
			searchIcon = React.createElement(UtilityActionIcon, {
				layoutOrder = 3,
				icon = searchActionIcon.icon,
				onActivated = searchActionIcon.onActivated
			})
		end

		v3.SearchIcon = searchIcon
		local utilities

		if renderUtilities then
			utilities = renderUtilities({ layoutOrder = 4, itemsGap = utilitiesGap })
		end

		v3.Utilities = utilities
		return createElement(groupTransparencyRight and "CanvasGroup" or "Frame", v2, v3)
	end, {
		renderUserInfo,
		avatarActionIcon,
		searchActionIcon,
		renderUtilities,
		utilitiesGap,
		groupTransparencyRight
	})
end

local function shouldRenderRight(joined): boolean -- 1 equivalent call inferred from this helper
	local renderUserInfo = joined.renderUserInfo
	local avatarActionIcon = joined.avatarActionIcon
	local searchActionIcon = joined.searchActionIcon
	local renderUtilities = joined.renderUtilities

	if renderUserInfo or avatarActionIcon or searchActionIcon or renderUtilities then
		return true
	end

	return false
end

local function AppHeaderBarComponent(p)
	local joined = Cryo.Dictionary.join(v, p)

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

	local renderLeft = useRenderLeft(joined)
	local renderCenter = useRenderCenter(joined)
	local renderRight = useRenderRight(joined)
	local v2 = shouldRenderRight(joined) -- inferred equivalent call
	local config

	if FFlagEnableClassicThemeHeaderBackground then
		config = useClassicThemeHeaderBackgroundConfig()
	end

	local v3 = FFlagEnableClassicThemeHeaderBackground and joined.enableHeaderImageBackground and config ~= nil
	local ref, ref2

	if FFlagEnableClassicThemeHeaderBackground then
		ref = React.useRef(nil)
		local guiObjectRef

		if groupTransparency then
			guiObjectRef = groupTransparency.guiObjectRef
		else
			guiObjectRef = nil
		end

		ref2 = React.useCallback(function(current)
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
	local groupTransparency2

	if groupTransparency then
		groupTransparency2 = groupTransparency.transparency
	end

	tagsByTag.GroupTransparency = groupTransparency2

	if not FFlagEnableClassicThemeHeaderBackground then
		if groupTransparency then
			ref2 = groupTransparency.guiObjectRef
		else
			ref2 = nil
		end
	end

	tagsByTag.ref = ref2

	tagsByTag.AutomaticSize = Enum.AutomaticSize.Y
	tagsByTag[React.Tag] = tag
	local headerImageBackground

	if v3 then
		headerImageBackground = React.createElement(AppHeaderBarClassicThemeBackground, {
			config = config,
			containerRef = ref
		})
	end

	local createElement2 = React.createElement

	if not v2 then
		renderRight = nil
	end

	return createElement(groupTransparency and "CanvasGroup" or "Frame", tagsByTag, {
		HeaderImageBackground = headerImageBackground,
		Bar = createElement2(HeaderBar, {
			barHeight = barHeight,
			renderLeft = renderLeft,
			renderCenter = renderCenter,
			renderRight = renderRight,
			onHeaderActivated = onHeaderActivated,
			backgroundStyle = backgroundStyle,
			backgroundTransparency = v3 and 1 or nil,
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
