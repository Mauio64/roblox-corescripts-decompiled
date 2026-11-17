local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useDynamicSizeMargin = require(ProfilePlatform.Hooks.useDynamicSizeMargin)
local useAboutSectionHeight = require(ProfilePlatform.Hooks.useAboutSectionHeight)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Enums = require(ProfilePlatform.Common.Enums)

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local Localization = require(parent.Localization)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local Responsive = require(parent.Responsive)

local useScreenSize = RobloxAppHooks.useScreenSize
local useIsSpatial = Responsive.useIsSpatial
local usePreferredInput = Responsive.usePreferredInput
local useLocalization = Localization.Hooks.useLocalization
local HorizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin
local ExpandableTextArea = UIBlox.App.Text.ExpandableTextArea
local useTokens = Foundation.Hooks.useTokens
local Text = Foundation.Text
local View = Foundation.View

local function Description(props)
	local v = useTokens()
	local v2 = useScreenSize()
	local v3, v4 = useDynamicSizeMargin()
	local v5 = useProfileWrapperContext()
	local bodyMedium = v.Typography.BodyMedium
	local state, setState = React.useState(v2.X)
	local profileType = v5.profileType

	local v6 = useLocalization({ moreText = TextKeys.More, noBioYet = TextKeys.NoBioYet })
	local text = props.description

	local v7 = useIsSpatial()
	local v8 = usePreferredInput() == Responsive.Input.Directional
	local v9 = v7 or v8

	local v10, v11 = useAboutSectionHeight(text, state, v3)
	local v12

	if FFlagProfilePlatformNewProfileHeader then
		v12 = v11
	else
		v12 = React.useMemo(function()
			return GetTextSize(
				string.gsub(text or "", "[\r\n]+", " "),
				bodyMedium.FontSize,
				bodyMedium.Font,
				Vector2.new(1e999, 1e999),
				{ addTemporaryPadding = false }
			).Y * (v9 and 2.6 or 2)
		end, { text, bodyMedium.FontSize, bodyMedium.Font, v9 })
	end

	local v13

	if FFlagProfilePlatformNewProfileHeader then
		v13 = v11 < v10
	end

	local uiSizeConstraint = React.useMemo(function()
		local v14 = state - v3 * 2
		return (React.createElement("UISizeConstraint", { MaxSize = Vector2.new(v14, v12) }))
	end, { v12, state, v3 })

	if text == nil or text == "" then
		if FFlagProfilePlatformNewProfileHeader then
			return nil
		end

		text = v6.noBioYet
	end

	if profileType ~= Enums.ProfileTypes.User and profileType ~= Enums.ProfileTypes.Contact then
		return React.createElement(
			HorizontalPageMargin,
			{
				layoutOrder = props.layoutOrder,
				backgroundTransparency = 1,
				size = UDim2.new(1, 0, 0, 0),
				useAutomaticSizing = true
			},
			{
				Description = React.createElement(ExpandableTextArea, {
					Text = props.description,
					compactNumberOfLines = 3,
					padding = Vector2.new(0, 0)
				})
			}
		)
	end

	local createElement = React.createElement
	local v14 = {
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		[React.Change.AbsoluteSize] = function(p)
			v4(p)
			setState(p.AbsoluteSize.X)
		end
	}
	local v15 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v3),
			PaddingRight = UDim.new(0, v3)
		}),
		DescriptionContainer = 0
	}

	local createElement2 = React.createElement

	local v16 = {
		Description = React.createElement(
			Text,
			{
				Text = text,
				LayoutOrder = 1,
				fontStyle = bodyMedium,
				tag = "auto-xy text-wrap text-align-x-left text-align-y-top text-truncate-split"
			},
			{ UISizeConstraint = uiSizeConstraint }
		),
		MoreButton = 0
	}
	local moreButton

	if FFlagProfilePlatformNewProfileHeader then
		if v13 then
			moreButton = React.createElement(Text, {
				Text = `<u>{v6.moreText}</u>`,
				LayoutOrder = 2,
				fontStyle = v.Typography.TitleMedium,
				RichText = true,
				tag = "auto-xy text-wrap text-align-x-left text-align-y-top text-truncate-split",
				onActivated = props.onActivateMoreButton
			})
		end
	else
		moreButton = React.createElement(Text, {
			Text = `<u>{v6.moreText}</u>`,
			LayoutOrder = 2,
			fontStyle = v.Typography.TitleMedium,
			RichText = true,
			tag = "auto-xy text-wrap text-align-x-left text-align-y-top text-truncate-split",
			onActivated = props.onActivateMoreButton
		})
	end

	v16.MoreButton = moreButton
	v15.DescriptionContainer = createElement2(View, { tag = "size-full col gap-xsmall" }, v16)
	return createElement("Frame", v14, v15)
end

return Description
