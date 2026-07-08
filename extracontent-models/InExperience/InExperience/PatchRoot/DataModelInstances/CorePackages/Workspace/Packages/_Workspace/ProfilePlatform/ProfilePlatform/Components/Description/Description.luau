local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local TextService = game:GetService("TextService")
local FFlagProfilePlatformNewProfileHeader = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformNewProfileHeader
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useDynamicSizeMargin = require(ProfilePlatform.Hooks.useDynamicSizeMargin)
local useAboutSectionHeight = require(ProfilePlatform.Hooks.useAboutSectionHeight)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Enums = require(ProfilePlatform.Common.Enums)
local React = require(ProfilePlatformParent.React)
local UIBlox = require(ProfilePlatformParent.UIBlox)
local Foundation = require(ProfilePlatformParent.Foundation)
local Localization = require(ProfilePlatformParent.Localization)
local RobloxAppHooks = require(ProfilePlatformParent.RobloxAppHooks)
local Responsive = require(ProfilePlatformParent.Responsive)
local useScreenSize = RobloxAppHooks.useScreenSize
local useIsSpatial = Responsive.useIsSpatial
local usePreferredInput = Responsive.usePreferredInput
local useLocalization = Localization.Hooks.useLocalization
local HorizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin
local ExpandableTextArea = UIBlox.App.Text.ExpandableTextArea
local useTokens = Foundation.Hooks.useTokens
local FoundationText = Foundation.Text
local View = Foundation.View

local function Description(t1: {[any]: any}) -- line: 38
	-- upvalues: useTokens (copy), useScreenSize (copy), useDynamicSizeMargin (copy), useProfileWrapperContext (copy), React (copy), useLocalization (copy), TextKeys (copy), useIsSpatial (copy), usePreferredInput (copy), Responsive (copy), useAboutSectionHeight (copy), FFlagProfilePlatformNewProfileHeader (copy), TextService (copy), Enums (copy), View (copy), FoundationText (copy), HorizontalPageMargin (copy), ExpandableTextArea (copy)
	local v27 = useTokens()
	local v28 = useScreenSize()
	local v29, v30 = useDynamicSizeMargin()
	local v31 = useProfileWrapperContext()
	local BodyMedium = v27.Typography.BodyMedium
	local v33, v34 = React.useState(v28.X)
	local profileType = v31.profileType
	local v36 = useLocalization({
		moreText = TextKeys.More,
		noBioYet = TextKeys.NoBioYet
	})
	local description = t1.description
	local v38 = useIsSpatial()
	local v39 = usePreferredInput() == Responsive.Input.Directional
	local v40 = v38 or v39
	local v41, v42 = useAboutSectionHeight(description, v33, v29)
	local v43 = if not FFlagProfilePlatformNewProfileHeader then React.useMemo(function() -- line: 58
		-- upvalues: description (ref), TextService (copy), BodyMedium (copy), v40 (copy)
		local v46 = string.gsub(description or "", "[\r\n]+", " ")

		return TextService:GetTextSize(v46, BodyMedium.FontSize, BodyMedium.Font, Vector2.new(1e999, 1e999)).Y * (not v40 and 2 or 2.6)
	end, {
		description,
		BodyMedium.FontSize,
		BodyMedium.Font,
		v40
	}) else v42
	local v44 = if not FFlagProfilePlatformNewProfileHeader then nil else v42 < v41
	local v45 = React.useMemo(function() -- line: 74
		-- upvalues: v33 (copy), v29 (copy), React (copy), v43 (copy)
		local v47 = v33 - v29 * 2

		return (React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(v47, v43)
		}))
	end, {
		v43,
		v33,
		v29
	})

	if description == nil or description == "" then
		if FFlagProfilePlatformNewProfileHeader then
			return nil
		end

		description = v36.noBioYet
	end

	if profileType == Enums.ProfileTypes.User or profileType == Enums.ProfileTypes.Contact then
		return React.createElement("Frame", {
			LayoutOrder = t1.layoutOrder,
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			[React.Change.AbsoluteSize] = function(p1) -- line: 95
				-- upvalues: v30 (copy), v34 (copy)
				v30(p1)
				v34(p1.AbsoluteSize.X)
			end
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v29),
				PaddingRight = UDim.new(0, v29)
			}),
			DescriptionContainer = React.createElement(View, {
				tag = "size-full col gap-xsmall"
			}, {
				Description = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "auto-xy text-wrap text-align-x-left text-align-y-top text-truncate-split",
					Text = description,
					fontStyle = BodyMedium
				}, {
					UISizeConstraint = v45
				}),
				MoreButton = if not FFlagProfilePlatformNewProfileHeader then React.createElement(FoundationText, {
					LayoutOrder = 2,
					RichText = true,
					tag = "auto-xy text-wrap text-align-x-left text-align-y-top text-truncate-split",
					Text = `<u>{ v36.moreText }</u>`,
					fontStyle = v27.Typography.TitleMedium,
					onActivated = t1.onActivateMoreButton
				}) else if not v44 then nil else React.createElement(FoundationText, {
					LayoutOrder = 2,
					RichText = true,
					tag = "auto-xy text-wrap text-align-x-left text-align-y-top text-truncate-split",
					Text = `<u>{ v36.moreText }</u>`,
					fontStyle = v27.Typography.TitleMedium,
					onActivated = t1.onActivateMoreButton
				})
			})
		})
	end

	return React.createElement(HorizontalPageMargin, {
		backgroundTransparency = 1,
		useAutomaticSizing = true,
		layoutOrder = t1.layoutOrder,
		size = UDim2.new(1, 0, 0, 0)
	}, {
		Description = React.createElement(ExpandableTextArea, {
			compactNumberOfLines = 3,
			Text = t1.description,
			padding = Vector2.new(0, 0)
		})
	})
end

return Description
